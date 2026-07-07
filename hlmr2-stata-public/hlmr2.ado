*! version 0.1.0  06jul2026  Eric A. Booth, Sr Researcher, Texas 2036
*! hlmr2 : Nakagawa marginal and conditional R-squared after -mixed-
*! Reference: Nakagawa & Schielzeth (2013), Methods in Ecology and
*!            Evolution 4(2): 133-142.
* version 16.0: needs -estat sd- after -mixed- and modern r(table)
* column stripes; both are available from Stata 15/16 onward.

program define hlmr2, rclass
    version 16.0
    syntax [, noDISplay Format(string) VARiance]

    * ---- must follow -mixed- -------------------------------------------
    if `"`e(cmd)'"' != "mixed" {
        display as error ///
            "last estimates not found or not from {bf:mixed}; run {bf:mixed} first"
        exit 301
    }
    local depvar `"`e(depvar)'"'

    * ---- display format ------------------------------------------------
    if `"`format'"' == "" local format "%9.4f"
    capture local fmtcheck : display `format' 0.123456
    if _rc {
        display as error `"format(`format') is not a valid numeric display format"'
        exit 120
    }

    * ---- fixed-effects variance on the estimation sample ---------------
    tempvar xb
    quietly predict double `xb' if e(sample), xb
    quietly summarize `xb' if e(sample)
    if r(N) == 0 {
        display as error "estimation sample not found; cannot compute Var(xb)"
        exit 2000
    }
    local var_f = r(Var)
    local nobs  = r(N)

    * ---- variance components from -estat sd- ---------------------------
    * -estat sd- labels parameters sd(...) in some Stata versions and,
    * with the variance option, var(...); the Mata parser accepts both,
    * so the two calls below return identical results.
    capture quietly estat sd, `variance'
    local rc = _rc
    if `rc' {
        display as error ///
            "{bf:estat sd} failed after {bf:mixed} (r(`rc')); " ///
            "variance components are unavailable"
        exit `rc'
    }

    tempname r2m r2c vf vran ve
    mata: _hlmr2_calc(`var_f', st_local("depvar"), ///
        st_local("r2m"), st_local("r2c"), st_local("vf"), ///
        st_local("vran"), st_local("ve"))

    * ---- notes for model features handled approximately ----------------
    if `nslopes' > 0 {
        display as text "note: model has random slopes; {bf:hlmr2} sums the" ///
            " random-effect variances and ignores"
        display as text "      their covariances, an approximation of the" ///
            " Nakagawa (2013) formula.  Interpret"
        display as text "      with caution."
    }
    if `nresid' > 1 {
        display as text "note: model has `nresid' residual variance" ///
            " parameters; {bf:hlmr2} uses their mean."
    }

    * ---- display ---------------------------------------------------------
    if "`display'" != "nodisplay" {
        display as text ""
        display as text "Nakagawa R-squared for the multilevel model" ///
            " (N = " as result `nobs' as text ")"
        display as text "{hline 62}"
        display as text "  Fixed-effects variance, Var(xb)      " ///
            as result `format' scalar(`vf')
        display as text "  Random-effects variance (summed)     " ///
            as result `format' scalar(`vran')
        display as text "  Residual variance                    " ///
            as result `format' scalar(`ve')
        display as text "{hline 62}"
        display as text "  Marginal R2   (fixed effects only)   " ///
            as result `format' scalar(`r2m')
        display as text "  Conditional R2 (fixed + random)      " ///
            as result `format' scalar(`r2c')
        display as text "{hline 62}"
    }

    * ---- stored results --------------------------------------------------
    return scalar r2_m    = scalar(`r2m')
    return scalar r2_c    = scalar(`r2c')
    return scalar var_f   = scalar(`vf')
    return scalar var_ran = scalar(`vran')
    return scalar var_e   = scalar(`ve')
    return scalar N       = `nobs'
    return local  depvar  `"`depvar'"'
end

version 16.0
mata:
mata set matastrict on

// Parse the current r(table) (as left by -estat sd- after -mixed-),
// combine with the fixed-effects variance, and store the Nakagawa
// R-squared pieces in the named Stata scalars.  Accepts both sd(...)
// and var(...) parameter labels.  Also sets the locals nslopes (count
// of random-slope variance parameters) and nresid (count of residual
// variance parameters) in the caller.
void _hlmr2_calc(real scalar var_f, string scalar depvar,
                 string scalar r2m_s, string scalar r2c_s,
                 string scalar vf_s,  string scalar vran_s,
                 string scalar ve_s)
{
    real matrix   tbl
    string matrix stripe
    real scalar   i, v, var_ran, var_e, total, nslopes, nresid
    real colvector resid
    string scalar eq, param, inner

    tbl    = st_matrix("r(table)")
    stripe = st_matrixcolstripe("r(table)")
    if (rows(tbl) == 0 | cols(tbl) == 0) {
        errprintf("r(table) from estat sd not found\n")
        _error(498)
    }

    var_ran = 0
    resid   = J(0, 1, .)
    nslopes = 0

    for (i = 1; i <= cols(tbl); i++) {
        eq    = stripe[i, 1]
        param = stripe[i, 2]

        // fixed-effect coefficient rows live under the depvar equation
        if (eq == depvar) continue

        // pull the value in variance metric, whichever label appears
        if (substr(param, 1, 3) == "sd(") {
            v     = tbl[1, i]^2
            inner = substr(param, 4, strlen(param) - 4)
        }
        else if (substr(param, 1, 4) == "var(") {
            v     = tbl[1, i]
            inner = substr(param, 5, strlen(param) - 5)
        }
        else continue                     // corr(...), cov(...), etc.

        if (eq == "Residual") {
            resid = resid \ v
        }
        else {
            var_ran = var_ran + v
            if (inner != "_cons" & substr(inner, 1, 2) != "R.") nslopes++
        }
    }

    nresid = rows(resid)
    if (nresid == 0) {
        errprintf("no residual variance found in the estat sd table\n")
        _error(498)
    }
    var_e = mean(resid)                   // one value in the usual case

    total = var_f + var_ran + var_e
    if (total <= 0 | missing(total)) {
        errprintf("total variance is zero or missing; cannot form R-squared\n")
        _error(498)
    }

    st_numscalar(r2m_s,  var_f / total)
    st_numscalar(r2c_s,  (var_f + var_ran) / total)
    st_numscalar(vf_s,   var_f)
    st_numscalar(vran_s, var_ran)
    st_numscalar(ve_s,   var_e)
    st_local("nslopes", strofreal(nslopes))
    st_local("nresid",  strofreal(nresid))
}
end
