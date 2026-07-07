{smcl}
{* *! version 0.1.0  2026-07-06}{...}
{viewerjumpto "Syntax" "hlmr2##syntax"}{...}
{viewerjumpto "Description" "hlmr2##description"}{...}
{viewerjumpto "Options" "hlmr2##options"}{...}
{viewerjumpto "Stored results" "hlmr2##results"}{...}
{viewerjumpto "Examples" "hlmr2##examples"}{...}
{viewerjumpto "Remarks" "hlmr2##remarks"}{...}
{viewerjumpto "References" "hlmr2##references"}{...}

{title:Title}

{p2colset 5 15 17 2}{...}
{p2col :{cmd:hlmr2} {hline 2}}Nakagawa marginal and conditional R-squared after {helpb mixed}{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:hlmr2} [{cmd:,} {it:options}]

{synoptset 22 tabbed}{...}
{synopthdr}
{synoptline}
{synopt :{cmd:nodisplay}}suppress the output table; results are still stored in {cmd:r()}{p_end}
{synopt :{cmd:format(}{it:%fmt}{cmd:)}}display format for the table; default is {cmd:format(%9.4f)}{p_end}
{synopt :{cmd:variance}}read the variance-metric table from {cmd:estat sd, variance}; results are identical{p_end}
{synoptline}

{pstd}
{cmd:hlmr2} is a postestimation command: run it immediately after
{helpb mixed}, with no arguments beyond the options above.


{marker description}{...}
{title:Description}

{pstd}
{cmd:hlmr2} computes the marginal and conditional R-squared of
Nakagawa and Schielzeth (2013) for a linear multilevel (mixed-effects)
model fit by {helpb mixed}.  The {bf:marginal} R-squared is the share of
total outcome variance explained by the fixed effects alone; the
{bf:conditional} R-squared is the share explained by the fixed and
random effects together.  Both are built from three pieces: the variance
of the fixed-portion linear predictor over the estimation sample, the sum
of the random-effect variance components, and the residual variance.

{pstd}
The variance components are read from {cmd:estat sd}, and {cmd:hlmr2}
accepts either the {cmd:sd(...)} or the {cmd:var(...)} parameter labels
that different Stata versions produce, so the same do-file works across
versions.  Models with one or more nested random-effects levels are
supported (for example, students within schools within districts).

{pstd}
If the last estimates in memory are not from {cmd:mixed}, {cmd:hlmr2}
exits with error 301.


{marker options}{...}
{title:Options}

{phang}{cmd:nodisplay} suppresses the printed table.  All results remain
available in {cmd:r()}, which is useful inside loops or when collecting
fit statistics across many models.{p_end}

{phang}{cmd:format(}{it:%fmt}{cmd:)} sets the numeric display format for
the printed table, for example {cmd:format(%12.6f)}.  It affects the
display only, not the stored results.{p_end}

{phang}{cmd:variance} makes {cmd:hlmr2} request the variance-metric table
({cmd:estat sd, variance}, whose parameters are labeled {cmd:var(...)})
instead of the standard-deviation table (labeled {cmd:sd(...)}).  The two
tables carry the same information and {cmd:hlmr2} parses both labelings,
so the results are identical; the option exists to verify that behavior
across Stata versions.{p_end}


{marker results}{...}
{title:Stored results}

{pstd}{cmd:hlmr2} stores in {cmd:r()}:{p_end}
{synoptset 14 tabbed}{...}
{synopt :{cmd:r(r2_m)}}marginal R-squared (fixed effects only){p_end}
{synopt :{cmd:r(r2_c)}}conditional R-squared (fixed plus random effects){p_end}
{synopt :{cmd:r(var_f)}}variance of the fixed-portion linear predictor{p_end}
{synopt :{cmd:r(var_ran)}}sum of the random-effect variance components{p_end}
{synopt :{cmd:r(var_e)}}residual variance{p_end}
{synopt :{cmd:r(N)}}number of observations in the estimation sample{p_end}
{synopt :{cmd:r(depvar)}}name of the dependent variable (macro){p_end}
{p2colreset}{...}


{marker examples}{...}
{title:Examples}

{pstd}Two-level model: wages of women within industries:{p_end}
{phang2}{cmd:. sysuse nlsw88, clear}{p_end}
{phang2}{cmd:. mixed wage grade age || industry:}{p_end}
{phang2}{cmd:. hlmr2}{p_end}

{pstd}Store the results for later use:{p_end}
{phang2}{cmd:. hlmr2, nodisplay}{p_end}
{phang2}{cmd:. display "Marginal R2 = " r(r2_m) ", Conditional R2 = " r(r2_c)}{p_end}

{pstd}Three-level model on simulated data (units within districts within
regions), with a wider display format:{p_end}
{phang2}{cmd:. clear}{p_end}
{phang2}{cmd:. set seed 20260706}{p_end}
{phang2}{cmd:. set obs 30}{p_end}
{phang2}{cmd:. generate region = _n}{p_end}
{phang2}{cmd:. generate u_r = rnormal(0, 1.5)}{p_end}
{phang2}{cmd:. expand 10}{p_end}
{phang2}{cmd:. bysort region: generate district = _n}{p_end}
{phang2}{cmd:. generate u_d = rnormal(0, 1)}{p_end}
{phang2}{cmd:. expand 8}{p_end}
{phang2}{cmd:. generate x = rnormal()}{p_end}
{phang2}{cmd:. generate y = 1 + 0.5*x + u_r + u_d + rnormal()}{p_end}
{phang2}{cmd:. mixed y x || region: || district:}{p_end}
{phang2}{cmd:. hlmr2, format(%12.6f)}{p_end}


{marker remarks}{...}
{title:Remarks}

{pstd}
{bf:Intercept-only models and the ICC.}  In a model with no covariates,
the fixed-portion variance is zero, so the marginal R-squared is zero and
the conditional R-squared equals the intraclass correlation (compare
{cmd:estat icc}).  This is a useful check that the pieces are being
combined correctly.

{pstd}
{bf:Random slopes.}  When the model includes random slopes, {cmd:hlmr2}
sums the random-effect variance components and ignores their covariances.
This is an approximation: the exact Nakagawa formula for random-slope
models weights the components by the covariate values (Johnson 2014).
{cmd:hlmr2} prints a note when it detects random slopes.  Version 0.1.0
does not implement the Johnson (2014) correction.

{pstd}
{bf:Linear models only.}  {cmd:hlmr2} supports {helpb mixed} (linear
mixed models).  It does not support {cmd:melogit}, {cmd:mepoisson}, or
other generalized linear mixed models, whose R-squared requires a
distribution-specific residual variance term.


{marker references}{...}
{title:References}

{phang}
Nakagawa, S., and H. Schielzeth.  2013.  A general and simple method for
obtaining R-squared from generalized linear mixed-effects models.
{it:Methods in Ecology and Evolution} 4(2): 133-142.{p_end}

{phang}
Johnson, P. C. D.  2014.  Extension of Nakagawa & Schielzeth's
R-squared(GLMM) to random slopes models.
{it:Methods in Ecology and Evolution} 5(9): 944-946.{p_end}


{title:Author}

{pstd}
Eric A. Booth, Sr Researcher, Texas 2036 (eric.a.booth@gmail.com), 2026.
MIT-licensed.{p_end}
