* test_undummy.do -- test battery for the undummy package
* Run in batch from a scratch directory:  stata-mp -b do test_undummy.do
* Judge by the log: no r-numbered errors, no failed asserts.
* ---------------------------------------------------------------------
* All paths live in globals set here; nothing below is hard-coded.
global pkgroot "/Users/ebooth/Documents/GitHub/Book Manuscript:Applied Evaluation-Stata/undummy-stata-public"

version 16.0
clear all
set more off
set seed 20260706
adopath ++ "$pkgroot"
which undummy

* =====================================================================
* Test 1: round trip through tabulate, generate() (the book use case)
* =====================================================================
sysuse auto, clear
tab foreign, gen(fd)
undummy fd1 fd2, gen(origin) varnames
local r_k = r(k)
local r_g "`r(generate)'"
local r_b "`r(base)'"
assert `r_k' == 2
assert "`r_g'" == "origin"
assert "`r_b'" == "fd1"
* numeric dummies: first-listed dummy is category 1
assert origin == foreign + 1
* dummies dropped by default
cap confirm variable fd1
assert _rc == 111
cap confirm variable fd2
assert _rc == 111
* labels built from the dummy variable names
assert `"`:label (origin) 1'"' == "fd1"
assert `"`:label (origin) 2'"' == "fd2"

* =====================================================================
* Test 2: default generate name, keepdummies, valuelab()
* =====================================================================
sysuse auto, clear
tab foreign, gen(fd)
label define originlab 1 "Domestic" 2 "Foreign"
undummy fd1 fd2, valuelab(originlab) keepdummies
assert "`r(generate)'" == "undummy"
confirm variable undummy fd1 fd2
assert "`:value label undummy'" == "originlab"
assert undummy == foreign + 1
* new variable carries the first dummy's variable label
assert `"`:variable label undummy'"' == `"`:variable label fd1'"'

* =====================================================================
* Test 3: string dummies with newvaluelab()
* =====================================================================
clear
set obs 60
gen byte cat = 1 + mod(_n, 3)
gen str1 s1 = cond(cat == 1, "1", "0")
gen str1 s2 = cond(cat == 2, "1", "0")
gen str1 s3 = cond(cat == 3, "1", "0")
undummy s1 s2 s3, gen(cats) varnames newvaluelab(catlab)
assert r(k) == 3
assert "`:value label cats'" == "catlab"
* string dummies: empty strings sort first, so numbering reverses
assert cats == 4 - cat
assert `"`:label catlab 1'"' == "s3"
assert `"`:label catlab 2'"' == "s2"
assert `"`:label catlab 3'"' == "s1"

* =====================================================================
* Test 4: checkdummies -- clean set passes, overlapping set fails
* =====================================================================
clear
set obs 10
gen byte c1 = _n <= 5
gen byte c2 = _n > 5
undummy c1 c2, checkdummies
* nothing created, dummies retained
confirm variable c1 c2
cap confirm variable undummy
assert _rc == 111
* overlapping dummies (check-all-that-apply block) must be refused
gen byte o1 = _n <= 6
gen byte o2 = _n >= 5
cap noi undummy o1 o2, checkdummies
assert _rc == 459
confirm variable o1 o2
* the same overlap must also be refused without checkdummies
cap noi undummy o1 o2, gen(bad)
assert _rc == 459
cap confirm variable bad
assert _rc == 111

* =====================================================================
* Test 5: mixed numeric/string types -- error without ignoretype
* =====================================================================
clear
set obs 10
gen str1 m1 = cond(_n <= 5, "1", "0")
gen byte m2 = _n > 5
cap noi undummy m1 m2, gen(mm)
assert _rc == 109
confirm variable m1 m2
undummy m1 m2, gen(mm) ignoretype varnames keepdummies
assert r(k) == 2
assert !mi(mm)
* internally tostring-ed, so string ordering applies: m2 rows are category 1
assert mm == cond(_n <= 5, 2, 1)
assert `"`:label (mm) 2'"' == "m1"
assert `"`:label (mm) 1'"' == "m2"

* =====================================================================
* Test 6: generate() name already exists
* =====================================================================
clear
set obs 10
gen byte c1 = _n <= 5
gen byte c2 = _n > 5
gen byte already = 1
cap noi undummy c1 c2, gen(already)
assert _rc == 110
confirm variable c1 c2

* =====================================================================
* Test 7: empty sample and all-zero dummies
* =====================================================================
cap noi undummy c1 c2 if _n > 100, gen(zz)
assert _rc == 2000
gen byte z1 = 0
gen byte z2 = 0
cap noi undummy z1 z2, gen(zz2)
assert _rc == 2000
cap confirm variable zz2
assert _rc == 111

* =====================================================================
* Test 8: non-constant dummy values refused when labeling by name
* =====================================================================
clear
set obs 10
gen byte n1 = cond(_n <= 3, 1, cond(_n <= 5, 2, 0))
gen byte n2 = _n > 5
cap noi undummy n1 n2, gen(nn) varnames
assert _rc == 459

* =====================================================================
* Test 9: a dummy that is never switched on is skipped with a note
* =====================================================================
clear
set obs 10
gen byte a1 = _n <= 5
gen byte a2 = _n > 5
gen byte a3 = 0
undummy a1 a2 a3, gen(aa) varnames
assert r(k) == 2
assert `"`:label (aa) 1'"' == "a1"
assert `"`:label (aa) 2'"' == "a2"

* =====================================================================
* Test 10: if/in restriction leaves out-of-sample rows missing
* =====================================================================
sysuse auto, clear
tab foreign, gen(fd)
undummy fd1 fd2 in 1/40, gen(f40) varnames keepdummies
assert !mi(f40) in 1/40
assert mi(f40) in 41/74

di as txt "ALL TESTS PASSED"
