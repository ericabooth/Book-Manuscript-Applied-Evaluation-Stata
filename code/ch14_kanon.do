*==============================================================================*
* ch14_kanon.do  --  Chapter 14: sharing data and results safely
* Demonstrates re-identification risk on sysuse nlsw88, treated as an
* administrative caseload stand-in. Computes k-anonymity over four ordinary
* quasi-identifiers, shows how coarsening industry raises k, and illustrates
* primary + complementary small-cell suppression in a two-way table.
* Also builds the cell-size histogram (ch14_kdist.png).
*
* Globals: in the full project $figures comes from code/00_control.do. Defined
* here only if missing so this file also runs standalone.
*==============================================================================*
clear all
set more off
set seed 20260704   // no simulation here; fixed for reproducibility

if "$figures" == "" {
    global root "`c(pwd)'"
    global figures "$root/figures"
    capture mkdir "$figures"
}

*--- 1. Load the stand-in and count people per quasi-identifier cell -----------*
sysuse nlsw88, clear
di "N_TOTAL = " _N

* Four quasi-identifiers any partner file would plausibly carry.
egen cell = group(race married collgrad industry), missing
bysort cell: gen k = _N
label var k "people sharing this quasi-id cell"

quietly tabulate cell
di "DISTINCT_CELLS = " r(r)

*--- 2. The headline count: how many people are one of a kind? -----------------*
count if k==1
di "K1_PEOPLE = " r(N)

*--- 3. Bin cells by size and count both cells and people ----------------------*
gen kbin = 1 + (k>1) + (k>4) + (k>10)
label define kb 1 "k=1 (unique)" 2 "k=2-4" ///
    3 "k=5-10" 4 "k>10", replace
label values kbin kb

di "--- PEOPLE PER BIN ---"
tabulate kbin

preserve
    bysort cell: keep if _n==1
    di "--- CELLS PER BIN ---"
    tabulate kbin
restore

*--- 4. Coarsen industry to 3 groups, recount k=1 -----------------------------*
* Goods = Ag/Mining/Construction/Manufacturing; Services = trade through
* professional; Public = public administration.
recode industry (1/4=1 "Goods") ///
    (5/11=2 "Services") (12=3 "Public"), ///
    gen(ind3)
egen cell3 = group(race married collgrad ind3), missing
bysort cell3: gen k3 = _N

count if k3==1
di "K1_PEOPLE_COARSE = " r(N)
quietly tabulate cell3
di "DISTINCT_CELLS_COARSE = " r(r)

*--- 5. Two-way table for the suppression example -----------------------------*
* Restrict to the goods-producing sub-industries, where small cells appear:
* college graduates in Mining and Construction are the thin cells a public
* release must suppress. This is the table shown before/after in the text.
di "--- SUPPRESSION SOURCE TABLE (collgrad x goods industry) ---"
tabulate collgrad industry if industry<=4

* Demonstrate primary + complementary suppression with a tiny algorithm on the
* 2x4 goods table. Threshold: blank positive cells < 5 (primary). Then, in any row or
* column that has exactly one blank against a visible total, blank a second cell
* (complementary) so the total can no longer be differenced to the hidden value.
preserve
    keep if industry<=4
    contract collgrad industry, freq(n)
    fillin collgrad industry
    replace n = 0 if missing(n)
    gen byte primary = n > 0 & n < 5
    di "--- PRIMARY BLANKS (0<n<5) ---"
    list collgrad industry n if primary, clean noobs
    * Complementary pass: in any column with exactly one blanked cell, the
    * visible cell plus the column total reveals the blank, so blank the
    * smallest still-visible cell in that column too.
    bysort industry: egen colprim = total(primary)
    * In a 2-row column with exactly one primary blank, the single remaining
    * visible cell is recoverable from the column total, so blank it too.
    gen byte comp = (colprim==1 & !primary)
    di "--- COMPLEMENTARY BLANKS ---"
    list collgrad industry n if comp, clean noobs
    gen byte shown = !(primary | comp)
    di "--- FINAL SHOWN/BLANK GRID ---"
    list industry collgrad n shown, clean noobs sepby(industry)
restore

*--- 6. Figure: distribution of cell sizes (one dot per cell) ------------------*
* Plot how many CELLS have each size k. Truncate the long right tail at 30 so
* the dangerous small-k region is readable; the note states the truncation.
preserve
    bysort cell: keep if _n==1        // one row per distinct cell
    gen kplot = min(k, 30)
    label define ktop 30 "30+", replace
    histogram kplot, discrete frequency ///
        fcolor(navy%60) lcolor(navy) ///
        xlabel(0(5)30, labsize(small)) ///
        xtitle("Cell size k (people sharing the cell)", ///
            size(small)) ///
        ytitle("Number of cells", size(small)) ///
        title("Re-identification exposure: quasi-id cell sizes", ///
            size(medium)) ///
        note("Source: nlsw88 stand-in over race, married, collgrad, industry. Cells of 30+ people pooled at the right. The tall spike at small k is the re-identifiable mass.", ///
            size(vsmall)) ///
        graphregion(margin(l=2 r=6)) ysize(4) xsize(7.2)
    graph export "$figures/ch14_kdist.png", replace width(2400)
restore
di "FIGURE_SAVED"

di "DONE"

*==============================================================================*
* (r) rawsweep demo: manifest of a simulated intake folder, PII flagged
*==============================================================================*
adopath ++ "`c(pwd)'/rawsweep"
local dir "`c(tmpdir)'/ch14_intake"
capture mkdir "`dir'"
foreach f in referrals.csv notes.csv failed.csv {
    capture erase "`dir'/`f'"
}
file open h using "`dir'/referrals.csv", write replace
file write h "id,site,score" _n "1,3,12" _n "2,5,9" _n
file close h
file open h using "`dir'/notes.csv", write replace
file write h "id,note" _n `"1,"call 512-555-0173 re: schedule""' _n
file close h
file open h using "`dir'/failed.csv", write replace
file close h
rawsweep, directory("`dir'") pii clear
assert r(files) == 3
assert r(flagged) == 1
di "RAWSWEEP_DEMO_OK"


*==============================================================================*
* (s) Synthetic stand-in with synthgen: same quasi-identifiers plus wage,
*     rank-preserving copula draw, and fidelity and source-match diagnostics.
*     Numbers frozen in the chapter prose.
*==============================================================================*
adopath ++ "`c(pwd)'/../synthgen-stata-public"
sysuse nlsw88, clear
synthgen race married collgrad industry wage, frame(synth) seed(20260730)
local sg_maxdmean = r(maxdmean)
local sg_maxdrho  = r(maxdrho)
local sg_dupes    = r(dupes)
di "SYNTHGEN maxdmean = " %5.3f `sg_maxdmean' ///
   "  maxdrho = " %5.3f `sg_maxdrho' "  dupes = " `sg_dupes'
assert `sg_maxdmean' < 0.10
assert `sg_maxdrho'  < 0.15
frame synth: quietly count
assert r(N) == 2246

* Compare exact matches with their frequency in the source. A match to a
* unique or rare source combination deserves closer disclosure review.
preserve
keep race married collgrad industry wage
bysort race married collgrad industry wage: gen long source_n = _N
bysort race married collgrad industry wage: keep if _n == 1
capture frame drop sg_source_cells
frame put race married collgrad industry wage source_n, into(sg_source_cells)
restore
frame synth: frlink m:1 race married collgrad industry wage, ///
    frame(sg_source_cells) generate(_source_match)
frame synth: frget source_n, from(_source_match)
frame synth: quietly count if source_n == 1
local sg_unique_matches = r(N)
frame synth: quietly count if inrange(source_n, 1, 4)
local sg_rare_matches = r(N)
assert `sg_unique_matches' <= `sg_rare_matches'
assert `sg_rare_matches' <= `sg_dupes'
di "SYNTHGEN source matches: unique = " `sg_unique_matches' ///
   "  source frequency 1-4 = " `sg_rare_matches'
frame drop sg_source_cells
di "SYNTHGEN_DEMO_OK"
