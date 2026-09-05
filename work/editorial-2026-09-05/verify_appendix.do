version 18
clear all
set more off
use "/Users/ericbooth/Library/CloudStorage/GoogleDrive-eric.booth@texas2036.org/My Drive/BookExamples/221043-V2/output_2022/prams22_master.dta", clear
assert _N == 32
pwcorr dep_before smoke_before
regress dep_before ins_none_before
regress dep_before ins_none_before smoke_before
regress dep_before ins_none_before smoke_before ins_medicaid_before
use "/Users/ericbooth/Library/CloudStorage/GoogleDrive-eric.booth@texas2036.org/My Drive/BookExamples/edc-3.0-texas/analytic_performance.dta", clear
count
summarize proficientorabove_percent year
isid panel_id year
xtset panel_id year
foreach sub in ela math {
    xtreg proficientorabove_percent redesign if subject == "`sub'" & inrange(year, 2021, 2024), fe vce(cluster stateassignedschid)
    display "CHECK `sub' 2021-2024 pp = " 100*_b[redesign]
    xtreg proficientorabove_percent redesign if subject == "`sub'" & inrange(year, 2018, 2024), fe vce(cluster stateassignedschid)
    display "CHECK `sub' 2018-2024 pp = " 100*_b[redesign]
}
display "APPENDIX VERIFICATION COMPLETE"
