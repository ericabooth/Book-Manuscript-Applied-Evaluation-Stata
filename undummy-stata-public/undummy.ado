*! undummy -- recombine a set of dummy/indicator variables into one categorical variable
*! version 1.1.0  06jul2026  Eric A. Booth, Sr Researcher, Texas 2036 (eric.a.booth@gmail.com)
*! version 1.0.0  09apr2017  Eric A. Booth
program define undummy, rclass sortpreserve
	version 16.0
	syntax varlist [if] [in] ///
		[, Generate(name) VALuelab(string) VARNames ///
		   NEWVALuelab(name) IGNORETYPE KEEPdummies CHECKdummies ]

	marksample touse, novarlist
	qui count if `touse'
	if r(N) == 0 {
		error 2000
	}

	* -- confirm there is room to add a working copy of each dummy ------
	local cc : word count `varlist'
	qui ds
	local cc0 : word count `r(varlist)'
	if `c(maxvar)' - (`cc' + `cc0') <= 0 {
		di as err "undummy: not enough room to add `cc' temporary working variables; increase {help maxvar:maxvar} and rerun"
		exit 900
	}

	* -- work on temporary clones so the originals are untouched on error
	local varlistoriginal `"`varlist'"'
	local varlist
	local i 0
	foreach a of local varlistoriginal {
		local ++i
		tempvar tv`i'
		qui clonevar `tv`i'' = `a'
		local varlist `varlist' `tv`i''
	}

	* -- detect variable types: dummies must be all numeric or all string
	local base : word 1 of `varlist'
	local baseformat = cond(substr("`:type `base''", 1, 3) == "str", 1, 0)
	local mixed 0
	local nv : word count `varlist'
	forvalues i = 2/`nv' {
		local j : word `i' of `varlist'
		local jformat = cond(substr("`:type `j''", 1, 3) == "str", 1, 0)
		if `jformat' != `baseformat' {
			local mixed 1
			if `"`ignoretype'"' == "" {
				local firstorig : word 1 of `varlistoriginal'
				local jorig : word `i' of `varlistoriginal'
				di as err "undummy: variable types in varlist are not consistent: {bf:`firstorig'} is `:type `base'' but {bf:`jorig'} is `:type `j''; see {stata describe `varlistoriginal'} or specify {bf:ignoretype}"
				exit 109
			}
		}
	}
	if `"`ignoretype'"' != "" & `mixed' {
		qui tostring `varlist', force replace
		local baseformat 1
	}

	* -- treat 0 (numeric) or "0"/" " (string) as "not in this category" -
	if `baseformat' == 0 {
		qui recode `varlist' (0 = .) if `touse'
	}
	else {
		foreach v of local varlist {
			qui replace `v' = "" if inlist(`v', "0", " ") & `touse'
		}
	}

	* -- every observation may have at most one dummy switched on -------
	tempvar check
	qui egen `check' = rownonmiss(`varlist') if `touse', strok
	qui su `check' if `touse', meanonly
	if r(max) > 1 {
		di as err "undummy: dummies are not mutually exclusive: at least one observation has more than one non-zero, non-missing value across varlist; see {stata describe `varlistoriginal'}"
		exit 459
	}
	if r(max) == 0 {
		di as err "undummy: no non-zero, non-missing values found in varlist within the sample"
		exit 2000
	}
	if `"`checkdummies'"' != "" {
		di as txt "undummy: check passed -- the dummies are mutually exclusive and can be combined into one categorical variable"
		exit
	}

	* -- combine the dummies into one categorical variable --------------
	if `"`generate'"' == "" local mz undummy
	else local mz `generate'
	cap confirm new variable `mz'
	if _rc {
		di as err "undummy: variable {bf:`mz'} already exists; specify a new name in {bf:generate()}"
		exit 110
	}
	qui egen `mz' = group(`varlist') if `touse', missing
	qui lab var `mz' "`mz'"
	local baselab : variable label `base'
	if `"`baselab'"' != "" qui lab var `mz' `"`baselab'"'

	* -- attach value labels ---------------------------------------------
	if `"`valuelab'"' != "" {
		cap lab val `mz' `valuelab'
		if `"`varnames'"' != "" | `"`newvaluelab'"' != "" {
			di as err "undummy: only one of {bf:valuelab()} or ({bf:varnames} / {bf:newvaluelab()}) may be specified; {bf:valuelab()} was applied"
		}
	}
	else if `"`varnames'"' != "" | `"`newvaluelab'"' != "" {
		local q 1
		local forlab
		foreach j of local varlist {
			local jorig : word `q' of `varlistoriginal'
			qui levelsof `mz' if !mi(`j') & `touse', local(jlev)
			if `:word count `jlev'' > 1 {
				di as err "undummy: dummy variable {bf:`jorig'} takes more than one non-zero value; values within each dummy must be constant to label the result"
				exit 459
			}
			if `"`jlev'"' != "" {
				if `"`varnames'"' != "" local yy `"`jorig'"'
				else local yy `"`jlev'"'
				local forlab `"`forlab' `jlev' `"`yy'"' "'
			}
			else {
				di as txt "undummy: note: {bf:`jorig'} is never switched on in the sample; no category or label was created for it"
			}
			local ++q
		}
		local fl undummylab_`mz'
		if `"`newvaluelab'"' != "" local fl `newvaluelab'
		cap lab def `fl' `forlab', modify
		if _rc {
			di as err "undummy: could not define value label {bf:`fl'}; {bf:`mz'} was created without value labels"
		}
		else {
			lab val `mz' `fl'
		}
	}

	* -- cleanup and stored results --------------------------------------
	if `"`keepdummies'"' == "" drop `varlistoriginal'
	qui su `mz' if `touse', meanonly
	return scalar k = r(max)
	return local generate `"`mz'"'
	return local base : word 1 of `varlistoriginal'
end
