* test_rawsweep.do -- behavioral contract for rawsweep
clear all
adopath ++ "`c(pwd)'"
set varabbrev off

* --- build a throwaway intake folder ------------------------------------------
tempfile junk
local dir "`c(tmpdir)'/rawsweep_test"
capture mkdir "`dir'"
foreach f in clean.csv notes.csv empty.txt manifest.csv {
    capture erase "`dir'/`f'"
}
* clean file
file open h using "`dir'/clean.csv", write replace
file write h "id,score" _n "1,10" _n "2,12" _n
file close h
* file with an SSN and an email
file open h using "`dir'/notes.csv", write replace
file write h "id,note" _n `"1,"SSN 123-45-6789 at intake""' _n ///
    `"2,"email bob@test.io""' _n "3,clean row" _n
file close h
* zero-byte file
file open h using "`dir'/empty.txt", write replace
file close h

* --- (1) manifest counts, sizes, pii flags -------------------------------------
rawsweep, directory("`dir'") pii clear
assert r(files) == 3
assert r(flagged) == 1
assert _N == 3
quietly summarize bytes if filename == "empty.txt"
assert r(max) == 0
quietly summarize pii_hits if filename == "notes.csv"
assert r(max) == 2
quietly summarize pii_hits if filename == "clean.csv"
assert r(max) == 0

* --- (2) refuses to clobber data without clear ---------------------------------
capture noisily rawsweep, directory("`dir'")
assert _rc == 4

* --- (3) without pii option, no scan; saving writes a csv -----------------------
rawsweep, directory("`dir'") saving("`c(tmpdir)'/rawsweep_manifest.csv") replace clear
assert r(flagged) == 0
confirm file "`c(tmpdir)'/rawsweep_manifest.csv"

* --- (4) missing directory errors cleanly ---------------------------------------
capture noisily rawsweep, directory("`dir'/nope") clear
assert _rc == 601

di as res "ALL TESTS PASSED"
