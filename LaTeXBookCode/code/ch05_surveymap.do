* ch05_surveymap.do -- item nonresponse: refusal or routing?
* Two items in a workforce follow-up survey look equally badly answered.
* One is the instrument working correctly; the other is a question people
* refuse. -misstable- cannot tell them apart; -surveymap- can.
* Requires: surveymap (author's GitHub / SSC).
clear all
set varabbrev off
version 16.0

* c(tmpdir) ends with a separator on macOS, so joining a name to it makes a
* doubled slash that some path handling downstream does not survive.  Trim it.
local tmp "`c(tmpdir)'"
if inlist(substr("`tmp'", -1, 1), "/", "\") local tmp = substr("`tmp'", 1, strlen("`tmp'") - 1)
local work "`tmp'/ch05_surveymap"
capture mkdir "`work'"
cd "`work'"

* ---- a 6-month follow-up survey with two skip patterns ---------------------
set seed 20260829
quietly {
    set obs 900
    generate int resp_id = 1000 + _n
    label variable resp_id "Respondent id"

    label define yn 0 "No" 1 "Yes"

    * a few break off at the door; everything below is asked of consenters
    generate byte consent = runiform() < 0.96
    label values consent yn
    label variable consent "Consented"

    generate byte employed = .
    replace employed = runiform() < 0.62 if consent == 1
    label values employed yn
    label variable employed "Working for pay"

    * asked ONLY of the employed: blanks here are routing
    generate int hours = .
    replace hours = round(rnormal(36, 8))     if employed == 1
    replace hours = .a if employed == 1 & runiform() < 0.04
    label variable hours "Weekly hours"

    generate float wage = .
    replace wage = round(17 + 6*runiform(), .25) if employed == 1
    replace wage = .a if employed == 1 & runiform() < 0.11
    label variable wage "Hourly wage"

    * asked ONLY of the not-employed
    generate byte searching = .
    replace searching = runiform() < 0.71 if employed == 0
    label values searching yn
    label variable searching "Looked for work"

    * asked of every consenter
    generate byte useful = .
    replace useful = 1 + int(5*runiform()) if consent == 1
    replace useful = .a if consent == 1 & runiform() < 0.03
    label variable useful "Training useful"

    * asked of every consenter, and heavily refused: blanks here are refusal
    generate long hh_income = .
    replace hh_income = round(exp(rnormal(10.6, .5))) if consent == 1
    replace hh_income = .a if consent == 1 & runiform() < 0.34
    label variable hh_income "Household income"

    compress
    save followup.dta, replace
}

* ---- 1. the naive read: two items, both look broken ------------------------
misstable summarize wage hh_income

* ---- 2. the decomposition -------------------------------------------------
* branch() names the gate; surveymap reads routing from the responses.
surveymap, branch(employed) out("followup_journal.tsv") replace

* what the receipt establishes, as assertions
assert r(K_items) == 8
assert r(N)       == 900
assert r(N_gates) == 1
* every respondent lands in exactly one of answered/declined/not shown
assert r(N_unbalanced) == 0

* ---- 3. the two figures ----------------------------------------------------
* the band chart: one column per item, any instrument length, one page
surveymap band, saving("ch05_surveymap_band.png") replace

* the flow map: structure rather than length.  Four columns is what fits a
* printed page and stays legible; the browser page carries the whole thing.
preserve
    keep consent employed wage hh_income
    quietly surveymap, branch(employed) out("short_journal.tsv") replace
    surveymap draw, export(png) saving("ch05_surveymap_flow") replace
restore

* the browser page keeps every item and every number on hover
* surveymap draw, export(html) saving("followup_map.html")

di as res "ch05_surveymap.do: ALL CHECKS PASSED"
