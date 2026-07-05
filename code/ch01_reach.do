*==============================================================================*
* ch01_reach.do  --  Chapter 1: the embedded evaluator
* Builds the opening rural-reach exhibit from SIMULATED enrollment (seed
* 20260704): for five host sites, a committed target rural share and an
* observed share, drawn side by side. No external data, no key. This is the
* concrete Monday exhibit behind the foundation officer's Thursday email.
*==============================================================================*

* Paths: in the full project these come from code/00_control.do. They are
* defined here (only if missing) so this file also runs standalone.
if "$figures" == "" {
    global root "`c(pwd)'"
    global figures "$root/figures"
    capture mkdir "$figures"
}

*--- 1. Simulate five host sites: target vs observed rural share ---------------*
* Simulated data. The fixed seed makes the exhibit rebuild identically.
clear
set seed 20260704
set obs 5
gen site = ""
replace site = "Bluff"    in 1
replace site = "Cedar"    in 2
replace site = "Delta"    in 3
replace site = "Elm"      in 4
replace site = "Fork"     in 5

* Each site committed to a target rural share matched to its catchment (some
* sit in more rural regions and promised more). Observed share is the target
* plus site-level noise: three sites clear the bar, two fall short.
gen target = .
replace target = 35 in 1
replace target = 45 in 2
replace target = 40 in 3
replace target = 55 in 4
replace target = 50 in 5
gen noise = rnormal(0, 12)
summarize noise, meanonly
replace noise = noise - r(mean)   // center so gaps straddle zero
gen observed = round(target + noise)
replace observed = 0   if observed < 0
replace observed = 100 if observed > 100
drop noise
di "SIMULATED  obs = " _N
list site target observed, clean noobs

*--- 2. The payoff figure: observed vs target rural share by site -------------*
graph bar (asis) target observed, ///
    over(site, label(labsize(small))) ///
    bar(1, color(gs10)) bar(2, color(navy)) ///
    blabel(bar, format(%3.0f)) ///
    legend(order(1 "Target" 2 "Observed")) ///
    title("Rural enrollment share by site (simulated)", ///
        size(medium)) ///
    note("Simulated data, seed 20260704.", size(vsmall)) ///
    graphregion(margin(l=2 r=6)) ysize(4) xsize(7.2)
graph export "$figures/ch01_reach.png", replace width(2400)
di "FIGURE_SAVED"

di "DONE"
