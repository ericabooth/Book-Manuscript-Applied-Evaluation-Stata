*==============================================================================*
* ch10_sparkta2.do  --  Chapter 10: an offline county map with sparkta2
* Applied Program Evaluation Using Stata  (Booth & Teas)
*------------------------------------------------------------------------------*
* Two sparkta2 maps of the 254 Texas counties, built from the County Health
* Rankings extract that ch04_chr.do saves (clean/chr2024_tx.dta). Each command
* writes ONE self-contained HTML file into `OUT'. With the -offline- option
* the D3 drawing code and the county boundaries are copied into the file, so
* the page opens with the network off.
*
* PREREQUISITES
*   1. Run ch04_chr.do first (it downloads CHR 2024 and saves the Texas file).
*   2. Install sparkta2 once (public repo, install verified 2026-11-10):
*        net install sparkta2, ///
*          from("https://raw.githubusercontent.com/ericabooth/sparkta2-stata-public/main/") replace force
*      The first map call downloads the package's JavaScript and boundary
*      files into your PLUS folder; later calls reuse them.
*==============================================================================*

version 17.0
clear all
set more off

*--- Paths --------------------------------------------------------------------*
local HERE "`c(pwd)'"
local OUT  "`HERE'/sparkta2_charts"
capture mkdir "`OUT'"

use "`HERE'/clean/chr2024_tx.dta", clear
assert _N == 254
destring fips, replace            // sparkta2 pads a numeric id to 5 digits
isid fips                         // one row per county; duplicates overwrite

label variable uninsured "Uninsured (%)"
label variable childpov  "Children in poverty (%)"
label variable hhincome  "Median household income ($)"
label variable yrslost   "Years of life lost per 100,000"

*==============================================================================*
* 1. CHOROPLETH -- uninsured rate by county
*------------------------------------------------------------------------------*
* id() is the county FIPS that joins each row to its boundary; name() is the
* hover label. classes(jenks) picks natural breaks and the legend prints the
* cut values. FIGURE: ch10_sp2_county.png
*==============================================================================*
sparkta2 uninsured, id(fips) name(cname) type(choropleth)       ///
    classes(jenks) scheme(blues)                                ///
    tooltipvars(childpov hhincome)                              ///
    search download datatable                                   ///
    title("Uninsured rate by Texas county, 2024")               ///
    note("Source: County Health Rankings & Roadmaps 2024.")     ///
    width(960) height(620) offline noopen                       ///
    export("`OUT'/01_county_uninsured.html")

*==============================================================================*
* 2. BIVARIATE -- child poverty against the uninsured rate
*------------------------------------------------------------------------------*
* Two variables and type(bivariate) give a 3 x 3 legend: a county is dark
* when it is high on both measures.
*==============================================================================*
sparkta2 childpov uninsured, id(fips) name(cname) type(bivariate) ///
    search download                                             ///
    title("Child poverty and uninsured rate, Texas counties, 2024") ///
    note("Source: County Health Rankings & Roadmaps 2024.")     ///
    width(960) height(620) offline noopen                       ///
    export("`OUT'/02_county_bivariate.html")

display "SPARKTA2_OK"
