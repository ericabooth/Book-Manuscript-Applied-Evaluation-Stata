*! version 0.1.1  06jul2026  Eric A. Booth, Sr Researcher, Texas 2036
*! rateshrink: empirical-Bayes shrinkage for noisy small-denominator rates
*! Methods paper: Field, Dong, Booth, Hastings, and Malone (2026),
*!   "Rethinking 'Signal-To-Noise': A Coherent Beta-Binomial Reliability
*!   Formulation for Assessing Quality Measures" (pre-print under review),
*!   Far Harbor, LLC.  https://github.com/ericabooth/BetaBinomialPaperMaterials
* version 16.0: needs only invibeta()/invgammap() and standard syntax
* machinery, all available since well before Stata 16.
program define rateshrink, rclass
    version 16.0
    syntax [if] [in], Success(varname numeric) Denominator(varname numeric) ///
        GENerate(name) [TYpe(string) CI(real 0) ID(varname) REL(name)]

    * ---- option checks -------------------------------------------------
    if "`type'" == "" local type "ebbeta"
    local type = lower("`type'")
    if !inlist("`type'", "ebbeta", "ebgamma") {
        display as error "type() must be {bf:ebbeta} or {bf:ebgamma}; " ///
            "you specified type(`type')"
        exit 198
    }

    if "`rel'" != "" {
        if "`type'" == "ebgamma" {
            display as error "rel() requires type(ebbeta): the Beta-binomial " ///
                "reliability n/(n + alpha + beta) is defined under the " ///
                "Beta-binomial model, not the Poisson-gamma model"
            exit 198
        }
        confirm new variable `rel'
    }

    confirm new variable `generate'
    local haveci = (`ci' != 0)
    if `haveci' {
        if `ci' <= 0 | `ci' >= 100 {
            display as error "ci() must be a level strictly between 0 and 100, e.g. ci(95)"
            exit 198
        }
        confirm new variable `generate'_lb
        confirm new variable `generate'_ub
        local plo = (1 - `ci'/100)/2
        local phi = 1 - `plo'
    }

    * ---- sample --------------------------------------------------------
    marksample touse, novarlist
    markout `touse' `success' `denominator'
    quietly count if `touse'
    local N = r(N)
    if `N' < 2 {
        display as error "at least 2 units with nonmissing success() and denominator() are required"
        exit 2001
    }

    * ---- data validity -------------------------------------------------
    capture assert `success' >= 0 if `touse'
    if _rc {
        display as error "success() contains negative values"
        exit 459
    }
    capture assert `denominator' > 0 if `touse'
    if _rc {
        display as error "denominator() must be strictly positive for every unit"
        exit 459
    }
    if "`type'" == "ebbeta" {
        capture assert `success' <= `denominator' if `touse'
        if _rc {
            display as error "success() exceeds denominator() for at least one unit; " ///
                "for event rates with exposure denominators use type(ebgamma)"
            exit 459
        }
    }

    tempvar praw
    quietly generate double `praw' = `success'/`denominator' if `touse'

    * ---- estimate the prior by method of moments -----------------------
    if "`type'" == "ebbeta" {
        * Beta-binomial: prior Beta(a,b) for proportions.
        * tau2 = between-unit variance of true rates, estimated as the raw
        * variance of the observed proportions minus the average binomial
        * sampling variance at the grand mean.
        quietly summarize `praw' if `touse'
        local pbar = r(mean)
        local s2   = r(Var)
        tempvar sampv
        quietly generate double `sampv' = `pbar'*(1 - `pbar')/`denominator' if `touse'
        quietly summarize `sampv' if `touse', meanonly
        local tau2 = max(`s2' - r(mean), 1e-6)
        local M = `pbar'*(1 - `pbar')/`tau2' - 1
        if `M' <= 0 | missing(`M') {
            display as text "note: between-unit variance too large to identify a " ///
                "moment-based prior; falling back to a uniform prior (alpha=1, beta=1)"
            local a = 1
            local b = 1
        }
        else {
            local a = `M'*`pbar'
            local b = `M'*(1 - `pbar')
        }
        local priormean = `a'/(`a' + `b')
        local priorn    = `a' + `b'

        quietly generate double `generate' = ///
            (`success' + `a')/(`denominator' + `a' + `b') if `touse'
        label variable `generate' "EB Beta-binomial shrunken rate"
        if `haveci' {
            * Posterior is Beta(y + a, n - y + b); quantiles via invibeta()
            quietly generate double `generate'_lb = ///
                invibeta(`success' + `a', `denominator' - `success' + `b', `plo') if `touse'
            quietly generate double `generate'_ub = ///
                invibeta(`success' + `a', `denominator' - `success' + `b', `phi') if `touse'
            label variable `generate'_lb "EB posterior `ci'% lower bound"
            label variable `generate'_ub "EB posterior `ci'% upper bound"
        }
        if "`rel'" != "" {
            * Beta-binomial reliability = shrinkage weight on the unit's
            * own data = n/(n + alpha + beta); see Field et al. (2026).
            quietly generate double `rel' = ///
                `denominator'/(`denominator' + `a' + `b') if `touse'
            label variable `rel' "Beta-binomial reliability n/(n + alpha + beta)"
        }
        local priordesc "Beta(alpha, beta); prior sample size = alpha + beta"
    }
    else {
        * Poisson-gamma: prior Gamma(a, rate b) for event rates with
        * exposure denominators.  Grand rate is exposure-weighted
        * (total events / total exposure); the between-unit variance
        * estimator subtracts the expected Poisson sampling variance
        * from the exposure-weighted variance of the raw rates
        * (Marshall 1991 moment estimator).
        quietly summarize `success' if `touse', meanonly
        local sumy = r(sum)
        quietly summarize `denominator' if `touse', meanonly
        local sumE = r(sum)
        local Ebar = r(mean)
        local rbar = `sumy'/`sumE'
        if `rbar' <= 0 {
            display as error "all success() counts are zero; nothing to shrink"
            exit 459
        }
        tempvar wdev2
        quietly generate double `wdev2' = ///
            `denominator'*(`praw' - `rbar')^2 if `touse'
        quietly summarize `wdev2' if `touse', meanonly
        local s2w  = r(sum)/`sumE'
        local tau2 = `s2w' - `rbar'/`Ebar'
        if `tau2' <= 0 | missing(`tau2') {
            display as text "note: no detectable between-unit variance; " ///
                "rates shrink almost fully to the grand rate"
            local tau2 = 1e-6
        }
        local b = `rbar'/`tau2'
        local a = `rbar'*`b'
        local priormean = `rbar'
        local priorn    = `b'

        quietly generate double `generate' = ///
            (`success' + `a')/(`denominator' + `b') if `touse'
        label variable `generate' "EB Poisson-gamma shrunken rate"
        if `haveci' {
            * Posterior is Gamma(y + a, rate E + b); quantiles via invgammap()
            quietly generate double `generate'_lb = ///
                invgammap(`success' + `a', `plo')/(`denominator' + `b') if `touse'
            quietly generate double `generate'_ub = ///
                invgammap(`success' + `a', `phi')/(`denominator' + `b') if `touse'
            label variable `generate'_lb "EB posterior `ci'% lower bound"
            label variable `generate'_ub "EB posterior `ci'% upper bound"
        }
        local priordesc "Gamma(alpha, rate beta); prior exposure = beta"
    }

    * ---- who moved the most --------------------------------------------
    tempvar amove
    tempname mm
    quietly generate double `amove' = abs(`generate' - `praw') if `touse'
    quietly summarize `amove' if `touse', meanonly
    scalar `mm' = r(max)
    tempvar obsn
    quietly generate long `obsn' = _n
    quietly summarize `obsn' if `touse' & `amove' >= `mm', meanonly
    local mobs = r(min)
    if "`id'" != "" {
        capture confirm string variable `id'
        if !_rc local unitlab = `id'[`mobs']
        else    local unitlab = strofreal(`id'[`mobs'])
        local unitlab `"`id' = `unitlab'"'
    }
    else local unitlab "observation `mobs'"
    local rawmost   = `praw'[`mobs']
    local shrunkmost = `generate'[`mobs']

    * ---- output ----------------------------------------------------------
    display as text "Empirical-Bayes shrinkage (" as result "`type'" ///
        as text "), " as result `N' as text " units"
    display as text "  prior: `priordesc'"
    display as text "  alpha = " as result %9.4f `a' ///
        as text "   beta = " as result %9.4f `b' ///
        as text "   prior mean = " as result %7.4f `priormean' ///
        as text "   prior size = " as result %9.2f `priorn'
    display as text "  shrunken rates in " as result "`generate'" ///
        _c
    if `haveci' display as text "; `ci'% posterior interval in " ///
        as result "`generate'_lb" as text ", " as result "`generate'_ub" _c
    display ""
    if "`rel'" != "" {
        tempname meanrel
        quietly summarize `rel' if `touse', meanonly
        scalar `meanrel' = r(mean)
        display as text "  Beta-binomial reliability in " as result "`rel'" ///
            as text " (mean = " as result %7.4f `meanrel' as text ")"
    }
    display as text "  largest move: " as result "`unitlab'" ///
        as text ", raw " as result %7.4f `rawmost' ///
        as text " -> shrunken " as result %7.4f `shrunkmost' ///
        as text " (max |raw - shrunken| = " as result %7.4f `mm' as text ")"

    * ---- stored results --------------------------------------------------
    return scalar N       = `N'
    return scalar alpha   = `a'
    return scalar beta    = `b'
    return scalar mean    = `priormean'
    return scalar maxmove = `mm'
    if "`rel'" != "" return scalar meanrel = `meanrel'
    return local  type      "`type'"
    return local  maxunit   "`unitlab'"
    return local  generate  "`generate'"
end
