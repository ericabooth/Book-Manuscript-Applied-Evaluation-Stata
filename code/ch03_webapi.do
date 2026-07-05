*==============================================================================*
* ch03_webapi.do  --  Chapter 3: JSON APIs in one line with webapi
* Every request here hits a live PUBLIC endpoint with NO API key.
* webapi uses only Stata's built-in Python (no pip install).
*
* Install once (public repo, install verified 2026-07-05):
*   net install webapi, ///
*     from("https://raw.githubusercontent.com/ericabooth/webapi-stata-public/main/") replace
*==============================================================================*
* Standalone globals; in the full project these come from 00_control.do.
global root "`c(pwd)'"

*--- 1. A public JSON array: nesting flattens automatically --------------------*
* address.city in the JSON arrives as the column addresscity.
webapi get using "https://jsonplaceholder.typicode.com/users", clear
describe, short
list id name addresscity in 1/3, noobs

*--- 2. Real health data, no key: CDC national mortality (Socrata JSON) --------*
webapi get using "https://data.cdc.gov/resource/bi63-dtpu.json", ///
    params("year=2017|cause_name=All causes") clear
di "rows=" r(nrows) "  http=" r(http)
destring deaths, replace force
keep state deaths
gsort -deaths
list in 1/6, noobs

*--- 3. The $ trap: Socrata SoQL options start with $, which Stata eats --------*
* Stata reads $ as a global macro, so params("$limit=5") silently becomes
* params("=5"). The clean fix is to avoid $ options entirely: plain field
* filters (field=value, as in step 2) do the same job with no dollar sign.
* If you truly need a $ clause, cap the rows in Stata after import instead:
webapi get using "https://data.cdc.gov/resource/bi63-dtpu.json", ///
    params("year=2017|cause_name=All causes") clear
keep in 1/5                                   // "limit" applied in Stata, no $
di "capped rows=" _N

*--- 4. Polling into a live panel (survey-monitoring pattern, Chapter 5) -------*
* every(#) seconds, times(#) snapshots; each stamped _poll and appended.
webapi get using ///
    "https://timeapi.io/api/Time/current/zone?timeZone=America/Chicago", ///
    records("") every(1) times(3) clear
list _poll seconds, noobs

di "DONE"
