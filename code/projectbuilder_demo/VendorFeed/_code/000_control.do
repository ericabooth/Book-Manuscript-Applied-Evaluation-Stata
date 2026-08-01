*===============================================================
* 000_control.do -- VendorFeed
* Created 2026-07-31 by ebooth (scaffolded by projectbuilder v2.0.1)
* Last built 2026-07-31
* Monthly vendor extract; agency emails the file
* The control file: every path in one place.
*===============================================================

clear all
version 16.0      // projectbuilder's floor; raise if you need newer syntax
set more off
set varabbrev off    // abbreviations hide bugs

*---------------------------------------------------------------
* >>> THE ONE PLACE YOU EDIT: the project root. <<<
* projectbuilder stamped the absolute path it scaffolded below.
* If this project ever MOVES -- new machine, new teammate, new
* drive -- edit ONLY the global root line, then rerun this file.
*---------------------------------------------------------------
global root "/Users/ebooth/Documents/GitHub/Book Manuscript:Applied Evaluation-Stata/code/projectbuilder_demo/VendorFeed"

* Derived from root; you should not need to touch these.
global raw       "$root/01_raw"            // untouched source files
global converted "$root/01_raw/_converted" // raw -> .dta, one per file
global cleaned   "$root/02_cleaned"        // the analytic file(s)
global output    "$root/03_output"         // logs, tables, exhibits
global code      "$root/_code"             // the do-files
global docs      "$root/_documentation"    // the documentation site
foreach d in raw converted cleaned output code docs {
    capture mkdir "${`d'}"     // safe to rerun
}

* set scheme stcolor    // uncomment to pin one graphics style

*---------------------------------------------------------------
* Optional: run the whole numbered pipeline, in order.
*---------------------------------------------------------------
local run_all 0    // flip to 1 to run every numbered step
if `run_all' {
    do "$code/100_data_download.do"
    do "$code/200_data_management.do"
    do "$code/300_labels.do"
    do "$code/400_data_profiler.do"
    do "$code/500_aggregation.do"
    do "$code/600_analysis.do"
}
