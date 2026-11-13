*==============================================================================*
* 01_install.do  --  One-time package setup
* Applied Program Evaluation Using Stata  (Booth & Teas)
*
* Installs the user-written packages the book relies on. Run once per machine.
* Everything here is free; -capture- lets the file rerun without error if a
* package is already installed.
*==============================================================================*

*--- Community packages from SSC ----------------------------------------------*
* usepackage (Booth, SSC) is itself a package-loader: -usepackage- installs
* and loads a named list of packages in one call, which teams use to pin a
* project's toolchain. Installed here the ordinary way; see help usepackage.
foreach pkg in estout coefplot gtools ftools reghdfe usepackage oaxaca {
    capture which `pkg'
    if _rc ssc install `pkg', replace
}

*--- Public-data access packages ----------------------------------------------*
* getcensus     : American Community Survey pulls (needs a free Census API key)
* educationdata : Urban Institute Education Data Portal (no key)
capture which getcensus
if _rc ssc install getcensus, replace
capture which educationdata
if _rc ssc install educationdata, replace
capture which libjson
if _rc ssc install libjson, replace            // educationdata dependency

*--- The book's own packages --------------------------------------------------*
* Eleven are published on SSC and install like any community package:
* webapi, googlesheets, googlechart, statashiny, dashboardbuilder,
* projectbuilder, combineall, convertanything, datadictionary, reshapehelper,
* and statplot (with N. J. Cox). SSC versions checked 2026-11-13: webapi 0.1.4,
* googlesheets 0.1.7, googlechart 0.1.7.
* webapi is required by ch03_webapi.do (and the guarded ch12 portal build);
* googlesheets and googlechart are optional.
capture which webapi
if _rc ssc install webapi, replace
* Uncomment the ones you want:
* ssc install googlechart, replace
* ssc install googlesheets, replace       // also needs the OAuth setup (Appendix A)
* ssc install statashiny, replace
* ssc install dashboardbuilder, replace  // needs Python 3 (stdlib only); required by ch12_dashboardbuilder.do
* ssc install convertanything, replace
* The remaining suite packages install from the authors' GitHub:
* net install datadeposit, from("https://raw.githubusercontent.com/ericabooth/datadeposit/main/") replace force  // R optional (.rds copy)
* ssc install importr, replace  // needs R (haven) or python pyreadstat to run
* webdoc2 needs Ben Jann's webdoc first, and a separate net get for its
* Bootstrap header.html (net get drops ancillary files in the current dir):
* ssc install webdoc, replace
* net install webdoc2, from("https://raw.githubusercontent.com/ericabooth/webdoc2-stata-public/main/") replace force
* net get webdoc2, from("https://raw.githubusercontent.com/ericabooth/webdoc2-stata-public/main/")
* sparkta2 (Stata 17+); the first map call downloads its JavaScript and boundary
* files into PLUS; required by ch10_sparkta2.do (install verified 2026-11-10):
* net install sparkta2, from("https://raw.githubusercontent.com/ericabooth/sparkta2-stata-public/main/") replace force

*--- The packages built FOR this book -----------------------------------------*
* All of these are published. Four are on SSC and install like any community
* package; the rest install from the authors' GitHub with one net line each
* (verified 2026-07-31).
foreach pkg in projectbuilder combineall datadictionary reshapehelper {
    capture which `pkg'
    if _rc ssc install `pkg', replace
}

local gh "https://raw.githubusercontent.com/ericabooth"
foreach pkg in cxchangelog rateshrink conformalpred hlmr2 twinmatch roisim ///
    suppress riskscan undummy synthgen {
    capture which `pkg'
    if _rc net install `pkg', from("`gh'/`pkg'-stata-public/main/") replace force
}

di as result "Package setup complete."
