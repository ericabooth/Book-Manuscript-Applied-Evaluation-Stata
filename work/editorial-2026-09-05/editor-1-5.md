# Chapters 1–5 editorial record, 2026-09-05

Read all five assigned chapter sources, including examples, notes, tables, captions, and exercises. The first three chapters received selective edits to preserve their existing voice, following the user's clarification. Chapter sequence, citation keys, and existing executable examples remain unchanged. New teaching uses existing examples and adds no executable code.

Read Clearwriter and its portable guide, long-document workflow, Gelman patterns, AI-tell catalog, and voice-register scaffold. Read Cox, “How to debug, part I” (March 4, 2026), https://journals.sagepub.com/doi/full/10.1177/1536867X261425801 on 2026-09-05. General inspiration: inspect a small case, explain what the output means, and distinguish a successful command from a justified interpretation. No phrasing copied.

## Scope and verification

New arithmetic: (1+0)/2 = 0.5; K/(K-1) decreases toward 1 for K > 1. Existing numbers were retained unless a mathematical interpretation was corrected; this is not an audit of every empirical claim. Root handles independent review, assembly, and compilation.

## Reversible edit ledger

Each row is an applied judgment or correction, with the exact old and new passage below so the author can reverse it. Weakspot entries add or repair novice instruction.

### 1. 11_ch01.tex — Editorial correction

Reason: Remove negate-assert framing while preserving chapter forecast.

Before:
> The question this chapter answers is not \enquote{what statistics should I know} but \enquote{what does the work actually look like, start to finish.}

After:
> This chapter asks what an embedded evaluator does from the moment a request arrives to the delivery of an answer.

### 2. 11_ch01.tex — Teaching weakspot

Reason: Distinguish writing a plan from preregistering it and explain the practical next action.

Before:
> When you put that agreement on paper, it becomes a pre-registered analysis plan, which is cheaper than it sounds.

After:
> You can turn the analysis provisions of that agreement into a plan written before you inspect the outcomes. To preregister it, deposit the dated plan in a registry or another agreed repository that preserves the original and records later amendments; a private file you can overwrite is a planning document, but does not provide the same independent record.

### 3. 11_ch01.tex — Editorial correction

Reason: Keep scoping distinct from preregistration.

Before:
> The note is the pre-registered plan described earlier in this section, scaled down to a single request: you state which comparison will be the answer before the data has a chance to suggest a more flattering one.

After:
> The note applies the same advance-planning habit to a single request: you state which comparison will answer the question before inspecting the results. Keep it with the project even when the request does not call for formal preregistration.

### 4. 11_ch01.tex — Teaching weakspot

Reason: Fix incompatible ZIP/county join and make classification actionable.

Before:
>     \item \textbf{Classify} students as rural or not by merging a county-rurality crosswalk, a two-column lookup file that maps each county to a rural flag, onto ZIP codes (Chapter~\ref{ch:panels}).

After:
>     \item \textbf{Classify} students using the rural definition agreed with the program and a geographic identifier that matches that definition. A county crosswalk requires county codes; ZIP codes require a documented ZIP-to-county conversion first (Chapter~\ref{ch:panels}).

### 5. 11_ch01.tex — Editorial correction

Reason: Separate a program target from a population benchmark.

Before:
>     \item \textbf{Benchmark} observed rural enrollment against a Census target pulled with \texttt{getcensus}\index{getcensus@\texttt{getcensus}} (Chapter~\ref{ch:apis}).

After:
>     \item \textbf{Benchmark} the share of enrollees classified as rural against the program\textquotesingle s agreed target. If you also compare reach with the eligible population, obtain population counts for the same geography, age range, and rural definition (Chapter~\ref{ch:apis}).

### 6. 11_ch01.tex — Teaching weakspot

Reason: Add denominator, missingness, many-to-many geography, and next-decision guidance.

Before:
> The workflow is the point. It is replicable because it runs from the raw exports, and actionable because it answers the officer's question in her own units. Every step is a later chapter; this scenario is the thread that ties them together.

After:
> Before computing a site\textquotesingle s rural share, count each enrolled student once and agree how to handle students whose location cannot be classified. Divide the number classified as rural by the number with a usable classification, and report the unclassified count beside the share. ZIP codes can cross county boundaries, so a ZIP-to-county lookup may give several candidate counties; use a documented allocation rule or seek a more precise address rather than duplicating a student across those matches. A shortfall then identifies a site to investigate, although you will still need staff knowledge of recruitment, transport, and eligibility to decide whether moving the site would help.

### 7. 11_ch01.tex — Editorial correction

Reason: Remove rhetorical negation from heading.

Before:
> \subsection{Not whether a program works, but where and for whom}

After:
> \subsection{Where a program works, and for whom}

### 8. 11_ch01.tex — Editorial correction

Reason: Remove unsupported exclusivity; external participatory evaluators can support process use.

Before:
> \emph{Process use}\index{process use} is the one only an embedded evaluator is positioned to capture:

After:
> \emph{Process use}\index{process use} develops when people learn through participating in an evaluation:

### 9. 11_ch01.tex — Editorial correction

Reason: Qualify categorical claim about external evaluators.

Before:
> process use accrues to the evaluator who is in the room across cycles, which is the embedded role's distinctive return

After:
> process use can develop through either arrangement, with repeated involvement giving an embedded evaluator more opportunities to support it

### 10. 11_ch01.tex — Editorial correction

Reason: Remove metaphor and negate-assert coda.

Before:
> The document is therefore not a shield one side holds against the other. It is the shared record that lets you keep both at once: the access that comes with proximity, and the independence the profession requires.

After:
> Both parties can refer to the shared record when they disagree about a finding, while continuing the daily work that makes the embedded role useful.

### 11. 11_ch01.tex — Editorial correction

Reason: Remove meta-talk without changing substantive scope.

Before:
> Two of those parts, getting the data and communicating it, take eight of the book's fifteen chapters, and the reason is worth stating plainly.

After:
> Getting the data and communicating it take eight of the book's fifteen chapters because these stages often require work beyond the statistical analysis.

### 12. 12_ch02.tex — Editorial correction

Reason: Remove contrast-formula heading.

Before:
> \section{The control file is a handoff, not housekeeping}

After:
> \section{The control file prepares a project for handoff}

### 13. 12_ch02.tex — Teaching weakspot

Reason: Replace unsafe and false passing-run guarantee with actionable handoff check.

Before:
> Their advice to a person taking over unfamiliar code is to run it before reading it, to trust the pipeline over the prose, and to treat a project that rebuilds end to end as the only documentation that cannot go stale, because a comment can be out of date while a run that still passes cannot.

After:
> Their advice encourages a successor to learn from running unfamiliar code as well as reading it. Before the first run, inspect the control file for downloads, overwrites, and other actions that affect files or external services, and run a working copy with the intended inputs. A successful run shows that the code executes in that environment; compare its outputs with the archived report before concluding that it reproduces the published results.

### 14. 12_ch02.tex — Editorial correction

Reason: Align diagram with reproduction check.

Before:
> {a passing run is the one\\document that cannot go stale}

After:
> {compare rebuilt outputs\\with the archived report}

### 15. 12_ch02.tex — Editorial correction

Reason: Correct figure caption overclaim.

Before:
> The handoff test, after \textcite{pilgrim2023code}: a successor runs the inherited pipeline \emph{before} reading a line of it. Only an end-to-end rebuild proves the code is what produced the report; anything short of that loops back to fixing paths, installs, and versions until it does.

After:
> The handoff test, informed by \textcite{pilgrim2023code}: after inspecting the control file, a successor runs a working copy of the inherited pipeline and compares the rebuilt outputs with the archived report. If execution fails, investigate paths, installations, and versions; if the numbers differ, also compare the inputs and analysis decisions.

### 16. 12_ch02.tex — Editorial correction

Reason: Date-only filename with replace overwrites within day.

Before:
> stamp the filename with the date so runs never overwrite each other:

After:
> stamp the filename with the date so a new day\textquotesingle s run preserves the previous day\textquotesingle s log:

### 17. 12_ch02.tex — Editorial correction

Reason: Remove enumeration teaser.

Before:
> Three details in those lines are worth the space. The date local turns today into

After:
> The \texttt{today} local stores the run date in a sortable form, for example

### 18. 12_ch02.tex — Teaching weakspot

Reason: Explain exact logging limitation and remedy.

Before:
> Dating it means yesterday's log survives today's run, so you keep a trail rather than a single file that is only ever as old as your last mistake.

After:
> This filename preserves logs across dates, but \texttt{replace} overwrites an earlier run from the same day. If you need every attempt, include the time or a run identifier in the filename before using this pattern in a scheduled job.

### 19. 12_ch02.tex — Editorial correction

Reason: Remove unsupported algorithmic explanation while retaining teaching equation.

Before:
> The pattern of the payoff is its own check: it scales with how much work the operation does per row, and \texttt{egen} touching every row is doing far more than \texttt{collapse} shrinking the file to a handful of group rows. Writing the run time as a fixed startup cost plus a per-row cost makes the pattern explicit and shows why the speedup column can drop below one:

After:
> These timings describe the tested file and machine; they do not identify why one implementation was faster. Both commands must examine the input rows, even though \texttt{collapse} retains fewer output rows. A rough accounting of startup and processing time can help you think about what to time next:

### 20. 12_ch02.tex — Editorial correction

Reason: Correct inference from timing ratio.

Before:
> A speedup above~$1$ means \texttt{gtools} was faster; below~$1$, its fixed cost $c_{0}$ outweighed the per-row saving, which is exactly what a fast \texttt{collapse} shows and a slow \texttt{egen} does not.

After:
> A speedup above~$1$ means \texttt{gtools} was faster; below~$1$ means the native command was faster. The ratio alone cannot separate startup cost from processing cost.

### 21. 12_ch02.tex — Editorial correction

Reason: Remove financial metaphor coda.

Before:
> Those are the replicable and extensible principles, banked once for every project ahead.

After:
> You can reuse that setup when the next project begins.

### 22. 21_ch03.tex — Teaching weakspot

Reason: Teach path/query distinction against existing worked example.

Before:
> Once that anatomy is clear, the query string is the only part you rewrite to aim the same call at a different county or year.

After:
> The location of those choices depends on the service. In the QCEW example the year, quarter, and county code are part of the path, with no query string. Other services put filters after a question mark, as in the CDC example later in the chapter. Before editing a URL, identify which part names the resource and which parts the service accepts as filters.

### 23. 21_ch03.tex — Editorial correction

Reason: Remove universal query-string claim.

Before:
> a base URL, a path that names the dataset, and a query string of parameters that names the slice you want.

After:
> a base URL and a path, sometimes followed by a query string of parameters that selects the slice you want.

### 24. 21_ch03.tex — Editorial correction

Reason: Correct API diagram label.

Before:
> {path};

After:
> {dataset\\path};

### 25. 21_ch03.tex — Editorial correction

Reason: Correct API diagram label.

Before:
> {query\\string};

After:
> {selection\\in path};

### 26. 21_ch03.tex — Editorial correction

Reason: Reconcile diagram caption with actual URL.

Before:
> Every portal in this chapter is the same object: a base URL, a path that names the dataset, and a query string that names the slice, returning CSV or JSON. Read the labels bottom-up against the QCEW call \texttt{data.bls.gov/cew/data/api/2023/1/area/48453.csv}: swap the FIPS code in the query string and you have a different county.

After:
> The QCEW request selects a county and quarter within the URL path. In \texttt{data.bls.gov/cew/data/api/2023/1/area/48453.csv}, \texttt{2023/1} selects the year and quarter and \texttt{48453} selects Travis County. This URL has no query string; services that use one place it after a question mark.

### 27. 21_ch03.tex — Editorial correction

Reason: Remove confusing counting.

Before:
> a two-unit test case, meaning one county and one period you will pull first and inspect by hand.

After:
> a test case, meaning one county in one period that you will pull first and inspect by hand.

### 28. 21_ch03.tex — Editorial correction

Reason: Replace promise of certainty with specific interpretation.

Before:
> Once you have read it, you can answer a program director's \enquote{is this number solid?} without hedging.

After:
> Use the handbook to explain which uncertainty matters for the requested comparison, including sampling error and the period the estimate covers.

### 29. 21_ch03.tex — Editorial correction

Reason: Correct false link from income table to rural population benchmark.

Before:
> The rural-reach example of Chapter~\ref{ch:embedded} draws its benchmark data from exactly this pull, and the payoff is accessibility in the plainest sense: real geography and real units in a funder's report, on demand.

After:
> The \texttt{B19013} example supplies median household income. For the rural-reach question in Chapter~\ref{ch:embedded}, you would instead need eligible-population counts matched to the program\textquotesingle s rural definition; an income table cannot supply that denominator.

### 30. 21_ch03.tex — Teaching weakspot

Reason: Add novice period-estimate and comparison guidance.

Before:
> \section{Education panels with educationdata}

After:
> Each year in this ACS pull labels the end of a five-year collection period, so adjacent releases share most of their survey years. Read the 2023 estimate as describing 2019--2023, and avoid treating its difference from the 2022 release as a clean change during 2023. When adapting the example, record the ACS product and period, the table code, the geography, and the dollar basis for income. Those details let you match the same cell on the Census website and explain a difference between releases without confusing it with a one-year program effect.

\section{Education panels with educationdata}

### 31. 21_ch03.tex — Editorial correction

Reason: Correct QCEW file unit.

Before:
> one per county-year,

After:
> one per county-quarter,

### 32. 21_ch03.tex — Editorial correction

Reason: Remove guarantee that unauthenticated endpoint cannot expire.

Before:
> With no key and nothing but \texttt{import delimited}, nothing in the pull can expire and no step in it depends on anyone's memory; the payoff is a comparison the board did not have before.

After:
> The pull requires no credential to renew. Preserve its raw downloads and retrieval dates because the agency can still revise the data or change the URL.

### 33. 21_ch03.tex — Teaching weakspot

Reason: Prevent invalid tract-average validation.

Before:
> aggregate your tracts and compare against the county value PLACES publishes for the same measure, because a tract average far from its own county signals a join error, not a health finding.

After:
> compare a downloaded tract estimate with the published estimate for that same tract, measure, release, and adjustment. A simple average across tracts need not equal the county estimate, because tract populations differ and the county estimate is produced for its own geographic population. If you aggregate tracts, specify the population weights and check whether the measure supports that aggregation.

### 34. 21_ch03.tex — Teaching weakspot

Reason: Fix false workaround for truncated API results.

Before:
> The clean fix is to not use the dollar options at all: the plain field filters shown above (\texttt{field=value}) do the same filtering with no dollar sign, and if you only need to cap the row count you can \texttt{keep in 1/5000} in Stata after the import. It is the one non-obvious trap in the chapter, and it bites everyone once.

After:
> For a small request, the plain field filters above avoid that macro collision. They do not increase the server\textquotesingle s row limit, and keeping rows after import cannot recover records the server never sent. Before requesting a larger table, use the service\textquotesingle s documented pagination or limit controls with a correctly escaped or encoded dollar sign, then reconcile the downloaded count with the number of matching records. A successful HTTP response confirms delivery of the requested page, not completeness of the dataset.

### 35. 21_ch03.tex — Editorial correction

Reason: Correct JSON type explanation.

Before:
> First, because JSON text records no column types, a count can arrive as a string variable;

After:
> Because JSON permits both numeric values and quoted text, a count can arrive as a string variable;

### 36. 21_ch03.tex — Teaching weakspot

Reason: Teach append versus merge and mixed-frequency alignment.

Before:
> Stack the three with \texttt{combineall}, tagging each variable's source so the exhibit's provenance is auditable.

After:
> Prepare each source at the same county-period unit, then merge the measures on that key; append is appropriate for adding periods of the same measure, not for placing income beside unemployment. Choose explicitly how monthly unemployment and quarterly wages become annual measures, and label ACS five-year estimates with their collection periods. Keep state totals separately so they do not enter county summaries, and record each variable\textquotesingle s source.

### 37. 22_ch04.tex — Editorial correction

Reason: Remove hyperbolic marketing contrast.

Before:
> There is no API. In this chapter we get that data into Stata without spending eighty-four afternoons on it, and we do it in a way you could show the agency without embarrassment.

After:
> The agency offers no API, so we use a script to request those files, keeping a record of what was downloaded and checking the result before analysis.

### 38. 22_ch04.tex — Editorial correction

Reason: Use substantive instructional heading.

Before:
> \section{Scraping public files is a method, not a workaround}

After:
> \section{Document how the website produced the data}

### 39. 22_ch04.tex — Editorial correction

Reason: Remove exclusivity pitch and emphasize practical shared workflow.

Before:
> You end up owning a thirteen-year Texas education panel almost no one else in the room will have: you write a short script that walks the state's download form, which has no API behind it, and pulls each year in turn. That ownership is the point for an embedded evaluator. When the state posts the files but ships no bulk extract, everyone at the table can see the same eighty-four buttons, but only the person who scripted the walk holds the assembled panel, and only that person can rebuild it next fall in an afternoon.

After:
> We now use the state\textquotesingle s download form to assemble a Texas education panel across thirteen years. You can save colleagues the repeated work of opening that form and selecting each year by recording those selections in a script they can rerun.

### 40. 22_ch04.tex — Editorial correction

Reason: Remove metaphor.

Before:
> a one-row map heals the split

After:
> a one-row map records the rename

### 41. 22_ch04.tex — Teaching weakspot

Reason: Distinguish syntactic harmonization from measurement harmonization.

Before:
> which is how a column split in 2020 lands in the same variable as its 2015 self.

After:
> which aligns an unchanged measure whose variable name changed. A measure split into separate categories requires a substantive rule for combining or comparing those categories; renaming alone cannot establish equivalence.

### 42. 22_ch04.tex — Teaching weakspot

Reason: Explain display abbreviation and safe numeric conversion.

Before:
> Both are strings, both names are truncated to junk in the middle\marginnote{\texttt{prematuredea\textasciitilde e} is not a name anyone will read in six months.}. Fix both in two moves: drop the label row, then rename the handful of columns you actually need into short, readable names and \texttt{destring}\index{destring@\texttt{destring}} them.

After:
> Both variables imported as strings. In this display Stata abbreviates the long names with a tilde; the underlying names remain intact, as the following \texttt{rename} commands show. After confirming that the first observation contains labels, drop it, choose readable names for the measures you need, and use \texttt{destring}\index{destring@\texttt{destring}} to convert their values to numbers. If conversion fails, inspect the nonnumeric entries for suppression codes or explanatory text before deciding how to handle them.

### 43. 22_ch04.tex — Teaching weakspot

Reason: Correct compensatory index interpretation and add worked arithmetic, missingness, weighting, and longitudinal cautions.

Before:
> standard deviations across the 254 counties. Standardizing first puts the two
measures on equal footing even though their scales differ (a rate per
100{,}000 and a percent), so a county is high-need only when it runs
high on both.

After:
> standard deviations among Texas counties with an observed value for each measure. Standardizing expresses each measure as a distance from its county mean in standard-deviation units, so the index gives the two measures equal weight despite their different original scales. A high value on either measure can raise the average; a county does not have to be high on both.

For example, a county one standard deviation above the mean on premature death and at the mean on child poverty receives an index of $(1+0)/2=0.5$. The value describes relative position among these counties, not an estimated benefit from a grant. If either input is missing, the arithmetic mean in the code is missing too; count and inspect those counties before ranking, and keep them in a separate unranked list. Before using the ranking to prioritize visits, compare the component measures and ask whether reasonable alternative weights change the counties you would visit. For comparisons over time, retain a fixed reference distribution or explain that recomputing the standardization each year measures a changing relative position.

### 44. 22_ch04.tex — Editorial correction

Reason: Remove causal allocation inference from descriptive index.

Before:
> A foundation reading this does not need a briefing to see where a place-based grant would do the most work.

After:
> A foundation can use this list to begin discussions with local partners about need, service gaps, and delivery capacity. The index does not estimate where a grant would have the largest effect.

### 45. 22_ch04.tex — Editorial correction

Reason: Remove unsupported explained-variance and allocation claim.

Before:
> Two measures explain most of the spread, and together they sort the counties cleanly: the upper-right quadrant, high poverty and high premature death, is a short, defensible list to take to a board.

After:
> Counties in the upper-right quadrant exceed the statewide reference on both measures. Discuss these component values beside the index ranking so a board can distinguish the observed need from its separate judgment about where and how to intervene.

### 46. 22_ch04.tex — Teaching weakspot

Reason: Distinguish client streaming from server filtering.

Before:
> What you take from the example matters more than the specific dataset: a small shop can work with enormous public data by filtering at the source rather than downloading first and filtering later.

After:
> Streaming limits memory use by processing records as they arrive. Unless the server itself supports a filter, you may still transfer the full document over the network, including records the parser later discards.

### 47. 22_ch04.tex — Editorial correction

Reason: Explain limits of count-based restart.

Before:
> when the job dies at hour nine, you can read from that count where it died and what a restart can skip

After:
> if the job stops, you can use the count to locate the failure and check the restart strategy. A count alone is not a resumable checkpoint: the parser also needs a recoverable position and enough state to resume a valid JSON record

### 48. 22_ch04.tex — Editorial correction

Reason: Correct guaranteed upward direction in exercise.

Before:
> confirm that the
    inflated average is what the margin note warns will bias every
    downstream statistic.

After:
> compare the resulting mean with the county-only mean. Explain why
    including overlapping geographic totals changes the population
    represented by that average; the direction of the change depends
    on the values in the added rows.

### 49. 23_ch05.tex — Editorial correction

Reason: Remove conceptual-location idiom.

Before:
> Behind all of it sits one framework, total survey error

After:
> We organize these tasks around total survey error

### 50. 23_ch05.tex — Editorial correction

Reason: Remove false claim that manual monitoring is impossible.

Before:
> Automation here is not a convenience: until the pull is scripted, there is nothing to monitor, which is why we ruled out spreadsheet analysis in Chapter~\ref{ch:workshop} and why we script the survey pull here.

After:
> A scripted pull lets you repeat the same checks on a schedule and preserve what you found, extending the reproducible workflow of Chapter~\ref{ch:workshop}.

### 51. 23_ch05.tex — Editorial correction

Reason: Distinguish genuine multiple responses from mutually exclusive dummies.

Before:
> \subsection{Recombining multi-select exports back into one variable}

After:
> \subsection{Recombining mutually exclusive indicator columns}

### 52. 23_ch05.tex — Editorial correction

Reason: Avoid universal and inaccurate platform format claim.

Before:
> The pull is only the first surprise the platform hands you. Qualtrics and Google Forms export a ``check all that apply'' question not as one variable but as a block of one-hot indicator columns, one per option, so a five-option question arrives as five \texttt{0/1} variables named after the choices.

After:
> Some survey exports represent each answer option in a separate indicator column, coded 1 when selected and 0 otherwise; the layout depends on the platform and export settings.

### 53. 23_ch05.tex — Teaching weakspot

Reason: Add safe decision rule for undummy.

Before:
> That layout is right for a check-all item, where a respondent can pick several, but wrong for a single-answer question that the platform still splits, and wrong for the analyst who wants one labeled categorical to tabulate.

After:
> Keep those columns when respondents may select several options, because each column records a separate answer. When the question permits exactly one choice, you can instead combine the columns into a labeled categorical variable after checking that each responding row selects only one option.

### 54. 23_ch05.tex — Editorial correction

Reason: Remove claim survey platforms used Stata to create exports.

Before:
> It is the exact inverse of \texttt{tabulate, generate()}, which is how survey platforms produced the dummy block in the first place.

After:
> For mutually exclusive indicators, you can understand the conversion as reversing Stata\textquotesingle s \texttt{tabulate, generate()}.

### 55. 23_ch05.tex — Teaching weakspot

Reason: Add novice denominator, deduplication, and roster checks.

Before:
> \begin{vizcallout}[Visualization to build: the response-rate control chart]

After:
> Before calculating a rate, define the eligible roster and the response that counts: for example, a completed questionnaire from a distinct eligible participant. Repeated exports often contain the same respondent, so match by a stable response or person identifier and count that person once. Report the numerator and eligible denominator beside each site\textquotesingle s percentage, and investigate an unmatched response or a missing roster before computing the rate. A site with no eligible participants has an undefined response rate, not a zero. These checks help you distinguish a collection problem from an apparent shortfall caused by the data preparation.

\begin{vizcallout}[Visualization to build: the response-rate control chart]

### 56. 23_ch05.tex — Editorial correction

Reason: Distinguish cumulative trajectory from fluctuating weekly simulation.

Before:
> Plot each site's cumulative response rate over the field period, with three reference lines via \texttt{yline()}: the target centerline and upper and lower control limits.

After:
> Plot each site\textquotesingle s rate over the field period and label whether it is weekly or cumulative. The simulation below illustrates reference lines with \texttt{yline()}; for a live cumulative survey, compare progress with the expected rate at the same stage of fieldwork.

### 57. 23_ch05.tex — Teaching weakspot

Reason: Correct formal-control-chart inference and teach adaptation.

Before:
> The control limits come from the process itself, not from a textbook constant. We set the centerline at the 70 percent target and the limits at two standard deviations of the observed weekly rates, then flag any site-week that falls below the lower limit:

After:
> For this illustration, we set the centerline at 70 percent and draw reference limits two standard deviations above and below it, using all the simulated site-week rates. This teaches the chart calculation, but it does not estimate a prospective false-alarm rate: the same simulated shortfalls also contribute to the standard deviation. In a live monitor, agree the decision rule using earlier comparable fieldwork or an explicit sampling model, then retain it while monitoring the new wave. Cumulative rates for a fixed roster generally rise as responses arrive, so a constant target and these fluctuating weekly draws would be a poor model of that process.

### 58. 23_ch05.tex — Editorial correction

Reason: Remove unsupported statistical rarity claim.

Before:
> \marginnote{Read the limits in policy units: a site-week below the lower line is not \enquote{a bit low,} it is far enough below target that noise alone rarely explains it; that is the moment a worry becomes a phone call.}

After:
> \marginnote{Here an alarm means the simulated rate falls below the chosen reference line. It is a prompt to investigate, with no calibrated probability that the shortfall arose by chance.}

### 59. 23_ch05.tex — Editorial correction

Reason: Replace diagnostic certainty with troubleshooting steps.

Before:
> Three explanations cover most dips. Instrument fatigue shows up as a synchronized sag, every panel drifting down in the same field week, and its remedy is a shorter reminder or a trimmed instrument, not a phone call to one site. Site turnover shows up as one panel falling off a cliff, and a single call to the site liaison, asking whether the coordinator who championed the survey left, usually confirms it. Seasonality shows up when the dip falls on the same calendar week as last wave's, spring break or end-of-quarter, which the prior wave's monitoring output confirms in a minute.

After:
> Use the site and week to guide follow-up without treating the shape of a line as a diagnosis. A decline across sites may reflect a common calendar event, a changed export, or survey fatigue; a decline at one site may reflect roster changes or staff turnover. Compare the export with the platform, check the invitation and reminder records, and ask the site liaison what changed before choosing a response. Changing the instrument mid-field also changes what later respondents answer, so record any such revision and consider its effect on comparisons.

### 60. 23_ch05.tex — Editorial correction

Reason: Remove forced three-bin framing.

Before:
> \marginnote{We suggest you spend one day sorting a dip into one of these three bins, fatigue, turnover, or seasonality, before you escalate, because a misdiagnosed alarm spends goodwill the next one will need.}

After:
> \marginnote{Record the explanation and supporting check beside the alarm. If the cause remains unclear, say so when you escalate.}

### 61. 23_ch05.tex — Teaching weakspot

Reason: Correct automatic-email claim and make monitor deployment actionable.

Before:
> Without the scheduler the promise stays aspirational; with it, the do-file's non-zero exit code on an alarm lets \texttt{cron} itself mail the alert, so the whole loop, pull to phone call, runs before anyone opens a laptop.

After:
> The schedule launches the do-file; notification requires a separate tested arrangement. A nonzero exit status does not by itself make \texttt{cron} send an email, and the simulation shown here only prints the alarm list. Configure the scheduling wrapper to distinguish a completed pull with low response from a failed pull, route the appropriate message, and test both cases before relying on it. The shell redirection shown above saves output to a log, which someone or another process must inspect.

### 62. 23_ch05.tex — Editorial correction

Reason: Align diagram with required notification setup.

Before:
> {Alert email\\(non-zero exit)}

After:
> {Configured alert\\after a checked run}

### 63. 23_ch05.tex — Editorial correction

Reason: Correct caption notification mechanism.

Before:
> A site below the limit sets a non-zero exit code that lets the scheduler mail the alert; otherwise the loop simply waits for the next morning. Nothing here waits on a human until the phone call.

After:
> A separately configured notification step sends the alarm list after a successful pull and reports a failed pull as a data-access problem. Test that step as well as the schedule before treating the monitor as operational.

### 64. 23_ch05.tex — Editorial correction

Reason: Remove hard alpha floor and unidimensionality claim.

Before:
> \marginnote{Rule of thumb on alpha: below 0.70 the items are not hanging together as one scale; above 0.95 they may be redundant, several ways of asking the same question. And alpha climbs mechanically with item count, so a high value on a 30-item battery proves less than it looks.}

After:
> \marginnote{Cronbach\textquotesingle s alpha summarizes consistency among items under assumptions about the scale. Its value depends on item count, covariance, and the sampled respondents. Inspect the wording and item relationships rather than treating a conventional cutoff as proof that the scale measures one construct.}

### 65. 23_ch05.tex — Teaching weakspot

Reason: Correct interpretation of existing alpha output.

Before:
> The battery returns a scale reliability (Cronbach's alpha) of \textbf{0.91} on the pooled data, comfortably above the 0.70 floor and below the 0.95 redundancy ceiling, so the five items are measuring one coaching-satisfaction construct rather than five unrelated things.

After:
> The simulated battery returns Cronbach\textquotesingle s alpha of \textbf{0.91} on the pooled data. The items covary as intended in this simulation; alpha alone does not establish that a real battery measures one coaching-satisfaction construct.

### 66. 23_ch05.tex — Editorial correction

Reason: Correct mathematical explanation.

Before:
> The formula makes the margin note's warning concrete: the leading $K/(K-1)$ factor and the item variances in the sum both grow with $K$, so alpha rises with item count even when each new item adds little, which is why a high value on a thirty-item battery proves less than the same value on five.

After:
> The factor $K/(K-1)$ decreases toward one as items are added. Alpha depends on the full variance ratio, including the covariances that contribute to the variance of the total score; adding similarly correlated items can raise alpha, but adding an arbitrary item need not do so.

### 67. 23_ch05.tex — Teaching weakspot

Reason: Add scoring-direction, missing-item, denominator, and interpretation guidance.

Before:
> With that reliability in hand, you can collapse the battery into one row of percent-agree figures per site:

After:
> Before applying this to your own battery, confirm that larger codes mean more of the same construct for every item, and agree how many answered items are required for a respondent\textquotesingle s index. A mean based on one answered question and a mean based on the full battery have different evidential support even if both are 4. For each percent-agree column, divide the number selecting agree or strongly agree by the number answering that item, and report that denominator. Retain the item-level results so you can see whether an apparently satisfactory overall mean hides a specific problem. We summarize the simulated responses by site below.

### 68. 23_ch05.tex — Editorial correction

Reason: Avoid guaranteeing raking repairs bias.

Before:
> A gap on traits you observe (site, race, age band) is recoverable:

After:
> A gap on observed traits (site, race, age band) may be reduced by weighting when the responding sample includes the groups needed for adjustment:

### 69. 23_ch05.tex — Editorial correction

Reason: Remove guaranteed repair from caption.

Before:
> The second is mechanical repair, raking to known margins, with the headline shown weighted and unweighted.

After:
> The second considers raking to known margins, with the headline shown weighted and unweighted and the remaining assumptions stated.

### 70. 23_ch05.tex — Editorial correction

Reason: Qualify weighting claim.

Before:
> where the imbalance they find gets corrected.

After:
> where you assess whether weighting can reduce the observed imbalance without giving a few respondents excessive influence.

### 71. 23_ch05.tex — Teaching weakspot

Reason: Add weighting assumptions and next checks between adjacent boxes.

Before:
> \begin{kaobox}[frametitle=Package Integration: \texttt{loebias}]

After:
> In the example above, weights adjust the respondent shares toward the frame shares for region and age group. They can improve an outcome estimate only to the extent that those variables help account for differences between respondents and nonrespondents. Check that every adjustment category has respondents, inspect the weight range, and compare the weighted and unweighted outcome. A close match to the margins is evidence that the adjustment ran as intended; it cannot show that unmeasured differences disappeared.

\begin{kaobox}[frametitle=Package Integration: \texttt{loebias}]

### 72. 23_ch05.tex — Editorial correction

Reason: Correct security claim contradicted by displayed token.

Before:
> The \texttt{dryrun} option prints any call without sending it, which is also how you keep a token out of a shared log:

After:
> The \texttt{dryrun} option prints the call without sending it. Use a placeholder token for demonstrations and shared logs: a dry run that prints a real token can expose it just as a live call can.

### 73. 11_ch01.tex — Editorial correction

Reason: Avoid leap from descriptive reach to site relocation.

Before:
> so the live question is no longer whether reach is uneven but which sites to move.

After:
> so the next discussion can focus on why particular sites missed the target and what changes staff could make.

### 74. 12_ch02.tex — Editorial correction

Reason: Remove impossible guarantee and decorative time promise.

Before:
> How do you set up a project once so that these failures cannot happen? A folder layout, a control file, and a few habits are the answer, and they take about ten minutes to put in place.

After:
> A consistent folder layout and a control file help you find the right files and make the paths work on another machine. We begin with that setup and then check whether a colleague can rebuild the results.

### 75. 12_ch02.tex — Editorial correction

Reason: Installation alone does not pin package versions.

Before:
> The control file and install file close the first three failures directly;

After:
> The control file, install file, and project package archive address the first three failures;

### 76. 21_ch03.tex — Editorial correction

Reason: Resolve leftover universal count after URL correction.

Before:
> every portal we present in this chapter is built from the same three parts:

After:
> the addresses in this chapter use a common structure:

### 77. 21_ch03.tex — Editorial correction

Reason: Retain existing values while removing invalid completeness inference.

Before:
> By 2022 the count had not just recovered but passed the old peak, reaching 5.52 million. The \texttt{n\_dist} column climbs steadily from 1{,}226 to 1{,}252 reporting districts, so the dip is a real loss of students, not an artifact of districts dropping out of the file.

After:
> By 2022 the count exceeded the earlier peak, reaching 5.52 million. The \texttt{n\_dist} column increases from 1{,}226 to 1{,}252 reporting districts, which is a useful completeness check. The number of reporting districts alone cannot rule out changes in which districts or students were counted, so compare district identifiers and coverage before interpreting the statewide change.

### 78. 21_ch03.tex — Editorial correction

Reason: A plausible geographic ordering is not external verification.

Before:
> The ordering is the external check on the pull:

After:
> The ordering is worth comparing with independent published values:

### 79. 21_ch03.tex — Editorial correction

Reason: Remove unsupported bound on revisions.

Before:
> since revised quarters shift by dollars, not hundreds.

After:
> using saved copies of the same quarter to identify revisions separately from changes over time.

### 80. 21_ch03.tex — Editorial correction

Reason: Replace tool praise with useful next check.

Before:
> You supplied a URL and received variables; no parsing step ever became your problem.

After:
> After import, inspect the identifier and the nested fields you plan to use, because flattening a reply does not establish that its rows match your intended unit of analysis.

### 81. 21_ch03.tex — Editorial correction

Reason: Remove marketing flourish and universal speed claim.

Before:
> Once JSON is no harder than CSV, meeting a short deadline no longer means settling for the handful of agencies that publish flat files: most modern APIs serve JSON, and that far larger set answers on the same twenty-minute budget. You can work across the whole open-data landscape, not just its friendly corner.

After:
> With a working JSON example to adapt, you can consider sources that publish nested records as well as flat tables. Allow time to check the record structure, authentication, and pagination before promising a new source on a short deadline.

### 82. 22_ch04.tex — Editorial correction

Reason: Remove idiom.

Before:
> Before automating a download, read the site the way a guest reads a house.

After:
> Before automating a download, inspect the site\textquotesingle s instructions and try a representative file manually.

### 83. 22_ch04.tex — Editorial correction

Reason: Replace rhetorical contrast with reason and action.

Before:
> Pushing a public server too hard can cost you the method itself, not just the afternoon. A scraper that gets an evaluator blocked has failed even if it ran, because the next quarter's update is now impossible. Politeness here is less a courtesy than maintenance on your own pipeline.

After:
> If the server blocks repeated requests, your next update may fail. Follow the agency\textquotesingle s limits and save successful downloads locally so routine debugging does not repeat requests unnecessarily.

### 84. 22_ch04.tex — Editorial correction

Reason: Remove enumeration teaser.

Before:
> Under \texttt{cmethod(append)}, three options do the combine half.

After:
> With \texttt{cmethod(append)}, you can use the year and rename-map options to align files before appending them.

### 85. 22_ch04.tex — Editorial correction

Reason: Remove dramatic language and clarify import mechanics.

Before:
> The header is where the real work starts, and it fails in two ways at once. First, the file's actual first data row is a second, machine-readable label row, so every column imports as a string and the numbers do not exist until you drop that row. Second, the real column names are long human phrases like \texttt{Premature Death raw value} that Stata munges into one lowercase token. You inspect the damage before you touch it:

After:
> Inspect the header before cleaning. The first imported observation contains machine-readable labels, which can cause otherwise numeric columns to import as strings. Stata also converts long header phrases such as \texttt{Premature Death raw value} into legal variable names. We examine the imported types and names before dropping the label observation and converting the measures:

### 86. 22_ch04.tex — Editorial correction

Reason: Avoid claiming every download error is a moved path.

Before:
> if a \texttt{copy} ever fails outright, the path has moved, and you repair it by finding the current address on the successor project's documentation page and updating the two macros, nothing else.

After:
> if \texttt{copy} fails, inspect the error and confirm the published address before changing the script. A moved file, a temporary server failure, and a local connection problem call for different responses.

### 87. 22_ch04.tex — Editorial correction

Reason: Remove metaphorical location verb.

Before:
> and land a modest Stata dataset at the end,

After:
> and write the selected records to a Stata dataset,

### 88. 22_ch04.tex — Editorial correction

Reason: Remove metaphor in streaming caption.

Before:
> matched records land in a modest \texttt{.dta}.

After:
> matched records are written to a \texttt{.dta}.

### 89. 22_ch04.tex — Editorial correction

Reason: Remove triumphant chapter conclusion.

Before:
> The agency that offers only download buttons can no longer stall you: you harvest the files anyway, survive the munged headers and stray label rows they arrive with, filter streams too large to hold, and absorb the mixed-format files that partners drop in a shared drive, all as scripted, replicable steps.

After:
> You can now plan a scripted download, check the downloaded files, clean irregular headers, and convert a partner\textquotesingle s mixed-format folder into Stata datasets. For larger files, you can assess whether streaming will reduce memory use enough to make the job practical.

### 90. 23_ch05.tex — Editorial correction

Reason: Remove counted preamble.

Before:
> Two design commitments frame everything that follows. The first is tailored design:

After:
> Survey design begins before the download. In their account of tailored design,

### 91. 23_ch05.tex — Editorial correction

Reason: Maintain transition after enumeration removal.

Before:
> The second is a shared vocabulary for what a response rate even is.

After:
> You also need a shared definition of a response rate.

### 92. 23_ch05.tex — Editorial correction

Reason: Remove rhetorical teaser in new source section.

Before:
> Here is what Stata's own missing-value summary shows:

After:
> We start with Stata\textquotesingle s missing-value summary:

### 93. 23_ch05.tex — Editorial correction

Reason: Remove absolute claim about manual downloads.

Before:
> \marginnote{Hand-downloading is the survey version of spreadsheet analysis: it works once and reproduces never.}

After:
> \marginnote{For any manual download, record the export settings and preserve the original. Scripting reduces the settings a colleague must reconstruct on the next pull.}

### 94. 23_ch05.tex — Editorial correction

Reason: Correct count and remove meta-praise.

Before:
> Those five locals are one small piece of statistical machinery.

After:
> We can express the reference lines and the alarm rule mathematically.

### 95. 23_ch05.tex — Editorial correction

Reason: Do not imply simulated calls caused recovery or hide material monitoring issues.

Before:
> The funder sees none of the mid-field churn, only the final response-rate narrative: the closing rate, the two sites that lagged, and the calls that recovered them, which presents monitoring as stewardship rather than trouble.

After:
> For the funder, report the closing response rate, the sites that lagged, the follow-up undertaken, and any unresolved gaps that affect interpretation. Describe a recovery only if the later records show it.

### 96. 23_ch05.tex — Editorial correction

Reason: Remove idiom and decorative time estimate.

Before:
> The changelog tracks the questions you asked; the data they produced needs a codebook of its own. When a new dataset lands on your desk, you spend the first hour learning it.

After:
> The changelog records the questions you asked; the resulting data need a codebook of their own. When you receive a new dataset, begin by inspecting its contents.

### 97. 23_ch05.tex — Editorial correction

Reason: Remove metaphorical location verb.

Before:
> and each figure sits in the same row as the label that names the variable it describes.

After:
> with each statistic next to the relevant variable label.

### 98. 23_ch05.tex — Editorial correction

Reason: Remove negate-assert transition.

Before:
> That covers any single file. A survey you field year after year raises a harder question: not only what this wave contains, but what moved since the last one.

After:
> For a repeated survey, compare the contents of each wave with the previous one before estimating a trend.

### 99. 23_ch05.tex — Teaching weakspot

Reason: Explain composition ratio versus response rate without rhetorical exaggeration.

Before:
> Read the ratio column the way a program officer would: the \enquote{Other} group arrived at 12~percent of its intended size, not slightly under-covered but nearly absent, and no amount of averaging over the full sample will speak for the group that is not in the room.

After:
> The ratio of 0.12 compares the \enquote{Other} category\textquotesingle s respondent share with its hypothetical target share: approximately 1.2 percent divided by 10 percent. It is not that group\textquotesingle s response rate, which would require the number invited in that category. Check the category definitions and the source of the targets before interpreting the gap.

### 100. 23_ch05.tex — Teaching weakspot

Reason: Explain limits of name-based relabel receipt.

Before:
> That receipt turns a silent mislabeling into a line you read before you trust the file: it says plainly that \texttt{q4} came back as \texttt{q4\_manage}, so seven of the eight variables were relabeled and one needs a human decision, rather than quietly attaching \texttt{q4}'s workload label to whatever column happened to abbreviate to it.

After:
> The receipt reports that \texttt{q4} is absent and \texttt{q4\_manage} is present; it cannot establish that they are the same item. Ask the collaborator whether the column was renamed, recoded, or replaced, then compare its values and meaning with the original before restoring a label. Seven variables matched by name, but those matches also require review if the collaborator changed any coding.

### 101. 23_ch05.tex — Teaching weakspot

Reason: Remove punchy coda and teach dataset-specific missing codes.

Before:
> The split between \texttt{Obs=.} and \texttt{Obs>.} is the whole answer, and it is easy to read past.

After:
> In this simulated file, ordinary missing values (\texttt{.}) identify items not shown and extended missing values identify refusals. Read those definitions with the summary; Stata\textquotesingle s missing-value codes do not assign those meanings automatically.

### 102. 23_ch05.tex — Editorial correction

Reason: Replace performative reversal with explanation.

Before:
> So the item that looks worse is the healthier one.

After:
> The intended denominators differ, so the overall completion percentages alone are misleading.

### 103. 23_ch05.tex — Editorial correction

Reason: Avoid diagnosing refusal from missingness alone.

Before:
> These are opposite problems with opposite fixes: routing is the questionnaire working, so you fix the denominator you report, if anything; refusal is a question-wording or placement problem, so you fix the instrument itself or carry the gap in a weighting model.

After:
> For correctly routed cases, use the number actually eligible for the item as its response-rate denominator. For refusals, discuss wording, placement, sensitivity, and other possible causes with the survey team; the missing-value code records what happened, but cannot establish why or whether weighting would address the resulting bias.

### 104. 23_ch05.tex — Editorial correction

Reason: Remove staccato counted opener.

Before:
> Three columns, three different things, and the last one names the gate that closed.

After:
> Read answered, declined, and not shown as mutually exclusive statuses, with the final column identifying the inferred routing condition.

### 105. 23_ch05.tex — Editorial correction

Reason: Remove numbered teaser and clarify denominator.

Before:
> One number in that table needs its denominator stated, because the same item carries a different percentage in the flow map of Figure~\ref{fig:ch05-flow}, where a gate splits the sample into lanes and each item is counted inside its own lane.

After:
> The receipt and flow map use different denominators. In Figure~\ref{fig:ch05-flow}, the branching question divides the sample into groups and the response percentage is calculated within the relevant group.

### 106. 23_ch05.tex — Editorial correction

Reason: Avoid stigmatizing and imprecise language.

Before:
> Thirty-one people consented to nothing, so they are absent from every later item.

After:
> In this simulation, 31 people declined consent and have no answers to later items.

### 107. 23_ch05.tex — Editorial correction

Reason: Remove metaphor and unsupported one-page scalability promise.

Before:
> \caption[Item status across the questionnaire]{Every item of the follow-up survey, in questionnaire order, each column split into the three fates and stacked to the whole sample. This view has no node budget, so a two-hundred-item questionnaire is still one page. The two problem items look nothing alike here: \texttt{wage} carries a tall dark block, which is people who were never asked, while \texttt{hh\_income} carries a mid-grey block, which is people who were asked and declined. A percent-missing table renders those two identical.

After:
> \caption[Item status across the questionnaire]{Items in the simulated follow-up survey, in questionnaire order, divided into answered, declined, and not shown. For \texttt{wage}, the dark block represents people who were never asked; for \texttt{hh\_income}, the mid-grey block represents those asked who declined. A single overall missing percentage would combine these reasons. For a longer instrument, check label legibility and divide the chart into sections if necessary.

### 108. 23_ch05.tex — Editorial correction

Reason: Remove metaphorical carry.

Before:
> \texttt{hh\_income} carries the flag

After:
> Beside \texttt{hh\_income}, you can read the flag

### 109. 23_ch05.tex — Editorial correction

Reason: Do not misclassify all verbatim responses as non-questionnaire data.

Before:
> One more caution, beyond the inference the box warns about. A delivered survey file is wider than the questionnaire, carrying record ids, sample-frame columns, interviewer admin and verbatim text, none of which were questions and all of which can look like branching.

After:
> Before scanning your own file, distinguish questionnaire items from record identifiers, sampling variables, and interviewer administration fields. Verbatim text may be an answer to an open question, so decide whether excluding it suits the purpose of the map.

## Final verification and remaining limits

- Applied 109 targeted edits, including 24 teaching weakspots. Read the added surveymap material when it appeared in the active source and included it in the pass. Broad voice retained in chapters 1–3; no chapter restructuring.
- New arithmetic checked directly: (1+0)/2 = 0.5; 457/900*100 = 50.7778 and 457/514*100 = 88.9105; K/(K-1) decreases for integer K > 1. Printed surveymap counts sum to 900 in every row. Retained pre-existing numerical outputs otherwise; no claim that all empirical source facts were re-audited.
- Primary-source cross-checks read 2026-09-05: Census ACS five-year comparison guidance, https://www2.census.gov/about/training-workshops/2026/2026-01-22-2020-2024-acs-5-year-prerelease-transcript.pdf ; Socrata pagination, https://dev.socrata.com/docs/paging.html ; Stata alpha reference, https://www.stata.com/manuals/mvalpha.pdf . QCEW path distinction checked against the literal URL already in the chapter; chrono/logging and simulation limitations checked against the displayed commands and companion do-files.
- No new executable examples were added. Existing code was inspected, including code/ch04_chr.do and code/ch05_monitoring.do. Their simulation and reporting limits now appear beside the prose claims. Assembly/compilation is assigned to root.
- Existing issues needing a broader code/example audit: chapter 2 CountyBudgets demonstration uses auto variables price/foreign; chapter 4 displayed keep command has an ellipsis and therefore is a fragment; chapter 5 scheduler examples are schematic and point at the simulation rather than a production platform pull; chapter 5 undummy invocation/options merit checking against shipped help. Root should distinguish these existing fragments from the newly added prose.
- Existing legal and empirical claims (scraping risk, CHR successor/end date, survey-platform entitlements, detailed external-study summaries) were not globally verified by this editorial pass. Corrections above address changed/new technical explanations. Avoid describing this as a comprehensive legal or evidence audit.
- The manuscript already does well at giving concrete evaluator situations, retaining complete Stata output, and connecting recurring datasets across chapters. The edits preserve that structure.
