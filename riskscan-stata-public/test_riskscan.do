* test_riskscan.do -- test battery for riskscan v0.1.0
* Run from any scratch directory:  stata-mp -b do test_riskscan.do
* All paths live in globals set here; nothing below is hard-coded.

global pkgroot "/Users/ebooth/Documents/GitHub/Book Manuscript:Applied Evaluation-Stata/riskscan-stata-public"

clear all
set more off
set seed 20260706
adopath + "$pkgroot"
which riskscan

* ---------------------------------------------------------------------
* 1. Known-truth benchmark: nlsw88, four quasi-identifiers
*    (book ledger: 103 distinct cells, 24 unique records, 87 below k=5)
* ---------------------------------------------------------------------
sysuse nlsw88, clear
riskscan race married collgrad industry
assert r(cells) == 103
assert r(k1) == 24
assert r(below) == 87
assert r(kthreshold) == 5
assert r(N) == 2246

* ---------------------------------------------------------------------
* 2. k() threshold: with k(2), "below" is exactly the unique records
* ---------------------------------------------------------------------
riskscan race married collgrad industry, k(2)
assert r(kthreshold) == 2
assert r(below) == r(k1)
assert r(below) == 24

* ---------------------------------------------------------------------
* 3. flag(): byte variable, 1 exactly when cell size < threshold
* ---------------------------------------------------------------------
riskscan race married collgrad industry, flag(risky)
confirm byte variable risky
count if risky == 1
assert r(N) == 87
count if risky == 0
assert r(N) == 2246 - 87

* cross-check flag against a hand-rolled k (the book's own recipe)
egen __cell = group(race married collgrad industry), missing
bysort __cell: gen __k = _N
assert risky == (__k < 5)
drop __cell __k risky

* ---------------------------------------------------------------------
* 4. if/in restrictions
* ---------------------------------------------------------------------
count if south == 1
local nsouth = r(N)
riskscan race married collgrad industry if south == 1
assert r(N) == `nsouth'
local cells_south = r(cells)
assert `cells_south' > 0 & `cells_south' <= 103

riskscan race married collgrad in 1/100
assert r(N) == 100

* ---------------------------------------------------------------------
* 5. detail option runs and does not change the data or sort stability
* ---------------------------------------------------------------------
sysuse nlsw88, clear
riskscan race married collgrad industry, detail
assert r(cells) == 103
assert _N == 2246

* ---------------------------------------------------------------------
* 6. Missing counts as a level (matches the book's egen ..., missing)
* ---------------------------------------------------------------------
clear
set obs 4
gen x = .
replace x = 1 in 3/4
riskscan x, k(2)
assert r(cells) == 2
assert r(k1) == 0
assert r(below) == 0

* ---------------------------------------------------------------------
* 7. l-diversity: constructed l=1 cell (attribute disclosure)
* ---------------------------------------------------------------------
clear
set obs 30
gen grp = ceil(_n/10)                 // three cells of 10
gen diag = cond(grp == 1, 1, mod(_n, 3) + 1)
* cell grp==1: every record has diag==1  -> l = 1
* cells grp==2,3: diag varies            -> l = 3
riskscan grp, sensitive(diag)
assert r(cells) == 3
assert r(k1) == 0
assert r(l1_cells) == 1

* sensitive() also runs on real data without error
sysuse nlsw88, clear
riskscan race married collgrad industry, sensitive(union)
assert r(l1_cells) >= 0 & r(l1_cells) <= r(cells)

* ---------------------------------------------------------------------
* 8. All options together
* ---------------------------------------------------------------------
sysuse nlsw88, clear
riskscan race married collgrad industry, k(3) flag(thin) ///
    sensitive(union) detail
assert r(kthreshold) == 3
local below3 = r(below)
count if thin == 1
assert r(N) == `below3'
drop thin

* ---------------------------------------------------------------------
* 9. Deliberate error cases
* ---------------------------------------------------------------------
* k(0) is not a valid threshold -> 198
capture noisily riskscan race married, k(0)
assert _rc == 198

* flag() must name a NEW variable -> 110
gen byte already = 0
capture noisily riskscan race married, flag(already)
assert _rc == 110
drop already

* sensitive() variable may not also be a quasi-identifier -> 198
capture noisily riskscan race married union, sensitive(union)
assert _rc == 198

* empty sample -> 2000
capture noisily riskscan race married if race == 99
assert _rc == 2000

di as txt "test_riskscan.do: all asserts passed"
exit, clear
