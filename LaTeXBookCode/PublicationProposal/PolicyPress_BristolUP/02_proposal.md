# Book Proposal — Bristol University Press / Policy Press

*Prepared to the headings and order of the BUP Proposal Guidelines. Format category: **Learning Resources**.*

---

## 1. Title information

**Proposed title:** Applied Program Evaluation Using Stata
**Subtitle:** A Practical Workflow from Data to Deliverables

**Authors** (in the order they should appear):

- **Eric A. Booth**, Senior Researcher, Texas 2036, Austin, Texas, USA
- **Elizabeth Teas**, Senior Research Scientist, Far Harbor, LLC, USA

The title is deliberately literal for discoverability: *program evaluation*, *Stata*, and *applied* are the three terms a librarian, a bookseller, or a searching practitioner would use.

---

## 2. Synopsis and aims

### Scope and content

Applied evaluators spend most of their working week on tasks that methods textbooks do not cover. A partner agency drops fourteen mismatched spreadsheets into a shared drive. A denominator lives behind a public API with no documentation. Two administrative files describe the same people and share no identifier. At the other end, a finding has to reach a programme director who will not read a regression table, a funder who expects an interactive dashboard rather than a PDF, and an auditor who will ask, three years later, exactly how a number was produced. Between those two ends sits the part the textbooks do cover: estimating something defensible.

This book treats all three as one continuous workflow, taught in Stata, from an empty project folder to a delivered result.

What is original is the connection rather than the components. Individually, most of these techniques exist somewhere in the literature. What has not existed is a single account in which an API pull feeds a longitudinal panel, the panel feeds an empirical-Bayes estimator that stabilises rates for sites too small to rank fairly, and that estimator feeds a self-contained web portal a reader can open with the internet off. Teaching the pieces separately, which is what the field currently does, leaves the reader to invent every join. Following one project the whole way is what requires a book.

That connection is the book's spine, and the text names it: the workflow ecosystem. J. Scott Long's *The Workflow of Data Analysis Using Stata* set the standard for project discipline inside one analyst's session, and we build on it explicitly. This book extends that discipline into the parts of a project Long could take as given and an evaluation shop cannot: metadata that has to survive years of merges, column names that drift between vintages, extracts that arrive with undocumented surprises, and a reviewer who has to correct the record without touching the data. Chapters 1 and 2 both signal the route forward, so the book reads as one argument rather than fifteen separate how-tos. Chapter 6 runs the route end to end on one worked example, and Appendix E runs it again at greater length on a single public dataset. Five Stata packages we wrote implement the route, and all five are free and public.

For a Learning Resource, that spine is the practical payoff. It gives a course one worked project to teach from, with each technique arriving at the point the project needs it, instead of fifteen disconnected techniques a student has to assemble alone. An instructor can teach the short version in a week from Chapter 6, or carry the long version across a term from Appendix E.

The themes developed throughout are four principles the book measures every deliverable against, introduced in Chapter 1 and returned to explicitly in each chapter: work should be **replicable** (someone else can rerun it and get the same answer), **extensible** (next year's data costs a rerun, not a rebuild), **accessible** (it reaches the people who need it, in the format they use, including readers with colour-vision deficiency or a screen reader), and **actionable** (a named person can decide something with it).

Two areas are at the forefront of current practice and are treated at length. The difference-in-differences literature has moved substantially in the last few years, and practising evaluators are working to catch up; Chapter 8 gives a practical translation, including how two-way fixed effects goes wrong and what diagnostics tell a reader when a design is credible. And evaluators are already using large language models, frequently in ways that leak confidential data or produce results nobody can reproduce; Chapter 13 sets out a working framework in which the model drafts code one checkable step at a time and the statistical software remains the system of record.

The deliberate omissions are worth naming. The book teaches one causal design in full rather than surveying many, because an embedded evaluator's comparative advantage is local knowledge rather than econometric range; other designs are routed to a quick-reference appendix and to the specialist texts. It does not teach Stata from scratch. And it does not teach machine learning, which would double the length and serve a different reader.

### Aims

The book aims to give practising evaluators a complete, reproducible workflow they can adopt on Monday, and to make the parts of that workflow that are usually improvised into things a team can standardise, document, and hand over.

The gap it fills is specific. Books that teach statistical software teach estimation. Books that teach evaluation practice are software-agnostic and stop short of code. Neither addresses the operational reality that determines whether an evaluation is reproducible: how the data got in, and how the result got out. That reality matters more, not less, as funders increasingly require open data, reproducible analysis, and accessible deliverables.

The intended change in practice is concrete. We want a reader to stop copying numbers by hand between a statistical package and a report, because every number copied by hand can go stale and, more seriously, breaks the chain that would let someone else reproduce the result.

### Summary (marketing blurb)

Evaluation work rarely begins with clean data or ends with a regression table. This book teaches the whole job: pulling data from public APIs and from agencies that publish nothing but a download button, linking administrative records that share no identifier, making a claim at the level of rigour the data will support, and delivering the result as a formatted spreadsheet, a live shared sheet, or a self-contained web portal that opens inside a locked-down agency network. Written by two practising evaluators, it covers the ground between the textbook and the deadline, including how to use AI tools without losing reproducibility and how to release data without re-identifying the people in it. Every number printed in the book is produced by code readers can download and rerun.

### Unique selling point

The whole pipeline in one volume, in one piece of software, with working code for every step. The book is itself the demonstration: a companion do-file reproduces every printed number, table, and figure, so a reader can rebuild the book before trusting it.

### Key features

- **One argument, taught as one project.** The book extends Scott Long's workflow discipline into metadata that has to survive years of merges, column names that drift between vintages, and corrections a reviewer makes to the record rather than to the data. Chapter 6 and Appendix E run that route end to end, so a course has a single worked spine to teach from.
- **Runnable throughout.** Companion do-files reproduce every result in the book; roughly two dozen Stata commands written and released by the authors are taught in place, most already distributed through the field's standard archive.
- **Covers the first mile and the last mile.** Data acquisition and delivery get eight of the fifteen chapters, ground that competing texts skip entirely.
- **Built for the constraints practitioners actually face:** locked-down IT, data-use agreements, small samples, and audiences who need a spreadsheet rather than a table.
- **Current on two fast-moving fronts:** modern difference-in-differences, and a framework for using large language models without losing reproducibility or leaking confidential data.
- **Teaches disclosure control as routine practice**, including k-anonymity scanning and cell suppression, so a practitioner can release a file safely rather than avoid releasing one.

### Keywords

program evaluation; Stata; reproducible research; applied social research methods; data visualisation and dissemination

---

## 3. Background information

The impetus came from our own work and from the people we train. Both authors are practising evaluators, at a policy think tank and at a private evaluation and research consultancy, and the workflow taught here is the one we use on live projects with government agencies, foundations, and nonprofits. We also teach parts of it in free and grant-sponsored workshops for policy doctoral students and early-career researchers, and the recurring request from those audiences is for exactly the material that is hardest to find written down: not how to run the model, but how to get the data in and get the answer out in a form somebody will use.

The book does not arise from a single funded research project and carries no funder dissemination requirements. It is not derived from a doctoral thesis, and no part of it has been published elsewhere. A *Stata Journal* article covering one component, the authors' tools for working with Google Sheets and charts, is in preparation; it addresses a single package and does not overlap with the book's argument.

The software packages taught in the book were written over several years in response to real project needs, and released publicly as they matured.

---

## 4. Content

Total: fifteen chapters in five parts, plus five appendices. Approximate word counts per chapter are given in brackets and include references.

### Part I — The embedded evaluator workflow

**1. The embedded evaluator** *(8,000)*
Defines the role the book is written for: an analyst working inside or alongside the organisation being evaluated, rather than an external contractor delivering a verdict. Sets out the four principles used throughout, gives each a one-sentence pass/fail test, and situates the role in its professional lineage: research-practice partnerships, utilisation-focused evaluation, and improvement science, including the Plan-Do-Study-Act cycle. Addresses the central trade of embedded work directly: proximity buys access at the cost of the independence distance used to guarantee, and a written charter agreed at the outset buys that independence back. Introduces the running examples and the scoping note the book asks readers to write before touching data.

**2. Setting up a project that survives deadlines** *(9,500)*
Builds a project a stranger could rebuild after the analyst leaves. Covers a five-folder layout, a control file that sets every path in one place, a numbered pipeline where the folder listing is the run order, dated logs, and a decision log that records the judgement calls the code executes but cannot explain. Treats package versioning seriously, since a community package that changes a default can move a published number without touching the analyst's own code. Names the four distinct faults hiding behind "it works on my machine" and gives each a specific remedy. Ends with benchmarked guidance on speed, because a pipeline that reruns in minutes gets rerun, and one that takes a day gets patched by hand.

### Part II — Getting the data

**3. Downloading public data through APIs** *(8,300)*
Teaches the anatomy of an API request and how to pull the denominators evaluation depends on (population, enrolment, regional wages) directly into the statistical session rather than by hand. Covers authentication and key handling, rate limits and how to be a good citizen of a public server, nested data structures, and what to do when a request fails. Written so a reader with no web-development background can follow it, with the non-statistical machinery kept in boxes and margin notes.

**4. Harvesting data when there is no API** *(6,300)*
Most agencies do not offer an API; they offer a download button, or a shared drive full of files in five formats. Covers responsible automated retrieval, reading the terms before scraping, filtering files too large to load into memory, and ingesting a folder tree of mixed formats in one call. Includes the triage pass an evaluator should run on a new data drop before writing any cleaning code.

**5. Working with survey platforms** *(9,500)*
Connects the statistical session to live survey platforms so response rates can be watched while the survey is still open, rather than diagnosed after it closes. Covers total survey error as a working framework, attaching question wording to variables so meaning survives the export, scale construction, and nonresponse bias diagnostics that distinguish a low response rate from a biased one.

**6. Building longitudinal data you can trust** *(12,400)*
Links administrative records that share no identifier, using cleaning, blocking, and graded string-distance scoring, and treats the match rate as a quantity to be predicted and checked rather than accepted. Covers schema drift across years, declaring a panel, and reporting missing data honestly rather than dropping it silently. Includes a decision table for the question every team eventually asks: should this be in a database instead? Closes with a capstone section, illustrated by a full-page figure, that runs the book's whole route on one example: three yearly wage extracts arrive as a CSV file, an Excel file, and a Stata file, and one of them silently renames a column between years. The section takes that mess to an analysis-ready panel that can answer on its own where any number came from, and it teaches the step most pipelines omit. A human reviewer reads the generated codebook, spots a wrong data vintage, and corrects the metadata rather than the data; the correction goes back in under an overwrite guard, with a row-by-row receipt. Every command and every printed output in the section comes from a companion do-file that runs with assertions at each step.

### Part III — Turning data into evidence

**7. Making numbers trustworthy** *(7,800)*
The safeguards that belong before a claim, each framed as an answer to a sceptical programme officer's question. Covers scale reliability and which item to cut, survey weighting back to the population, stabilising rates for sites too small to rank fairly using empirical-Bayes shrinkage with a reliability figure attached, distribution-free prediction intervals, and power expressed as the minimum effect a design can detect, a number a funder should hear before data collection starts, not after.

**8. From differences to defensible claims** *(9,000)*
Matches the claim to the design. Covers decomposing a group gap into composition and structure, then treats modern difference-in-differences at length: how two-way fixed effects goes wrong with staggered treatment timing, how to read an event study, how to choose a comparison group that survives challenge, and what a flat pre-trend does and does not prove. Ends with simulating return on investment under uncertainty, since that is the number a board asks for.

### Part IV — Communicating results

**9. Graphing for busy readers** *(6,400)*
Static graphics designed around how people actually read charts, applying the perceptual research on which encodings are read accurately. Covers stripping a default chart to its data, ranked comparisons that show their own uncertainty, coefficient plots, marking an intervention date on a trend, and writing a caption that states the finding rather than describing the axes.

**10. Building interactive charts and infographics** *(9,900)*
Interactive charts, maps, and animations generated from code rather than assembled in a design tool, so next quarter's version is a rerun. Places each option on the spectrum from author-driven to reader-driven and matches it to the venue. Treats colour-vision deficiency as a design constraint rather than an afterthought, and is honest about the failure modes of interactive deliverables, including the one where a page silently shows last year's data.

**11. Delivering through spreadsheets** *(8,100)*
Meets programme teams in the format they already use, without giving up reproducibility. Establishes the rule that no number is ever typed into a cell, then shows how to write estimates directly into formatted workbooks and live shared sheets from stored results. Covers the evidence on spreadsheet error rates, and the discipline that prevents a helpful colleague's hand edit from becoming a published mistake.

**12. Publishing self-contained reports and portals** *(11,800)*
Compiles narrative, code, and interactive elements into a single portal that opens offline, which is what a locked-down agency network requires. Covers writing the report from the analysis so the prose and the numbers cannot disagree, and stamping every release with a version, a data vintage, and a code fingerprint so an auditor years later can rebuild the exact figures. Treats handing over a deliverable the partner can maintain as a question about capacity, not only about file formats.

### Part V — Sustaining the practice

**13. Using AI without getting burned** *(13,300)*
A framework for using a large language model inside an evaluation without losing reproducibility or leaking confidential data. The model drafts and annotates code one checkable step at a time; the statistical software computes and logs every result; automated assertions decide whether a step passed. Covers a privacy gate at intake, defences against instructions hidden in untrusted text, measuring agreement when a model classifies free-text case notes, correcting estimates built on machine labels, and auditing a classifier for bias across groups. Written to survive the next model release rather than to describe today's tools.

**14. Sharing data and results safely** *(6,900)*
Preparing analytic files for release without re-identifying the people in them. Covers scanning for the combinations of ordinary columns that make individuals unique, suppressing thin cells without letting them be recovered by subtraction, coarsening categories, synthetic data, and a disclosure-review checklist an analyst and a lawyer can sign together.

**15. Turning scripts into shared tools** *(6,600)*
Turning a repeated block of code into a documented, installable tool a colleague can use. Covers writing the program and its help file, distributing it, writing a test battery *before* the command it tests, versioning promises, using faster languages only where they pay, and leaving a replication archive that outlives the project.

### Appendices *(11,500 combined)*

Five appendices, in this order. **A**, a setup guide covering installation and credentials. **B**, a causal quick-reference toolbox for the designs the book routes elsewhere. **C**, a toolkit index of every package the book uses. **D**, two hands-on worked examples on real public files, one small and messy and one large and clean. **E**, a reproducible capstone of thirty pages that carries one public dataset from ingest to finished deliverable, every step runnable, which is the longest sustained demonstration in the book and the one an instructor can teach a term from.

### Digital content

Substantial and integral rather than supplementary; see section 11.

---

## 5. Author information

**Eric A. Booth**, Senior Researcher, Texas 2036 (Austin, Texas). Works in applied evaluation and data systems across the public policy and nonprofit sectors. Writes and maintains open-source Stata packages connecting statistical analysis to modern data engineering, with an emphasis on API access, reproducibility, and workflow automation. Teaches this material in workshops for policy doctoral students and early-career researchers.

**Elizabeth Teas**, Senior Research Scientist, Far Harbor, LLC. Applied researcher and evaluator specialising in implementation science and program evaluation, and in turning statistical findings into strategies that community organisations, foundations, and government agencies can act on.

**A note on rights and affiliation.** We name our current positions as professional background only. This book is our own work, drawn on a career's worth of accumulated practice rather than on any employer's project, and it is not written under, sponsored by, or endorsed by either organisation. Neither employer holds any rights in the manuscript, the companion code, or the software packages, and neither would be a party to a publishing agreement. We contract as individuals.

*[Eric: attach both CVs. If either of you has a blog, a personal site, a GitHub profile with meaningful traffic, or a professional-association role, add it here; BUP asks about direct routes to market and this is where the workshop teaching and the package user base belong. The packages already have users, which is a marketing asset worth naming.]*

---

## 6. Target audience

### Primary audience

Practising evaluators, policy analysts, and applied researchers working inside or alongside nonprofits, foundations, school districts, health departments, and government agencies: people doing monitoring, evaluation, and learning work on a deadline, usually in teams of one to three. They already use Stata competently for analysis. What they lack is a worked account of everything on either side of the model.

This audience is substantial and underserved. Stata has a large installed base in public health, education research, social policy, and economics, much of it outside universities. Nearly all books written for that base are about estimation.

### Secondary audience

Graduate programmes in public policy, public health, social work, and applied social research, where students will take exactly these jobs. Also researchers who want to modernise a Stata workflow with APIs and web deliverables rather than migrate to another language, and evaluation offices building internal capacity, for whom the reproducibility and handover material is directly useful.

Professional bodies whose members are the primary audience include the American Evaluation Association and the UK and European evaluation societies. Evaluation capacity-building programmes at multilateral institutions are a further route.

### International market

The workflow is not jurisdiction-specific; the public datasets used as examples are American, but every technique transfers, and the constraints the book is written around (restrictive IT environments, data-sharing agreements, small samples, non-technical audiences) are universal in the sector. The UK, Ireland, Australia, and Canada are natural markets given shared evaluation-practice traditions, and Stata is widely used in Latin American social policy research.

### Course information

*[Eric: this is worth completing precisely, because for a Learning Resource it carries real weight. Name the workshops you and Elizabeth teach: the institution or programme, level (doctoral, professional), typical enrolment, and how often they run. If either of you has a standing course or guest lecture, say so. If you have colleagues who would adopt it, name their courses too.]*

The book is designed to work as a course text for an applied research methods or evaluation practicum at master's or doctoral level, and as the spine of a professional short course. Every chapter ends with exercises, including one that asks students to run the technique on their own data. An instructor gets one project to teach from rather than fifteen disconnected techniques: Chapter 6 supplies a week-sized worked example that runs the book's route end to end, and Appendix E supplies a term-sized one on a single public dataset, so a syllabus can be built around a project students carry the whole way.

---

## 7. Competition

There is no direct competitor. The nearest works each cover one segment of the workflow.

| Title | Publisher / date | How ours differs |
|---|---|---|
| J. Scott Long, *The Workflow of Data Analysis Using Stata* | Stata Press, 2009 | The closest relative and a genuinely good book. Covers project discipline inside one analyst's session, and predates public APIs, web deliverables, disclosure control, and AI. Ours extends that route to metadata that has to survive years of merges, column names that drift between vintages, extracts that arrive with undocumented surprises, and corrections a reviewer makes to the record rather than to the data. We build on it explicitly and say so. |
| Michael N. Mitchell, *Data Management Using Stata: A Practical Handbook*, 2nd ed. | Stata Press | Strong on cleaning and reshaping; stops at the analysis boundary in both directions. Nothing on acquisition or delivery. |
| Kyle C. Longest, *Using Stata for Quantitative Analysis*, 3rd ed. | Sage, 2019 | An introduction to statistical analysis for students. Assumes the data exists and ends at the output. |
| Lisa Daniels & Nicholas Minot, *An Introduction to Statistics and Data Analysis Using Stata*, 2nd ed. | Sage, 2025 | Same segment as Longest, more recent. Research-design-to-report in scope, but not data engineering or delivery. |
| Helen Kara, *Research and Evaluation for Busy Students and Practitioners*, 3rd ed. | Policy Press | Speaks to our readership and our register, and is a genuine complement. Software-agnostic and does not teach code; ours is the technical companion to that book's reasoning. |
| Cole Davis, *SPSS Step by Step* | Policy Press, 2013 | Your existing statistical-software title. Different package, and a software primer rather than a workflow. |

**Strengths of the competition:** the Stata Press titles are authoritative and well edited, and Long in particular is a genuinely good book that we recommend to readers. **Weaknesses:** all of them assume the analyst's problem begins with a dataset and ends with an estimate, which is precisely the assumption that fails in applied evaluation practice.

**Why ours suits the reader better:** it is more operational and less statistical, it is written by practitioners about constraints they face daily, and it ships code the reader can run rather than code the reader must retype. It is also, as far as we can establish, the only book of any kind treating large language models inside an evaluation workflow with reproducibility and confidentiality intact.

*[Prices are not listed because we have not verified current retail figures. We can supply them on request.]*

---

## 8. Typescript information

- **Estimated total word count:** approximately **158,000 words** including references and appendices. The per-chapter counts in Section 4 sum to about 145,300; they cover body text only. The balance is the bibliography, the index, the front matter, and the book's margin notes, which are a substantial part of a tufte-style layout rather than an afterthought.
- **Illustrations:** **67 figures and 32 tables**. Figures are a mix of statistical graphics generated from code and workflow diagrams drawn in TikZ. All are ours; all can be supplied as PDF, EPS, or PNG at any resolution. Figures are authored in colour using a colour-vision-deficiency-safe palette and remain legible in greyscale, so colour printing is welcome but not required.
- **Stage reached:** **complete**. All fifteen chapters and five appendices are drafted and compile clean at 336 pages in a wide-margin layout; converting to a conventional academic format will tighten the page count. Every printed number is generated by a companion do-file we can rerun on request.
- **Prior publication:** none. No part of the manuscript has appeared elsewhere.
- **Copyright clearance:** **none required.** All data used is public or simulated, and all figures are our own work.

---

## 9. Timetable

The manuscript is finished, so the schedule is driven by your process rather than by our writing.

- **Final typescript in your required format:** within **three months** of contract. That window covers converting the layout, responding to peer review, and any restructuring you ask for.
- **Publication:** we would welcome 2027 and have no fixed external deadline.
- **Timing considerations:** parts of the material track fast-moving tools, particularly the AI chapter, so we would value the option to make small factual revisions close to press time. Nothing else in the book is time-critical.
- **Updating:** the code and datasets live in a companion repository we maintain, so corrections and updates can be published there between editions without waiting on a reprint.
- **Conferences worth considering for promotion:** the American Evaluation Association annual conference, and the Stata user-group meetings held annually in London and in the US.

*[Eric: add whether either of you has time formally set aside for revisions.]*

---

## 10. Referees

BUP asks for **at least four** suitably qualified people with contact details, and specifically asks that the list be diverse and include scholars at Global South institutions.

**I have deliberately left this blank rather than invent names and email addresses.** Fabricated reviewer details would be caught immediately, and choosing who reviews your book is your call. Here is the frame to fill:

| # | Who to look for | Why this slot |
|---|---|---|
| 1 | A methods academic who teaches applied quantitative evaluation to practitioners | Speaks to BUP's course-adoption question |
| 2 | A senior evaluator inside a government agency, foundation, or large nonprofit | Confirms the practitioner audience is real |
| 3 | A recognised member of the Stata user community: a Stata Journal author, SSC contributor, or user-group organiser | Vouches for technical credibility |
| 4 | An evaluation or social-policy researcher at a Global South institution | BUP asks for this explicitly, and it is a genuine strength given evaluation capacity-building work in Latin America, Africa, and South Asia |
| 5 | Optional: someone working on research reproducibility or open science | Speaks to the book's core argument |

Avoid close collaborators and co-authors; presses screen for that. For each, give name, position, institution, and email.

---

## 11. Textbook annex (BUP guidelines, page 6)

### Pedagogical features

- **Chapter previews.** Every chapter opens by stating what it does, what the reader will be able to do afterwards, and why that matters, so readers know where the material is going.
- **End-of-chapter exercises** in every chapter, including a "try it on your own data" exercise that moves the technique onto the reader's real project, and predict-then-check exercises that ask readers to write down an expected answer before running the code.
- **Applied Examples**, numbered within chapters, working a full scenario end to end with runnable code.
- **"What this depends on" boxes** wherever the book offers a statistical guarantee, listing the few conditions the guarantee needs and, for each, the symptom a reader would see if it failed.
- **"Visualization to build" callouts** specifying a chart and the story it has to tell.
- **Margin notes** throughout, carrying definitions, traps, and asides without interrupting the main line.
- **Decision tables and flow diagrams** for the recurring judgement calls: which tool for which venue, when a database is warranted, which causal design a claim requires.
- **A worked triage order** for diagnosing failures, so readers can debug rather than guess.

### Companion digital content

This is where the book differs most from a conventional methods text, and it costs the press nothing to host because we maintain it.

- **Runnable code for the entire book.** A companion do-file per chapter reproduces every number, table, and figure printed in the text. A reader can rebuild the book's results before trusting them, and an instructor can regenerate every exhibit.
- **Datasets.** Every example uses public data (US Census, Bureau of Labor Statistics, CDC, County Health Rankings, state education files) or clearly labelled simulated data. Nothing is restricted, so students can run everything.
- **Roughly two dozen Stata packages** written and released by the authors, taught in place in the book. Several are already distributed through the Statistical Software Components archive, the field's standard channel, and we expect the rest to be there before publication. These install in one line and are free. Five of them implement the workflow route the book teaches: `projectbuilder`, `combineall`, `srctag`/`srcfind`, `datadictionary`, and `convertanything`. The first two are on the archive now; the others are submitted this month.
- **Test batteries** for the authors' packages, which double as teaching material in Chapter 15.
- **Instructor material** we would be glad to develop if useful: exercise solutions, a suggested twelve-week course map, and slide sets built from the book's own figures.

---

## 12. Open access

We have no open-access funding and are under no OA mandate. We would be glad to discuss options but are not asking the press to plan around one.
