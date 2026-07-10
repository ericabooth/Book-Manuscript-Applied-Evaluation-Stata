* test_projectbuilder.do -- test battery for projectbuilder v2.0.0
* Run from any scratch directory:  stata-mp -b do test_projectbuilder.do
* All paths live in globals set here; synthetic data only (no committed
* .dta/.log).  Judge success by the absence of r(NNN); and failed asserts.

clear all
set more off
version 16.0
set seed 20260707

* ---- where the package lives (edit if you moved it) -------------------
global pkgroot "/Users/ebooth/Documents/GitHub/Book Manuscript:Applied Evaluation-Stata/projectbuilder-stata-public"

* Prepend so this source copy wins over any older installed copy in PLUS.
adopath ++ "$pkgroot"

* ---- fresh scratch tree for this run ----------------------------------
tempfile tbase
global work "`tbase'_pbtest"
mkdir "$work"

* helper: load a text file one line per obs into v1 (line-oriented read)
capture program drop loadlines
program define loadlines
    import delimited using `0', clear delimiters("`=char(1)'", asstring) ///
        varnames(nonames) bindquote(nobind) encoding("utf-8")
end

di as text "{hline 70}"
di as text "TEST a1: Method B -- scaffold only, every folder and file exists"
di as text "{hline 70}"
projectbuilder Demo, path("$work")
assert `"`r(project)'"' == "Demo"
assert `"`r(path)'"'    == `"$work/Demo"'
assert r(nraw)       == 0
assert r(nconverted) == 0
assert r(rebuilt)    == 0

foreach d in 01_raw 01_raw/_archive 01_raw/_converted ///
             02_cleaned 02_cleaned/_archive ///
             03_output 03_output/_archive ///
             _code _code/_archive ///
             _documentation _documentation/_archive _documentation/website ///
             _archive {
    confirm file "$work/Demo/`d'/."
}
foreach f in 000_control.do 100_data_download.do 200_data_management.do ///
             300_labels.do 400_data_profiler.do 500_aggregation.do    ///
             600_analysis.do {
    confirm file "$work/Demo/_code/`f'"
}
foreach f in index.do _runall.do Readme.md {
    confirm file "$work/Demo/_documentation/`f'"
}
confirm file "$work/Demo/_documentation/website/index.html"

* 01_raw must be empty (no files; subfolders don't count)
local rl : dir "$work/Demo/01_raw" files "*"
assert `: word count `rl'' == 0

di as text "{hline 70}"
di as text "TEST a2: edit a code file, drop data, rebuild -> convert/combine/docs"
di as text "{hline 70}"

* sentinel line appended to a code file the 'user' has edited
tempname sfh
file open `sfh' using "$work/Demo/_code/000_control.do", write text append
file write `sfh' _n "* SENTINEL-KEEP-ME-4711" _n
file close `sfh'

* two synthetic CSVs dropped into 01_raw by hand
sysuse auto, clear
quietly export delimited using "$work/Demo/01_raw/auto_part1.csv", replace
keep make price mpg
quietly export delimited using "$work/Demo/01_raw/auto_part2.csv", replace

projectbuilder Demo, path("$work") rebuild
assert r(nraw)    == 2
assert r(rebuilt) == 1
confirm file "$work/Demo/_documentation/website/index.html"

* the rebuilt documentation mentions both raw files
loadlines "$work/Demo/_documentation/website/index.html"
quietly count if strpos(v1, "auto_part1.csv")
assert r(N) >= 1
quietly count if strpos(v1, "auto_part2.csv")
assert r(N) >= 1

* rebuild WITHOUT replace must NOT overwrite the edited code file
loadlines "$work/Demo/_code/000_control.do"
quietly count if strpos(v1, "SENTINEL-KEEP-ME-4711")
assert r(N) == 1

di as text "{hline 70}"
di as text "TEST a3: rebuild WITH replace overwrites the code file"
di as text "{hline 70}"
projectbuilder Demo, path("$work") rebuild replace
loadlines "$work/Demo/_code/000_control.do"
quietly count if strpos(v1, "SENTINEL-KEEP-ME-4711")
assert r(N) == 0

di as text "{hline 70}"
di as text "TEST b: Method A -- data() copies a folder of files into 01_raw/"
di as text "{hline 70}"
mkdir "$work/_src2"
sysuse auto, clear
quietly export delimited using "$work/_src2/src_a.csv", replace
keep make foreign
quietly export delimited using "$work/_src2/src_b.csv", replace
projectbuilder Demo2, path("$work") data("$work/_src2") ///
    description("two synthetic CSVs")
assert r(nraw) == 2
confirm file "$work/Demo2/01_raw/src_a.csv"
confirm file "$work/Demo2/01_raw/src_b.csv"

di as text "{hline 70}"
di as text "TEST c: clobber guard -- rerun without rebuild -> _rc==602"
di as text "{hline 70}"
capture noisily projectbuilder Demo, path("$work")
assert _rc == 602
confirm file "$work/Demo/_code/000_control.do"

di as text "{hline 70}"
di as text "TEST d: leaf/option validation -> _rc==198"
di as text "{hline 70}"
capture noisily projectbuilder "../evil", path("$work")
assert _rc == 198
capture noisily projectbuilder EvilPF, path("$work") publicfacing(maybe)
assert _rc == 198

di as text "{hline 70}"
di as text "TEST e: Source/Subsource nesting"
di as text "{hline 70}"
projectbuilder Agency/Extract, path("$work")
assert `"`r(project)'"' == "Agency_Extract"
assert `"`r(path)'"'    == `"$work/Agency/Extract"'
confirm file "$work/Agency/Extract/_code/000_control.do"
confirm file "$work/Agency/Extract/_documentation/website/index.html"

di as text "{hline 70}"
di as text "TEST f: the generated 000_control.do runs; its globals are real dirs"
di as text "{hline 70}"
* stash test state: the control file runs -clear all-, which drops globals,
* programs, and adopath additions.
local W  "$work"
local PK "$pkgroot"
do "$work/Demo2/_code/000_control.do"
assert `"$root"'      == `"`W'/Demo2"'   // NB: $root is stamped absolute
assert `"$raw"'       == `"`W'/Demo2/01_raw"'
assert `"$converted"' == `"`W'/Demo2/01_raw/_converted"'
assert `"$cleaned"'   == `"`W'/Demo2/02_cleaned"'
assert `"$output"'    == `"`W'/Demo2/03_output"'
assert `"$code"'      == `"`W'/Demo2/_code"'
assert `"$docs"'      == `"`W'/Demo2/_documentation"'
foreach g in root raw converted cleaned output code docs {
    confirm file "${`g'}/."
}

di as text ""
di as text "{hline 70}"
di as text "projectbuilder v2.0.0: ALL TESTS PASSED"
di as text "{hline 70}"
