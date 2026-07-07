*! version 0.1.0  06jul2026  Eric A. Booth, Sr Researcher, Texas 2036
*! roisim: Monte Carlo return-on-investment simulation with tornado export
program define roisim, rclass
    version 16.0
    // version 16.0 is the package baseline; the program uses only Mata's
    // rnormal()/runiform() generators and standard -syntax- parsing, all
    // long available, so no newer version is needed.

    syntax , EFFect(numlist max=1) SE(numlist max=1)                ///
             COSTLow(numlist max=1) COSTHigh(numlist max=1)         ///
           [ NJoiners(numlist max=1) VALue(numlist max=1)           ///
             DIScount(numlist max=1)                                ///
             HORizon(numlist max=1 integer)                         ///
             DISCOUNTRange(numlist min=2 max=2)                     ///
             HORIZONRange(numlist min=2 max=2 integer)              ///
             REPs(integer 10000) SEED(numlist max=1 integer)        ///
             SAVing(string asis) ]

    * ---------------------------------------------------- validation
    if `se' < 0 {
        di as err "se() must be zero or positive"
        exit 198
    }
    if `costlow' <= 0 {
        di as err "costlow() must be strictly positive (ROI divides by cost)"
        exit 198
    }
    if `costhigh' < `costlow' {
        di as err "costhigh() must be greater than or equal to costlow()"
        exit 198
    }
    if "`njoiners'" == "" local njoiners 1
    if `njoiners' <= 0 {
        di as err "njoiners() must be strictly positive"
        exit 198
    }
    if "`value'" == "" local value 1
    if `value' <= 0 {
        di as err "value() must be strictly positive; " ///
            "carry the sign of the benefit in effect()"
        exit 198
    }
    if "`discount'" != "" & "`discountrange'" != "" {
        di as err "specify discount() or discountrange(), not both"
        exit 198
    }
    if "`horizon'" != "" & "`horizonrange'" != "" {
        di as err "specify horizon() or horizonrange(), not both"
        exit 198
    }
    if "`discountrange'" != "" {
        gettoken dlo dhi : discountrange
        local dhi : word 1 of `dhi'
        if `dlo' > `dhi' {
            di as err "discountrange() must be low high, in that order"
            exit 198
        }
        if `dlo' < 0 | `dhi' >= 1 {
            di as err "discountrange() rates must satisfy 0 <= low <= high < 1"
            exit 198
        }
        local d0 = (`dlo' + `dhi')/2
    }
    else {
        if "`discount'" == "" local discount 0.03
        if `discount' < 0 | `discount' >= 1 {
            di as err "discount() must satisfy 0 <= rate < 1 (e.g. 0.03 for 3%)"
            exit 198
        }
        local d0  `discount'
        local dlo .
        local dhi .
    }
    if "`horizonrange'" != "" {
        gettoken hlo hhi : horizonrange
        local hhi : word 1 of `hhi'
        if `hlo' > `hhi' {
            di as err "horizonrange() must be low high, in that order"
            exit 198
        }
        if `hlo' < 1 {
            di as err "horizonrange() years must be 1 or greater"
            exit 198
        }
        local h0 = round((`hlo' + `hhi')/2)
    }
    else {
        if "`horizon'" == "" local horizon 5
        if `horizon' < 1 {
            di as err "horizon() must be 1 or greater"
            exit 198
        }
        local h0  `horizon'
        local hlo .
        local hhi .
    }
    if `reps' < 100 {
        di as err "reps() must be at least 100"
        exit 198
    }

    * parse saving(filename[, replace])
    local dosave 0
    if `"`saving'"' != "" {
        local 0 `"`saving'"'
        syntax [anything] [, replace]
        local svfile = subinstr(`"`anything'"', `"""', "", .)
        if `"`svfile'"' == "" {
            di as err "saving() requires a filename"
            exit 198
        }
        if !strpos(`"`svfile'"', ".") local svfile `"`svfile'.csv"'
        if "`replace'" == "" confirm new file `"`svfile'"'
        local dosave 1
    }

    if "`seed'" != "" set seed `seed'

    * ---------------------------------------------------- Monte Carlo
    * effect draw ~ Normal(effect, se); cost draw ~ Uniform(costlow, costhigh);
    * discount and horizon are fixed unless a range() draws them too.
    tempname res
    mata: _roisim_mc(`effect', `se', `costlow', `costhigh',   ///
        `njoiners', `value', `d0', `h0',                      ///
        `dlo', `dhi', `hlo', `hhi', `reps', "`res'")

    * ---------------------------------------------------- central-value ROI
    local c0 = (`costlow' + `costhigh')/2
    tempname A0 pv0 roi0
    scalar `A0'   = cond(`d0'==0, `h0', (1 - (1+`d0')^(-`h0'))/`d0')
    scalar `pv0'  = `njoiners'*`value'*`effect'*`A0'
    scalar `roi0' = (`pv0' - `c0')/`c0'

    * ---------------------------------------------------- tornado sweep
    * One input at a time swings low -> high with every other input held at
    * its central value.  effect swings across its 95% interval
    * (effect -/+ 1.96*se); cost across costlow to costhigh; discount and
    * horizon across their ranges when discountrange()/horizonrange() are
    * given, and are omitted from the sweep when held fixed.
    tempname T
    local z = invnormal(.975)
    local elo = `effect' - `z'*`se'
    local ehi = `effect' + `z'*`se'
    _roisim_point `elo' `c0' `d0' `h0' `njoiners' `value'
    local rl = r(roi)
    _roisim_point `ehi' `c0' `d0' `h0' `njoiners' `value'
    local rh = r(roi)
    matrix `T' = (`elo', `effect', `ehi', `rl', `rh', abs(`rh'-`rl'))
    local rown "effect"

    _roisim_point `effect' `costlow' `d0' `h0' `njoiners' `value'
    local rl = r(roi)
    _roisim_point `effect' `costhigh' `d0' `h0' `njoiners' `value'
    local rh = r(roi)
    matrix `T' = `T' \ (`costlow', `c0', `costhigh', `rl', `rh', abs(`rh'-`rl'))
    local rown "`rown' cost"

    if "`dlo'" != "." {
        _roisim_point `effect' `c0' `dlo' `h0' `njoiners' `value'
        local rl = r(roi)
        _roisim_point `effect' `c0' `dhi' `h0' `njoiners' `value'
        local rh = r(roi)
        matrix `T' = `T' \ (`dlo', `d0', `dhi', `rl', `rh', abs(`rh'-`rl'))
        local rown "`rown' discount"
    }
    if "`hlo'" != "." {
        _roisim_point `effect' `c0' `d0' `hlo' `njoiners' `value'
        local rl = r(roi)
        _roisim_point `effect' `c0' `d0' `hhi' `njoiners' `value'
        local rh = r(roi)
        matrix `T' = `T' \ (`hlo', `h0', `hhi', `rl', `rh', abs(`rh'-`rl'))
        local rown "`rown' horizon"
    }
    matrix rownames `T' = `rown'
    matrix colnames `T' = low central high roi_low roi_high swing
    mata: _roisim_sorttorn("`T'")
    local nswept = rowsof(`T')

    * ---------------------------------------------------- write tornado CSV
    if `dosave' {
        tempname fh
        file open `fh' using `"`svfile'"', write text replace
        file write `fh' "input,low,central,high,roi_low,roi_high,swing" _n
        local rnames : rownames `T'
        forvalues i = 1/`nswept' {
            local rn : word `i' of `rnames'
            file write `fh' "`rn'"
            forvalues j = 1/6 {
                local v : di %18.0g el(`T',`i',`j')
                local v = trim("`v'")
                file write `fh' ",`v'"
            }
            file write `fh' _n
        }
        file close `fh'
    }

    * ---------------------------------------------------- display
    di
    di as txt "Monte Carlo ROI simulation" _col(46) ///
        as txt "replications = " as res %9.0fc `reps'
    di as txt "{hline 72}"
    di as txt "  effect   ~ Normal("  as res "`effect'" as txt ", " ///
        as res "`se'" as txt ")"
    di as txt "  cost     ~ Uniform(" as res "`costlow'" as txt ", " ///
        as res "`costhigh'" as txt ")"
    if "`dlo'" != "." {
        di as txt "  discount ~ Uniform(" as res "`dlo'" as txt ", " ///
            as res "`dhi'" as txt ")"
    }
    else di as txt "  discount   fixed at " as res "`discount'"
    if "`hlo'" != "." {
        di as txt "  horizon  ~ integer Uniform(" as res "`hlo'" as txt ", " ///
            as res "`hhi'" as txt ") years"
    }
    else di as txt "  horizon    fixed at " as res "`horizon'" as txt " years"
    di as txt "  annual benefit = njoiners (" as res "`njoiners'" ///
        as txt ") x value (" as res "`value'" as txt ") x effect draw"
    di as txt "  ROI = (PV of benefits - cost) / cost"
    di as txt "{hline 72}"
    di as txt "  percentiles of the simulated ROI"
    di as txt "      1%      5%     10%     25%     50%     75%     90%" ///
        "     95%     99%"
    di as res "  " %6.2f el(`res',1,5)  " " %6.2f el(`res',1,6)  ///
        " "  %6.2f el(`res',1,7)  " " %6.2f el(`res',1,8)        ///
        " "  %6.2f el(`res',1,9)  " " %6.2f el(`res',1,10)       ///
        " "  %6.2f el(`res',1,11) " " %6.2f el(`res',1,12)       ///
        " "  %6.2f el(`res',1,13)
    di
    di as txt "  mean = " as res %6.3f el(`res',1,1)             ///
        as txt "   sd = " as res %6.3f el(`res',1,2)             ///
        as txt "   min = " as res %6.3f el(`res',1,3)            ///
        as txt "   max = " as res %6.3f el(`res',1,4)
    di as txt "  Pr(ROI > 0) = " as res %5.3f el(`res',1,14)     ///
        as txt "    ROI at central values = " as res %6.3f `roi0'
    di as txt "{hline 72}"
    di as txt "  tornado sweep: one input low -> high, others at center"
    di as txt %10s "input" %11s "low" %11s "high" ///
        %11s "ROI@low" %11s "ROI@high" %9s "swing"
    local rnames : rownames `T'
    forvalues i = 1/`nswept' {
        local rn : word `i' of `rnames'
        di as txt %10s "`rn'" as res ///
            %11.0g el(`T',`i',1) %11.0g el(`T',`i',3) ///
            %11.3f el(`T',`i',4) %11.3f el(`T',`i',5) ///
            %9.3f  el(`T',`i',6)
    }
    if `dosave' di as txt "  tornado table saved to " as res `"`svfile'"'
    di

    * ---------------------------------------------------- returns
    tempname pct
    matrix `pct' = (el(`res',1,5), el(`res',1,6), el(`res',1,7),   ///
        el(`res',1,8), el(`res',1,9), el(`res',1,10),              ///
        el(`res',1,11), el(`res',1,12), el(`res',1,13))
    matrix colnames `pct' = p1 p5 p10 p25 p50 p75 p90 p95 p99
    matrix rownames `pct' = roi

    return scalar reps        = `reps'
    return scalar mean        = el(`res',1,1)
    return scalar sd          = el(`res',1,2)
    return scalar min         = el(`res',1,3)
    return scalar max         = el(`res',1,4)
    return scalar p1          = el(`res',1,5)
    return scalar p5          = el(`res',1,6)
    return scalar p10         = el(`res',1,7)
    return scalar p25         = el(`res',1,8)
    return scalar p50         = el(`res',1,9)
    return scalar p75         = el(`res',1,10)
    return scalar p90         = el(`res',1,11)
    return scalar p95         = el(`res',1,12)
    return scalar p99         = el(`res',1,13)
    return scalar prpos       = el(`res',1,14)
    return scalar roi_central = `roi0'
    return scalar pv_central  = `pv0'
    return scalar pvfactor    = `A0'
    return scalar n_swept     = `nswept'
    return scalar effect      = `effect'
    return scalar se          = `se'
    return scalar costlow     = `costlow'
    return scalar costhigh    = `costhigh'
    return scalar njoiners    = `njoiners'
    return scalar value       = `value'
    return local  cmd "roisim"
    if `dosave' return local saving `"`svfile'"'
    return matrix pct     = `pct'
    return matrix tornado = `T'
end

* deterministic single-point ROI: e c d h nj val
program define _roisim_point, rclass
    version 16.0
    args e c d h nj val
    tempname A
    scalar `A' = cond(`d'==0, `h', (1 - (1+`d')^(-`h'))/`d')
    return scalar roi = (`nj'*`val'*`e'*`A' - `c')/`c'
end

version 16.0
mata:

// percentile of a sorted column vector, summarize-detail convention
real scalar _roisim_pctile(real colvector s, real scalar p)
{
    real scalar n, i
    n = rows(s)
    i = n * p / 100
    if (i == floor(i)) return((s[i] + s[i+1]) / 2)
    return(s[ceil(i)])
}

void _roisim_mc(real scalar effect, real scalar se,
                real scalar clo,    real scalar chi,
                real scalar nj,     real scalar val,
                real scalar d0,     real scalar h0,
                real scalar dlo,    real scalar dhi,
                real scalar hlo,    real scalar hhi,
                real scalar reps,   string scalar out)
{
    real colvector eff, cost, d, h, dd, A, roi, s
    real scalar    mu, sd
    real rowvector res

    if (se > 0) eff = rnormal(reps, 1, effect, se)
    else        eff = J(reps, 1, effect)
    cost = clo :+ (chi - clo) :* runiform(reps, 1)
    if (dlo < .) d = dlo :+ (dhi - dlo) :* runiform(reps, 1)
    else         d = J(reps, 1, d0)
    if (hlo < .) h = hlo :+ floor((hhi - hlo + 1) :* runiform(reps, 1))
    else         h = J(reps, 1, h0)

    // annuity factor: sum_{t=1..h} (1+d)^-t = (1-(1+d)^-h)/d, = h at d=0
    dd  = d :+ (d :== 0)
    A   = (d :== 0) :* h :+ (d :!= 0) :* ((1 :- (1 :+ d):^(-h)) :/ dd)
    roi = (nj :* val :* eff :* A :- cost) :/ cost

    s   = sort(roi, 1)
    mu  = mean(roi)
    sd  = sqrt(sum((roi :- mu):^2)/(reps - 1))
    res = (mu, sd, s[1], s[reps],
           _roisim_pctile(s, 1),  _roisim_pctile(s, 5),
           _roisim_pctile(s, 10), _roisim_pctile(s, 25),
           _roisim_pctile(s, 50), _roisim_pctile(s, 75),
           _roisim_pctile(s, 90), _roisim_pctile(s, 95),
           _roisim_pctile(s, 99), mean(roi :> 0))
    st_matrix(out, res)
}

// sort a tornado matrix descending on column 6 (swing), keep stripes
void _roisim_sorttorn(string scalar mname)
{
    real matrix    M
    string matrix  rn, cn
    real colvector idx
    M   = st_matrix(mname)
    rn  = st_matrixrowstripe(mname)
    cn  = st_matrixcolstripe(mname)
    idx = order(-M[., 6], 1)
    st_matrix(mname, M[idx, .])
    st_matrixrowstripe(mname, rn[idx, .])
    st_matrixcolstripe(mname, cn)
}

end
