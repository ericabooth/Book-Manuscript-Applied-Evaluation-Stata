*==============================================================================*
* ch13_parallel.do  --  Chapter 13: going parallel, the backbone way
* Two patterns, each keeping every worker a logged, reproducible batch job.
*
* PATTERN 1 (below): split a slow bootstrap across instances.
*   True parallel launch from the shell (4 instances at once):
*     for t in 1 2 3 4; do
*       stata-mp -b do boot_worker.do $t 250 $((1000+t)) &
*     done; wait
*   This file runs the same split SEQUENTIALLY so it works standalone;
*   the result is identical, only slower.
*
* PATTERN 2: fan out code review. A shell harness that runs every step in
*   parallel and judges each by its LOG (batch Stata exits 0 even on error):
*     for f in *.do; do stata-mp -b do "$f" >/dev/null 2>&1 & done; wait
*     for f in *.do; do log=${f%.do}.log
*       grep -qE '^r\([0-9]+\);' "$log" && echo "FAIL $f" || echo "pass $f"
*     done
*==============================================================================*
version 18
clear all
global root "`c(pwd)'"
tempfile combined
local first 1

* --- the "worker": one chunk of a bootstrap of the tenure coefficient --------*
capture program drop bootchunk
program define bootchunk
    args tag reps seed
    set seed `seed'
    sysuse nlsw88, clear
    postfile buf double b using "boot_`tag'.dta", replace
    forvalues r = 1/`reps' {
        preserve
            bsample
            quietly regress wage tenure grade age
            post buf (_b[tenure])
        restore
    }
    postclose buf
end

* --- run four chunks (parallel in production; sequential here) ----------------*
forvalues t = 1/4 {
    bootchunk `t' 250 `=1000+`t''
}

* --- combine: stack the four files, read off SE and 95% CI -------------------*
clear
forvalues t = 1/4 {
    append using "boot_`t'.dta"
}
summarize b
local se = r(sd)
_pctile b, p(2.5 97.5)
di as result "reps=" _N "  SE=" %5.3f `se' ///
    "  95%CI=[" %5.3f r(r1) ", " %5.3f r(r2) "]"
* real run: reps=1000  SE=0.019  95%CI=[0.112, 0.187]

* tidy up the chunk files
forvalues t = 1/4 {
    capture erase "boot_`t'.dta"
}
di "DONE"
