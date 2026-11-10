*==============================================================================*
* ch09_graphs.do  --  Chapter 9: graphing for busy readers
*
* Builds the three chapter exhibits from data every Stata user has:
*   (a) ch09_ink.png     data-ink before/after via graph combine (sysuse nlsw88)
*   (b) ch09_coefplot.png  small-multiple coefficient plot   (sysuse nlsw88)
*   (c) ch09_runchart.png  run chart with an xline at go-live (SIMULATED)
* Also reports the before/after means behind Table 9.1.
*
* Paths: in the full project these come from code/00_control.do. They are
* defined here (only if missing) so this file also runs standalone.
*==============================================================================*

clear all
set more off

if "$figures" == "" {
    global root "`c(pwd)'"
    global figures "$root/figures"
    capture mkdir "$figures"
}

*--- (a) Data-ink, before and after -------------------------------------------*
* The same finding -- mean hourly wage by occupation -- drawn badly then well.
sysuse nlsw88, clear

* cluttered (everything on): saved as g_bad
graph hbar (mean) wage, over(occ) ///
    ytitle("mean wage") legend(on) ///
    graphregion(color(gs14)) ///
    ylabel(, grid glcolor(gs10)) ///
    title("Default", size(medium)) ///
    name(g_bad, replace)

* stripped (data-ink only): saved as g_good
graph hbar (mean) wage, ///
    over(occ, sort(1) descending ///
        label(labsize(vsmall))) ///
    bar(1, color(navy)) ///
    blabel(bar, format(%3.1f) size(vsmall)) ///
    ytitle("") ylabel(none) ///
    yscale(off) graphregion(color(white)) ///
    title("Data-ink only", size(medium)) ///
    name(g_good, replace)

graph combine g_bad g_good, cols(2) ///
    graphregion(margin(l=2 r=6) color(white)) ///
    ysize(4) xsize(7.6)
graph export "$figures/ch09_ink.png", replace width(2400)
di "INK_OK"

*--- (b) Coefficient small multiples ------------------------------------------*
* The union coefficient across three outcomes, on a shared zero line.
sysuse nlsw88, clear
foreach y in wage hours ttl_exp {
    quietly regress `y' union age collgrad south
    estimates store m_`y'
}
coefplot (m_wage, aseq("Wage ($/hr)")) ///
         (m_hours, aseq("Hours/week")) ///
         (m_ttl_exp, aseq("Experience (yrs)")), ///
    keep(union) aseq swapnames legend(off) ///
    xline(0, lpattern(dash) lcolor(gs8)) ///
    msymbol(D) mcolor(navy) ///
    ciopts(recast(rcap) lcolor(navy)) ///
    xtitle("Estimated union coefficient", size(small)) ///
    title("Union gap by outcome, NLSW 1988", size(medium)) ///
    note("Points are OLS estimates; caps are 95% CIs. Controls: age, college, South.", ///
        size(vsmall)) ///
    graphregion(margin(l=2 r=6)) ysize(4) xsize(7.2)
graph export "$figures/ch09_coefplot.png", replace width(2400)
di "COEFPLOT_OK"

*--- (c) Run chart with an intervention line (SIMULATED) ----------------------*
* A simulated monthly service metric with a step improvement at go-live.
clear
set seed 20260704
set obs 36
gen month = tm(2023m1) + _n - 1
format month %tm
gen days = 22 + rnormal(0, 1.5)          // simulated baseline noise
replace days = days - 4 if _n >= 19      // step at go-live (2024m7)

twoway (connected days month, mcolor(navy) lcolor(navy)), ///
    xline(`=tm(2024m7)', lpattern(dash) lcolor(maroon)) ///
    text(22 `=tm(2024m7)' "new intake process", ///
        placement(e) size(small) color(maroon)) ///
    ytitle("Avg. days to placement", size(small)) ///
    xtitle("") xlabel(, labsize(small)) ///
    title("Days to placement, monthly (simulated)", ///
        size(medium)) ///
    note("Dashed line marks go-live of a new intake process.", ///
        size(vsmall)) ///
    graphregion(margin(l=2 r=6)) ysize(4) xsize(7.2)
graph export "$figures/ch09_runchart.png", replace width(2400)
di "RUNCHART_OK"

* Table 9.1: before/after means behind the run chart
quietly summarize days if _n < 19
local pre = r(mean)
quietly summarize days if _n >= 19
local post = r(mean)
di "BEFORE mean = " %4.1f `pre'
di "AFTER  mean = " %4.1f `post'
di "DIFF        = " %4.1f `post' - `pre'

*==============================================================================*
* (4) High-density categorical summary with statplot: 13 occupations, ranked,
*     with 95% CIs. statplot (Booth & Cox) collapses to the statistic and
*     draws the ranked hbar in one call.
*==============================================================================*
sysuse nlsw88, clear
statplot wage, over(occupation) ci sort wrap(14) ///
    xtitle("mean hourly wage (1988 dollars)") ///
    name(statplot_occ, replace) ///
    note("NLSW88 extract; bars are means, whiskers 95% CIs.", size(vsmall))
graph export "$figures/ch09_statplot.png", replace width(2400)
* plotted numbers for the caption (top, bottom, and the widest-CI category)
statplot wage, over(occupation) ci sort listdata
di "STATPLOT_OK"

*==============================================================================*
* (5) One-call composition snapshot: the indicator variables of the cleaned
*     extract as ranked percent shares (a graphical -summarize- for the room).
*     percent scales 0/1 means x100; sort descending ranks; wrap(12) folds
*     the curated variable labels instead of abbreviating them.
*==============================================================================*
sysuse nlsw88, clear
statplot union married never_married collgrad ///
    south smsa c_city, ///
    percent sort descending wrap(12) ///
    ytitle("percent of respondents") ///
    name(statplot_snap, replace)
graph export "$figures/ch09_statplot2.png", replace width(2400)
* freeze the plotted numbers: each bar = mean x 100 on its own nonmissing N
quietly summarize smsa
assert abs(r(mean)*100 - 70.39) < 0.05
quietly summarize married
assert abs(r(mean)*100 - 64.20) < 0.05
quietly summarize south
assert abs(r(mean)*100 - 41.94) < 0.05
quietly summarize never_married
assert abs(r(mean)*100 - 10.42) < 0.05
quietly summarize union
assert abs(r(mean)*100 - 24.55) < 0.05
assert r(N) == 1878
di "STATPLOT_SNAPSHOT_OK"

*==============================================================================*
* (6) The template version: fixed house order + headings() section rows +
*     frame() resultsset handback. headings()/ci build via twoway, so the
*     value axis is x (xtitle), unlike the plain hbar calls above (ytitle).
*==============================================================================*
sysuse nlsw88, clear
capture frame drop snapshot
statplot married never_married south smsa c_city ///
    union collgrad, percent wrap(12) ///
    headings(married = "{bf:Family}" ///
             south = "{bf:Location}" ///
             union = "{bf:Work and education}") ///
    xtitle("percent of respondents") frame(snapshot) ///
    name(statplot_tmpl, replace)
graph export "$figures/ch09_statplot3.png", replace width(2400)
* the resultsset is a dataset: format it, list it, reuse it
frame snapshot: format mean %9.1f
frame snapshot: list, noobs
* freeze: frame rows match the flat-snapshot values (percent-scaled means)
frame snapshot {
    quietly summarize mean if variable == "married"
    assert abs(r(mean) - 64.20) < 0.05
    quietly summarize mean if variable == "smsa"
    assert abs(r(mean) - 70.39) < 0.05
    assert _N == 7
}
di "STATPLOT_TEMPLATE_OK"

di "DONE"

*==============================================================================*
* (7) Diverging Likert bar in native Stata (ILLUSTRATIVE data). Three survey
*     items, five response levels, percent of respondents at each level; the
*     same illustrative numbers Chapter 10 charts interactively. Each segment
*     is drawn from a left edge to a right edge, and the neutral share is
*     split in half around zero so agreement and disagreement share a
*     baseline at the center.
*==============================================================================*
clear
input byte item byte level byte share
1 1 18
1 2 20
1 3 14
1 4 34
1 5 14
2 1 33
2 2 31
2 3 16
2 4 15
2 5  5
3 1 22
3 2 26
3 3 20
3 4 26
3 5  6
end
label define item 1 `""K-12 investment is" "on the right track""' ///
                  2 `""Higher education" "is affordable""'        ///
                  3 `""Texas is prepared for" "its water needs""'
label values item item

* every item's shares must sum to 100 before any edge is computed
bysort item: egen total = total(share)
assert total == 100

* left edge of the first segment: minus (both disagree levels + half neutral)
bysort item (level): egen left = total(cond(level < 3, share, ///
                                       cond(level == 3, share/2, 0)))
bysort item (level): gen hi = sum(share) - left
gen lo = hi - share
* the neutral segment must straddle zero
assert abs(lo + hi) < 1e-6 if level == 3

twoway (rbar lo hi item if level == 1, horizontal barwidth(.6) ///
            color("166 97 26")  lwidth(none))                   ///
       (rbar lo hi item if level == 2, horizontal barwidth(.6) ///
            color("223 194 125") lwidth(none))                  ///
       (rbar lo hi item if level == 3, horizontal barwidth(.6) ///
            color(gs13) lwidth(none))                           ///
       (rbar lo hi item if level == 4, horizontal barwidth(.6) ///
            color("128 205 193") lwidth(none))                  ///
       (rbar lo hi item if level == 5, horizontal barwidth(.6) ///
            color("1 133 113") lwidth(none)),                   ///
    xline(0, lcolor(gs6) lwidth(thin))                          ///
    ylabel(1 2 3, valuelabel angle(0) nogrid labsize(small))    ///
    yscale(reverse range(0.5 3.5)) ytitle("")                   ///
    xlabel(-80 "80" -40 "40" 0 "0" 40 "40" 80 "80", nogrid)     ///
    xtitle("percent of respondents: disagree to the left, agree to the right") ///
    legend(order(1 "Strongly disagree" 2 "Disagree" 3 "Neutral" ///
                 4 "Agree" 5 "Strongly agree")                  ///
           rows(1) position(6) size(small) symxsize(*.5))       ///
    xsize(7.5) ysize(3.2) name(likert_div, replace)
graph export "$figures/ch09_likert.png", replace width(2400)

* numbers for the caption: net agreement (agree + strongly agree minus the
* two disagree levels) for each item
bysort item: egen agree    = total(cond(level > 3, share, 0))
bysort item: egen disagree = total(cond(level < 3, share, 0))
gen net = agree - disagree
tabstat agree disagree net, by(item) nototal
assert net == 10  if item == 1
assert net == -44 if item == 2
assert net == -16 if item == 3
di "LIKERT_DIVERGING_OK"
