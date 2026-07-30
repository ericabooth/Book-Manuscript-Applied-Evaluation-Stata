* test_loebias.do -- behavioral contract for loebias
clear all
adopath ++ "`c(pwd)'"
set varabbrev off

* --- respondents by attempt count; late arrivals differ ------------------------
clear
set seed 20260704
set obs 900
gen byte attempts = 1 + floor(3*runiform())   // 1..3
gen byte outcome  = runiform() < (0.60 - 0.15*(attempts==3))

* --- (1) cumulative table matches hand computation ------------------------------
loebias outcome, attempts(attempts)
matrix T = r(table)
local lev = r(levels)
local fin = r(final)
local stab = r(stable)
assert `lev' == 3
quietly summarize outcome if attempts <= 1
assert abs(T[1,3] - r(mean)) < 1e-9
quietly summarize outcome if attempts <= 2
assert abs(T[2,3] - r(mean)) < 1e-9
quietly summarize outcome
assert abs(T[3,3] - r(mean)) < 1e-9
assert abs(`fin' - r(mean)) < 1e-9

* --- (2) drifting series flagged unstable ---------------------------------------
assert `stab' == 0

* --- (3) flat series flagged stable ----------------------------------------------
gen byte flat = mod(_n, 2)
sort attempts flat
by attempts: replace flat = mod(_n, 2)   // identical mix at every level
loebias flat, attempts(attempts) noreport
assert r(stable) == 1

* --- (4) too few effort levels refused --------------------------------------------
gen byte two = 1 + (attempts > 2)
capture noisily loebias outcome, attempts(two)
assert _rc == 198

* --- (5) graph option builds a named graph ----------------------------------------
loebias outcome, attempts(attempts) graphname(loetest) noreport
capture graph describe loetest
assert _rc == 0

di as res "ALL TESTS PASSED"
