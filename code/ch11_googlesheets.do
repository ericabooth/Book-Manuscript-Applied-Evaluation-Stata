*==============================================================================*
* ch11_googlesheets.do  --  Chapter 11: Google Sheets as a live channel
*------------------------------------------------------------------------------*
* DISPLAY-ONLY. Every -googlesheets- line below needs a one-time Google
* OAuth sign-in (Appendix A) and a live Sheet you can open, so this file is
* NOT run at book-build time and is not part of 00_control.do's build.
* It is the copy-pasteable workflow: point $SS at your own Sheet, complete
* the Appendix-A sign-in once, and every command here runs as written.
*
* Data: County Health Rankings & Roadmaps (CHR&R) 2025 state extract,
*   51 rows (50 states + DC). Columns A-K:
*   A fips  B state  C usps  D geo_code  E median_income  F premature_death
*   G obesity  H uninsured  I child_poverty  J unemployment  K pct_rural
* Sibling chapter: googlechart (Ch10) renders the SAME CHR data offline-to-HTML.
*==============================================================================*
version 18
clear all
set more off

* $SS is a Google Sheet ID (the ~44-char string in the URL) OR the full URL.
* Set your own here, or -googlesheets create- a fresh one and capture r(id).
global SS "YOUR_SHEET_ID_OR_URL"

*--- Load the CHR state extract (the same file googlechart charts in Ch10) ----*
import delimited using "`c(pwd)'/../data/chr_states_2025.csv", ///
    varnames(1) clear

*--- 1. Ping: confirm the connection and that you can reach the Sheet --------*
googlesheets ping, spreadsheet("$SS")

*--- 2. Make a clean tab: delete-if-exists, then add it fresh -----------------*
* Tabs must EXIST before -export-/-put-; -addsheet- creates one. Names are
* case-sensitive. The -capture- swallows the error if the tab isn't there yet.
capture googlesheets deletesheet, spreadsheet("$SS") title("CHR states 2025")
googlesheets addsheet,    spreadsheet("$SS") title("CHR states 2025")

*--- 3. Export the whole dataset in ONE bulk write (not a row loop) -----------*
* firstrow(variables) writes the variable names as the header row.
googlesheets export using "$SS", sheet("CHR states 2025") firstrow(variables)

*--- 4. Format cells (the -putexcel ..., overwritefmt- analog) ----------------*
* Header row: navy fill, white text, bold, Montserrat 12pt (Texas 2036 look).
googlesheets format using "$SS", sheet("CHR states 2025") range("A1:K1") ///
    bgcolor("#1B2D55") fgcolor("#FFFFFF") bold font("Montserrat") ///
    fontsize(12)
* Column E (median_income): show as US dollars with thousands separators.
googlesheets format using "$SS", sheet("CHR states 2025") ///
    range("E2:E52") numfmt(`""$"#,##0"')
* Column H (uninsured %): one decimal place.
googlesheets format using "$SS", sheet("CHR states 2025") ///
    range("H2:H52") numfmt("0.0")

*--- 5. put: write single values, strings, a formula, and a MATRIX -----------*
* -put- is the -putexcel- analog: exactly ONE of value()/string()/formula()/
* matrix() per call, placed at cell().

* A title and a build stamp off to the right of the data (column M).
googlesheets put using "$SS", sheet("CHR states 2025") cell(M1) ///
    string("2025 County Health Rankings -- state summary")
googlesheets put using "$SS", sheet("CHR states 2025") cell(M2) ///
    string("Built in Stata on `=c(current_date)'")

* A computed value: mean uninsured, rounded in Stata, written as a number.
quietly summarize uninsured
googlesheets put using "$SS", sheet("CHR states 2025") cell(M3) ///
    string("Mean uninsured (%)")
googlesheets put using "$SS", sheet("CHR states 2025") cell(N3) ///
    value(`=round(r(mean),.1)')

* A live formula: Sheets recomputes MAX in the browser, not Stata.
googlesheets put using "$SS", sheet("CHR states 2025") cell(M4) ///
    string("Max uninsured (%)")
googlesheets put using "$SS", sheet("CHR states 2025") cell(N4) ///
    formula("=MAX(H2:H52)")

* A correlation MATRIX, written as a labeled block starting at M6.
* matrix() writes a rowsof x colsof block from cell(); missing -> blank.
correlate uninsured median_income premature_death child_poverty
matrix C = r(C)
googlesheets put using "$SS", sheet("CHR states 2025") cell(M6) matrix(C)

*--- 6. addchart: two NATIVE, live Google Sheets charts -----------------------*
* These are real Sheets chart objects (not static PNGs): the team can hover,
* resize, and re-color them right in the browser, and they redraw when the
* underlying cells change. -addchart- has no putexcel equivalent.

* Chart 1 -- ranked bar of the 15 highest-uninsured states, on its own tab.
preserve
    gsort -uninsured
    keep in 1/15
    keep state uninsured
    capture googlesheets deletesheet, spreadsheet("$SS") ///
        title("Top15 uninsured")
    googlesheets addsheet, spreadsheet("$SS") title("Top15 uninsured")
    googlesheets export using "$SS", sheet("Top15 uninsured") ///
        firstrow(variables)
restore

googlesheets addchart using "$SS", sheet("Top15 uninsured") type(bar) ///
    domain(A2:A16) series(B2:B16) names("Uninsured (%)") ///
    title("States with the highest uninsured rate (2025)") ///
    xlabel("Uninsured (%)") ///
    tx2036style legendpos(NONE) ///
    targetsheet("Top15 uninsured") anchor(D2) width(620) height(420)

* Chart 2 -- scatter of median income (E) vs premature death (F).
googlesheets addchart using "$SS", sheet("CHR states 2025") type(scatter) ///
    domain(E2:E52) series(F2:F52) names("State") ///
    title("Higher income, fewer years of life lost (states, 2025)") ///
    xlabel("Median household income (USD)") ///
    ylabel("Premature death (YPLL per 100,000)") ///
    tx2036style legendpos(NONE) ///
    targetsheet("CHR states 2025") anchor(M9) width(620) height(400)

*--- 7. Round-trip QA: read the tab back and confirm the write landed --------*
* An evaluator who writes to a shared sheet and never reads it back is
* trusting the API, the tab name, and the range all behaved. Read-back +
* -count- catches the silent partial write before the team sees it.
googlesheets import using "$SS", sheet("CHR states 2025") ///
    range("A1:K52") firstrow clear
count
assert _N == 51

*==============================================================================*
* 8. Google Forms angle -- the live-monitoring bridge to Chapter (surveys)
*------------------------------------------------------------------------------*
* A Google Form writes each submission as a row on a "Form Responses 1" tab
* (Timestamp is the first column). -import- reads that tab like any other.
* Two server-cheap incremental filters keep the pull small on a schedule:
*   tail(N)          -- keep only the last N rows
*   since(col=value) -- keep rows where header column >= value (dates & numbers
*                       parsed as such, robust to unpadded Google hours)
*------------------------------------------------------------------------------*
* Last 50 responses only (a cron-friendly, quota-cheap monitoring pull):
googlesheets import using "$SS", sheet("Form Responses 1") ///
    firstrow clear tail(50)

* Everything submitted on or after a cutoff timestamp:
googlesheets import using "$SS", sheet("Form Responses 1") ///
    firstrow clear since(Timestamp=2026-07-04 12:00:00)

di "DONE (display-only: run against your own Sheet after Appendix-A sign-in)"
