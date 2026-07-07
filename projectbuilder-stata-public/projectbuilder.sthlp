{smcl}
{* *! version 1.0.0 06jul2026 Eric A. Booth, Sr Researcher, Texas 2036}{...}
{viewerjumpto "Syntax"          "projectbuilder##syntax"}{...}
{viewerjumpto "Description"     "projectbuilder##description"}{...}
{viewerjumpto "Options"         "projectbuilder##options"}{...}
{viewerjumpto "Examples"        "projectbuilder##examples"}{...}
{viewerjumpto "Workflow A"      "projectbuilder##wfA"}{...}
{viewerjumpto "Workflow B"      "projectbuilder##wfB"}{...}
{viewerjumpto "Workflow C"      "projectbuilder##wfC"}{...}
{viewerjumpto "What gets built" "projectbuilder##scaffold"}{...}
{viewerjumpto "Stored results"  "projectbuilder##results"}{...}
{viewerjumpto "Author"          "projectbuilder##author"}{...}
{hline}
{pstd}help for {hi:projectbuilder}{p_end}
{hline}

{title:Title}

{p 4 8 2}
{bf:projectbuilder} {hline 2} scaffold a data-analysis project folder with a
numbered do-file pipeline, a control file that holds every path in one
place, and a metadata-stamped README.{p_end}


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:projectbuilder} {it:Source}[{cmd:/}{it:Subsource}] [{cmd:,} {it:options}]

{synoptset 25 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt des:cription(string)}}one-line description of the project; stamped into the README{p_end}
{synopt:{opt url(string)}}source URL; lands as the download-target comment in {cmd:100_ingest.do}{p_end}
{synopt:{opt path(string)}}base directory; default is the current working directory{p_end}
{synopt:{opt topic(string)}}free-text topic tag(s){p_end}
{synopt:{opt pub:licfacing(string)}}must be {cmd:yes}, {cmd:no}, or {cmd:unsure}{p_end}
{synopt:{opt time:line(string)}}refresh cadence (e.g., {cmd:monthly}){p_end}
{synopt:{opt other:notes(string)}}free-text caveats / provenance notes{p_end}
{synopt:{opt out:comes(varlist)}}up to 10 outcome variables; suggested local in {cmd:300_analyze.do}{p_end}
{synopt:{opt ov:er(varlist)}}up to 10 by-variables; suggested local in {cmd:300_analyze.do}{p_end}
{synopt:{opt descsave}}add a commented {cmd:descsave} (SSC) codebook call to {cmd:200_clean.do}{p_end}
{synoptline}


{marker description}{...}
{title:Description}

{pstd}
{cmd:projectbuilder} creates a new project folder named {it:Source} (or
{it:Source/Subsource}, nested one level) under the current working
directory or under {opt path()}, populated with:{p_end}

{p 8 11 2}• the five-folder tree: {cmd:raw/} (untouched downloads,
write-once), {cmd:clean/} (analysis-ready {cmd:.dta} files), {cmd:code/}
(the do-files), {cmd:output/} (logs and tables), and {cmd:figures/}
(exported graphs){p_end}

{p 8 11 2}• {cmd:code/00_control.do} {hline 2} the control file. It pins
the Stata {help version}, sets {cmd:$root} to the scaffolded absolute path
(one loudly commented line to edit if the project ever moves), derives
{cmd:$raw}, {cmd:$clean}, {cmd:$code}, {cmd:$output}, and {cmd:$figures}
from it, and ends with an optional run-all block that rebuilds the whole
pipeline in order when you flip {cmd:local run_all} to {cmd:1}{p_end}

{p 8 11 2}• the numbered pipeline stubs in {cmd:code/}:
{cmd:100_ingest.do}, {cmd:200_clean.do}, {cmd:300_analyze.do},
{cmd:400_visualize.do}, {cmd:500_report.do}. Each states its single job
in a header comment and notes that the globals come from
{cmd:00_control.do}. Numbering by hundreds leaves gaps on purpose, so a
new step slots in as {cmd:150_} without renaming the rest{p_end}

{p 8 11 2}• {cmd:README.md} at the project root, stamped with the project
name, date, author, and every metadata option you passed, plus the tree
diagram.{p_end}

{pstd}
The metadata options do double duty: they document the project in the
README and seed the stubs. {opt url()} becomes the download-target
comment in {cmd:100_ingest.do}; {opt outcomes()} and {opt over()} become
suggested locals in {cmd:300_analyze.do}; {opt descsave} adds a commented
codebook-export call to {cmd:200_clean.do}.{p_end}

{pstd}
{cmd:projectbuilder} never overwrites an existing folder: if the target
already exists, it stops with error 602 and tells you so. It is
self-contained (every scaffold file is written by the program itself; no
template folder is needed) and cross-OS (it uses Stata's built-in
{help mkdir} and {help file} commands; no shell calls).{p_end}

{pstd}
This package accompanies the book {it:Applied Program Evaluation Using
Stata} by Booth & Teas; the scaffold is the project layout that book uses
throughout. The design grew out of the authors' production scaffolding
tool.{p_end}


{marker options}{...}
{title:Options}

{phang}
{opt description(string)} provides a one-line description of the project.
It is stamped into {cmd:README.md}; if omitted, the README carries an
edit-me placeholder.{p_end}

{phang}
{opt url(string)} records the source URL. It lands in
{cmd:100_ingest.do} as the download-target comment, next to a commented
{help copy} call ready to be uncommented. Omit it for a
local-files-only project (see Workflow A).{p_end}

{phang}
{opt path(string)} sets the base directory the project folder is created
under. The default is the current working directory,
{cmd:c(pwd)}.{p_end}

{phang}
{opt topic(string)} sets free-text topic tag(s) for the README.{p_end}

{phang}
{opt publicfacing(string)} must be {cmd:yes}, {cmd:no}, {cmd:unsure}, or
omitted. Recorded in the README.{p_end}

{phang}
{opt timeline(string)} records the refresh cadence (e.g.,
{cmd:monthly}, {cmd:annual; each October}).{p_end}

{phang}
{opt othernotes(string)} records free-text caveats or provenance notes
(who sent the files, when, under what terms).{p_end}

{phang}
{opt outcomes(varlist)} names up to 10 outcome variables. They are
written into {cmd:300_analyze.do} as the suggested {cmd:local outcomes}.
More than 10 are trimmed to the first 10, with a note.{p_end}

{phang}
{opt over(varlist)} names up to 10 by-variables for breakdowns, written
into {cmd:300_analyze.do} as the suggested {cmd:local over}. Same
10-item cap.{p_end}

{phang}
{opt descsave} adds a commented codebook-export call via {cmd:descsave}
(from SSC: {cmd:ssc install descsave}) to {cmd:200_clean.do}.{p_end}


{marker examples}{...}
{title:Examples}

{pstd}Minimal {hline 2} a project named {cmd:CountyBudgets} under the current directory:{p_end}

{phang2}{cmd:. projectbuilder CountyBudgets}{p_end}

{pstd}Nested under a source, with a base path:{p_end}

{phang2}{cmd:. projectbuilder LaborDept/UnempClaims, path("~/projects")}{p_end}

{pstd}Metadata-rich:{p_end}

{phang2}{cmd:. projectbuilder LaborDept/UnempClaims, desc("Monthly county unemployment claims") url("https://example.gov/data/claims.csv") outcomes(claims_rate claims_n) over(county year) descsave topic("labor markets") publicfacing(yes) timeline(monthly)}{p_end}


{marker wfA}{...}
{title:Workflow A {hline 2} new project from local files only (no URL)}

{pstd}
You have three CSV files someone emailed you and want a project built
around them. There is no public URL.{p_end}

{pstd}
{bf:Step 1.} Scaffold the folder. Omit {cmd:url()}; use
{cmd:othernotes()} to capture provenance:{p_end}

{phang2}{cmd:. projectbuilder CountyBudgets, desc("County budget CSVs, one row per dept per FY") othernotes("Files received from M. Smith on 2026-05-20") outcomes(total_budget) over(year department)}{p_end}

{pstd}
{bf:Step 2.} Drag the files into the new {cmd:CountyBudgets/raw/}. Raw
files are write-once: they are never edited, only read.{p_end}

{pstd}
{bf:Step 3.} Open {cmd:code/100_ingest.do} and replace the placeholder
comment with a note on where the files came from (or, if they refresh at
a known local path, a {help copy} command from that path into
{cmd:$raw}).{p_end}

{pstd}
{bf:Step 4.} Run {cmd:00_control.do}, then write the import in
{cmd:200_clean.do} (e.g., {cmd:import delimited "$raw/..."} ...
{cmd:save "$clean/...dta"}) and work down the pipeline.{p_end}


{marker wfB}{...}
{title:Workflow B {hline 2} refreshing a project with new files}

{pstd}
The project already exists and a new vintage of the data arrives.
{cmd:projectbuilder} is not involved (it refuses to touch an existing
folder); the scaffold is built for exactly this moment:{p_end}

{p 8 11 2}{bf:Case B1 {hline 2} same filenames, new contents.} Drop the
new files into {cmd:raw/}, flip {cmd:local run_all} to {cmd:1} in
{cmd:00_control.do}, and rerun it. The whole pipeline rebuilds in
order.{p_end}

{p 8 11 2}{bf:Case B2 {hline 2} new filenames.} Update the filename(s)
in {cmd:100_ingest.do} and {cmd:200_clean.do}, then rebuild as in
B1.{p_end}

{p 8 11 2}{bf:Case B3 {hline 2} you want to keep the old vintage.} Make
a subfolder such as {cmd:raw/2025/} for the prior files before dropping
in the new ones, and point {cmd:200_clean.do} at the current
vintage.{p_end}


{marker wfC}{...}
{title:Workflow C {hline 2} new project, source has a public URL}

{pstd}
Pass the URL at scaffold time and it is waiting for you in
{cmd:100_ingest.do}:{p_end}

{phang2}{cmd:. projectbuilder LaborDept/UnempClaims, url("https://example.gov/data/claims.csv") desc("Monthly county unemployment claims")}{p_end}

{pstd}
Open {cmd:code/100_ingest.do}, uncomment the {help copy} line, fix the
local filename, and run it. The raw file lands in {cmd:$raw} and the
rest of the pipeline proceeds as in Workflow A.{p_end}


{marker scaffold}{...}
{title:What gets built}

{pstd}
After {cmd:projectbuilder LaborDept/UnempClaims, ...} you will have:{p_end}

{hline}
{cmd}
LaborDept/UnempClaims/
├── README.md          project name, date, author, metadata, this tree
├── raw/               untouched downloads (write-once; never edited)
├── clean/             analysis-ready .dta files
├── code/
│   ├── 00_control.do      every path in one place; run-all block
│   ├── 100_ingest.do      fetch raw source files into $raw
│   ├── 200_clean.do       raw -> analysis-ready .dta in $clean
│   ├── 300_analyze.do     clean -> tables in $output
│   ├── 400_visualize.do   graphs exported to $figures
│   └── 500_report.do      assemble the deliverable in $output
├── output/            logs and tables
└── figures/           exported graphs
{txt}{hline}

{pstd}
{cmd:00_control.do} stamps {cmd:$root} with the absolute path of the
scaffolded folder, so the pipeline runs immediately; when the project
moves, edit that one line and nothing else.{p_end}


{marker results}{...}
{title:Stored results}

{pstd}{cmd:projectbuilder} stores the following in {cmd:r()}:{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(project)}}the project label ({it:Source} or {it:Source_Subsource}){p_end}
{synopt:{cmd:r(path)}}the absolute path of the scaffolded folder{p_end}


{title:Notes}

{p 8 11 2}• The target folder must not already exist; if it does,
{cmd:projectbuilder} exits with error 602 and changes nothing.{p_end}

{p 8 11 2}• Names may nest at most one level ({it:Source/Subsource}) and
may not contain {cmd:..} or backslashes.{p_end}

{p 8 11 2}• Metadata strings are stamped into generated files verbatim;
avoid backtick and dollar-sign characters in them.{p_end}

{p 8 11 2}• Requires Stata 16.0 or newer. No dependencies. The optional
{cmd:descsave} codebook call requires {cmd:ssc install descsave}.{p_end}


{marker author}{...}
{title:Author}

{pstd}
Eric A. Booth, Sr Researcher, Texas 2036{break}
Support: eric.a.booth@gmail.com{break}
Companion package to {it:Applied Program Evaluation Using Stata}.{p_end}

{hline}
