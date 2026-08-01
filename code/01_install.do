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
* Three are published on SSC and install like any community package.
* webapi is required by ch03_webapi.do (and the guarded ch12 portal build);
* googlesheets and googlechart are optional (verified on SSC 2026-07-31).
capture which webapi
if _rc ssc install webapi, replace
* Uncomment the ones you want:
* ssc install googlechart, replace
* ssc install googlesheets, replace       // also needs the OAuth setup (Appendix A)
* The remaining suite packages install from the authors' GitHub:
* net install statashiny, from("https://raw.githubusercontent.com/ericabooth/StataShiny-public/main/") replace force
* net install dashboardbuilder, from("https://raw.githubusercontent.com/ericabooth/dashboardbuilder-stata-public/main/") replace force  // needs Python 3 (stdlib only); install verified 2026-07-14; required by ch12_dashboardbuilder.do
* net install convertanything, from("https://raw.githubusercontent.com/ericabooth/convertanything-stata-public/main/") replace force
* net install importr, from("https://raw.githubusercontent.com/ericabooth/importR-stata/main/") replace force  // needs R (haven) or python pyreadstat to run
* webdoc2 needs Ben Jann's webdoc first, and a separate net get for its
* Bootstrap header.html (net get drops ancillary files in the current dir):
* ssc install webdoc, replace
* net install webdoc2, from("https://raw.githubusercontent.com/ericabooth/webdoc2-stata-public/main/") replace force
* net get webdoc2, from("https://raw.githubusercontent.com/ericabooth/webdoc2-stata-public/main/")
* (sparkta2 is not yet published; its examples in the book are display-only.)

*--- The thirteen packages built FOR this book ---------------------------------*
* Each lives in a <name>-stata-public folder that publishes to the authors'
* GitHub with the book. Until those repos are live, install from the local
* folders that ship beside this project (edit BOOKPKG to your copy's path);
* after publication the same names install from raw.githubusercontent.com
* with the usual one-line net install.
* NOTE: -net- mistakes a colon in a folder path for a URL scheme, so if your
* copy sits under a path containing ":", copy the package folders somewhere
* colon-free first (or wait for the GitHub repos).
local BOOKPKG ""   // e.g. "/path/to/book-repo" ; leave empty to skip
if "`BOOKPKG'" != "" {
    foreach pkg in projectbuilder combineall cxchangelog datadictionary ///
        reshapehelper rateshrink conformalpred hlmr2 twinmatch roisim ///
        suppress riskscan undummy {
        capture which `pkg'
        if _rc net install `pkg', from("`BOOKPKG'/`pkg'-stata-public/") replace force
    }
}

di as result "Package setup complete."
