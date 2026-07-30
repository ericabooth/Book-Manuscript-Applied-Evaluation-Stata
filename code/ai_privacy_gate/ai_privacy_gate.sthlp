{smcl}
{* *! version 1.0.0  27jul2026}{...}
{title:Title}

{p2colset 5 24 26 2}{...}
{p2col :{cmd:ai_privacy_gate} {hline 2}}Scan text fields for likely PII before they leave for a hosted LLM{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 16 2}
{cmd:ai_privacy_gate} {varlist} {ifin}{cmd:,}
[{opt a:ction(report|mask|stop)} {opt gen:flag(newvar)} {opt norep:ort}]

{p 4 6 2}
{it:varlist} names one or more string variables (case notes, comments,
open-ended responses).


{title:Description}

{pstd}
Text that leaves your machine for a hosted language model cannot be
recalled, so the time to find personally identifiable information is before
the API call, not after.  {cmd:ai_privacy_gate} scans string variables for
six likely-PII pattern classes {hline 2} Social Security numbers, phone
numbers, email addresses, dates in date-of-birth form, street addresses,
and tagged record numbers ({cmd:MRN:}, {cmd:Case #}) {hline 2} and reports
flagged-row counts by class.

{pstd}
The command enforces as well as reports.  With {cmd:action(stop)} it exits
with error when anything is flagged, which turns a data-use agreement's
{cmd:"}no identified records leave the building{cmd:"} clause into a line of
code a pipeline cannot skip.  With {cmd:action(mask)} it replaces each match,
in place, with a {cmd:[REDACTED-CLASS]} tag; run it on a copy of the data.

{pstd}
A pattern scan is a floor, not a guarantee: free text can identify a person
with no pattern at all ({cmd:"}the only welder in Marfa{cmd:"}).  The gate
catches the leaks that look like data; a human still owns the judgment.


{title:Options}

{phang}
{opt action(report|mask|stop)} sets what happens on a hit.
{cmd:report} (the default) prints counts and returns them.
{cmd:mask} replaces matches with {cmd:[REDACTED-CLASS]} tags in place.
{cmd:stop} reports, then exits with error 459 if any row was flagged
{hline 2} the pipeline-gate mode.

{phang}
{opt genflag(newvar)} creates a byte variable marking rows with any hit,
for routing flagged rows to local-only handling.

{phang}
{opt noreport} suppresses the table; results are still returned.


{title:Examples}

{pstd}Scan two note fields and mark flagged rows:{p_end}

{phang2}{cmd:. ai_privacy_gate notes comments, genflag(pii)}{p_end}

{pstd}Gate a pipeline: halt the do-file if anything would leak:{p_end}

{phang2}{cmd:. ai_privacy_gate notes, action(stop)}{p_end}

{pstd}Mask a copy for export:{p_end}

{phang2}{cmd:. preserve}{p_end}
{phang2}{cmd:. ai_privacy_gate notes, action(mask)}{p_end}
{phang2}{cmd:. ai_privacy_gate notes, action(stop)  // proves the mask held}{p_end}


{title:Stored results}

{pstd}
{cmd:ai_privacy_gate} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(rows)}}rows flagged by any class{p_end}
{synopt:{cmd:r(total)}}sum of flagged-row counts across classes{p_end}
{synopt:{cmd:r(ssn)}, {cmd:r(phone)}, {cmd:r(email)}, {cmd:r(date)}, {cmd:r(address)}, {cmd:r(idnum)}}flagged rows per class{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(action)}}action taken{p_end}


{title:Author}

{pstd}
Eric A. Booth.  Companion tool to {it:Applied Program Evaluation Using Stata}.
