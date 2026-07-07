{smcl}
{* *! version 1.1.0  2026-07-06}{...}
{viewerjumpto "Syntax" "undummy##syntax"}{...}
{viewerjumpto "Description" "undummy##description"}{...}
{viewerjumpto "Options" "undummy##options"}{...}
{viewerjumpto "Remarks" "undummy##remarks"}{...}
{viewerjumpto "Examples" "undummy##examples"}{...}
{viewerjumpto "Stored results" "undummy##results"}{...}
{viewerjumpto "Author" "undummy##author"}{...}

{title:Title}

{p2colset 5 16 18 2}{...}
{p2col :{cmd:undummy} {hline 2}}Recombine a set of dummy/indicator variables into one categorical variable{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:undummy} {varlist} {ifin} [{cmd:,} {it:options}]

{synoptset 22 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Main}
{synopt :{opt g:enerate(newvar)}}name of the categorical variable to create; default is {cmd:undummy}{p_end}
{synopt :{opt check:dummies}}only check that the dummies are mutually exclusive; create nothing{p_end}
{synopt :{opt keep:dummies}}keep the original dummy variables; default is to drop them{p_end}

{syntab :Labeling}
{synopt :{opt val:uelab(labelname)}}attach the existing value label {it:labelname} to the new variable{p_end}
{synopt :{opt varn:ames}}label each category with the name of the dummy variable that defines it{p_end}
{synopt :{opt newval:uelab(labelname)}}store the constructed labels under {it:labelname}; default is {cmd:undummylab_}{it:newvar}{p_end}

{syntab :Types}
{synopt :{opt ignoretype}}allow a mix of numeric and string dummies by converting all to string internally{p_end}
{synoptline}

{pstd}
{it:varlist} may contain numeric or string variables but, without
{cmd:ignoretype}, not a mix of the two.


{marker description}{...}
{title:Description}

{pstd}
{cmd:undummy} reverses one-hot or dummy coding.  Given a set of mutually
exclusive indicator variables -- one column per category, as produced by
{cmd:tabulate, generate()}, by many survey platforms, and by many agency
data extracts -- it creates a single categorical variable whose values run
1, 2, ... in the sort order of the dummy set, and can attach value labels
taken from an existing label, from the dummy variable names, or under a new
label name that you specify.

{pstd}
A dummy counts as "switched on" for an observation when it is non-zero and
non-missing.  Numeric zeros and string values of {cmd:"0"}, {cmd:" "}, or
{cmd:""} count as off.  Before combining, {cmd:undummy} verifies that no
observation in the sample has more than one dummy switched on and exits
with an error if the set is not mutually exclusive; {cmd:checkdummies}
runs that verification alone.  Observations with no dummy switched on
receive their own (unlabeled) category, and observations outside the
{it:if}/{it:in} sample are set to missing.

{pstd}
By default the original dummies are dropped after the categorical variable
is created; specify {cmd:keepdummies} to keep them.  The new variable
carries the variable label of the first dummy in {it:varlist}, when one
exists.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt generate(newvar)} names the categorical variable to create.  The
default name is {cmd:undummy}.  The name must not already exist in the
dataset.

{phang}
{opt checkdummies} reports whether the dummies are mutually exclusive and
then stops.  No variable is created and the dummies are not dropped.  If
the check fails, {cmd:undummy} exits with return code 459, so the option
can gate a do-file:  {cmd:capture undummy ..., checkdummies} followed by a
test of {cmd:_rc}.

{phang}
{opt keepdummies} keeps the original dummy variables.  By default they are
dropped once the categorical variable has been created.

{dlgtab:Labeling}

{phang}
{opt valuelab(labelname)} attaches the existing value label {it:labelname}
to the new variable.  You are responsible for making the label's integer
codes match the category numbering, which follows the sort order of the
dummy set (see {it:Remarks}).  {cmd:valuelab()} may not be combined with
{cmd:varnames} or {cmd:newvaluelab()}; if both are given, {cmd:valuelab()}
wins and a warning is printed.

{phang}
{opt varnames} builds value labels from the names of the dummy variables:
the category defined by dummy {cmd:race_2}, for example, is labeled
{cmd:race_2}.  This requires each dummy to take a single constant non-zero
value (the usual 0/1 coding qualifies).

{phang}
{opt newvaluelab(labelname)} stores the labels constructed by
{cmd:varnames} (or, without {cmd:varnames}, labels equal to the category
numbers) under the value label {it:labelname}.  The default label name is
{cmd:undummylab_}{it:newvar}.

{dlgtab:Types}

{phang}
{opt ignoretype} permits {it:varlist} to mix numeric and string dummies.
The working copies are all converted to string before combining.  Without
this option a mixed varlist exits with return code 109.


{marker remarks}{...}
{title:Remarks}

{pstd}
{bf:Where the dummies come from.}  Administrative extracts and survey
platforms often deliver categorical information as one-hot columns:
{cmd:race_1}, {cmd:race_2}, ... in an agency file, or one 0/1 column per
answer choice in a Qualtrics-style export.  Analysis in Stata usually
wants the opposite shape -- one labeled categorical variable that works
with {help fvvarlist:factor-variable notation}, {cmd:tabulate}, and
graphs.  {cmd:undummy} is the bridge back.  It is also the inverse of
{cmd:tabulate, generate()}, which turns a categorical variable into
dummies.

{pstd}
{bf:Category numbering.}  Categories are numbered by
{cmd:egen, group()} in the sort order of the dummy set, after zeros are
recoded to missing.  For numeric dummies, missing sorts last, so the
category defined by the first dummy in {it:varlist} is numbered 1, the
second 2, and so on.  For string dummies the empty string sorts first, so
the numbering runs in the reverse order of {it:varlist}.  When the labels
matter, use {cmd:varnames} (which maps each dummy to its category by
value, so it is correct under either ordering) rather than relying on the
numbering.

{pstd}
{bf:Rows with nothing switched on.}  An observation whose dummies are all
zero or missing belongs to no category; it is assigned its own category
(unlabeled) rather than set to missing, so that no observations are
silently lost.  Inspect the result with {cmd:tabulate, missing} and recode
if you prefer missing.

{pstd}
{bf:Mutual exclusivity.}  Multi-select survey questions ("check all that
apply") are not mutually exclusive and cannot be represented as one
categorical variable; {cmd:undummy} refuses them with return code 459.
Use {cmd:checkdummies} to test a set before committing to the
transformation.


{marker examples}{...}
{title:Examples}

{pstd}Round trip through {cmd:tabulate, generate()}:{p_end}

{phang2}{cmd:. sysuse auto, clear}{p_end}
{phang2}{cmd:. tabulate foreign, generate(fd)}{p_end}
{phang2}{cmd:. undummy fd1 fd2, generate(origin) varnames}{p_end}
{phang2}{cmd:. tabulate origin}{p_end}

{pstd}Attach an existing value label instead:{p_end}

{phang2}{cmd:. sysuse auto, clear}{p_end}
{phang2}{cmd:. tabulate foreign, generate(fd)}{p_end}
{phang2}{cmd:. label define originlab 1 "Domestic" 2 "Foreign"}{p_end}
{phang2}{cmd:. undummy fd1 fd2, generate(origin) valuelab(originlab) keepdummies}{p_end}

{pstd}Check a one-hot race extract before converting it:{p_end}

{phang2}{cmd:. undummy race_1-race_7, checkdummies}{p_end}
{phang2}{cmd:. undummy race_1-race_7, generate(race) varnames newvaluelab(racelab)}{p_end}

{pstd}String dummies ("1"/"0") from a survey export:{p_end}

{phang2}{cmd:. undummy q12_a q12_b q12_c, generate(q12) varnames}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:undummy} stores the following in {cmd:r()} (nothing is stored when
{cmd:checkdummies} is specified):

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt :{cmd:r(k)}}number of categories in the new variable{p_end}

{p2col 5 15 19 2: Macros}{p_end}
{synopt :{cmd:r(generate)}}name of the created variable{p_end}
{synopt :{cmd:r(base)}}name of the first dummy in {it:varlist}, whose type and variable label anchor the result{p_end}


{marker author}{...}
{title:Author}

{pstd}
Eric A. Booth, Sr Researcher, Texas 2036{break}
Support: {browse "mailto:eric.a.booth@gmail.com":eric.a.booth@gmail.com}


{title:Also see}

{psee}
Help: {help tabulate oneway:tabulate, generate()}, {help egen} (group function), {help label}
{p_end}
