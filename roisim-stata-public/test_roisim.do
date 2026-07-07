* test_roisim.do -- test battery for roisim
* Run in batch from any scratch directory:
*   stata-mp -b do test_roisim.do
* Judge by the log: zero r(NNN) and no "assertion is false".

* ------------------------------------------------------------- header
* All paths live in globals set here; nothing below is hard-coded.
global pkgroot   "/Users/ebooth/Documents/GitHub/Book Manuscript:Applied Evaluation-Stata/roisim-stata-public"
global scratchdir = c(tmpdir)
global torncsv   "$scratchdir/roisim_test_tornado.csv"

version 16.0
clear all
set more off
adopath + "$pkgroot"
set seed 20260706

di as txt "=== roisim test battery, seed 20260706 ==="

* ---------------------------------------------------- 1. basic run
roisim, effect(3000) se(900) costlow(3800) costhigh(4600) ///
    discount(0.035) horizon(4) reps(10000) seed(20260706)
assert r(reps)   == 10000
assert r(effect) == 3000
assert r(se)     == 900
assert r(costlow) == 3800 & r(costhigh) == 4600
assert r(njoiners) == 1 & r(value) == 1
assert "`r(cmd)'" == "roisim"

* percentiles must be weakly increasing
local prev = r(p1)
foreach p in 5 10 25 50 75 90 95 99 {
    assert r(p`p') >= `prev'
    local prev = r(p`p')
}
* moments bracket the percentiles
assert r(min) <= r(p1)  & r(p99) <= r(max)
assert r(sd) > 0
assert r(mean) > r(min) & r(mean) < r(max)

* break-even probability is a probability
assert r(prpos) >= 0 & r(prpos) <= 1

* central-value ROI matches a hand computation
local A     = (1 - 1.035^(-4))/0.035
local roi0  = (3000*`A' - 4200)/4200
assert reldif(r(roi_central), `roi0') < 1e-12
assert reldif(r(pvfactor), `A') < 1e-12
assert reldif(r(pv_central), 3000*`A') < 1e-12

* default sweep: effect and cost only (discount, horizon held fixed)
assert r(n_swept) == 2
matrix T1 = r(tornado)
assert rowsof(T1) == r(n_swept)
local p50_base = r(p50)
local p10_base = r(p10)
local p90_base = r(p90)
local mean_base = r(mean)

* ---------------------------------------------------- 2. reproducibility
roisim, effect(3000) se(900) costlow(3800) costhigh(4600) ///
    discount(0.035) horizon(4) reps(10000) seed(20260706)
assert reldif(r(mean), `mean_base') < 1e-14
assert reldif(r(p50),  `p50_base')  < 1e-14

* ---------------------------------------------------- 3. monotonicity: value
* higher value() must raise the median ROI (same seed, same draws)
roisim, effect(3000) se(900) costlow(3800) costhigh(4600) ///
    discount(0.035) horizon(4) reps(10000) seed(20260706) value(1.25)
assert r(p50) > `p50_base'
assert r(value) == 1.25

* ---------------------------------------------------- 4. wider cost range
* wider cost bounds around the same midpoint must widen the p10-p90 spread
roisim, effect(3000) se(900) costlow(4000) costhigh(4400) ///
    discount(0.035) horizon(4) reps(10000) seed(20260706)
local spread_narrow = r(p90) - r(p10)
roisim, effect(3000) se(900) costlow(3000) costhigh(5400) ///
    discount(0.035) horizon(4) reps(10000) seed(20260706)
local spread_wide = r(p90) - r(p10)
assert `spread_wide' > `spread_narrow'

* ---------------------------------------------------- 5. wider se fattens the loss tail
roisim, effect(3000) se(1500) costlow(3800) costhigh(4600) ///
    discount(0.035) horizon(4) reps(10000) seed(20260706)
assert r(p10) < `p10_base'

* ---------------------------------------------------- 6. prpos consistent with percentiles
* a clearly profitable program: p10 > 0 forces Pr(ROI>0) >= ~0.90
roisim, effect(3000) se(300) costlow(3800) costhigh(4600) ///
    discount(0.035) horizon(4) reps(10000) seed(20260706)
assert r(p10) > 0
assert r(prpos) >= 0.899
* a clearly unprofitable program: p90 < 0 forces Pr(ROI>0) <= ~0.10
roisim, effect(100) se(50) costlow(4000) costhigh(4400) ///
    discount(0.035) horizon(2) reps(10000) seed(20260706)
assert r(p90) < 0
assert r(prpos) <= 0.101

* ---------------------------------------------------- 7. scale invariance
* scaling participants and costs by the same factor leaves ROI unchanged
roisim, effect(3000) se(900) costlow(3800) costhigh(4600) ///
    discount(0.035) horizon(4) reps(10000) seed(20260706)
local p50_one = r(p50)
roisim, effect(3000) se(900) costlow(38000) costhigh(46000) ///
    njoiners(10) discount(0.035) horizon(4) reps(10000) seed(20260706)
assert reldif(r(p50), `p50_one') < 1e-10
assert r(njoiners) == 10

* ---------------------------------------------------- 8. value() in units, discount(0)
* zero discount rate: PV factor equals the horizon exactly
roisim, effect(0.15) se(0.05) value(9000) njoiners(200) ///
    costlow(150000) costhigh(210000) discount(0) horizon(5) ///
    reps(1000) seed(20260706)
assert r(pvfactor) == 5
local A0   = 5
local roi0 = (200*9000*0.15*`A0' - 180000)/180000
assert reldif(r(roi_central), `roi0') < 1e-12

* ---------------------------------------------------- 9. tornado with all four inputs
capture erase "$torncsv"
roisim, effect(3000) se(900) costlow(3800) costhigh(4600)   ///
    discountrange(0.02 0.07) horizonrange(3 5)              ///
    reps(10000) seed(20260706) saving("$torncsv", replace)
assert r(n_swept) == 4
matrix T4 = r(tornado)
assert rowsof(T4) == 4
assert colsof(T4) == 6
* swings are nonnegative and sorted longest-first
forvalues i = 1/4 {
    assert T4[`i', 6] >= 0
    if `i' > 1 assert T4[`i', 6] <= T4[`=`i'-1', 6]
}
assert "`r(saving)'" != ""
* percentile matrix ships too
matrix P = r(pct)
assert rowsof(P) == 1 & colsof(P) == 9
assert reldif(P[1,5], r(p50)) < 1e-14

* CSV round-trip: row count = number of swept inputs, sorted by swing
preserve
import delimited using "$torncsv", clear varnames(1)
assert _N == 4
confirm string variable input
confirm numeric variable low central high roi_low roi_high swing
assert swing >= 0
assert swing <= swing[_n-1] if _n > 1
* the four swept inputs, each exactly once
sort input
assert input[1] == "cost" & input[2] == "discount" ///
     & input[3] == "effect" & input[4] == "horizon"
restore

* ---------------------------------------------------- 10. user data untouched
sysuse auto, clear
datasignature
local sig1 "`r(datasignature)'"
roisim, effect(3000) se(900) costlow(3800) costhigh(4600) ///
    reps(500) seed(20260706)
datasignature
assert "`r(datasignature)'" == "`sig1'"

* ---------------------------------------------------- 11. deliberate errors
* negative se
capture noisily roisim, effect(3000) se(-1) costlow(3800) costhigh(4600)
local rc = _rc
assert `rc' == 198
* cost bounds reversed
capture noisily roisim, effect(3000) se(900) costlow(4600) costhigh(3800)
local rc = _rc
assert `rc' == 198
* nonpositive cost
capture noisily roisim, effect(3000) se(900) costlow(0) costhigh(4600)
local rc = _rc
assert `rc' == 198
* too few reps
capture noisily roisim, effect(3000) se(900) costlow(3800) ///
    costhigh(4600) reps(50)
local rc = _rc
assert `rc' == 198
* discount() and discountrange() together
capture noisily roisim, effect(3000) se(900) costlow(3800) ///
    costhigh(4600) discount(0.03) discountrange(0.02 0.07)
local rc = _rc
assert `rc' == 198
* saving() an existing file without replace -> r(602)
capture noisily roisim, effect(3000) se(900) costlow(3800) ///
    costhigh(4600) reps(500) seed(20260706) saving("$torncsv")
local rc = _rc
assert `rc' == 602

* ---------------------------------------------------- cleanup
capture erase "$torncsv"
clear

di as txt "=== all roisim tests passed ==="
