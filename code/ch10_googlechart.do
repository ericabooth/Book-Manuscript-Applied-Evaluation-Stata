*==============================================================================*
* ch10_googlechart.do  --  Chapter 10: building interactive charts & infographics
*------------------------------------------------------------------------------*
* Six worked googlechart examples on County Health Rankings & Roadmaps (CHR&R)
* 2025 state data. Each command writes ONE self-contained interactive HTML file
* into `OUT'. The four figures printed in the chapter (geo, bubble, table,
* divbar) are pre-rendered PNGs of these exact commands.
*
* WHY THIS RUNS WITH NO KEY AND NO NETWORK:
*   googlechart does not call any web service while Stata runs. It only writes
*   text (HTML + JSON + an inlined JavaScript engine) to a file with -file
*   write-. The Google Charts drawing code is fetched by the *browser* when the
*   page is opened, not by Stata when the page is built. So this whole do-file
*   builds offline: no API key, no credentials, no network at run time. (A
*   viewer does need internet to open the pages, because they load Google's
*   chart library from https://www.gstatic.com at view time.)
*
* SUITE CONTEXT (see the book's suite matrix, Chapter 10 section 10.1):
*   googlechart is the ONLINE chart layer. Its offline sibling is sparkta2
*   (D3, sub-state maps). Data comes in via webapi (Ch.3) or googlesheets
*   (Ch.11); the finished charts get wrapped into one report or portal by
*   statashiny / webdoc2 (Ch.12).
*
* PREREQUISITE (once; public repo, install verified 2026-07-05):
*   net install googlechart, ///
*     from("https://raw.githubusercontent.com/ericabooth/googlechart-stata-public/main/") replace
*
* DATA: two tidied CHR extracts ship in ./data next to this file.
*   chr_states_2025.csv   51 rows (50 states + DC), one row per state, 2025.
*   chr_states_panel.csv  510 rows, 51 states x 10 years (2016-2025), for the
*                         animated bubble. 2024-2025 are the real CHR releases;
*                         2016-2023 are simulated to give the Play control frames.
*==============================================================================*

version 17.0
clear all
set more off

*--- Paths --------------------------------------------------------------------*
* DATA points at the ./data folder shipped with this do-file. OUT is where the
* HTML files land. Edit these two lines if you move the file.
local HERE "`c(pwd)'"
local DATA "`HERE'/data"
local OUT  "`HERE'/googlechart_charts"
capture mkdir "`OUT'"

* Reproducible alternative to the shipped extract: CHR posts the analytic file
* at a stable per-year URL, and -import delimited- reads a URL directly. Keep
* the state-summary rows (5-digit FIPS ending in 000), then rename to match.
*   import delimited using ///
*     "https://www.countyhealthrankings.org/sites/default/files/media/document/analytic_data2025_v3.csv", ///
*     varnames(1) clear


*==============================================================================*
* 1. GEO -- US state choropleth of the uninsured rate
*------------------------------------------------------------------------------*
* The type() that answers "show me my states on a map". name() names the column
* holding the geographic key; for US states googlechart wants a "US-XX" code
* (here geo_code, e.g. US-TX), set by georegion("US") georesolution("us-states").
* NOTE: geo caps at US-state / country level. For TX county or school-district
* choropleths use the offline sibling sparkta2 instead. FIGURE: ch10_gc_geo.png
*==============================================================================*
import delimited using "`DATA'/chr_states_2025.csv", varnames(1) clear

googlechart uninsured, name(geo_code) type(geo)              ///
    georegion("US") georesolution("us-states")              ///
    tx2036style scheme(blues)                               ///
    download datatable downloadpos(below)                   ///
    title("Uninsured rate by state, 2025")                  ///
    note("Source: County Health Rankings & Roadmaps 2025.") ///
    width(960) height(560) noopen                           ///
    export("`OUT'/01_geo_uninsured.html")


*==============================================================================*
* 2. BAR -- the 15 highest-uninsured states, labels drawn on the bars
*------------------------------------------------------------------------------*
* -bar- is the horizontal bar; -column- is vertical. directlabels prints each
* value on its bar. We do NOT add -animate- here: the annotation column that
* directlabels needs is incompatible with the startup animation, and googlechart
* would drop animate with a note anyway. preserve/restore so the sort is local.
*==============================================================================*
preserve
    gsort -uninsured
    keep in 1/15
    googlechart uninsured, name(usps) type(bar)             ///
        directlabels tx2036style                           ///
        download datatable downloadpos(below)              ///
        title("Fifteen states with the highest uninsured rate (2025)") ///
        xlabel("Uninsured (%)")                            ///
        width(900) height(560) noopen                      ///
        export("`OUT'/02_bar_uninsured.html")
restore


*==============================================================================*
* 3. SCATTER -- median income vs premature death, extra columns in the tooltip
*------------------------------------------------------------------------------*
* scatter/bubble take TWO numeric vars (x then y). tooltipvars() adds columns to
* the hover card and the downloadable data table without plotting them. animate
* is fine here (no directlabels). FIGURE: not printed; built for the portal.
*==============================================================================*
import delimited using "`DATA'/chr_states_2025.csv", varnames(1) clear

googlechart median_income premature_death, name(state) type(scatter) ///
    tooltipvars(uninsured child_poverty)                   ///
    tx2036style download datatable downloadpos(below) animate ///
    title("Median income vs premature death (states, 2025)") ///
    xlabel("Median household income (USD)")                ///
    ylabel("Premature death (YPLL per 100,000)")           ///
    width(920) height(560) noopen                          ///
    export("`OUT'/03_scatter_income_ypll.html")


*==============================================================================*
* 4. BUBBLE -- animated across the 2016->2025 panel (Play button via time(year))
*------------------------------------------------------------------------------*
* time(year) adds a Play button and a year slider. It REQUIRES a panel: one row
* per entity (usps) per time value (year), or nothing animates. over() colors
* the bubbles by a group; sizevar() sizes them. FIGURE: ch10_gc_bubble.png
*==============================================================================*
import delimited using "`DATA'/chr_states_panel.csv", varnames(1) clear

gen byte highunins = uninsured >= 10
label define hu 0 "Uninsured < 10%" 1 "Uninsured >= 10%"
label values highunins hu
label variable child_poverty   "Children in poverty (%)"
label variable premature_death "Premature death (YPLL/100k)"

googlechart child_poverty premature_death, name(usps) over(highunins) ///
    sizevar(pct_rural) time(year) type(bubble)             ///
    tooltipvars(uninsured)                                 ///
    tx2036style download datatable downloadpos(below)      ///
    title("Child poverty vs premature death (press Play: 2016 to 2025)") ///
    note("2024-2025 actual CHR releases; 2016-2023 simulated to demo Play.") ///
    xlabel("Children in poverty (%)")                      ///
    ylabel("Premature death (YPLL per 100,000)")           ///
    width(920) height(560) noopen                          ///
    export("`OUT'/04_bubble.html")


*==============================================================================*
* 5. TABLE -- searchable, sticky-header table of every state measure
*------------------------------------------------------------------------------*
* type(table) usually takes NO varlist: the columns come from tooltipvars().
* tablesearch adds the search box; tableheadersticky freezes the header row on
* scroll. The reader types their state and finds their own row. FIGURE:
* ch10_gc_table.png
*==============================================================================*
import delimited using "`DATA'/chr_states_2025.csv", varnames(1) clear

googlechart, type(table)                                   ///
    tooltipvars(state uninsured median_income              ///
                premature_death obesity child_poverty      ///
                unemployment pct_rural)                    ///
    tablesearch tableheadersticky                          ///
    tx2036style download datatable downloadpos(below)      ///
    title("2025 County Health Rankings: state measures (searchable)") ///
    width(980) height(460) noopen                          ///
    export("`OUT'/05_table.html")


*==============================================================================*
* 6. DIVBAR -- Pew-style diverging stacked bar (illustrative Likert data)
*------------------------------------------------------------------------------*
* divbar needs name() (the item) + level() (the Likert response). levelorder()
* fixes the stack order; centerlevel() centers a neutral level on zero and
* sign-flips the disagree side to the left. Data here is synthetic, for shape.
* FIGURE: ch10_gc_divbar.png
*==============================================================================*
preserve
clear
input str90 q str18 response byte share
"Texas is on the right track investing in K-12 education" "Strongly disagree" 18
"Texas is on the right track investing in K-12 education" "Disagree"          20
"Texas is on the right track investing in K-12 education" "Neutral"           14
"Texas is on the right track investing in K-12 education" "Agree"             34
"Texas is on the right track investing in K-12 education" "Strongly agree"    14
"Higher education is affordable for most Texas families"  "Strongly disagree" 33
"Higher education is affordable for most Texas families"  "Disagree"          31
"Higher education is affordable for most Texas families"  "Neutral"           16
"Higher education is affordable for most Texas families"  "Agree"             15
"Higher education is affordable for most Texas families"  "Strongly agree"     5
"Texas is prepared for its 20-year water-supply needs"    "Strongly disagree" 22
"Texas is prepared for its 20-year water-supply needs"    "Disagree"          26
"Texas is prepared for its 20-year water-supply needs"    "Neutral"           20
"Texas is prepared for its 20-year water-supply needs"    "Agree"             26
"Texas is prepared for its 20-year water-supply needs"    "Strongly agree"     6
end

googlechart share, name(q) level(response) type(divbar)    ///
    levelorder("Strongly disagree|Disagree|Neutral|Agree|Strongly agree") ///
    centerlevel(Neutral)                                   ///
    tx2036style download datatable downloadpos(below)      ///
    title("Texans on state policy (illustrative survey data)") ///
    subtitle("Diverging stacked bar; neutral centered on zero") ///
    width(1040) height(420) noopen                         ///
    export("`OUT'/06_divbar.html")
restore


*==============================================================================*
* 7. Confirm the six HTML files landed
*------------------------------------------------------------------------------*
foreach f in 01_geo_uninsured 02_bar_uninsured 03_scatter_income_ypll ///
             04_bubble 05_table 06_divbar {
    capture confirm file "`OUT'/`f'.html"
    if _rc di as error "MISSING: `f'.html"
    else   di as text  "OK: `f'.html"
}
di "DONE"

*------------------------------------------------------------------------------*
* WHERE THESE GO NEXT (the suite pipeline):
*   - Ch.11 (googlesheets): pull the CHR feed live from a shared Google Sheet
*     instead of the shipped CSV, or push the ranked table back to a sheet.
*   - Ch.12 (statashiny / webdoc2): wrap these six HTML files into ONE offline
*     report or GitHub-Pages portal with wdiframe / an iframe, so a reader
*     clicks between the geo map, the bubble, and the searchable table in a
*     single branded page.
*==============================================================================*
