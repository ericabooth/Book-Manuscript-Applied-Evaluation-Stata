* test_ai_privacy_gate.do -- behavioral contract for ai_privacy_gate
* run: stata-mp -b do test_ai_privacy_gate.do ; grep for ALL TESTS PASSED
clear all
adopath ++ "`c(pwd)'"
set varabbrev off

* --- build a 12-note test file with planted PII ---------------------------
clear
input str244 notes
"Client reports progress on transportation barrier this week."
"Follow up scheduled; SSN 123-45-6789 recorded at intake."
"Call back at (512) 555-1234 after Tuesday."
"Emailed jane.doe@example.org the schedule."
"DOB 03/14/1987 confirmed against roster."
"Lives at 4412 Maple Street since March."
"MRN: 88471 transferred from the clinic."
"No barriers reported; attended all sessions."
"Second contact 512-555-9876 belongs to the sister."
"Prefers morning appointments; no changes."
"Case# 100234 flagged for review by supervisor."
"Discussed goals; nothing identifying shared."
end
gen str60 comments = "clean text here"
replace comments = "reach me at bob@test.io" in 10

* --- (1) report mode: exact per-class counts -----------------------------
ai_privacy_gate notes comments, genflag(pii)
assert r(ssn)     == 1
assert r(email)   == 2
assert r(date)    == 1
assert r(address) == 1
assert r(idnum)   == 2
assert r(phone)   == 2
assert r(rows)    == 9
assert pii == 1 if inlist(_n, 2,3,4,5,6,7,9) | inlist(_n, 10,11)
assert pii == 0 if inlist(_n, 1,8,12)

* --- (2) stop mode errors on dirty data ----------------------------------
capture noisily ai_privacy_gate notes, action(stop) noreport
assert _rc == 459

* --- (3) mask removes every match; gate then passes ----------------------
preserve
ai_privacy_gate notes comments, action(mask) noreport
capture noisily ai_privacy_gate notes comments, action(stop) noreport
assert _rc == 0
assert r(rows) == 0
assert strpos(notes[2], "[REDACTED-SSN]") > 0
assert strpos(notes, "123-45-6789") == 0
restore

* --- (4) clean data passes stop mode -------------------------------------
keep in 1
capture noisily ai_privacy_gate notes comments, action(stop) noreport
assert _rc == 0

* --- (5) bad action errors cleanly ---------------------------------------
capture noisily ai_privacy_gate notes, action(delete)
assert _rc == 198

di as res "ALL TESTS PASSED"
