*! version 0.1.0  06jul2026  Eric A. Booth, Sr Researcher, Texas 2036
*! riskscan : k-anonymity re-identification scan over quasi-identifiers
program define riskscan, rclass sortpreserve
    version 16.0
    // version 16.0 suffices: egen group(), bysort, and rclass returns
    // are all long-stable features; nothing newer is needed.

    syntax varlist [if] [in] [, K(integer 5) FLag(name) SENsitive(varname) DETail]

    // ---- option checks -------------------------------------------------
    if `k' < 1 {
        di as err "option k() must be a positive integer; you supplied k(`k')"
        exit 198
    }
    if "`flag'" != "" {
        confirm new variable `flag'
    }
    if "`sensitive'" != "" {
        local overlap : list sensitive in varlist
        if `overlap' {
            di as err "sensitive(`sensitive') also appears in the " ///
                "quasi-identifier varlist; a variable cannot be both"
            exit 198
        }
    }

    // Missing values in the quasi-identifiers count as a level (a cell of
    // records missing on industry is still a findable cell), so we do NOT
    // mark out missings -- only if/in restricts the sample.
    marksample touse, novarlist
    quietly count if `touse'
    if r(N) == 0 {
        error 2000
    }
    local N = r(N)

    // ---- cell sizes ----------------------------------------------------
    tempvar cell kk tag kbin
    quietly egen long `cell' = group(`varlist') if `touse', missing
    quietly summarize `cell' if `touse', meanonly
    local cells = r(max)                        // egen group codes 1..G
    quietly bysort `touse' `cell': gen long `kk' = _N if `touse'
    quietly by `touse' `cell': gen byte `tag' = (_n == 1) if `touse'

    quietly count if `kk' == 1 & `touse'
    local k1 = r(N)
    quietly count if `kk' < `k' & `touse'
    local below = r(N)

    // ---- k-distribution bins: 1, 2-4, 5-10, >10 ------------------------
    quietly gen byte `kbin' = 1 + (`kk' > 1) + (`kk' > 4) + (`kk' > 10) ///
        if `touse'
    local blab1 "k=1 (unique)"
    local blab2 "k=2-4"
    local blab3 "k=5-10"
    local blab4 "k>10"
    forvalues b = 1/4 {
        quietly count if `kbin' == `b' & `touse'
        local p`b' = r(N)
        quietly count if `kbin' == `b' & `tag' == 1 & `touse'
        local c`b' = r(N)
    }

    // ---- l-diversity (optional) ----------------------------------------
    if "`sensitive'" != "" {
        tempvar sgrp ltag lrun ldiv
        quietly egen long `sgrp' = group(`sensitive') if `touse', missing
        quietly bysort `touse' `cell' `sgrp': gen byte `ltag' = (_n == 1) ///
            if `touse'
        quietly bysort `touse' `cell' (`sgrp'): gen long `lrun' = ///
            sum(`ltag') if `touse'
        quietly by `touse' `cell': gen long `ldiv' = `lrun'[_N] if `touse'
        quietly count if `ldiv' == 1 & `tag' == 1 & `touse'
        local l1cells = r(N)
    }

    // ---- flag variable (optional) ---------------------------------------
    if "`flag'" != "" {
        quietly gen byte `flag' = (`kk' < `k') if `touse'
        label variable `flag' "1 if quasi-identifier cell size k < `k'"
    }

    // ---- display ---------------------------------------------------------
    di as txt ""
    di as txt "k-anonymity re-identification scan"
    di as txt "Quasi-identifiers: " as res "`varlist'"
    di as txt "Records scanned: " as res %-12.0fc `N' ///
        as txt "  threshold: " as res "k < `k'"
    di as txt ""
    di as txt "  {hline 44}"
    di as txt "  Cell size (k)        Cells        Records"
    di as txt "  {hline 44}"
    forvalues b = 1/4 {
        di as txt "  " %-15s "`blab`b''" as res %10.0fc `c`b'' ///
            %15.0fc `p`b''
    }
    di as txt "  {hline 44}"
    di as txt "  " %-15s "Total" as res %10.0fc `cells' %15.0fc `N'
    di as txt "  {hline 44}"
    di as txt ""
    di as txt "Distinct quasi-identifier cells:      " as res %9.0fc `cells'
    di as txt "Records unique on these columns (k=1):" as res %9.0fc `k1'
    di as txt "Records below threshold (k<`k'):" _col(39) as res %9.0fc `below'
    if "`sensitive'" != "" {
        di as txt ""
        di as txt "l-diversity on sensitive variable: " as res "`sensitive'"
        di as txt "Cells with one sensitive value (l=1): " ///
            as res %9.0fc `l1cells' ///
            as txt "  (attribute-disclosure risk)"
    }
    if "`flag'" != "" {
        di as txt ""
        di as txt "Flag variable " as res "`flag'" ///
            as txt " created (=1 when k < `k')."
    }

    // ---- detail: smallest cells, one row per cell -----------------------
    if "`detail'" != "" {
        quietly count if `tag' == 1 & `kk' < `k' & `touse'
        local ncells = r(N)
        di as txt ""
        if `ncells' == 0 {
            di as txt "detail: no cells below the k < `k' threshold."
        }
        else {
            di as txt "Highest-risk combinations (cells with k < `k')," ///
                " smallest first:"
            preserve
            quietly keep if `tag' == 1 & `kk' < `k' & `touse'
            keep `varlist' `kk'
            // find an unused display name for the cell-size column
            local kname "cellsize"
            local j = 0
            capture confirm new variable `kname'
            while _rc {
                local ++j
                local kname "cellsize`j'"
                capture confirm new variable `kname'
            }
            rename `kk' `kname'
            sort `kname' `varlist'
            local nlist = min(`ncells', 30)
            list `varlist' `kname' in 1/`nlist', noobs abbreviate(12)
            if `ncells' > 30 {
                di as txt "  (showing 30 of `ncells' cells;" ///
                    " sensitive values are never listed)"
            }
            restore
        }
    }

    // ---- stored results --------------------------------------------------
    return scalar N          = `N'
    return scalar cells      = `cells'
    return scalar k1         = `k1'
    return scalar below      = `below'
    return scalar kthreshold = `k'
    if "`sensitive'" != "" {
        return scalar l1_cells = `l1cells'
    }
    return local varlist "`varlist'"
end
