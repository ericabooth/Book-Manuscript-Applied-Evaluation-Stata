*==============================================================================*
* ch05_monitoring.do  --  Chapter 5: watching response rates while a survey is
* alive, and reporting a Likert battery as percent agree.
* SIMULATED data (set seed 20260704). Two parts:
*   (1) 8 sites x 6 weeks of response rates -> small-multiples control chart
*       (ch05_monitor.png) + an alert list of flagged site-weeks.
*   (2) a 5-item coaching-satisfaction battery -> Cronbach's alpha + a
*       percent-agree (top-two-box) table by site.
* No API key or platform access required; everything is generated locally.
*==============================================================================*
* Globals normally live in code/00_control.do; they are defined here so this
* file runs standalone. Point them at your own project folders.
global figures "`c(pwd)'/figures"
capture mkdir "$figures"

version 17
set more off

*==============================================================================*
* PART 1 -- Response-rate control chart
*==============================================================================*
clear
set seed 20260704
set obs 48
egen site = seq(), block(6)          // 8 sites, 6 rows each
bysort site: gen week = _n           // field week 1..6
gen rate = 70 + rnormal(0, 6)        // target centerline 70%
replace rate = rate - 14 if inlist(site,3,6) & week>=4   // two laggards
replace rate = min(max(rate,0),100)

*--- Control limits from the process (2 SD around the 70% target) -------------*
quietly summarize rate
local cl  = 70
local sd  = r(sd)
local lcl = `cl' - 2*`sd'
local ucl = `cl' + 2*`sd'
gen byte alarm = rate < `lcl'

di as txt "CL=`cl'  SD=" %5.2f `sd' "  LCL=" %5.2f `lcl' "  UCL=" %5.2f `ucl'

*--- Alert list: site-weeks below the lower control limit ---------------------*
di as txt _n "==== ALERT LIST: site-weeks below LCL ===="
list site week rate if alarm, clean noobs
quietly count if alarm
di as txt "FLAGGED_SITEWEEKS=" r(N)
quietly levelsof site if alarm, local(bad)
di as txt "FLAGGED_SITES: `bad'"

*--- Small-multiples control chart, one panel per site -----------------------*
twoway (line rate week, sort lcolor(navy))                       ///
       (scatter rate week if alarm,                              ///
            mcolor(cranberry) msize(medium)),                    ///
    by(site, note("") title("Weekly response rate by site"       ///
        " (simulated)", size(medium))                            ///
        legend(off) rows(2) graphregion(margin(l=2 r=6)))        ///
    yline(`cl', lp(dash) lcolor(gs8))                            ///
    yline(`lcl', lp(dot) lcolor(gs10))                           ///
    yline(`ucl', lp(dot) lcolor(gs10))                           ///
    ytitle("Response rate (%)") xtitle("Field week")             ///
    ylabel(40(20)100, labsize(small)) xlabel(1(1)6, labsize(small))
graph export "$figures/ch05_monitor.png", replace width(2400)

*==============================================================================*
* PART 2 -- Likert battery: Cronbach's alpha + percent agree by site
*==============================================================================*
clear
set seed 20260704
set obs 320                          // ~40 respondents x 8 sites
egen site = seq(), block(40)

* latent site quality: sites 3 and 6 run low (mirrors the laggards above)
gen siteq = 0.55
replace siteq = -0.75 if inlist(site,3,6)
gen respq = siteq + rnormal(0,0.7)   // person-level latent satisfaction

* 5 correlated items on a 1..5 Likert scale; item difficulty varies so the
* rank order (Q3 easiest, Q4 hardest) is stable across sites.
local diff3 =  0.35
local diff4 = -0.35
forvalues i = 1/5 {
    local d = 0
    if `i'==3 local d =  0.35
    if `i'==4 local d = -0.35
    gen double z`i' = respq + `d' + rnormal(0,0.6)
    gen byte q`i' = 1 + (z`i'>-1.1) + (z`i'>-0.4) ///
                      + (z`i'>0.3) + (z`i'>1.0)
    drop z`i'
    label var q`i' "Item `i'"
}

*--- Reliability of the battery ----------------------------------------------*
alpha q1 q2 q3 q4 q5

*--- Top-two-box percent agree (=4 or =5) by site + scale mean ---------------*
egen scalemean = rowmean(q1 q2 q3 q4 q5)
forvalues i = 1/5 {
    gen byte agree`i' = q`i'>=4 if !missing(q`i')
}
* percent = mean of the 0/1 agree indicators, x100
forvalues i = 1/5 {
    replace agree`i' = 100*agree`i'
}
di as txt _n "==== PERCENT AGREE BY SITE (top-two-box) ===="
table site, statistic(mean agree1 agree2 agree3 agree4 agree5)

di as txt _n "==== SCALE MEAN (1-5) BY SITE ===="
tabstat scalemean, by(site) statistics(mean) format(%4.2f)

di as txt _n "==== POOLED (all sites) ===="
summarize agree1 agree2 agree3 agree4 agree5 scalemean

*==============================================================================*
* (z) Careless-responding screen: straight-liners and speeders
*     Printed in ch05 "The respondent who was not really there".
*     400 simulated responses, q5 reverse-worded, 12 planted straight-liners.
*==============================================================================*
clear
set seed 20260704
set obs 400
gen latent = rnormal(0,1)
forvalues i = 1/4 {
    gen q`i' = max(1, min(5, round(3.4 + .9*latent + rnormal(0,.7))))
}
* q5 is reverse-worded on the form
gen q5 = max(1, min(5, round(3.6 - .9*latent + rnormal(0,.7))))
gen duration_sec = round(rgamma(9, 34))
* plant 12 straight-liners: all 4s on the raw form, fast finishes
replace q1=4 if _n<=12
replace q2=4 if _n<=12
replace q3=4 if _n<=12
replace q4=4 if _n<=12
replace q5=4 if _n<=12
replace duration_sec = round(rgamma(3, 16)) if _n<=12
egen rowsd_raw = rowsd(q1 q2 q3 q4 q5)
gen q5r = 6 - q5
egen scale = rowmean(q1 q2 q3 q4 q5r)
count if rowsd_raw==0
assert r(N)==14
gen byte flag = rowsd_raw==0 | duration_sec < 90
count if flag
assert r(N)==16
summarize scale
summarize scale if !flag
di "CARELESS_SCREEN_OK"


di "DONE"
