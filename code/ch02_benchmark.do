*==============================================================================*
* ch02_benchmark.do  --  Chapter 2: a speed benchmark you can rerun
* Expands nlsw88 to ~2 million rows, then times native collapse vs
* gtools gcollapse, and native egen vs gegen, at two group counts
* (24 groups and 200,000 groups), 5 runs each, with Stata's timers.
* Also demonstrates the chapter's dated-log discipline.
* Timings in the book: Apple-silicon Mac (M1 Max), Stata MP batch.
*==============================================================================*
* Standalone globals. In the full project these come from 00_control.do;
* they are defined locally here so the file runs on its own.
global root "`c(pwd)'"
global raw     "$root/raw"
global clean   "$root/clean"
global output  "$root/output"
global figures "$root/figures"
foreach f in raw clean output figures {
    capture mkdir "${`f'}"
}

version 18
clear all
set more off
set varabbrev off
set seed 20260704

*--- The dated log: one pattern that makes every run auditable ----------------*
local today : di %tdCYND daily("`c(current_date)'", "DMY")
capture log close bench
log using "$output/ch02_benchmark_`today'.log", name(bench) replace text

*--- Build a 2-million-row file from a shipped dataset ------------------------*
sysuse nlsw88, clear
expand 891                       // 2,246 x 891 = 2,001,186 rows
gen long gid = mod(_n, 200000)   // a 200,000-group identifier
di as txt "Rows in memory: " as res %12.0fc _N

*--- Benchmarks 1-2: collapse vs gcollapse at 24 and 200k groups ---------------*
* preserve/restore sits OUTSIDE the timers, so we time only the command.
timer clear
forvalues i = 1/5 {
    preserve
    timer on 1
    collapse (mean) wage hours, by(industry union)
    timer off 1
    restore

    preserve
    timer on 2
    gcollapse (mean) wage hours, by(industry union)
    timer off 2
    restore

    preserve
    timer on 3
    collapse (mean) wage hours, by(gid)
    timer off 3
    restore

    preserve
    timer on 4
    gcollapse (mean) wage hours, by(gid)
    timer off 4
    restore
}

*--- Benchmarks 3-4: egen vs gegen, group means back onto the rows -------------*
forvalues i = 1/5 {
    timer on 5
    egen m24_`i' = mean(wage), by(industry union)
    timer off 5

    timer on 6
    gegen g24_`i' = mean(wage), by(industry union)
    timer off 6

    timer on 7
    egen m2k_`i' = mean(wage), by(gid)
    timer off 7

    timer on 8
    gegen g2k_`i' = mean(wage), by(gid)
    timer off 8

    assert abs(m24_`i' - g24_`i') < 1e-6   // same answer, or no deal
    assert abs(m2k_`i' - g2k_`i') < 1e-6
    drop m24_`i' g24_`i' m2k_`i' g2k_`i'
}

*--- Report means per run and speedups ----------------------------------------*
timer list
quietly timer list
forvalues t = 1/8 {
    local t`t' = r(t`t')/5
}
di as txt "collapse  24 grp   native vs gtools: " ///
    as res %5.2f `t1' " vs " %5.2f `t2' "  (x" %4.1f `t1'/`t2' ")"
di as txt "collapse  200k grp native vs gtools: " ///
    as res %5.2f `t3' " vs " %5.2f `t4' "  (x" %4.1f `t3'/`t4' ")"
di as txt "egen mean 24 grp   native vs gtools: " ///
    as res %5.2f `t5' " vs " %5.2f `t6' "  (x" %4.1f `t5'/`t6' ")"
di as txt "egen mean 200k grp native vs gtools: " ///
    as res %5.2f `t7' " vs " %5.2f `t8' "  (x" %4.1f `t7'/`t8' ")"

*--- The payoff figure: seconds per run, native vs gtools ----------------------*
preserve
clear
set obs 8
gen byte eng  = 1 + mod(_n+1, 2)      // odd rows native, even gtools
gen byte task = ceil(_n/2)
gen sec = .
forvalues r = 1/8 {
    replace sec = `t`r'' in `r'
}
label define eng 1 "native" 2 "gtools"
label values eng eng
label define task 1 "collapse, 24 groups"       ///
                  2 "collapse, 200,000 groups"  ///
                  3 "egen mean, 24 groups"      ///
                  4 "egen mean, 200,000 groups"
label values task task

graph hbar (asis) sec, ///
    over(eng, label(labsize(small))) ///
    over(task, label(labsize(small))) asyvars ///
    bar(1, color(navy)) bar(2, color(maroon)) ///
    blabel(bar, format(%9.2f) size(small)) ///
    legend(rows(1) size(small) region(lstyle(none))) ///
    ytitle("Seconds per run (mean of 5)", size(small)) ///
    title("Native vs. gtools on 2 million rows", size(medium)) ///
    note("sysuse nlsw88 expanded to 2,001,186 rows; group means of wage and hours." ///
         " Apple M1 Max, Stata MP batch.", size(vsmall)) ///
    graphregion(margin(l=2 r=6)) ysize(4.2) xsize(7.2)
graph export "$figures/ch02_benchmark.png", replace width(2400)
di "FIGURE_SAVED"
restore

log close bench
di "DONE"
