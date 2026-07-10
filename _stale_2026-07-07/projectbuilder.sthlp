{smcl}
{* *! version 1.2.1 24may2026 Author: Eric Booth}{...}
{vieweralsosee "[P] webdoc2" "help webdoc2"}{...}
{vieweralsosee "[P] dsload"  "help dsload"}{...}
{viewerjumpto "Syntax"            "projectbuilder##syntax"}{...}
{viewerjumpto "Description"       "projectbuilder##description"}{...}
{viewerjumpto "Options"           "projectbuilder##options"}{...}
{viewerjumpto "Examples"          "projectbuilder##examples"}{...}
{viewerjumpto "Workflow A"        "projectbuilder##wfA"}{...}
{viewerjumpto "Workflow B"        "projectbuilder##wfB"}{...}
{viewerjumpto "Workflow C"        "projectbuilder##wfC"}{...}
{viewerjumpto "What gets built"   "projectbuilder##scaffold"}{...}
{viewerjumpto "Companion programs" "projectbuilder##companions"}{...}
{viewerjumpto "Author"            "projectbuilder##author"}{...}
{hline}
{pstd}help for {hi:projectbuilder}{p_end}
{hline}

{title:Title}

{p 4 8 2}
{bf:projectbuilder} {hline 2} scaffold a new Texas 2036 datashare folder from 
the canonical template, with project metadata, profiler hints, and a 
clickable shortcut to the rendered documentation.{p_end}


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:projectbuilder} {it:Source}[/{it:Subsource}] [{cmd:,} {it:options}]

{synoptset 25 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt t:ype(string)}}scaffold flavour; default is {cmd:datashare}{p_end}
{synopt:{opt des:cription(string)}}one-line description of the source{p_end}
{synopt:{opt url(string)}}source agency URL; omit for local-only projects{p_end}
{synopt:{opt path(string)}}override the base directory; default is {cmd:_datashare}{p_end}
{synopt:{opt nologo}}skip copying the Texas 2036 logo{p_end}
{synopt:{opt out:comes(varlist)}}up to 10 outcome variables for data profiler{p_end}
{synopt:{opt ov:er(varlist)}}up to 10 by-variables for auto breakdowns{p_end}
{synopt:{opt descsave}}generate {cmd:codebook.xlsx} via SSC {cmd:descsave}{p_end}
{synopt:{opt topic(string)}}free-text topic tag(s){p_end}
{synopt:{opt pub:licfacing(string)}}must be {cmd:yes}, {cmd:no}, or {cmd:unsure}{p_end}
{synopt:{opt time:line(string)}}refresh cadence (e.g., {cmd:monthly}){p_end}
{synopt:{opt other:notes(string)}}free-text caveats / context{p_end}
{synoptline}


{marker description}{...}
{title:Description}

{pstd}
{cmd:projectbuilder} creates a new folder under {cmd:_datashare/} (or under a 
user-specified path) populated with:{p_end}

{p 8 11 2}• the canonical folder tree ({cmd:01_raw/}, {cmd:01_raw/_converted/}, 
{cmd:02_cleaned/}, {cmd:03_output/}, {cmd:_code/}, {cmd:_documentation/}, 
{cmd:_archive/}, each with its own {cmd:_archive/} sub-folder){p_end}

{p 8 11 2}• the eight-step Stata pipeline in {cmd:_code/}: {cmd:000_controlfile.do}, 
{cmd:050_preferences.do}, {cmd:100_data_download.do}, 
{cmd:200_data_management.do}, {cmd:300_labels.do}, 
{cmd:400_data_profiler.do}, {cmd:500_aggregation.do}, 
{cmd:600_analysis.do}{p_end}

{p 8 11 2}• the documentation site builders in {cmd:_documentation/}: 
{cmd:_runall.do}, {cmd:index.do}, {cmd:help.do}, and {cmd:Readme.md}{p_end}

{p 8 11 2}• a copy of {cmd:tx2036_logo.png} in {cmd:_documentation/website/} 
(if cached in {cmd:_codeshare/assets/} — run {bf:projectbuilder_fetchlogo} 
once to cache it){p_end}

{p 8 11 2}• a clickable {cmd:OPEN_documentation.html} shortcut at the project root 
that redirects to {cmd:_documentation/website/index.html}.{p_end}

{pstd}
All template files are copied verbatim except for token substitution: 
{cmd:<PROJECT>}, {cmd:<DATE>}, {cmd:<AUTHOR>}, {cmd:<SOURCE_DESC>}, 
{cmd:<SOURCE_URL>}, {cmd:<PROJ_PATH>}, {cmd:<TOPIC>}, {cmd:<PUBLICFACING>}, 
{cmd:<TIMELINE>}, {cmd:<OTHERNOTES>}, {cmd:<OUTCOMES>}, {cmd:<OVER>}, 
{cmd:<DESCSAVE>}.{p_end}

{pstd}
The program is cross-OS: it uses Stata's built-in {help mkdir}, {help copy}, 
and {help file} commands. No shell calls.{p_end}


{marker options}{...}
{title:Options}

{phang}
{opt type(string)} specifies the scaffold flavour. Default is {cmd:datashare}. 
{cmd:project} is a forward-compatible stub.{p_end}

{phang}
{opt description(string)} provides a one-line description of the source. 
Lands in {cmd:000_controlfile.do} as {cmd:$ds_source_desc}.{p_end}

{phang}
{opt url(string)} specifies the source agency URL. OMIT for a 
local-files-only project (see Workflow A below).{p_end}

{phang}
{opt path(string)} overrides the base directory. 
Default: {cmd:Shared drives/Data and Research Team/_datashare}. Use for sandboxing.{p_end}

{phang}
{opt nologo} skips the logo copy step.{p_end}

{phang}
{opt outcomes(varlist)} provides up to 10 outcome variables that the 
{cmd:400_data_profiler.do} auto-section will tabulate. Variables that 
don't exist in a given cleaned table are silently skipped.{p_end}

{phang}
{opt over(varlist)} provides up to 10 by-variables for the auto breakdowns.{p_end}

{phang}
{opt descsave} triggers the generation of a multi-sheet {cmd:codebook.xlsx} 
via {bf:descsave} (SSC) in {cmd:300_labels.do}.{p_end}

{phang}
{opt topic(string)} sets free-text topic tag(s).{p_end}

{phang}
{opt publicfacing(string)} must be {cmd:yes}, {cmd:no}, {cmd:unsure}, or empty.{p_end}

{phang}
{opt timeline(string)} specifies the refresh cadence (e.g. {cmd:monthly}).{p_end}

{phang}
{opt othernotes(string)} provides free-text caveats or context.{p_end}


{marker examples}{...}
{title:Examples}

{phang2}{cmd:. projectbuilder TDI/TitleAgents, desc("TX title-insurance industry") url("https://www.tdi.texas.gov/data/index.html") outcomes("n_companies n_officers") over("mdate county") descsave topic("insurance, title agents") publicfacing(yes) timeline("monthly")}{p_end}

{phang2}{cmd:. projectbuilder TEA_AEIS/Discipline, desc("AEIS discipline incidents")}{p_end}

{phang2}{cmd:. projectbuilder THECB}{p_end}


{marker wfA}{...}
{title:Workflow A — new project from local files only (no URL)}

{pstd}
You have three CSV / XLSX / DTA files on your Desktop and want to build a 
project around them. No public URL.{p_end}

{pstd}
{bf:Step 1.} Scaffold the folder. Omit {cmd:url()}; use {cmd:othernotes()} 
to capture provenance:{p_end}

{hline}
{cmd}
. projectbuilder CountyBudgets,                                              ///
      desc("County-level budget CSVs from City Hall, one row per dept per FY") ///
      topic("local government, budgets")                                      ///
      publicfacing(unsure)                                                    ///
      timeline("annual; refreshed each October")                              ///
      othernotes("Files received from M. Smith on 2026-05-20")                ///
      outcomes("total_budget department_count")                               ///
      over("year department")                                                 ///
      descsave
{txt}{hline}

{pstd}
{bf:Step 2.} Drag the files into the new {cmd:_datashare/CountyBudgets/01_raw/}.{p_end}

{pstd}
{bf:Step 3.} Open {cmd:_code/100_data_download.do} and pick ONE of:{p_end}

{p 8 11 2}3a. If the files only exist once, leave the {cmd:urls} list empty. 
Replace the "Source" {cmd:wdlist} with notes on where the files came from.{p_end}

{p 8 11 2}3b. If the files refresh at a known local path, put those paths 
in the {cmd:urls} list:{p_end}

{hline}
{cmd}
    local home "/Users/`c(username)'"      // portable
    local urls ///
        "`home'/Desktop/FY24_county_budgets/county_budget_2022.csv" ///
        "`home'/Desktop/FY24_county_budgets/county_budget_2023.csv" ///
        "`home'/Desktop/FY24_county_budgets/county_budget_2024.csv"
    local localnames ///
        "2022_CountyBudget.csv" ///
        "2023_CountyBudget.csv" ///
        "2024_CountyBudget.csv"
{txt}{hline}

{pstd}
{bf:Step 4.} Switch {cmd:import excel} to {cmd:import delimited} in 
{cmd:200_data_management.do} if the files are CSVs:{p_end}

{hline}
{cmd}
    local rawfiles : dir "${raw}" files "*.csv"
    foreach f of local rawfiles {
        local stem = subinstr("`f'", ".csv", "", .)
        import delimited "${raw}/`f'", clear varnames(1) case(lower)
        qui compress
        save "${converted}/`stem'.dta", replace
    }
{txt}{hline}


{marker wfB}{...}
{title:Workflow B — refreshing a project with new local files}

{pstd}
The project already exists. The vendor sent you a new vintage. What now?{p_end}

{pstd}
{bf:Case B1 — same paths, new contents.} Nothing to edit; just rebuild:{p_end}
{phang2}{cmd:. do "${docs}/_runall.do"}{p_end}

{pstd}
{bf:Case B2 — same vendor, different filenames.} Edit {cmd:100_data_download.do} 
to update the lists, then rebuild.{p_end}

{pstd}
{bf:Case B3 — drop-in by hand.} If you just want to drop files into {cmd:01_raw/} 
manually:{p_end}

{p 8 11 2}1. Move prior contents to {cmd:01_raw/_archive/}.{p_end}
{p 8 11 2}2. Drop new files into {cmd:01_raw/}.{p_end}
{p 8 11 2}3. {cmd:do "${docs}/_runall.do"}.{p_end}


{marker wfC}{...}
{title:Workflow C — new project, source has a public URL}

{pstd}
The canonical workflow. See the example for {cmd:TDI/TitleAgents} above. 
{cmd:100_data_download.do} fetches via {help copy} from the URLs you list.{p_end}


{marker scaffold}{...}
{title:What gets built}

{pstd}
After {cmd:projectbuilder TDI_Insurance, ...} you will have:{p_end}

{hline}
{cmd}
_datashare/TDI_Insurance/
├── OPEN_documentation.html     
├── 01_raw/
│   ├── _archive/
│   └── _converted/
├── 02_cleaned/
│   └── _archive/
├── 03_output/
│   └── _archive/
├── _code/
│   ├── 000_controlfile.do
│   ├── ...
│   └── _archive/
├── _documentation/
│   ├── Readme.md
│   ├── website/
│   └── _archive/
└── _archive/
{txt}{hline}


{marker companions}{...}
{title:Companion programs}

{p 8 20 2}{bf:dsload} {space 8} defensive loader for {cmd:000_controlfile.do}{p_end}
{p 8 20 2}{bf:wdds_navbar} {space 3} renders the Bootstrap 5 navbar{p_end}
{p 8 20 2}{bf:fetchlogo} {space 5} one-shot download of Texas 2036 logo{p_end}
{p 8 20 2}{bf:webdoc2} {space 7} wraps {help webdoc} and powers the templates{p_end}


{marker author}{...}
{title:Author}

{pstd}
Eric A. Booth{break}
Texas 2036{break}
GitHub: {browse "https://www.github.com/ericabooth":www.github.com/ericabooth}{p_end}

{hline}
