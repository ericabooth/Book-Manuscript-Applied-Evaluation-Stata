*! version 1.0.0  Eric A. Booth  28jul2026
*! srctag: stamp variables with their source lineage in a characteristic
program define srctag, rclass
    version 16.0
    syntax varlist, SOurce(string) [Vintage(string) NOTEs(string) replace]

    local n = 0
    foreach v of varlist `varlist' {
        local cur : char `v'[source]
        if `"`cur'"' != "" & "`replace'" == "" {
            di as error `"srctag: `v' already carries source (`cur'); add replace to overwrite"'
            exit 110
        }
        char `v'[source] `"`source'"'
        if `"`vintage'"' != "" char `v'[source_vintage] `"`vintage'"'
        if `"`notes'"'   != "" char `v'[source_notes]   `"`notes'"'
        local ++n
    }
    local mani : char _dta[sources]
    if !strmatch(`"`mani'"', `"*`source'*"') {
        char _dta[sources] `"`mani'`=cond(`"`mani'"'=="","","; ")'`source'"'
    }
    di as txt "srctag: stamped " as res `n' as txt " variable(s) with source " ///
        as res `"`source'"'
    return scalar n = `n'
end