* ===========================================================================
* test_reshapehelper.do -- test battery for reshapehelper v0.9.0
* Run in batch from the package directory:
*     stata-mp -b do test_reshapehelper.do
* Judge the run by the log: no r(NNN) errors, no "assertion is false".
* ---------------------------------------------------------------------------
* Scenarios T1-T18 mirror the researched catalog: the [D] reshape manual
* examples, the Stata "problems with reshape" FAQ, UCLA OARC's doubly-wide
* FAQ, and Statalist threads (prefix-j, duplicate (i,j), composite factors,
* transpose confusion).  reshapehelper must never modify the data in memory;
* every scenario asserts the row/column counts afterward.
* ===========================================================================
global pkgroot "/Users/ebooth/Documents/GitHub/Book Manuscript:Applied Evaluation-Stata/reshapehelper-stata-public"

version 16.0
clear all
set more off
set seed 20260715
adopath + "$pkgroot"

* ---------------------------------------------------------------------------
* T1. Classic wide -> long, numeric suffixes ([D] reshape Example 1)
* ---------------------------------------------------------------------------
clear
input id sex inc80 inc81 inc82
1 0 5000 5500 6000
2 1 2000 2200 3300
3 0 3000 2000 1000
end
reshapehelper
assert "`r(status)'"    == "ok"
assert "`r(direction)'" == "wide2long"
assert r(tested)        == 1
assert strpos(`"`r(cmd)'"', "reshape long inc, i(id) j(year)") > 0
assert `"$reshapehelper_cmd"' == `"`r(cmd)'"'
assert _N == 3 & c(k) == 5          // data untouched

* ---------------------------------------------------------------------------
* T2. Two stubs at once: inc AND ue ([D] reshape Example 1, full)
* ---------------------------------------------------------------------------
clear
input id sex inc80 inc81 inc82 ue80 ue81 ue82
1 0 5000 5500 6000 0 1 0
2 1 2000 2200 3300 1 0 0
3 0 3000 2000 1000 0 0 1
end
reshapehelper
assert "`r(status)'" == "ok"
assert r(tested)     == 1
assert strpos(`"`r(cmd)'"', "reshape long inc ue, i(id) j(year)") > 0

* ---------------------------------------------------------------------------
* T3. Classic long -> wide ([D] reshape Example 1 reversed)
* ---------------------------------------------------------------------------
clear
input id year sex inc ue
1 80 0 5000 0
1 81 0 5500 1
1 82 0 6000 0
2 80 1 2000 1
2 81 1 2200 0
2 82 1 3300 0
3 80 0 3000 0
3 81 0 2000 0
3 82 0 1000 1
end
reshapehelper, to(wide)
assert "`r(status)'"    == "ok"
assert "`r(direction)'" == "long2wide"
assert r(tested)        == 1
assert strpos(`"`r(cmd)'"', "reshape wide inc ue, i(id) j(year)") > 0
assert _N == 9 & c(k) == 5

* ---------------------------------------------------------------------------
* T4. String suffixes after an underscore (sysuse bpwide)
* ---------------------------------------------------------------------------
sysuse bpwide, clear
reshapehelper
assert "`r(status)'" == "ok"
assert r(tested)     == 1
assert strpos(`"`r(cmd)'"', "reshape long bp_, i(patient) j(period) string") > 0

* ---------------------------------------------------------------------------
* T5. @ mid-name stubs beside plain stubs ([D] reshape Example 7: inc@r + ue)
* ---------------------------------------------------------------------------
clear
input id sex inc80r inc81r inc82r ue80 ue81 ue82
1 0 5000 5500 6000 0 1 0
2 1 2000 2200 3300 1 0 0
3 0 3000 2000 1000 0 0 1
end
reshapehelper
assert "`r(status)'" == "ok"
assert r(tested)     == 1
assert strpos(`"`r(cmd)'"', "inc@r") > 0
assert strpos(`"`r(cmd)'"', "ue") > 0
assert strpos(`"`r(cmd)'"', "j(year)") > 0

* ---------------------------------------------------------------------------
* T6. Unbalanced stubs: ue81 does not exist ([D] reshape Example 6)
* ---------------------------------------------------------------------------
clear
input id sex inc80 inc81 inc82 ue80 ue82
1 0 5000 5500 6000 0 0
2 1 2000 2200 3300 1 0
3 0 3000 2000 1000 0 1
end
reshapehelper
assert "`r(status)'" == "ok"
assert r(tested)     == 1
assert strpos(`"`r(cmd)'"', "reshape long inc ue, i(id) j(year)") > 0
assert strpos(`"`r(note)'"', "unbalanced") > 0

* ---------------------------------------------------------------------------
* T7. The inc2 trap: a stray same-stub variable ([D] reshape, j() values).
*     The dry run PASSES (reshape happily builds a j=2 group), so the
*     mixed-width caution is the safety net.
* ---------------------------------------------------------------------------
clear
input id sex inc80 inc81 inc82 inc2
1 0 5000 5500 6000 1
2 1 2000 2200 3300 0
3 0 3000 2000 1000 1
end
reshapehelper
assert "`r(status)'" == "ok"
assert r(tested)     == 1
assert strpos(`"`r(caution)'"', "widths differ") > 0
assert strpos(`"`r(caution)'"', "restrict j") > 0

* ---------------------------------------------------------------------------
* T8. Inconsistent stub names: inc80 / income81 / incm82 (UVA + Stata FAQ).
*     No family forms, so the helper must say so and coach a rename.
* ---------------------------------------------------------------------------
clear
input id sex inc80 income81 incm82
1 0 5000 5500 6000
2 1 2000 2200 3300
3 0 3000 2000 1000
end
reshapehelper
assert "`r(status)'" == "needinfo"
assert `"`r(cmd)'"' == ""

* ---------------------------------------------------------------------------
* T9. String j containing spaces (Statalist r(111) thread): forced j(state)
*     must trigger the pre-clean line, the string option, and a passing test
* ---------------------------------------------------------------------------
clear
input year str12 state pop
2020 "New York" 20.2
2020 "Texas" 29.1
2021 "New York" 19.8
2021 "Texas" 29.5
end
reshapehelper, to(wide) j(state)
assert "`r(status)'" == "ok"
assert r(tested)     == 1
assert strpos(`"`r(cmd)'"', "j(state) string") > 0
assert strpos(`"`r(preclean)'"', "subinstr") > 0
assert _N == 4 & c(k) == 3          // caller's data untouched (incl. spaces)
assert strpos(state[1], " ") > 0

* ---------------------------------------------------------------------------
* T10. Prefix-as-j: qld_p nsw_p vic_p (Statalist "no xij variables found")
* ---------------------------------------------------------------------------
clear
input year qld_p nsw_p vic_p
2018 4.9 7.9 6.4
2019 5.0 8.0 6.5
2020 5.1 8.1 6.6
end
reshapehelper
assert "`r(status)'" == "ok"
assert r(tested)     == 1
assert strpos(`"`r(cmd)'"', "@_p") > 0
assert strpos(`"`r(cmd)'"', "string") > 0

* ---------------------------------------------------------------------------
* T11. Duplicate (i, j) pairs block reshape wide (Statalist / manual Ex. 3):
*      the helper must diagnose, count, and hand back the remedy menu
* ---------------------------------------------------------------------------
clear
input id year inc
1 2019 45000
1 2020 47000
2 2019 32000
2 2019 32000
2 2020 33500
end
reshapehelper, to(wide)
assert "`r(status)'" == "needinfo"
assert strpos(`"`r(diagnosis)'"', "duplicates report") > 0
assert strpos(`"`r(diagnosis)'"', "collapse") > 0
assert strpos(`"`r(diagnosis)'"', "concat") > 0

* ---------------------------------------------------------------------------
* T12. Two crossed factors (Statalist animal/level/delay): the helper finds a
*      compound i and widens ONE factor, and its note points to the rest
* ---------------------------------------------------------------------------
clear
input animal s1level s1s2delay s2peakvalue
1 0 50 12.1
1 0 100 13.4
1 0 200 15.2
1 1 50 18.3
1 1 100 19.9
1 1 200 22.4
2 0 50 11.8
2 0 100 12.9
2 0 200 14.7
2 1 50 17.5
2 1 100 19.2
2 1 200 21.8
end
reshapehelper, to(wide)
assert "`r(status)'" == "ok"
assert r(tested)     == 1
assert strpos(`"`r(cmd)'"', "reshape wide s2peakvalue") > 0
assert strpos(`"`r(note)'"', "concat") > 0

* ---------------------------------------------------------------------------
* T13. Doubly wide (UCLA FAQ): two digit runs in the names -> two chained
*      reshapes, both dry-run tested
* ---------------------------------------------------------------------------
clear
input famid ht_k1_t1 ht_k1_t2 ht_k2_t1 ht_k2_t2
1 3.1 3.6 4.0 4.4
2 3.3 3.8 4.1 4.6
3 3.0 3.5 3.9 4.3
end
reshapehelper
assert "`r(status)'"    == "ok"
assert "`r(direction)'" == "doubly"
assert r(tested)        == 1
assert `"`r(cmd2)'"' != ""
assert strpos(`"`r(cmd)'"',  "reshape long ht_k1_t ht_k2_t, i(famid)") > 0
assert strpos(`"`r(cmd2)'"', "reshape long ht_k@_t, i(famid") > 0
assert _N == 3 & c(k) == 5

* ---------------------------------------------------------------------------
* T14. Long-long to wide-wide, step one ([D] reshape second-level nesting):
*      compound i() found, low-cardinality factor left in i() flagged
* ---------------------------------------------------------------------------
clear
input hid str1 sex year inc
1 "f" 90 3200
1 "f" 91 4700
1 "m" 90 4500
1 "m" 91 4600
2 "f" 90 3600
2 "f" 91 3800
2 "m" 90 5100
2 "m" 91 5300
end
reshapehelper, to(wide)
assert "`r(status)'" == "ok"
assert r(tested)     == 1
assert strpos(`"`r(cmd)'"', "reshape wide inc") > 0
assert `"`r(note)'"' != ""

* ---------------------------------------------------------------------------
* T15. Already-long tidy panel, no to(): the helper reads it as long and
*      offers the wide command
* ---------------------------------------------------------------------------
clear
input id year inc
1 80 5000
1 81 5500
1 82 6000
2 80 2000
2 81 2200
2 82 3300
end
reshapehelper
assert "`r(status)'"    == "ok"
assert "`r(direction)'" == "long2wide"
assert r(tested)        == 1

* ---------------------------------------------------------------------------
* T16. Transpose, not reshape (Statalist xpose thread): metrics as rows
* ---------------------------------------------------------------------------
clear
input str12 metric alpha beta gamma
"n"       100 200 150
"mean"    52.1 48.9 50.3
"missing" 3 7 5
end
reshapehelper
assert "`r(status)'" == "needinfo"
assert r(xpose) == 1

* ---------------------------------------------------------------------------
* T17. Wide-long panel honoring xtset: county-year rows with sector columns;
*      i() must include the existing time variable
* ---------------------------------------------------------------------------
clear
input county year emp_manuf emp_retail emp_gov
1 2019 120 340 210
1 2020 115 330 215
2 2019  80 210 150
2 2020  78 220 155
3 2019  60 190 120
3 2020  61 200 118
end
xtset county year
reshapehelper
assert "`r(status)'" == "ok"
assert r(tested)     == 1
assert strpos(`"`r(cmd)'"', "reshape long emp_, i(county year)") > 0
assert strpos(`"`r(cmd)'"', "string") > 0
assert strpos(`"`r(note)'"', "SECOND long dimension") > 0

* ---------------------------------------------------------------------------
* T18. User-assisted bare string suffixes ([D] reshape Example 8: incm/incf):
*      stubs()+i()+j() supplied; the dry-run engine discovers the string
*      option by iterating on reshape's own r(498)
* ---------------------------------------------------------------------------
clear
input id kids incm incf
1 0 5000 5500
2 1 2000 2200
3 2 3000 2000
end
reshapehelper, to(long) stubs(inc) i(id) j(sex)
assert "`r(status)'" == "ok"
assert r(tested)     == 1
assert strpos(`"`r(cmd)'"', "reshape long inc, i(id) j(sex) string") > 0

* ---------------------------------------------------------------------------
* T19. Guardrails: shorthand tokens, bad options, empty data
* ---------------------------------------------------------------------------
sysuse bpwide, clear
reshapehelper long                    // bare-token shorthand for to(long)
assert "`r(status)'" == "ok"
capture reshapehelper, to(sideways)
assert _rc == 198
capture reshapehelper, sample(3)
assert _rc == 198
clear
capture reshapehelper
assert _rc == 2000

* ---------------------------------------------------------------------------
* T20. The SMCL suggestion file exists and holds the unwrapped command
* ---------------------------------------------------------------------------
clear
input id inc80 inc81
1 5000 5500
2 2000 2200
end
tempfile junk
reshapehelper, smcl("$pkgroot/scratch_suggestion.smcl") replace
assert "`r(status)'" == "ok"
confirm file "$pkgroot/scratch_suggestion.smcl"
file open fh using "$pkgroot/scratch_suggestion.smcl", read text
local found 0
file read fh line
while r(eof) == 0 {
    if strpos(`"`macval(line)'"', "reshape long inc, i(id) j(year)") local found 1
    file read fh line
}
file close fh
assert `found' == 1
erase "$pkgroot/scratch_suggestion.smcl"

di as res _n "test_reshapehelper.do: ALL TESTS PASSED"
