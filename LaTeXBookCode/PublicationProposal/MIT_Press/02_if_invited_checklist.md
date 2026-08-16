# If she asks for a full proposal — what to assemble

Stage 2 starts only if Catherine Woods replies asking for more. Nothing in this file gets written before that reply, and nothing here gets sent unasked. Ask her what she wants first, then build from this list.

## The four things MIT Press requires

| # | Item | Their wording | Where the text already exists |
|---|---|---|---|
| 1 | **Prospectus** | describes your intentions, following the content points below | `../stata_press_proposal.md` and `../PolicyPress_BristolUP/02_proposal.md` between them cover every point |
| 2 | **Detailed table of contents** | "a detailed table of contents" | Annotated TOC in `../stata_press_proposal.md`; page-level TOC is pages iii–vi of `main.pdf` |
| 3 | **Two to four sample chapters** | "ideally, about one-fourth of the work should be submitted" | Chapters 1, 2, 6, and 13, exported from `main.pdf` |
| 4 | **CV** | "an up-to-date curriculum vita or resumé" | Yours to supply, for both authors |

## The prospectus, point by point

Their page asks a prospectus to answer five things. Write to their order and their phrasing, because an editor reading forty inquiries a month notices when someone did.

1. **The work, its rationale, approach, and pedagogy**, in one or two paragraphs. Lift the opening of `../stata_press_proposal.md` and add the pedagogy sentence MIT asks for that Stata Press did not: exercises at the end of every chapter, callout boxes stating what each statistical guarantee depends on, worked examples that run, and companion do-files that regenerate every printed number.
2. **The distinctive features**, as a short list. The five that carry weight: a finished 336-page manuscript; every number produced by a rerunnable do-file; five free companion Stata packages that implement the book's workflow; Chapter 13 on using language models inside an evaluation, which has no competing treatment anywhere; and Appendix E, a 30-page reproducible capstone.
3. **The competition**, discussed "individually and specifically," with strengths and weaknesses, and how this book is similar to and different from each in style, coverage, and depth. See the section below before writing it.
4. **Your qualifications**, meaning why these two people and not others. The author paragraphs in `../stata_press_proposal.md` are ready. Keep the sentence that says you are practitioners; it is the answer to the question, not a weakness to manage.
5. **The market**, meaning who buys the book, what new information justifies the price, and **your estimate of the total market**. MIT is the only press in this folder that asks for a number. Nobody can invent it for you, and the honest route is a bottom-up count: evaluation staff in state agencies and large districts, members of the professional evaluation associations, enrollment in public policy and public health graduate methods courses, plus your own workshop attendance and package download counts.

Their page also invites **suggested reviewers** and asks you to clarify your relationship with each person named. As in every other package here, that list is left blank on purpose. It is your call who reads your book.

**Add the AI disclosure to the prospectus.** MIT Press requires authors to inform their editors of AI use and to be transparent about it in the manuscript. Put it in writing here rather than in a later email, and reuse the same wording in the book's front matter.

## The competition analysis, and the Long problem

Their instruction is blunt: *"please be as frank as possible... Please mention all pertinent titles."* A thin competition section reads as either ignorance of the field or evasion, and it is the section acquisitions editors read hardest.

The titles a frank analysis has to name, at minimum. Check every edition and year against the book's own reference list before sending:

- **J. Scott Long, *The Workflow of Data Analysis Using Stata* (Stata Press).** The head-to-head. Everything else is secondary.
- **Cameron and Trivedi, *Microeconometrics Using Stata* (Stata Press).** Deeper on estimation, silent on data arrival and delivery.
- **Mitchell, *Data Management Using Stata* (Stata Press).** Overlaps on cleaning, stops before provenance, packaging, and deliverables.
- **Huber, *Causal Analysis* (MIT Press, 2023).** Their own list, same length, same price. Strong on identification, aimed at academic readers, and it assumes the data.
- **Clarke, *Applied Microeconometrics*, and Westhoff, *An Introduction to Econometrics* (both MIT Press).** The only two Stata-adjacent titles they publish. Both use Stata to teach econometrics rather than teaching the workflow.
- **Gertler and colleagues, *Impact Evaluation in Practice* (World Bank).** The free title every evaluator already has. Strong on design, no code, no delivery.
- **Kara, *Research and Evaluation for Busy Students and Practitioners* (Policy Press).** The practitioner audience, without the quantitative machinery.

**Now the awkward part.** A frank head-to-head means writing, for MIT, that Long's book stops where this book starts. That claim is true and Chapter 1 already makes it in print. It is still uncomfortable if Stata Press, which publishes Long, is reading the same proposal the same month.

Two ways through, and the choice is yours:

- **Argue extension rather than replacement**, which is what the manuscript itself argues. Long standardized the analyst's own files; this book carries that discipline into metadata, drifting column names, undocumented extracts, and a reviewer who corrects the record without touching the data. That is a frank assessment of where Long's coverage ends, stated without disparaging a book you are building on. It satisfies MIT and would embarrass nobody if Stata Press read it.
- **Write nothing for one press you would not want the other to read.** Proposals circulate, reviewers overlap, and the Stata publishing world is small.

Recommendation: take the first route. It costs nothing in frankness and removes the tension entirely. If you would rather sharpen the contrast for MIT, decide that deliberately and accept that Stata Press may see it.

## The detailed table of contents

Fifteen chapters in five parts, then five appendices. Give the annotated version, not the bare list, since MIT asks for detail.

| App. | Title | Pages |
|---|---|---|
| A | The Setup Guide | 4 |
| B | The Causal Quick-Reference Toolbox | 2 |
| C | The Book's Toolkit | 2 |
| D | Two Hands-On Worked Examples | 4 |
| E | **A Reproducible Capstone: One Public Dataset, Ingest to Deliverable** | 30 |

Appendix E is nearly a tenth of the book and it is a selling point rather than back matter: one public dataset carried from first download to finished deliverable, reproducible end to end. Name it in the prospectus.

## The sample chapters

**Send Chapters 1, 2, 6, and 13. Together they run 92 pages, about a quarter of 336, which is what their guidance asks for, and four chapters is the top of their two-to-four range.**

| Ch. | Title | Why it is in the set |
|---|---|---|
| 1 | The embedded evaluator | Frames the role, states the four principles, and previews the route the book takes |
| 2 | Setting up a project that survives deadlines | Builds the project scaffold the rest of the workflow runs on |
| 6 | Building longitudinal data you can trust (28pp) | The capstone chapter. Section 6.6 proves the whole argument on one worked example, with a full-page figure of the route |
| 13 | Using AI without getting burned | The chapter with no competing title anywhere, and the one Woods can judge without knowing Stata |

Chapter 6 is the one to lead with in the covering note. It is the argument in miniature, and it is the chapter that answers the question an economics editor will actually ask, which is what this book does that the existing shelf does not.

## What only you can supply

The same gaps as the other four packages, plus one MIT adds:

1. **CVs for both authors.** Required outright.
2. **Suggested reviewers**, with your relationship to each stated.
3. **A total market estimate in numbers.** New here. Stata Press, Vernon, Anthem, and Bristol all accepted a described audience; MIT asks you to size it.
4. **The AI disclosure wording.**

## Timing, so the calendar is not a surprise

Peer review at the proposal stage comes first, and a textbook may go to more reviewers than a monograph would. The contract decision then waits for the MIT Press Editorial Board, which is MIT faculty and meets four times each year. A second round of review follows once the complete manuscript is delivered, which in your case is now. Ask Woods when the Board next meets, and plan the other presses on their own clocks rather than around this one.
