{smcl}
{* *! version 1.0.0  28jul2026}{...}
{title:Title}

{p2colset 5 17 19 2}{...}
{p2col :{cmd:rawsweep} {hline 2}}Manifest of an intake folder, with a PII flag per file{p_end}
{p2colreset}{...}

{title:Syntax}

{p 8 16 2}{cmd:rawsweep ,} {opt dir:ectory(path)} [{opt pat:terns(string)} {cmd:pii} {opt sam:ple(#)} {opt sav:ing(filename)} {cmd:replace} {cmd:clear}]

{title:Description}

{pstd}
Files that land in a shared intake folder deserve a triage read before
anything imports them.  {cmd:rawsweep} builds a one-row-per-file manifest
(name, extension, bytes), calls out zero-byte files, failed downloads
wearing success flags, and with {cmd:pii} scans each file's first
{opt sample(#)} rows (default 25) against the same six likely-PII pattern
classes as {helpb ai_privacy_gate}, so protected fields are caught at the
door rather than three merges later.  The manifest becomes the dataset in memory ({cmd:clear} required when data are present) and is optionally written with {opt saving()}.

{title:Example}

{phang2}{cmd:. rawsweep, directory("raw/intake") pii saving("raw/manifest.csv") replace clear}{p_end}

{title:Stored results}

{synoptset 16 tabbed}{...}
{p2col 5 16 20 2: Scalars}{p_end}
{synopt:{cmd:r(files)}, {cmd:r(flagged)}}files found; files with PII hits{p_end}

{title:Author}

{pstd}Eric A. Booth.  Companion tool to {it:Applied Program Evaluation Using Stata}.
