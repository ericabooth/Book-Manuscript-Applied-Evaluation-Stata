* test_srctag.do -- behavioral contract for srctag + srcfind
clear all
adopath ++ "`c(pwd)'"
set varabbrev off

sysuse auto, clear

* --- (1) stamp and read back -------------------------------------------------
srctag price mpg, source(dealer file 2026) vintage(2026-07)
assert r(n) == 2
local s : char price[source]
assert `"`s'"' == "dealer file 2026"
local v : char mpg[source_vintage]
assert `"`v'"' == "2026-07"

* --- (2) refuse silent overwrite; allow with replace -------------------------
capture noisily srctag price, source(other)
assert _rc == 110
srctag price, source(EPA extract) replace
local s : char price[source]
assert `"`s'"' == "EPA extract"

* --- (3) srcfind by pattern and all -------------------------------------------
srctag weight length, source(dealer file 2026)
srcfind dealer, noreport
assert r(n) == 3
assert strpos("`r(varlist)'", "mpg") > 0
srcfind , all noreport
assert r(n) == 4
srcfind nomatch, noreport
assert r(n) == 0

* --- (3b) dataset-level manifest accumulates unique sources -------------------
local m : char _dta[sources]
assert strpos(`"`m'"', "dealer file 2026") > 0
assert strpos(`"`m'"', "EPA extract") > 0

* --- (4) characteristics survive save/use -------------------------------------
tempfile t
save "`t'"
use "`t'", clear
local s : char mpg[source]
assert `"`s'"' == "dealer file 2026"

di as res "ALL TESTS PASSED"
