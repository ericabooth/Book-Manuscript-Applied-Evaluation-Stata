{smcl}
{* *! version 1.0.0  27jul2026}{...}
{title:Title}

{p2colset 5 20 22 2}{...}
{p2col :{cmd:reachcheck} {hline 2}}Compare a responding sample's composition against target-population margins{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 16 2}
{cmd:reachcheck} {varname} {ifin}{cmd:,} {opt tar:get(numlist)}
[{opt tol:erance(#)} {opt norep:ort}]

{p 4 6 2}
{it:varname} is a categorical numeric variable (value labels are used in the
report when present).


{title:Description}

{pstd}
{cmd:reachcheck} answers the question that follows every disappointing
response rate: do the people who answered look like the population the survey
meant to describe?  It tabulates the sample's share in each category of
{it:varname}, sets each share beside the target share you supply in
{opt target()}, and reports the gap in percentage points, the sample-to-target
ratio, and a chi-squared goodness-of-fit test of the sample against the
target margins.

{pstd}
{cmd:reachcheck} diagnoses; it does not repair.  When the gaps are large the
output points to raking ({helpb ipfraking} from SSC) and to reporting the
gap beside the response rate, which is the honest minimum.


{title:Options}

{phang}
{opt target(numlist)} is required: one value per category of {it:varname},
in ascending order of the category values.  Values may be shares that sum
to 1 or percentages that sum to 100; {cmd:reachcheck} detects which and
errors if the list sums to neither.

{phang}
{opt tolerance(#)} sets the gap, in percentage points, above which the
report recommends action.  Default is {cmd:tolerance(5)}.

{phang}
{opt noreport} suppresses the table and returns results silently.


{title:Examples}

{pstd}Compare the sample's race composition against (invented) target
margins of 70/20/10 percent:{p_end}

{phang2}{cmd:. sysuse nlsw88, clear}{p_end}
{phang2}{cmd:. reachcheck race, target(70 20 10)}{p_end}

{pstd}Same, with shares, and a stricter tolerance:{p_end}

{phang2}{cmd:. reachcheck race, target(.70 .20 .10) tolerance(3)}{p_end}


{title:Stored results}

{pstd}
{cmd:reachcheck} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}respondents used{p_end}
{synopt:{cmd:r(maxgap)}}largest signed gap, percentage points{p_end}
{synopt:{cmd:r(chi2)}}goodness-of-fit chi-squared vs the target{p_end}
{synopt:{cmd:r(df)}}degrees of freedom{p_end}
{synopt:{cmd:r(p)}}p-value{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(maxgap_category)}}label of the category with the largest gap{p_end}

{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(table)}}sample %, target %, gap, ratio; one row per category{p_end}


{title:Author}

{pstd}
Eric A. Booth.  Companion tool to {it:Applied Program Evaluation Using Stata}.
