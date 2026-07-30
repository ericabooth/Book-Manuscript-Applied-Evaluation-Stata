{smcl}
{* *! version 1.0.0  28jul2026}{...}
{title:Title}

{p2colset 5 18 20 2}{...}
{p2col :{cmd:faircheck} {hline 2}}Group-wise error audit of a binary prediction{p_end}
{p2colreset}{...}

{title:Syntax}

{p 8 16 2}
{cmd:faircheck} {it:truthvar} {it:predvar} {ifin}{cmd:,} {opt by(groupvar)} [{opt norep:ort}]

{title:Description}

{pstd}
A prediction that is accurate on average can still make its errors unevenly.
{cmd:faircheck} tabulates, for each group of {opt by()}: N, the base rate,
the true-positive rate (of the people who truly qualify, how many the tool
finds), the false-positive rate (of those who do not, how many it wrongly
flags), and precision, then reports the largest cross-group gap in TPR and
FPR.  Both variables must be 0/1.  The closing line states the fact every
audit conversation needs: when base rates differ across groups, equal TPR
and equal FPR cannot both hold, so the choice of which error to equalize is
a policy decision to make openly.

{title:Example}

{phang2}{cmd:. faircheck completed flagged, by(race)}{p_end}

{title:Stored results}

{synoptset 18 tabbed}{...}
{p2col 5 18 22 2: Scalars}{p_end}
{synopt:{cmd:r(N)}, {cmd:r(groups)}}sample and group count{p_end}
{synopt:{cmd:r(tpr_gap)}, {cmd:r(fpr_gap)}}largest cross-group gaps{p_end}
{p2col 5 18 22 2: Matrices}{p_end}
{synopt:{cmd:r(table)}}N, base rate, TPR, FPR, precision by group{p_end}

{title:Author}

{pstd}Eric A. Booth.  Companion tool to {it:Applied Program Evaluation Using Stata}.
