*==============================================================================*
* ch10_smallmult.do  --  Chapter 10: building interactive charts & infographics
* Builds a "spark wall": six tiny quarterly-wage sparklines for six Texas
* counties, 2019q1-2024q4, from the BLS QCEW open-data CSV files. One panel
* per county, minimal axes, so a reader scans the whole portfolio at a glance.
* This is a direct callback to Chapter 3: every file downloads with
* -import delimited- from a public URL, and no API key is required.
*==============================================================================*
* Globals normally live in code/00_control.do; they are defined here so this
* file runs standalone. Point them at your own project folders.
global raw     "`c(pwd)'/raw"
global clean   "`c(pwd)'/clean"
global figures "`c(pwd)'/figures"
capture mkdir "$raw"
capture mkdir "$clean"
capture mkdir "$figures"

*--- Six Texas metro counties: FIPS codes -------------------------------------*
* Travis(Austin) Harris(Houston) Dallas Bexar(SanAntonio) Tarrant(FtWorth) ElPaso
local counties 48453 48201 48113 48029 48439 48141

*--- Loop county x year x quarter over the no-key QCEW area CSVs ---------------*
* QCEW posts one CSV per county-year-quarter at a stable URL. -capture- swallows
* a missing quarter (the newest quarters lag) so one 404 skips one panel, not the
* whole run. Keep the total private-sector row: own_code 5, industry_code 10.
tempfile master
local first 1
foreach fips of local counties {
    forvalues yr = 2019/2024 {
        forvalues q = 1/4 {
            capture import delimited ///
                "https://data.bls.gov/cew/data/api/`yr'/`q'/area/`fips'.csv", ///
                clear varnames(1) stringcols(1 3)
            if _rc continue
            keep if own_code == 5 & industry_code == "10"
            keep area_fips year qtr avg_wkly_wage
            if `first' {
                save `master', replace
                local first 0
            }
            else {
                append using `master'
                save `master', replace
            }
        }
    }
}
use `master', clear

*--- Build a continuous quarter index for the x-axis --------------------------*
gen tq = yq(year, qtr)
format tq %tq
destring avg_wkly_wage, replace force

*--- Label counties for the panel headers -------------------------------------*
gen county = ""
replace county = "Travis (Austin)"      if area_fips=="48453"
replace county = "Harris (Houston)"     if area_fips=="48201"
replace county = "Dallas"               if area_fips=="48113"
replace county = "Bexar (San Antonio)"  if area_fips=="48029"
replace county = "Tarrant (Ft. Worth)"  if area_fips=="48439"
replace county = "El Paso"              if area_fips=="48141"
drop if county == ""
sort county tq

*--- Save the analysis-ready panel & report how many rows landed --------------*
save "$clean/qcew_tx_spark_panel.dta", replace
count
di "PANEL_ROWS=" r(N)

*--- The spark wall: one tiny line per county, minimal axes -------------------*
* by() makes the small multiples; we strip the axes to sparkline density so the
* eye reads the shape, not the gridlines. Each panel keeps its own free y-scale.
twoway line avg_wkly_wage tq, lcolor(navy) lwidth(medthin) ///
    by(county, ///
        title("Private-sector weekly wage, six Texas counties, 2019q1-2024q4", size(medium)) ///
        note("Source: BLS QCEW quarterly area CSVs (public, no key). Each panel shares no common y-scale.", size(vsmall)) ///
        legend(off) graphregion(margin(l=2 r=6)) rows(2)) ///
    ytitle("") xtitle("") ///
    ylabel(, nogrid labsize(vsmall) angle(0)) ///
    xlabel(, nogrid labsize(vsmall)) ///
    subtitle(, size(small))
graph export "$figures/ch10_sparkwall.png", replace width(2400)
di "FIGURE_SAVED"
di "DONE"
