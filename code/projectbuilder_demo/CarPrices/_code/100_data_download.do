*===============================================================
* 100_data_download.do -- CarPrices
* Single job: get the raw source files into $raw.
* Raw files are write-once: downloaded/copied, never edited by hand.
*===============================================================
* Globals come from 000_control.do -- run that first.

* No source URL was recorded at scaffold time.
* If the source lives at a URL, note it here and fetch with -copy-:
* copy "https://example.com/data.csv" "$raw/data.csv", replace
* If the files arrive by hand (email, thumb drive, shared folder),
* drop them into $raw and record who sent them, and when, below.

* Provenance notes (who/where/when the raw files came from):
*   (not recorded)
