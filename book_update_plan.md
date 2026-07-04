# Book Plan (July 2026 overhaul): Applied Evaluation Using Stata

This plan replaces the June 2026 plan. It reorganizes the book around the workflow of an embedded evaluator, moves causal methods down to a single section plus a reference appendix, and elevates the material practitioners reach for weekly: public-data APIs, survey platform automation, panel construction, infographic-quality graphics, and client-ready deliverables in Excel, Google Sheets, and self-contained HTML. The prior draft and plan are preserved in `BookManuscript_ARCHIVE_20260704_0032.tar.gz`.

Three research inputs shaped the changes. First, a genre study of thirteen Stata Press books: workflow books there are ordered as the reader's production pipeline, use gerund chapter titles, run 8 to 16 chapters, and close with reporting and protection chapters. Second, style field guides built from Gelman, Hill, and Vehtari's *Regression and Other Stories* and from Nick Cox's *Speaking Stata* columns; their concrete moves are folded into the style contract below. Third, an inventory of the authors' existing tools, worked examples, and public data sources, so every chapter is anchored to assets that exist or are honestly flagged as still to build.

---

## 1. Positioning: the shelf gap and the hook

**The gap.** Stata Press has intake books (Mitchell's *Data Management Using Stata*), output books (*Create and Export Tables Using Stata*), and estimation books (Cameron and Trivedi). No title spans design to deliverable for evaluators, and none treats the internet-facing work (APIs, survey platforms, web reports) that fills a working evaluator's week. Long's *Workflow of Data Analysis Using Stata*, the closest ancestor, is seventeen years old. This book claims that empty shelf space.

**The hook stays: the embedded evaluator.** Academic texts assume clean data, patient timelines, and neutral audiences. The embedded evaluator gets forty inconsistent spreadsheets on Thursday, a funder question due Monday, and findings with money attached. The book equips that person to run everything from one Stata command center: pull the data by API, assemble a trustworthy panel, answer the question at the right level of rigor, and hand the client something they can open, use, and keep.

**The four promises.** Every chapter and every tool is measured against four properties, introduced in Chapter 1 and used as recurring language throughout, in the way Gelman repeats "comparisons, not effects":

- **Replicable.** Anyone on the team can rerun it next month and get the same answer, from raw source to final figure.
- **Extensible.** The next wave, year, site, or client fits without rewriting; the pipeline grows by parameter, not by copy-paste.
- **Accessible.** Program staff, funders, and partners can read, open, and understand the outputs without a statistics degree or a software license.
- **Actionable.** The output tells someone what to do next Monday, in the units they budget and staff in.

Each section's narrative says explicitly which promises it serves and why the reader's partners and audiences benefit. This is a book requirement, not decoration: it is the applied researcher's answer to "why are we doing it this way?"

**What this book is not.** It is not a causal inference text. Causal methods get one working section (8.2) and a quick-reference appendix that routes readers to the right estimator and the right specialist book. The rest of the causal-frontier material from earlier drafts is cut or reduced to pointers (migration map in Section 6 below).

---

## 2. Title proposals

Stata Press house grammar is "[task noun phrase] Using Stata," with a subtitle that promises a mode of use rather than restating content. Three candidates, in recommended order:

1. **Applied Program Evaluation Using Stata: A Practical Workflow from Data to Deliverables.** On-genre, names the audience's task, and the subtitle states the book's actual span (all data, not just public; through to client deliverables). This is the working subtitle now in `main.tex`.
2. **Evaluation Workflows Using Stata: A Practical Guide for Embedded Researchers.** Leans on the "workflow book" sub-genre signal; keeps the embedded identity in the subtitle.
3. **Embedded Evaluation: Stata Tools for Applied Research and Evaluation.** The current title. Distinctive but off-genre; if kept, consider adding "Using Stata" to the subtitle for shelf findability.

A Gelman-style page of "fun alternate chapter titles" in the front matter is planned regardless (one wry alternate per chapter; see style contract).

---

## 3. Style contract

House rules for every chapter, drawn from the Gelman and Cox field guides plus the authors' own writing rules. Writers and revisers check drafts against this list.

**Voice and paragraphs**
1. Plain declaratives, first-person plural, present tense. Confidence without boasting; minimal em-dashes.
2. Every paragraph: topic or transition sentence first, then the evidence or rationale, then the why-we-care sentence connecting to the chapter's job. Groups of paragraphs get explicit signposts.
3. Jargon is defined at first use in plain words, labeled as jargon ("in survey jargon, this is *unit nonresponse*"), or deferred with a forwarding address ("we take this up properly in Section 8.2"). No technobabble, no filler phrases.
4. Pithy, earned aphorisms as memory hooks, one per major idea, Cox-style: "no news is good news" for residual scatter; ours include "Excel is a format, not a calculator" and "the estimate is only as credible as the comparison group."
5. Honest hedging in words, not hedging by vagueness: "the gain shrinks to 1.7 points, and we would not bet the program on the difference."

**Structure and signposts**
6. Chapters open with the reader's felt pain in one or two sentences (Cox), then a one-paragraph roadmap that links backward, announces the plan, and previews the close (Gelman).
7. Chapters end with a short "Where this leaves you" section: what you can now do, which promises it served, and a one-sentence trail to the next chapter.
8. Cross-references always carry numbers ("Section 6.3," "Figure 9.4"), never "as we saw earlier."
9. Section titles: gerund-plus-object for actions ("Merging the unmergeable"), noun phrases for objects of study ("The cross-wave codebook"), and an occasional full-sentence title when the section is the claim ("Excel is a format, not a calculator").

**Code, examples, and figures**
10. The four-beat example rhythm: one or two paragraphs of real backstory; a short code block (never a dump); verbatim output; interpretation of each number in policy units (percentage points, dollars, students, weeks). Then the "This makes sense:" check against substantive intuition.
11. The exact command appears above every figure it produces. Captions are self-contained: plot type, then an interpretive sentence, sometimes a question.
12. Offstage work is confessed, not hidden ("we cleaned the district names offstage; the do-file shows the surgery").
13. Named running examples with a data-folder footnote at first use; examples recur across chapters with explicit forward and backward references.
14. Boxed elements keep their current three types: *Applied Example* (end-to-end scenario), *Visualization to build* (chart spec with the story it must tell), and *Ado-file idea* (short plan for a tool, no code in this pass).
15. Each tool introduction reviews what official Stata or existing community commands already do, states the gap, then lists the new tool's design principles as bullets (Cox).

**Front and back matter (Stata Press conventions)**
16. Chapter 1 carries the meta-sections: read me first, the four promises, the running examples with one subsection per dataset, how the book is organized, support materials.
17. Preface includes a Gelman-style skills contract: one "after this chapter you can..." line per chapter, plus suggested reading paths for three personas (program evaluator at a nonprofit, agency/foundation analyst, research shop tool-builder).
18. Back matter: appendices, references, subject index. Data and packages installable from inside Stata (GitHub `net install` now; `stata-press.com/data/<abbrev>` pattern if the book lands there).

---

## 4. The new structure

Fifteen chapters in five parts, ordered as the embedded evaluator's production pipeline: set up, get data, make evidence, communicate, sustain. Part titles are terse noun phrases (house rule); chapter titles are workflow gerunds with two deliberate exceptions.

For each section below: what it covers, the assets it draws on, and the "why" annotation that the manuscript text must carry (audiences served, promises kept).

### Part I. The Embedded Workshop

#### Chapter 1: The embedded evaluator (read me first)
*Felt pain opening: the Thursday email, the Monday deadline, the forty spreadsheets.*

- **1.1 Who this book is for, and the week it assumes.** Personas and the real constraints: small team, standard Stata licenses, protected data, funders who read only page one. *Why: sets expectations so each reader knows which chapters pay their salary; serves accessibility by writing to the actual audience, not an idealized one.*
- **1.2 Four promises: replicable, extensible, accessible, actionable.** Defines the book's evaluative language with one concrete pass/fail example per promise (e.g., replicable = a colleague reruns the Monday brief from raw files with one command). *Why: gives evaluators the vocabulary to justify workflow investments to partners and supervisors; every later chapter closes against these.*
- **1.3 Working embedded: partners, power, and bad news.** Data ownership agreements on day one; pre-registered outcome definitions as a shield; building staff evaluation literacy with plain-language data dictionaries generated from `codebook, compact` and `labelbook`. Keeps the funder's-question Applied Example (rural reach, answered by Monday). *Why: findings survive politics only when the ground rules pre-date the findings; literacy work makes front-line staff partners in data quality rather than sources of missingness. Serves actionable and accessible.* *Ado-file ideas:* `evalaudit` (project startup checklist auditing data-sharing agreements and funder mandates), `datadict` (NEW; see Section 5).
- **1.4 The running examples and the book's toolkit.** One subsection per running dataset (Stata Press convention): the Texas STAAR school panel, County Health Rankings state/county files, BLS QCEW county wages, the PRAMS workbooks, and a small simulated program-enrollment file for survey chapters. Install pattern for the companion packages. *Why: named, downloadable, recurring data is what makes the book itself replicable.*
- **1.5 How the book is organized.** The pipeline map, chapter by chapter, plus the three persona reading paths.

#### Chapter 2: Setting up a workshop that survives deadlines
*Felt pain: the do-file that ran last month and dies today, on your coworker's laptop.*

- **2.1 One folder pattern for every project.** The numbered pipeline (`100_ingest` through `600_report`), a master control do-file, parameters separated from logic; cross-platform paths with `driveuse`. *Why: the next analyst, including future you, finds everything where they expect it; extensibility begins as a directory layout.* *Ado-file idea:* `projectbuilder` (scaffolds the layout, globals, and master do-file).
- **2.2 Excel is a format, not a calculator.** The no-spreadsheet-analysis rule and what replaces each spreadsheet habit. *Why: audit trail; the difference between "trust me" and "rerun me" when a client challenges a number. Serves replicable.*
- **2.3 Speed you will actually notice.** `gtools`/`ftools`, filter-on-import, `compress`, memory habits for standard (non-MP) Stata, benchmarked on the STAAR ingest loop (400 MB yearly files, only the needed slice ever lands in memory). *Why: iteration speed is analysis quality; a pipeline that reruns in minutes gets rerun, one that takes a day gets patched by hand.*
- **2.4 Recording what you did.** Logs, version control basics for do-files, dependency capture with `usepackage`, and minimal working examples with `writeinput` when asking for help or filing bugs. *Why: replicable includes the environment, not just the code.*

### Part II. Getting the Data

#### Chapter 3: Downloading public data through APIs
*Felt pain: the context statistic the funder wants exists at census.gov and you have 20 minutes.*

- **3.1 The shape of an API request.** URL anatomy, keys and where to keep them (`profile.do`, never in shared code), JSON versus CSV endpoints, polite request habits. *Why: one mental model covers every agency; this is the chapter's grammar lesson before the vocabulary.*
- **3.2 Census data with getcensus.** ACS tables at any geography, `getcensus catalog` for discovery, building a county covariate panel in four commands. Flag honestly: the package covers ACS; decennial/CPS endpoints get the thin Python bridge from 3.6. *Why: denominators and community context on demand; the reach-check example from 1.3 gets its benchmark data here. Serves actionable (real geography, real units) and replicable.*
- **3.3 Education panels with educationdata.** The Urban Institute portal's harmonized CCD/IPEDS/CRDC endpoints from the official Stata package; no key, consistent names across years. *Why: cross-year name harmonization done by someone else is a gift; the panel arrives analysis-ready.*
- **3.4 Economic series with import fred and BLS flat files.** Native `import fred` for state/county series; the QCEW open-data CSV pattern (`import delimited` a URL, loop years and quarters, no key at all). *Why: the cleanest replicable-download loop in the book; wages and unemployment are the context every workforce evaluation needs.*
- **3.5 Health and community context: PLACES and County Health Rankings.** Socrata CSV endpoints with query filters; the `$limit` silent-truncation gotcha in a warning box; CHR annual analytic files by stable URL. *Why: small-area health estimates make need visible to funders; the truncation box saves readers a real, common error.*
- **3.6 Three routes from Stata to any API.** The general pattern from the authors' Stata Journal work: bare `import delimited` from a URL; a `python:` block with `requests` for authenticated JSON; `file write` for web output. Decision rules for which route. *Why: extensible; when the next agency posts a new endpoint, the reader already owns the pattern.*
- *Ado-file idea:* `panelstack` (NEW; see Section 5). *Applied Example:* a 2015-2023 Texas county panel (income, child poverty, unemployment) assembled from three APIs and stacked with provenance tags.

#### Chapter 4: Harvesting data when there is no API
*Felt pain: the state posts exactly what you need, as 84 separate download-button files.*

- **4.1 Reading the site before you scrape.** Terms of use, form structure, politeness delays, resumability; when to ask the agency for a bulk file instead. *Why: embedded evaluators depend on agency goodwill; scrape like someone who has to email them next week.*
- **4.2 A real case: fourteen years of Texas school report cards.** The TEA TAPR downloader pattern (form parsing, year/level loops, organized output folders) and the honest lesson that element names mutate across years, resolved with the master reference sheet and rename maps. *Why: this is what "panel datasets that are tricky to download and combine" actually looks like; the payoff is a district panel no one else in the room has.*
- **4.3 Streaming the impossibly large.** The price-transparency pattern: filtering a 100+ GB cloud JSON stream down to a Stata dataset on a laptop. Presented as a case study in not downloading what you cannot hold. *Why: extends the reader's sense of what a small shop can do; the sieve idea generalizes.*
- **4.4 Converting whatever lands in the shared drive.** `convertanything` for folder trees of mixed formats; hand-crafted `import excel, cellrange()` for published-for-humans workbooks, with the PRAMS block geometry as the worked case and the rule "document the geometry you assumed." *Why: accessible in reverse; the world sends people-formatted files, and the pipeline must absorb them replicably.*

#### Chapter 5: Working with survey platforms
*Felt pain: the survey closes Friday and nobody can say what the response rate was on Tuesday.*

- **5.1 Pulling responses automatically.** The platform-by-platform patterns: REDCap's single POST (simplest), Qualtrics' three-step export, SurveyMonkey pagination and its rate limits, KoBoToolbox, and the zero-auth Google Sheets one-liner (`import delimited` on a link-shared response sheet) as the instant win. *Why: hand-downloading is the survey version of spreadsheet analysis; automation makes monitoring possible at all. Serves replicable and extensible.*
- **5.2 Watching response rates while the survey is alive.** A scheduled monitoring do-file; response counts against the roster; control-chart logic for when a dip is noise versus news; attrition alerts; demographic reach against benchmarks. *Visualization callout:* the control chart, small-multiples by site. *Ado-file idea:* `reachcheck`. *Why: mid-course corrections happen only if the evaluator can see mid-course; this is the most directly actionable section in the book, and program teams are the audience.*
- **5.3 From platform metadata to labeled variables.** Question text into variable characteristics (`char define`), auto-encoding from platform metadata, and `surveytracker` for logging instruments wave over wave. *Why: the codebook writes itself, and the survey's meaning travels with the data.*
- **5.4 Scales without tears.** `likertscale`: encoding, reverse-coding, alpha, indices, top-two-box percent-agree variables that clients actually read. *Why: accessible; percent-agree is the lingua franca of program boards, and computing it consistently prevents quiet errors.*
- **5.5 Who did not answer, and does it matter.** Unit versus item nonresponse, frame comparisons with `nonresponse`, level-of-effort stabilization with `loebias`, and the handoff to weighting in Chapter 7. *Why: the honest answer to "can we trust a 22 percent response rate" is a diagnostic, not a shrug.*
- **5.6 The cross-wave codebook.** `cxchangelog`: regenerate the item-changes inventory from a long-format crosswalk; lifecycle codes for added, reworded, re-optioned, and dropped items; diff against a frozen vintage. Demo data: a synthetic multi-wave crosswalk (planned; see Section 5). *Why: extensible across waves and staff turnover; the tracker answers "did we change this question in 2024?" in seconds instead of an afternoon.*
- *Ado-file idea:* `surveypull` (NEW; see Section 5).

#### Chapter 6: Building panels you can trust
*Felt pain: two agency files, no shared ID, and a merge that must survive an audit.*

- **6.1 Merging the unmergeable.** Cleaning names, blocking, string distance, thresholds with a manual-review band; nearest-value joins on dates and amounts with `nearmrg`. *Ado-file idea:* `fastmatch` (EM-based probabilistic linkage). *Why: most administrative questions are join questions; documented match quality is what makes the answer defensible.*
- **6.2 Crosswalks as first-class files.** State, region, rurality, district lineage; versioned lookup tables in the repo. *Why: crosswalks encode decisions; treating them as data makes the decisions reviewable.*
- **6.3 Where did this number come from?** Source lineage in variable characteristics with `srctag`, warehouse search with `srcfind`; the skeptical-client scene (running the lineage check in front of the workforce agency) kept from the prior plan. *Why: trust with agency partners is won by traceability; this is the accessibility of provenance.*
- **6.4 Schema drift and the polluted year.** Declarative validation with `schemaudit` (rulebook of required variables, legal values, uniqueness); flagging known-bad periods rather than averaging over them, with the 2016 STAAR vendor failure as the worked case. *Why: the pipeline should refuse bad data loudly; a documented flag today prevents a wrong finding next year.*
- **6.5 Reshaping into analysis-ready panels.** Panel IDs, wide/long discipline, transition matrices of participant movement. *Visualization callout:* the Sankey flow. *Ado-file idea:* `trackflow`. *Why: the panel is the book's central data structure; participant-flow pictures answer the program director's first question, "where do people go?"*
- **6.6 Missing data honestly.** Patterns with `misstable`, the missingness map, when multiple imputation earns its complexity. *Why: dropped rows are silent decisions; making them visible is a replicability duty.*

### Part III. Turning Data into Evidence

#### Chapter 7: Making numbers trustworthy
*Felt pain: a five-person site ranks worst in the state because one family moved.*

- **7.1 From items to reliable scales.** Alpha, exploratory factor checks, when IRT adds value for an applied shop. *Why: a scale that does not hang together produces findings that do not replicate across waves.*
- **7.2 Weights that restore the population.** `svyset`, post-stratification, raking against frame margins, connected back to the nonresponse diagnostics of 5.5. *Why: representativeness is the difference between "our respondents" and "our participants"; funders quote the second.*
- **7.3 Small sites, noisy rates.** Empirical Bayes shrinkage for sparse denominators. *Ado-file idea:* `rateshrink` (Beta-binomial and Poisson-gamma shrinkage with a raw-versus-shrunken scatter). *Why: rankings drive funding and blame; stabilized rates protect small sites from statistical accidents. Directly actionable for dashboard builders.*
- **7.4 Power and the smallest effect you can see.** MDE framing for program directors, cluster designs, the power curve with the budget line marked. *Why: the most expensive mistake is the study too small to find what it was funded to find; this section is stakeholder expectation management with math.*

#### Chapter 8: From differences to defensible claims
*Felt pain: "so did it work?" asked in a room with money on the table.*

- **8.1 Comparisons first.** Well-built descriptive comparisons, uncertainty stated in policy units, the "This makes sense:" ritual, and the discipline of pre-specified primary outcomes. *Why: most evaluation questions are answered credibly at this level; rigor is matching the claim to the design, not maximizing machinery.*
- **8.2 When only a causal claim will do: a working DiD kit.** THE causal section, and deliberately the only one. Staggered rollouts and why naive two-way fixed effects mislead (the contaminated-comparison intuition, one paragraph, no algebra); `csdid` on the Medicaid expansion workshop data end to end; the event-study plot as the design's honesty check; a closing map of adjacent designs (cutoffs, single units, interrupted series) in three sentences each, all routed to Appendix B and the specialist shelf (Cunningham; Huntington-Klein). Anchored by the STAAR baseline-sensitivity lesson: the estimate is only as credible as the comparison group. *Why: applied researchers need enough causal literacy to use `csdid` responsibly and to know when to call a specialist; one honest section serves them better than five chapters they will not read.*
- **8.3 What did it cost, what did it return.** Cost-effectiveness perspectives, discounting, Monte Carlo uncertainty. *Visualization callout:* the tornado chart. *Ado-file idea:* `roisim`. *Why: funders ask this question directly; an ROI with honest error bars beats a point estimate that overpromises.*
- **8.4 Subgroups without fishing.** Pre-registration of subgroup analyses, exploratory findings labeled as such. *Why: the garden of forking paths is a reputational risk for an embedded shop; the discipline here is what makes 8.1's simplicity trustworthy.*

### Part IV. Communicating Results

#### Chapter 9: Graphing for busy readers
*Felt pain: your finding is real and your graph is why nobody saw it.*

- **9.1 The data-ink budget.** Cox and Tufte principles as working rules with an aphorism and a failure mode per graph type; colorblind-safe palettes; direct labels over legends. *Why: the graph is the finding for most readers; ink spent on decoration is attention taken from the result.*
- **9.2 Distributions and categories that read at a glance.** `statplot`, `catplot`, diverging Likert bars for survey items. *Why: survey results in particular die in stacked-bar noise; these layouts are the rescue.*
- **9.3 Coefficients as pictures.** `coefplot`, small multiples across outcomes and subgroups on a shared scale. *Visualization callout:* the small-multiple coefficient plot. *Why: a regression table is a wall; the same information as a picture invites comparison.*
- **9.4 Trends with a story line.** Run charts with annotated reference lines (`xline()` at the policy change), control charts from 5.2 revisited as communication devices. *Why: "did the line move after we acted" is the program officer's native question; build the graph that answers it at a glance.*
- **9.5 Captions that carry the finding.** The self-contained caption discipline: plot type, takeaway sentence, cross-reference. *Why: reports are skimmed; captions are read.*

#### Chapter 10: Building interactive charts and infographics
*Felt pain: the board wants "something like the newspaper does," due Thursday.*

- **10.1 Sparklines: the word-sized trend.** `sparkta2` inline trends in portfolio tables; forty sites scanned in one column. (Prerequisite flagged: the sparkta2 source must be published to the authors' GitHub before print; currently only rendered galleries are public.) *Why: density with dignity; portfolio managers see every site's trajectory without forty pages.*
- **10.2 Fourteen chart types from one command.** `googlechart`: geo choropleths, animated bubbles over panels, searchable tables, diverging bars; brand theming; the download menu for client self-service. *Why: infographic-quality output from a do-file keeps the graphic inside the replicable pipeline instead of in a designer's one-off file.*
- **10.3 Choosing static, interactive, or animated.** Decision rules by audience and venue; when interactivity subtracts. *Why: the medium is a claim about how the audience will use the evidence; choose it deliberately.*

#### Chapter 11: Delivering through spreadsheets
*Felt pain: the client lives in Excel and Sheets, and will not leave.*

- **11.1 Formatted Excel from collect and putexcel.** Automated summary and appendix workbooks; the Monday-morning update as a scheduled artifact. *Ado-file idea:* `fundertable` (pre-formatted executive summary tables). *Why: meeting clients in their native format is accessibility in practice; automation makes the recurring deliverable cheap enough to sustain.*
- **11.2 Google Sheets as a live channel.** `googlesheets`: export, `put` values and formulas, format, insert native charts, and re-import for round-trip QA; OAuth setup deferred to Appendix A; the Forms-response import (`since()`, `tail()`) bridging back to Chapter 5. *Why: a Sheet the whole program team can open, on their phones, updated by your do-file, is embedded evaluation made tangible.*
- **11.3 Toolkits program teams keep using.** The capstone Applied Example: an enrollment-tracker toolkit for a field team (validated entry tab, auto-updating charts, plain-language data dictionary tab from `datadict`), built and refreshed entirely from Stata. *Why: this is the book's thesis in one artifact; the evaluator ships a tool, not a PDF, and the team's own data quality improves because they can see themselves in it.*

#### Chapter 12: Publishing self-contained reports and portals
*Felt pain: the client's firewall eats anything that needs a server.*

- **12.1 From do-file to webpage.** `webdoc2`: headings, collapsible code, navigation, numbers in the text that come from the data. *Why: the report that regenerates itself cannot drift from the analysis; replicable reporting is the end of copy-paste errors.*
- **12.2 Interactive without a server.** `statashiny`: searchable tables, live-filtering charts, value cards, all in static files. *Why: interactivity for clients behind restrictive IT, with nothing to install and nothing to maintain.*
- **12.3 One folder the client can own.** Assembling the offline portal; optional GitHub Pages publication; versioning delivered artifacts. *Applied Example:* from do-file to shareable project portal (kept and expanded with the live example sites). *Why: handing over a folder the client controls respects their ownership of their own evidence; extensible because next quarter is one rerun away.*

### Part V. Sustaining the Practice

#### Chapter 13: Using AI without getting burned
*Felt pain: 5,000 free-text case notes, one intern, and a coding deadline.*
Consolidates all prior AI material (old Chapters 2.4, 3, 4.2, and 14.2) into one chapter of guardrails and one worked pattern.

- **13.1 What never leaves the building.** FERPA/HIPAA constraints, PII stripping before any API call, local models for protected text. *Ado-file idea:* `ai_privacy_gate`. *Why: one leaked record can end a data-sharing agreement; privacy is the precondition for using these tools at all.*
- **13.2 A measurement, not an oracle.** LLM output treated as a measurement requiring validation: human-coded gold standard, kappa thresholds, multi-model consensus with `llmsieve`. *Why: fluent is not accurate; the validation protocol is what makes AI-coded variables publishable.*
- **13.3 Reproducing stochastic output.** Pinned versions, temperature zero, cached responses as the frozen analysis dataset; model-agnostic wrappers (the `gemini` command and its local Ollama fallback). *Why: replicable includes the model; tomorrow's rerun must not change today's finding.*
- **13.4 Untrusted text and prompt injection.** Separating instructions from data; validating output values; auditing classification distributions. *Why: survey respondents can write anything, including instructions to your model.*
- **13.5 Auditing prediction for fairness.** When models target people (outreach lists, risk scores): selection rates, error-rate balance, the four-fifths rule with `faircheck`. *Why: targeting models inherit history; the audit is the evaluator's duty of care to participants, and increasingly the funder's compliance question.*
- **13.6 Coding 5,000 progress notes without getting burned.** The kept Applied Example, now the chapter capstone: gate, gold standard, sieve, verify, cache, disclose. Also here: `text2vars` and `stata2brief`/`evalpreflight` as drafting and adversarial-review aids, each behind the same guardrails.

#### Chapter 14: Sharing data and results safely
*Felt pain: the partner wants the file, the lawyer wants it de-identified, both by Friday.*

- **14.1 Quasi-identifiers and re-identification.** k-anonymity and l-diversity in plain terms; ZIP plus birthdate plus sex as the canonical trap. *Ado-file idea:* `riskscan`. *Why: "we removed the names" is not de-identification; the metrics give the lawyer and the evaluator a shared standard.*
- **14.2 Suppressing small cells without lying.** Primary and complementary suppression, denominator thresholds, integrated with `collect` before export. *Ado-file idea:* `suppress`. *Why: public dashboards and small subgroups collide constantly; principled suppression keeps tables publishable and people unidentifiable.*
- **14.3 Synthetic stand-ins.** Generating synthetic cohorts that preserve structure for code development and external collaboration. *Ado-file idea:* `synthgen`. *Why: partners can build against realistic data while the real records never move.*
- **14.4 Sanitizing raw files with a human in the loop.** The production pattern: scan incoming files, emit a for-human-review workbook, execute removals with dry-run mode and an audit receipt. *Ado-file idea:* `rawsweep` (NEW; see Section 5). *Why: intake is where PII sneaks in; a receipt-producing gate makes compliance demonstrable, not asserted.*

#### Chapter 15: Turning scripts into shared tools
*Felt pain: three colleagues, three slightly different copies of the same do-file, three answers.*

- **15.1 When a do-file wants to be a command.** The `dsload` story: extract, parameterize, generalize. *Why: the team's consistency problem is a packaging problem; extensibility across people, not just projects.*
- **15.2 Help files people actually read.** SMCL basics, the runnable-example rule, `editanything` as the developer's opener. *Why: a tool without a help file dies with its author's memory.*
- **15.3 Distributing through GitHub and net install.** `.pkg` and `stata.toc`, versioning internal libraries, install lines clients and colleagues can paste; `ScrapeSSC` for air-gapped machines. *Why: distribution is what turns a fix into a standard; accessible to teammates by design.*
- **15.4 A dash of Mata and Python where it counts.** The trifecta in one honest section: Stata as the system of record, Python for web and APIs, Mata only where matrix speed pays (with `lstrfun` as the example). Absorbs and retires the old Mata chapter. *Why: evaluators need the seams, not the languages; know enough to call across them.*
- **15.5 The replication archive.** The two-tier pattern: canonical deposit with a DOI on openICPSR, convenience mirror on GitHub where `use "https://raw.githubusercontent.com/..."` works in one line; what goes in the archive (data, code, codebooks, environment). *Why: the book ends where the genre says it must, on protection and permanence; the archive is the four promises kept after the contract ends.*

### Appendices

- **Appendix A: The setup guide.** Consolidated one-time configuration: API keys and `profile.do`; the Python bridge and venvs; Google Cloud OAuth for `googlesheets` (with the credential-free Sheets fallback for readers who skip it); LLM CLI and local Ollama setup. *Kept from old Appendix A, widened beyond LLMs so no chapter carries setup friction in its body.*
- **Appendix B: The causal quick-reference toolbox.** Expanded from the old Appendix B into the landing zone for everything Part III used to hold: scenario-to-estimator table (staggered timing, cutoffs, single units, interrupted series, high-dimensional confounding), the Stata command for each (`csdid`, `jwdid`, `rdrobust`/`rddensity`, `synth`, `sdid`, `ddml`), one-paragraph intuition each, sensitivity tools (`honestdid`, `psacalc`), and an annotated pointer shelf (Cunningham; Huntington-Klein; Cameron and Trivedi Vol. II).
- **Appendix C: The book's toolkit.** Roster of every package and proposed tool with chapter homes and install lines (updated to the new numbering; adds googlesheets, googlechart, statashiny, cxchangelog, and the four new proposals).
- **Appendix D: Two end-to-end walkthroughs.** Kept: D.1 PRAMS (messy workbook to ecological regression, the honest null) and D.2 Texas STAAR (big administrative panel, the baseline-sensitivity lesson), with cross-references retargeted to new chapter numbers. Known fixes carried as tasks: regenerate the contaminated STAAR log; ship the 15.6 MB analytic checkpoint rather than 5 GB of raw CSVs; note the `estout`/`coefplot` installs; fix the West Virginia crosswalk nit.

---

## 5. Tool roster

### 5.1 Existing packages the book showcases (published, installable)

| Package | Chapter home | Role |
|---|---|---|
| `googlechart` | 10 | 14 interactive chart types from one command; flagship infographic tool |
| `googlesheets` | 11 (5, 3) | Sheets import/export/put/format/addchart; live client channel |
| `statashiny` | 12 | Serverless interactive dashboards |
| `webdoc2` | 12 | Bootstrap-5 dynamic HTML reports over Jann's webdoc |
| `sparkta2` | 10 | Inline sparklines and offline D3 graphics — **source must be published before print** |
| `statplot` | 9 | High-density categorical/statistical plots (with N. Cox) |
| `convertanything` | 4 | Folder trees of mixed formats to clean datasets |
| `nearmrg` | 6 | Nearest-value merges on dates/amounts |
| `writeinput` | 2, 15 | In-memory data to reproducible input blocks (MWEs) |
| `editanything` | 15 | Open any text file from the command line; dev workflow |
| `usepackage` | 2 | Dependency scan and auto-install |
| `ScrapeSSC` | 15 | Local SSC catalog for air-gapped installs |
| `gemini` | 13 | LLM CLI bridge with local Ollama fallback |
| `validemail` | 5 | Survey email validation (format, MX, disposable) |
| `driveuse` | 2 | Cross-platform Google Drive path resolution |
| `importR` | 4 | R data formats into Stata |
| `surveytracker`, `likertscale`, `nonresponse`, `loebias`, `llmsieve`, `faircheck`, `evalpreflight`, `srctag`/`srcfind` | 5, 5, 5, 5, 13, 13, 13, 6 | Specified in Section 5.4 below (specs carried forward) |

### 5.2 Proposed tools carried forward (plans only, no code this pass)

`projectbuilder` (Ch 2), `reachcheck` (Ch 5), `fundertable` (Ch 11), `ai_privacy_gate` (Ch 13), `evalaudit` (Ch 1), `riskscan`/`suppress`/`synthgen` (Ch 14), `rateshrink` (Ch 7), `schemaudit` (Ch 6), `fastmatch` (Ch 6), `trackflow` (Ch 6), `cxchangelog` (Ch 5), `roisim` (Ch 8), `text2vars`/`stata2brief` (Ch 13).

### 5.3 New tool ideas added this pass (plans only)

- **`surveypull` (Ch 5).** One wrapper over the platform APIs: `surveypull, platform(redcap|qualtrics|surveymonkey|kobo|gsheet) ...` with subcommands `responses` (download to labeled .dta), `monitor` (counts and response rates against a roster, exit code for schedulers), and `codebook` (platform metadata to a data dictionary). Fills the inventory's biggest gap: no existing repo touches Qualtrics/REDCap. Design principle: REDCap first (simplest API), one authentication story per platform, all secrets in environment variables.
- **`panelstack` (Ch 3-4).** Stacks year-stamped files into a harmonized panel: takes a folder pattern plus a rename-map CSV (old name, new name, first year, last year), applies vintage-aware renames, tags provenance with `srctag` conventions, and reports what failed to match. Solves the "combine half" of the TAPR/QCEW/CHR download loops, which the inventory flagged as undemonstrated.
- **`datadict` (Ch 1, 11).** Generates a plain-language data dictionary (HTML or a Sheets/Excel tab) from variable labels, value labels, characteristics, and missingness rates, ordered for program staff rather than analysts. The evaluation-literacy tool 1.3 promises; pairs with the Chapter 11 toolkit example.
- **`rawsweep` (Ch 14).** Generalizes the production sanitization pattern that currently exists only in deleted git history: scan incoming raw files, emit a for-human-review workbook of flagged fields, execute removals with confirmation and dry-run modes, and write an audit receipt. Resurrects a real, book-worthy workflow before it is lost.

### 5.4 Detailed specs carried forward unchanged

The nine tool specifications from the June plan (`loebias`, `faircheck`, `llmsieve`, `evalpreflight`, `surveytracker`, `likertscale`, `nonresponse`, `srctag`, `srcfind`) remain the reference specs; they are unchanged except for chapter renumbering and live in the archive copy of the June plan and in Appendix C's roster. The unit-test plan (test_*.do per tool) carries forward and gains `test_surveypull.do`, `test_panelstack.do`, `test_datadict.do`, `test_rawsweep.do`, and `test_cxchangelog.do` (fix the `code(baselice|simple)` typo to `code(baseline|simple)` when implementing).

### 5.5 Cut from the plan, with reasons

`did_selector`, `sdid_viz`, `twinmatch`, `causalforest`, `conformalpred`, `cate_explorer` (causal/ML scope removed; Appendix B points to existing community tools instead); `mata_bench` (Mata reduced to one section); `gtools_audit` and `fidplot` (thin value next to their chapters' main tools); `llm_verify` (subsumed by `llmsieve`); `qualtrics_pull`/`redcap_pull` (subsumed by `surveypull`).

---

## 6. Worked-example data roster

Ranked for the book's needs: free, low login friction, panel/time dimension, policy relevance, shippable size.

| # | Dataset and access | Book home |
|---|---|---|
| 1 | NCES CCD district enrollment via `educationdata` (no key) | Ch 3 core demo; Ch 6 panel |
| 2 | BLS QCEW county flat CSVs (no key, `import delimited` loop) | Ch 3.4; `panelstack` demo |
| 3 | FRED state/county series via native `import fred` (free key) | Ch 3.4; reshape teaching moment |
| 4 | ACS county tables via `getcensus` (free key) | Ch 3.2; reach-check benchmarks |
| 5 | CDC PLACES county file via Socrata CSV (no key) | Ch 3.5; `$limit` gotcha box |
| 6 | County Health Rankings analytic CSVs 2010-2025 (no login) | Ch 3.5; Ch 10-11 dashboard data (already used in the SJ paper) |
| 7 | Texas TEA TAPR advanced downloads (no login, messy) | Ch 4.2; the "real client data" case |
| 8 | Medicaid expansion workshop panel (ships with NSF materials) | Ch 8.2 csdid worked example |

Plus: PRAMS 2016-2022 workbooks (shipped files; **note: the PRAMS ARF request portal is suspended as of mid-2026, so PRAMS is presented as shipped public workbooks and a sidebar on DUA-based access, never as a live-API example**); the STAAR analytic checkpoint (`analytic_performance.dta`, 15.6 MB, shippable) with download instructions for the 5 GB raw layer; a simulated enrollment/survey file for Chapters 5 and 11 (to be generated, ships with the book); a synthetic multi-wave item crosswalk for the `cxchangelog` demo (to be generated).

Hosting: canonical archive on openICPSR with a DOI, convenience mirror on GitHub for one-line `use` from raw URLs (the Ch 15.5 pattern, practiced on the book itself).

---

## 7. Migration map (old structure to new)

| Old (June 2026) | Disposition |
|---|---|
| Ch 1 Strategic Evaluation (1.1-1.3) | Ch 1 (1.3, 1.2); PDSA/CFIR trimmed into Ch 2.1 and Ch 9.4 examples |
| Ch 1.4 Power/MDE, 1.5 Pre-registration | Ch 7.4; Ch 8.1/8.4 |
| Ch 2 High-Performance Environment | Ch 2 (speed, folders); 2.2 monitoring to Ch 5.2; 2.3 funder tables to Ch 11.1; 2.4 LLM bridge to Ch 13 |
| Ch 3 Careful AI | Ch 13 (consolidated) |
| Ch 4 Ingestion & APIs | Ch 3 (APIs) and Ch 4 (no-API); 4.2 AI bridge to Ch 13.6; 4.3 measurement to Ch 7.1; rateshrink to Ch 7.3 |
| Ch 5 Harmonization/MDM | Ch 6; missing data 6.6; weighting to Ch 7.2; cxchangelog to Ch 5.6 |
| Ch 6 Survey Instrumentation | Ch 5 (expanded into the platform-operations chapter) |
| Ch 7 Ethics/Privacy/Synthetic | Ch 14 |
| Ch 8 Modern DiD | Ch 8.2 (one section) + Appendix B |
| Ch 9 RD & ITS | Appendix B (pointers only) |
| Ch 10 Synthetic Controls | Appendix B (pointers only) |
| Ch 11 ML & Fairness | faircheck to Ch 13.5; lasso/forests/ddml/conformal to Appendix B pointers |
| Ch 12 Cost-Effectiveness | Ch 8.3 |
| Ch 13 Visualizations | Ch 9 and Ch 10 (split static/interactive; googlechart added) |
| Ch 14 Dynamic Reporting | Ch 12; AI narrative tools to Ch 13.6; googlesheets added as new Ch 11 |
| Ch 15 Scripts to Systems | Ch 15 |
| Ch 16 Mata Trifecta | Ch 15.4 (one section) |
| Appendices A-D | A widened (all setup); B expanded (causal landing zone); C updated roster; D kept with fixes |

---

## 7b. Companion code and substance pass (July 4, second revision)

Per author feedback, the book moves from narrative skeleton to substantive draft with working code, figures, tables, and diagrams. Changes made:
- **Subtitle** changed to "A Practical Workflow from Data to Deliverables" (was "From Public Data to Client-Ready Results"; the book is not just public data).
- **Part I** renamed "The Embedded Evaluator Workflow" (dropped the "workshop" lens). **Chapter 2** retitled "Setting up a project that survives deadlines" (was "...a workshop..."). **Chapter 6** retitled "Building longitudinal data you can trust" (was "Building panels...", which was ambiguous between nested and survey panels).
- **Companion do-file suite** created in `code/`: `00_control.do` (master control file: one editable root path, derived subfolders, project preferences, and a `run_all` switch that sources every stage in order), `01_install.do` (one-time package install), `20_ch03_apis.do` (downloads real BLS QCEW county wages with no key and builds the wage figure). All tested in Stata 19; the QCEW example produces verified real numbers (e.g., Harris/Houston $1,900/wk, Bexar/San Antonio $1,270/wk, 2023 Q1).
- **New chapter about control files** (Section 2.2) with the actual control-file code, the numbered-pipeline convention (100_ingest ... 600_report), and the run-all block.
- **Figures/diagrams** added via TikZ (preamble now loads tikz): a five-stage pipeline flow diagram (Fig 1.1), the numbered-pipeline diagram (Ch 2), a running-datasets table (Table 1.1), and the QCEW wage figure exported by the do-file and included from `images/ch03_qcew_wages.png` (Fig 3.1). Manuscript compiles clean (0 errors, 0 undefined refs, 90 pp).
- **Writing made punchier**: chapters now lead with the concrete question, then how, then why; removed unexplained name-dropping (e.g., the Cox residual-scatter passage in Ch 9 rewritten to explain the idea directly).
- Deeply revised so far: Preface, Ch 1, Ch 2, Ch 3, plus the Ch 6 retitle/opening and the Ch 9 data-ink section. **Still to receive the same worked-code + figure treatment: Chapters 4, 5, 7, 8, 10, 11, 12, 13, 14, 15** (they currently hold the first-pass narrative skeleton).

Data sources confirmed working from Stata via `copy`/`import delimited`, no key: BLS QCEW (county CSV), County Health Rankings (annual analytic CSV), Stata built-ins (`sysuse`, stata-press.com/data URLs). Confirmed key-required (Appendix A setup): Census `getcensus`, FRED `import fred`. Documented gotcha (tested): Socrata `$limit` collides with Stata's `$` macro; fix with `char(36)`.

## 8. Production notes and open tasks

1. **This pass (done in main.tex):** new part/chapter/section architecture, retitled throughout; narrative skeleton, annotations, and idea stems rewritten to the style contract; every section carries its why-it-helps and four-promises language; no package code written.
2. **Before drafting full chapters:** publish `sparkta2` source; regenerate the STAAR log; generate the two synthetic demo datasets (enrollment/survey file; item crosswalk); regenerate SJ demo figures from an actual Stata run; verify `net install` URLs and EDC/Zelma redistribution terms.
3. **Book data abbreviation: DECIDED (July 2026): `apes`** (Applied Program Evaluation using Stata). Use it for: the companion data/package URL per house convention (`stata-press.com/data/apes/` if the book lands there; GitHub raw mirror meanwhile), the `net install apes` companion package name, and any shipped-dataset prefixes (`apes_enrollment.dta`, `apes_crosswalk.dta`). The `code/` folder and do-file names stay as they are; the handle appears where readers download things.
4. **Fun alternate titles page:** draft one wry alternate per chapter during full drafting (e.g., Ch 2: "Your do-file should survive your laptop"; Ch 8: "The estimate is only as credible as the comparison group").
