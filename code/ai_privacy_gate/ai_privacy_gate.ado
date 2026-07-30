*! version 1.0.0  Eric A. Booth  27jul2026
*! ai_privacy_gate: scan string variables for likely PII before text leaves for a hosted LLM
program define ai_privacy_gate, rclass
    version 16.0
    syntax varlist(string) [if] [in], [Action(string) GENflag(name) noREPort]

    if "`action'" == "" local action report
    if !inlist("`action'", "report", "mask", "stop") {
        di as error "ai_privacy_gate: action() must be report, mask, or stop"
        exit 198
    }

    marksample touse, novarlist

    * PII pattern classes (Unicode regex, case-insensitive where it matters)
    local c_ssn     "\b[0-9]{3}-[0-9]{2}-[0-9]{4}\b"
    local c_phone   "(\+?1[-\. ])?\(?[0-9]{3}\)?[-\. ][0-9]{3}[-\. ][0-9]{4}"
    local c_email   "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}"
    local c_date    "\b(0?[1-9]|1[0-2])[/-](0?[1-9]|[12][0-9]|3[01])[/-](19|20)[0-9]{2}\b"
    local c_address "(?i)\b[0-9]{1,5} [A-Za-z]+( [A-Za-z]+)? (Street|St|Avenue|Ave|Road|Rd|Drive|Dr|Lane|Ln|Boulevard|Blvd|Court|Ct)\b"
    local c_idnum   "(?i)\b(MRN|SSN|ID|Case)[#: ]+[0-9]{4,}\b"
    local classes ssn phone email date address idnum

    if "`genflag'" != "" {
        confirm new variable `genflag'
        quietly gen byte `genflag' = 0 if `touse'
        label variable `genflag' "ai_privacy_gate: row contains likely PII"
    }

    tempvar anyhit
    quietly gen byte `anyhit' = 0

    * per class, count rows with at least one hit across the varlist
    foreach cl of local classes {
        local n_`cl' = 0
    }
    local nvars : word count `varlist'

    foreach v of local varlist {
        foreach cl of local classes {
            tempvar hit_`cl'
            quietly gen byte `hit_`cl'' = ///
                ustrregexm(`v', "`c_`cl''") == 1 if `touse'
            quietly count if `hit_`cl'' == 1
            local vh_`v'_`cl' = r(N)
            local n_`cl' = `n_`cl'' + r(N)
            quietly replace `anyhit' = 1 if `hit_`cl'' == 1
            drop `hit_`cl''
        }
        if "`action'" == "mask" {
            foreach cl of local classes {
                quietly replace `v' = ///
                    ustrregexra(`v', "`c_`cl''", "[REDACTED-`=upper("`cl'")']") ///
                    if `touse'
            }
        }
    }

    quietly count if `anyhit' == 1
    local nrows = r(N)
    local total = 0
    foreach cl of local classes {
        local total = `total' + `n_`cl''
    }
    if "`genflag'" != "" {
        quietly replace `genflag' = 1 if `anyhit' == 1
    }

    if "`report'" != "noreport" {
        di as txt _n "AI privacy gate: " as res `nvars' as txt ///
            " text variable(s) scanned, action = " as res "`action'"
        di as txt "{hline 58}"
        di as txt %-14s "class" %12s "flagged rows"
        di as txt "{hline 58}"
        foreach cl of local classes {
            di as txt %-14s "`cl'" as res %12.0fc `n_`cl''
        }
        di as txt "{hline 58}"
        di as txt %-14s "any class" as res %12.0fc `nrows'
        if "`action'" == "mask" {
            di as txt _n "Matches replaced in place with [REDACTED-CLASS] tags."
            di as txt "Masking runs on a copy of the data by design; " ///
                "re-run the gate to confirm zero."
        }
    }

    return scalar rows  = `nrows'
    return scalar total = `total'
    foreach cl of local classes {
        return scalar `cl' = `n_`cl''
    }
    return local action "`action'"

    if "`action'" == "stop" & `nrows' > 0 {
        di as error _n "ai_privacy_gate: `nrows' row(s) contain likely PII; " ///
            "nothing should leave for a hosted LLM."
        di as error "Mask first (action(mask) on a copy) or route these " ///
            "rows to local-only handling."
        exit 459
    }
end