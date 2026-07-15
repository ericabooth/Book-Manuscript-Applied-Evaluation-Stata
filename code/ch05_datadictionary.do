*==============================================================================*
* ch05_datadictionary.do  --  Chapter 5: the label round-trip across languages.
* SIMULATED data (set seed 20260714). Demonstrates datadictionary's dofile()
* and dictionary() options: a labeled Stata dataset leaves for another program
* as bare values, is edited, and returns to be re-dressed by a generated
* relabel do-file that prints a re-ingestion receipt.
*
* Mirrors Section 5.x "Sending data out and getting it back labeled" and
* Figure (label round-trip). No API key or platform access required.
*
* PREREQUISITE (once; public repo, install verified 2026-07-15):
*   net install datadictionary, ///
*     from("https://raw.githubusercontent.com/ericabooth/datadictionary-stata-public/main/") replace
*==============================================================================*
version 16
clear all
set more off

* Everything lands in a scratch folder next to this do-file
local WORK "dd_roundtrip"
capture mkdir "`WORK'"
cd "`WORK'"

*------------------------------------------------------------------------------*
* 0. A small labeled staff-wellbeing extract (what starts life in Stata)
*------------------------------------------------------------------------------*
set seed 20260714
set obs 180
gen int id = _n
label variable id "Respondent id"

gen byte q1 = runiformint(1, 5)
label variable q1 "Overall job satisfaction (1-5)"

label define agree4 1 "Strongly disagree" 2 "Disagree" 3 "Agree" 4 "Strongly agree"
gen byte q2 = runiformint(1, 4)
label values q2 agree4
label variable q2 "I feel supported by my supervisor"

gen byte q4 = runiformint(1, 4)
label values q4 agree4
label variable q4 "My workload is manageable"

gen str9 occupation = cond(mod(_n,3)==0, "Counselor", cond(mod(_n,3)==1, "Nurse", "Admin"))
label variable occupation "Occupation (free text)"

gen hours = round(rnormal(42, 6), .5)
replace hours = . if runiform() < .08
format hours %5.1f
label variable hours "Weekly work hours (self-report)"

note q2: Core supervisor-support item; fielded every wave.
char q2[srctag] "staff_survey_w1.dta"
char q2[module] "core"
save staff.dta, replace

*------------------------------------------------------------------------------*
* 1. Document the file AND write the relabel do-file (the descsave idea)
*------------------------------------------------------------------------------*
datadictionary, excel(staff_codebook) dofile(staff_relabel) dictionary(staff) replace
di as txt "codebook : `r(xlsx)'"
di as txt "relabel  : `r(dofile)'"
di as txt "dict     : `r(dct)'"

*------------------------------------------------------------------------------*
* 2. Export the NUMERIC CODES (nolabel) so value labels can reattach, then
*    share staff.csv + staff_codebook.xlsx with a collaborator
*------------------------------------------------------------------------------*
use staff.dta, clear
export delimited using staff.csv, nolabel replace

*------------------------------------------------------------------------------*
* 3. ...a collaborator edits staff.csv in R / Python / Excel. Here we SIMULATE
*    two realistic edits: they rename a column and add a derived one.
*------------------------------------------------------------------------------*
import delimited using staff.csv, varnames(1) case(preserve) clear
rename q4 q4_manage          // renamed header
gen byte overworked = q4_manage <= 2   // a derived column they added
export delimited using staff_edited.csv, nolabel replace

*------------------------------------------------------------------------------*
* 4. Get the edited file back and re-dress it in one -do-. Read the receipt:
*    it names q4 (renamed) and q4_manage/overworked (added).
*------------------------------------------------------------------------------*
import delimited using staff_edited.csv, varnames(1) case(preserve) clear
do staff_relabel

* confirm the round-trip restored the labels on the columns that kept their names
local ll2 : value label q2
assert "`ll2'" == "agree4"
local vl2 : variable label q2
assert `"`vl2'"' == "I feel supported by my supervisor"
local st : char q2[srctag]
assert "`st'" == "staff_survey_w1.dta"
di as res _n "ch05_datadictionary.do: round-trip verified, labels restored."

*------------------------------------------------------------------------------*
* 5. The dictionary alternative: a typed one-step -infile- read (types +
*    variable labels only; whitespace-delimited, so export with tab + quote).
*------------------------------------------------------------------------------*
use staff.dta, clear
export delimited using staff.txt, delimiter(tab) nolabel quote replace
infile using staff.dct, clear
assert _N == 180
di as txt "dictionary read: " as res _N as txt " rows, " as res c(k) as txt " typed & labeled variables"
