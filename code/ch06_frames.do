*==============================================================================*
* ch06_frames.do
* Companion to Chapter 6, Section "Frames: a second dataset open at the same
* time". Reproduces every number printed in that subsection.
*
* The question: how does each woman's wage compare with the average in her own
* industry? Two levels are involved (women, industries), which is the case
* frames handle without duplicating rows.
*
* Requires: Stata 16 or later (frames were introduced in Stata 16).
*==============================================================================*
version 16.0
clear all
set more off

*--- Level 1: one row per woman ----------------------------------------------*
sysuse nlsw88, clear
keep idcode industry wage union
drop if missing(industry)          // 14 dropped
count                              // 2,232 women
assert r(N) == 2232

*--- Level 2: one row per industry, built in its own frame -------------------*
frame put industry wage, into(indlevel)
frame indlevel {
    collapse (mean) ind_wage = wage (count) n_women = wage, by(industry)
    format ind_wage %6.2f
    list in 1/4, noobs abbrev(12)  // printed in the book
    count                          // 12 industries
    assert r(N) == 12
}

*--- Link the levels, then pull across only what is needed -------------------*
* frlink does not combine the data: it records which row of indlevel each
* woman's row corresponds to. frget then copies named variables across.
frlink m:1 industry, frame(indlevel)
frget ind_wage n_women, from(indlevel)
assert !missing(ind_wage)          // "all observations ... matched"

*--- The comparison the team actually asked for ------------------------------*
gen above = wage > ind_wage if !missing(wage, ind_wage)
label define ab 0 "at or below" 1 "above"
label values above ab
tabulate above                     // 1,442 at or below / 790 above

count if above == 1
assert r(N) == 790
count if above == 0
assert r(N) == 1442

di "DONE"
