* test_likertscale.do -- behavioral contract for likertscale
clear all
adopath ++ "`c(pwd)'"
set varabbrev off

* --- build a known 1-5 battery ----------------------------------------------
clear
set seed 20260704
set obs 200
gen latent = rnormal()
forvalues i = 1/4 {
    gen q`i' = max(1, min(5, round(3 + latent + rnormal(0,.6))))
}
gen q5 = max(1, min(5, round(3 + 0.1*latent + rnormal(0,1))))  // weak item

* --- (1) defaults: top-two-box agree, index, alpha --------------------------
likertscale q1 q2 q3 q4 q5
assert r(items) == 5
assert "`r(agree)'" == "4 5"
assert r(alpha) > 0 & r(alpha) < 1
confirm variable scaleindex agree1 agree5
quietly count if agree1 != 100 & agree1 != 0 & !missing(agree1)
assert r(N) == 0
* agree matches manual top-two-box
gen manual1 = 100*inlist(q1, 4, 5) if !missing(q1)
assert agree1 == manual1

* --- (2) index equals rowmean ------------------------------------------------
egen manidx = rowmean(q1 q2 q3 q4 q5)
assert abs(scaleindex - manidx) < 1e-9

* --- (3) custom agree set + names + noalpha ----------------------------------
drop scaleindex agree1-agree5
likertscale q1 q2 q3, agree(5) genstub(top) index(idx3) noalpha noreport
assert "`r(agree)'" == "5"
assert r(alpha) >= .
confirm variable idx3 top1 top3
gen m3 = 100*(q3 == 5) if !missing(q3)
assert top3 == m3

* --- (4) existing target variable errors cleanly -----------------------------
capture noisily likertscale q1 q2, index(idx3)
assert _rc != 0

di as res "ALL TESTS PASSED"
