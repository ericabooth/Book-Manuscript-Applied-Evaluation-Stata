*==============================================================================*
* ch06_reshapehelper.do  --  Chapter 6: getting the reshape command right.
* Reproduces the reshapehelper diagnosis printed in the chapter figure, then
* runs the suggestion the tool stores, and shows two harder cases (a duplicate
* that blocks the widening, and a doubly-wide layout that needs two reshapes).
* SIMULATED data; no API key or network needed.
*
* reshapehelper NEVER reshapes your data -- it scans the names, finds i and j,
* composes the reshape command, and test-runs it on a sample under
* preserve/restore before handing it back in r(cmd) and $reshapehelper_cmd.
*
* PREREQUISITE (once; public repo):
*   net install reshapehelper, ///
*     from("https://raw.githubusercontent.com/ericabooth/reshapehelper-stata-public/main/") replace force
*==============================================================================*
version 16
clear all
set more off

*------------------------------------------------------------------------------*
* 1. The chapter figure: a grant file with one outcome column per year
*------------------------------------------------------------------------------*
clear
input int site served2021 served2022 served2023
101 120 145 168
102  90 110 132
103 210 205 240
end
label var served2021 "Participants served, 2021"

reshapehelper
* -> suggests and dry-runs: reshape long served, i(site) j(year)

* read the diagram, agree, and run what it stored:
$reshapehelper_cmd

* the reshape's own tiny contract: same number of sites before and after
quietly levelsof site, local(sites)
assert `: word count `sites'' == 3
list, sepby(site)

*------------------------------------------------------------------------------*
* 2. When it CANNOT settle: a duplicate site-year blocks the widening. The tool
*    diagnoses the collision and hands back a remedy menu, not a broken command.
*------------------------------------------------------------------------------*
clear
input int site int year served
101 2021 120
101 2022 145
102 2021  90
102 2021  90
102 2022 110
end
reshapehelper, to(wide)
di as txt "status = " as res "`r(status)'"
di as txt "diagnosis: " as res `"`r(diagnosis)'"'
* here the repeat is an exact duplicate row, so:
duplicates drop
reshapehelper, to(wide)
$reshapehelper_cmd

*------------------------------------------------------------------------------*
* 3. Doubly wide: two indices packed into each name (kid, then time). One
*    reshape cannot unpack two dimensions; reshapehelper writes both, tested.
*------------------------------------------------------------------------------*
clear
input famid ht_k1_t1 ht_k1_t2 ht_k2_t1 ht_k2_t2
1 3.1 3.6 4.0 4.4
2 3.3 3.8 4.1 4.6
3 3.0 3.5 3.9 4.3
end
reshapehelper
di as txt "step 1: " as res `"$reshapehelper_cmd"'
di as txt "step 2: " as res `"$reshapehelper_cmd2"'
$reshapehelper_cmd
$reshapehelper_cmd2
list, sepby(famid)

di as res _n "ch06_reshapehelper.do complete."
