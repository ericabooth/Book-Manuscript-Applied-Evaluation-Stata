{smcl}
{* *! version 1.0.0 30jul2026}{...}
{hi:help synthgen}{...}
{right:v 1.0.0}
{hline}

{title:Title}

{phang}
{bf:synthgen} {hline 2} generate a rank-preserving synthetic stand-in dataset


{title:Syntax}

{p 8 16 2}
{cmd:synthgen} [{varlist}] {ifin} {cmd:,}
[{opt sav:ing(filename[, replace])} {opt fr:ame(name)}
{opt n(#)} {opt se:ed(#)} {opt norep:ort}]

{p 4 6 2}
At least one of {opt saving()} and {opt frame()} is required: state where the
synthetic rows land.  {it:varlist} defaults to every numeric variable.


{title:Description}

{pstd}
{cmd:synthgen} builds a synthetic dataset that behaves like the source without
containing any of its records, so an outside collaborator can write and test
code against realistic data while the real records never leave the secure
environment.

{pstd}
The engine is a Gaussian copula with empirical margins.  Each variable's
observed distribution is reproduced exactly: every synthetic value is a value
that occurs in the source, drawn with the source's frequencies, so minimums,
maximums, and category codes are always respected.  The association between
variables is preserved through their rank (Spearman) correlations: normal
scores are correlated on the source's complete cases, a joint normal sample is
drawn with that structure, and each margin is mapped back through the source
variable's empirical quantiles.  Each variable's missing-value share is then
re-imposed independently.  Value and variable labels are carried across, and
the data label marks the file as synthetic.

{pstd}
{cmd:synthgen} refuses two kinds of input loudly, with no override.  String
variables are refused (encode a category first; a string identifier is a leak,
not a feature).  Any numeric variable whose nonmissing values are all distinct
is refused as ID-shaped: synthesizing an identifier manufactures fake people
with real-looking keys.


{title:Options}

{phang}
{opt saving(filename[, replace])} writes the synthetic rows to a {bf:.dta}
file.

{phang}
{opt frame(name)} copies the synthetic rows into a frame, replacing it if it
exists.

{phang}
{opt n(#)} sets the number of synthetic rows; the default is the source
sample size.

{phang}
{opt seed(#)} sets the random-number seed, making the draw reproducible.

{phang}
{opt noreport} suppresses the fidelity and match report.


{title:The diagnostic}

{pstd}
Every run prints (and returns) a fidelity and match diagnostic: the worst
standardized mean gap between source and synthetic variables, the worst gap
in pairwise rank correlations, and the count of synthetic rows that duplicate
a source row on the synthesized variables. An exact match is a review flag.
Its disclosure risk depends on source rarity, sensitive attributes, recipient
knowledge, prior releases, and the release setting.


{title:Remarks}

{pstd}
A synthetic file is a development surface rather than a substitute for the
source analysis. Compare generated matches with unique and rare combinations
in the source, assess the intended analyses, and document the release decision.
Do not state that no generated row corresponds to a source person unless a
case-specific disclosure assessment supports that statement.

{pstd}
Limitations, stated plainly: associations are preserved through rank
correlations, so strongly non-monotone relationships are attenuated;
missingness is re-imposed independently per variable, so missingness patterns
that depend on other variables are not reproduced.


{title:Examples}

{phang}{cmd:. sysuse nlsw88, clear}{p_end}
{phang}{cmd:. synthgen wage grade tenure age hours, frame(synth) seed(20260730)}{p_end}
{phang}{cmd:. frame synth: summarize}{p_end}

{phang}{cmd:. synthgen race married collgrad industry wage, saving(synth_share.dta, replace) seed(1)}{p_end}


{title:Stored results}

{pstd}{cmd:synthgen} stores the following in {cmd:r()}:{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(n)}}synthetic rows generated{p_end}
{synopt:{cmd:r(k)}}variables synthesized{p_end}
{synopt:{cmd:r(src_n)}}source observations used{p_end}
{synopt:{cmd:r(cc_n)}}complete cases behind the correlation structure{p_end}
{synopt:{cmd:r(maxdmean)}}worst standardized mean gap{p_end}
{synopt:{cmd:r(maxdrho)}}worst pairwise rank-correlation gap{p_end}
{synopt:{cmd:r(dupes)}}synthetic rows duplicating a real record{p_end}


{title:Authors}

{pstd}
Eric A. Booth, Sr Researcher, Texas 2036 ({browse "mailto:eric.a.booth@gmail.com":eric.a.booth@gmail.com}){break}
Elizabeth Teas, Sr Research Scientist, Far Harbor, LLC


{title:Also see}

{psee}
Help: {helpb riskscan}, {helpb suppress}, {helpb frames}
{p_end}
