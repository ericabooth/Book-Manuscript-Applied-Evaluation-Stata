*==============================================================================*
* ch06_longitudinal.do  --  Chapter 6: longitudinal data you can trust
* Builds three things the chapter needs from real/simulated data:
*   (1) xtset / xtdescribe on the shipped nlswork panel  (verbatim excerpt)
*   (2) a wage-quartile transition matrix                (real numbers -> table)
*   (3) percent-missing-by-variable bar chart, ~200 obs  (ch06_missmap.png)
*   (4) a tiny fuzzy-merge demo: soundex + birth-year blocking on two
*       simulated rosters, with an honest note that Jaro-Winkler lives in SSC.
*
* Globals note: in the full project $figures comes from code/00_control.do.
* Defined here (only if missing) so this file also runs standalone.
*==============================================================================*

if "$figures" == "" {
    global root "`c(pwd)'"
    global figures "$root/figures"
    capture mkdir "$figures"
}

set seed 20260704
set linesize 66

*=============================================================================*
* (1) A shipped panel: xtset and xtdescribe                                    *
*=============================================================================*
* nlswork ships with Stata: young women followed across survey years, the
* textbook panel. -xtset- declares the panel (id) and time (year) dimensions;
* -xtdescribe- reports its shape and how balanced it is.
webuse nlswork, clear
xtset idcode year
xtdescribe

*=============================================================================*
* (2) Wage-quartile transition matrix                                          *
*=============================================================================*
* Where do workers go? Cut real wage into within-year quartiles, then compare
* each worker's quartile now with her quartile at the next observation. The
* row-percent table is a Markov transition matrix: read across a row to see
* where workers who started in that quartile ended up.
gen lw = ln_wage
xtile wq = lw, nq(4)
bysort idcode (year): gen wq_next = wq[_n+1]
label define Q 1 "Q1 (low)" 2 "Q2" 3 "Q3" 4 "Q4 (high)"
label values wq wq_next Q
tab wq wq_next, row nofreq

*=============================================================================*
* (3) Missingness heatmap on ~200 sampled observations                         *
*=============================================================================*
* misstable reports the pattern (which variables go missing together); a
* sorted bar chart of percent missing per variable shows the magnitude at a
* glance. Sample ~200 rows so the percentages are stable but cheap to draw.
preserve
    keep idcode year ln_wage hours ///
         tenure union wks_ue msp
    sample 200, count
    misstable patterns ln_wage hours ///
        tenure union wks_ue msp, frequency

    * The pattern table above shows which variables go missing TOGETHER; this
    * bar chart shows how MUCH each is missing, the magnitude the pattern table
    * leaves off a common scale. Percent missing per variable -> a tiny dataset
    * -> a sorted horizontal bar.
    local vars ln_wage hours tenure union wks_ue msp
    tempname M
    tempfile mm
    postfile `M' str12 varname double pctmiss using `mm', replace
    foreach v of local vars {
        quietly count if missing(`v')
        post `M' ("`v'") (100*r(N)/_N)
    }
    postclose `M'
    use `mm', clear
    list varname pctmiss, clean noobs        // canonical numbers for the caption
    graph hbar (mean) pctmiss, ///
        over(varname, sort(1) descending) ///
        bar(1, color(maroon)) ///
        blabel(bar, format(%3.0f) size(small)) ///
        ytitle("percent of 200 sampled rows missing", ///
            size(small)) ///
        ylabel(0(10)30, labsize(small)) ///
        title("Where the gaps are: percent missing" ///
            "by variable", size(medium)) ///
        subtitle("nlswork panel, 200 sampled rows", ///
            size(small)) ///
        note("A 200-row sample (seed 20260704). The gaps" ///
            "concentrate in union and wks_ue; the other" ///
            "variables are complete or nearly so, so" ///
            "casewise deletion would drop rows on those" ///
            "two, not at random.", size(vsmall)) ///
        graphregion(margin(l=2 r=4)) ///
        ysize(4.2) xsize(7.2)
    graph export "$figures/ch06_missmap.png", ///
        replace width(2400)
    di "MISSMAP_SAVED"
restore

*=============================================================================*
* (4) Fuzzy merge: soundex + birth-year blocking on two tiny rosters           *
*=============================================================================*
* Two simulated files describe the same six people with no shared key: names
* are entered inconsistently and one birth year is a typo. We block on birth
* year and compare soundex codes within block. Soundex is built into Stata;
* it collapses a surname to a phonetic code so "Smith" meets "Smyth".
clear
input str12 lname_a int byear
"SMITH" 1975
"JOHNSON" 1980
"ZHANG" 1975
"OBRIEN" 1988
"GARCIA" 1990
"NGUYEN" 1980
end
gen sdx_a = soundex(lname_a)
gen id_a = _n
tempfile rosterA
save `rosterA'

clear
input str12 lname_b int byear
"SMYTHE" 1975
"JONSON" 1980
"CHANG" 1975
"O'BRIEN" 1988
"GARSIA" 1990
"WINGUYEN" 1981
end
* strip punctuation, uppercase, then soundex
gen clean_b = upper(subinstr(lname_b, "'", "", .))
gen sdx_b = soundex(clean_b)
gen id_b = _n
tempfile rosterB
save `rosterB'

* Block on birth year: -joinby- forms candidate pairs only among
* rows that agree on byear, so we never compare people born in
* different years. Then flag pairs whose soundex codes agree.
use `rosterA', clear
joinby byear using `rosterB'
gen soundex_hit = (sdx_a == sdx_b)
sort id_a id_b
di "Candidate pairs after birth-year blocking: " _N
list lname_a lname_b byear sdx_a sdx_b ///
    soundex_hit, clean noobs

* Accept a match when it survives both gates: same block AND same
* soundex code. NGUYEN never appears: its partner's birth year is
* a typo (1981 vs 1980), so blocking drops the true pair. That is
* the honest cost of blocking on a field that can be mistyped.
di "ACCEPTED matches (block AND soundex agree):"
list lname_a lname_b byear if soundex_hit==1, ///
    clean noobs

di "DONE"
