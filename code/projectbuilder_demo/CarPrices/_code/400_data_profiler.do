*===============================================================
* 400_data_profiler.do -- CarPrices
* Single job: profile the analytic file -- distributions of the
* outcome variables, optionally broken down by the -over- variables.
*===============================================================
* Globals come from 000_control.do -- run that first.

use "$cleaned/CarPrices_analytic.dta", clear

local outcomes "price"   // recorded from outcomes(); edit freely
local over     "foreign"   // recorded from over(); edit freely

* -table, statistic()- is the Stata 17 syntax.  000_control.do pins
* -version 16.0-, this package's floor, so this file has to work under
* that pin too: under 16 the statistic() option is a syntax error.
* c(stata_version) is the RUNNING release, which is what decides.
local newtable = (c(stata_version) >= 17)

foreach y of local outcomes {
    capture confirm variable `y'
    if _rc continue          // silently skip vars not in this file
    summarize `y', detail
    foreach g of local over {
        capture confirm variable `g'
        if _rc continue
        if `newtable' {
            version 17: table `g', statistic(mean `y') statistic(count `y')
        }
        else {
            tabstat `y', by(`g') statistics(mean count)
        }
    }
}
