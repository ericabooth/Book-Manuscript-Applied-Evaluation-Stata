*! version 1.0.0  Eric A. Booth  28jul2026
*! llmsieve: convergence delta between two LLM passes; route unstable rows to humans
program define llmsieve, rclass
    version 16.0
    syntax varlist(min=2 max=2 string) [if] [in], ///
        [THREShold(real 0.15) GENdelta(name) GENflag(name) noREPort]

    marksample touse, novarlist
    quietly count if `touse'
    if r(N) == 0 error 2000
    local N = r(N)

    tokenize `varlist'
    local v1 `1'
    local v2 `2'

    tempvar delta
    quietly gen double `delta' = .
    mata: _llmsieve_delta("`v1'", "`v2'", "`delta'", "`touse'")

    tempvar flag
    quietly gen byte `flag' = `delta' > `threshold' if `touse' & !missing(`delta')
    quietly count if `flag' == 1
    local nflag = r(N)
    quietly summarize `delta' if `touse'
    local mean = r(mean)
    local max  = r(max)

    if "`report'" != "noreport" {
        di as txt _n "llmsieve: convergence delta between {bf:`v1'} and {bf:`v2'}" ///
            " (N = " as res `N' as txt ")"
        di as txt "  mean delta " as res %6.3f `mean' ///
            as txt ", max " as res %6.3f `max'
        di as txt "  rows above threshold(" as res %4.2f `threshold' ///
            as txt "), routed to human review: " as res `nflag' ///
            as txt " of " as res `N'
        di as txt "  a low delta certifies stability, not correctness;" ///
            " keep the gold-standard kappa."
    }

    if "`gendelta'" != "" {
        confirm new variable `gendelta'
        quietly gen double `gendelta' = `delta'
        label variable `gendelta' "llmsieve: normalized edit distance"
    }
    if "`genflag'" != "" {
        confirm new variable `genflag'
        quietly gen byte `genflag' = `flag'
        label variable `genflag' "llmsieve: route to human review"
    }

    return scalar N       = `N'
    return scalar flagged = `nflag'
    return scalar mean    = `mean'
    return scalar max     = `max'
    return scalar threshold = `threshold'
end

version 16.0
mata:
void _llmsieve_delta(string scalar v1, string scalar v2,
                     string scalar dv, string scalar touse)
{
    real colvector use
    string colvector a, b
    real scalar i, n, la, lb, m
    real colvector d

    a = st_sdata(., v1, touse)
    b = st_sdata(., v2, touse)
    n = rows(a)
    d = J(n, 1, .)
    for (i = 1; i <= n; i++) {
        la = ustrlen(a[i]); lb = ustrlen(b[i])
        m = max((la, lb))
        if (m == 0) d[i] = 0
        else d[i] = _llmsieve_lev(a[i], b[i]) / m
    }
    st_store(., dv, touse, d)
}

real scalar _llmsieve_lev(string scalar s, string scalar t)
{
    real scalar n, m, i, j, cost
    real rowvector prev, curr
    n = ustrlen(s); m = ustrlen(t)
    if (n == 0) return(m)
    if (m == 0) return(n)
    prev = 0..m
    for (i = 1; i <= n; i++) {
        curr = J(1, m + 1, .)
        curr[1] = i
        for (j = 1; j <= m; j++) {
            cost = (usubstr(s, i, 1) == usubstr(t, j, 1)) ? 0 : 1
            curr[j + 1] = min((prev[j + 1] + 1, curr[j] + 1, prev[j] + cost))
        }
        prev = curr
    }
    return(prev[m + 1])
}
end