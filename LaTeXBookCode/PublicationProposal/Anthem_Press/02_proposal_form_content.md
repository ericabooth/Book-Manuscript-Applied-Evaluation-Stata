# Anthem Press proposal form — content to paste

Headings follow `anthem_press_proposal_form_BLANK.docx` in order.

---

## Author / Editor

| Field | Eric | Elizabeth |
|---|---|---|
| Name | Eric A. Booth | Elizabeth Teas |
| Affiliation | Texas 2036 | Far Harbor, LLC |
| Work address | *[fill]* | *[fill]* |
| Work telephone | *[fill]* | *[fill]* |
| Home address | *[fill: or leave blank; it is not load-bearing]* | *[fill]* |
| Home telephone | *[fill]* | *[fill]* |
| Email | eric.a.booth@gmail.com | *[fill]* |
| Social media | *[fill: GitHub profile is the relevant one here, plus LinkedIn or Bluesky if used professionally]* | *[fill]* |

**CV:** attach both. Note their warning that CVs are shared with reviewers unless you object.

**On the affiliation and address fields.** List your current positions, since they establish credibility and the form asks. But use **personal** contact details for correspondence rather than a work address or work phone: this is a personal project, you contract as individuals, and a contract should not route through an employer's mailroom.

**A note on rights and affiliation.** We name our current positions as professional background only. This book is our own work, drawn on a career's worth of accumulated practice rather than on any employer's project, and it is not written under, sponsored by, or endorsed by either organization. Neither employer holds any rights in the manuscript, the companion code, or the software packages, and neither would be a party to a publishing agreement. We contract as individuals.

---

## The book

### What type of book is this primarily?

A **professional / practitioner reference with textbook use**. It is written first for working analysts and second as a course text for graduate applied-research and evaluation programmes. It is not a scholarly monograph and not a general-interest title.

### One paragraph on scope and content

Applied evaluators are asked whether public programmes work, and they answer on a deadline with whatever data an agency can supply. This book teaches that whole job as one reproducible workflow: acquiring data from public interfaces and from agencies that publish nothing but a download button, linking administrative records that share no identifier, making a claim at the level of rigour the evidence supports, and delivering the result to a programme director, a funder, and an auditor: three readers who need the same finding at different depths. Most methods books begin once data is clean and end once a model is estimated; this one covers the eighty percent of the work on either side, in a single piece of software, with runnable code for every step.

### Table of contents

**Part I — The embedded evaluator workflow**
1. The embedded evaluator
2. Setting up a project that survives deadlines

**Part II — Getting the data**
3. Downloading public data through APIs
4. Harvesting data when there is no API
5. Working with survey platforms
6. Building longitudinal data you can trust

**Part III — Turning data into evidence**
7. Making numbers trustworthy
8. From differences to defensible claims

**Part IV — Communicating results**
9. Graphing for busy readers
10. Building interactive charts and infographics
11. Delivering through spreadsheets
12. Publishing self-contained reports and portals

**Part V — Sustaining the practice**
13. Using AI without getting burned
14. Sharing data and results safely
15. Turning scripts into shared tools

**Appendices:** A. Setup and credentials · B. Two end-to-end worked examples · C. Causal-design quick reference · D. The book's toolkit

### Chapter summaries

1. **The embedded evaluator.** Defines the analyst working inside the organisation being evaluated rather than delivering an external verdict, and sets four principles the book measures every deliverable against: replicable, extensible, accessible, actionable. Addresses the central trade directly: proximity buys access at the cost of independence, and a written charter agreed up front buys the independence back.
2. **Setting up a project that survives deadlines.** Builds a project a stranger could rebuild after the analyst leaves: folder structure, one control file setting every path, a numbered pipeline, dated logs, a decision log, and package version pinning so a dependency update cannot silently move a published number.
3. **Downloading public data through APIs.** The anatomy of a request, authentication, rate limits, nested data, and error handling, written so a reader with no web-development background can pull census, labour, and health denominators directly rather than downloading them by hand.
4. **Harvesting data when there is no API.** Responsible automated retrieval, reading terms before scraping, filtering files too large to load, and ingesting a folder of mixed formats in one call.
5. **Working with survey platforms.** Connecting to live survey platforms to watch response rates while a survey is open, keeping question wording attached to variables, and distinguishing a low response rate from a biased one.
6. **Building longitudinal data you can trust.** Linking administrative records with no shared identifier through cleaning, blocking, and graded string-distance scoring; handling schema drift across years; and reporting missing data rather than dropping it silently.
7. **Making numbers trustworthy.** Scale reliability, survey weighting, stabilising rates for sites too small to rank fairly, distribution-free prediction intervals, and stating the minimum effect a design can detect before data collection starts.
8. **From differences to defensible claims.** Decomposing a group gap into composition and structure, then modern difference-in-differences at length: where the standard approach fails with staggered timing, how to read an event study, and how to choose a defensible comparison group.
9. **Graphing for busy readers.** Static graphics built on the perceptual research about which encodings people read accurately, and captions that state the finding rather than describing the axes.
10. **Building interactive charts and infographics.** Interactive charts and maps generated from code so next quarter is a rerun, matched to venue, with colour-vision deficiency treated as a design constraint and the failure modes named honestly.
11. **Delivering through spreadsheets.** Meeting programme teams in the format they use without giving up reproducibility, under the rule that no number is ever typed into a cell.
12. **Publishing self-contained reports and portals.** Compiling narrative, code, and interactive elements into one portal that opens offline inside a locked-down network, stamped so an auditor can rebuild the exact figures years later.
13. **Using AI without getting burned.** A framework in which the model drafts code one checkable step at a time and the statistical software stays the system of record: a privacy gate at intake, defences against instructions hidden in untrusted text, and how to correct estimates built on machine-generated labels.
14. **Sharing data and results safely.** Scanning for the ordinary column combinations that make people unique, suppressing thin cells without letting them be recovered by subtraction, and a disclosure-review checklist an analyst and a lawyer can sign together.
15. **Turning scripts into shared tools.** Turning repeated code into a documented, installable tool: the program, its help file, a test battery written before the command it tests, and a replication archive that outlives the project.

### Sample chapter

**Chapter 13, "Using AI without getting burned."** This is **a sample of the proposed manuscript**, in final draft, not a writing sample written for the proposal.

### Edited collection contributors

Not applicable. Sole-authored by the two of us.

---

## Why we should publish your book

### Why should we publish this book? What are the particular strengths?

Three reasons.

**It occupies a real gap.** Books that teach statistical software teach estimation. Books that teach evaluation practice are software-agnostic and stop before the code. Nothing covers data acquisition, analysis, and delivery as one reproducible workflow, which is what practitioners actually need and what funders increasingly require.

**It is verifiable.** Every number, table, and figure printed in the book is generated by a companion do-file we can rerun on request. That is unusual in a methods book and it is the book's own argument applied to itself: a reader can rebuild the results before trusting the text.

**It is current where the field is anxious.** Two chapters address problems research organisations have right now and have not solved: using large language models without losing reproducibility or leaking confidential data, and releasing datasets publicly without re-identifying vulnerable people. We are not aware of a book-length treatment of the first anywhere.

Practical strengths for a publisher: the manuscript is finished, no permissions need clearing, all data is public or simulated, all figures are ours, and the authors maintain the companion code and software at no cost to the press.

### Who is it aimed at? Who will buy it?

**Primary market.** Practising evaluators, policy analysts, and applied researchers in nonprofits, foundations, think tanks, school districts, health departments, and government agencies: people doing monitoring, evaluation, and learning work, usually in teams of one to three. They buy professional books that solve a Monday problem. This audience is large: Stata has a substantial installed base across public health, education research, social policy, and economics, much of it outside universities, and nearly everything written for that base is about estimation.

**Secondary market.** Graduate programmes in public policy, public health, social work, and applied social research, whose students take exactly these jobs. The book is built for course use: chapter previews, worked examples, and exercises throughout, including exercises that move each technique onto the student's own data. Also evaluation offices building internal capacity, for whom the reproducibility and handover material is directly useful.

**Routes to the buyer.** The American Evaluation Association and its international counterparts; annual Stata user-group meetings in London and the US; the authors' own workshop teaching; and the existing user base of the authors' published software packages, which reaches practising Stata users directly.

*[Eric: if you have workshop enrolment numbers or package download counts, put them here. Concrete demand figures are the single most persuasive thing you can add for a committee that includes sales and marketing.]*

### Comparable books, and the gap

| Title | Publisher / date | Relationship |
|---|---|---|
| J. Scott Long, *The Workflow of Data Analysis Using Stata* | Stata Press, 2009 | Closest relative. Excellent on project discipline; predates public APIs, web deliverables, disclosure control, and AI. We build on it and say so. |
| Michael N. Mitchell, *Data Management Using Stata: A Practical Handbook*, 2nd ed. | Stata Press | Strong on cleaning; nothing on acquisition or delivery. |
| Kyle C. Longest, *Using Stata for Quantitative Analysis*, 3rd ed. | Sage, 2019 | Student introduction to analysis. Assumes the data exists; ends at the output. |
| Lisa Daniels & Nicholas Minot, *An Introduction to Statistics and Data Analysis Using Stata*, 2nd ed. | Sage, 2025 | Same segment, more recent. Not data engineering or delivery. |
| Helen Kara, *Research and Evaluation for Busy Students and Practitioners*, 3rd ed. | Policy Press | Same readership and register; software-agnostic. A complement rather than a competitor. Ours is the technical companion to that book's reasoning. |

**The gap:** every one of these assumes the analyst's problem begins with a dataset and ends with an estimate. That assumption is what fails in applied evaluation practice, and nothing on the shelf addresses the failure.

---

## Essential information

| Question | Answer |
|---|---|
| Proposed submission date for the completed manuscript | The manuscript is **already complete**. A final typescript in your required format within **three months of contract**. |
| Word count | Approximately **155,000** including references and appendices. |
| Pictures, graphs, diagrams | **65 figures and 32 tables.** Figures are statistical graphics generated from code plus workflow diagrams drawn in TikZ. All are ours and can be supplied at any resolution as PDF, EPS, or PNG. Authored in colour on a colour-vision-deficiency-safe palette and legible in greyscale, so colour is welcome but not required. **No permissions to secure. Every image is our own work.** |
| Copyright or permission issues | **None.** All data is public (US Census, Bureau of Labor Statistics, CDC, County Health Rankings, state education files) or simulated. |
| Previously published portions | **None.** No part of the manuscript has appeared elsewhere. A *Stata Journal* article on one of the software packages is in preparation and does not overlap with the book's argument. |
| Translated manuscript | Not applicable. Written in English. |
| Copyediting required | **Light.** The manuscript has been through several full editorial passes and a consistency sweep. It is typeset in LaTeX with a single style throughout. |
| Would it benefit from an index? | **Yes.** |
| What type, and who prepares it? | A combined subject and command index, since readers look up both concepts ("nonresponse bias") and command names. The manuscript **already carries index markup throughout**, so the index generates from the source. We will prepare it. |
| Have you contacted other publishers? | *[Eric: answer honestly. If Stata Press, Vernon, or Policy Press has it concurrently, say so. Simultaneous submission is normal; concealing it is what damages you.]* |

---

## Recommended peer reviewers (5–10)

**Left blank deliberately.** Anthem asks for names, affiliations, and email addresses, and wants each flagged as personally known to you or not. I will not invent real people's contact details. Fill these five slots:

| # | Who to look for | Personally known? |
|---|---|---|
| 1 | A methods academic teaching applied quantitative evaluation to practitioners | flag honestly |
| 2 | A senior evaluator inside a government agency, foundation, or large nonprofit | flag honestly |
| 3 | A recognised member of the Stata user community (Stata Journal author, SSC contributor, user-group organiser) | flag honestly |
| 4 | A public-policy or public-health researcher who uses administrative data | flag honestly |
| 5 | Someone working on research reproducibility or open science | flag honestly |

Anthem prefers reviewers not personally known to you, so weight the list that way and avoid co-authors and close collaborators.
