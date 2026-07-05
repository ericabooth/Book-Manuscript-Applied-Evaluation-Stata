*==============================================================================*
* ch13_backbone.do  --  Chapter 13: Stata as the backbone for LLM work
* Demonstrates the "propose -> run in batch -> the log (with assert) decides"
* loop. Run this from the shell so the run is real and logged:
*     stata-mp -b do ch13_backbone.do
*==============================================================================*
* Standalone globals; in the full project these come from 00_control.do.
global root "`c(pwd)'"

*--- A step the model proposed, made trustworthy by tripwires ------------------*
* assert statements are one-line contracts: state what must be true, and if it
* is not, Stata halts with r(9) rather than sailing on with wrong data.
version 18
clear all
sysuse nlsw88, clear

gen byte lowpay = wage < 5      // the model's proposed transformation
assert !missing(lowpay)         // no silent missings introduced
assert inlist(lowpay, 0, 1)     // strictly binary
isid idcode                     // still one row per worker
count if lowpay
* The expected count is justified in TODO.md; the log, not the model, confirms it.
* (While drafting the book, the first two guesses -- 132, then 278 -- each hit
*  this tripwire with "assertion is false / r(9);". The true count is 757.)
assert r(N) == 757
di as result "STEP 120 PASSED: N_lowpay = " r(N)

di "DONE"
