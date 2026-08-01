*===============================================================
* 100_data_download.do -- VendorFeed
* Single job: get the raw source files into $raw.
* Raw files are write-once: downloaded/copied, never edited by hand.
*===============================================================
* Globals come from 000_control.do -- run that first.

* Source URL recorded from the url() option:
*   https://example.gov/vendor/monthly.csv
* Fetch it with Stata's -copy- (works for http/https URLs):
capture copy "https://example.gov/vendor/monthly.csv" "$raw/monthly.csv", replace
if _rc di as txt "100: could not fetch the URL; check the address or drop the file into $raw by hand."

* Provenance notes (who/where/when the raw files came from):
*   (not recorded)
