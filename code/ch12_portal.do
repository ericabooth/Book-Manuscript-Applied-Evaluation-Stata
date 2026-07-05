*==============================================================================*
* ch12_portal.do  --  Chapter 12: publishing self-contained reports & portals
* Applied Program Evaluation Using Stata  (Booth & Teas)
*
* WHAT THIS FILE IS
*   The suite CAPSTONE: "one evaluation, one folder." It sketches the whole
*   toolkit end to end -- data in (webapi / googlesheets) -> charts
*   (googlechart online, sparkta2 offline) -> an interactive dashboard
*   (statashiny) -> a Bootstrap-5 report shell (webdoc2) that wraps them all
*   into a single index.html the client can open offline.
*
*   Most of this file is DISPLAY-ONLY. statashiny, webdoc2, and sparkta2 need
*   packages (and sometimes OAuth) that are not assumed installed here, so those
*   blocks are wrapped in `if 0 { ... }' and clearly commented. What DOES run
*   with no packages and no network is the folder-scaffolding section at the
*   bottom: it builds the portal skeleton and a stamped README so you can see
*   the shape of the deliverable before the tools fill it in.
*
* HOW TO USE
*   Read top to bottom for the pipeline. To scaffold a real portal folder,
*   run only the SCAFFOLD section (it is guarded so nothing else fires).
*==============================================================================*

clear all
version 18
set more off
set linesize 90

*--- Paths (globals normally live in code/00_control.do; set here to run alone)*
global root    "`c(pwd)'"
global portal  "$root/site-portal"           // the one folder the client owns
global charts  "$portal/charts"              // statashiny/googlechart HTML
global data    "$portal/data"                // inlined json the charts read
capture mkdir "$portal"
capture mkdir "$charts"
capture mkdir "$data"

*--- Version stamp: set ONCE per delivery, reused by every artifact below -----*
global version "v1.3"                         // bump per delivery (see Sec. versioning)


********************************************************************************
* PART A -- statashiny: an interactive dashboard with no server (DISPLAY-ONLY)
*   Workflow is always three moves: init -> add elements -> build.
*   Each element is keyed by an ID; `output()' places a widget, `input()'
*   places a control. `build export()' writes one self-contained .html.
*   Needs the statashiny package (Ch12); shown display-only.
*   Live example: https://ericabooth.github.io/StataShiny_Example_Site/
********************************************************************************
if 0 {   // DISPLAY-ONLY: requires -statashiny-

    * --- minimal example (verbatim from the package README) ---
    sysuse auto, clear
    collapse (mean) price mpg weight length (count) n=price, by(foreign)

    statashiny, title("Auto Summary Table") replace     // 1. init the dashboard
    statashiny autotab, output(table) ///                // 2. add a searchable table
        label("Descriptives by Origin")
    statashiny, build export("dashboard.html") open      // 3. build the html

    * --- richer version: value cards + a live slider (drill-down) ---
    sysuse auto, clear
    collapse (mean) price mpg (count) n=price, by(foreign)

    statashiny, title("Auto Outcomes") replace           // init
    * value cards: one headline number each
    statashiny meanprice, output(val) ///
        label("Mean price") prefix("$")
    statashiny meanmpg,   output(val) ///
        label("Mean mpg")
    * a searchable table of the rows
    statashiny tbl, output(table) ///
        label("Means by origin")
    * a slider the reader drags to filter live, in the browser
    statashiny mpgcut, input(num) ///
        val(20) min(10) max(40) step(1)
    statashiny, build ///                                 // build one .html
        export("$charts/dashboard.html") open

}   // end DISPLAY-ONLY statashiny


********************************************************************************
* PART B -- webdoc2: a Bootstrap-5 report shell (DISPLAY-ONLY)
*   webdoc2 wraps Ben Jann's -webdoc-. wdinit opens (and injects the BS5
*   header), wputh1/wput write narrative, wd...wdclose logs a code block,
*   button...buttonclose makes a collapsible one, and `webdoc close' writes
*   the html. wdimg / wdiframe are the load-bearing embed commands: they
*   pull the charts and dashboards above into ONE page.
*   Needs the webdoc2 package (Ch12); shown display-only.
*   Live example: https://ericabooth.github.io/Webdoc2_Example_Site/
********************************************************************************
if 0 {   // DISPLAY-ONLY: requires -webdoc2- (and -webdoc-)

    * --- quickstart (verbatim from the package README) ---
    wdinit quickstart, replace
    wputh1 Quickstart
    wput   This page was generated from a ///
           20-line Stata do-file by webdoc2.
    wputh2 Run a regression and show it inline
    wd
    sysuse auto, clear
    regress price mpg weight
    wdclose
    wputh2 Same regression, collapsed by default
    button
    sysuse auto, clear
    regress price mpg weight foreign
    buttonclose
    webdoc close

    * --- the embed commands that wrap the suite into one page ---
    * wdimg embeds a static image (a sparkta2 SVG/PNG map);
    * wdiframe embeds a whole interactive html (the statashiny
    * dashboard or a googlechart page) inside a framed panel.
    wdinit "$portal/report", replace
    wputh1 Q3 Site Outcomes
    wput   Enrollment and completion, rebuilt ///
           from the analysis file.
    wdimg  "$charts/county_map.png", ///
        caption("Completion by county (offline map)")
    wdiframe "charts/dashboard.html", height(640)
    webdoc close

}   // end DISPLAY-ONLY webdoc2


********************************************************************************
* PART C -- THE CAPSTONE: one evaluation, one folder (DISPLAY-ONLY sketch)
*   The whole suite in sequence. Each step names the chapter that teaches it.
*   Guarded because it needs webapi/googlesheets/googlechart/sparkta2/
*   statashiny/webdoc2 all installed and (for the live ones) network + OAuth.
********************************************************************************
if 0 {   // DISPLAY-ONLY: full-suite orchestration

    * --- 1. INGEST: pull the data (Ch3 webapi, or Ch11 googlesheets) --------*
    * public JSON in one line, no key:
    webapi get using ///
        "https://data.cdc.gov/resource/bi63-dtpu.json", ///
        params("year=2017|cause_name=All causes") clear
    * ...or a live team sheet (Ch11), needs OAuth (Appendix A):
    * googlesheets import using "$SS", ///
    *     sheet("CHR states 2025") firstrow clear

    * --- 2a. CHART, ONLINE: googlechart interactive page (Ch10) -------------*
    googlechart uninsured, name(geo_code) type(geo) ///
        georegion("US") georesolution("us-states") ///
        tx2036style scheme(blues) download datatable ///
        title("Uninsured rate by state, 2025") ///
        width(960) height(560) noopen ///
        export("$charts/geo_uninsured.html")

    * --- 2b. CHART, OFFLINE: sparkta2 sub-state map (Ch10) ------------------*
    * sparkta2 draws county / school-district choropleths that GeoChart
    * cannot; it renders offline (D3 bundled inline). Source forthcoming,
    * so this line is a sketch of the intended call:
    * sparkta2 completed, name(county) type(choropleth) ///
    *     geo(tx-counties) tx2036style ///
    *     export("$charts/county_map.html")

    * --- 3. INTERACTIVE: statashiny drill-down dashboard (Ch12) -------------*
    statashiny, title("Site Outcomes") replace
    statashiny cards, output(val) label("Completion") suffix("%")
    statashiny tbl,   output(table) label("By site")
    statashiny cut,   input(num) val(50) min(0) max(100) step(5)
    statashiny, build export("$charts/dashboard.html")

    * --- 4. WRAP: webdoc2 assembles narrative + embeds into index.html ------*
    wdinit "$portal/index", replace
    wdnavbar "Site Evaluation Portal"
    wdnavitem "Report", href("#report")
    wdnavitem "Dashboard", href("#dash")
    wdnavbarclose
    wdtoc "Contents", depth(2)
    wputh1 Q3 Site Outcomes
    wput   Rebuilt from the analysis file on $S_DATE.
    wputh2 Interactive dashboard
    wdiframe "charts/dashboard.html", height(640)
    wputh2 Uninsured by state
    wdiframe "charts/geo_uninsured.html", height(600)
    wputh2 Completion by county (offline map)
    wdimg  "charts/county_map.png", ///
        caption("Offline county choropleth")
    * stamp the footer at BUILD time so it cannot drift (Sec. versioning):
    wput ---
    wput Version $version, built $S_DATE.
    wput Rebuild: git checkout $version, then run ///
         ch12_portal.do.
    webdoc close

    * --- 5. (optional) PUBLISH to GitHub Pages ------------------------------*
    * The folder is already a website. To give the client a link, push
    * $portal to a repo and enable Pages (both example sites host this way):
    *   cd "$portal"
    *   git init && git add . && git commit -m "portal $version"
    *   git branch -M main
    *   git remote add origin <repo-url>
    *   git push -u origin main
    * then turn on Pages in the repo settings. Nothing here needs a server.

}   // end DISPLAY-ONLY capstone


********************************************************************************
* PART D -- SCAFFOLD (TESTABLE: no packages, no network)
*   Builds the empty portal skeleton and a stamped README + landing page, so
*   the folder's shape exists before the tools above fill it. This is the only
*   part that actually runs.
********************************************************************************

* stamp the folder name with the delivery version (Sec. versioning):
local stamped "$root/site-portal-$version"
capture mkdir "`stamped'"
capture mkdir "`stamped'/charts"
capture mkdir "`stamped'/data"

* a minimal landing page carrying the visible version-and-date stamp:
tempname idx
file open `idx' using "`stamped'/index.html", write replace
file write `idx' "<!doctype html><html><head>" _n
file write `idx' "<meta charset='utf-8'>" _n
file write `idx' "<title>Site Evaluation Portal</title>" _n
file write `idx' "</head><body>" _n
file write `idx' "<h1>Site Evaluation Portal</h1>" _n
file write `idx' "<p>Version $version, built $S_DATE.</p>" _n
file write `idx' "<ul>" _n
file write `idx' "<li><a href='report.html'>Narrative report</a></li>" _n
file write `idx' "<li><a href='charts/dashboard.html'>Dashboard</a></li>" _n
file write `idx' "</ul>" _n
file write `idx' "</body></html>" _n
file close `idx'

* a README that records the rebuild instruction (the auditor's stamp):
tempname rd
file open `rd' using "`stamped'/README.md", write replace
file write `rd' "# Site Evaluation Portal ($version)" _n _n
file write `rd' "Built $S_DATE from ch12_portal.do." _n _n
file write `rd' "Rebuild: git checkout $version, then run" _n
file write `rd' "ch12_portal.do end to end." _n
file close `rd'

display as text "Scaffolded portal at: `stamped'"
display as text "Open index.html in any browser -- no server needed."

* end of ch12_portal.do
