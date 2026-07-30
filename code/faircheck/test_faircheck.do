* test_faircheck.do -- behavioral contract for faircheck
clear all
adopath ++ "`c(pwd)'"
set varabbrev off

* --- deterministic confusion counts by group --------------------------------
clear
input byte group byte truth byte pred int n
1 1 1 40
1 1 0 10
1 0 1  5
1 0 0 45
2 1 1 20
2 1 0 20
2 0 1 15
2 0 0 45
end
expand n
drop n
label define g 1 "A" 2 "B"
label values group g

faircheck truth pred, by(group)
assert r(N) == 200
assert r(groups) == 2
matrix T = r(table)
* group A: sel 45/100, TPR 40/50=.8, FPR 5/50=.1 ; group B: sel 35/100, TPR .5, FPR .25
assert abs(T[1,3] - .45) < 1e-9
assert abs(T[2,3] - .35) < 1e-9
assert abs(T[1,4] - .8)  < 1e-9
assert abs(T[1,5] - .1)  < 1e-9
assert abs(T[2,4] - .5)  < 1e-9
assert abs(T[2,5] - .25) < 1e-9
assert abs(r(tpr_gap) - .3)  < 1e-9
assert abs(r(fpr_gap) - .15) < 1e-9
assert abs(r(parity_ratio) - 35/45) < 1e-9
assert r(parity_flag) == 1
* precision A: 40/45
assert abs(T[1,6] - 40/45) < 1e-9

* --- non-binary input errors cleanly -----------------------------------------
gen bad = 2
capture noisily faircheck bad pred, by(group)
assert _rc == 198

di as res "ALL TESTS PASSED"
