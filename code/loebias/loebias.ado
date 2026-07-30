*! version 1.0.0  Eric A. Booth  29jul2026
*! loebias: level-of-effort sensitivity: does the estimate stabilize as later attempts arrive?
program define loebias, rclass
    version 16.0
    syntax varname(numeric) [if] [in], ATTempts(varname numeric) ///
        [THREShold(real 0.5) GRaph GRAPHName(name) noREPort]

    marksample touse
    markout `touse' `attempts'
    local y `varlist'
    quietly count if `touse'
    if r(N) == 0 error 2000

    quietly levelsof `attempts' if `touse', local(levs)
    local K : word count `levs'
    if `K' < 3 {
        di as error "loebias: `attempts' has only `K' distinct level(s);" ///
            " a level-of-effort read needs at least 3"
        exit 198
    }

    * scale detection: report in pp for shares, raw units otherwise
    quietly summarize `y' if `touse'
    local isshare = (r(min) >= 0 & r(max) <= 1)
    local unit = cond(`isshare', "pp", "units")

    tempname T
    matrix `T' = J(`K', 3, .)
    matrix colnames `T' = max_attempts N cum_estimate
    local i = 0
    local prev = .
    local lastchg = .
    foreach k of local levs {
        local ++i
        quietly summarize `y' if `touse' & `attempts' <= `k'
        matrix `T'[`i',1] = `k'
        matrix `T'[`i',2] = r(N)
        matrix `T'[`i',3] = r(mean)
        if `prev' < . local lastchg = r(mean) - `prev'
        local prev = r(mean)
    }
    local final = `T'[`K',3]
    local chgpp = cond(`isshare', 100*`lastchg', `lastchg')
    local stable = (abs(`chgpp') < `threshold')

    if "`report'" != "noreport" {
        di as txt _n "Level-of-effort check: cumulative estimate of {bf:`y'} by {bf:`attempts'}"
        di as txt "{hline 46}"
        di as txt %14s "attempts <= k" %8s "N" %14s "estimate"
        di as txt "{hline 46}"
        forvalues r = 1/`K' {
            di as txt %14.0f `T'[`r',1] as res %8.0fc `T'[`r',2] %14.4f `T'[`r',3]
        }
        di as txt "{hline 46}"
        di as txt "last-step change: " as res %6.2f `chgpp' as txt " `unit'" ///
            cond(`stable', " (stable at threshold `threshold')", ///
                           " {bf:(still moving at threshold `threshold')}")
        if `stable' di as txt "late, reluctant respondents look like earlier ones" ///
            " on this outcome; the estimate has settled."
        else di as txt "the estimate is still drifting as reluctant respondents" ///
            " arrive: treat the final number as provisional and pair this" ///
            " with a frame comparison."
        di as txt "assumes late responders resemble nonresponders, which holds" ///
            " better for reluctance than unreachability."
    }

    if "`graph'" != "" | "`graphname'" != "" {
        if "`graphname'" == "" local graphname loebias
        preserve
        quietly {
            clear
            svmat `T', names(col)
            twoway connected cum_estimate max_attempts, ///
                ytitle("cumulative estimate") xtitle("attempts included (<= k)") ///
                title("Level-of-effort sensitivity") name(`graphname', replace)
        }
        restore
    }

    return matrix table = `T'
    return scalar levels    = `K'
    return scalar final     = `final'
    return scalar last_change = `lastchg'
    return scalar stable    = `stable'
end