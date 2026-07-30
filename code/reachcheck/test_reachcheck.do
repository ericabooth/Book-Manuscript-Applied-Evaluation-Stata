* test_reachcheck.do -- behavioral contract for reachcheck
* run: stata-mp -b do test_reachcheck.do ; grep for ALL TESTS PASSED
clear all
adopath ++ "`c(pwd)'"
set varabbrev off

* --- (1) basic run on nlsw88 race, percentages ---------------------------
sysuse nlsw88, clear
quietly count if !missing(race)
local NN = r(N)
forvalues k = 1/3 {
    quietly count if race == `k'
    local n`k' = r(N)
    local p`k' = 100*r(N)/`NN'
}
reachcheck race, target(70 20 10)
assert r(N) == `NN'
matrix T = r(table)
assert abs(T[1,1] - `p1') < .01
assert abs(T[2,1] - `p2') < .01
assert abs(T[3,1] - `p3') < .01
assert abs(T[1,2] - 70) < .001 & abs(T[2,2] - 20) < .001 & abs(T[3,2] - 10) < .001
* the largest |gap| among the three, with its sign
local g1 = `p1' - 70
local g2 = `p2' - 20
local g3 = `p3' - 10
local want = `g1'
if abs(`g2') > abs(`want') local want = `g2'
if abs(`g3') > abs(`want') local want = `g3'
assert abs(r(maxgap) - (`want')) < .01

* --- (2) shares auto-detect gives identical answers ----------------------
reachcheck race, target(.70 .20 .10) noreport
assert abs(r(maxgap) - (`want')) < .01

* --- (3) category-count mismatch errors cleanly --------------------------
capture noisily reachcheck race, target(70 30)
assert _rc == 198

* --- (4) nonsense target sum errors cleanly ------------------------------
capture noisily reachcheck race, target(10 10 10)
assert _rc == 198

* --- (5) if restriction honored ------------------------------------------
quietly count if collgrad == 1 & !missing(race)
local nsub = r(N)
reachcheck race if collgrad == 1, target(80 15 5) noreport
assert r(N) == `nsub'

* --- (6) perfect target gives chi2 ~ 0 and tiny maxgap -------------------
reachcheck race, target(`p1' `p2' `p3') noreport
assert abs(r(maxgap)) < .01
assert r(chi2) < .001

di as res "ALL TESTS PASSED"
