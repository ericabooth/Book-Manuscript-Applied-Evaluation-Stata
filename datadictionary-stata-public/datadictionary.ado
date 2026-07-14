*! version 1.0.0  20260714  Eric A. Booth, Sr Researcher, Texas 2036
*! datadictionary: enhanced, over-time-ready codebook generator (a modern descsave)
*
*  version 16.0 is the floor the package is tested against; no feature above
*  that baseline is required.  The caller's data are preserved and restored
*  untouched in both modes (restore happens automatically at program exit).

program define datadictionary, rclass
    version 16.0

    syntax [varlist(default=none)] [if] [in] [,          ///
        WAve(varname) FILes(string) FOLder(string)       ///
        PATtern(string) WAVENames(string)                ///
        EXcel(string) SAVing(string) REPlace             ///
        DOfile(string) DICTionary(string) NORECast       ///
        EXAMples(integer 3) TOP(integer 5)               ///
        NOCHars NONotes ]

    * ---- option validation ---------------------------------------------------
    if `examples' < 1 {
        di as err "examples() must be a positive integer"
        exit 198
    }
    if `top' < 1 {
        di as err "top() must be a positive integer"
        exit 198
    }
    if `"`files'"' != "" & `"`folder'"' != "" {
        di as err "files() and folder() may not be combined; use one or the other"
        exit 198
    }
    if `"`pattern'"' != "" & `"`folder'"' == "" {
        di as err "pattern() requires folder()"
        exit 198
    }
    local filesmode = (`"`files'"' != "" | `"`folder'"' != "")
    if !`filesmode' & `"`wavenames'"' != "" {
        di as err "wavenames() applies to files mode only; specify files() or folder()"
        exit 198
    }
    if `filesmode' {
        if "`wave'" != "" {
            di as err "wave() applies to in-memory mode only; in files mode each file is a wave (name them with wavenames())"
            exit 198
        }
        if `"`if'`in'"' != "" | "`varlist'" != "" {
            di as err "varlist, if, and in apply to in-memory mode only"
            exit 198
        }
    }

    * ---- output file names, checked before any work ---------------------------
    if `"`excel'"' != "" {
        if lower(substr(`"`excel'"', -5, .)) != ".xlsx" local excel `"`excel'.xlsx"'
        if "`replace'" == "" {
            capture confirm new file `"`excel'"'
            if _rc {
                di as err `"excel file `excel' already exists; specify the replace option"'
                exit 602
            }
        }
    }
    if `"`saving'"' != "" {
        if lower(substr(`"`saving'"', -4, .)) != ".dta" local saving `"`saving'.dta"'
        if "`replace'" == "" {
            capture confirm new file `"`saving'"'
            if _rc {
                di as err `"saving file `saving' already exists; specify the replace option"'
                exit 602
            }
        }
    }

    * ---- resolve the file list (files mode) ------------------------------------
    local nfiles 0
    if `"`folder'"' != "" {
        if `"`pattern'"' == "" local pattern "*.dta"
        if substr(`"`folder'"', -1, .) == "/" {
            local folder = substr(`"`folder'"', 1, strlen(`"`folder'"') - 1)
        }
        local fnames : dir `"`folder'"' files `"`pattern'"'
        local fnames : list sort fnames
        foreach f of local fnames {
            local ++nfiles
            local file`nfiles' `"`folder'/`f'"'
        }
        if `nfiles' == 0 {
            di as err `"no files in folder(`folder') match pattern(`pattern')"'
            exit 601
        }
    }
    else if `"`files'"' != "" {
        local rest `"`files'"'
        gettoken f rest : rest
        while `"`f'"' != "" {
            local ++nfiles
            local file`nfiles' `"`f'"'
            gettoken f rest : rest
        }
    }
    if `filesmode' {
        forvalues i = 1/`nfiles' {
            confirm file `"`file`i''"'
        }
        * wave names: wavenames() tokens, else the file basename minus .dta
        local nwn 0
        local restwn `"`wavenames'"'
        gettoken w restwn : restwn
        while `"`w'"' != "" {
            local ++nwn
            local wn`nwn' `"`w'"'
            gettoken w restwn : restwn
        }
        if `nwn' > 0 & `nwn' != `nfiles' {
            di as err "wavenames() lists `nwn' names for `nfiles' files"
            exit 198
        }
        if `nwn' == 0 {
            forvalues i = 1/`nfiles' {
                local bn `"`file`i''"'
                local sl = strrpos(`"`bn'"', "/")
                if `sl' > 0 local bn = substr(`"`bn'"', `sl' + 1, .)
                local dt = strrpos(`"`bn'"', ".")
                if `dt' > 0 local bn = substr(`"`bn'"', 1, `dt' - 1)
                local wn`i' `"`bn'"'
            }
        }
        local nw = `nfiles'
    }

    * ---- in-memory mode: sample selection ---------------------------------------
    if !`filesmode' {
        if "`varlist'" == "" {
            if c(k) == 0 {
                di as err "no variables to document: the dataset in memory is empty and no files() or folder() was specified"
                exit 2000
            }
            unab varlist : _all
        }
        marksample touse, novarlist strok
        quietly count if `touse'
        if r(N) == 0 {
            di as err "no observations selected by the varlist/if/in restriction"
            exit 2000
        }
    }

    * ---- everything below runs on scratch copies; the caller's data are
    * ---- restored automatically when the program exits --------------------------
    capture preserve
    local srcname = cond(`"`c(filename)'"' == "", "data in memory", `"`c(filename)'"')

    tempname MH VH GH CH
    tempfile MAIN VLAB GRID CHG SIG GRIDW
    postfile `MH' int wavenum str80 wave str32 name str12 type str49 format ///
        str80 varlab str32 vallab double n double pctmiss double distinct   ///
        double mean double sd double min double p50 double max              ///
        str2000 examples str2000 notes str2000 srctag str2000 chars         ///
        using `MAIN'
    postfile `VH' int wavenum str32 lname double value str2000 label using `VLAB'

    local totnotes 0

    * ============================ FILES MODE ======================================
    if `filesmode' {
        forvalues i = 1/`nfiles' {
            quietly use `"`file`i''"', clear
            local N`i' = _N
            _dd_rows, mh(`MH') wavenum(`i') wave(`"`wn`i''"')  ///
                examples(`examples') top(`top') `nochars' `nonotes'
            local k`i' = r(k)
            local totnotes = `totnotes' + r(nnotes)
            local lbls `"`r(lblnames)'"'
            if `"`lbls'"' != "" {
                quietly uselabel `lbls', clear
                forvalues r = 1/`=_N' {
                    local ln = lname[`r']
                    local vv = value[`r']
                    local lt = substr(label[`r'], 1, 2000)
                    post `VH' (`i') ("`ln'") (`vv') (`"`lt'"')
                }
            }
        }
    }

    * =========================== IN-MEMORY MODE ===================================
    else {
        quietly keep if `touse'
        local keepvars `varlist'
        if "`wave'" != "" local keepvars : list keepvars | wave
        quietly keep `keepvars'
        local NKEPT = _N

        * wave levels and labels (before any sorting inside the harvester)
        local nw 0
        if "`wave'" != "" {
            capture confirm string variable `wave'
            local strwave = (_rc == 0)
            quietly levelsof `wave', local(wlevs)
            local wvallab : value label `wave'
            foreach L of local wlevs {
                local ++nw
                if `strwave' local wn`nw' `"`L'"'
                else if "`wvallab'" != "" {
                    local wn`nw' : label (`wave') `L'
                }
                else local wn`nw' `"`L'"'
                local wlev`nw' `"`L'"'
            }
        }

        _dd_rows, mh(`MH') wavenum(0) wave("") vars(`varlist') ///
            examples(`examples') top(`top') `nochars' `nonotes'
        local kmem = r(k)
        local totnotes = r(nnotes)
        local lbls `"`r(lblnames)'"'

        * per-wave presence and missingness grid (in-memory wave mode).
        * presence = any nonmissing value in the wave; an all-missing variable
        * is reported "absent" because absent and never-answered cannot be
        * distinguished in a stitched file.
        if `nw' > 0 {
            postfile `GH' str32 name int wavenum str20 cell using `GRID'
            local gvars : list varlist - wave
            forvalues w = 1/`nw' {
                if `strwave' local wcond `"`wave' == `"`wlev`w''"'"'
                else local wcond `"`wave' == `wlev`w''"'
                quietly count if `wcond'
                local NW`w' = r(N)
                local kw`w' = 0
                foreach v of local gvars {
                    capture confirm string variable `v'
                    if _rc == 0 {
                        quietly count if `v' != "" & (`wcond')
                    }
                    else quietly count if !missing(`v') & (`wcond')
                    local nnw = r(N)
                    if `nnw' == 0 local cell "absent"
                    else if `NW`w'' > 0 {
                        local cell = strtrim(string(100 * (`NW`w'' - `nnw') / `NW`w'', "%6.1f"))
                    }
                    else local cell "absent"
                    if `nnw' > 0 local kw`w' = `kw`w'' + 1
                    post `GH' ("`v'") (`w') ("`cell'")
                }
            }
            postclose `GH'
        }

        * value labels attached to the documented variables
        if `"`lbls'"' != "" {
            quietly uselabel `lbls', clear
            forvalues r = 1/`=_N' {
                local ln = lname[`r']
                local vv = value[`r']
                local lt = substr(label[`r'], 1, 2000)
                post `VH' (0) ("`ln'") (`vv') (`"`lt'"')
            }
        }
    }

    postclose `MH'
    postclose `VH'

    quietly use `MAIN', clear
    local nvars = _N

    * ---- change detection across waves (files mode only: stitching waves into
    * ---- one file destroys per-wave value labels, so this cannot be done on a
    * ---- combined in-memory file) ------------------------------------------------
    local nchanges 0
    if `filesmode' {
        * one signature string per (wave, value-label set): "v=label | v=label"
        local havesig 0
        quietly use `VLAB', clear
        if _N > 0 {
            sort wavenum lname value
            quietly gen strL _p = string(value, "%13.0g") + "=" + label
            quietly by wavenum lname: gen strL _s = _p if _n == 1
            quietly by wavenum lname: replace _s = _s[_n - 1] + " | " + _p if _n > 1
            quietly by wavenum lname: keep if _n == _N
            quietly gen str2000 vsig = substr(_s, 1, 2000)
            keep wavenum lname vsig
            rename lname vallab
            quietly save `SIG'
            local havesig 1
        }
        quietly use `MAIN', clear
        if `havesig' {
            quietly merge m:1 wavenum vallab using `SIG', keep(1 3) ///
                keepusing(vsig) nogenerate
            quietly replace vsig = "" if vallab == ""
        }
        else quietly gen str1 vsig = ""
        tempfile MAINS
        quietly save `MAINS'

        postfile `CH' str80 wavepair str32 name str40 change ///
            str2000 before str2000 after using `CHG'
        forvalues i = 1/`= `nfiles' - 1' {
            local j = `i' + 1
            local wp `"`wn`i'' -> `wn`j''"'
            quietly use `MAINS', clear
            quietly keep if wavenum == `i'
            keep name type format varlab vallab vsig
            foreach x in type format varlab vallab vsig {
                rename `x' `x'0
            }
            tempfile A
            quietly save `A'
            quietly use `MAINS', clear
            quietly keep if wavenum == `j'
            keep name type format varlab vallab vsig
            quietly merge 1:1 name using `A'
            sort name
            forvalues r = 1/`=_N' {
                local nm = name[`r']
                if _merge[`r'] == 2 {
                    post `CH' (`"`wp'"') ("`nm'") ("variable dropped") ("") ("")
                }
                else if _merge[`r'] == 1 {
                    post `CH' (`"`wp'"') ("`nm'") ("variable added") ("") ("")
                }
                else {
                    foreach x in type format varlab {
                        local b = `x'0[`r']
                        local a = `x'[`r']
                        if `"`b'"' != `"`a'"' {
                            if "`x'" == "type"   local ct "storage type changed"
                            if "`x'" == "format" local ct "display format changed"
                            if "`x'" == "varlab" local ct "variable label changed"
                            post `CH' (`"`wp'"') ("`nm'") ("`ct'") (`"`b'"') (`"`a'"')
                        }
                    }
                    local lb = vallab0[`r']
                    local la = vallab[`r']
                    local sb = vsig0[`r']
                    local sa = vsig[`r']
                    if `"`lb'"' != `"`la'"' | `"`sb'"' != `"`sa'"' {
                        local btxt = cond(`"`lb'"' == "", "(none)", `"`lb': `sb'"')
                        local atxt = cond(`"`la'"' == "", "(none)", `"`la': `sa'"')
                        local btxt = substr(`"`btxt'"', 1, 2000)
                        local atxt = substr(`"`atxt'"', 1, 2000)
                        post `CH' (`"`wp'"') ("`nm'") ("value label set changed") ///
                            (`"`btxt'"') (`"`atxt'"')
                    }
                }
            }
        }
        postclose `CH'
        quietly use `CHG', clear
        local nchanges = _N
    }

    * ---- missingness grid, wide (files mode, or in-memory wave mode) --------------
    local havegrid 0
    if `filesmode' | `nw' > 0 {
        if `filesmode' {
            quietly use `MAIN', clear
            quietly keep name wavenum pctmiss
            quietly gen str20 cell = strtrim(string(pctmiss, "%6.1f"))
            quietly drop pctmiss
        }
        else quietly use `GRID', clear
        quietly reshape wide cell, i(name) j(wavenum)
        forvalues w = 1/`nw' {
            capture confirm variable cell`w'
            if _rc quietly gen str20 cell`w' = ""
            quietly replace cell`w' = "absent" if cell`w' == ""
            rename cell`w' w`w'
            label variable w`w' `"`wn`w''"'
        }
        label variable name "variable"
        sort name
        quietly save `GRIDW'
        local havegrid 1
    }

    * ---- display ---------------------------------------------------------------------
    di as txt _n "datadictionary 1.0.0"
    if `filesmode' {
        di as txt "  mode: " as res "files" as txt "    files: " as res `nfiles' ///
            as txt "    codebook rows: " as res `nvars'
        di as txt "  changes detected across waves: " as res `nchanges'
    }
    else {
        di as txt "  mode: " as res "in-memory" as txt "    source: " as res `"`srcname'"'
        di as txt "  observations: " as res `NKEPT' as txt "    variables documented: " as res `nvars'
        if `nw' > 0 di as txt "  waves (" as res "`wave'" as txt "): " as res `nw'
    }

    quietly use `MAIN', clear
    local lastw = -1
    forvalues r = 1/`=_N' {
        if wavenum[`r'] != `lastw' {
            local lastw = wavenum[`r']
            if `filesmode' {
                di as txt _n "{hline 78}"
                di as txt "wave " as res `"`wn`lastw''"' as txt ///
                    "  (N = " as res `N`lastw'' as txt ", variables = " as res `k`lastw'' as txt ")"
            }
            di as txt "{hline 78}"
            di as txt %-14s "name" %-9s "type" %-10s "format" ///
                %9s "N" %8s "miss%" %7s "dist" "  " "label"
            di as txt "{hline 78}"
        }
        local nm = name[`r']
        local ty = type[`r']
        local fm = format[`r']
        local vl = varlab[`r']
        di as res %-14s abbrev("`nm'", 13) as txt %-9s "`ty'" ///
            %-10s abbrev("`fm'", 9) as res %9.0f n[`r'] %8.1f pctmiss[`r'] ///
            %7.0f distinct[`r'] as txt "  " abbrev(`"`vl'"', 26)
    }
    di as txt "{hline 78}"

    if `filesmode' & `nchanges' > 0 {
        di as txt _n "Changes detected across waves:"
        quietly use `CHG', clear
        forvalues r = 1/`=_N' {
            local wp = wavepair[`r']
            local nm = name[`r']
            local ct = change[`r']
            local b  = before[`r']
            local a  = after[`r']
            di as txt "  " %-16s `"`wp'"' as res %-13s abbrev("`nm'", 12) ///
                as txt %-26s "`ct'" _c
            if `"`b'`a'"' != "" {
                di as txt "  " abbrev(`"`b'"', 24) " -> " abbrev(`"`a'"', 24)
            }
            else di ""
        }
    }

    if `havegrid' {
        di as txt _n "Per-wave % missing (" as res "absent" ///
            as txt " = not present in that wave, or never answered):"
        quietly use `GRIDW', clear
        di as txt %-14s "variable" _c
        forvalues w = 1/`nw' {
            di as txt %10s abbrev(`"`wn`w''"', 9) _c
        }
        di ""
        forvalues r = 1/`=_N' {
            local nm = name[`r']
            di as res %-14s abbrev("`nm'", 13) _c
            forvalues w = 1/`nw' {
                local cc = w`w'[`r']
                di as res %10s "`cc'" _c
            }
            di ""
        }
    }

    * ---- saving(): the machine-readable codebook -----------------------------------
    if `"`saving'"' != "" {
        quietly use `MAIN', clear
        if !`filesmode' quietly drop wave wavenum
        else order wave name, first
        label variable name     "variable name"
        label variable type     "storage type"
        label variable format   "display format"
        label variable varlab   "variable label"
        label variable vallab   "value-label name"
        label variable n        "N nonmissing"
        label variable pctmiss  "% missing"
        label variable distinct "distinct nonmissing values"
        label variable mean     "mean"
        label variable sd       "std. dev."
        label variable min      "minimum"
        label variable p50      "median"
        label variable max      "maximum"
        label variable examples "example values / top categories"
        label variable notes    "stored notes"
        label variable srctag   "char [srctag] (combineall/projectbuilder)"
        label variable chars    "other characteristics"
        if `filesmode' {
            label variable wave    "wave"
            label variable wavenum "wave order"
        }
        label data "datadictionary codebook: `srcname'"
        quietly compress
        quietly save `"`saving'"', replace
        di as txt _n "wrote " as res `"`saving'"'
    }

    * ---- excel(): multi-sheet workbook ------------------------------------------------
    if `"`excel'"' != "" {
        * Overview sheet (created first so it is the workbook's first sheet)
        putexcel set `"`excel'"', sheet("Overview") replace open
        putexcel A1 = "datadictionary codebook", bold
        putexcel A2 = "Generated"
        putexcel B2 = "`c(current_date)' `c(current_time)'"
        putexcel A3 = "Mode"
        local modestr = cond(`filesmode', "files", "in-memory")
        putexcel B3 = "`modestr'"
        putexcel A4 = "Source"
        if `filesmode' {
            local srclist ""
            forvalues i = 1/`nfiles' {
                local srclist `"`srclist'`file`i''; "'
            }
            local srclist = substr(`"`srclist'"', 1, max(1, strlen(`"`srclist'"') - 2))
            putexcel B4 = `"`srclist'"'
        }
        else putexcel B4 = `"`srcname'"'
        putexcel A5 = "Codebook rows"
        putexcel B5 = `nvars'
        putexcel A6 = "Variable notes harvested"
        putexcel B6 = `totnotes'
        local rr 7
        if `filesmode' {
            putexcel A`rr' = "Changes detected"
            putexcel B`rr' = `nchanges'
            local ++rr
        }
        local ++rr
        if `filesmode' | `nw' > 0 {
            putexcel A`rr' = "Wave", bold
            putexcel B`rr' = "N", bold
            putexcel C`rr' = "Variables", bold
            forvalues w = 1/`nw' {
                local ++rr
                putexcel A`rr' = `"`wn`w''"'
                if `filesmode' {
                    putexcel B`rr' = `N`w''
                    putexcel C`rr' = `k`w''
                }
                else {
                    putexcel B`rr' = `NW`w''
                    putexcel C`rr' = `kw`w''
                }
            }
        }
        else {
            putexcel A`rr' = "N", bold
            putexcel B`rr' = "Variables", bold
            local ++rr
            putexcel A`rr' = `NKEPT'
            putexcel B`rr' = `nvars'
        }
        putexcel save

        * Variables sheet
        quietly use `MAIN', clear
        quietly drop wavenum
        if !`filesmode' quietly drop wave
        if _N > 0 {
            quietly export excel using `"`excel'"', sheet("Variables") ///
                sheetreplace firstrow(variables)
        }
        _dd_bold, file(`"`excel'"') sheet("Variables")

        * ValueLabels sheet
        quietly use `VLAB', clear
        if `filesmode' {
            quietly gen str80 wave = ""
            forvalues w = 1/`nw' {
                quietly replace wave = `"`wn`w''"' if wavenum == `w'
            }
            order wave lname value label
        }
        quietly drop wavenum
        if _N > 0 {
            quietly export excel using `"`excel'"', sheet("ValueLabels") ///
                sheetreplace firstrow(variables)
        }
        _dd_bold, file(`"`excel'"') sheet("ValueLabels")

        * Changes sheet (files mode only: see the change-detection note above)
        if `filesmode' {
            quietly use `CHG', clear
            if _N > 0 {
                quietly export excel using `"`excel'"', sheet("Changes") ///
                    sheetreplace firstrow(variables)
            }
            _dd_bold, file(`"`excel'"') sheet("Changes")
        }

        * Missingness sheet (variable x wave grid of % missing)
        if `havegrid' {
            quietly use `GRIDW', clear
            if _N > 0 {
                quietly export excel using `"`excel'"', sheet("Missingness") ///
                    sheetreplace firstrow(varlabels)
            }
            _dd_bold, file(`"`excel'"') sheet("Missingness") labels
        }

        di as txt "wrote " as res `"`excel'"'
    }

    * ---- stored results -----------------------------------------------------------------
    return scalar nvars    = `nvars'
    return scalar nchanges = `nchanges'
    if `"`excel'"' != ""  return local xlsx `"`excel'"'
    if `"`saving'"' != "" return local dta `"`saving'"'
end


* ---------------------------------------------------------------------------
* _dd_rows: harvest one codebook row per variable of the dataset in memory
* and post it to the main postfile.  Returns r(k) (variables documented),
* r(nnotes) (variable notes seen), and r(lblnames) (value labels attached).
* The routine sorts the data while computing distinct counts and example
* values; callers must not rely on row order afterward.
* ---------------------------------------------------------------------------
program define _dd_rows, rclass
    version 16.0
    syntax , MH(name) WAVENUM(integer) EXAMPLES(integer) TOP(integer) ///
        [ WAVE(string) VARS(string) NOCHARS NONOTES ]

    if `"`vars'"' == "" unab vars : _all
    local NT = _N
    local wavelab = substr(`"`wave'"', 1, 80)
    local nnotes 0
    local lblnames ""
    local k 0

    foreach v of local vars {
        local ++k
        local ty : type `v'
        local fm : format `v'
        local vl : variable label `v'
        local ll : value label `v'
        if "`ll'" != "" local lblnames `lblnames' `ll'
        local isstr = (strpos("`ty'", "str") == 1)

        * N nonmissing and % missing
        if `isstr' quietly count if `v' != ""
        else quietly count if !missing(`v')
        local nn = r(N)
        local pctm = cond(`NT' > 0, 100 * (`NT' - `nn') / `NT', .)

        * distinct nonmissing values
        local dist 0
        if `nn' > 0 {
            tempvar tg
            if `isstr' {
                quietly bysort `v': gen byte `tg' = (_n == 1 & `v' != "")
            }
            else quietly bysort `v': gen byte `tg' = (_n == 1 & !missing(`v'))
            quietly count if `tg'
            local dist = r(N)
            drop `tg'
        }

        * numeric summary statistics (blank for strings)
        local mn .
        local sd .
        local mi .
        local md .
        local mx .
        if !`isstr' & `nn' > 0 {
            quietly summarize `v', detail
            local mn = r(mean)
            local sd = r(sd)
            local mi = r(min)
            local md = r(p50)
            local mx = r(max)
        }

        * example values: distinct examples for strings; top categories by
        * frequency, as "label (n, pct%)", for value-labeled variables
        local ex ""
        if `isstr' & `nn' > 0 {
            sort `v'
            local ct 0
            local last ""
            local o 1
            while `ct' < `examples' & `o' <= `NT' {
                local cur = `v'[`o']
                if `"`cur'"' != "" & `"`cur'"' != `"`last'"' {
                    local ++ct
                    if `ct' == 1 local ex `"`cur'"'
                    else local ex `"`ex', `cur'"'
                    local last `"`cur'"'
                }
                local ++o
            }
        }
        else if "`ll'" != "" & `nn' > 0 {
            tempname F R
            capture quietly tabulate `v', sort matcell(`F') matrow(`R')
            if _rc == 0 {
                local tot = r(N)
                local take = min(`top', rowsof(`R'))
                forvalues j = 1/`take' {
                    local vv = `R'[`j', 1]
                    local ff = `F'[`j', 1]
                    local pc = strtrim(string(100 * `ff' / `tot', "%5.1f"))
                    capture local lb : label (`v') `vv'
                    if _rc local lb "`vv'"
                    if `j' == 1 local ex `"`lb' (`ff', `pc'%)"'
                    else local ex `"`ex', `lb' (`ff', `pc'%)"'
                }
            }
        }
        local ex = substr(`"`ex'"', 1, 2000)

        * stored notes
        local ntxt ""
        if "`nonotes'" == "" {
            local k0 : char `v'[note0]
            capture local k0 = int(real("`k0'"))
            if "`k0'" == "" | "`k0'" == "." local k0 0
            forvalues j = 1/`k0' {
                local t : char `v'[note`j']
                if `j' == 1 local ntxt `"`j'. `t'"'
                else local ntxt `"`ntxt' | `j'. `t'"'
            }
            local nnotes = `nnotes' + `k0'
            local ntxt = substr(`"`ntxt'"', 1, 2000)
        }

        * characteristics: srctag in its own column, all others concatenated
        local st ""
        local ch ""
        if "`nochars'" == "" {
            local st : char `v'[srctag]
            local st = substr(`"`st'"', 1, 2000)
            local allc : char `v'[]
            foreach c of local allc {
                if "`c'" == "srctag" continue
                if regexm("`c'", "^note[0-9]+$") | "`c'" == "note0" continue
                local cv : char `v'[`c']
                if `"`ch'"' == "" local ch `"`c'=`cv'"'
                else local ch `"`ch'; `c'=`cv'"'
            }
            local ch = substr(`"`ch'"', 1, 2000)
        }

        post `mh' (`wavenum') (`"`wavelab'"') ("`v'") ("`ty'") ("`fm'")   ///
            (`"`vl'"') ("`ll'") (`nn') (`pctm') (`dist')                  ///
            (`mn') (`sd') (`mi') (`md') (`mx')                            ///
            (`"`ex'"') (`"`ntxt'"') (`"`st'"') (`"`ch'"')
    }

    local lblnames : list uniq lblnames
    return local lblnames `lblnames'
    return scalar nnotes = `nnotes'
    return scalar k = `k'
end


* ---------------------------------------------------------------------------
* _dd_bold: bold the header row of one sheet via putexcel.  Headers come from
* the dataset in memory (variable names, or variable labels with -labels-).
* putexcel creates the sheet when it does not exist yet, so this also writes
* header-only sheets for empty tables.
* ---------------------------------------------------------------------------
program define _dd_bold
    version 16.0
    syntax , FILE(string) SHEET(string) [ LABels ]
    unab allv : _all
    local k : word count `allv'
    putexcel set `"`file'"', sheet("`sheet'") modify open
    forvalues c = 1/`k' {
        local v : word `c' of `allv'
        if "`labels'" != "" {
            local h : variable label `v'
            if `"`h'"' == "" local h "`v'"
        }
        else local h "`v'"
        if `c' <= 26 local L = char(64 + `c')
        else local L = char(64 + int((`c' - 1) / 26)) + char(65 + mod(`c' - 1, 26))
        putexcel `L'1 = `"`h'"', bold
    }
    putexcel save
end
