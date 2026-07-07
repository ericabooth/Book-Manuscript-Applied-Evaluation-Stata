* test_projectbuilder.do -- test battery for projectbuilder v1.0.0
* Run from any scratch directory:  stata-mp -b do test_projectbuilder.do
* All paths live in globals set here; nothing below is hard-coded.

clear all
set more off
version 16.0

global pkgroot "/Users/ebooth/Documents/GitHub/Book Manuscript:Applied Evaluation-Stata/projectbuilder-stata-public"

adopath + "$pkgroot"
set seed 20260706

* fresh scratch tree for this run (tempfile gives a unique, unused path)
tempfile tbase
global work "`tbase'_pbtest"
mkdir "$work"

di as text "{hline 70}"
di as text "TEST 1: plain scaffold -- every folder and file exists"
di as text "{hline 70}"
projectbuilder demo, path("$work")
local rproj `"`r(project)'"'
local rpath `"`r(path)'"'
assert `"`rproj'"' == "demo"
assert `"`rpath'"' == `"$work/demo"'
foreach d in raw clean code output figures {
    confirm file "$work/demo/`d'/."
}
foreach f in 00_control.do 100_ingest.do 200_clean.do ///
             300_analyze.do 400_visualize.do 500_report.do {
    confirm file "$work/demo/code/`f'"
}
confirm file "$work/demo/README.md"

di as text "{hline 70}"
di as text "TEST 2: run the generated 00_control.do; globals resolve"
di as text "{hline 70}"
do "$work/demo/code/00_control.do"
assert `"$root"'    == `"$work/demo"'
assert `"$raw"'     == `"$work/demo/raw"'
assert `"$clean"'   == `"$work/demo/clean"'
assert `"$code"'    == `"$work/demo/code"'
assert `"$output"'  == `"$work/demo/output"'
assert `"$figures"' == `"$work/demo/figures"'
foreach g in root raw clean code output figures {
    confirm file "${`g'}/."
}

di as text "{hline 70}"
di as text "TEST 3: re-run on the same target -> refuse to clobber (602)"
di as text "{hline 70}"
capture noisily projectbuilder demo, path("$work")
assert _rc == 602
* and it changed nothing: the control file is still there
confirm file "$work/demo/code/00_control.do"

di as text "{hline 70}"
di as text "TEST 4: Source/Subsource nesting"
di as text "{hline 70}"
projectbuilder Agency/Extract, path("$work")
local rproj `"`r(project)'"'
local rpath `"`r(path)'"'
assert `"`rproj'"' == "Agency_Extract"
assert `"`rpath'"' == `"$work/Agency/Extract"'
foreach d in raw clean code output figures {
    confirm file "$work/Agency/Extract/`d'/."
}
confirm file "$work/Agency/Extract/code/00_control.do"
confirm file "$work/Agency/Extract/README.md"
* a second subsource under the same source nests beside the first
projectbuilder Agency/Extract2, path("$work")
confirm file "$work/Agency/Extract2/code/00_control.do"

di as text "{hline 70}"
di as text "TEST 5: metadata-rich scaffold -- stamps land where promised"
di as text "{hline 70}"

* helper: load a text file one line per obs into v1 (defined here, after
* TEST 2, because the generated 00_control.do runs -clear all-, which
* drops any program defined earlier in this do-file)
capture program drop loadlines
program define loadlines
    * `0' arrives already quoted by the caller; do not re-quote it
    import delimited using `0', clear delimiters("`=char(1)'", asstring) ///
        varnames(nonames) bindquote(nobind) encoding("utf-8")
end

projectbuilder MetaRich, path("$work")                              ///
    description("pbtest-marker-4711 county unemployment extracts")  ///
    url("https://example.org/data/unemp.csv")                       ///
    topic("labor markets") publicfacing(yes) timeline(annual)       ///
    othernotes("received from J. Doe on 2026-06-30")                ///
    outcomes(unemp_rate labor_force) over(county year) descsave

* 5a. README carries the description, url, topic, timeline, notes
loadlines "$work/MetaRich/README.md"
quietly count if strpos(v1, "pbtest-marker-4711 county unemployment extracts")
assert r(N) >= 1
quietly count if strpos(v1, "https://example.org/data/unemp.csv")
assert r(N) >= 1
quietly count if strpos(v1, "labor markets")
assert r(N) >= 1
quietly count if strpos(v1, "annual")
assert r(N) >= 1
quietly count if strpos(v1, "received from J. Doe on 2026-06-30")
assert r(N) >= 1

* 5b. url() lands as the download-target comment in 100_ingest.do
loadlines "$work/MetaRich/code/100_ingest.do"
quietly count if strpos(v1, "https://example.org/data/unemp.csv")
assert r(N) >= 2   // the recorded comment and the ready-to-uncomment copy line

* 5c. outcomes()/over() land as suggested locals in 300_analyze.do
loadlines "$work/MetaRich/code/300_analyze.do"
quietly count if strpos(v1, `"local outcomes "unemp_rate labor_force""')
assert r(N) == 1
quietly count if strpos(v1, `"local over     "county year""')
assert r(N) == 1

* 5d. descsave option writes the commented descsave call in 200_clean.do
loadlines "$work/MetaRich/code/200_clean.do"
quietly count if strpos(v1, "descsave")
assert r(N) >= 1

* 5e. without descsave, 200_clean.do has no descsave call
loadlines "$work/demo/code/200_clean.do"
quietly count if strpos(v1, "descsave")
assert r(N) == 0

* 5f. the generated control file contains real $-globals and `locals',
*     not placeholder artifacts.  Needles are built with char() so the
*     test itself does not macro-expand them ($root is set by TEST 2).
loadlines "$work/MetaRich/code/00_control.do"
quietly count if strpos(v1, "global raw") & strpos(v1, char(36) + "root/raw")
assert r(N) == 1
quietly count if strpos(v1, char(36) + "{" + char(96) + "f'}")
assert r(N) == 1
quietly count if strpos(v1, "if " + char(96) + "run_all' {")
assert r(N) == 1
quietly count if strpos(v1, "local run_all 0")
assert r(N) == 1
quietly count if strpos(v1, "~D") | strpos(v1, "~B")
assert r(N) == 0

di as text "{hline 70}"
di as text "TEST 6: outcomes()/over() capped at 10 with a trim note"
di as text "{hline 70}"
projectbuilder CapTest, path("$work") ///
    outcomes(o1 o2 o3 o4 o5 o6 o7 o8 o9 o10 o11 o12)
loadlines "$work/CapTest/code/300_analyze.do"
quietly count if strpos(v1, "o10")
assert r(N) >= 1
quietly count if strpos(v1, "o11")
assert r(N) == 0

di as text "{hline 70}"
di as text "TEST 7: default base path is the current working directory"
di as text "{hline 70}"
local oldpwd `"`c(pwd)'"'
quietly cd "$work"
* compare against c(pwd), not $work: the OS may resolve symlinks
* (e.g. /var -> /private/var on macOS) when changing directory
local workres `"`c(pwd)'"'
projectbuilder PwdDefault
local rpath `"`r(path)'"'
assert `"`rpath'"' == `"`workres'/PwdDefault"'
confirm file "$work/PwdDefault/code/00_control.do"
quietly cd `"`oldpwd'"'

di as text "{hline 70}"
di as text "TEST 8: validation errors (all exit 198)"
di as text "{hline 70}"

* 8a. leaf name with ".."
capture noisily projectbuilder "bad..leaf", path("$work")
assert _rc == 198

* 8b. backslash in the name
capture noisily projectbuilder "Agency\Sub", path("$work")
assert _rc == 198

* 8c. more than one level of nesting
capture noisily projectbuilder A/B/C, path("$work")
assert _rc == 198

* 8d. invalid publicfacing()
capture noisily projectbuilder BadMeta, path("$work") publicfacing(maybe)
assert _rc == 198

* 8e. empty subsource
capture noisily projectbuilder Agency/, path("$work")
assert _rc == 198

di as text ""
di as text "{hline 70}"
di as text "projectbuilder: ALL TESTS PASSED"
di as text "{hline 70}"
