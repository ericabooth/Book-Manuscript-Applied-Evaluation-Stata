* ==========================================================================
* test_hlmr2.do -- test battery for hlmr2 (v0.1.0)
* Run in batch from a scratch directory:  stata-mp -b do test_hlmr2.do
* Judge by the log: zero r(NNN); no "assertion is false".
* ==========================================================================

* ---- header: the only place a path appears ------------------------------
global pkgroot "/Users/ebooth/Documents/GitHub/Book Manuscript:Applied Evaluation-Stata/hlmr2-stata-public"

version 16.0
clear all
set more off
set seed 20260706

adopath ++ "$pkgroot"
which hlmr2

* ==========================================================================
di as txt "[TEST 1] two-level model on nlsw88 (sd() path, real data)"
* ==========================================================================
sysuse nlsw88, clear
mixed wage grade age || industry: , nolog
hlmr2

* returns exist and are coherent
assert !missing(r(r2_m)) & !missing(r(r2_c))
assert !missing(r(var_f)) & !missing(r(var_ran)) & !missing(r(var_e))
assert r(r2_m) > 0 & r(r2_m) < 1
assert r(r2_c) > 0 & r(r2_c) < 1
assert r(r2_c) >= r(r2_m)
assert r(var_f) > 0 & r(var_ran) > 0 & r(var_e) > 0
assert "`r(depvar)'" == "wage"
assert r(N) == e(N)

local t1_r2m   = r(r2_m)
local t1_r2c   = r(r2_c)
local t1_vf    = r(var_f)
local t1_vran  = r(var_ran)
local t1_ve    = r(var_e)

* internal identity: R2s recombine from the stored pieces
local tot = `t1_vf' + `t1_vran' + `t1_ve'
assert reldif(`t1_r2m', `t1_vf'/`tot')  < 1e-12
assert reldif(`t1_r2c', (`t1_vf'+`t1_vran')/`tot') < 1e-12

* predict-then-check: Var(xb) on e(sample) matches r(var_f)
tempvar xbchk
qui predict double `xbchk' if e(sample), xb
qui summarize `xbchk' if e(sample)
assert reldif(r(Var), `t1_vf') < 1e-10

* residual variance matches the model's own exp(lnsig_e)^2
assert reldif(`t1_ve', exp([lnsig_e]_b[_cons])^2) < 1e-8

* ==========================================================================
di as txt "[TEST 2] var() parameter labels give identical results"
* ==========================================================================
* The variance option makes hlmr2 read the -estat sd, variance- table
* (var() labels) instead of the sd() one; results must match TEST 1.
hlmr2, variance nodisplay
assert reldif(r(r2_m),    `t1_r2m')  < 1e-10
assert reldif(r(r2_c),    `t1_r2c')  < 1e-10
assert reldif(r(var_ran), `t1_vran') < 1e-10
assert reldif(r(var_e),   `t1_ve')   < 1e-10

* ==========================================================================
di as txt "[TEST 3] three-level synthetic model (2 random-effects levels)"
* ==========================================================================
clear
set seed 20260706
set obs 40
gen region = _n
gen u_r = rnormal(0, 1.5)
expand 10
bysort region: gen district = _n
gen u_d = rnormal(0, 1)
expand 8
gen x1 = rnormal()
gen x2 = rnormal()
gen y = 1 + 0.8*x1 - 0.5*x2 + u_r + u_d + rnormal(0, 1)

mixed y x1 x2 || region: || district: , nolog
hlmr2, format(%12.6f)

assert r(r2_m) > 0 & r(r2_m) < 1
assert r(r2_c) > r(r2_m) & r(r2_c) < 1
assert r(var_ran) > 0
* var_ran should absorb both levels: roughly 1.5^2 + 1^2 = 3.25
assert r(var_ran) > 1.5 & r(var_ran) < 6
* residual variance close to 1 by construction
assert abs(r(var_e) - 1) < 0.25
* fixed-effects variance roughly 0.8^2 + 0.5^2 = 0.89
assert abs(r(var_f) - 0.89) < 0.30

* ==========================================================================
di as txt "[TEST 4] math sanity: intercept-only model, ICC known by design"
* ==========================================================================
* u_j ~ N(0, 2^2), e ~ N(0, 1)  =>  ICC = 4 / (4 + 1) = 0.80
clear
set seed 20260706
set obs 200
gen g = _n
gen u = rnormal(0, 2)
expand 30
gen y = 5 + u + rnormal(0, 1)

mixed y || g: , nolog
hlmr2

* no covariates: xb is constant, so marginal R2 is exactly 0
assert r(var_f) < 1e-12
assert r(r2_m)  < 1e-12
* conditional R2 equals the constructed ICC within tolerance
assert abs(r(r2_c) - 0.80) < 0.05
* and equals the ICC identity from its own stored pieces
assert reldif(r(r2_c), r(var_ran)/(r(var_ran) + r(var_e))) < 1e-12

* cross-check against official -estat icc-
local t4_r2c = r(r2_c)
qui estat icc
assert abs(r(icc2) - `t4_r2c') < 1e-6

* ==========================================================================
di as txt "[TEST 5] options: nodisplay and format()"
* ==========================================================================
sysuse nlsw88, clear
mixed wage grade age || industry: , nolog

hlmr2, nodisplay
assert !missing(r(r2_m)) & !missing(r(r2_c))
assert reldif(r(r2_m), `t1_r2m') < 1e-12
assert reldif(r(r2_c), `t1_r2c') < 1e-12

hlmr2, format(%12.6f)
assert reldif(r(r2_m), `t1_r2m') < 1e-12

* invalid display format is rejected with r(120)
capture noisily hlmr2, format(banana)
assert _rc == 120

* ==========================================================================
di as txt "[TEST 6] random-slope model runs, notes the approximation"
* ==========================================================================
sysuse nlsw88, clear
mixed wage grade age || industry: age , nolog
hlmr2
assert r(r2_m) > 0 & r(r2_m) < 1
assert r(r2_c) >= r(r2_m) & r(r2_c) < 1
assert r(var_ran) > 0

* ==========================================================================
di as txt "[TEST 7] error cases: last estimates not from mixed -> r(301)"
* ==========================================================================
sysuse auto, clear
regress price mpg weight
capture noisily hlmr2
assert _rc == 301

ereturn clear
capture noisily hlmr2
assert _rc == 301

* ==========================================================================
di as txt "ALL hlmr2 TESTS PASSED"
* ==========================================================================
exit, clear
