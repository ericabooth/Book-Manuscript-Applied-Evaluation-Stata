{smcl}
{* *! version 1.0.0  29jul2026}{...}
{title:Title}

{p2colset 5 20 22 2}{...}
{p2col :{cmd:nonresponse} {hline 2}}Frame-vs-respondent diagnosis, response model, and raking weights{p_end}
{p2colreset}{...}

{title:Syntax}

{p 8 16 2}
{cmd:nonresponse} {it:respvar} {ifin}{cmd:,} {opt fr:ame(varlist)}
[{opt gen:erate(newvar)} {opt tol:erance(#)} {opt iter:ate(#)} {opt nomod:el} {opt norep:ort}]

{p 4 6 2}
Run on the sampling frame with {it:respvar} = 1 for responders, 0 otherwise;
{opt frame()} names the categorical variables the frame is trusted on.

{title:Description}

{pstd}
{cmd:nonresponse} answers the question a response rate cannot: do the people
who answered differ from the frame they were drawn from?  It tabulates
respondent versus frame shares for every category of every {opt frame()}
variable, fits the response model (a logit of responding on the frame
variables, shown, not hidden), and with {opt generate()} rakes the
responding cases to the frame margins by iterative proportional fitting
{hline 2} weights normalized to mean 1, convergence enforced.

{pstd}
It refuses loudly rather than guessing: a category with zero responders
cannot be raked back into the sample (error 459), and non-convergence is an
error, not a warning.  Report the headline weighted and unweighted, always.

{title:Stored results}

{synoptset 18 tabbed}{...}
{p2col 5 18 22 2: Scalars}{p_end}
{synopt:{cmd:r(N_frame)}, {cmd:r(N_resp)}}frame and responder counts{p_end}
{synopt:{cmd:r(maxgap)}}largest signed gap, pp{p_end}
{synopt:{cmd:r(iters)}, {cmd:r(wmin)}, {cmd:r(wmax)}}raking convergence and weight range{p_end}
{p2col 5 18 22 2: Matrices}{p_end}
{synopt:{cmd:r(table)}}respondent %, frame %, gap by category{p_end}

{title:Author}

{pstd}Eric A. Booth.  Companion tool to {it:Applied Program Evaluation Using Stata}.
