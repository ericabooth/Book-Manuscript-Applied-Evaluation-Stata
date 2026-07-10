*! projectbuilder v1.1 — scaffold a new datashare (or project) folder
*! Cross-OS: uses Stata's mkdir/copy/file commands; no shell calls.
*! Author: Eric Booth, Texas 2036
*!
*! Syntax:
*!     projectbuilder Source[/Subsource] [, ///
*!         Type(datashare|project)   ///
*!         DEScription(string)       ///
*!         URL(string)               ///
*!         PATH(string)              ///
*!         NOLOGO                    ///
*!         OUTcomes(string)          ///   up to 10 outcome vars for 400 profiler
*!         OVer(string)              ///   up to 10 by-vars for 400 profiler
*!         DESCsave                  ///   export Excel codebook in 300_labels
*!         TOPIC(string)             ///   metadata: topic tag(s)
*!         PUBlicfacing(string)      ///   metadata: yes | no | unsure
*!         TIMEline(string)          ///   metadata: refresh cadence
*!         OTHERnotes(string)        ///   metadata: free-text caveats
*!         NOAUTOconvert]            ///   skip Pass 0 bulk-convert in 200
*!
*! Examples:
*!     projectbuilder TDI/TitleAgents, desc("TX title-insurance industry") ///
*!         url("https://www.tdi.texas.gov/data/index.html")                 ///
*!         outcomes("n_companies n_officers")  over("county state")         ///
*!         descsave  topic("insurance, market structure")                   ///
*!         publicfacing(yes)  timeline("monthly")

program define projectbuilder
    version 16
    syntax anything(name=projspec id="source[/subsource]") [, ///
        DEScription(string)         ///
        URL(string)                 ///
        PATH(string)                ///
        Type(string)                ///
        NOLOGO                      ///
        OUTcomes(string)            ///
        OVer(string)                ///
        DESCsave                    ///
        TOPIC(string)               ///
        PUBlicfacing(string)        ///
        TIMEline(string)            ///
        OTHERnotes(string)          ///
        NOAUTOconvert]

    * ── Type defaults to "datashare" ────────────────────────────────────────
    if "`type'" == "" local type "datashare"
    if !inlist("`type'", "datashare", "project") {
        di as err "projectbuilder: type() must be datashare or project"
        exit 198
    }
    if "`type'" == "project" {
        di as txt "projectbuilder: type(project) is not yet implemented."
        di as txt "                Use type(datashare) for now (the default)."
        di as txt "                See README_NamingConventions.txt for the project layout."
        exit 0
    }

    * ── Validate publicfacing ──────────────────────────────────────────────
    if !inlist(lower(`"`publicfacing'"'), "", "yes", "no", "unsure") {
        di as err `"projectbuilder: publicfacing() must be yes, no, unsure, or empty (got "`publicfacing'")"'
        exit 198
    }
    local publicfacing = lower(`"`publicfacing'"')

    * ── Cap outcomes / over at 10 each ─────────────────────────────────────
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

    * ── Resolve Google Drive root (re-uses ${tx2036_root} if already set) ──
    local drive `"${tx2036_root}"'
    if `"`drive'"' == "" {
        if inlist("`c(os)'", "MacOSX", "Unix") {     // Apple-Silicon batch Stata reports "Unix"
            local home "/Users/`c(username)'"
            local gd_base "`home'/Library/CloudStorage"
            local gd_folders : dir "`gd_base'" dirs "GoogleDrive-*"
            local gd_folder  : word 1 of `gd_folders'
            local gd_folder  = subinstr(`"`gd_folder'"', `"""', "", .)
            local drive `"`gd_base'/`gd_folder'/Shared drives/Data and Research Team"'
        }
        else if "`c(os)'" == "Windows" {
            local drive "G:/Shared drives/Data and Research Team"
        }
        else {
            di as err "projectbuilder: unsupported OS — only macOS and Windows are wired up."
            exit 198
        }
    }

    local codeshare `"`drive'/_codeshare"'
    local templates `"`codeshare'/_datashare_templates"'
    local base      `"`drive'/_datashare"'
    if `"`path'"' != "" local base `"`path'"'

    * ── Validate templates ─────────────────────────────────────────────────
    cap confirm file `"`templates'/000_controlfile.do"'
    if _rc {
        di as err `"projectbuilder: templates not found at `templates'"'
        di as err  "                Expected _codeshare/_datashare_templates/000_controlfile.do"
        exit 601
    }

    * ── Parse source[/subsource] ───────────────────────────────────────────
    local pos = strpos(`"`projspec'"', "/")
    if `pos' > 0 {
        local parent = substr(`"`projspec'"', 1, `pos' - 1)
        local leaf   = substr(`"`projspec'"', `pos' + 1, .)
        local target `"`base'/`parent'/`leaf'"'
        local proj_label = subinstr(`"`projspec'"', "/", "_", .)
    }
    else {
        local parent ""
        local leaf   `"`projspec'"'
        local target `"`base'/`leaf'"'
        local proj_label `"`leaf'"'
    }

    * ── Validate leaf name (no path tricks) ────────────────────────────────
    if strpos(`"`leaf'"', "..") | strpos(`"`leaf'"', "\") {
        di as err `"projectbuilder: leaf name "`leaf'" is not a valid folder name"'
        exit 198
    }

    * ── Refuse to clobber existing folders ─────────────────────────────────
    cap confirm file `"`target'/."'
    if !_rc {
        di as err `"projectbuilder: target already exists — `target'"'
        di as err  "                rename or move it manually, then re-run."
        exit 602
    }

    di as txt `"projectbuilder: scaffolding `target'"'

    * ── Build folder tree (Stata's mkdir is cross-OS) ──────────────────────
    cap mkdir `"`base'"'
    if `"`parent'"' != "" cap mkdir `"`base'/`parent'"'
    mkdir `"`target'"'
    foreach sub in 01_raw 02_cleaned 03_output _code _documentation _archive {
        mkdir `"`target'/`sub'"'
    }
    mkdir `"`target'/01_raw/_archive"'
    mkdir `"`target'/01_raw/_converted"'
    mkdir `"`target'/02_cleaned/_archive"'
    mkdir `"`target'/03_output/_archive"'
    mkdir `"`target'/_code/_archive"'
    mkdir `"`target'/_documentation/_archive"'
    mkdir `"`target'/_documentation/website"'
    mkdir `"`target'/_documentation/_source_snapshot"'

    * ── Compose tokens ─────────────────────────────────────────────────────
    local today : di %tdCCYY-NN-DD daily(`"`c(current_date)'"', "DMY")
    local DESCfull `"`description'"'
    if `"`DESCfull'"' == "" local DESCfull "(add a one-line description of the source here)"
    local descsave_flag    = cond("`descsave'"      != "", "1", "")
    local autoconvert_flag = cond("`noautoconvert'" != "", "0", "1")

    global PB_PROJECT     `"`proj_label'"'
    global PB_DATE        `"`today'"'
    global PB_AUTHOR      `"`c(username)'"'
    global PB_DESC        `"`DESCfull'"'
    global PB_URL         `"`url'"'
    global PB_PATH        `"`target'"'
    global PB_TOPIC       `"`topic'"'
    global PB_PUBLIC      `"`publicfacing'"'
    global PB_TIMELINE    `"`timeline'"'
    global PB_OTHERNOTES  `"`othernotes'"'
    global PB_OUTCOMES    `"`outcomes'"'
    global PB_OVER        `"`over'"'
    global PB_DESCSAVE    `"`descsave_flag'"'
    global PB_AUTOCONVERT `"`autoconvert_flag'"'

    * ── Copy + token-substitute each template ──────────────────────────────
    foreach f in 000_controlfile.do 050_preferences.do                       ///
                 100_data_download.do 200_data_management.do                 ///
                 300_labels.do 400_data_profiler.do 500_aggregation.do       ///
                 600_analysis.do {
        projectbuilder_subst `"`templates'/`f'"' `"`target'/_code/`f'"'
    }
    foreach f in _runall.do index.do help.do Readme.md {
        projectbuilder_subst `"`templates'/`f'"' `"`target'/_documentation/`f'"'
    }
    foreach f in OPEN_documentation.html {
        projectbuilder_subst `"`templates'/`f'"' `"`target'/`f'"'
    }

    * ── Copy Texas 2036 logo into the website folder ───────────────────────
    if "`nologo'" == "" {
        cap copy `"`codeshare'/assets/tx2036_logo.png"' `"`target'/_documentation/website/tx2036_logo.png"', replace
        if _rc {
            di as txt "projectbuilder: tx2036_logo.png not yet cached in `codeshare'/assets/."
            di as txt "                Run -projectbuilder_fetchlogo- once to cache it."
        }
    }

    * ── Clean up global tokens ─────────────────────────────────────────────
    macro drop PB_PROJECT PB_DATE PB_AUTHOR PB_DESC PB_URL PB_PATH ///
               PB_TOPIC PB_PUBLIC PB_TIMELINE PB_OTHERNOTES        ///
               PB_OUTCOMES PB_OVER PB_DESCSAVE PB_AUTOCONVERT

    di as txt _n "{hline}"
    di as txt "projectbuilder OK"
    di as txt `"  Project       : `proj_label'"'
    di as txt `"  Location      : `target'"'
    di as txt `"  Templates     : `templates'"'
    di as txt `"  Outcomes      : `outcomes'"'
    di as txt `"  Over          : `over'"'
    di as txt `"  Descsave      : `=cond("`descsave'"!="", "yes", "no")'"'
    di as txt `"  Auto-convert  : `=cond("`noautoconvert'"=="", "yes", "no")'"'
    di as txt `"  Topic         : `topic'"'
    di as txt `"  Public-facing : `publicfacing'"'
    di as txt `"  Timeline      : `timeline'"'
    di as txt _n "Next steps:"
    di as txt `"  1. cd "`target'/_code""'
    di as txt  "  2. Open 000_controlfile.do, run it, fill in any TODOs"
    di as txt  "  3. Edit 100_data_download.do with the URLs you need to fetch"
    di as txt `"  4. do "${docs}/_runall.do"  — to build the website"'
end


* ─── Helper: copy template to destination with <TOKEN> substitution ─────
*   Uses -filefilter- (binary find/replace) so template content with bare
*   backticks (Markdown code spans like `_raw/`) or stray apostrophes can't
*   confuse Stata's compound-quote parser the way a line-by-line approach
*   does.  Alternates between two tempfiles to chain the 13 substitutions.
program define projectbuilder_subst
    args src dst

    tempfile t1 t2

    filefilter `"`src'"' `"`t1'"', from("<PROJECT>")      to("${PB_PROJECT}")    replace
    filefilter `"`t1'"'  `"`t2'"', from("<DATE>")         to("${PB_DATE}")       replace
    filefilter `"`t2'"'  `"`t1'"', from("<AUTHOR>")       to("${PB_AUTHOR}")     replace
    filefilter `"`t1'"'  `"`t2'"', from("<SOURCE_DESC>")  to("${PB_DESC}")       replace
    filefilter `"`t2'"'  `"`t1'"', from("<SOURCE_URL>")   to("${PB_URL}")        replace
    filefilter `"`t1'"'  `"`t2'"', from("<PROJ_PATH>")    to("${PB_PATH}")       replace
    filefilter `"`t2'"'  `"`t1'"', from("<TOPIC>")        to("${PB_TOPIC}")      replace
    filefilter `"`t1'"'  `"`t2'"', from("<PUBLICFACING>") to("${PB_PUBLIC}")     replace
    filefilter `"`t2'"'  `"`t1'"', from("<TIMELINE>")     to("${PB_TIMELINE}")   replace
    filefilter `"`t1'"'  `"`t2'"', from("<OTHERNOTES>")   to("${PB_OTHERNOTES}") replace
    filefilter `"`t2'"'  `"`t1'"', from("<OUTCOMES>")     to("${PB_OUTCOMES}")   replace
    filefilter `"`t1'"'  `"`t2'"', from("<OVER>")         to("${PB_OVER}")        replace
    filefilter `"`t2'"'  `"`t1'"', from("<DESCSAVE>")     to("${PB_DESCSAVE}")    replace
    filefilter `"`t1'"'  `"`t2'"', from("<AUTOCONVERT>")  to("${PB_AUTOCONVERT}") replace

    copy `"`t2'"' `"`dst'"', replace
end


* ─── One-shot helper: fetch the Texas 2036 logo into _codeshare/assets ────
program define projectbuilder_fetchlogo
    local drive `"${tx2036_root}"'
    if `"`drive'"' == "" {
        if inlist("`c(os)'", "MacOSX", "Unix") {     // Apple-Silicon batch Stata reports "Unix"
            local home "/Users/`c(username)'"
            local gd_base "`home'/Library/CloudStorage"
            local gd_folders : dir "`gd_base'" dirs "GoogleDrive-*"
            local gd_folder  : word 1 of `gd_folders'
            local gd_folder  = subinstr(`"`gd_folder'"', `"""', "", .)
            local drive `"`gd_base'/`gd_folder'/Shared drives/Data and Research Team"'
        }
        else if "`c(os)'" == "Windows" {
            local drive "G:/Shared drives/Data and Research Team"
        }
    }
    local assets `"`drive'/_codeshare/assets"'
    cap mkdir `"`assets'"'

    local urls ///
        "https://texas2036.org/wp-content/uploads/2019/08/19_Texas2036_Primary_2Color.png" ///
        "https://www.texas2036.org/wp-content/uploads/2019/08/19_Texas2036_Primary_2Color.png"

    local got = 0
    foreach u of local urls {
        di as txt "projectbuilder_fetchlogo: trying `u'"
        cap copy `"`u'"' `"`assets'/tx2036_logo.png"', replace
        if !_rc {
            di as txt "  OK → `assets'/tx2036_logo.png"
            local got = 1
            continue, break
        }
    }
    if !`got' {
        di as err "projectbuilder_fetchlogo: every candidate URL failed."
        di as err "                          Drop tx2036_logo.png into `assets'/ manually."
        exit 631
    }
end
