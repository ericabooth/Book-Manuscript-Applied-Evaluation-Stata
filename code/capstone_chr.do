*! capstone_chr.do  -- Applied Program Evaluation Using Stata, Appendix E
*! One public dataset, ingest to deliverable, no API key required.
*! County Health Rankings 2024 analytic file. Re-runs with `do capstone_chr.do`.
version 18
clear all
set more off

*--- 0. Control block (Chapter 2): paths and one switch you can flip ----------
local site  "https://www.countyhealthrankings.org"
local path  "sites/default/files/media/document"
local csv   "chr_2024.csv"
local redownload 1          // set to 0 to reuse a cached copy

*--- 1. Ingest (Chapter 4: harvest when the "API" is just a file) -------------
if `redownload' | !fileexists("`csv'") {
    capture copy "`site'/`path'/analytic_data2024.csv" "`csv'", replace
    if _rc {
        display as error "Download failed (rc=`_rc'). Check the URL or your network."
        exit `_rc'
    }
}
* FIPS codes are identifiers, not magnitudes: read them as strings so leading
* zeros survive (Chapter 6). case(lower) makes the munged names predictable.
import delimited "`csv'", clear varnames(1) case(lower) stringcols(1 2 3)

*--- 2. Clean (Chapters 4-6): drop the label row, keep real counties ----------
drop in 1                                   // row 1 is a second header of labels
keep if countyfipscode != "000"             // "000" rows are state roll-ups
rename (prematuredeathrawvalue childreninpovertyrawvalue ///
        uninsuredrawvalue stateabbreviation) ///
       (ypll childpov unins state)
destring ypll childpov unins, replace force
replace childpov = childpov*100             // proportion -> percentage points
replace unins    = unins*100
drop if missing(ypll, childpov, unins)

*--- 3. Tripwires (Chapter 7): fail loudly if the file drifted ----------------
* Predict, then check: the CHR file covers ~3,000-3,150 usable counties.
count
assert r(N) > 2900 & r(N) < 3200
assert ypll    > 0    & ypll    < 50000     // YPLL per 100,000, sane range
assert childpov >= 0  & childpov <= 100
local N = r(N)
display as result "Counties analyzed: `N'"

*--- 4. Analyze (Chapter 8: the comparison, stated in policy units) -----------
* Question: do higher-poverty counties lose more years of life, and does
* insurance coverage explain part of the gap?
regress ypll childpov unins
local per10_naive = 10*_b[childpov]          // effect per 10 points of poverty
display as result "Naive: +" %4.0f `per10_naive' ///
    " YPLL per 10-pt rise in child poverty;  R2=" %4.3f e(r2)

* Add state fixed effects: compare counties within the same state, so a
* state's Medicaid rules and reporting quirks cannot drive the association.
areg ypll childpov unins, absorb(state)
local per10_fe = 10*_b[childpov]
display as result "State FE: +" %4.0f `per10_fe' ///
    " YPLL per 10-pt rise;  N=" e(N)

*--- 5. Visualize (Chapter 9: one honest picture) ----------------------------
preserve
    gen povbin = round(childpov/5)*5
    collapse (mean) ypll (count) n=ypll, by(povbin)
    drop if n < 10                           // hide bins too thin to trust
    twoway connected ypll povbin, sort ///
        lcolor(navy) mcolor(navy) lwidth(medthick) ///
        ytitle("Premature death" "(YPLL per 100,000)", size(small)) ///
        xtitle("County child-poverty rate (%), 5-point bins", size(small)) ///
        title("Higher-poverty counties lose more years of life", size(medsmall)) ///
        note("County Health Rankings 2024. Bins with <10 counties dropped.", size(vsmall)) ///
        graphregion(color(white)) ysize(3.4) xsize(5.2)
    graph export "cap_ypll_poverty.png", replace width(2400)
restore

*--- 6. Deliver (Chapters 11-12): a checkpoint others can reuse ---------------
* Ship the small cleaned extract, not the raw file, with a stamped label.
label data "CHR 2024 county extract (capstone). See capstone_chr.do."
compress
save "chr_2024_clean.dta", replace
display as result "Deliverable saved: chr_2024_clean.dta, cap_ypll_poverty.png"
