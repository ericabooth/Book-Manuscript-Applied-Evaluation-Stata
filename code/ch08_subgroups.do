*==============================================================================*
* ch08_subgroups.do
* Companion to Chapter 8, "Subgroups without fishing" -- the estimation half.
* One simulated program, six subgroups of very different sizes. True effects
* genuinely differ (2.9 to 7.4 points), and sampling noise differs enormously,
* because the smallest subgroup has a tenth of the largest one's people.
* The shrinkage step reuses Chapter 7's logic: each subgroup keeps its own
* estimate in proportion to its reliability and borrows the rest from the pool.
*==============================================================================*
version 16.0
clear all
set seed 20260807
set obs 3000

gen u = runiform()
gen byte grp = 1 + (u>.40) + (u>.65) + (u>.80) + (u>.90) + (u>.96)

gen byte treat = runiform() < .5
* true effect rises with grp: 2.0 + 0.9*grp  (grp1 2.9 ... grp6 7.4)
gen true_fx = 2.0 + 0.9*grp
gen y = 50 + true_fx*treat + 2*(grp==1) - 1*(grp==4) + rnormal(0, 10)

tempname h
postfile `h' grp n b se using subfx, replace
forvalues g = 1/6 {
    quietly regress y treat if grp==`g'
    quietly count if grp==`g'
    post `h' (`g') (r(N)) (_b[treat]) (_se[treat])
}
postclose `h'
use subfx, clear

* precision-weighted pooled effect, then empirical-Bayes shrinkage
gen double w  = 1/se^2
gen double wb = w*b
quietly summarize wb
local sumwb = r(sum)
quietly summarize w
local sumw = r(sum)
local B = `sumwb'/`sumw'
gen double q = w*(b - `B')^2
quietly summarize q
local Q = r(sum)
gen double w2 = w^2
quietly summarize w2
local tau2 = max(0, (`Q' - 5) / (`sumw' - r(sum)/`sumw'))
gen double rel   = `tau2'/(`tau2' + se^2)
gen double b_shr = rel*b + (1-rel)*`B'
format b se b_shr %6.2f
format rel %5.2f

display "pooled effect = " %5.2f `B' "   between-group variance tau2 = " %5.2f `tau2'
list grp n b se rel b_shr, noobs abbrev(10)

* every shrunken estimate sits between its raw estimate and the pool
quietly gen byte ok = (b_shr - b)*(b_shr - `B') <= 1e-9
assert ok == 1
* reliability rises with subgroup size
sort n
quietly gen byte mono = rel >= rel[_n-1] - 1e-9 if _n > 1
assert mono == 1 if _n > 1
di "DONE"
