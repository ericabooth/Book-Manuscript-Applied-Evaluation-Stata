*==============================================================================*
* ch07_trust.do  --  Chapter 7: making numbers trustworthy
* (a) reliability of a simulated 6-item staff-rated engagement scale
* (b) design weights: NHANES II high blood pressure, weighted vs unweighted
* (c) empirical-Bayes shrinkage of 50 simulated site completion rates
* (d) power curves for a two-arm design, read at the budget line
* Simulated blocks use seed 20260704 and are labeled simulated in the text.
*==============================================================================*
* Globals defined locally so this file runs standalone; in the full book
* project they are set once by code/00_control.do instead.
global root    "`c(pwd)'"
global raw     "$root/raw"
global clean   "$root/clean"
global figures "$root/figures"
capture mkdir "$raw"
capture mkdir "$clean"
capture mkdir "$figures"

version 19
clear all

*--- (a) Reliability: simulate a 6-item scale, one weak item ------------------*
* 400 caregivers, latent engagement, five real items, one dud (item6).
set seed 20260704
set obs 400
gen latent = rnormal()
forvalues j = 1/5 {
    gen item`j' = round(3 + latent + rnormal(0, 1))
    replace item`j' = 1 if item`j' < 1
    replace item`j' = 5 if item`j' > 5
}
gen item6 = round(3 + 0.15*latent + rnormal(0, 1))
replace item6 = 1 if item6 < 1
replace item6 = 5 if item6 > 5

di "---ALPHA ALL SIX---"
alpha item1-item6
di "---ALPHA ITEM DIAGNOSTICS---"
alpha item1-item6, item
di "---ALPHA WITHOUT ITEM6---"
alpha item1-item5

*--- (b) Weights that restore the population: NHANES II -----------------------*
webuse nhanes2f, clear
di "---UNWEIGHTED MEAN---"
mean highbp
svyset psuid [pweight=finalwgt], strata(stratid)
di "---WEIGHTED (DESIGN-BASED) MEAN---"
svy: mean highbp
* why: oversampled groups (older adults) have more hypertension
di "---MEAN AGE, UNWEIGHTED VS WEIGHTED---"
mean age
svy: mean age

*--- (c) Shrinkage: 50 simulated sites, beta-binomial moment estimator --------*
clear
set seed 20260704
set obs 50
gen site  = _n
gen n     = 5 + int(495*runiform()^2)        // caseloads 5-500, most small
gen ptrue = rbeta(8, 32)                     // mean .20, sd .062
gen y     = rbinomial(n, ptrue)
gen praw  = y/n

* Empirical-Bayes (beta-binomial) shrinkage, moment estimator:
quietly summarize praw
scalar pbar = r(mean)
scalar s2   = r(Var)
gen sampv   = pbar*(1 - pbar)/n
quietly summarize sampv
scalar tau2 = max(s2 - r(mean), 1e-6)        // between-site variance
scalar M    = pbar*(1 - pbar)/tau2 - 1       // prior sample size
gen pshrunk = (y + M*pbar)/(n + M)
gen move    = pshrunk - praw
di "---SHRINKAGE CONSTANTS---"
di "grand mean = " %5.3f pbar " ; prior sample size M = " %5.1f M

gen absmove = abs(move)
gsort -absmove
format praw pshrunk move %6.3f
di "---THREE MOST-MOVED SITES---"
list site n praw pshrunk move in 1/3, noobs

save "$clean/ch07_sites_shrunk.dta", replace

*--- (c) figure: raw vs shrunken, sized by caseload, 45-degree line -----------*
quietly summarize praw
local pmax = ceil(r(max)*20)/20
local pb   = pbar
twoway (function y = x, range(0 `pmax') lcolor(gs10) lpattern(dash)) ///
       (scatter pshrunk praw [aweight=n], msymbol(Oh) mcolor(navy)   ///
           mlwidth(medthick)),                                       ///
    yline(`pb', lcolor(cranberry) lpattern(shortdash))               ///
    xtitle("Raw completion rate (successes / caseload)",             ///
        size(small))                                                 ///
    ytitle("Shrunken (EB) rate", size(small))                        ///
    title("Shrinkage pulls small sites toward the mean",             ///
        size(medium))                                                ///
    legend(order(2 "Site (marker area = caseload)"                   ///
        1 "No shrinkage (y = x)") rows(1) size(small)                ///
        position(6) region(lstyle(none)))                            ///
    note("Simulated: 50 sites, caseloads 5-500 (most small)," ///
        " true rates centered at 0.20. Dotted line: grand mean.",    ///
        size(vsmall))                                                ///
    graphregion(margin(l=2 r=6)) ysize(3.6) xsize(7.2)
graph export "$figures/ch07_shrink.png", replace width(2400)
di "FIGURE_SHRINK_SAVED"

*--- (d) Power: two-arm design, read the curve at the budget line -------------*
* Job-readiness score, control mean 50, sd 10; candidate gains 2, 3, 4 pts.
di "---POWER AT THE BUDGETED N=300---"
power twomeans 50 (52 53 54), sd(10) n(300) table(N delta power)

power twomeans 50 (52 53 54), sd(10) n(100(20)500)                   ///
    graph(ydimension(power) xdimension(N)                            ///
        plotopts(lwidth(medthick))                                   ///
        yline(0.8, lcolor(gs8) lpattern(dash))                       ///
        xline(300, lcolor(cranberry) lpattern(shortdash))            ///
        title("Power to detect a 2-, 3-, or 4-point gain",           ///
            size(medium))                                            ///
        subtitle("")                                                 ///
        ytitle("Power", size(small))                                 ///
        xtitle("Total sample size (both arms)", size(small))         ///
        legend(title("Treated-arm mean (control = 50)",              ///
            size(small)) rows(1) size(small) position(6)             ///
            region(lstyle(none)))                                    ///
        note("Two-sample means test, sd = 10, alpha = 0.05." ///
            " Vertical line: budgeted N = 300.", size(vsmall))       ///
        graphregion(margin(l=2 r=6)) ysize(4.6) xsize(6.4))
graph export "$figures/ch07_power.png", replace width(2400)
di "FIGURE_POWER_SAVED"

*==============================================================================*
* (f) ch07_conformal.png -- the 90% band drawn: observed vs predicted wage,
*     parallel bounds at +/-Q, the promised 10% marked. Printed in sec:conformal.
*==============================================================================*
adopath ++ "`c(pwd)'/../conformalpred-stata-public"
sysuse nlsw88, clear
conformalpred, command(regress wage grade tenure) alpha(0.1) seed(20260706)
assert abs(r(Q) - 5.77) < 0.05
gen double fit = (cp_lower + cp_upper)/2
gen byte outside = wage < cp_lower | wage > cp_upper
quietly summarize outside
local pctout = 100*r(mean)
twoway (scatter wage fit if !outside, msymbol(oh) mcolor(navy%40) msize(small)) ///
       (scatter wage fit if outside,  msymbol(x)  mcolor(cranberry) msize(small)) ///
       (line cp_lower fit, sort lcolor(gs6) lpattern(dash)) ///
       (line cp_upper fit, sort lcolor(gs6) lpattern(dash)), ///
    legend(order(1 "inside the band" 2 "outside (the promised share)") ///
        ring(0) position(11) cols(1) size(small) region(lstyle(none))) ///
    ytitle("observed hourly wage") xtitle("predicted hourly wage") ///
    graphregion(color(white)) ysize(4.2) xsize(6.4)
graph export "$figures/ch07_conformal.png", replace width(2400)
di "PCT_OUTSIDE " %4.1f `pctout'
di "FIGURE_CONFORMAL_SAVED"


di "DONE"
