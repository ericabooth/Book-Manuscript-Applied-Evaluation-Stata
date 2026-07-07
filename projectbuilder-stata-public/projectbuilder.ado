*! version 1.0.0  06jul2026  Eric A. Booth, Sr Researcher, Texas 2036
*! projectbuilder -- scaffold a data-analysis project folder with a
*!                   numbered do-file pipeline.
*! Self-contained: every scaffold file is written by this program;
*! no template folder is required.
*! Companion package to "Applied Program Evaluation Using Stata".
*! Cross-OS: uses Stata's mkdir and file commands; no shell calls.
*! Support: eric.a.booth@gmail.com

program define projectbuilder, rclass
    version 16
    syntax anything(name=projspec id="source[/subsource]") [, ///
        DEScription(string)  ///
        URL(string)          ///
        PATH(string)         ///
        TOPIC(string)        ///
        PUBlicfacing(string) ///
        TIMEline(string)     ///
        OTHERnotes(string)   ///
        OUTcomes(string)     ///
        OVer(string)         ///
        DESCsave]

    * ---- validate publicfacing ------------------------------------------
    if !inlist(lower(`"`publicfacing'"'), "", "yes", "no", "unsure") {
        di as err `"projectbuilder: publicfacing() must be yes, no, unsure, or empty (got "`publicfacing'")"'
        exit 198
    }
    local publicfacing = lower(`"`publicfacing'"')

    * ---- cap outcomes / over at 10 each ---------------------------------
    local outcomes_trim
    local n = 0
    foreach w of local outcomes {
        local ++n
        if `n' > 10 continue
        local outcomes_trim `outcomes_trim' `w'
    }
    if `n' > 10 di as txt "projectbuilder: outcomes() had `n' items; using first 10."
    local outcomes : copy local outcomes_trim

    local over_trim
    local n = 0
    foreach w of local over {
        local ++n
        if `n' > 10 continue
        local over_trim `over_trim' `w'
    }
    if `n' > 10 di as txt "projectbuilder: over() had `n' items; using first 10."
    local over : copy local over_trim

    * ---- base path: path() overrides the current working directory ------
    local base `"`c(pwd)'"'
    if `"`path'"' != "" local base `"`path'"'
    if inlist(substr(`"`base'"', -1, 1), "/", "\") {
        local base = substr(`"`base'"', 1, strlen(`"`base'"') - 1)
    }

    * ---- parse source[/subsource] ----------------------------------------
    local projspec = subinstr(`"`projspec'"', char(34), "", .)
    local projspec = strtrim(`"`projspec'"')
    if `"`projspec'"' == "" {
        di as err "projectbuilder: project name is empty"
        exit 198
    }
    local pos = strpos(`"`projspec'"', "/")
    if `pos' > 0 {
        local parent = substr(`"`projspec'"', 1, `pos' - 1)
        local leaf   = substr(`"`projspec'"', `pos' + 1, .)
        local proj_label = subinstr(`"`projspec'"', "/", "_", .)
    }
    else {
        local parent ""
        local leaf   `"`projspec'"'
        local proj_label `"`leaf'"'
    }

    * ---- validate names (no path tricks) ---------------------------------
    if strpos(`"`projspec'"', "..") | strpos(`"`projspec'"', "\") {
        di as err `"projectbuilder: "`projspec'" is not a valid project name (no ".." or "\" allowed)"'
        exit 198
    }
    if strpos(`"`leaf'"', "/") {
        di as err `"projectbuilder: at most one level of nesting -- use source or source/subsource"'
        exit 198
    }
    if `"`leaf'"' == "" | (`pos' > 0 & `"`parent'"' == "") {
        di as err "projectbuilder: source and subsource names cannot be empty"
        exit 198
    }

    if `"`parent'"' != "" local target `"`base'/`parent'/`leaf'"'
    else                  local target `"`base'/`leaf'"'

    * ---- refuse to clobber an existing target ----------------------------
    capture confirm file `"`target'/."'
    if !_rc {
        di as err `"projectbuilder: target already exists -- `target'"'
        di as err  "                projectbuilder never overwrites an existing project."
        di as err  "                Rename or move that folder manually, then re-run."
        exit 602
    }

    * ---- build the folder tree (Stata's mkdir is cross-OS) ---------------
    capture mkdir `"`base'"'
    capture confirm file `"`base'/."'
    if _rc {
        di as err `"projectbuilder: base path not found and could not be created -- `base'"'
        di as err  "                Create its parent directories first, or check path()."
        exit 601
    }
    if `"`parent'"' != "" capture mkdir `"`base'/`parent'"'
    mkdir `"`target'"'
    foreach sub in raw clean code output figures {
        mkdir `"`target'/`sub'"'
    }
    di as txt `"projectbuilder: scaffolding `target'"'

    * ---- values stamped into the scaffold files --------------------------
    local today : di %tdCCYY-NN-DD daily(`"`c(current_date)'"', "DMY")
    local author `"`c(username)'"'
    local descfull `"`description'"'
    if `"`descfull'"' == "" local descfull "(add a one-line description of the project here)"
    local url_readme `"`url'"'
    if `"`url_readme'"' == "" local url_readme "(none recorded)"
    foreach m in topic publicfacing timeline othernotes {
        local `m'_readme `"``m''"'
        if `"``m'_readme'"' == "" local `m'_readme "(not recorded)"
    }

    * In the projectbuilder_wl helper, ~D becomes a literal $ and ~B a
    * literal backtick in the written file.  Values such as `target' and
    * `descfull' expand here, at scaffold time -- which is the point.

    * ---- code/00_control.do ----------------------------------------------
    tempname fh
    file open `fh' using `"`target'/code/00_control.do"', write text replace
    projectbuilder_wl `fh' `"*==============================================================="'
    projectbuilder_wl `fh' `"* 00_control.do -- `proj_label'"'
    projectbuilder_wl `fh' `"* Created `today' by `author' (scaffolded by projectbuilder)"'
    projectbuilder_wl `fh' `"* The control file: every path in one place."'
    projectbuilder_wl `fh' `"*==============================================================="'
    projectbuilder_wl `fh' `""'
    projectbuilder_wl `fh' `"clear all"'
    projectbuilder_wl `fh' `"version `c(stata_version)'      // pin the language version"'
    projectbuilder_wl `fh' `"set more off"'
    projectbuilder_wl `fh' `"set varabbrev off    // abbreviations hide bugs"'
    projectbuilder_wl `fh' `""'
    projectbuilder_wl `fh' `"*---------------------------------------------------------------"'
    projectbuilder_wl `fh' `"* THE ONE PLACE YOU EDIT: the project root."'
    projectbuilder_wl `fh' `"* projectbuilder stamped the absolute path it scaffolded."'
    projectbuilder_wl `fh' `"* If this project ever moves -- new machine, new teammate,"'
    projectbuilder_wl `fh' `"* new drive -- edit ONLY the global root line below."'
    projectbuilder_wl `fh' `"*---------------------------------------------------------------"'
    projectbuilder_wl `fh' `"global root "`target'""'
    projectbuilder_wl `fh' `""'
    projectbuilder_wl `fh' `"* Derived from root; you never touch these."'
    projectbuilder_wl `fh' `"global raw     "~Droot/raw"       // untouched downloads"'
    projectbuilder_wl `fh' `"global clean   "~Droot/clean"     // analysis-ready data"'
    projectbuilder_wl `fh' `"global code    "~Droot/code"      // the do-files"'
    projectbuilder_wl `fh' `"global output  "~Droot/output"    // logs and tables"'
    projectbuilder_wl `fh' `"global figures "~Droot/figures"   // exported graphs"'
    projectbuilder_wl `fh' `"foreach f in raw clean output figures {"'
    projectbuilder_wl `fh' `"    capture mkdir "~D{~Bf'}"      // safe to rerun"'
    projectbuilder_wl `fh' `"}"'
    projectbuilder_wl `fh' `""'
    projectbuilder_wl `fh' `"* set scheme stcolor    // uncomment to pin one graphics style"'
    projectbuilder_wl `fh' `""'
    projectbuilder_wl `fh' `"*---------------------------------------------------------------"'
    projectbuilder_wl `fh' `"* Optional: rebuild the whole pipeline, in order."'
    projectbuilder_wl `fh' `"*---------------------------------------------------------------"'
    projectbuilder_wl `fh' `"local run_all 0    // flip to 1 to rebuild everything"'
    projectbuilder_wl `fh' `"if ~Brun_all' {"'
    projectbuilder_wl `fh' `"    do "~Dcode/100_ingest.do""'
    projectbuilder_wl `fh' `"    do "~Dcode/200_clean.do""'
    projectbuilder_wl `fh' `"    do "~Dcode/300_analyze.do""'
    projectbuilder_wl `fh' `"    do "~Dcode/400_visualize.do""'
    projectbuilder_wl `fh' `"    do "~Dcode/500_report.do""'
    projectbuilder_wl `fh' `"}"'
    file close `fh'

    * ---- code/100_ingest.do -----------------------------------------------
    file open `fh' using `"`target'/code/100_ingest.do"', write text replace
    projectbuilder_wl `fh' `"*==============================================================="'
    projectbuilder_wl `fh' `"* 100_ingest.do -- `proj_label'"'
    projectbuilder_wl `fh' `"* Single job: fetch or copy the raw source files into ~Draw."'
    projectbuilder_wl `fh' `"* Raw files are write-once: downloaded, never edited by hand."'
    projectbuilder_wl `fh' `"* Numbered by hundreds on purpose -- a new step slots in as"'
    projectbuilder_wl `fh' `"* 150_ without renaming the rest."'
    projectbuilder_wl `fh' `"*==============================================================="'
    projectbuilder_wl `fh' `"* Globals (~Droot, ~Draw, ~Dclean, ~Doutput, ~Dfigures) come"'
    projectbuilder_wl `fh' `"* from 00_control.do -- run that first."'
    projectbuilder_wl `fh' `""'
    projectbuilder_wl `fh' `"* Suggested per-run log (dated, so runs never overwrite):"'
    projectbuilder_wl `fh' `"* log using "~Doutput/100_ingest_~DS_DATE.log", replace text"'
    projectbuilder_wl `fh' `""'
    if `"`url'"' != "" {
        projectbuilder_wl `fh' `"* Download target (recorded from the url() option):"'
        projectbuilder_wl `fh' `"*   `url'"'
        projectbuilder_wl `fh' `"* Fetch it with Stata's -copy- (works for http/https URLs):"'
        projectbuilder_wl `fh' `"* copy "`url'" "~Draw/rawfile.ext", replace"'
    }
    else {
        projectbuilder_wl `fh' `"* No source URL was recorded at scaffold time."'
        projectbuilder_wl `fh' `"* If the source lives at a URL, note it here and fetch with -copy-:"'
        projectbuilder_wl `fh' `"* copy "https://example.com/data.csv" "~Draw/data.csv", replace"'
        projectbuilder_wl `fh' `"* If the files arrive by hand (email, thumb drive), drop them"'
        projectbuilder_wl `fh' `"* into ~Draw and record who sent them and when in README.md."'
    }
    projectbuilder_wl `fh' `""'
    projectbuilder_wl `fh' `"* capture log close"'
    file close `fh'

    * ---- code/200_clean.do --------------------------------------------------
    file open `fh' using `"`target'/code/200_clean.do"', write text replace
    projectbuilder_wl `fh' `"*==============================================================="'
    projectbuilder_wl `fh' `"* 200_clean.do -- `proj_label'"'
    projectbuilder_wl `fh' `"* Single job: read from ~Draw, write analysis-ready .dta files"'
    projectbuilder_wl `fh' `"* to ~Dclean.  Every transformation starts from the untouched"'
    projectbuilder_wl `fh' `"* raw files, so a cleaning bug is one rerun away from repair."'
    projectbuilder_wl `fh' `"*==============================================================="'
    projectbuilder_wl `fh' `"* Globals come from 00_control.do -- run that first."'
    projectbuilder_wl `fh' `""'
    projectbuilder_wl `fh' `"* Suggested per-run log (dated, so runs never overwrite):"'
    projectbuilder_wl `fh' `"* log using "~Doutput/200_clean_~DS_DATE.log", replace text"'
    projectbuilder_wl `fh' `""'
    projectbuilder_wl `fh' `"* Typical shape of this step:"'
    projectbuilder_wl `fh' `"* import delimited "~Draw/data.csv", clear varnames(1)"'
    projectbuilder_wl `fh' `"* ... rename, destring, label, check ..."'
    projectbuilder_wl `fh' `"* compress"'
    projectbuilder_wl `fh' `"* save "~Dclean/data.dta", replace"'
    if "`descsave'" != "" {
        projectbuilder_wl `fh' `""'
        projectbuilder_wl `fh' `"* Codebook export via -descsave- (install once: ssc install descsave):"'
        projectbuilder_wl `fh' `"* descsave, list(name type format vallab varlab) ///"'
        projectbuilder_wl `fh' `"*     saving("~Doutput/codebook.dta", replace)"'
    }
    projectbuilder_wl `fh' `""'
    projectbuilder_wl `fh' `"* capture log close"'
    file close `fh'

    * ---- code/300_analyze.do ------------------------------------------------
    file open `fh' using `"`target'/code/300_analyze.do"', write text replace
    projectbuilder_wl `fh' `"*==============================================================="'
    projectbuilder_wl `fh' `"* 300_analyze.do -- `proj_label'"'
    projectbuilder_wl `fh' `"* Single job: read from ~Dclean, run the analysis, write tables"'
    projectbuilder_wl `fh' `"* to ~Doutput.  No cleaning here -- if a variable needs fixing,"'
    projectbuilder_wl `fh' `"* fix it in 200_clean.do and rerun."'
    projectbuilder_wl `fh' `"*==============================================================="'
    projectbuilder_wl `fh' `"* Globals come from 00_control.do -- run that first."'
    projectbuilder_wl `fh' `""'
    projectbuilder_wl `fh' `"* Suggested per-run log (dated, so runs never overwrite):"'
    projectbuilder_wl `fh' `"* log using "~Doutput/300_analyze_~DS_DATE.log", replace text"'
    projectbuilder_wl `fh' `""'
    projectbuilder_wl `fh' `"* Suggested analysis locals (recorded from the outcomes() and"'
    projectbuilder_wl `fh' `"* over() options at scaffold time; edit freely):"'
    projectbuilder_wl `fh' `"local outcomes "`outcomes'"   // outcome variables to summarize"'
    projectbuilder_wl `fh' `"local over     "`over'"   // by-variables for breakdowns"'
    projectbuilder_wl `fh' `""'
    projectbuilder_wl `fh' `"* Typical shape of this step:"'
    projectbuilder_wl `fh' `"* use "~Dclean/data.dta", clear"'
    projectbuilder_wl `fh' `"* foreach y of local outcomes {"'
    projectbuilder_wl `fh' `"*     foreach g of local over {"'
    projectbuilder_wl `fh' `"*         table ~Bg', statistic(mean ~By') statistic(count ~By')"'
    projectbuilder_wl `fh' `"*     }"'
    projectbuilder_wl `fh' `"* }"'
    projectbuilder_wl `fh' `""'
    projectbuilder_wl `fh' `"* capture log close"'
    file close `fh'

    * ---- code/400_visualize.do ----------------------------------------------
    file open `fh' using `"`target'/code/400_visualize.do"', write text replace
    projectbuilder_wl `fh' `"*==============================================================="'
    projectbuilder_wl `fh' `"* 400_visualize.do -- `proj_label'"'
    projectbuilder_wl `fh' `"* Single job: read from ~Dclean (or ~Doutput), export graphs"'
    projectbuilder_wl `fh' `"* to ~Dfigures.  Every figure the report uses is rebuilt here."'
    projectbuilder_wl `fh' `"*==============================================================="'
    projectbuilder_wl `fh' `"* Globals come from 00_control.do -- run that first."'
    projectbuilder_wl `fh' `""'
    projectbuilder_wl `fh' `"* Suggested per-run log (dated, so runs never overwrite):"'
    projectbuilder_wl `fh' `"* log using "~Doutput/400_visualize_~DS_DATE.log", replace text"'
    projectbuilder_wl `fh' `""'
    projectbuilder_wl `fh' `"* Typical shape of this step:"'
    projectbuilder_wl `fh' `"* use "~Dclean/data.dta", clear"'
    projectbuilder_wl `fh' `"* graph ..."'
    projectbuilder_wl `fh' `"* graph export "~Dfigures/fig01_descriptives.png", replace width(2400)"'
    projectbuilder_wl `fh' `""'
    projectbuilder_wl `fh' `"* capture log close"'
    file close `fh'

    * ---- code/500_report.do ---------------------------------------------------
    file open `fh' using `"`target'/code/500_report.do"', write text replace
    projectbuilder_wl `fh' `"*==============================================================="'
    projectbuilder_wl `fh' `"* 500_report.do -- `proj_label'"'
    projectbuilder_wl `fh' `"* Single job: assemble the final deliverable -- the tables and"'
    projectbuilder_wl `fh' `"* figures built upstream -- into the report, memo, or slide"'
    projectbuilder_wl `fh' `"* inputs, written to ~Doutput."'
    projectbuilder_wl `fh' `"*==============================================================="'
    projectbuilder_wl `fh' `"* Globals come from 00_control.do -- run that first."'
    projectbuilder_wl `fh' `""'
    projectbuilder_wl `fh' `"* Suggested per-run log (dated, so runs never overwrite):"'
    projectbuilder_wl `fh' `"* log using "~Doutput/500_report_~DS_DATE.log", replace text"'
    projectbuilder_wl `fh' `""'
    projectbuilder_wl `fh' `"* Typical shape of this step:"'
    projectbuilder_wl `fh' `"* putdocx / putpdf / collect export ... writing to "~Doutput/""'
    projectbuilder_wl `fh' `""'
    projectbuilder_wl `fh' `"* capture log close"'
    file close `fh'

    * ---- README.md at the project root ---------------------------------------
    file open `fh' using `"`target'/README.md"', write text replace
    projectbuilder_wl `fh' `"# `proj_label'"'
    projectbuilder_wl `fh' `""'
    projectbuilder_wl `fh' `"`descfull'"'
    projectbuilder_wl `fh' `""'
    projectbuilder_wl `fh' `"| Field            | Value |"'
    projectbuilder_wl `fh' `"|------------------|-------|"'
    projectbuilder_wl `fh' `"| Project          | `proj_label' |"'
    projectbuilder_wl `fh' `"| Created          | `today' |"'
    projectbuilder_wl `fh' `"| Author           | `author' |"'
    projectbuilder_wl `fh' `"| Description      | `descfull' |"'
    projectbuilder_wl `fh' `"| Source URL       | `url_readme' |"'
    projectbuilder_wl `fh' `"| Topic            | `topic_readme' |"'
    projectbuilder_wl `fh' `"| Public-facing    | `publicfacing_readme' |"'
    projectbuilder_wl `fh' `"| Refresh timeline | `timeline_readme' |"'
    projectbuilder_wl `fh' `"| Other notes      | `othernotes_readme' |"'
    projectbuilder_wl `fh' `""'
    projectbuilder_wl `fh' `"## Layout"'
    projectbuilder_wl `fh' `""'
    projectbuilder_wl `fh' `"    `leaf'/"'
    projectbuilder_wl `fh' `"    ├── raw/       untouched downloads (write-once; never edited)"'
    projectbuilder_wl `fh' `"    ├── clean/     analysis-ready .dta files"'
    projectbuilder_wl `fh' `"    ├── code/      numbered do-files; 00_control.do holds every path"'
    projectbuilder_wl `fh' `"    ├── output/    logs and tables"'
    projectbuilder_wl `fh' `"    └── figures/   exported graphs"'
    projectbuilder_wl `fh' `""'
    projectbuilder_wl `fh' `"## How to run"'
    projectbuilder_wl `fh' `""'
    projectbuilder_wl `fh' `"1. Open code/00_control.do.  The root global is stamped with this"'
    projectbuilder_wl `fh' `"   folder's absolute path; if the project moves, edit that one line."'
    projectbuilder_wl `fh' `"2. Run 00_control.do to set the path globals."'
    projectbuilder_wl `fh' `"3. Work down the numbered pipeline: 100_ingest, 200_clean,"'
    projectbuilder_wl `fh' `"   300_analyze, 400_visualize, 500_report.  The numbering is the"'
    projectbuilder_wl `fh' `"   run order; gaps are left so a 150_ step can slot in later."'
    projectbuilder_wl `fh' `"4. To rebuild everything in order, flip local run_all to 1 in"'
    projectbuilder_wl `fh' `"   00_control.do and rerun it."'
    projectbuilder_wl `fh' `""'
    projectbuilder_wl `fh' `"Scaffolded by projectbuilder on `today'."'
    file close `fh'

    * ---- summary + next steps --------------------------------------------
    di as txt _n "{hline 66}"
    di as txt "projectbuilder OK"
    di as txt `"  Project       : `proj_label'"'
    di as txt `"  Location      : `target'"'
    di as txt `"  Description   : `descfull'"'
    di as txt `"  Source URL    : `url'"'
    di as txt `"  Outcomes      : `outcomes'"'
    di as txt `"  Over          : `over'"'
    di as txt `"  Descsave      : `=cond("`descsave'" != "", "yes", "no")'"'
    di as txt `"  Topic         : `topic'"'
    di as txt `"  Public-facing : `publicfacing'"'
    di as txt `"  Timeline      : `timeline'"'
    di as txt "{hline 66}"
    di as txt _n "Next steps:"
    di as txt `"  1. do "`target'/code/00_control.do"    (sets the path globals)"'
    di as txt  "  2. Put raw files in raw/, or edit code/100_ingest.do to fetch them"
    di as txt  "  3. Work down the pipeline: 100_ingest -> 200_clean -> 300_analyze"
    di as txt  "     -> 400_visualize -> 500_report"
    di as txt  "  4. To rebuild everything, flip -local run_all- to 1 in 00_control.do"

    return local project `"`proj_label'"'
    return local path    `"`target'"'
end


* --- Helper: write one line, turning ~D into a literal $ and ~B into a
*     literal backtick.  The line is written as a string EXPRESSION, so the
*     substituted characters are never re-parsed by the macro processor --
*     which is what lets a self-contained ado emit files containing $globals
*     and `locals' without a template folder or -filefilter-.
program define projectbuilder_wl
    gettoken fh 0 : 0
    file write `fh' (subinstr(subinstr(`0', "~D", char(36), .), "~B", char(96), .)) _n
end
