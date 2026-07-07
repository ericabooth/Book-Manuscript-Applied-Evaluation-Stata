* ==========================================================================
* test_rateshrink.do -- test battery for rateshrink v0.1.1
* Run from any scratch directory:  stata-mp -b do test_rateshrink.do
* All paths live in globals below; nothing else is hard-coded.
* ==========================================================================
global pkgroot "/Users/ebooth/Documents/GitHub/Book Manuscript:Applied Evaluation-Stata/rateshrink-stata-public"

version 16.0
clear all
set more off
set seed 20260706
adopath + "$pkgroot"
which rateshrink

* --------------------------------------------------------------------------
* Test 1: ebbeta (default) -- book-style setup: sites with caseloads 5-500,
* true completion rates near 0.20.  Checks returns, labels, and the two
* core shrinkage properties.
* --------------------------------------------------------------------------
display as text "{hline 70}"
display as text "TEST 1: ebbeta basics + shrinkage geometry"
clear
set obs 25
gen site  = _n
gen n     = 5 + int(495*runiform()^2)
gen ptrue = rbeta(8, 32)
gen y     = rbinomial(n, ptrue)
* force one small-n zero-success site (the book's site-26 pattern)
replace n = 7 in 1
replace y = 0 in 1

rateshrink, success(y) denominator(n) generate(pshrunk) id(site)

assert "`r(type)'" == "ebbeta"
assert r(alpha) > 0 & r(alpha) < .
assert r(beta)  > 0 & r(beta)  < .
assert r(N) == 25
scalar pbar    = r(mean)
scalar maxmove = r(maxmove)
assert pbar > 0 & pbar < 1
assert !missing(pshrunk)

gen double praw = y/n
* (a) shrunken rate lies between the raw rate and the grand (prior) mean:
*     same side, and never further from the mean than the raw rate
assert (praw - pbar)*(praw - pshrunk) >= -1e-10
assert abs(pshrunk - pbar) <= abs(praw - pbar) + 1e-10
* r(maxmove) matches the data and the most-moved unit was identified
local mu `"`r(maxunit)'"'
assert `"`mu'"' != ""
assert strpos(`"`mu'"', "= .") == 0     // unit label resolved, not missing
gen double amove = abs(pshrunk - praw)
summarize amove, meanonly
assert reldif(r(max), maxmove) < 1e-12

* (b) book qualitative behavior: the small-n zero-success site is pulled
*     up hard, well off zero and toward the pack
assert pshrunk[1] > praw[1]
assert pshrunk[1] > 0.5*pbar
assert amove[1]   > 0.05
drop praw amove

* --------------------------------------------------------------------------
* Test 2: small-n units move more than large-n units at the SAME raw rate
* (ebbeta), plus ci() posterior interval checks.
* --------------------------------------------------------------------------
display as text "{hline 70}"
display as text "TEST 2: ebbeta small-n vs large-n + ci()"
clear
set obs 22
gen unit = _n
gen n    = 20 + int(180*runiform())
gen y    = rbinomial(n, 0.2)
* two crafted units with identical raw rate 0.60 but very different n
replace n = 5   in 21
replace y = 3   in 21
replace n = 200 in 22
replace y = 120 in 22

rateshrink, success(y) denominator(n) generate(ps) ci(95) id(unit)

gen double praw = y/n
gen double move = abs(ps - praw)
assert reldif(praw[21], praw[22]) < 1e-12   // same raw rate by construction
assert move[21] > move[22]                  // small n pulled harder
* ci() sanity: bounds bracket the posterior mean and live in [0,1]
assert !missing(ps_lb) & !missing(ps_ub)
assert ps_lb <= ps & ps <= ps_ub
assert ps_lb >= 0 & ps_ub <= 1
assert ps_ub > ps_lb
* wider level => wider interval
rateshrink, success(y) denominator(n) generate(ps2) ci(50)
assert ps2_lb >= ps_lb - 1e-12 & ps2_ub <= ps_ub + 1e-12

* --------------------------------------------------------------------------
* Test 3: ebgamma -- event counts with exposure denominators; rates may
* exceed 1.  Same geometry checks against the exposure-weighted grand rate.
* --------------------------------------------------------------------------
display as text "{hline 70}"
display as text "TEST 3: ebgamma basics + geometry + ci()"
clear
set obs 20
gen unit    = _n
gen expos   = 10 + int(990*runiform()^2)
gen mu_true = rgamma(4, .05)          // mean event rate ~ 0.20
gen y       = rpoisson(expos*mu_true)
* crafted pair: identical raw rate, exposures 10 vs 800
replace expos = 10  in 19
replace y     = 8   in 19             // raw rate 0.80
replace expos = 800 in 20
replace y     = 640 in 20             // raw rate 0.80

rateshrink, success(y) denominator(expos) generate(rs) type(ebgamma) ci(90) id(unit)

assert "`r(type)'" == "ebgamma"
assert r(alpha) > 0 & r(beta) > 0
scalar rbar = r(mean)
* exposure-weighted grand rate = total events / total exposure
summarize y, meanonly
scalar sumy = r(sum)
summarize expos, meanonly
assert reldif(rbar, sumy/r(sum)) < 1e-10

gen double rraw = y/expos
assert (rraw - rbar)*(rraw - rs) >= -1e-10
assert abs(rs - rbar) <= abs(rraw - rbar) + 1e-10
gen double gmove = abs(rs - rraw)
assert gmove[19] > gmove[20]          // small exposure pulled harder
* ci() sanity for the gamma posterior
assert !missing(rs_lb) & !missing(rs_ub)
assert rs_lb <= rs & rs <= rs_ub
assert rs_lb >= 0
assert rs_ub > rs_lb

* --------------------------------------------------------------------------
* Test 4: if/in restrictions and missing handling
* --------------------------------------------------------------------------
display as text "{hline 70}"
display as text "TEST 4: if/in + missings"
clear
set obs 30
gen unit = _n
gen n    = 10 + int(100*runiform())
gen y    = rbinomial(n, 0.25)
replace y = . in 30                   // missing numerator ignored

rateshrink if unit <= 20, success(y) denominator(n) generate(psub)
assert r(N) == 20
assert !missing(psub) if unit <= 20
assert  missing(psub) if unit >  20

rateshrink in 5/25, success(y) denominator(n) generate(pin)
assert r(N) == 21
assert missing(pin[1]) & missing(pin[30])

* --------------------------------------------------------------------------
* Test 5: deliberate error cases -- capture and assert the exit codes
* --------------------------------------------------------------------------
display as text "{hline 70}"
display as text "TEST 5: error handling"
clear
set obs 10
gen n = 10
gen y = 5
replace y = 12 in 1                   // success > denominator

* (a) success > denominator under ebbeta -> 459
capture noisily rateshrink, success(y) denominator(n) generate(zz)
assert _rc == 459
capture confirm variable zz
assert _rc != 0                       // nothing generated on error

* (b) ...but the same data are legal under ebgamma
replace y = 5 in 1
replace y = 12 in 2
rateshrink, success(y) denominator(n) generate(zz) type(ebgamma)
drop zz

* (c) invalid type() -> 198
capture rateshrink, success(y) denominator(n) generate(zz) type(bogus)
assert _rc == 198

* (d) invalid ci() level -> 198
capture rateshrink, success(y) denominator(n) generate(zz) ci(150)
assert _rc == 198

* (e) existing generate() variable -> 110
gen taken = 1
capture rateshrink, success(y) denominator(n) generate(taken)
assert _rc == 110

* (f) negative success -> 459
replace y = -2 in 3
capture rateshrink, success(y) denominator(n) generate(zz)
assert _rc == 459
replace y = 5 in 3

* (g) nonpositive denominator -> 459
replace n = 0 in 4
capture rateshrink, success(y) denominator(n) generate(zz)
assert _rc == 459

* --------------------------------------------------------------------------
* Test 6: rel() -- Beta-binomial reliability n/(n + alpha + beta)
* --------------------------------------------------------------------------
display as text "{hline 70}"
display as text "TEST 6: rel() reliability"
clear
set obs 25
gen site = _n
gen n    = 5 + int(495*runiform()^2)
gen y    = rbinomial(n, rbeta(8, 32))

rateshrink, success(y) denominator(n) generate(pr) rel(reliab) id(site)

* (a) reliability exists, is labeled, and lies in (0, 1]
assert !missing(reliab)
assert reliab > 0 & reliab <= 1
local rlab : variable label reliab
assert `"`rlab'"' != ""

* (b) reliability matches the formula from the stored prior
scalar a = r(alpha)
scalar b = r(beta)
gen double relcheck = n/(n + a + b)
assert reldif(reliab, relcheck) < 1e-12

* (c) r(meanrel) matches the data
scalar mr = r(meanrel)
assert mr > 0 & mr <= 1
summarize reliab, meanonly
assert reldif(r(mean), mr) < 1e-12

* (d) larger-n units have (weakly) higher reliability at the same prior
sort n
assert reliab >= reliab[_n-1] in 2/L

* (e) reliability equals the shrinkage weight on the unit's own data:
*     pshrunk = reliab*praw + (1 - reliab)*priormean
gen double praw6  = y/n
gen double blend6 = reliab*praw6 + (1 - reliab)*(a/(a + b))
assert reldif(pr, blend6) < 1e-10

* (f) rel() with type(ebgamma) -> 198
capture rateshrink, success(y) denominator(n) generate(zz6) type(ebgamma) rel(r6)
assert _rc == 198
capture confirm variable zz6
assert _rc != 0
capture confirm variable r6
assert _rc != 0

* --------------------------------------------------------------------------
* Done
* --------------------------------------------------------------------------
display as text "{hline 70}"
display as result "ALL rateshrink TESTS PASSED"
display as text "{hline 70}"
