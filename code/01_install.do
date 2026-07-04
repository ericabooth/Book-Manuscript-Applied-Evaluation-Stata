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
* Uncomment the ones you want; each installs with a single net command.
* net install googlechart, from("https://raw.githubusercontent.com/ericabooth/googlechart-stata-public/main/") replace
* net install googlesheets, from("https://raw.githubusercontent.com/ericabooth/googlesheets-stata-public/main/") replace

di as result "Package setup complete."
