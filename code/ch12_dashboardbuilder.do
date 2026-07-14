*==============================================================================*
* ch12_dashboardbuilder.do  --  Chapter 12: the dashboard you rebuild
*------------------------------------------------------------------------------*
* Two worked dashboardbuilder examples, both on datasets that ship with Stata.
* Each -build- writes ONE self-contained interactive HTML file into `OUT'.
* The two dashboard figures printed in Chapter 12 are screenshots of these
* exact pages.
*
* WHY THIS BUILDS OFFLINE AND OPENS OFFLINE:
*   dashboardbuilder writes plain HTML with the data inlined as JSON and the
*   charts drawn by a small vanilla-JavaScript/SVG engine embedded in the same
*   file. No CDN, no external library, no network at build time or view time.
*   (One opt-in exception: the -truepdf- build option adds a one-click PDF
*   button that pulls a JS library from a CDN at view time; we do not use it
*   here, and the build receipt says so whenever you do.)
*
* SUITE CONTEXT (see the book's suite matrix, Chapter 10 section 10.1):
*   dashboardbuilder is an OFFLINE CONTAINER, the KPI-and-benchmark sibling of
*   statashiny (explore-the-rows dashboards). Data comes in via webapi (Ch.3)
*   or googlesheets (Ch.11); webdoc2 (Ch.12) can embed the finished page in a
*   portal with one wdiframe line.
*
* PREREQUISITE (once; public repo, install verified 2026-07-14):
*   net install dashboardbuilder, ///
*     from("https://raw.githubusercontent.com/ericabooth/dashboardbuilder-stata-public/main/") replace
*   Requires Stata 16+ and a Python 3 visible to Stata (standard library only).
*
* Adapted from the package's own example_dashboardbuilder.do (Eric A. Booth),
* with the reference-row aggregation corrected to (rawsum); see the tripwire
* note at dashboard 2.
*==============================================================================*
version 16
clear all
set more off

* All outputs land here, next to this do-file
local OUT "dashboards"
capture mkdir "`OUT'"

* ============================================================================
* DASHBOARD 1 -- the two-minute build: init -> panel -> panel -> build
* ============================================================================
sysuse auto, clear
collapse (mean) price mpg weight, by(foreign)

dashboardbuilder init , title("Auto quick look") ///
    subtitle("mean price, mileage, and weight by origin (1978 autos)")
dashboardbuilder panel bar , x(foreign) y(price) ///
    title("Domestic cars cost less on average") ytitle("mean price (USD)")
dashboardbuilder panel table , title("The numbers behind the chart")
dashboardbuilder build using "`OUT'/auto_quick.html", replace

* r() is the build receipt: file, bytes, panel count
di as txt "built: " as res r(file) as txt " (" as res r(bytes) as txt " bytes)"
local bytes1 = r(bytes)
capture confirm file "`OUT'/auto_quick.html"
assert _rc == 0
assert `bytes1' > 20000

* ============================================================================
* DASHBOARD 2 -- the benchmark explorer: selector + reference unit + tabs
* ============================================================================
sysuse census, clear

* rates per 1,000 residents so the compare panel's rows share one scale
gen double death_rt = 1000 * death    / pop
gen double marr_rt  = 1000 * marriage / pop
gen double div_rt   = 1000 * divorce  / pop
label var pop      "Population"
label var medage   "Median age (years)"
label var death_rt "Deaths per 1,000"
label var marr_rt  "Marriages per 1,000"
label var div_rt   "Divorces per 1,000"

* Build the reference row: a synthetic United States aggregate.
* TRIPWIRE -- (rawsum), not (sum). With aweights, collapse rescales every
* (sum) to N x the weighted mean: (sum) pop [aw=pop] returns 467,012,262,
* not the true 1980 total of 225,907,472. (rawsum) leaves the totals
* unweighted while medage stays population-weighted, which is what a
* reference row needs. The asserts below caught this while we built the
* chapter figure.
preserve
    collapse (rawsum) pop death marriage divorce (mean) medage [aw=pop]
    assert pop == 225907472              // 1980 US total in sysuse census
    assert abs(medage   - 30.1) < .05    // population-weighted median age
    gen double death_rt = 1000 * death    / pop
    gen double marr_rt  = 1000 * marriage / pop
    gen double div_rt   = 1000 * divorce  / pop
    assert abs(death_rt -  8.7) < .05    // 1980 US crude death rate
    * (tolerance form, not round()==x: rounded doubles rarely compare exactly)
    gen str28 state = "United States"
    tempfile us
    save `us'
restore
append using `us'
tempfile censusplus
save `censusplus'

dashboardbuilder init , title("State explorer") ///
    subtitle("every state against the national picture (1980 census)") ///
    selector(state) sellabel("Choose a state") refvalue("United States")

dashboardbuilder tab , name(today) label("Where states stand")
dashboardbuilder tab , name(rank)  label("Rankings")

* KPI tiles: one row per unit, so the collapse is already done
use `censusplus', clear
keep state pop medage death_rt
dashboardbuilder panel kpi , tab(today) values(pop medage death_rt) ///
    title("Headline numbers") ///
    interp("Pick a state above; tiles and bars update. 'United States' is the reference.")

* compare bullet bars: metrics long; the US row draws the | reference markers
use `censusplus', clear
keep state death_rt marr_rt div_rt
rename (death_rt marr_rt div_rt) (v1 v2 v3)
reshape long v, i(state) j(metric)
label define metric 1 "Deaths per 1,000" 2 "Marriages per 1,000" 3 "Divorces per 1,000"
label values metric metric
dashboardbuilder panel compare , tab(today) x(metric) y(v) ///
    title("Vital rates vs. the United States") ///
    note("Bar = selected state; | marker = United States. Rates share one scale.") ///
    ytitle("per 1,000 residents")

* a STATIC ranking: rename the selector column so this panel does NOT filter
use `censusplus', clear
drop if state == "United States"
gsort -medage
keep in 1/10
rename state stname
dashboardbuilder panel hbar , tab(rank) x(stname) y(medage) ///
    title("Ten oldest states by median age") ytitle("median age (years)")

* full data table on the rankings tab (filterable again)
use `censusplus', clear
keep state region pop medage death_rt marr_rt div_rt
dashboardbuilder panel table , tab(rank) title("Every state, every metric")

dashboardbuilder describe        // show the registered plan before building

* -pdf- adds the offline Save-as-PDF button; we skip -truepdf- (CDN at view
* time) so the page stays fully self-contained.
dashboardbuilder build using "`OUT'/state_explorer.html", replace pdf ///
    callout("A teaching example on 1980 census extracts; the point is the layout, not the vintage.") ///
    sourcenote("Source: sysuse census (1980 US census extract shipped with Stata).")

di as txt "built: " as res r(file) as txt " (" as res r(bytes) as txt " bytes)"
local bytes2 = r(bytes)
capture confirm file "`OUT'/state_explorer.html"
assert _rc == 0
assert `bytes2' > 30000

di as txt _n "ch12_dashboardbuilder.do complete: 2 dashboards in ./`OUT'/"
