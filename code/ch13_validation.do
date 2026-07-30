*==============================================================================*
* ch13_validation.do  --  Chapter 13: using AI without getting burned
* (a) gold-standard validation: 150 hand labels vs ~85% model, Cohen's kappa
* (b) multi-model consensus: 3 models, agreement share, routing action
* (c) fairness audit: simulated risk scores + group offset, cutoff,
*     selection rates and the four-fifths ratio (faircheck's logic in 12 lines)
* (d) optional ch13_agreement.png: per-category agreement bar
* (e) prediction-powered inference: correct a biased machine-label prevalence
* ALL blocks are SIMULATED with seed 20260704 and labeled simulated in text.
*==============================================================================*
* Globals defined locally so this file runs standalone; in the full book
* project they are set once by code/00_control.do instead.
global root    "`c(pwd)'"
global figures "$root/figures"
capture mkdir "$figures"

version 19
clear all

*--- (a) Gold standard: 150 hand labels, model agrees ~85% of the time -------*
* Five barrier categories. Truth is the human gold standard; the model
* copies the truth 85% of the time and picks a random other label 15%.
set seed 20260704
set obs 150
gen truth = 1 + int(5 * runiform())          // 1..5 barrier categories
gen byte hit = runiform() < 0.85              // model agrees 85% of the time
gen model = truth
replace model = 1 + mod(truth + int(4*runiform()), 5) if !hit
label define bar 1 "transport" 2 "childcare" 3 "schedule" ///
    4 "none" 5 "other"
label values truth model bar

di "---KAP: model vs human gold standard---"
kap truth model

*--- (b) Multi-model consensus: three models over the same 150 notes --------*
* Model A is the 85% model above. Models B and C are independent draws
* that each agree with truth ~80% and ~78% of the time. We report, per
* note, how many of the three agree with the modal label.
gen mA = model
foreach m in B C {
    local p = cond("`m'"=="B", 0.80, 0.78)
    gen byte hit`m' = runiform() < `p'
    gen m`m' = truth
    replace m`m' = 1 + mod(truth + int(4*runiform()), 5) if !hit`m'
    label values m`m' bar
}
* how many of the three models back the modal (most common) label:
* count how many models share each model's label, take the row max.
gen byte cA = (mA==mA) + (mB==mA) + (mC==mA)
gen byte cB = (mA==mB) + (mB==mB) + (mC==mB)
gen byte cC = (mA==mC) + (mB==mC) + (mC==mC)
egen byte n_agree = rowmax(cA cB cC)
label define agr 3 "3/3 unanimous" 2 "2/3 majority" 1 "1/3 split"
label values n_agree agr
di "---CONSENSUS: how many of 3 models back the modal label---"
tab n_agree

*--- (c) Fairness audit: risk scores with a group offset, cutoff, 4/5 rule --*
* faircheck's logic in 12 lines. Two groups A and B; group B's latent
* risk is shifted down by a fixed offset, so an identical cutoff selects
* B at a lower rate. We compute selection rates and the four-fifths ratio.
clear
set seed 20260704
set obs 2000
gen byte groupB = runiform() < 0.5
gen risk = invlogit(rnormal(0,1) - 0.55*groupB)   // B shifted down
gen byte select = risk > 0.5                       // outreach cutoff
label define grp 0 "Group A" 1 "Group B"
label values groupB grp
di "---SELECTION RATE BY GROUP---"
tabstat select, by(groupB) stat(mean n) nototal
* four-fifths ratio: lower group's rate over higher group's rate
quietly summarize select if groupB==0
local rA = r(mean)
quietly summarize select if groupB==1
local rB = r(mean)
local ratio = min(`rA',`rB') / max(`rA',`rB')
di "---FOUR-FIFTHS RATIO (flag if < 0.80)---"
di "Group A rate = " %5.3f `rA'
di "Group B rate = " %5.3f `rB'
di "4/5 ratio     = " %5.3f `ratio' ///
    cond(`ratio' < 0.80, "  <-- ADVERSE IMPACT", "  ok")

*--- (d) Optional figure: per-category agreement of model vs gold standard --*
* Rebuild the gold-standard frame to chart where the model agrees least.
clear
set seed 20260704
set obs 150
gen truth = 1 + int(5 * runiform())
gen byte hit = runiform() < 0.85
gen model = truth
replace model = 1 + mod(truth + int(4*runiform()), 5) if !hit
label define bar 1 "transport" 2 "childcare" 3 "schedule" ///
    4 "none" 5 "other"
label values truth bar
gen byte agree = truth==model
graph bar (mean) agree, over(truth, label(labsize(small))) ///
    ytitle("Share model matches gold standard") ///
    title("Model-human agreement by barrier category", ///
        size(medium)) ///
    note("Simulated 150-note gold standard, seed 20260704", ///
        size(vsmall)) ///
    bar(1, color(navy)) blabel(bar, format(%4.2f)) ///
    graphregion(margin(l=2 r=6))
graph export "$figures/ch13_agreement.png", replace width(2400)

*--- (e) Prediction-powered inference: correct the downstream estimate -------*
* Validation (a) certifies the LABELS; this block corrects the ESTIMATE built
* from them. 5,000 notes, true transport prevalence 0.30; the LLM under-detects
* transport (sensitivity 0.70) and rarely invents it (specificity 0.95), so the
* naive machine-label prevalence is biased low even though agreement looks high.
* The fix (Angelopoulos et al. 2023, Science): estimate on ALL machine labels,
* then add back the human-minus-machine gap measured on a RANDOM gold subset.
clear
set seed 20260704
set obs 5000
gen byte transport = runiform() < 0.30           // truth (human coding)
gen byte ml = cond(transport, runiform() < 0.70, runiform() >= 0.95)
gen byte gold = _n <= 150                         // random: obs order is random
                                                  // by construction here; in
                                                  // practice draw with sample

* naive: treat 5,000 machine labels as if they were the data
quietly summarize ml
local p_naive = r(mean)
local se_naive = sqrt(`p_naive'*(1-`p_naive')/_N)

* PPI: machine mean on all N, plus the human-machine gap on the gold n
quietly summarize ml
local p_ml_all = r(mean)
gen diff = transport - ml if gold
quietly summarize diff
local rect    = r(mean)                           // the "rectifier"
local se_rect = r(sd)/sqrt(r(N))
local p_corr  = `p_ml_all' + `rect'
local se_corr = sqrt(`se_naive'^2 + `se_rect'^2)

quietly summarize transport
di as txt "true prevalence (all 5,000, for reference): " as res %5.3f r(mean)
di as txt "naive ML estimate:  " as res %5.3f `p_naive' ///
    as txt "  95% CI [" as res %5.3f `p_naive'-1.96*`se_naive' ///
    as txt ", " as res %5.3f `p_naive'+1.96*`se_naive' as txt "]"
di as txt "PPI corrected:      " as res %5.3f `p_corr' ///
    as txt "  95% CI [" as res %5.3f `p_corr'-1.96*`se_corr' ///
    as txt ", " as res %5.3f `p_corr'+1.96*`se_corr' as txt "]"

* tripwires: the naive CI misses the truth; the corrected CI covers it
assert `p_naive' + 1.96*`se_naive' < 0.30
assert (`p_corr'-1.96*`se_corr') < 0.30 & 0.30 < (`p_corr'+1.96*`se_corr')
assert abs(`p_corr' - 0.30) < 0.06

di "DONE"

*==============================================================================*
* (f) ai_privacy_gate demo: 12 simulated case notes, 3+ seeded with PII
*     Printed in ch13 "A gate the pipeline cannot skip".
*==============================================================================*
adopath ++ "`c(pwd)'/ai_privacy_gate"
clear
input str244 notes
"Client reports progress on transportation barrier this week."
"Follow up scheduled; SSN 123-45-6789 recorded at intake."
"Call back at (512) 555-1234 after Tuesday."
"Emailed jane.doe@example.org the schedule."
"DOB 03/14/1987 confirmed against roster."
"Lives at 4412 Maple Street since March."
"MRN: 88471 transferred from the clinic."
"No barriers reported; attended all sessions."
"Second contact 512-555-9876 belongs to the sister."
"Prefers morning appointments; no changes."
"Case# 100234 flagged for review by supervisor."
"Discussed goals; nothing identifying shared."
end
gen str60 comments = "clean text here"
replace comments = "reach me at bob@test.io" in 10
ai_privacy_gate notes comments, genflag(pii)
assert r(rows) == 9
preserve
ai_privacy_gate notes comments, action(mask) noreport
capture noisily ai_privacy_gate notes comments, action(stop) noreport
assert _rc == 0
restore
di "AIGATE_DEMO_OK"

*==============================================================================*
* (g) llmsieve demo: convergence delta on four two-pass answers
*==============================================================================*
adopath ++ "`c(pwd)'/llmsieve"
clear
input str60 pass1 str60 pass2
"transportation barrier"          "transportation barrier"
"childcare gap on Tuesdays"       "childcare gap on Tuesday"
"no barrier reported"             "no barrier reported"
"schedule conflict with work"     "client lost housing in March"
end
llmsieve pass1 pass2, gendelta(delta) genflag(review)
assert r(flagged) == 1
di "LLMSIEVE_DEMO_OK"

*==============================================================================*
* (h) faircheck: equalized-odds view of the four-fifths sim (needs realized)
*==============================================================================*
adopath ++ "`c(pwd)'/faircheck"
clear
set seed 20260704
set obs 2000
gen byte groupB = runiform() < 0.5
gen risk = invlogit(rnormal(0,1) - 0.55*groupB)
gen select = risk > 0.5
gen byte need = runiform() < risk
faircheck need select, by(groupB)
assert abs(r(tpr_gap) - .206) < .01
di "FAIRCHECK_DEMO_OK"

