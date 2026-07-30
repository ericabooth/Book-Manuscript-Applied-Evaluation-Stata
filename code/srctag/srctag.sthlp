{smcl}
{* *! version 1.0.0  28jul2026}{...}
{title:Title}

{p2colset 5 16 18 2}{...}
{p2col :{cmd:srctag} {hline 2}}Stamp variables with source lineage; {cmd:srcfind} searches it{p_end}
{p2colreset}{...}

{title:Syntax}

{p 8 16 2}{cmd:srctag} {varlist}{cmd:,} {opt so:urce(text)} [{opt v:intage(text)} {opt note:s(text)} {cmd:replace}]

{p 8 16 2}{cmd:srcfind} [{it:pattern}] [{cmd:,} {opt so:urce(text)} {cmd:all} {opt norep:ort}]

{title:Description}

{pstd}
{cmd:srctag} writes a variable's origin into its {it:source} characteristic,
the metadata slot that survives {cmd:save} and travels with the dataset, so
six months later {cmd:srcfind dealer} answers {cmd:"}which variables came
from the dealer file?{cmd:"} without archaeology.  {cmd:srctag} refuses to
overwrite an existing tag unless told {cmd:replace}, so lineage cannot be
lost silently.  {cmd:srcfind} matches case-insensitively on any part of the
tag and returns the matching variables in {cmd:r(varlist)}.

{title:Examples}

{phang2}{cmd:. srctag q1-q10, source(2026 caregiver survey) vintage(wave 3)}{p_end}
{phang2}{cmd:. srcfind caregiver}{p_end}

{title:Author}

{pstd}Eric A. Booth.  Companion tool to {it:Applied Program Evaluation Using Stata}.
