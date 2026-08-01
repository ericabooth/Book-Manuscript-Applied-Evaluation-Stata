*===============================================================
* 300_labels.do -- CarPrices
* Single job: variable/value labels and provenance on the analytic
* file, plus (optionally) a codebook export for the documentation.
*===============================================================
* Globals come from 000_control.do -- run that first.

use "$cleaned/CarPrices_analytic.dta", clear

* label variable somevar "Human-readable label"
* label define yesno 0 "No" 1 "Yes"
* label values flagvar yesno

* --- Source lineage: tag each variable with the raw file it came
* from, then make that lineage searchable (author's -srctag-/-srcfind-).
capture which srctag
if _rc {
    di as txt "srctag/srcfind not installed (author's GitHub); skipping lineage tags."
}
else {
    * srctag, source("$raw") // record which raw file/vintage each var came from
    * srcfind somevar         // later: search a variable's source lineage
}

* --- Codebook export via -descsave- (SSC: ssc install descsave) ----
capture which descsave
if _rc {
    di as txt "descsave not installed. Install it with:  ssc install descsave"
}
else {
    * descsave writes a Stata dataset, one observation per variable.
    * Its -using- names the file to DESCRIBE; the output file goes in
    * saving(), which is also where -replace- belongs.  Export the
    * result to .xlsx afterwards with Stata's own -export excel-, so
    * the codebook is readable by someone without Stata.
    preserve
    descsave, list(name type format varlab vallab) ///
        saving("$docs/CarPrices_codebook.dta", replace)
    use "$docs/CarPrices_codebook.dta", clear
    capture noisily export excel using "$docs/CarPrices_codebook.xlsx", ///
        firstrow(variables) replace
    if _rc di as txt "codebook saved as .dta; the .xlsx export failed."
    restore
}

compress
save "$cleaned/CarPrices_analytic.dta", replace
