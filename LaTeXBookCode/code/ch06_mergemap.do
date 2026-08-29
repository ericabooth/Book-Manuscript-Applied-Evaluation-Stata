* ch06_mergemap.do -- where did the rows go?
* A roster of 2,400 programme participants becomes a 1,293-row estimation
* sample.  The earnings merge gets the blame; the earnings merge matched 97
* percent.  -mergemap- reads the build and says which step actually did it.
* Requires: mergemap (author's GitHub / SSC).
clear all
set varabbrev off
version 16.0

* c(tmpdir) ends with a separator on macOS, so joining a name to it makes a
* doubled slash that some path handling downstream does not survive.  Trim it.
local tmp "`c(tmpdir)'"
if inlist(substr("`tmp'", -1, 1), "/", "\") local tmp = substr("`tmp'", 1, strlen("`tmp'") - 1)
local work "`tmp'/ch06_mergemap"
capture mkdir "`work'"
cd "`work'"
foreach d in raw build {
    capture mkdir "`d'"
}

* ---- the three raw files a workforce programme hands you -------------------
set seed 20260829
quietly {
    * enrollment roster: one row per participant
    set obs 2400
    generate long  pid    = 700000 + _n
    generate str5  county = string(48000 + 1 + 2*int(254*runiform()), "%05.0f")
    generate int   cohort = 2022 + int(3*runiform())
    save raw/roster.dta, replace

    * quarterly wage records: several rows per participant, some blank
    clear
    set obs 9100
    generate long  pid = 700000 + 1 + int(2400*runiform())
    generate int   qtr = 1 + int(4*runiform())
    generate float earnings = round(exp(rnormal(8.6, .6)), 1)
    replace earnings = . if runiform() < 0.07
    save raw/wages.dta, replace

    * county lookup: covers 210 counties, and Texas has 254
    clear
    set obs 210
    generate str5 county = string(48000 + 1 + 2*_n, "%05.0f")
    generate byte rural  = runiform() < 0.45
    save raw/county_key.dta, replace
}

* ---- the build, as three numbered do-files ---------------------------------
tempname fh
file open `fh' using "build/10_stack.do", write text replace
file write `fh' "* 10_stack.do -- one row per participant" _n ///
    `"use "raw/wages.dta", clear"' _n ///
    "drop if missing(earnings)" _n ///
    "collapse (sum) earnings, by(pid)" _n ///
    `"save "build/annual_earnings.dta", replace"' _n
file close `fh'

file open `fh' using "build/20_link.do", write text replace
file write `fh' "* 20_link.do -- attach earnings and county traits" _n ///
    `"use "raw/roster.dta", clear"' _n ///
    `"merge 1:1 pid using "build/annual_earnings.dta", keep(1 3) nogenerate"' _n ///
    `"merge m:1 county using "raw/county_key.dta", keep(match) nogenerate"' _n ///
    `"save "build/analysis.dta", replace"' _n
file close `fh'

file open `fh' using "build/30_analyze.do", write text replace
file write `fh' "* 30_analyze.do -- the estimation sample" _n ///
    `"use "build/analysis.dta", clear"' _n ///
    "drop if missing(earnings)" _n ///
    "keep if cohort >= 2023" _n ///
    `"save "build/estimation.dta", replace"' _n
file close `fh'

* ---- 1. scan: read the build without running it ----------------------------
* Nothing is executed.  This works on a project you have just inherited,
* on code that will not currently run, and on data you do not have.
mergemap build/
assert r(N_events) == 12

* ---- 2. run: the same build, instrumented ----------------------------------
* The wrappers call the real commands and pass your options through, so the
* saved datasets come out identical.  What you gain is the counts.
mergemap run build/

* the arithmetic the run establishes, as assertions
use build/estimation.dta, clear
assert _N == 1293
use build/analysis.dta, clear
assert _N == 1967          // 2,400 roster rows, less 433 the county merge cut

* ---- 3. the map ------------------------------------------------------------
* horizontal wraps into rows of boxes and fits a page across; the default
* vertical layout runs down one, which suits a screen better than a page.
* The if is evaluated on the journal's own columns.  Drawing one do-file
* keeps the boxes large enough to read on a printed page; the receipt and
* the journal still hold all twelve events.
mergemap draw journal.tsv if dofile == "20_link.do", export(png) ///
    layout(horizontal) paths(base) saving("ch06_mergemap_flow") replace

* one join, drawn as two toy tables and the rows it pairs.  Name the journal:
* -detail- falls back on the last one, and the run above moved that on.
mergemap detail 7 journal.tsv, draw

di as res "ch06_mergemap.do: ALL CHECKS PASSED"
