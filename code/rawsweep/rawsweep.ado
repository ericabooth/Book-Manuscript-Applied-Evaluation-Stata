*! version 1.0.0  Eric A. Booth  28jul2026
*! rawsweep: manifest of an intake folder, with a PII flag per file
program define rawsweep, rclass
    version 16.0
    syntax , DIRectory(string) [PATterns(string) PII SAMple(integer 25) SAVing(string) replace clear]

    if _N > 0 & "`clear'" == "" {
        di as error "rawsweep builds the manifest as the dataset in memory;" ///
            " add {bf:clear} to discard the current data"
        exit 4
    }

    if "`patterns'" == "" local patterns "*.csv *.txt"
    capture confirm file `"`directory'/."'
    if _rc {
        di as error `"rawsweep: directory not found: `directory'"'
        exit 601
    }

    local allfiles ""
    foreach pat of local patterns {
        local these : dir `"`directory'"' files "`pat'"
        foreach f of local these {
            local allfiles `"`allfiles' "`f'""'
        }
    }
    local nf : word count `allfiles'
    if `nf' == 0 {
        di as txt "rawsweep: no files matching (`patterns') in `directory'"
        return scalar files = 0
        return scalar flagged = 0
        exit
    }

    clear
    quietly {
        set obs `nf'
        gen str200 filename = ""
        gen str12  ext      = ""
        gen double bytes    = .
        gen long   pii_hits = .
    }
    local i = 0
    local totflag = 0
    foreach f of local allfiles {
        local ++i
        quietly replace filename = `"`f'"' in `i'
        quietly replace ext = lower(substr(`"`f'"', strrpos(`"`f'"', ".") + 1, .)) in `i'
        local fpath `"`directory'/`f'"'
        quietly checksum `"`fpath'"'
        quietly replace bytes = r(filelen) in `i'
        if "`pii'" != "" {
            local hh 0
            mata: st_local("hh", strofreal(_rawsweep_scan(st_local("fpath"), `sample')))
            quietly replace pii_hits = `hh' in `i'
            if `hh' > 0 local ++totflag
        }
    }
    label variable filename "file in intake folder"
    label variable bytes    "size in bytes"
    if "`pii'" != "" label variable pii_hits "sampled rows with likely PII"

    di as txt _n "rawsweep: " as res `nf' as txt " file(s) in " as res `"`directory'"'
    quietly summarize bytes
    di as txt "  smallest " as res %12.0fc r(min) as txt "  largest " ///
        as res %12.0fc r(max) as txt " bytes"
    quietly count if bytes == 0
    if r(N) > 0 di as txt "  " as res r(N) as txt " zero-byte file(s):" ///
        " failed downloads wearing success flags"
    if "`pii'" != "" {
        di as txt "  files with likely PII in the first `sample' rows: " ///
            as res `totflag'
        if `totflag' > 0 di as txt "  route those through the privacy gate" ///
            " before anything else touches them."
    }

    if `"`saving'"' != "" {
        quietly export delimited using `"`saving'"', `replace'
        di as txt "  manifest written to " as res `"`saving'"'
    }
    return scalar files   = `nf'
    return scalar flagged = `totflag'
end

version 16.0
mata:
real scalar _rawsweep_scan(string scalar path, real scalar maxrows)
{
    real scalar fh, i, j, hits, hit
    string scalar line
    string rowvector pats
    pats = ("[0-9]{3}-[0-9]{2}-[0-9]{4}",
            "(\+?1[-\. ])?\(?[0-9]{3}\)?[-\. ][0-9]{3}[-\. ][0-9]{4}",
            "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}",
            "\b(0?[1-9]|1[0-2])[/-](0?[1-9]|[12][0-9]|3[01])[/-](19|20)[0-9]{2}\b",
            "(?i)\b[0-9]{1,5} [A-Za-z]+( [A-Za-z]+)? (Street|St|Avenue|Ave|Road|Rd|Drive|Dr|Lane|Ln|Boulevard|Blvd|Court|Ct)\b",
            "(?i)\b(MRN|SSN|ID|Case)[#: ]+[0-9]{4,}\b")
    fh = _fopen(path, "r")
    if (fh < 0) return(0)
    hits = 0
    for (i = 1; i <= maxrows; i++) {
        line = fget(fh)
        if (line == J(0,0,"")) break
        hit = 0
        for (j = 1; j <= cols(pats); j++) {
            if (ustrregexm(line, pats[j])) hit = 1
        }
        hits = hits + hit
    }
    fclose(fh)
    return(hits)
}
end