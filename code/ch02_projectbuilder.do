*==============================================================================*
* ch02_projectbuilder.do  --  Chapter 2: scaffolding a project in one command
* Applied Program Evaluation Using Stata  (Booth & Teas)
*
* projectbuilder builds the folder tree, the numbered do-file pipeline, and a
* documentation site for a data project. It supports the two ways a project
* actually starts:
*
*   METHOD A  the data already exists (a folder of files, or a source URL)
*   METHOD B  scaffold now, data later; rerun with -rebuild- on every refresh
*
* Everything below runs offline on synthetic files made from sysuse auto.
* Nothing here needs a key or a network.
*
* Install once:
*   local gh "https://raw.githubusercontent.com/ericabooth"
*   net install projectbuilder, from("`gh'/projectbuilder-stata-public/main/") replace
* Optional, and used automatically when present (each step degrades gracefully):
*   net install convertanything, from("`gh'/convertanything-stata-public/main/") replace
*   net install combineall,      from("`gh'/combineall-stata-public/main/") replace
*   ssc install descsave                       // Excel codebook in 300_labels.do
*==============================================================================*
version 18
clear all
set more off
set seed 20260707

*--- A sandbox to build in; everything below stays inside it -----------------*
local demo "`c(pwd)'/projectbuilder_demo"
capture mkdir "`demo'"
cd "`demo'"

*==============================================================================*
* METHOD A -- the data already exists on disk
*------------------------------------------------------------------------------*
* A partner drops a folder of yearly CSVs on you. Point projectbuilder at it:
* it copies them into 01_raw/, converts them to .dta in 01_raw/_converted/
* (convertanything), appends them into 02_cleaned/ (combineall), and writes the
* documentation site. One command, and the project is real.
*==============================================================================*
capture mkdir "`demo'/incoming"
sysuse auto, clear
keep make price mpg weight foreign
export delimited using "`demo'/incoming/cars_2019.csv", replace
replace price = round(price*1.04)
export delimited using "`demo'/incoming/cars_2020.csv", replace

projectbuilder CarPrices,                                        ///
    data("`demo'/incoming")                                      ///
    description("Dealer price extracts, one file per model year") ///
    topic("prices, vehicles") publicfacing(unsure)               ///
    timeline("annual, each October")                             ///
    outcomes(price) over(foreign)                                ///
    descsave

display as result "Method A: raw files = " r(nraw) ///
    "; converted = " r(nconverted) "; project at " r(path)

*==============================================================================*
* METHOD B -- scaffold now, data later, rebuild on every refresh
*------------------------------------------------------------------------------*
* More often you open the project before the agency sends anything. Scaffold
* the empty shell, put the request in motion, and when the files land you drop
* them into 01_raw/ and rerun with -rebuild-. That single command re-converts,
* re-appends, and regenerates the docs. Every quarterly refresh is one rebuild.
*==============================================================================*
projectbuilder VendorFeed,                                       ///
    description("Monthly vendor extract; agency emails the file") ///
    url("https://example.gov/vendor/monthly.csv")                ///
    topic("procurement") publicfacing(no) timeline("monthly")

display as result "Method B: scaffolded empty, raw files = " r(nraw)

* ... weeks pass; the first extract arrives. Drop it into 01_raw/ ...
sysuse auto, clear
keep make price mpg
export delimited using "`demo'/VendorFeed/01_raw/vendor_2026m01.csv", replace

* ... and rebuild. Nothing you edited in _code/ is touched.
projectbuilder VendorFeed, rebuild
display as result "Method B after 1st drop: raw = " r(nraw) ///
    "; rebuilt = " r(rebuilt)

* Next month's file is just another drop and another rebuild.
sysuse auto, clear
keep make price mpg
replace price = round(price*1.02)
export delimited using "`demo'/VendorFeed/01_raw/vendor_2026m02.csv", replace
projectbuilder VendorFeed, rebuild
display as result "Method B after 2nd drop: raw = " r(nraw)

*--- What you get either way --------------------------------------------------*
* 01_raw/            the files exactly as they arrived, never edited
* 01_raw/_converted/ one .dta per raw file (convertanything)
* 02_cleaned/        the appended analytic file (combineall)
* _code/             000_control.do + the numbered 100..600 pipeline
* _documentation/    Readme.md and website/index.html, stamped and rebuilt
*
* The generated 300_labels.do is where documentation earns its keep: it calls
* descsave for an Excel codebook and srctag/srcfind to tag each variable with
* the raw file it came from, so a year from now you can answer "where did this
* number come from?" without opening a single spreadsheet.

display as result "Done. Open " ///
    "`demo'/VendorFeed/_documentation/website/index.html"
