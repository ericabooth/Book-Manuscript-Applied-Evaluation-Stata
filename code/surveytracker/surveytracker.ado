*! version 1.0.0  Eric A. Booth  29jul2026
*! surveytracker: launch-day metadata snapshot, one wave per block, appended to a running tracker
program define surveytracker, rclass
    version 16.0
    syntax using/ , WAVE(string) [VARlist(varlist)]

    if "`varlist'" == "" {
        quietly ds
        local varlist `r(varlist)'
    }
    local nv : word count `varlist'

    * refuse loudly if this wave is already logged
    capture confirm file `"`using'"'
    local exists = (_rc == 0)
    if `exists' {
        preserve
        quietly use `"`using'"', clear
        capture confirm variable wave
        if _rc {
            di as error `"surveytracker: `using' is not a tracker file (no wave variable)"'
            restore
            exit 198
        }
        quietly count if wave == `"`wave'"'
        if r(N) > 0 {
            di as error `"surveytracker: wave "`wave'" is already logged in `using';"' ///
                " a snapshot is a record, not a draft. Remove its rows deliberately" ///
                " if it must be redone."
            restore
            exit 110
        }
        restore
    }

    * build the snapshot rows from the data in memory
    tempname ph
    tempfile snap
    postfile `ph' str40 wave str32 varname str80 varlab str32 vallabname ///
        str244 vallabtext str12 vtype str12 vformat using `snap'
    foreach v of local varlist {
        local vl : variable label `v'
        local ln : value label `v'
        local lt ""
        if "`ln'" != "" {
            quietly levelsof `v', local(levs)
            foreach l of local levs {
                local one : label `ln' `l'
                local lt `"`lt'`=cond(`"`lt'"'=="","","; ")'`l'=`one'"'
            }
            local lt = substr(`"`lt'"', 1, 244)
        }
        local ty : type `v'
        local fm : format `v'
        post `ph' (`"`wave'"') ("`v'") (`"`vl'"') ("`ln'") (`"`lt'"') ("`ty'") ("`fm'")
    }
    postclose `ph'

    * append to the tracker (create on first use)
    preserve
    quietly use `snap', clear
    if `exists' {
        quietly append using `"`using'"'
        quietly sort wave varname
    }
    quietly save `"`using'"', replace
    restore

    di as txt "surveytracker: logged " as res `nv' as txt " variable(s) as wave " ///
        as res `"`wave'"' as txt " in " as res `"`using'"'
    di as txt "diff waves with {bf:cxchangelog} when the next one lands."
    return scalar vars = `nv'
    return local wave `"`wave'"'
end