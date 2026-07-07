*==============================================================================*
* ch08_oaxaca.do  --  Chapter 8: decomposing a group gap (Blinder-Oaxaca)
* Applied Program Evaluation Using Stata  (Booth & Teas)
*
* Question: an observed wage gap between two groups -- how much is composition
* (the groups differ in measured characteristics) versus structure (the same
* characteristics earn different returns)? The Blinder-Oaxaca decomposition
* splits the gap into an "explained" (endowments) and an "unexplained" part.
*
* Data: nlsw88 (Stata built-in, no key). White vs. Black women, log wage.
* SSC packages: oaxaca (Jann 2008) to decompose; coefplot to visualize;
*   estout/esttab to table. Install once:
*     ssc install oaxaca, replace
*     ssc install coefplot, replace
*     ssc install estout, replace
*==============================================================================*
version 18
clear all
set more off

*--- 1. Build two clean groups and the outcome -------------------------------*
sysuse nlsw88, clear
keep if inlist(race, 1, 2)          // 1 = white, 2 = black; drop "other"
gen byte white = race == 1
label define wl 0 "Black" 1 "White"
label values white wl
gen lnwage = ln(wage)               // decompose the log wage, not the level
drop if missing(wage, grade, ttl_exp, tenure, hours, union)

*--- 2. The raw gap before any decomposition ---------------------------------*
tabstat lnwage, by(white) stat(mean n)

*--- 3. Twofold Blinder-Oaxaca, pooled (Neumark) reference model -------------*
* The pooled reference regression is the neutral non-discriminatory benchmark
* Jann (2008) recommends over using either group's coefficients alone.
oaxaca lnwage grade ttl_exp tenure hours union, by(white) pooled detail

*--- 4. Tripwires: freeze the headline numbers the book quotes ---------------*
matrix b = e(b)
scalar gap   = b[1,"overall:difference"]     // Black - White (negative)
scalar expl  = b[1,"overall:explained"]
scalar unex  = b[1,"overall:unexplained"]
assert e(N) == 1841
assert reldif(gap,  -.1578) < 0.01
assert reldif(expl, -.0346) < 0.02
assert reldif(unex, -.1231) < 0.02
di as result "Gap = " %5.3f gap "  explained = " %5.3f expl ///
    " (" %3.0f 100*expl/gap "%)  unexplained = " %5.3f unex

*--- 5. Visualize: which characteristics drive the EXPLAINED gap -------------*
coefplot, keep(explained:grade explained:ttl_exp explained:tenure ///
        explained:hours explained:union) ///
    xline(0, lcolor(gs8) lpattern(dash)) ///
    msymbol(D) mcolor(navy) ciopts(lcolor(navy)) ///
    title("What explains the white-Black wage gap?", size(medsmall)) ///
    subtitle("Endowment (explained) contribution of each characteristic", size(small)) ///
    xtitle("Log-wage points (negative = widens the gap)", size(small)) ///
    note("nlsw88; twofold Blinder-Oaxaca, pooled reference (oaxaca, Jann 2008).", size(vsmall)) ///
    graphregion(color(white)) ysize(3.2) xsize(5.4)
graph export "ch08_oaxaca.png", replace width(2400)

di as result "Done: ch08_oaxaca.png written."

* CAVEAT worth carrying: the "unexplained" part is NOT a clean estimate of
* discrimination. It absorbs every wage-relevant characteristic you did not
* measure (school quality, field of study, unmeasured experience). Read it as
* "the gap left after the controls you have," not as a discrimination number.
