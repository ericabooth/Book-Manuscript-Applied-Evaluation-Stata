*==============================================================================*
* ch15_deposit.do  --  Chapter 15: hand an analysis file to a mixed-language team
* Writes a deposit of an nlsw88 extract with -datadeposit-: the data as csv,
* .dta, and .rds; a codebook; and setup scripts for Stata, R, and Python.
* Then checks the deposit, and shows how a second version records its parent.
* Shipped data (sysuse nlsw88). No key, no external data.
* Needs: datadeposit (see 01_install.do). R is optional: without it the .rds
* copy is skipped and a note says so.
* Globals: none needed. Writes nlsw88_deposit and nlsw88_deposit_v2 in the
* working directory.
*==============================================================================*
clear all
set more off

*--- An analysis file with the documentation survey files usually have ------*
sysuse nlsw88, clear
keep idcode age race married collgrad union wage hours tenure

* question wording is stored in characteristics, as survey exports usually do
char union[question] "Are you covered by a union contract at work?"
char wage[question]  "What is your hourly pay, before taxes?"
notes wage: Hourly wage in 1988 dollars; the survey top-codes it at 40.75.

* For illustration only: treat one in three of the missing union answers as
* "Don't know", coded .d, so the file has a labelled extended missing code.
replace union = .d if missing(union) & mod(idcode, 3) == 0
label define unionlbl .d "Don't know", modify

*--- The deposit: the last line of the analysis do-file ----------------------*
datadeposit, to(nlsw88_deposit) authors("Evaluation team") replace ///
    title("NLSW 1988 extract for the wage team")

*--- Anyone can check it ------------------------------------------------------*
datadeposit verify nlsw88_deposit

*--- A change becomes version 2, which names version 1 as its parent ---------*
datadeposit use nlsw88_deposit, clear
replace wage = . if wage > 40
datadeposit, changes("Top-coded wages set to missing") replace
return list
