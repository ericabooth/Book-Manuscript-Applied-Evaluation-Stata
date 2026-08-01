*===============================================================
* 200_data_management.do -- VendorFeed
* Single job: turn the raw drop in $raw into ONE analytic file
* in $cleaned, in two passes:
*   Pass 1  convertanything : every csv/xlsx/dta in $raw -> .dta
*                             in $converted (names cleaned).
*   Pass 2  combineall      : append those .dta into the analytic file.
* projectbuilder runs both passes for you at scaffold/rebuild time
* when the packages are installed; this file is the reproducible
* record of what it ran (and a teaching artifact if they are not).
*===============================================================
* Globals come from 000_control.do -- run that first.

* --- Pass 1: convert every raw file to .dta -----------------------
capture which convertanything
if _rc {
    di as txt "convertanything not installed. Install it with:"
    di as txt `"    net install convertanything, from("https://raw.githubusercontent.com/ericabooth/convertanything-stata-public/main/") replace"'
}
else {
    convertanything using "$raw", recursive ///
        saving("$converted") replace clear cleannames compress
}

* --- Pass 2: append the converted files into the analytic file ----
capture which combineall
if _rc {
    di as txt "combineall not installed. Install it with:"
    di as txt `"    net install combineall, from("https://raw.githubusercontent.com/ericabooth/combineall-stata-public/main/") replace"'
}
else {
    capture noisily combineall using "$cleaned/VendorFeed_analytic", ///
        cmethod(append) directory("$converted") filetype(dta) replace
    if _rc di as txt "combineall found nothing to append; run Pass 1 first."
}

* From here, load the analytic file and reshape/merge as the project needs:
* use "$cleaned/VendorFeed_analytic.dta", clear
