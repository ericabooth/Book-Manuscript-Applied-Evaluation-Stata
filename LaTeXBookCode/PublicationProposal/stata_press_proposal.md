# Book Proposal: Applied Program Evaluation Using Stata
## A Practical Workflow from Data to Deliverables

**Authors:** 
Eric Booth, Sr Researcher, Texas 2036 
Elizabeth Teas, Sr Research Scientist, Far Harbor

---

## Description of project

### What is this book about?
*Applied Program Evaluation Using Stata* is a comprehensive, end-to-end guide for the practitioner working as an embedded analyst or alongside nonprofits, foundations, and government agencies. Unlike traditional statistics textbooks that assume data arrives clean and ready for modeling, this book tackles the messy reality of applied evaluation. It teaches readers how to use Stata as the command center for the entire project lifecycle: pulling raw data from public data sources (e.g. JSON APIs and messy archival sources), combining internal program or survey data with administrative records, stitching together longitudinal panels without shared identifiers, producing policy-relevant evidence, strategies for safely integrating Large Language Models (LLMs) into the coding workflow (that aren't focused on current or short-run LLM developments or flavors, but instead on the idea of how LLMs of any type can ride along in a project and bring value if implemented with guardrails), and delivering interactive, accessible, and actionable results via Stata graphics self-contained HTML portals generated from Stata. Stata packages and code to interact with survey platforms and a variety of online tools.

### Why should it exist? Why is it new? 
The book addresses the "first mile" and "last mile" of data engineering and reproducible delivery—that many Stata resources skip. We use all of these skills in our daily policy and program - facing workflows and often use parts of this work in workshops for policy PhD students and early-career researchers. The landscape of applied research has shifted dramatically: funders expect interactive dashboards rather than static PDFs, modern causal inference (like staggered difference-in-differences) has upended standard regression practices, and the pressure to use AI is ubiquitous but fraught with privacy, accuracy, and reproducibility risks. This book brings these modern demands into a unified, reproducible Stata pipeline.

Where it fits in the Stata publication universe: While excellent texts exist for microeconometrics (e.g., Cameron and Trivedi) and basic workflow (e.g., Long), there is a distinct gap for a book that centers the work on tried-and-true aspects of *delivery* and *operations*, it fills a gap in tools that Stata users often discuss as desired and available in other software (R, Python, etc). A *Stata Journal* article might accompany this work to cover one of the custom commands we introduce  in the book (like `googlechart` or `rateshrink`), but the overarching value here is the interconnected workflow—how an API pull feeds a panel, which feeds an empirical-Bayes shrinkage estimator, which feeds a scheduled, serverless HTML dashboard. That cohesive narrative requires a book. For the book we are creating nearly 20 custom adofile packages (currently on github and can be moved to SSC before publication) that support various aspects of this worflow.

### Why are you the one to write it?
As working practitioners in the applied evaluation and policy space (Texas 2036 policy think tank and Far Harbor, LLC private research and evaluation consulting firm), we live the challenges described in this book daily. We are not just statisticians; we are tool builders who have developed the exact Stata packages required to bridge the gap between rigorous evaluation and modern data delivery (including `webapi`, `googlesheets`, `statashiny`, `webdoc2`, `rateshrink`, and `convertanything`). We have spent years navigating restrictive IT environments, balancing the need for rigorous causal inference with the realities of small sample sizes, and building data systems and tools that practitioners actually use. 

### Why is now the time to publish it?
Three urgent shifts make this book timely:
1. **The AI explosion:** Evaluators are pasting sensitive administrative data into ChatGPT, relying on LLMs to do statistical work that it's not well matched for, and tools are changing rapidly. Chapter 13 provides the industry's first Stata-centric framework for using AI safely—treating the LLM as an external spine/index to help organize, spot check, debug, and annotate code in the workflow without allowing spots for it to hallucinate data or allow its 'model drift' to contaminate analysis/results (while keeping Stata as the strict, logged system of record) 
2. **The Causal Inference revolution:** Applied policy researchers and program evaluators are scrambling to catch up with the recent literature on difference-in-differences (e.g., Callaway & Sant'Anna) and synthetic controls and easily employ them in their daily workflows. We provide a practical, non-academic translation of these methods using modern Stata tools (`csdid`) with simple interpretations and ways to inspect the data for appropriate use
3. **The demand for modern deliverables:** Stakeholders want interactivity (and researchers want to deliver data responsibly). We show how to leverage Stata ado wrappers (like webdoc) to write pages (with some improved functions we added) plus use of Stata's Python integration to generate other web deliverables (like Socrata API pipelines, interactive charts, and JavaScript-powered dashboards, again we have adofile wrappers to make this much eaiser). We produce workflows from data download to creation of websites with interactive dashboards entirely from do-files, completely bypassing the need for expensive external BI tools like Tableau, etc.

---

## Who makes up the core audience and why will they find it appealing?

**The Core Audience:**
1. **Practitioner-Researchers and Evaluators:** Analysts working in nonprofits, think tanks, foundations, school districts, and government agencies doing Monitoring, Evaluation, and Learning (MEL). We teach free or grant sponsored workshops and provide technical assistance to these audiences frequently and they frequently ask for these packages, features, tools, and coding examples. 
2. **Applied Data Scientists:** Researchers looking to modernize their Stata workflows with APIs, web scraping, and serverless HTML dashboards.
3. **Implementation Scientists:** Academics and practitioners focused on real-time program monitoring and fidelity including embedded, real-time partnerships during the course of a study or implementation.

**Their Situations & How This Book Helps:**
These readers constantly face chaotic data drops, strict data-use agreements, restrictive IT firewalls, and audiences who are intimidated by regression tables. They find themselves having to answer questions like, "Are we reaching our target population?" by Monday morning using the right tools. 
This book helps them by providing battle-tested code to:
* Automate the ingestion of dozens of messy Excel sheets (`convertanything`).
* Shrink noisy, small-denominator rates so tiny clinics aren't unfairly penalized in rankings (`rateshrink`).
* Deliver results in the formats clients actually use—like formatted Excel workbooks or live Google Sheets (`googlesheets`)—without typing a single number by hand.
* Build interactive HTML portals that run offline, bypassing strict government/agency firewalls (`statashiny`, `sparkta2`, `webdoc2`, `googlechart`).

**Assumed Knowledge:**
We assume the reader has basic-to-intermediate Stata knowledge (they know what a do-file is, can merge datasets, and can run a basic regression) - we think this book build naturally upon Scott Long's workflow book and our -projectbuilder- ado match many of the principals his book offers - but it also helps automate the documentation, error-checking/QC, and file path control mechanisms that Long's book offers by handcoding only. 
We do *not* assume a background in computer science, web development, or advanced econometrics. We teach some necessary vernacular and basic skills to understand why and when you interact with API or modern data architecture (json/parquet), HTML/web concepts, and causal inference intuition but do not expect the reader to become an expert on the mechanics of these from this book (instead we offer wrappers to make most of this work free from non-Stata coding aspects of these types of workflows (e.g., Stata dashboards with interactive maps without having to write any HTML or .js) ). 

---

## Annotated Table of Contents

The book is divided into five parts, following a project's natural lifecycle from an empty folder to a delivered portal.

### PART I: THE EMBEDDED EVALUATOR WORKFLOW
**1. The embedded evaluator**
*Point:* Defines the role of the embedded evaluator and establishes the book's four principles: replicable, extensible, accessible, and actionable.
*Contribution:* Sets the professional and ethical foundation. It gives readers the vocabulary (e.g., Plan-Do-Study-Act) to defend their independence and negotiate data charters with clients.

**2. Setting up a project that survives deadlines**
*Point:* How to build a folder structure and master control file (`00_control.do`) that guarantees a project can be handed off or rerun years later. 
*Contribution:* Introduces the numbered pipeline, robust package management, and performance benchmarking (using `gtools`), ensuring readers' code doesn't break when moved to a colleague's laptop.

### PART II: GETTING THE DATA
**3. Downloading public data through APIs**
*Point:* Teaches the anatomy of an API request and how to pull crucial denominator data (Census, BLS, CDC) directly into Stata without manual downloads.
*Contribution:* Introduces `getcensus`, `educationdata`, `import fred`, and our custom `webapi` tool for parsing nested JSON seamlessly via Stata's Python bridge.

**4. Harvesting data when there is no API**
*Point:* How to automate data ingestion when agencies only provide download buttons or messy shared-drive drops.
*Contribution:* Covers responsible scraping, streaming impossibly large files to avoid memory crashes, and using `convertanything` to clean chaotic folder trees of mixed file formats.

**5. Working with survey platforms**
*Point:* Connecting Stata to live survey platforms (Qualtrics, REDCap) to monitor response rates in real-time.
*Contribution:* Teaches total survey error, automated likert-scale generation (`likertscale`), nonresponse bias diagnostics, and generating cross-wave codebooks. 

**6. Building longitudinal data you can trust**
*Point:* Linking administrative records that lack shared identifiers and reshaping them into analysis-ready panels.
*Contribution:* Covers probabilistic record linkage (cleaning, blocking, scoring via Jaro-Winkler), handling schema drift, declaring panels with `xtset`, and transparent missing-data handling.

### PART III: TURNING DATA INTO EVIDENCE
**7. Making numbers trustworthy**
*Point:* Implementing safeguards before making claims: reliability checks, survey weighting, and stabilizing noisy small-sample rates.
*Contribution:* Introduces `rateshrink` for empirical-Bayes shrinkage, conformal prediction (`conformalpred`) for distribution-free prediction intervals, and power calculations. 

**8. From differences to defensible claims**
*Point:* Matching the claim to the design, focusing on modern Difference-in-Differences (DiD).
*Contribution:* Translates the new DiD econometrics (`csdid`) for practitioners. Shows how to avoid TWFE bias, visualize event studies, choose transparent comparison groups, and simulate Return on Investment (ROI) with Monte Carlo methods (`roisim`).

### PART IV: COMMUNICATING RESULTS
**9. Graphing for busy readers**
*Point:* Designing static graphics optimized for human perception and busy executives.
*Contribution:* Applies Cleveland-McGill perceptual rankings to Stata graphs. Teaches small multiples, coefficient plots (`coefplot`), and self-contained captions.

**10. Building interactive charts and infographics**
*Point:* Generating interactive web charts (maps, animations) directly from Stata without external BI tools.
*Contribution:* Showcases `googlechart` and `sparkta2` to create hoverable choropleths, animated bubbles, and sparklines that render completely offline for air-gapped environments.

**11. Delivering through spreadsheets**
*Point:* Delivering data in the client's native format (Excel/Google Sheets) without sacrificing reproducibility.
*Contribution:* Teaches the strict "never type a number" discipline. Uses `putexcel`, `collect`, and `googlesheets` to automatically push regressions and formatted tables to live, shared workbooks.

**12. Publishing self-contained reports and portals**
*Point:* Wrapping narratives, code, and interactive charts into a single, self-contained HTML portal.
*Contribution:* Uses `webdoc2` and `statashiny` to compile Stata output into serverless dashboards. Introduces strict version-stamping (Git commit hashes in the footer) for auditing.

### PART V: SUSTAINING THE PRACTICE
**13. Using AI without getting burned**
*Point:* A safe, rigorous framework for integrating Large Language Models (LLMs) into the evaluation workflow.
*Contribution:* Positions Stata as the strict backbone and the LLM as the coding partner. Introduces `llmsieve` for multi-model consensus, privacy gates, and prompt-injection defenses when classifying free-text case notes.

**14. Sharing data and results safely**
*Point:* Preparing analytic files for public release without re-identifying vulnerable individuals.
*Contribution:* Teaches k-anonymity scanning (`riskscan`), automated primary/complementary cell suppression (`suppress`), and human-in-the-loop sanitization.

**15. Turning scripts into shared tools**
*Point:* Converting repetitive do-file blocks into documented, shareable Stata packages (`.ado`).
*Contribution:* Shows how to write Stata help files, distribute via GitHub (`net install`), integrate Mata/Python for speed bottlenecks, and build permanent replication archives.

---

## Sample Chapter

The manuscript is currently drafted in LaTeX (utilizing the `kaobook` class for a beautiful, modern layout with margin notes and integrated graphics). A fully compiled PDF draft of the entire book (240+ pages) is available for review, featuring live code, statistical outputs, and high-quality visualizations. We are happy to submit specific chapters in standard PDF or TeX format upon request.

---

## About the Authors

**Eric A. Booth** Eric is an applied evaluation  and data systems specialist with extensive experience in the public policy and nonprofit sectors (currently at Texas 2036). He has a long history of teaching about and developing open-source Stata packages designed to bridge the gap between statistical analysis and modern data engineering. His tools often focus on API integration, reproducibility, and workflow automation.

**Elizabeth Teas** Elizabeth is an applied researcher and evaluator at Far Harbor, LLC. She specializes in implementation science, program evaluation, and translating complex statistical findings into actionable strategies for community organizations, foundations, and government agencies. 

---

## Timetable

The manuscript is in an advanced draft stage. All 15 chapters have early drafts (we share them here) and while much of this content needs to be refined, condensed, and sharpend, we currently have this as a 240+ page LaTeX document (it's using tufte layout which we like but converted to classic Stata press layout if you all decide to publish it and require that layout may condense the narrative length by as much as 10-15%, also some of this work might need to live in a website live technical appendix).  Nearly all the custom Stata packages referenced in the book have been developed and tested, some are still in progress.

* **Final Manuscript Delivery:** Anticipated within 3 to 6 months (plus allowing  time for peer review, layout adjustments for Stata Press standards, and final copyediting).  We anticipate that given the nature of these contents (fast moving technologies) we'll want the flexibility to make changes close to press time where possible. 
* **Target Publication:**   Early 2027.
