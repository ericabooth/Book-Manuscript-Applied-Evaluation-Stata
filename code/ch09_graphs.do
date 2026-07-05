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

di "DONE"
