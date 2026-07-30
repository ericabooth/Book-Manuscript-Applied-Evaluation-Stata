{smcl}
{* *! version 1.0.0  29jul2026}{...}
{title:Title}

{p2colset 5 22 24 2}{...}
{p2col :{cmd:surveytracker} {hline 2}}Launch-day metadata snapshot, appended to a running instrument tracker{p_end}
{p2colreset}{...}

{title:Syntax}

{p 8 16 2}
{cmd:surveytracker} {cmd:using} {it:trackerfile}{cmd:,} {opt wave(text)} [{opt var:list(varlist)}]

{title:Description}

{pstd}
Platforms let an editor reword a question mid-field, and the wording your
December respondents saw is recoverable only if the launch pull saved it.
{cmd:surveytracker} snapshots the data in memory {hline 2} variable names,
variable labels, value-label names and text, types, formats {hline 2} as one
block of rows tagged {opt wave()}, appended to {it:trackerfile} (created on
first use).  {helpb cxchangelog} diffs the waves when the next one lands.

{pstd}
A snapshot is a record, not a draft: re-logging an existing wave is refused
(error 110), with no override.  Removing a wave's rows is a deliberate,
visible act on the tracker file itself.

{title:Stored results}

{synoptset 14 tabbed}{...}
{p2col 5 14 18 2: Scalars}{p_end}
{synopt:{cmd:r(vars)}}variables logged{p_end}
{p2col 5 14 18 2: Macros}{p_end}
{synopt:{cmd:r(wave)}}wave tag{p_end}

{title:Author}

{pstd}Eric A. Booth.  Companion tool to {it:Applied Program Evaluation Using Stata}.
