{smcl}
{* *! version 2.0.0 07jul2026 Eric A. Booth}{...}
{vieweralsosee "[P] file" "help file"}{...}
{vieweralsosee "[D] copy" "help copy"}{...}
{viewerjumpto "Syntax"            "projectbuilder##syntax"}{...}
{viewerjumpto "Description"       "projectbuilder##description"}{...}
{viewerjumpto "Options"           "projectbuilder##options"}{...}
{viewerjumpto "Workflow A"        "projectbuilder##wfA"}{...}
{viewerjumpto "Workflow B"        "projectbuilder##wfB"}{...}
{viewerjumpto "Optional dependencies" "projectbuilder##deps"}{...}
{viewerjumpto "What gets built"   "projectbuilder##scaffold"}{...}
{viewerjumpto "Stored results"    "projectbuilder##results"}{...}
{viewerjumpto "Author"            "projectbuilder##author"}{...}
{hline}
{pstd}help for {hi:projectbuilder}{p_end}
{hline}

{title:Title}

{p 4 8 2}
{bf:projectbuilder} {hline 2} scaffold a data-analysis project folder with a
numbered do-file pipeline, then optionally ingest data, convert it, combine it
into one analytic file, and build a documentation page.{p_end}


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:projectbuilder} {it:Source}[{cmd:/}{it:Subsource}] [{cmd:,} {it:options}]

{synoptset 27 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt path(string)}}base directory; default is the current working directory{p_end}
{synopt:{opt des:cription(string)}}one-line description of the project{p_end}
{synopt:{opt url(string)}}source URL; recorded, and fetched now if reachable{p_end}
{synopt:{opt data(string)}}local file or folder to copy into {cmd:01_raw/} now{p_end}
{synopt:{opt topic(string)}}free-text topic tag(s){p_end}
{synopt:{opt pub:licfacing(string)}}must be {cmd:yes}, {cmd:no}, or {cmd:unsure}{p_end}
{synopt:{opt time:line(string)}}refresh cadence (for example, {cmd:monthly}){p_end}
{synopt:{opt other:notes(string)}}free-text caveats or provenance{p_end}
{synopt:{opt out:comes(varlist)}}up to 10 outcome variables for the profiler{p_end}
{synopt:{opt ov:er(varlist)}}up to 10 by-variables for the profiler{p_end}
{synopt:{opt descsave}}seed a codebook-export call in {cmd:300_labels.do}{p_end}
{synopt:{opt rebuild}}refresh an existing project (re-ingest, re-document){p_end}
{synopt:{opt replace}}with {cmd:rebuild}, also overwrite edited code files{p_end}
{synopt:{opt builddocs}}render the documentation with {cmd:webdoc2} if installed{p_end}
{synopt:{opt noauto:convert}}skip the automatic convert/combine pass{p_end}
{synoptline}


{marker description}{...}
{title:Description}

{pstd}
{cmd:projectbuilder} creates a project folder under the current working
directory (or under {opt path()}) and fills it with a numbered do-file
pipeline, an analytic-data folder, an output folder, and a documentation
folder. Everything is written by the command itself with {help file:file
write}; there is no template folder and no shell call, so it behaves the same
on macOS, Windows, and Linux.{p_end}

{pstd}
There are two ways to use it. In {bf:Workflow A} the data exists now, so you
point {opt data()} at local files and/or {opt url()} at a source address;
{cmd:projectbuilder} copies the files in, converts them, combines them into one
analytic file, and builds the documentation. In {bf:Workflow B} you scaffold
first and add data later, then rerun with {opt rebuild} on every refresh. Both
are shown below.{p_end}

{pstd}
{cmd:projectbuilder} never overwrites an existing project: a plain call on a
folder that already exists stops with error 602. Use {opt rebuild} to opt in to
working on an existing project. A {opt rebuild} preserves any do-file in
{cmd:_code/} you have edited unless you also give {opt replace}; the
documentation, being a derived artifact, is regenerated on every {opt rebuild}.{p_end}


{marker options}{...}
{title:Options}

{phang}
{opt path(string)} sets the base directory under which the project folder is
created. The default is the current working directory. The project is created
at {it:path}{cmd:/}{it:Source} (or {it:path}{cmd:/}{it:Source}{cmd:/}{it:Subsource}).{p_end}

{phang}
{opt description(string)} is a one-line description of the project. It is
stamped into the documentation and the pipeline headers.{p_end}

{phang}
{opt url(string)} records a source URL. The fetch is written into
{cmd:100_data_download.do} so it is reproducible, and it is attempted once at
scaffold time; if the address is reachable the file lands in {cmd:01_raw/}.{p_end}

{phang}
{opt data(string)} names a local file, or a folder of files, to copy into
{cmd:01_raw/} now. This is the Workflow A entry point for data you already
have on disk.{p_end}

{phang}
{opt topic(string)}, {opt publicfacing(string)}, {opt timeline(string)}, and
{opt othernotes(string)} are metadata stamped into the documentation.
{opt publicfacing()} must be {cmd:yes}, {cmd:no}, {cmd:unsure}, or empty.{p_end}

{phang}
{opt outcomes(varlist)} and {opt over(varlist)} seed the suggested locals in
{cmd:400_data_profiler.do}. Each is capped at 10 items, with a note when
trimmed.{p_end}

{phang}
{opt descsave} adds a codebook-export call (via {cmd:descsave} from SSC) to
{cmd:300_labels.do}, writing an Excel codebook into {cmd:_documentation/}.{p_end}

{phang}
{opt rebuild} refreshes an existing project: it re-runs the convert/combine
pass over {cmd:01_raw/} and regenerates the documentation. Every data refresh
is just another {opt rebuild}.{p_end}

{phang}
{opt replace} has effect only with {opt rebuild}: it allows the numbered
do-files to be overwritten. Without it, a {opt rebuild} leaves your edited
do-files untouched.{p_end}

{phang}
{opt builddocs} renders {cmd:_documentation/website/index.html} with
{cmd:webdoc2} if it is installed. Documentation is always built either way; this
option only makes it prettier.{p_end}

{phang}
{opt noautoconvert} skips the automatic {cmd:convertanything} and
{cmd:combineall} pass. The calls still appear in {cmd:200_data_management.do} so
you can run them yourself.{p_end}


{marker wfA}{...}
{title:Workflow A -- the data already exists (local files or a source URL)}

{pstd}
You have a folder of CSV or Excel files on disk (or a public download URL), and
you want a project built around them in one command.{p_end}

{pstd}
{bf:Step 1.} Scaffold and ingest in a single call. Point {opt data()} at the
folder of files (and/or {opt url()} at the source):{p_end}

{p 8 8 2}{cmd:. cd "~/projects"}{p_end}
{p 8 8 2}{cmd:. projectbuilder CountyBudgets,                                   ///}{p_end}
{p 8 8 2}{cmd:        data("~/Desktop/budget_drop")                            ///}{p_end}
{p 8 8 2}{cmd:        description("County budget CSVs, one row per dept per FY") ///}{p_end}
{p 8 8 2}{cmd:        topic("local government, budgets") publicfacing(unsure)  ///}{p_end}
{p 8 8 2}{cmd:        timeline("annual") outcomes(total_budget) over(year dept) descsave}{p_end}

{pstd}
This copies every file from {cmd:budget_drop/} into {cmd:CountyBudgets/01_raw/},
runs {cmd:convertanything} over {cmd:01_raw/} into {cmd:01_raw/_converted/},
appends the converted files with {cmd:combineall} into
{cmd:02_cleaned/CountyBudgets_analytic.dta}, and writes the documentation page.
(If a source lives online, add {cmd:url("https://.../data.csv")}; it is fetched
now and the fetch is recorded in {cmd:100_data_download.do}.){p_end}

{pstd}
{bf:Step 2.} Open {cmd:_code/000_control.do}, run it to set the path globals,
then work down the pipeline from {cmd:300_labels.do} onward.{p_end}


{marker wfB}{...}
{title:Workflow B -- scaffold now, data later, rebuild on every refresh}

{pstd}
You want the project structure now, before the data has arrived.{p_end}

{pstd}
{bf:Step 1.} Scaffold with no {opt data()} and no {opt url()}. You get the full
tree, an empty {cmd:01_raw/}, and printed next steps:{p_end}

{p 8 8 2}{cmd:. projectbuilder VendorFeed, description("Monthly vendor extract")}{p_end}

{pstd}
{bf:Step 2.} When the files arrive, drop them into
{cmd:VendorFeed/01_raw/}.{p_end}

{pstd}
{bf:Step 3.} Rerun with {opt rebuild}. {cmd:projectbuilder} detects the new
files, re-runs the convert/combine pass, and regenerates the documentation:{p_end}

{p 8 8 2}{cmd:. projectbuilder VendorFeed, rebuild}{p_end}

{pstd}
Every later refresh is the same {opt rebuild}. It is idempotent, and it will not
overwrite a do-file you have edited in {cmd:_code/} unless you add {opt replace}.{p_end}


{marker deps}{...}
{title:Optional dependencies}

{pstd}
{cmd:projectbuilder} has no hard dependencies. A few companion tools make it do
more when installed; each is detected with {help capture:capture which}. If a
tool is missing, the generated do-file still {it:contains} the call (so it is a
working example), the automatic pass skips that step, and a one-line note names
the package and its install command.{p_end}

{p2colset 8 26 28 2}{...}
{p2col:{bf:convertanything}}bulk-convert mixed formats in {cmd:01_raw/} to {cmd:.dta} in {cmd:01_raw/_converted/} (author's GitHub){p_end}
{p2col:{bf:combineall}}append or merge the converted files into the analytic file (author's GitHub){p_end}
{p2col:{bf:descsave}}write an Excel codebook from {cmd:300_labels.do} (SSC: {cmd:ssc install descsave}){p_end}
{p2col:{bf:srctag} / {bf:srcfind}}tag and search each variable's source lineage (author's GitHub){p_end}
{p2col:{bf:webdoc2}}render a richer {cmd:index.html} (author's GitHub; needs {cmd:ssc install webdoc}){p_end}
{p2colreset}{...}

{pstd}
The convert-then-combine chain is the heart of {cmd:200_data_management.do}:
{cmd:convertanything} turns every raw file into a cleaned {cmd:.dta}, then
{cmd:combineall} with {cmd:cmethod(append)} stacks those into one analytic file.
When {cmd:webdoc2} is absent, {cmd:projectbuilder} writes a plain but complete
{cmd:index.html} and {cmd:Readme.md} directly, so the documentation always
exists.{p_end}


{marker scaffold}{...}
{title:What gets built}

{pstd}
After {cmd:projectbuilder MyProject} you have:{p_end}

{p 8 8 2}{cmd}{...}
MyProject/
+-- 01_raw/                raw source files (write-once)
|   +-- _archive/
|   +-- _converted/        convertanything output (one .dta per raw file)
+-- 02_cleaned/            <project>_analytic.dta lives here
|   +-- _archive/
+-- 03_output/             logs, tables, exhibits
|   +-- _archive/
+-- _code/
|   +-- 000_control.do     every path in one place; run-all block
|   +-- 100_data_download.do
|   +-- 200_data_management.do   convertanything -> combineall
|   +-- 300_labels.do
|   +-- 400_data_profiler.do
|   +-- 500_aggregation.do
|   +-- 600_analysis.do
|   +-- _archive/
+-- _documentation/
|   +-- index.do           webdoc2 source
|   +-- _runall.do         renders website/index.html
|   +-- Readme.md
|   +-- website/index.html
|   +-- _archive/
+-- _archive/
{txt}{...}
{p_end}

{pstd}
{cmd:000_control.do} pins the Stata version, stamps {cmd:$root} with the
absolute path of the new folder (one loudly commented line to edit if the
project ever moves), derives {cmd:$raw}, {cmd:$converted}, {cmd:$cleaned},
{cmd:$output}, {cmd:$code}, and {cmd:$docs} from it, and ends with a run-all
block over the numbered pipeline.{p_end}


{marker results}{...}
{title:Stored results}

{pstd}{cmd:projectbuilder} is {help return:rclass} and stores:{p_end}

{synoptset 16 tabbed}{...}
{p2col 5 16 20 2: Scalars}{p_end}
{synopt:{cmd:r(nraw)}}number of files in {cmd:01_raw/}{p_end}
{synopt:{cmd:r(nconverted)}}number of {cmd:.dta} files in {cmd:01_raw/_converted/}{p_end}
{synopt:{cmd:r(rebuilt)}}1 if this call refreshed an existing project, else 0{p_end}
{p2col 5 16 20 2: Macros}{p_end}
{synopt:{cmd:r(project)}}project label (slashes become underscores){p_end}
{synopt:{cmd:r(path)}}absolute path of the project folder{p_end}
{p2colreset}{...}


{marker author}{...}
{title:Author}

{pstd}
Eric A. Booth, Sr Researcher, Texas 2036{break}
Support: {browse "mailto:eric.a.booth@gmail.com":eric.a.booth@gmail.com}{break}
A generalization of the author's production project-scaffolding tool; companion
to {it:Applied Program Evaluation Using Stata}.{p_end}

{hline}
