# Applied Program Evaluation Using Stata: 
## A Practical Workflow from Data to Deliverables
###** Data Modernization, Modern Causal Inference, and AI-Integrated Workflows**

**Authors:** Eric A. Booth (Sr Researcher, Texas 2036) & Elizabeth Teas (Sr Research Scientist, Far Harbor, LLC)  
**Status:** 🚧 *Preprint Draft in Progress* 🚧

---
<img width="508" height="754" alt="Screenshot 2026-07-26 at 7 03 25 PM" src="https://github.com/user-attachments/assets/1674bad6-e203-4646-8747-0e5a7eb436e9" />

## Overview
*Applied Program Evaluation Using Stata* shows implementation scientists, applied researchers, and evaluators how to carry a project from source data to a checked, reproducible deliverable in Stata. The examples address work in foundations, nonprofits, public agencies, and implementation programs.

The book treats **embedded evaluation** as an ongoing working relationship between researchers and practitioners. Its examples emphasize data and tools that program staff can inspect, rerun, and use after a study ends.

## Target Audience
- **Practitioner-Researchers** working within or alongside nonprofit organizations conducting applied monitoring, evaluation, and learning (MEL) activities.
- **Evaluators** in the public sector or foundation spaces supporting program implementation/interventions.
- **Applied Data Scientists** looking to modernize their Stata-centric workflows.
- **Implementation Scientists** focused on fidelity, adaptation, and real-time monitoring.

## Key Topics
This repository and the accompanying book cover methods and workflows often omitted from evaluation texts:
- **Language-model workflows:** Calling a language model from a do-file while keeping statistical computation, validation, and logs in Stata.
- **Recent causal methods:** Applying staggered-adoption difference-in-differences (`csdid`, `jwdid`) and synthetic difference-in-differences (`sdid`).
- **Large administrative files:** Using `gtools` and `ftools` where benchmarks show a useful speed gain.
- **Interactive displays:** Building compact dashboards with Fahad Mirza's `sparkta` package and `webdoc`.
- **Stata tools:** Turning repeated code into documented `.ado` commands and using **Mata** when it improves performance.

## Repository Contents
This repository contains the book manuscript and its companion materials:
- **`LaTeXBookCode/`**: The source code for the book's manuscript (compiled using the `kaobook` class).
- **`draft_book_outline.pdf`**: A high-level overview of the chapters and technical goals.
- **Example Data & Scripts**: (Coming Soon) Implementation examples for each chapter.
- **Custom Tools**: Integration scripts for the Gemini CLI and specific evaluation templates.

## Status Note
**Only the book outline is currently available publicly.** Full chapter content is being developed for a 2026/27 release. We are sharing the outline to invite feedback from the applied evaluation community.

## Citation & Contact
If you are interested in reviewing early drafts or collaborating on specific implementation science modules, please contact:

*Eric A. Booth*, Sr Researcher, Texas 2036 — eric.a.booth@gmail.com
    and
*Elizabeth Teas*, Far Harbor, LLC

---
*This work is released under the terms provided in the [LICENSE](LICENSE) file.*
