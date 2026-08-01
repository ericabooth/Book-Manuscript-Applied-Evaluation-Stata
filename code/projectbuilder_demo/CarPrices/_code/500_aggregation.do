*===============================================================
* 500_aggregation.do -- CarPrices
* Single job: build the aggregated/collapsed tables the analysis
* needs (e.g., one row per unit-period), written to $cleaned.
*===============================================================
* Globals come from 000_control.do -- run that first.

use "$cleaned/CarPrices_analytic.dta", clear

* Typical shape of this step:
* collapse (mean) price, by(foreign)
* save "$cleaned/CarPrices_agg.dta", replace
