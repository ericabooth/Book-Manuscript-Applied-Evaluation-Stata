* test_llmsieve.do -- behavioral contract for llmsieve
clear all
adopath ++ "`c(pwd)'"
set varabbrev off

* --- (1) known distances ---------------------------------------------------
clear
input str20 a str20 b
"kitten"   "sitting"
"transport" "transport"
"abc"      "xyz"
""         ""
"health"   "wealth"
end
llmsieve a b, gendelta(d) genflag(f) threshold(.5)
assert r(N) == 5
* lev(kitten,sitting)=3, max len 7 -> 3/7
assert abs(d[1] - 3/7) < 1e-6
assert d[2] == 0
assert d[3] == 1
assert d[4] == 0
assert abs(d[5] - 1/6) < 1e-6
assert f[3] == 1 & f[1] == 0 & f[2] == 0
assert r(flagged) == 1

* --- (2) threshold moves the routing count ---------------------------------
llmsieve a b, threshold(.1) noreport
assert r(flagged) == 3

* --- (3) if restriction ------------------------------------------------------
llmsieve a b if _n <= 2, noreport
assert r(N) == 2

di as res "ALL TESTS PASSED"
