* test_surveytracker.do -- behavioral contract for surveytracker
clear all
adopath ++ "`c(pwd)'"
set varabbrev off

local trk "`c(tmpdir)'/tracker_test.dta"
capture erase "`trk'"

* --- (1) first wave creates the tracker -----------------------------------------
sysuse auto, clear
keep price mpg foreign
surveytracker using "`trk'", wave(2026w1)
assert r(vars) == 3
preserve
use "`trk'", clear
assert _N == 3
assert wave == "2026w1"
quietly count if varname == "foreign" & vallabname == "origin"
assert r(N) == 1
quietly count if varname == "foreign" & strpos(vallabtext, "0=Domestic") > 0
assert r(N) == 1
restore

* --- (2) second wave appends; label change is visible -----------------------------
label variable mpg "Mileage, EPA revised"
surveytracker using "`trk'", wave(2026w2)
preserve
use "`trk'", clear
assert _N == 6
quietly count if wave == "2026w2" & varname == "mpg" & varlab == "Mileage, EPA revised"
assert r(N) == 1
restore

* --- (3) re-logging a wave is refused, no override --------------------------------
capture noisily surveytracker using "`trk'", wave(2026w1)
assert _rc == 110

* --- (4) non-tracker target refused ------------------------------------------------
tempfile nottracker
preserve
sysuse auto, clear
save "`nottracker'"
restore
capture noisily surveytracker using "`nottracker'", wave(2026w3)
assert _rc == 198

* --- (5) varlist subset honored -----------------------------------------------------
surveytracker using "`trk'", wave(2026w3) varlist(price)
preserve
use "`trk'", clear
quietly count if wave == "2026w3"
assert r(N) == 1
restore

di as res "ALL TESTS PASSED"
