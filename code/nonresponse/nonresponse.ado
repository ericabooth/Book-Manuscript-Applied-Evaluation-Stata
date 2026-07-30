*! version 1.0.0  Eric A. Booth  29jul2026
*! nonresponse: frame-vs-respondent diagnosis plus raking weights, on a frame file with a response flag
program define nonresponse, rclass
    version 16.0
    syntax varname(numeric) [if] [in], FRame(varlist numeric) ///
        [GENerate(name) TOLerance(real 0.0005) ITERate(integer 50) noREPort noMODel]

    marksample touse
    markout `touse' `frame'
    local resp `varlist'
    capture assert inlist(`resp', 0, 1) if `touse'
    if _rc {
        di as error "nonresponse: `resp' must be 0/1 (1 = responded)"
        exit 198
    }
    quietly count if `touse'
    local Nfr = r(N)
    quietly count if `touse' & `resp' == 1
    local Nre = r(N)
    if `Nre' == 0 | `Nre' == `Nfr' {
        di as error "nonresponse: need both responders and nonresponders in the frame"
        exit 2000
    }

    * -- refuse loudly: every frame category must have at least one responder --
    foreach v of local frame {
        quietly levelsof `v' if `touse', local(levs)
        local K : word count `levs'
        if `K' > 20 {
            di as error "nonresponse: `v' has `K' levels; frame() takes categorical variables"
            exit 198
        }
        foreach l of local levs {
            quietly count if `touse' & `resp' == 1 & `v' == `l'
            if r(N) == 0 {
                di as error "nonresponse: no responders in `v' == `l';" ///
                    " raking cannot recover a category nobody answered from"
                exit 459
            }
        }
    }

    * -- per-variable gap table: respondent share vs frame share ---------------
    tempname T
    local rows = 0
    foreach v of local frame {
        quietly levelsof `v' if `touse', local(levs)
        local rows = `rows' + `:word count `levs''
    }
    matrix `T' = J(`rows', 3, .)
    matrix colnames `T' = resp_pct frame_pct gap_pp
    local rn ""
    local i = 0
    local maxgap = 0
    local maxlab ""
    foreach v of local frame {
        local vlab : value label `v'
        quietly levelsof `v' if `touse', local(levs)
        foreach l of local levs {
            local ++i
            quietly count if `touse' & `v' == `l'
            local fpct = 100*r(N)/`Nfr'
            quietly count if `touse' & `resp' == 1 & `v' == `l'
            local rpct = 100*r(N)/`Nre'
            matrix `T'[`i',1] = `rpct'
            matrix `T'[`i',2] = `fpct'
            matrix `T'[`i',3] = `rpct' - `fpct'
            local lab "`l'"
            if "`vlab'" != "" local lab : label `vlab' `l'
            local rn `"`rn' "`v'=`lab'""'
            if abs(`rpct'-`fpct') > abs(`maxgap') {
                local maxgap = `rpct' - `fpct'
                local maxlab "`v'=`lab'"
            }
        }
    }
    matrix rownames `T' = `rn'

    * -- response model, shown not hidden --------------------------------------
    if "`model'" != "nomodel" {
        local fvl ""
        foreach v of local frame {
            local fvl "`fvl' i.`v'"
        }
        di as txt _n "Response model (who answers):"
        logit `resp' `fvl' if `touse', nolog
    }

    * -- raking: iterate proportional fitting to the frame margins -------------
    if "`generate'" != "" {
        confirm new variable `generate'
        tempvar w
        quietly gen double `w' = 1 if `touse' & `resp' == 1
        local converged = 0
        forvalues it = 1/`iterate' {
            local maxadj = 0
            foreach v of local frame {
                quietly levelsof `v' if `touse', local(levs)
                foreach l of local levs {
                    quietly count if `touse' & `v' == `l'
                    local ftarg = r(N)/`Nfr'
                    quietly summarize `w' if `touse' & `resp' == 1
                    local wtot = r(sum)
                    quietly summarize `w' if `touse' & `resp' == 1 & `v' == `l'
                    local wcur = cond(r(N) > 0, r(sum), 0) / `wtot'
                    local f = `ftarg'/`wcur'
                    quietly replace `w' = `w'*`f' if `touse' & `resp' == 1 & `v' == `l'
                    if abs(`f'-1) > `maxadj' local maxadj = abs(`f'-1)
                }
            }
            if `maxadj' < `tolerance' {
                local converged = 1
                local iters = `it'
                continue, break
            }
        }
        if !`converged' {
            di as error "nonresponse: raking did not converge in `iterate' iterations;" ///
                " simplify frame() or coarsen sparse categories"
            exit 430
        }
        * normalize weights to mean 1 among respondents
        quietly summarize `w' if `touse' & `resp' == 1
        quietly gen double `generate' = `w'/r(mean) if `touse' & `resp' == 1
        label variable `generate' "nonresponse: raking weight to frame margins"
        quietly summarize `generate' if `touse' & `resp' == 1
        local wmin = r(min)
        local wmax = r(max)
    }

    if "`report'" != "noreport" {
        di as txt _n "Nonresponse check: " as res `Nre' as txt " responders in a frame of " ///
            as res `Nfr' as txt " (" as res %4.1f 100*`Nre'/`Nfr' as txt "%)"
        di as txt "{hline 58}"
        di as txt %-22s "category" %10s "resp %" %10s "frame %" %9s "gap pp"
        di as txt "{hline 58}"
        forvalues r = 1/`rows' {
            local lab : word `r' of `rn'
            di as txt %-22s abbrev(`"`lab'"',21) as res %10.1f `T'[`r',1] ///
                %10.1f `T'[`r',2] %9.1f `T'[`r',3]
        }
        di as txt "{hline 58}"
        di as txt "largest gap: " as res %4.1f `maxgap' as txt " pp on " as res `"`maxlab'"'
        if "`generate'" != "" {
            di as txt "raking converged in " as res `iters' as txt " iteration(s);" ///
                " weights in {bf:`generate'}, range " ///
                as res %5.2f `wmin' as txt " to " as res %5.2f `wmax'
            di as txt "rerun the headline weighted and unweighted, and report both."
        }
    }

    return matrix table = `T'
    return scalar N_frame = `Nfr'
    return scalar N_resp  = `Nre'
    return scalar maxgap  = `maxgap'
    if "`generate'" != "" {
        return scalar iters = `iters'
        return scalar wmin  = `wmin'
        return scalar wmax  = `wmax'
    }
end