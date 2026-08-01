*===============================================================
* 600_analysis.do -- CarPrices
* Single job: the analysis itself -- models, estimates, and the
* tables/figures for the deliverable, written to $output.
*===============================================================
* Globals come from 000_control.do -- run that first.

use "$cleaned/CarPrices_analytic.dta", clear

* Suggested per-run log (dated, so runs never overwrite):
* log using "$output/600_analysis_$S_DATE.log", replace text

* ... regress / logit / margins / graph / collect export ...
* graph export "$output/fig01.png", replace width(2400)

* capture log close
