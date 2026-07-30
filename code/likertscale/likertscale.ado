*! version 1.0.0  Eric A. Booth  28jul2026
*! likertscale: scale construction in one auditable step: index, alpha, percent-agree
program define likertscale, rclass
    version 16.0
    syntax varlist(min=2 numeric) [if] [in], ///
        [AGree(numlist integer >=1) GENStub(name) INDex(name) noALpha noREPort]

    marksample touse
    quietly count if `touse'
    if r(N) == 0 error 2000
    local N = r(N)
    local K : word count `varlist'

    * default agree set: top two points of the observed scale range
    if "`agree'" == "" {
        local hi = .
        local lo = .
        foreach v of local varlist {
            quietly summarize `v' if `touse'
            if r(max) > `hi' | `hi' >= . local hi = r(max)
            if r(min) < `lo' | `lo' >= . local lo = r(min)
        }
        local agree "`=`hi'-1' `hi'"
    }
    local acut : word 1 of `agree'

    * row-wise index
    if "`index'" == "" local index scaleindex
    confirm new variable `index'
    tempvar miss
    quietly egen `index' = rowmean(`varlist') if `touse'
    label variable `index' "Row-mean index of `K' items"

    * top-box percent-agree companions
    if "`genstub'" == "" local genstub agree
    local made ""
    local i = 0
    foreach v of local varlist {
        local ++i
        confirm new variable `genstub'`i'
        quietly gen byte `genstub'`i' = 0 if `touse' & !missing(`v')
        foreach a of local agree {
            quietly replace `genstub'`i' = 100 if `touse' & `v' == `a'
        }
        local vl : variable label `v'
        if `"`vl'"' == "" local vl "`v'"
        label variable `genstub'`i' `"% agree: `vl'"'
        local made "`made' `genstub'`i'"
    }

    * reliability
    local a = .
    if "`alpha'" != "noalpha" {
        quietly alpha `varlist' if `touse'
        local a = r(alpha)
    }

    if "`report'" != "noreport" {
        di as txt _n "likertscale: " as res `K' as txt " items, N = " ///
            as res `N' as txt ", agree = {" as res "`agree'" as txt "}"
        if `a' < . {
            di as txt "  Cronbach's alpha " as res %5.3f `a'
            if `a' < 0.70 di as txt "  below the 0.70 research floor:" ///
                " inspect item-rest correlations before averaging."
            if `a' > 0.95 di as txt "  above 0.95: items may be redundant" ///
                " rather than reliable."
        }
        quietly summarize `index' if `touse'
        di as txt "  index {bf:`index'}: mean " as res %5.2f r(mean) ///
            as txt ", sd " as res %5.2f r(sd)
        di as txt "  built:`made'"
    }

    return scalar N     = `N'
    return scalar items = `K'
    return scalar alpha = `a'
    return local  agree  "`agree'"
    return local  index  "`index'"
    return local  agreevars "`made'"
end