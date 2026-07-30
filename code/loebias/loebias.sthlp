{smcl}
{* *! version 1.0.0  29jul2026}{...}
{title:Title}

{p2colset 5 16 18 2}{...}
{p2col :{cmd:loebias} {hline 2}}Level-of-effort sensitivity: does the estimate settle as later attempts arrive?{p_end}
{p2colreset}{...}

{title:Syntax}

{p 8 16 2}
{cmd:loebias} {it:outcomevar} {ifin}{cmd:,} {opt att:empts(varname)}
[{opt thres:hold(#)} {opt gr:aph} {opt graphn:ame(name)} {opt norep:ort}]

{title:Description}

{pstd}
The respondents who needed five calls are the closest available stand-ins
for the people who never answered.  {cmd:loebias} computes the cumulative
estimate of {it:outcomevar} as each attempt level is folded in, reports the
last-step change, and calls the series stable when that change is under
{opt threshold()} (default 0.5, in percentage points for 0/1 outcomes).
A drifting series says the reluctant differ: treat the final number as
provisional and pair it with a frame comparison ({helpb nonresponse},
{helpb reachcheck}).

{pstd}
It requires a real contact-attempts variable with at least three levels and
refuses otherwise: arrival order is not effort, and the command does not
accept it as a substitute.

{title:Stored results}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(levels)}, {cmd:r(final)}}effort levels; full-sample estimate{p_end}
{synopt:{cmd:r(last_change)}, {cmd:r(stable)}}last-step change; verdict{p_end}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(table)}}k, N, cumulative estimate{p_end}

{title:Author}

{pstd}Eric A. Booth.  Companion tool to {it:Applied Program Evaluation Using Stata}.
