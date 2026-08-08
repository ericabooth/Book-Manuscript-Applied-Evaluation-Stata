* ch06_provenance.do -- the provenance workflow, end to end
* Three yearly wage files arrive in three formats, one column renamed
* midstream.  The workflow: scaffold, stack and harmonize, tag, document,
* let a reviewer correct the metadata, fold the corrections back, and
* prove the panel answers the provenance question.
* Requires (all author's packages, installed locally): projectbuilder,
* convertanything, combineall, srctag/srcfind, datadictionary.
clear all
set varabbrev off
version 16.0

* work in a scratch folder so nothing lands in the book tree
local work "`c(tmpdir)'/ch06_provenance"
capture mkdir "`work'"
cd "`work'"
foreach junk in TWCwages drop {
    capture mkdir "`junk'"
}

* ---- 0. three annual releases, three formats, one renamed column ------------
set seed 20260808
quietly {
    clear
    set obs 40
    generate int  id    = _n
    generate wage  = round(18 + 6 * runiform(), .01)
    generate hours = round(28 + 14 * runiform())
    export delimited using "drop/wages_2019.csv", replace
    replace wage  = round(wage  * 1.03, .01)
    replace hours = min(hours + 1, 40)
    export excel using "drop/wages_2020.xlsx", firstrow(variables) replace
    replace wage = round(wage * 1.04, .01)
    rename hours hrs_weekly            // the 2021 release renames the column
    save "drop/wages_2021.dta", replace
}

* the rename map: one row, windowed to the year the new name applies
tempname mh
file open `mh' using "renames.csv", write text replace
file write `mh' "oldname,newname,firstyear,lastyear" _n
file write `mh' "hrs_weekly,hours,2021,2021" _n
file close `mh'

* ---- 1. ORGANIZE: one command builds the project ----------------------------
projectbuilder TWCwages, data("drop") replace rebuild                     ///
    description("TWC annual wage extracts, one row per worker per year")  ///
    topic("wages") publicfacing(no) timeline("annual")                    ///
    outcomes(wage hours) over(year)
assert r(nraw) == 3

* the auto-pass appended naively, so the 2021 rename is now a hole:
* hours is missing for every 2021 row.  Prove the drift is real.
use "TWCwages/02_cleaned/TWCwages_analytic.dta", clear
quietly count if missing(hours)
assert r(N) == 40                     // 2021's rows lost their hours

* ---- 2. COMBINE, this time harmonized ---------------------------------------
* One edit fixes it: rerun the stack with the rename map.  combineall
* extracts the year from each filename, applies the windowed rename, and
* stamps each renamed variable's origin in char[source].
combineall using "TWCwages/02_cleaned/TWCwages_analytic",                 ///
    cmethod(append) directory("TWCwages/01_raw/_converted")               ///
    filetype(dta) map("renames.csv") replace

use "TWCwages/02_cleaned/TWCwages_analytic.dta", clear
quietly count if missing(hours)
assert r(N) == 0                      // the hole is gone
confirm variable year
local s : char hours[source]
assert strpos(`"`s'"', "hrs_weekly") > 0    // combineall documented the rename

* ---- 3. TAG: add what the stamps lack, then sign ----------------------------
srctag wage hours, agency(TWC) dataset(annual wage extract) vintage(2019-2021)
srctag id, source(assigned at intake) notes(stable across years)
srctag year, source(derived by combineall from the filenames)
srctag sign
quietly save "TWCwages/02_cleaned/TWCwages_analytic.dta", replace

* ---- 4. DOCUMENT: a codebook for people, a relabel file for the data --------
datadictionary, excel("TWCwages/_documentation/TWCwages_codebook.xlsx") replace
datadictionary, dofile("TWCwages/_code/310_relabel.do") replace
confirm file "TWCwages/_documentation/TWCwages_codebook.xlsx"

* ---- 5. HUMAN REVIEW: a reviewer corrects the metadata itself ---------------
* Export the tags, one row per variable per tag ...
srcfind , all noreport saving("TWCwages/_documentation/lineage.dta", replace)
* ... the reviewer fixes a wrong vintage in that file ...
preserve
quietly {
    use "TWCwages/_documentation/lineage.dta", clear
    replace value = "2019q1-2021q4" if charname == "source_vintage"
    save "TWCwages/_documentation/lineage.dta", replace
}
restore
* ... and the edits fold back in: guarded, receipted, then re-signed
srctag apply using "TWCwages/_documentation/lineage.dta", replace
assert r(n_applied) == 2
srctag sign
quietly save "TWCwages/02_cleaned/TWCwages_analytic.dta", replace
* regenerate what the corrections made stale
datadictionary, excel("TWCwages/_documentation/TWCwages_codebook.xlsx") replace
datadictionary, dofile("TWCwages/_code/310_relabel.do") replace

* ---- 6. ANSWER: the panel explains itself -----------------------------------
srcfind TWC
assert r(n) == 2
local vv : char wage[source_vintage]
assert `"`vv'"' == "2019q1-2021q4"
* the completeness contract: nothing untagged, nothing stale
srcfind , untagged noreport
assert r(n) == 0
srctag verify
assert r(match) == 1

* analysis-ready: declare the panel
xtset id year
assert "`r(panelvar)'" == "id"

di as res "ch06_provenance.do: ALL CHECKS PASSED"
