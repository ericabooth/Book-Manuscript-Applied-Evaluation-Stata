*! version 1.0.0  Eric A. Booth  28jul2026
*! srcfind: find variables by their srctag source lineage
program define srcfind, rclass
    version 16.0
    syntax [anything(name=pattern)] , [SOurce(string) All noREPort]

    if `"`source'"' == "" & `"`pattern'"' != "" local source `"`pattern'"'
    local found ""
    quietly ds
    foreach v of varlist `r(varlist)' {
        local s : char `v'[source]
        if `"`s'"' == "" continue
        if "`all'" == "" & !strmatch(lower(`"`s'"'), lower(`"*`source'*"')) continue
        local found "`found' `v'"
        if "`report'" != "noreport" {
            local vin : char `v'[source_vintage]
            if `"`vin'"' != "" {
                di as txt %-16s "`v'" as res `"`s'"' as txt " (" as res `"`vin'"' as txt ")"
            }
            else di as txt %-16s "`v'" as res `"`s'"'
        }
    }
    local found : list retokenize found
    if "`report'" != "noreport" & "`found'" == "" ///
        di as txt "srcfind: no variables match"
    local nf : word count `found'
    return local varlist "`found'"
    return scalar n = `nf'
end