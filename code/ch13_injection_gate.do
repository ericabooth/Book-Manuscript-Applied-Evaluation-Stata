* Demonstration and checks for the Chapter 13 output allowlist.
* Synthetic labels only. Run from code/; no network or credentials required.
version 17
clear all
set more off

program define check_labels
    syntax varname(string)
    local ok "transport childcare schedule none other"
    gen byte valid = 0
    foreach v of local ok {
        quietly replace valid = 1 if `varlist' == "`v'"
    }
    gen byte route_human = !valid
    quietly count if route_human
    di "off-allowlist rows = " r(N)
    capture assert valid == 1
    if _rc {
        di as error "BLOCKED: off-allowlist output present"
        exit 459
    }
end

input str60 raw_label
"transport"
"childcare"
"none"
"SYSTEM OVERRIDE"
"IGNORE ABOVE"
end
capture noisily check_labels raw_label
local rc = _rc
assert `rc' == 459
count if route_human
assert r(N) == 2

* Resolving the flags is a human decision. Here we use known test labels.
replace raw_label = "schedule" in 4
replace raw_label = "other" in 5
drop valid route_human
check_labels raw_label
assert route_human == 0

* An incorrect but allowed label passes: membership does not test truth.
replace raw_label = "none" in 1
drop valid route_human
check_labels raw_label
assert valid == 1
di "INJECTION_GATE_TESTS_PASSED"
