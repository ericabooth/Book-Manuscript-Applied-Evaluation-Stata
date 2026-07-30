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

* likertscale bundles index + alpha + percent-agree in one call
adopath ++ "`c(pwd)'/likertscale"
likertscale q1 q2 q3 q4 q5, agree(4 5) genstub(ls_) index(ls_index)
assert abs(r(alpha) - .907) < .01
drop ls_index ls_1 ls_2 ls_3 ls_4 ls_5
di "LIKERTSCALE_DEMO_OK"

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


*==============================================================================*
* (y) reachcheck demo: sample composition vs supposed frame margins
*     Printed in ch05 "The one-line frame comparison".
*==============================================================================*
adopath ++ "`c(pwd)'/reachcheck"
sysuse nlsw88, clear
reachcheck race, target(70 20 10)
assert r(N) == 2246
assert abs(r(chi2) - 218.1) < 0.5
di "REACHCHECK_DEMO_OK"


*==============================================================================*
* (x) surveypull dry runs: the platform calls, printed not sent
*==============================================================================*
adopath ++ "`c(pwd)'/surveypull"
surveypull redcap, url(https://redcap.youruni.edu/api/) token(YOURTOKEN) dryrun
surveypull qualtrics, datacenter(ca1) token(YOURTOKEN) survey(SV_abc123) dryrun
di "SURVEYPULL_DEMO_OK"


*==============================================================================*
* (n) nonresponse demo: frame with a response flag -> gaps, model, weights
*==============================================================================*
adopath ++ "`c(pwd)'/nonresponse"
preserve
clear
set seed 20260704
set obs 2000
gen byte region = 1 + (runiform() > 0.5)
gen byte young  = runiform() < 0.4
gen byte resp   = runiform() < (0.55 - 0.25*young + 0.10*(region==2))
label define reg 1 "North" 2 "South"
label values region reg
nonresponse resp, frame(region young) generate(w) nomodel
assert abs(r(maxgap)) > 3
di "NONRESPONSE_DEMO_OK"

*==============================================================================*
* (l) loebias demo: does the estimate settle as attempts accumulate?
*==============================================================================*
adopath ++ "`c(pwd)'/loebias"
clear
set seed 20260704
set obs 900
gen byte attempts = 1 + floor(3*runiform())
gen byte engaged  = runiform() < (0.60 - 0.15*(attempts==3))
loebias engaged, attempts(attempts)
assert r(stable) == 0
di "LOEBIAS_DEMO_OK"

*==============================================================================*
* (t) surveytracker demo: two waves into a tracker, third relog refused
*==============================================================================*
adopath ++ "`c(pwd)'/surveytracker"
local trk "`c(tmpdir)'/ch05_tracker.dta"
capture erase "`trk'"
sysuse auto, clear
keep price mpg foreign
surveytracker using "`trk'", wave(2026w1)
label variable mpg "Mileage, EPA revised"
surveytracker using "`trk'", wave(2026w2)
capture noisily surveytracker using "`trk'", wave(2026w1)
assert _rc == 110
di "SURVEYTRACKER_DEMO_OK"
restore


di "DONE"
