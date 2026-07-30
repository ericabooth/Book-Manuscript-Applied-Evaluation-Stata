*! version 1.0.0  Eric A. Booth  28jul2026
*! faircheck: group-wise error audit of a binary prediction against observed truth
program define faircheck, rclass
    version 16.0
    syntax varlist(min=2 max=2 numeric) [if] [in], by(varname numeric) [RATio(real 0.8) noREPort]

    marksample touse
    markout `touse' `by'
    quietly count if `touse'
    if r(N) == 0 error 2000
    local N = r(N)

    tokenize `varlist'
    local truth `1'
    local pred  `2'
    foreach v in `truth' `pred' {
        capture assert inlist(`v', 0, 1) if `touse'
        if _rc {
            di as error "faircheck: `v' must be 0/1"
            exit 198
        }
    }

    quietly levelsof `by' if `touse', local(groups)
    local G : word count `groups'
    tempname T
    matrix `T' = J(`G', 6, .)
    matrix colnames `T' = N base_rate sel_rate tpr fpr precision
    local vlab : value label `by'
    local rn ""
    local mintpr = 1
    local maxtpr = 0
    local minfpr = 1
    local maxfpr = 0
    local g = 0
    foreach lev of local groups {
        local ++g
        quietly count if `touse' & `by' == `lev'
        local ng = r(N)
        quietly count if `touse' & `by' == `lev' & `truth' == 1
        local npos = r(N)
        quietly count if `touse' & `by' == `lev' & `truth' == 1 & `pred' == 1
        local tp = r(N)
        quietly count if `touse' & `by' == `lev' & `truth' == 0 & `pred' == 1
        local fp = r(N)
        quietly count if `touse' & `by' == `lev' & `pred' == 1
        local ppos = r(N)
        local tpr = cond(`npos' > 0, `tp'/`npos', .)
        local fpr = cond(`ng' - `npos' > 0, `fp'/(`ng' - `npos'), .)
        local prec = cond(`ppos' > 0, `tp'/`ppos', .)
        matrix `T'[`g',1] = `ng'
        matrix `T'[`g',2] = `npos'/`ng'
        matrix `T'[`g',3] = `ppos'/`ng'
        matrix `T'[`g',4] = `tpr'
        matrix `T'[`g',5] = `fpr'
        matrix `T'[`g',6] = `prec'
        if `tpr' < . {
            if `tpr' < `mintpr' local mintpr = `tpr'
            if `tpr' > `maxtpr' local maxtpr = `tpr'
        }
        if `fpr' < . {
            if `fpr' < `minfpr' local minfpr = `fpr'
            if `fpr' > `maxfpr' local maxfpr = `fpr'
        }
        local lab "`lev'"
        if "`vlab'" != "" local lab : label `vlab' `lev'
        local rn `"`rn' "`lab'""'
    }
    matrix rownames `T' = `rn'
    local tprgap = `maxtpr' - `mintpr'
    local fprgap = `maxfpr' - `minfpr'
    local minsel = 1
    local maxsel = 0
    forvalues i = 1/`G' {
        if `T'[`i',3] < `minsel' local minsel = `T'[`i',3]
        if `T'[`i',3] > `maxsel' local maxsel = `T'[`i',3]
    }
    local parity = cond(`maxsel' > 0, `minsel'/`maxsel', .)

    if "`report'" != "noreport" {
        di as txt _n "faircheck: {bf:`pred'} against {bf:`truth'}, by {bf:`by'}" ///
            " (N = " as res `N' as txt ")"
        di as txt "{hline 64}"
        di as txt %-13s "group" %7s "N" %8s "base" %8s "select" %8s "TPR" %8s "FPR" %8s "prec"
        di as txt "{hline 64}"
        forvalues i = 1/`G' {
            local lab : word `i' of `rn'
            di as txt %-13s abbrev(`"`lab'"',12) as res %7.0fc `T'[`i',1] ///
                %8.3f `T'[`i',2] %8.3f `T'[`i',3] %8.3f `T'[`i',4] ///
                %8.3f `T'[`i',5] %8.3f `T'[`i',6]
        }
        di as txt "{hline 64}"
        di as txt "selection-rate parity ratio " as res %5.3f `parity' ///
            as txt cond(`parity' < `ratio', " {bf:below the `=strofreal(`ratio',"%4.2f")' line}", " (clears `=strofreal(`ratio',"%4.2f")')")
        di as txt "largest gaps across groups: TPR " as res %5.3f `tprgap' ///
            as txt ", FPR " as res %5.3f `fprgap'
        di as txt "equal TPR and equal FPR cannot both hold when base rates" ///
            " differ; decide which error matters and defend the choice."
    }

    return matrix table = `T'
    return scalar N      = `N'
    return scalar groups = `G'
    return scalar tpr_gap = `tprgap'
    return scalar fpr_gap = `fprgap'
    return scalar parity_ratio = `parity'
    return scalar parity_flag  = (`parity' < `ratio')
end