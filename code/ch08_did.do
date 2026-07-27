*==============================================================================*
* ch08_did.do  --  Chapter 8: from differences to defensible claims
* (a) SIMULATED staggered adoption: 60 units, 12 periods, cohorts at t=5,9
*     plus a never-treated group; dynamic effect growing 2 -> 9 (t=5 cohort).
*     Naive TWFE (reghdfe) vs Callaway-Sant'Anna (csdid) against a KNOWN truth.
* (b) Event-study figure from csdid (pre-trend read).
* (c) ROI Monte Carlo -> tornado horizontal-bar chart.
* All blocks are SIMULATED with seed 20260704 and labeled simulated in the text.
* Packages assumed preinstalled: reghdfe, ftools, csdid, drdid, estout.
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
set more off

*--- (a) Simulate a staggered rollout with a KNOWN truth ----------------------*
* 60 units, 12 periods. Cohort 1 (units 1-20) adopts at t=5; cohort 2
* (units 21-40) adopts at t=9; units 41-60 are never treated (cohort 0).
* The treatment effect is dynamic: 2 in the first exposed period, +1 each
* period after (exposure 0 -> effect 2; the t=5 cohort reaches exposure 7 ->
* effect 9 by the final period, while the late t=9 cohort tops out at 5).
set seed 20260704
set obs 60
gen unit   = _n
gen cohort = cond(unit<=20, 5, cond(unit<=40, 9, 0))
gen unit_fe = rnormal(0, 2)

expand 12
bysort unit: gen period = _n
bysort period: gen time_fe = rnormal(0, 1)

gen exposure = cond(cohort==0, ., period - cohort)
gen treated  = cohort>0 & period>=cohort
gen effect   = cond(treated, 2 + exposure, 0)
gen y = 5 + unit_fe + time_fe + effect + rnormal(0, 1)

* The truth, by construction: mean effect over all treated unit-periods.
quietly summarize effect if treated
scalar true_att = r(mean)
di "---TRUE ATT (BY CONSTRUCTION)---"
di "true ATT = " %5.3f true_att

save "$clean/ch08_panel.dta", replace

*--- (a) Naive two-way fixed-effects: one dummy, one number (biased) ----------*
di "---NAIVE TWFE (reghdfe)---"
reghdfe y treated, absorb(unit period) vce(cluster unit)
scalar twfe_b  = _b[treated]
scalar twfe_se = _se[treated]

*--- (a) Callaway-Sant'Anna: clean comparison group, then aggregate -----------*
di "---CSDID SIMPLE AGGREGATION---"
csdid y, ivar(unit) time(period) gvar(cohort) method(dripw)
estat simple
scalar cs_b  = r(b)[1,1]
scalar cs_se = sqrt(r(V)[1,1])

di "---THREE NUMBERS SIDE BY SIDE---"
di "true ATT  = " %5.3f true_att
di "TWFE      = " %5.3f twfe_b  "  (se " %4.3f twfe_se ")"
di "csdid     = " %5.3f cs_b    "  (se " %4.3f cs_se ")"

*--- (b) Event study: aggregate by time since treatment, plot -----------------*
di "---CSDID EVENT AGGREGATION---"
csdid y, ivar(unit) time(period) gvar(cohort) method(dripw)
estat event
csdid_plot,                                                          ///
    title("Event study: effect by time since treatment",            ///
        size(medium))                                                ///
    ytitle("Estimated effect (outcome units)", size(small))          ///
    xtitle("Periods since treatment", size(small))                   ///
    note("Simulated: 60 units, 12 periods, cohorts at t=5 and t=9," ///
        " never-treated controls; true effect grows 2 to 9.",        ///
        size(vsmall))                                                ///
    legend(order(2 "Pre-treatment (should be flat near 0)"           ///
        4 "Post-treatment (the estimated effect)")                   ///
        rows(2) size(small) position(3)                              ///
        region(lstyle(none)))                                        ///
    graphregion(margin(l=2 r=6)) ysize(4.2) xsize(7.0)
graph export "$figures/ch08_event.png", replace width(2400)
di "FIGURE_EVENT_SAVED"

*--- (c) ROI Monte Carlo -----------------------------------------------------*
* Price the training program: annual per-participant earnings gain, per-seat
* cost, a persistence horizon of 3-5 years, and a discount rate 2-7%. Draw
* each input 10,000 times and summarize the resulting ROI distribution.
clear
set seed 20260704
local reps 10000
set obs `reps'
gen roi = .
forvalues i = 1/`reps' {
    local gain  = rnormal(3000, 900)
    local cost  = rnormal(4200, 400)
    if `cost' < 500 local cost = 500
    local years = 3 + int(3*runiform())
    local disc  = 0.02 + 0.05*runiform()
    local pv = 0
    forvalues t = 1/`years' {
        local pv = `pv' + `gain'/(1+`disc')^`t'
    }
    quietly replace roi = (`pv' - `cost')/`cost' in `i'
}
di "---ROI DISTRIBUTION---"
summarize roi, detail

*--- (c) Tornado: one-at-a-time sensitivity, low/high swing per input ---------*
* Center each input; move ONE input to its low/high plausible bound with the
* others held at center; record the ROI swing (high ROI - low ROI).
* Centers: gain 3000, cost 4200, years 4, disc 0.045.
clear
capture program drop roi_at
program define roi_at, rclass
    args gain cost years disc
    local pv = 0
    local yr = round(`years')
    forvalues t = 1/`yr' {
        local pv = `pv' + `gain'/(1+`disc')^`t'
    }
    return scalar roi = (`pv' - `cost')/`cost'
end

* plausible low/high bounds per input (roughly the 10th/90th pct of each draw)
* gain:  1850 .. 4150   cost: 3690 .. 4710   years: 3 .. 5   disc: .025 .. .065
roi_at 1850 4200 4 0.045
scalar gain_lo = r(roi)
roi_at 4150 4200 4 0.045
scalar gain_hi = r(roi)
roi_at 3000 3690 4 0.045
scalar cost_hi = r(roi)
roi_at 3000 4710 4 0.045
scalar cost_lo = r(roi)
roi_at 3000 4200 3 0.045
scalar yr_lo = r(roi)
roi_at 3000 4200 5 0.045
scalar yr_hi = r(roi)
roi_at 3000 4200 4 0.025
scalar disc_hi = r(roi)
roi_at 3000 4200 4 0.065
scalar disc_lo = r(roi)

clear
set obs 4
gen str18 input = ""
gen swing = .
replace input = "Earnings gain"       in 1
replace swing = abs(gain_hi - gain_lo) in 1
replace input = "Persistence (yrs)"    in 2
replace swing = abs(yr_hi - yr_lo)     in 2
replace input = "Per-seat cost"        in 3
replace swing = abs(cost_hi - cost_lo) in 3
replace input = "Discount rate"        in 4
replace swing = abs(disc_hi - disc_lo) in 4
gsort -swing
di "---TORNADO SWINGS (ROI range per input)---"
list input swing, noobs

graph hbar (asis) swing, over(input, sort(1)                          ///
        label(labsize(small)))                                        ///
    bar(1, color(navy)) blabel(bar, format(%4.2f))                    ///
    ytitle("Swing in ROI (low bound to high bound)", size(small))     ///
    title("Tornado: what moves the ROI", size(medium))               ///
    note("Simulated: each input alone swept low to high, others at" ///
        " center. Longer bar = input the debate should focus on.",   ///
        size(vsmall))                                                 ///
    graphregion(margin(l=2 r=6)) ysize(3.6) xsize(7.2)
graph export "$figures/ch08_tornado.png", replace width(2400)
di "FIGURE_TORNADO_SAVED"


*==============================================================================*
* (d) Cut-score flip demo: two parallel forms, reliability .85, cut at p60.
*     Printed in ch08 "The cut score: analyze the score, report the label".
*==============================================================================*
clear
set seed 20260704
set obs 5000
gen true  = rnormal(0,1)
gen formA = true + rnormal(0, sqrt(1/.85 - 1))
gen formB = true + rnormal(0, sqrt(1/.85 - 1))
corr formA formB
_pctile formA, p(60)
scalar cut = r(r1)
gen byte profA = formA >= cut
gen byte profB = formB >= cut
count if profA != profB
assert r(N)==876
gen dist = abs(formA - cut)
gen byte flip = profA != profB
summarize flip if dist < .5
summarize flip if dist >= 1.5
di "CUTSCORE_FLIP_OK"

di "DONE"
