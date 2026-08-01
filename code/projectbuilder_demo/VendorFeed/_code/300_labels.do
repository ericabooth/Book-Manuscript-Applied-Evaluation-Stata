*===============================================================
* 300_labels.do -- VendorFeed
* Single job: variable/value labels and provenance on the analytic
* file, plus (optionally) a codebook export for the documentation.
*===============================================================
* Globals come from 000_control.do -- run that first.

use "$cleaned/VendorFeed_analytic.dta", clear

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

compress
save "$cleaned/VendorFeed_analytic.dta", replace
