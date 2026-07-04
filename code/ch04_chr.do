*==============================================================================*
* ch04_chr.do  --  Chapter 4: harvesting data when there is no API
* Downloads the County Health Rankings 2024 analytic file (a plain CSV at a
* stable per-year URL: no API, no key), cleans the label row and the munged
* variable names, keeps Texas counties, and builds (a) a premature-death vs
* child-poverty scatter and (b) a five-highest-need-counties table.
*==============================================================================*

* Paths: in the full project these come from code/00_control.do. They are
* defined here (only if missing) so this file also runs standalone.
if "$raw" == "" {
    global root "`c(pwd)'"
    global raw     "$root/raw"
    global clean   "$root/clean"
    global figures "$root/figures"
    foreach f in raw clean figures {
        capture mkdir "${`f'}"
    }
}

*--- 1. Download: one stable per-year URL, one -copy- -------------------------*
local site "https://www.countyhealthrankings.org"
local path "sites/default/files/media/document"
capture confirm file "$raw/chr2024.csv"
if _rc {
    copy "`site'/`path'/analytic_data2024.csv" ///
         "$raw/chr2024.csv", replace
}
di "DOWNLOAD_OK"

*--- 2. Import and inspect the damage ------------------------------------------*
import delimited "$raw/chr2024.csv", clear varnames(1)
di "IMPORT_OK  vars = " c(k) "  obs = " _N

* The file's first data row is a second, machine-readable label row, so every
* column imports as a string. Look at it, then drop it.
list statefipscode countyfipscode name in 1/3, clean noobs

* BEFORE: the names Stata munged from the long header phrases
describe prematuredeathrawvalue childreninpovertyrawvalue ///
    uninsuredrawvalue medianhouseholdincomerawvalue

drop in 1            // the label row
di "LABELROW_DROPPED  obs = " _N

*--- 3. Rename the munged names, keep what we need -----------------------------*
rename prematuredeathrawvalue        yrslost
rename childreninpovertyrawvalue     childpov
rename uninsuredrawvalue             uninsured
rename medianhouseholdincomerawvalue hhincome
rename digitfipscode                 fips
rename stateabbreviation             state

keep fips state name yrslost childpov uninsured hhincome
destring yrslost childpov uninsured hhincome, replace

* AFTER: short names, numeric storage, original labels intact
describe yrslost childpov uninsured hhincome

*--- 4. Keep Texas: grab the state row's official values, then counties only ---*
* CHR ships national and state rows too (county FIPS "000"); use the Texas
* state row for the figure's reference lines instead of recomputing a mean.
summarize yrslost if state=="TX" & name=="Texas"
local tx_yrslost = r(mean)
summarize childpov if state=="TX" & name=="Texas"
local tx_childpov = 100*r(mean)

keep if state=="TX" & name!="Texas"
di "TX_COUNTIES  obs = " _N
assert _N==254

* Child poverty and uninsured arrive as proportions; report in percent.
replace childpov  = 100*childpov
replace uninsured = 100*uninsured
di "TX statewide: yrslost = " %6.0fc `tx_yrslost' ///
   "  childpov = " %4.1f `tx_childpov'

* CHR suppresses estimates too unstable to publish; count what we lost.
count if missing(yrslost)
di "MISSING_YRSLOST = " r(N)

*--- 5. A simple need index and the five highest-need counties ------------------*
egen zd = std(yrslost)
egen zp = std(childpov)
gen need = (zd + zp)/2
label var need "mean of z(yrslost) and z(childpov)"

gen cname = subinstr(name, " County", "", 1)
gsort -need
format yrslost %8.0fc
format childpov uninsured %4.1f
list cname yrslost childpov uninsured in 1/5, clean noobs

save "$clean/chr2024_tx.dta", replace

*--- 6. The payoff figure: premature death vs child poverty --------------------*
gen mlab = cname if _n<=5      // label only the five highest-need counties
scatter yrslost childpov, ///
    msymbol(Oh) mcolor(navy%60) ///
    mlabel(mlab) mlabsize(vsmall) mlabcolor(maroon) mlabpos(9) ///
    xline(`tx_childpov', lpattern(dash) lcolor(gs8)) ///
    yline(`tx_yrslost',  lpattern(dash) lcolor(gs8)) ///
    xlabel(0(10)50, format(%2.0f)) ///
    xtitle("Children in poverty (%)", size(small)) ///
    ytitle("Years of life lost before 75, per 100,000", size(small)) ///
    title("Premature death vs child poverty, Texas counties, 2024", ///
        size(medium)) ///
    note("Source: County Health Rankings 2024 analytic file. Dashed lines mark the official statewide values.", ///
        size(vsmall)) ///
    graphregion(margin(l=2 r=6)) ysize(4) xsize(7.2)
graph export "$figures/ch04_chr_scatter.png", replace width(2400)
di "FIGURE_SAVED"

di "DONE"
