{smcl}
{* *! version 1.0.0  28jul2026}{...}
{title:Title}

{p2colset 5 18 20 2}{...}
{p2col :{cmd:llmsieve} {hline 2}}Convergence delta between two LLM passes; route unstable rows to human review{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 16 2}
{cmd:llmsieve} {it:strvar1} {it:strvar2} {ifin}{cmd:,}
[{opt thres:hold(#)} {opt gend:elta(newvar)} {opt genf:lag(newvar)} {opt norep:ort}]


{title:Description}

{pstd}
A hosted LLM returns an answer but not its confidence.  {cmd:llmsieve}
measures uncertainty from behavior instead: given two passes over the same
input (one LLM refining another, or two models answering independently), it
computes the {it:convergence delta} for each row, the Levenshtein edit
distance between the two answers divided by the length of the longer one, so
0 means identical and 1 means nothing survived.  Rows whose delta exceeds
{opt threshold()} are the unstable cases, the ones to spend human review on.

{pstd}
A low delta certifies {it:stability}, not correctness: two LLMs that share
training data can agree confidently on the same wrong answer.  Keep a
gold-standard kappa in the design.


{title:Options}

{phang}{opt threshold(#)} sets the routing cut; default {cmd:0.15}.{p_end}
{phang}{opt gendelta(newvar)} saves each row's delta.{p_end}
{phang}{opt genflag(newvar)} marks rows above the threshold.{p_end}
{phang}{opt noreport} suppresses the summary.{p_end}


{title:Example}

{phang2}{cmd:. llmsieve answer_pass1 answer_pass2, gendelta(delta) genflag(review)}{p_end}


{title:Stored results}

{synoptset 18 tabbed}{...}
{p2col 5 18 22 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}rows compared{p_end}
{synopt:{cmd:r(flagged)}}rows routed to review{p_end}
{synopt:{cmd:r(mean)}, {cmd:r(max)}}delta summary{p_end}
{synopt:{cmd:r(threshold)}}threshold used{p_end}


{title:Author}

{pstd}Eric A. Booth.  Companion tool to {it:Applied Program Evaluation Using Stata}.
