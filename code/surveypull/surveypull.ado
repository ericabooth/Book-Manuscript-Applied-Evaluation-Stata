*! version 1.0.0  Eric A. Booth  28jul2026
*! surveypull: platform-aware survey downloads built on webapi (REDCap live; Qualtrics dry-run)
program define surveypull, rclass
    version 16.0
    gettoken sub 0 : 0, parse(" ,")
    if !inlist("`sub'", "redcap", "qualtrics") {
        di as error "surveypull: first word must be {bf:redcap} or {bf:qualtrics}"
        exit 198
    }

    if "`sub'" == "redcap" {
        syntax , URL(string) TOKen(string) [CONtent(string) SAVing(string) DRYrun replace]
        if "`content'" == "" local content record
        local body "token=`token'&content=`content'&format=csv"
        local cmd `"webapi post using "`url'", body("`body'")"'
        if `"`saving'"' != "" local cmd `"`cmd' saving("`saving'"`=cond("`replace'"!="",", replace","")')"'
        return local cmd `"`cmd'"'
        if "`dryrun'" != "" {
            di as txt "surveypull (dry run): the call it would make:"
            di as res `"  `cmd'"'
            exit
        }
        capture which webapi
        if _rc {
            di as error "surveypull: needs {bf:webapi} " ///
                "(net install from the authors' GitHub); or add {bf:dryrun}"
            exit 111
        }
        `cmd'
        return scalar N = _N
        di as txt "surveypull: " as res _N as txt " records pulled from REDCap"
    }

    if "`sub'" == "qualtrics" {
        syntax , DATAcenter(string) TOKen(string) SURvey(string) [DRYrun]
        local base "https://`datacenter'.qualtrics.com/API/v3/surveys/`survey'/export-responses"
        local c1 `"webapi post using "`base'", body({"format":"csv"}) headers(X-API-TOKEN:`token')"'
        local c2 `"webapi get using "`base'/{progressId}", headers(X-API-TOKEN:`token')"'
        local c3 `"curl -OJ -H "X-API-TOKEN: `token'" "`base'/{fileId}/file"   (returns a zip)"'
        return local cmd1 `"`c1'"'
        return local cmd2 `"`c2'"'
        return local cmd3 `"`c3'"'
        di as txt "surveypull (Qualtrics is a three-step export;" ///
            " dry run prints the exact calls):"
        di as txt "  1. request the export:"
        di as res `"     `c1'"'
        di as txt "  2. poll until percentComplete = 100, using the progressId step 1 returns:"
        di as res `"     `c2'"'
        di as txt "  3. download the finished file, using the fileId step 2 returns:"
        di as res `"     `c3'"'
        di as txt "surveypull runs steps for you once Stata-side zip download" ///
            " lands in webapi; today it hands you the calls."
        if "`dryrun'" == "" di as txt "(nothing was sent: Qualtrics support is dry-run only in this version)"
    }
end