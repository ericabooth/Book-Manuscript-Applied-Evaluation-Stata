{smcl}
{* *! version 0.1.1  2026-07-06}{...}
{viewerjumpto "Syntax" "rateshrink##syntax"}{...}
{viewerjumpto "Description" "rateshrink##description"}{...}
{viewerjumpto "Options" "rateshrink##options"}{...}
{viewerjumpto "Methods" "rateshrink##methods"}{...}
{viewerjumpto "Stored results" "rateshrink##results"}{...}
{viewerjumpto "Examples" "rateshrink##examples"}{...}
{viewerjumpto "Remarks" "rateshrink##remarks"}{...}

{title:Title}

{p2colset 5 19 21 2}{...}
{p2col :{cmd:rateshrink} {hline 2}}Empirical-Bayes shrinkage for noisy small-denominator rates{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:rateshrink} {ifin}{cmd:,} {opth s:uccess(varname)} {opth d:enominator(varname)}
{opth gen:erate(newvar)} [{it:options}]

{synoptset 24 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Required}
{synopt :{opth s:uccess(varname)}}numerator: successes (counts) per unit{p_end}
{synopt :{opth d:enominator(varname)}}denominator: trials ({cmd:ebbeta}) or exposure ({cmd:ebgamma}){p_end}
{synopt :{opth gen:erate(newvar)}}new variable to hold the shrunken rates{p_end}

{syntab :Optional}
{synopt :{cmd:type(}{it:ebbeta}|{it:ebgamma}{cmd:)}}shrinkage model; default is {cmd:ebbeta}{p_end}
{synopt :{opt ci(#)}}also generate {it:newvar}{cmd:_lb} and {it:newvar}{cmd:_ub}, the {it:#}% equal-tailed posterior interval{p_end}
{synopt :{opth id(varname)}}unit identifier used to label the most-moved unit in the summary line{p_end}
{synopt :{opth rel(newvar)}}also generate each unit's Beta-binomial reliability, {it:n}/({it:n} + alpha + beta); {cmd:type(ebbeta)} only{p_end}
{synoptline}


{marker description}{...}
{title:Description}

{pstd}
{cmd:rateshrink} stabilizes rates computed on small denominators.  Raw rates
from units with few cases are noisy by construction: a single event at a
five-person site can send it to the top or bottom of a ranking even though
the estimate carries almost no information.  {cmd:rateshrink} pulls each
unit's raw rate toward the overall mean in proportion to how little data
supports it, so a unit with 5 cases is nudged hard toward the average while
a unit with 500 barely moves.  The result is a set of rates stable enough
for dashboards, rankings, and benchmarking.

{pstd}
Two models are available.  {cmd:type(ebbeta)} (the default) is Beta-binomial
shrinkage for proportions, where {cmd:success()} out of {cmd:denominator()}
trials is a fraction between 0 and 1.  {cmd:type(ebgamma)} is Poisson-gamma
shrinkage for event rates with exposure denominators (events per
person-year, per 1,000 residents, and so on), where {cmd:success()} may
exceed {cmd:denominator()}.  In both cases the prior is estimated from the
data by the method of moments, and each shrunken rate is the posterior mean:
an exact precision-weighted blend of the unit's own raw rate and the grand
mean.

{pstd}
After running, {cmd:rateshrink} prints the estimated prior and a one-line
summary of the largest move (max |raw − shrunken|) and which unit moved
most.  Large moves always belong to small denominators; that is the method
working as intended.


{marker options}{...}
{title:Options}

{phang}{opth success(varname)} and {opth denominator(varname)} name the
numerator and denominator.  Both must be nonnegative and the denominator
strictly positive.  Under {cmd:type(ebbeta)}, {cmd:success()} must not
exceed {cmd:denominator()}; if your data are event counts against exposure,
use {cmd:type(ebgamma)} instead.{p_end}

{phang}{opth generate(newvar)} names the new variable for the shrunken
rates.  It must not already exist.  With {cmd:ci()}, {it:newvar}{cmd:_lb}
and {it:newvar}{cmd:_ub} must also be new.{p_end}

{phang}{cmd:type(ebbeta)} fits a Beta(alpha, beta) prior to the observed
proportions and returns the Beta-binomial posterior mean
(y + alpha)/(n + alpha + beta).
{cmd:type(ebgamma)} fits a Gamma(alpha, beta) prior (rate
parameterization) to the observed rates and returns the Poisson-gamma
posterior mean (y + alpha)/(E + beta), with E the exposure.{p_end}

{phang}{opt ci(#)} generates the equal-tailed {it:#}% posterior interval
for each unit.  For {cmd:ebbeta} the posterior is
Beta(y + alpha, n − y + beta) and quantiles come from {helpb invibeta()};
for {cmd:ebgamma} the posterior is Gamma(y + alpha, rate E + beta) and
quantiles come from {helpb invgammap()}.  {it:#} is a level such as 90 or
95.{p_end}

{phang}{opth id(varname)} labels the most-moved unit in the summary line
with that variable's value (string or numeric) instead of the observation
number.{p_end}

{phang}{opth rel(newvar)} generates each unit's Beta-binomial reliability,
{it:n}/({it:n} + alpha + beta), using the estimated prior.  It equals the
weight the posterior mean places on the unit's own data, so it lies in
(0, 1] and rises with the denominator.  Available only with
{cmd:type(ebbeta)}; with {cmd:type(ebgamma)}, {cmd:rel()} exits with
error 198 because this reliability statistic is defined under the
Beta-binomial model.  The mean reliability is stored in
{cmd:r(meanrel)}.{p_end}


{marker methods}{...}
{title:Methods}

{pstd}
{bf:Beta-binomial (type(ebbeta)).}  Let p-bar and s2 be the unweighted mean
and variance of the raw proportions, and let v-bar be the average binomial
sampling variance p-bar(1 − p-bar)/n across units.  The between-unit
variance is estimated as tau2 = max(s2 − v-bar, 1e−6), the prior sample
size as M = p-bar(1 − p-bar)/tau2 − 1, and the prior parameters as
alpha = M·p-bar and beta = M·(1 − p-bar).  Every unit is treated as if it
carried an extra M cases pinned at the grand mean.  If M is not positive
(the observed variance is at or beyond the binomial ceiling),
{cmd:rateshrink} falls back to a uniform prior (alpha = beta = 1) and says
so.

{pstd}
{bf:Poisson-gamma (type(ebgamma)).}  The grand rate r-bar is
exposure-weighted (total events / total exposure).  The between-unit
variance is the Marshall (1991) moment estimator: the exposure-weighted
variance of the raw rates minus the expected Poisson sampling variance
r-bar/E-bar, where E-bar is the mean exposure.  The prior is then
beta = r-bar/tau2 and alpha = r-bar·beta, so the prior mean is r-bar and
each unit is treated as if it carried an extra beta units of exposure at
the grand rate.  If no between-unit variance is detectable, rates shrink
almost fully to the grand rate and a note is printed.

{pstd}
In both models the posterior mean lies exactly between the raw rate and the
prior mean, with weight n/(n + M) (or E/(E + beta)) on the unit's own data.

{pstd}
{bf:Methods and references.}  Under the Beta-binomial model, the weight a
unit's own data receives, n/(n + alpha + beta), is the same number as a
CTT-coherent reliability statistic for that unit, so the shrinkage factor
{cmd:rateshrink} applies and the reliability {cmd:rel()} reports are one
and the same quantity.  This identity, and the case for it as a more stable
alternative to the Adams (2009) signal-to-noise approach used in provider
profiling, is developed in Field, S., Dong, F., Booth, E., Hastings, P.,
and Malone, P. (2026, pre-print under review), "Rethinking
'Signal-To-Noise': A Coherent Beta-Binomial Reliability Formulation for
Assessing Quality Measures," Far Harbor, LLC.  Replication materials:
{browse "https://github.com/ericabooth/BetaBinomialPaperMaterials"}.


{marker results}{...}
{title:Stored results}

{pstd}{cmd:rateshrink} stores in {cmd:r()}:{p_end}
{synoptset 16 tabbed}{...}
{synopt :{cmd:r(N)}}number of units used{p_end}
{synopt :{cmd:r(alpha)}}estimated prior alpha{p_end}
{synopt :{cmd:r(beta)}}estimated prior beta{p_end}
{synopt :{cmd:r(mean)}}prior mean (the shrinkage target){p_end}
{synopt :{cmd:r(maxmove)}}max |raw − shrunken| across units{p_end}
{synopt :{cmd:r(meanrel)}}mean Beta-binomial reliability (only with {cmd:rel()}){p_end}
{synopt :{cmd:r(type)}}shrinkage model used: {cmd:ebbeta} or {cmd:ebgamma}{p_end}
{synopt :{cmd:r(maxunit)}}label of the unit that moved most{p_end}
{synopt :{cmd:r(generate)}}name of the generated variable{p_end}
{p2colreset}{...}


{marker examples}{...}
{title:Examples}

{pstd}Proportions: 50 simulated sites, caseloads 5 to 500, completion rates
near 0.20{p_end}

{phang2}{cmd:. clear}{p_end}
{phang2}{cmd:. set seed 20260706}{p_end}
{phang2}{cmd:. set obs 50}{p_end}
{phang2}{cmd:. gen site  = _n}{p_end}
{phang2}{cmd:. gen n     = 5 + int(495*runiform()^2)}{p_end}
{phang2}{cmd:. gen ptrue = rbeta(8, 32)}{p_end}
{phang2}{cmd:. gen y     = rbinomial(n, ptrue)}{p_end}
{phang2}{cmd:. rateshrink, success(y) denominator(n) generate(pshrunk) id(site)}{p_end}
{phang2}{cmd:. return list}{p_end}

{pstd}Add a 95% posterior interval{p_end}

{phang2}{cmd:. rateshrink, success(y) denominator(n) generate(pshrunk2) ci(95)}{p_end}

{pstd}Also report each site's Beta-binomial reliability{p_end}

{phang2}{cmd:. rateshrink, success(y) denominator(n) generate(pshrunk3) rel(reliab)}{p_end}
{phang2}{cmd:. display r(meanrel)}{p_end}

{pstd}Event rates with exposure: county incidents per person-year{p_end}

{phang2}{cmd:. clear}{p_end}
{phang2}{cmd:. set obs 30}{p_end}
{phang2}{cmd:. gen county = _n}{p_end}
{phang2}{cmd:. gen pyears = 20 + int(2000*runiform()^2)}{p_end}
{phang2}{cmd:. gen mu     = rgamma(4, .05)}{p_end}
{phang2}{cmd:. gen events = rpoisson(pyears*mu)}{p_end}
{phang2}{cmd:. rateshrink, success(events) denominator(pyears) generate(rshrunk) type(ebgamma) ci(90) id(county)}{p_end}

{pstd}Plot raw versus shrunken; points off the 45-degree line are the
small denominators being pulled toward the mean{p_end}

{phang2}{cmd:. gen praw = y/n}{p_end}
{phang2}{cmd:. twoway (function y = x, range(0 .6) lpattern(dash)) (scatter pshrunk praw [aweight=n], msymbol(Oh))}{p_end}


{marker remarks}{...}
{title:Remarks}

{pstd}
Shrinkage is fairest to the small units themselves: it protects a
five-person program from a statistical accident.  It is not a substitute
for modeling known structure; if units differ systematically (by region,
program type), consider shrinking within groups by running {cmd:rateshrink}
with {cmd:if} on each group, or a full multilevel model
({helpb melogit}, {helpb mepoisson}) when covariates matter.

{pstd}
The prior is estimated from the same data being shrunk, so with very few
units (under about 10) the prior itself is noisy.  Weights are not
supported in this version.


{title:Author}

{pstd}
Eric A. Booth, Sr Researcher, Texas 2036{break}
Support: eric.a.booth@gmail.com
