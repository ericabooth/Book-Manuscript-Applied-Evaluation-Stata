* test_nonresponse.do -- behavioral contract for nonresponse
clear all
adopath ++ "`c(pwd)'"
set varabbrev off

* --- frame of 2000 with response depending on group --------------------------
clear
set seed 20260704
set obs 2000
gen byte region = 1 + (runiform() > 0.5)
gen byte young  = runiform() < 0.4
gen double p    = 0.55 - 0.25*young + 0.10*(region==2)
gen byte resp   = runiform() < p
label define reg 1 "North" 2 "South"
label values region reg

* --- (1) diagnosis: gaps match hand computation -------------------------------
nonresponse resp, frame(region young) nomodel
matrix T = r(table)
quietly count if resp==1
local nr = r(N)
quietly count
local nf = r(N)
assert r(N) == 2000
quietly count if resp==1 & region==1
local a = 100*r(N)/`nr'
quietly count if region==1
local b = 100*r(N)/`nf'
assert abs(T[1,1] - `a') < 1e-6
assert abs(T[1,2] - `b') < 1e-6
assert abs(T[1,3] - (`a'-`b')) < 1e-6

* --- (2) raking recovers the frame margins ------------------------------------
nonresponse resp, frame(region young) generate(w) nomodel noreport
confirm variable w
quietly summarize w if resp==1
assert abs(r(mean) - 1) < 1e-6
* weighted respondent shares equal frame shares on both margins
foreach v in region young {
    quietly levelsof `v', local(levs)
    foreach l of local levs {
        quietly count if `v'==`l'
        local ftarg = r(N)/2000
        quietly summarize w if resp==1
        local wtot = r(sum)
        quietly summarize w if resp==1 & `v'==`l'
        local wsh = r(sum)/`wtot'
        assert abs(`wsh' - `ftarg') < 0.001
    }
}
assert r(iters) >= 1

* --- (3) refuses a category with zero responders -------------------------------
* force an empty responder cell on a fresh variable
gen byte cell4 = 1 + (region==2)*2 + young
replace resp = 0 if cell4 == 4
capture noisily nonresponse resp, frame(cell4) nomodel noreport
assert _rc == 459

* --- (4) non-binary flag errors -------------------------------------------------
gen byte bad = 2
capture noisily nonresponse bad, frame(region) nomodel
assert _rc == 198

di as res "ALL TESTS PASSED"
