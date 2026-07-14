{smcl}
{* *! version 1.0.0  2026-07-14}{...}
{viewerjumpto "Syntax" "datadictionary##syntax"}{...}
{viewerjumpto "Description" "datadictionary##description"}{...}
{viewerjumpto "Options" "datadictionary##options"}{...}
{viewerjumpto "Output" "datadictionary##output"}{...}
{viewerjumpto "Stored results" "datadictionary##results"}{...}
{viewerjumpto "Examples" "datadictionary##examples"}{...}
{viewerjumpto "Remarks" "datadictionary##remarks"}{...}
{viewerjumpto "Related work" "datadictionary##related"}{...}

{title:Title}

{p2colset 5 18 20 2}{...}
{p2col :{cmd:datadictionary} {hline 2}}Enhanced, over-time-ready codebook generator (a modern descsave){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}In-memory mode (documents the dataset in memory):{p_end}

{p 8 16 2}
{cmd:datadictionary} [{varlist}] {ifin} [{cmd:,}
{cmd:wave(}{varname}{cmd:)} {it:shared_options}]

{pstd}Files mode (documents a set of wave files and detects changes across
waves):{p_end}

{p 8 16 2}
{cmd:datadictionary}{cmd:,} {cmd:files(}{it:"w1.dta w2.dta ..."}{cmd:)}
[{cmd:wavenames(}{it:"name1 name2 ..."}{cmd:)} {it:shared_options}]

{p 8 16 2}
{cmd:datadictionary}{cmd:,} {cmd:folder(}{it:dirpath}{cmd:)}
[{cmd:pattern(}{it:str}{cmd:)} {cmd:wavenames(}{it:"name1 name2 ..."}{cmd:)}
{it:shared_options}]

{synoptset 24 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :In-memory mode}
{synopt :{cmd:wave(}{varname}{cmd:)}}wave identifier in a stitched file; adds per-wave presence and per-wave missingness{p_end}

{syntab :Files mode}
{synopt :{cmd:files(}{it:"f1 f2 ..."}{cmd:)}}space-separated list of wave .dta files, in wave order{p_end}
{synopt :{cmd:folder(}{it:dirpath}{cmd:)}}take the wave files from a folder instead{p_end}
{synopt :{cmd:pattern(}{it:str}{cmd:)}}filename pattern for {cmd:folder()}; default is {cmd:*.dta}; matches are sorted by filename{p_end}
{synopt :{cmd:wavenames(}{it:"n1 n2 ..."}{cmd:)}}display names for the waves, one per file; default is each file's basename{p_end}

{syntab :Shared}
{synopt :{cmd:excel(}{it:filename}{cmd:)}}write a multi-sheet .xlsx codebook{p_end}
{synopt :{cmd:saving(}{it:filename}{cmd:)}}save the codebook itself as a .dta, one row per variable (per variable-wave in files mode){p_end}
{synopt :{cmd:replace}}overwrite existing {cmd:excel()} and {cmd:saving()} files{p_end}
{synopt :{cmd:examples(}{it:#}{cmd:)}}distinct example values shown for string variables; default {cmd:examples(3)}{p_end}
{synopt :{cmd:top(}{it:#}{cmd:)}}top categories by frequency shown for value-labeled variables; default {cmd:top(5)}{p_end}
{synopt :{cmd:nochars}}skip characteristics (both the {cmd:srctag} and {cmd:chars} columns){p_end}
{synopt :{cmd:nonotes}}skip stored {help notes}{p_end}
{synoptline}


{marker description}{...}
{title:Description}

{pstd}
{cmd:datadictionary} generates a codebook: one row per variable (per variable-wave
in files mode) holding the variable's name, storage type, display format,
variable label, value-label name, N nonmissing, % missing, number of distinct
values, numeric summary statistics (mean, sd, min, median, max; blank for
strings), example values, stored {help notes}, and characteristics
({help char}), including the {cmd:srctag} characteristic written by the
author's {cmd:combineall}/{cmd:projectbuilder} tools.  Results are displayed
compactly in the Results window and can be written to a machine-readable
.dta ({cmd:saving()}) and a multi-sheet Excel workbook ({cmd:excel()}).

{pstd}
{bf:In-memory mode} documents the dataset in memory, optionally restricted by
{it:varlist}, {cmd:if}, and {cmd:in}.  With {cmd:wave(}{varname}{cmd:)} it
also reports per-wave presence and per-wave missingness for a stitched
(appended) multi-wave file.

{pstd}
{bf:Files mode} ({cmd:files()} or {cmd:folder()}) loads each wave file in
turn (the caller's data are preserved and restored untouched), harvests
per-wave metadata, and detects changes across waves: variables added or
dropped, storage type changes, variable label changes, value-label set
changes (categories added, removed, or relabeled), and display format
changes.  This is only possible in files mode, because stitching waves into
one file destroys per-wave value labels: after {help append} only one label
definition per label name survives, so wave-specific category sets can no
longer be compared.  Files mode exists for exactly this reason.


{marker options}{...}
{title:Options}

{dlgtab:In-memory mode}

{phang}{cmd:wave(}{varname}{cmd:)} names the wave identifier of a stitched
multi-wave file (numeric or string).  {cmd:datadictionary} adds a per-wave
missingness grid (variable {c 215} wave, % missing) to the display and, with
{cmd:excel()}, a {cmd:Missingness} sheet.  Presence in a wave means the
variable has at least one nonmissing value in that wave.  A variable that is
all-missing within a wave is reported as {cmd:absent}, meaning
{it:absent or never answered}: in a stitched file the two cannot be
distinguished, because a variable that was not fielded in a wave and a
variable that was fielded but never answered both appear as all-missing
rows.{p_end}

{dlgtab:Files mode}

{phang}{cmd:files(}{it:"f1 f2 ..."}{cmd:)} lists the wave .dta files,
space-separated and in wave order; quote filenames that contain spaces.
Each file is one wave.{p_end}

{phang}{cmd:folder(}{it:dirpath}{cmd:)} takes the wave files from a folder.
Files matching {cmd:pattern()} are sorted by filename and treated as waves in
that order, so a sortable naming scheme ({cmd:w1_}..., {cmd:2019_}...) gives
the right wave order.{p_end}

{phang}{cmd:pattern(}{it:str}{cmd:)} is the filename pattern for
{cmd:folder()}; the default is {cmd:*.dta}.{p_end}

{phang}{cmd:wavenames(}{it:"n1 n2 ..."}{cmd:)} supplies display names for the
waves (for example {cmd:wavenames("2019 2021 2023")}), one per file, used in
the display, the {cmd:wave} column, the {cmd:Changes} wave-pairs, and the
{cmd:Missingness} column headers.  The default is each file's basename
without the extension.{p_end}

{dlgtab:Shared}

{phang}{cmd:excel(}{it:filename}{cmd:)} writes a multi-sheet .xlsx workbook;
see {help datadictionary##output:Output} below.  {cmd:.xlsx} is appended when no
extension is given.{p_end}

{phang}{cmd:saving(}{it:filename}{cmd:)} saves the codebook itself as a
Stata dataset, one row per variable (per variable-wave in files mode) - the
descsave-style machine-readable product.  {cmd:.dta} is appended when no
extension is given.{p_end}

{phang}{cmd:replace} permits overwriting; without it an existing
{cmd:excel()} or {cmd:saving()} file stops the command with error 602.{p_end}

{phang}{cmd:examples(}{it:#}{cmd:)} sets how many distinct example values are
reported for string variables (comma-separated, in sorted order); the default
is 3.{p_end}

{phang}{cmd:top(}{it:#}{cmd:)} sets how many top categories by frequency are
reported for value-labeled variables, each as {it:label (n, pct%)}; the
default is 5.{p_end}

{phang}{cmd:nochars} skips characteristics entirely: neither the
{cmd:srctag} column (harvested from {cmd:char} {it:varname}{cmd:[srctag]},
written by the author's {cmd:combineall}/{cmd:projectbuilder} tools) nor the
{cmd:chars} column (all other characteristics, concatenated as
{it:name=value} pairs) is filled.{p_end}

{phang}{cmd:nonotes} skips stored {help notes}.{p_end}


{marker output}{...}
{title:Output}

{pstd}The default output is a compact formatted display: a per-variable table
(grouped by wave in files mode), the list of detected changes (files mode),
and the per-wave missingness grid (files mode, or in-memory mode with
{cmd:wave()}).  {cmd:excel(}{it:filename}{cmd:)} writes:{p_end}

{p2colset 8 26 28 2}{...}
{p2col :{cmd:Overview}}source file(s), N and variable count per wave, generation date, notes count, changes count{p_end}
{p2col :{cmd:Variables}}the per-variable codebook rows; in files mode includes a {cmd:wave} column{p_end}
{p2col :{cmd:ValueLabels}}label name, value, label text; per wave in files mode{p_end}
{p2col :{cmd:Changes}}files mode only; one row per detected change: wave-pair, variable, change type, before, after{p_end}
{p2col :{cmd:Missingness}}files mode or {cmd:wave()}; variable {c 215} wave grid of % missing ({cmd:absent} = not present, or never answered){p_end}
{p2colreset}{...}

{pstd}Header rows are written in bold via {help putexcel}.  Value-label text
longer than 80 characters is truncated in the {cmd:ValueLabels} sheet and in
the change-detection signatures (a {help uselabel} limit); truncation is
applied identically in every wave, so change detection is unaffected.{p_end}


{marker results}{...}
{title:Stored results}

{pstd}{cmd:datadictionary} stores the following in {cmd:r()}:{p_end}
{synoptset 16 tabbed}{...}
{synopt :{cmd:r(nvars)}}number of codebook rows: variables documented (variable-waves in files mode){p_end}
{synopt :{cmd:r(nchanges)}}number of changes detected across waves (0 outside files mode){p_end}
{synopt :{cmd:r(xlsx)}}path of the Excel workbook written (only with {cmd:excel()}){p_end}
{synopt :{cmd:r(dta)}}path of the codebook dataset written (only with {cmd:saving()}){p_end}
{p2colreset}{...}


{marker examples}{...}
{title:Examples}

{pstd}Document the dataset in memory:{p_end}

{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. datadictionary}{p_end}
{phang2}{cmd:. datadictionary, excel(auto_codebook) saving(auto_codebook) replace}{p_end}
{phang2}{cmd:. return list}{p_end}

{pstd}Document a stitched three-wave file, with per-wave missingness:{p_end}

{phang2}{cmd:. datadictionary, wave(wave) excel(stitched_codebook) replace}{p_end}

{pstd}Document three wave files and detect what changed across waves:{p_end}

{phang2}{cmd:. datadictionary, files("staff_w1.dta staff_w2.dta staff_w3.dta") wavenames("2019 2021 2023") excel(staff_codebook) saving(staff_codebook) replace}{p_end}

{pstd}The same, taking every .dta in a folder (sorted by filename):{p_end}

{phang2}{cmd:. datadictionary, folder("waves") pattern("staff_*.dta") excel(staff_codebook) replace}{p_end}


{marker remarks}{...}
{title:Remarks}

{pstd}
{bf:Why files mode exists.}  Change detection across waves is only possible
in files mode, because stitching waves into one file destroys per-wave value
labels.  When wave files are appended, only one definition per value-label
name survives, so a category set that was extended or relabeled between waves
is no longer recoverable from the combined file.  Run {cmd:datadictionary} over the
original wave files, before or alongside stitching, to keep that history.

{pstd}
{bf:Absent or never answered.}  In the per-wave missingness grid, a variable
that is all-missing within a wave is reported as {cmd:absent}.  In a stitched
file this means {it:absent or never answered}: a variable that was not
fielded that wave and one that was fielded but never answered cannot be
distinguished.  In files mode, {cmd:absent} means the variable is not in that
wave's file.

{pstd}
{bf:What counts as a change.}  Consecutive waves are compared.  A variable
missing from one wave's file and present in the next is {cmd:added}; the
reverse is {cmd:dropped}.  For variables present in both waves, the storage
type, display format, variable label, and value-label set (attached label
name plus its full value/text content) are compared; each difference is one
row in the {cmd:Changes} output, with the before and after values.

{pstd}
{bf:Sample restriction.}  In-memory mode documents the selected subsample:
rows excluded by {cmd:if}/{cmd:in} do not contribute to N, missingness,
statistics, or examples.  Selecting an empty sample stops the command with
error 2000.


{marker related}{...}
{title:Related work}

{pstd}
Roger Newson's {cmd:descsave} (SSC) exports variable-level attributes to a
dataset or do-file; {cmd:datadictionary} adds over-time change detection,
missingness patterns, example values, and the notes/chars/srctag harvest.
Kishor Das's {cmd:codebookout} (SSC) writes a one-dataset codebook to
Excel; {cmd:datadictionary} adds the multi-wave file comparison and multi-sheet
workbook (value labels, changes, missingness).  Built-in {help codebook}
prints a rich per-variable report but stores no machine-readable product;
{cmd:datadictionary} writes one ({cmd:saving()}) plus the Excel workbook, and
tracks how the file changes across waves.


{title:Author}

{pstd}
Eric A. Booth, Sr Researcher, Texas 2036, 2026.
Support: eric.a.booth@gmail.com.  MIT-licensed.
