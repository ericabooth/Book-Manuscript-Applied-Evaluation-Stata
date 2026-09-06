*==============================================================================*
* ch03_educationdata.do  --  Chapter 3: education panels with -educationdata-
* Pulls district-level CCD enrollment for Texas (2015-2022) from the Urban
* Institute Education Data Portal, collapses to a state-year enrollment
* series, and charts it with the COVID-19 school year marked.
* No API key required. One-time install: ssc install educationdata
*==============================================================================*
* Globals normally live in code/00_control.do; they are defined here so this
* file runs standalone. Point them at your own project folders.
global raw     "`c(pwd)'/raw"
global clean   "`c(pwd)'/clean"
global figures "`c(pwd)'/figures"
capture mkdir "$raw"
capture mkdir "$clean"
capture mkdir "$figures"

*--- One-time installs (no key needed; libjson is a dependency) ---------------*
capture which educationdata
if _rc ssc install educationdata
capture which libjson
if _rc ssc install libjson

*--- Download district-level CCD enrollment for Texas, 2015-2022 --------------*
* grade=99 is the district total across grades; fips=48 is Texas. The sub()
* option filters on the server, so only the rows we need travel the wire.
educationdata using "district ccd enrollment", ///
    sub(year=2015:2022 grade=99 fips=48) clear

*--- Data checks before we trust the panel ------------------------------------*
assert grade == 99                      // district totals only
count if missing(enrollment) | enrollment < 0
di "FLAGGED_ROWS=" r(N)                 // suppressed or missing counts
drop if missing(enrollment) | enrollment < 0
tab year

*--- Collapse the district panel to one state-year series ---------------------*
collapse (sum) enrollment (count) n_dist=enrollment, by(year) fast
gen enroll_m = enrollment/1e6
format enrollment %12.0fc
list year enrollment n_dist, clean noobs

*--- Save the analysis-ready series -------------------------------------------*
save "$clean/ccd_tx_state_enrollment.dta", replace

*--- Summary figure: state enrollment with the COVID year marked -----------*
twoway connected enroll_m year, ///
    lcolor(navy) mcolor(navy) msize(medsmall) ///
    xline(2020, lpattern(dash) lcolor(gs9)) ///
    text(5.54 2019.93 "COVID-19", place(w) size(small) color(gs6)) ///
    xlabel(2015(1)2022, labsize(small)) ///
    ylabel(5.3(0.05)5.55, angle(0) labsize(small) format(%4.2f)) ///
    xtitle("School year (fall)", size(small)) ///
    ytitle("Students enrolled (millions)", size(small)) ///
    title("Texas public school enrollment, 2015-2022", size(medium)) ///
    note("Source: Urban Institute Education Data Portal (CCD). Year is the fall of the school year.", size(vsmall)) ///
    graphregion(margin(l=2 r=6)) ysize(4) xsize(5.4)
graph export "$figures/ch03_ccd_enrollment.png", replace width(2400)
di "FIGURE_SAVED"
di "DONE"
