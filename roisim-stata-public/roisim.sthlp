{smcl}
{* *! version 0.1.0  2026-07-06}{...}
{viewerjumpto "Syntax" "roisim##syntax"}{...}
{viewerjumpto "Description" "roisim##description"}{...}
{viewerjumpto "Options" "roisim##options"}{...}
{viewerjumpto "The model" "roisim##model"}{...}
{viewerjumpto "The tornado" "roisim##tornado"}{...}
{viewerjumpto "Stored results" "roisim##results"}{...}
{viewerjumpto "Examples" "roisim##examples"}{...}
{viewerjumpto "Remarks" "roisim##remarks"}{...}

{title:Title}

{p2colset 5 15 17 2}{...}
{p2col :{cmd:roisim} {hline 2}}Monte Carlo return-on-investment simulation with tornado export{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:roisim}{cmd:,} {cmd:effect(}{it:#}{cmd:)} {cmd:se(}{it:#}{cmd:)}
{cmd:costlow(}{it:#}{cmd:)} {cmd:costhigh(}{it:#}{cmd:)} [{it:options}]

{synoptset 26 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Required}
{synopt :{cmd:effect(}{it:#}{cmd:)}}point estimate of the program effect per participant{p_end}
{synopt :{cmd:se(}{it:#}{cmd:)}}standard error of that effect; 0 treats it as known{p_end}
{synopt :{cmd:costlow(}{it:#}{cmd:)}}low end of the plausible total program cost{p_end}
{synopt :{cmd:costhigh(}{it:#}{cmd:)}}high end of the plausible total program cost{p_end}

{syntab :Benefit scaling}
{synopt :{cmd:njoiners(}{it:#}{cmd:)}}number of participants; default 1{p_end}
{synopt :{cmd:value(}{it:#}{cmd:)}}dollars per unit of effect per year; default 1{p_end}

{syntab :Discounting}
{synopt :{cmd:discount(}{it:#}{cmd:)}}fixed annual discount rate; default 0.03{p_end}
{synopt :{cmd:horizon(}{it:#}{cmd:)}}fixed years the benefit persists; default 5{p_end}
{synopt :{cmd:discountrange(}{it:# #}{cmd:)}}draw the rate uniformly between low and high instead{p_end}
{synopt :{cmd:horizonrange(}{it:# #}{cmd:)}}draw whole years uniformly between low and high instead{p_end}

{syntab :Simulation}
{synopt :{cmd:reps(}{it:#}{cmd:)}}number of Monte Carlo draws; default 10000, minimum 100{p_end}
{synopt :{cmd:seed(}{it:#}{cmd:)}}set the random-number seed for a reproducible run{p_end}
{synopt :{cmd:saving(}{it:filename}[{cmd:, replace}]{cmd:)}}write the tornado table to a CSV file{p_end}
{synoptline}


{marker description}{...}
{title:Description}

{pstd}
{cmd:roisim} answers the money question with a range rather than a single
ratio.  It draws each uncertain input many times, computes the return on
investment for every draw, and reports the percentiles of the resulting
distribution together with the break-even probability Pr(ROI > 0), the
share of draws in which the program at least pays for itself.  A median
ROI of 1.5 with a tenth percentile of 0.4 tells a board how much of the
bet is safe; the bare 1.5 never could.

{pstd}
The command also runs a one-way sensitivity sweep: every input is held at
its central value while one input at a time swings from the low to the
high end of its plausible range, and the resulting swings in ROI are
sorted longest first.  {cmd:saving()} writes that table to a CSV file
ready for a tornado bar chart, which shows stakeholders which two or
three assumptions actually drive the answer.

{pstd}
{cmd:roisim} touches no data in memory, ships no files, and makes no
network calls.  All results are left in {cmd:r()}.


{marker options}{...}
{title:Options}

{phang}{cmd:effect(}{it:#}{cmd:)} and {cmd:se(}{it:#}{cmd:)} describe the
estimated effect per participant per year, typically a regression
coefficient and its standard error.  Each replication draws the effect
from Normal({it:effect}, {it:se}).  With {cmd:se(0)} the effect is held
fixed, which isolates the uncertainty contributed by the other inputs.{p_end}

{phang}{cmd:costlow(}{it:#}{cmd:)} and {cmd:costhigh(}{it:#}{cmd:)} bound
the plausible {it:total} program cost; each replication draws the cost
uniformly between them.  Set both to the same value for a known cost.
If your cost table is per seat, multiply by the number of seats first
(or scale benefits with {cmd:njoiners()} and costs by hand, keeping the
two on the same footing).  {cmd:costlow()} must be strictly positive
because ROI divides by cost.{p_end}

{phang}{cmd:njoiners(}{it:#}{cmd:)} scales the annual benefit by the
number of participants.  {cmd:value(}{it:#}{cmd:)} converts one unit of
effect into dollars per year (leave it at 1 when {cmd:effect()} is
already in dollars).  Annual benefit =
{it:njoiners} x {it:value} x effect draw.{p_end}

{phang}{cmd:discount(}{it:#}{cmd:)} fixes the annual rate used to bring
future benefits back to present value.  The discount rate is a value
judgment wearing a number's clothing, so consider reporting results at
two or three rates, or pass {cmd:discountrange(}{it:low high}{cmd:)} to
draw the rate uniformly in each replication and add it to the tornado
sweep.{p_end}

{phang}{cmd:horizon(}{it:#}{cmd:)} fixes how many whole years the annual
benefit persists.  {cmd:horizonrange(}{it:low high}{cmd:)} instead draws
a whole number of years uniformly between {it:low} and {it:high} in each
replication and adds the horizon to the tornado sweep.{p_end}

{phang}{cmd:reps(}{it:#}{cmd:)} sets the number of Monte Carlo
replications.  The default of 10,000 makes the reported percentiles
stable to about two decimal places in typical applications.{p_end}

{phang}{cmd:seed(}{it:#}{cmd:)} calls {helpb set seed} before drawing, so
the run is exactly reproducible.  Without it the current random-number
state is used.{p_end}

{phang}{cmd:saving(}{it:filename}[{cmd:, replace}]{cmd:)} writes the
tornado table to a CSV file with columns {it:input}, {it:low},
{it:central}, {it:high}, {it:roi_low}, {it:roi_high}, {it:swing}, one row
per swept input, sorted by swing, longest first.  A {cmd:.csv} extension
is added when the filename has none.  Without {cmd:replace}, an existing
file is an error.{p_end}


{marker model}{...}
{title:The model}

{pstd}
Each replication draws the uncertain inputs and computes one ROI:

{p 8 12 2}effect draw {space 3}~ Normal({cmd:effect()}, {cmd:se()}){p_end}
{p 8 12 2}cost draw {space 5}~ Uniform({cmd:costlow()}, {cmd:costhigh()}){p_end}
{p 8 12 2}annual benefit = {cmd:njoiners()} x {cmd:value()} x effect draw{p_end}
{p 8 12 2}PV of benefits = annual benefit x [1 - (1+d)^(-h)] / d{p_end}
{p 8 12 2}ROI = (PV of benefits - cost draw) / cost draw{p_end}

{pstd}
where d is the discount rate and h the horizon in years (the present-value
factor equals h when d = 0).  ROI is a net return per dollar: 0 means the
program exactly pays for itself, 1.5 means $1.50 returned net per dollar
spent.  With {cmd:discountrange()} or {cmd:horizonrange()}, d or h is
drawn each replication as well.


{marker tornado}{...}
{title:The tornado}

{pstd}
The distribution tells a board how confident to be; the tornado tells
them what to argue about.  Every input is held at its central value
(effect at {cmd:effect()}, cost at the midpoint of its bounds, discount
and horizon at their fixed values or range midpoints); then one input at
a time swings to the low and high ends of its plausible range and the ROI
is recomputed at each end.  The effect swings across its 95% interval,
{cmd:effect()} -/+ 1.96 x {cmd:se()}; cost across its bounds; discount
and horizon across their ranges when {cmd:discountrange()} or
{cmd:horizonrange()} is given.  Inputs held fixed contribute no
uncertainty, so they are omitted from the sweep: the tornado has two rows
by default and up to four with both ranges supplied.  {cmd:r(n_swept)}
records the count.


{marker results}{...}
{title:Stored results}

{pstd}{cmd:roisim} stores in {cmd:r()}:{p_end}

{synoptset 18 tabbed}{...}
{p2col 5 22 26 2: Scalars}{p_end}
{synopt :{cmd:r(reps)}}number of replications{p_end}
{synopt :{cmd:r(mean)}}mean of the simulated ROI{p_end}
{synopt :{cmd:r(sd)}}standard deviation of the simulated ROI{p_end}
{synopt :{cmd:r(min)}, {cmd:r(max)}}smallest and largest draw{p_end}
{synopt :{cmd:r(p1)} ... {cmd:r(p99)}}percentiles 1, 5, 10, 25, 50, 75, 90, 95, 99{p_end}
{synopt :{cmd:r(prpos)}}Pr(ROI > 0), the break-even probability{p_end}
{synopt :{cmd:r(roi_central)}}ROI with every input at its central value{p_end}
{synopt :{cmd:r(pv_central)}}present value of benefits at central values{p_end}
{synopt :{cmd:r(pvfactor)}}present-value annuity factor at central values{p_end}
{synopt :{cmd:r(n_swept)}}number of inputs in the tornado sweep{p_end}
{synopt :{cmd:r(effect)}, {cmd:r(se)}}inputs as given{p_end}
{synopt :{cmd:r(costlow)}, {cmd:r(costhigh)}}inputs as given{p_end}
{synopt :{cmd:r(njoiners)}, {cmd:r(value)}}inputs as given{p_end}

{p2col 5 22 26 2: Macros}{p_end}
{synopt :{cmd:r(cmd)}}{cmd:roisim}{p_end}
{synopt :{cmd:r(saving)}}CSV path, when {cmd:saving()} was given{p_end}

{p2col 5 22 26 2: Matrices}{p_end}
{synopt :{cmd:r(pct)}}1 x 9 row of the nine percentiles{p_end}
{synopt :{cmd:r(tornado)}}{cmd:r(n_swept)} x 6: low, central, high, roi_low, roi_high, swing{p_end}
{p2colreset}{...}


{marker examples}{...}
{title:Examples}

{pstd}A job-training program: an estimated earnings gain of $3,000 per
participant per year (SE $900), a total cost somewhere between $3,800 and
$4,600, benefits persisting 4 years, discounted at 3.5%:{p_end}

{phang2}{cmd:. roisim, effect(3000) se(900) costlow(3800) costhigh(4600) discount(0.035) horizon(4) seed(20260706)}{p_end}

{pstd}Read the median from {cmd:r(p50)} and the break-even probability
from {cmd:r(prpos)}:{p_end}

{phang2}{cmd:. display "median ROI = " r(p50) ", Pr(ROI>0) = " r(prpos)}{p_end}

{pstd}Treat the discount rate and the persistence horizon as uncertain
too, and export the four-row tornado table for charting:{p_end}

{phang2}{cmd:. roisim, effect(3000) se(900) costlow(3800) costhigh(4600) discountrange(0.02 0.07) horizonrange(3 5) seed(20260706) saving(tornado.csv, replace)}{p_end}

{pstd}Chart it (longest bar at the top):{p_end}

{phang2}{cmd:. import delimited using tornado.csv, clear}{p_end}
{phang2}{cmd:. graph hbar (asis) swing, over(input, sort(1) descending) title("Tornado: what moves the ROI")}{p_end}

{pstd}An effect measured in units rather than dollars: 0.15 additional
graduates per participant, each valued at $9,000 per year, 200
participants, total cost between $150,000 and $210,000:{p_end}

{phang2}{cmd:. roisim, effect(0.15) se(0.05) value(9000) njoiners(200) costlow(150000) costhigh(210000) horizon(5) seed(20260706)}{p_end}


{marker remarks}{...}
{title:Remarks}

{pstd}
Fix the accounting perspective before reaching for this command: whose
costs and whose benefits count changes every input.  Report the result at
two or three discount rates rather than defending one.  And report the
loss tail rather than rounding it away; a thin band of draws below zero
is exactly what a funder needs to see to plan against the estimate
honestly.

{pstd}
In this version the effect is Normal, the cost is Uniform, and the
inputs are drawn independently; correlated draws and other distribution
families are not supported.


{title:Author}

{pstd}
Eric A. Booth, Sr Researcher, Texas 2036{break}
Support: eric.a.booth@gmail.com
{p_end}
