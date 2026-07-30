*! version 1.0.0  Eric A. Booth  27jul2026
*! reachcheck: compare a responding sample's composition against target-population margins
program define reachcheck, rclass
    version 16.0
    syntax varname(numeric) [if] [in], TARget(numlist >=0) ///
        [TOLerance(real 5.0) noREPort]

    marksample touse
    quietly count if `touse'
    if r(N) == 0 error 2000
    local N = r(N)

    * levels present in the sample, in value order
    quietly levelsof `varlist' if `touse', local(levels)
    local K : word count `levels'
    local T : word count `target'
    if `K' != `T' {
        di as error "reachcheck: {bf:`varlist'} has `K' categories in the sample " ///
            "but target() lists `T' values"
        di as error "  sample categories: `levels'"
        exit 198
    }

    * auto-detect shares (sum near 1) vs percentages (sum near 100)
    local tsum = 0
    foreach t of local target {
        local tsum = `tsum' + `t'
    }
    local scale = 1
    if `tsum' <= 1.5 local scale = 100
    if !inrange(`tsum'*`scale', 95, 105) {
        di as error "reachcheck: target() sums to " %6.3f `tsum' ///
            "; expected shares summing to 1 or percentages summing to 100"
        exit 198
    }

    tempname table
    matrix `table' = J(`K', 4, .)
    matrix colnames `table' = sample_pct target_pct gap_pp ratio

    local vlab : value label `varlist'
    local maxgap = 0
    local maxlab ""
    local chi2 = 0
    local rn ""
    forvalues i = 1/`K' {
        local lev : word `i' of `levels'
        local tgt : word `i' of `target'
        local tgt = `tgt' * `scale'
        quietly count if `touse' & `varlist' == `lev'
        local spct = 100 * r(N) / `N'
        local gap = `spct' - `tgt'
        matrix `table'[`i',1] = `spct'
        matrix `table'[`i',2] = `tgt'
        matrix `table'[`i',3] = `gap'
        matrix `table'[`i',4] = cond(`tgt'>0, `spct'/`tgt', .)
        if `tgt' > 0 {
            local chi2 = `chi2' + `N' * (`spct'/100 - `tgt'/100)^2 / (`tgt'/100)
        }
        local lab "`lev'"
        if "`vlab'" != "" {
            local lab : label `vlab' `lev'
        }
        local rn `"`rn' "`lab'""'
        if abs(`gap') > abs(`maxgap') {
            local maxgap = `gap'
            local maxlab "`lab'"
        }
    }
    matrix rownames `table' = `rn'
    local df = `K' - 1
    local p = chi2tail(`df', `chi2')

    if "`report'" != "noreport" {
        di as txt _n "Reach check: {bf:`varlist'} " ///
            "(N = " as res `N' as txt " respondents)"
        di as txt "{hline 60}"
        di as txt %-20s "category" %10s "sample %" %10s "target %" ///
            %9s "gap pp" %8s "ratio"
        di as txt "{hline 60}"
        forvalues i = 1/`K' {
            local lab : word `i' of `rn'
            di as txt %-20s abbrev(`"`lab'"',19) ///
                as res %10.1f `table'[`i',1] %10.1f `table'[`i',2] ///
                %9.1f `table'[`i',3] %8.2f `table'[`i',4]
        }
        di as txt "{hline 60}"
        di as txt "largest gap: " as res %4.1f `maxgap' as txt " pp on " ///
            as res `"`maxlab'"'
        di as txt "goodness of fit vs target: chi2(" as res `df' as txt ") = " ///
            as res %6.1f `chi2' as txt ", p = " as res %6.4f `p'
        if abs(`maxgap') > `tolerance' {
            di as txt _n "The responding sample is off its target by more than " ///
                as res `tolerance' as txt " pp."
            di as txt "Consider raking to the target margins " ///
                "({stata ssc describe ipfraking:ipfraking}) and, either way,"
            di as txt "report the gap beside the response rate."
        }
        else {
            di as txt _n "All gaps within " as res `tolerance' ///
                as txt " pp of target; report the table and proceed."
        }
    }

    return matrix table = `table'
    return scalar N      = `N'
    return scalar maxgap = `maxgap'
    return scalar chi2   = `chi2'
    return scalar df     = `df'
    return scalar p      = `p'
    return local  maxgap_category `"`maxlab'"'
end