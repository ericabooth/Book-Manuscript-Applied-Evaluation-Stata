*==============================================================================*
* 20_ch03_apis.do  --  Chapter 3: downloading public data through APIs
* Builds a Texas metro county wage snapshot from the BLS QCEW open data.
* No API key. Everything here downloads with -import delimited- from a URL.
*==============================================================================*
do "`c(pwd)'/code/00_control.do"     // load globals (root, raw, clean, figures)

*--- Download total private employment & wages for five Texas metro counties --*
* QCEW area files are one CSV per county-year. Loop the counties, keep the
* "total, all industries" private-sector row (own_code 5, industry_code 10).
local counties 48453 48201 48113 48029 48439    // Travis Harris Dallas Bexar Tarrant
tempfile master
local first 1
foreach fips of local counties {
    import delimited ///
        "https://data.bls.gov/cew/data/api/2023/1/area/`fips'.csv", ///
        clear varnames(1) stringcols(1 3)
    keep if own_code == 5 & industry_code == "10"
    keep area_fips year qtr qtrly_estabs month3_emplvl avg_wkly_wage
    if `first' {
        save `master', replace
        local first 0
    }
    else {
        append using `master'
        save `master', replace
    }
}
use `master', clear

*--- Label the counties for a client-readable chart ---------------------------*
gen county = ""
replace county = "Travis (Austin)"     if area_fips=="48453"
replace county = "Harris (Houston)"    if area_fips=="48201"
replace county = "Dallas"              if area_fips=="48113"
replace county = "Bexar (San Antonio)" if area_fips=="48029"
replace county = "Tarrant (Ft. Worth)" if area_fips=="48439"

format avg_wkly_wage %9.0fc
list county month3_emplvl avg_wkly_wage, clean noobs

*--- Save the analysis-ready extract ------------------------------------------*
save "$clean/qcew_tx_metro_2023q1.dta", replace

*--- Summary figure: average weekly wage by county -------------------------*
graph hbar (asis) avg_wkly_wage, ///
    over(county, sort(1) descending label(labsize(small))) ///
    bar(1, color(navy)) blabel(bar, format(%9.0fc) size(small)) ///
    ytitle("Average weekly wage, private sector ($)", size(small)) ///
    title("Private-sector weekly wage, Texas metros, 2023 Q1", size(medium)) ///
    note("Source: BLS Quarterly Census of Employment and Wages (public, no key).", size(vsmall)) ///
    graphregion(margin(l=2 r=6)) ysize(3.6) xsize(7.2)
graph export "$figures/ch03_qcew_wages.png", replace width(2400)
di "FIGURE_SAVED"
