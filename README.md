# Applied Program Evaluation Using Stata
### A Practical Workflow from Data to Deliverables

**Eric A. Booth and Elizabeth Teas**

**Status:** complete manuscript draft (preprint). 352 pages: fifteen chapters in five parts, five appendices, 72 figures, and 32 tables. The text may change before publication.

**Read it:** [`LaTeXBookCode/main.pdf`](LaTeXBookCode/main.pdf)

---

## What the book covers

This book teaches the whole job of an analyst embedded with a nonprofit, foundation, school district, or public agency, from an empty project folder to a result the client can open and trust. Most statistics texts start after the data are clean. This one starts before the data arrive and continues after the estimates are in.

You learn to do each stage of an evaluation in Stata:

- pull public data from APIs and from agencies that offer only a download button;
- link records that share no identifier, and build a documented panel that can answer "where did this number come from?";
- make a claim at the level of rigor the data support, from a careful descriptive comparison to the newer difference-in-differences estimators;
- deliver the result in the form the client already uses: a formatted workbook, a live Google Sheet, or a self-contained HTML report or dashboard that opens without a server;
- work with an AI assistant iteratively, approving each piece of code before it runs and checking every reported number and reference against its evidence.

The book extends J. Scott Long's *The Workflow of Data Analysis Using Stata* into the parts of an evaluation that arrive messy: data releases whose columns change between years, metadata that must survive years of merges, and reviewers who need to trace every number. Four principles run through it, and each chapter tests its deliverables against them: **replicable, extensible, accessible, and actionable**.

## Who it is for

- **Evaluators and practitioner-researchers** doing monitoring, evaluation, and learning work in nonprofits, foundations, school districts, and government agencies.
- **Applied data analysts** who want APIs, web data, and interactive deliverables without moving the project out of Stata.
- **Implementation scientists** monitoring programs and fidelity while a study runs.

The book assumes basic-to-intermediate Stata: you know what a do-file is, can merge datasets, and can run a regression. It does not assume a background in web development or advanced econometrics.

## How the book is organized

| Part | Chapters |
|---|---|
| **I. The embedded evaluator workflow** | 1. The embedded evaluator · 2. Setting up a project that survives deadlines |
| **II. Getting the data** | 3. Downloading public data through APIs · 4. Harvesting data when there is no API · 5. Working with survey platforms · 6. Building longitudinal data you can trust |
| **III. Turning data into evidence** | 7. Making numbers trustworthy · 8. From differences to defensible claims |
| **IV. Communicating results** | 9. Graphing for busy readers · 10. Building interactive charts and infographics · 11. Delivering through spreadsheets · 12. Publishing self-contained reports and portals |
| **V. Sustaining the practice** | 13. Using AI in a reproducible evaluation workflow · 14. Sharing data and results safely · 15. Turning scripts into shared tools |
| **Appendices** | A. The setup guide · B. The causal quick-reference toolbox · C. The book's toolkit · D. Two hands-on worked examples · E. A reproducible capstone: one public dataset, ingest to deliverable |

## Every printed number comes from a do-file

Each worked example in the book is a do-file in [`code/`](code/), and those do-files produced every figure, table, and printed result. The examples use public downloads, datasets shipped with Stata, or data the do-file simulates with a fixed seed, so you can rerun any of them and get the numbers on the page. [`code/README.md`](code/README.md) lists each file and the setup it needs; a few examples need a free API key, an account, or a community package.

To run the examples:

1. Open `code/00_control.do` and set the one `global root` line to the folder that holds `code/`.
2. Run `code/01_install.do` once to install the packages the book uses.
3. Run `00_control.do`, then any chapter do-file, or set `local run_all 1` in `00_control.do` to rebuild everything in order.

## The companion Stata packages

The workflow runs on free, open-source packages the authors wrote. Eleven are on SSC and install in one line each:

```stata
ssc install projectbuilder
ssc install combineall
ssc install convertanything
ssc install datadictionary
ssc install reshapehelper
ssc install webapi
ssc install googlesheets
ssc install googlechart
ssc install statashiny
ssc install dashboardbuilder
ssc install statplot
```

`statplot` is joint work with Nicholas J. Cox. The fourteen packages built alongside the book, four of which are also among the SSC eleven, live in the `*-stata-public/` folders of this repository, each with its ado-file, help file, and test battery: `combineall`, `conformalpred`, `cxchangelog`, `datadictionary`, `hlmr2`, `projectbuilder`, `rateshrink`, `reshapehelper`, `riskscan`, `roisim`, `suppress`, `synthgen`, `twinmatch`, and `undummy`. Others, such as `sparkta2`, `webdoc2`, `mergemap`, and `surveymap`, install from their own repositories on [github.com/ericabooth](https://github.com/ericabooth). Appendix C of the book lists every package the book uses, ours and other people's, with the chapter that teaches it.

## Repository layout

| Path | Contents |
|---|---|
| `LaTeXBookCode/main.pdf` | The compiled book (`main.pdf` at the top level is a copy) |
| `LaTeXBookCode/src/` | The manuscript source: one `.tex` file per chapter in `src/chapters/`, the preamble, and the assembly script |
| `LaTeXBookCode/images/` | The book's figures, produced by the companion do-files, and its screenshots |
| `code/` | The companion do-files and the commands that ship with them |
| `*-stata-public/` | Packages built for the book, each with tests and a help file |

## Building the PDF

The book uses the [`kaobook`](https://github.com/fmarotta/kaobook) LaTeX class, whose files are included in `LaTeXBookCode/`. Assemble the chapters into `main.tex`, then compile with pdfLaTeX, biber, and makeindex:

```bash
cd LaTeXBookCode/src && bash assemble.sh && cp main_assembled.tex ../main.tex && cd ..
pdflatex main && biber main && makeindex main.idx && pdflatex main && pdflatex main
```

## Feedback

We welcome comments on the draft, especially from evaluators who try the workflow on their own projects. Please open an issue in this repository or write to Eric A. Booth at eric.a.booth@gmail.com.

## Suggested citation

Booth, Eric A., and Elizabeth Teas. 2026. *Applied Program Evaluation Using Stata: A Practical Workflow from Data to Deliverables*. Manuscript draft. https://github.com/ericabooth/Book-Manuscript-Applied-Evaluation-Stata

## License

The code in this repository (do-files, ado-files, help files, and scripts) is released under the MIT License; see [LICENSE](LICENSE). The manuscript itself, meaning the text and figures of the book in `LaTeXBookCode/` (including `main.tex`, `src/`, and the compiled `main.pdf`), is copyright © 2026 Eric A. Booth and Elizabeth Teas, all rights reserved, and is not covered by the MIT License. The packages in the `*-stata-public` folders carry their own MIT licenses.
