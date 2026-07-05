*==============================================================================*
* ch15_bench.do  --  Chapter 15: three ways to build one variable
* Times three methods to compute x^2 on 1,000,000 simulated rows:
*   (1) vectorized -gen-, (2) a Mata column operation, (3) an explicit
* -forvalues- loop. Uses Stata's -timer- to settle the speed argument.
* Simulated data (set seed 20260704). No key, no external data.
* Globals: none needed. This file writes no files and reads no external
* data, so it runs standalone from any working directory.
*==============================================================================*
clear all
set more off
set seed 20260704

*--- Simulated one-million-row dataset ---------------------------------------*
set obs 1000000
gen double x = runiform()

*--- Method 1: vectorized gen (Stata's native idiom) -------------------------*
timer clear
timer on 1
    gen double y1 = x^2
timer off 1

*--- Method 2: Mata column operation -----------------------------------------*
gen double y2 = .
timer on 2
    mata: st_store(., "y2", st_data(., "x"):^2)
timer off 2

*--- Method 3: explicit observation-by-observation loop (anti-pattern) --------*
gen double y3 = .
timer on 3
    forvalues i = 1/`=_N' {
        replace y3 = x^2 in `i'
    }
timer off 3

*--- Confirm all three produced the identical column -------------------------*
assert reldif(y1, y2) < 1e-12
assert reldif(y1, y3) < 1e-12

*--- Report the timings -------------------------------------------------------*
timer list
di "DONE"
