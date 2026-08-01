*===============================================================
* 500_aggregation.do -- VendorFeed
* Single job: build the aggregated/collapsed tables the analysis
* needs (e.g., one row per unit-period), written to $cleaned.
*===============================================================
* Globals come from 000_control.do -- run that first.

use "$cleaned/VendorFeed_analytic.dta", clear

* Typical shape of this step:
* collapse (mean) , by()
* save "$cleaned/VendorFeed_agg.dta", replace
