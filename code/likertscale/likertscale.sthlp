{smcl}
{* *! version 1.0.0  28jul2026}{...}
{title:Title}

{p2colset 5 20 22 2}{...}
{p2col :{cmd:likertscale} {hline 2}}Scale construction in one auditable step: index, alpha, percent-agree{p_end}
{p2colreset}{...}

{title:Syntax}

{p 8 16 2}
{cmd:likertscale} {varlist} {ifin}{cmd:,}
[{opt ag:ree(numlist)} {opt gens:tub(stub)} {opt ind:ex(newvar)} {opt noal:pha} {opt norep:ort}]

{title:Description}

{pstd}
{cmd:likertscale} performs the three moves every Likert battery needs, in one
command a reviewer can audit: a row-mean index across the items, Cronbach's
alpha for the battery, and one labeled 0/100 percent-agree companion per item
(top-two-box by default, detected from the items' observed range), the
variables a program audience actually reads.  The report warns when alpha
falls below the 0.70 research floor or above the 0.95 redundancy ceiling.

{title:Options}

{phang}{opt agree(numlist)} names the response values that count as agreement; default is the top two points of the observed range.{p_end}
{phang}{opt genstub(stub)} prefixes the percent-agree variables; default {cmd:agree}.{p_end}
{phang}{opt index(newvar)} names the row-mean index; default {cmd:scaleindex}.{p_end}
{phang}{opt noalpha} skips the reliability step.{p_end}

{title:Example}

{phang2}{cmd:. likertscale q1 q2 q3 q4 q5, agree(4 5)}{p_end}

{title:Stored results}

{synoptset 18 tabbed}{...}
{p2col 5 18 22 2: Scalars}{p_end}
{synopt:{cmd:r(N)}, {cmd:r(items)}, {cmd:r(alpha)}}sample, item count, reliability{p_end}
{p2col 5 18 22 2: Macros}{p_end}
{synopt:{cmd:r(agree)}, {cmd:r(index)}, {cmd:r(agreevars)}}settings and variables built{p_end}

{title:Author}

{pstd}Eric A. Booth.  Companion tool to {it:Applied Program Evaluation Using Stata}.
