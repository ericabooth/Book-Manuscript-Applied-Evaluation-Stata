*==============================================================================*
* 00_control.do  --  Master control file
* Applied Program Evaluation Using Stata  (Booth & Teas)
*
* WHY THIS FILE EXISTS
*   One place to set every path and preference for the whole project. Change the
*   root once, here, and every downstream do-file follows. Flip run_all to 1 to
*   rebuild the project end to end, in order, from raw download to final figure.
*
* HOW TO USE
*   1. Edit the single global "root" below to point at this project folder.
*   2. Run this file once at the start of a session to load the paths, OR
*   3. Set run_all to 1 to run every chapter do-file in order.
*==============================================================================*

clear all
version 18                     // pin the language version so code behaves the same next year
set more off                   // never pause for -more-
set varabbrev off              // abbreviations invite silent errors; require full names
set linesize 90

*--- 1. THE ONE PLACE YOU EDIT: the project root -----------------------------*
global root "REPLACE/WITH/YOUR/PATH"     // <-- EDIT THIS ONE LINE

*--- 2. Standard subfolders (derived from root; leave these alone) ------------*
global raw     "$root/raw"        // untouched downloads live here
global clean   "$root/clean"      // analysis-ready datasets
global code    "$root/code"       // the do-files (this folder)
global output  "$root/output"     // logs and tables
global figures "$root/figures"    // exported graphs

* Create any missing folder (safe to run every time).
foreach f in raw clean output figures {
    capture mkdir "${`f'}"
}

*--- 3. Project-wide preferences ----------------------------------------------*
set scheme s2color                 // a clean default; swap for your house scheme

*--- 4. Optional: run the whole pipeline, in order ----------------------------*
* Leave at 0 to just load these globals. Flip to 1 to rebuild everything.
local run_all 0     // flip to 1 to rebuild everything
if `run_all' {
    do "$code/01_install.do"
    do "$code/ch01_reach.do"
    do "$code/ch02_benchmark.do"
    * ch02_projectbuilder.do scaffolds real folders; run it on its own:
    * do "$code/ch02_projectbuilder.do"
    do "$code/20_ch03_apis.do"
    do "$code/ch03_webapi.do"
    do "$code/ch03_educationdata.do"
    do "$code/ch04_chr.do"
    do "$code/ch05_monitoring.do"
    do "$code/ch06_longitudinal.do"
    do "$code/ch07_trust.do"
    do "$code/ch08_did.do"
    do "$code/ch08_oaxaca.do"
    do "$code/ch09_graphs.do"
    do "$code/ch10_smallmult.do"
    do "$code/ch10_googlechart.do"
    do "$code/ch11_tables.do"
    do "$code/ch11_googlesheets.do"
    do "$code/ch12_portal.do"
    do "$code/ch13_backbone.do"
    do "$code/ch13_parallel.do"
    do "$code/ch13_validation.do"
    do "$code/ch14_kanon.do"
    do "$code/ch15_bench.do"
}
