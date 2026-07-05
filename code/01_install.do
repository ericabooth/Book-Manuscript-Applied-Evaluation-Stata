*==============================================================================*
* 01_install.do  --  One-time package setup
* Applied Program Evaluation Using Stata  (Booth & Teas)
*
* Installs the user-written packages the book relies on. Run once per machine.
* Everything here is free; -capture- lets the file rerun without error if a
* package is already installed.
*==============================================================================*

*--- Community packages from SSC ----------------------------------------------*
foreach pkg in estout coefplot gtools ftools reghdfe {
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

*--- The book's own packages (from the authors' GitHub) -----------------------*
* webapi is required by ch03_webapi.do (and the guarded ch12 portal build);
* the others are optional. Each installs with one net command (verified 2026-07).
capture which webapi
if _rc net install webapi, from("https://raw.githubusercontent.com/ericabooth/webapi-stata-public/main/") replace
* Uncomment the ones you want:
* net install googlechart, from("https://raw.githubusercontent.com/ericabooth/googlechart-stata-public/main/") replace
* net install googlesheets, from("https://raw.githubusercontent.com/ericabooth/googlesheets-stata-public/main/") replace
* net install statashiny, from("https://raw.githubusercontent.com/ericabooth/StataShiny-public/main/") replace
* webdoc2 needs Ben Jann's webdoc first, and a separate net get for its
* Bootstrap header.html (net get drops ancillary files in the current dir):
* ssc install webdoc, replace
* net install webdoc2, from("https://raw.githubusercontent.com/ericabooth/webdoc2-stata-public/main/") replace
* net get webdoc2, from("https://raw.githubusercontent.com/ericabooth/webdoc2-stata-public/main/")
* (sparkta2 is not yet published; its examples in the book are display-only.)

di as result "Package setup complete."
