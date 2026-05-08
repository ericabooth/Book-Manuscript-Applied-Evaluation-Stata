# Beyond Analysis: Strategic Evaluation with Stata
### Data Modernization, Modern Causal Inference, and AI-Integrated Workflows

**Authors:** Eric Booth & Elizabeth Teas  
**Status:** 🚧 *Preprint Draft in Progress* 🚧

---

## Overview
*Beyond Analysis* is a practical guide designed to equip professionals in implementation science, applied research, and evaluation with the skills to harness **Stata’s** power for real-world challenges. This book bridges the gap between advanced statistical programming and actionable insights tailored to foundations, nonprofits, and implementation programs.

The focus is on moving beyond "parachute research" toward **embedded evaluation**—building sustained, strategic relationships between researchers and practitioners.

## Target Audience
- **Practitioner-Researchers** working within or alongside nonprofit organizations conducting applied monitoring, evaluation, and learning (MEL) activities.
- **Evaluators** in the public sector or foundation spaces supporting program implementation/interventions.
- **Applied Data Scientists** looking to modernize their Stata-centric workflows.
- **Implementation Scientists** focused on fidelity, adaptation, and real-time monitoring.

## Key Topics
This repository and the accompanying book cover modern research techniques often omitted from traditional evaluation texts:
- **AI-integrated or supported workflows:** Leveraging the `gemini` Stata package to run LLM prompts directly from do-files for data cleaning and narrative reporting.
- **Modern/recent causal methods:** Implementing staggered-adoption Difference-in-Differences (`csdid`, `jwdid`) and Synthetic Diff-in-Diff (`sdid`).
- **High-performance Stata:** Using `gtools` and `ftools` to process millions of administrative records in seconds.
- **Dynamic visualization:** Building high-density dashboards using Fahad Mirza's `sparkta` package integrated with `webdoc` for auto-updating HTML portals.
- **Tool building:** From do-files to custom `.ado` commands and leveraging **Mata** for scalability.

## Repository Contents
This GitHub repository serves as the digital companion to the book. At this stage of development, the following are available:
- **`LaTeXBookCode/`**: The source code for the book's manuscript (compiled using the `kaobook` class).
- **`draft_book_outline.pdf`**: A high-level overview of the chapters and technical goals.
- **Example Data & Scripts**: (Coming Soon) Implementation examples for each chapter.
- **Custom Tools**: Integration scripts for the Gemini CLI and specific evaluation templates.

## Status Note
**Only the book outline is currently available publicly.** Full chapter content is being developed for a 2026/27 release. We are currently sharing the architecture of the book to solicit feedback from the applied evaluation community.

## Citation & Contact
If you are interested in reviewing early drafts or collaborating on specific implementation science modules, please contact:

*Eric Booth* 

eric.a.booth@gmail.com  
Texas2036.org
    _and_
*Elizabeth Teas*
Far Harbor, LLC
---
*This work is released under the terms provided in the [LICENSE](LICENSE) file.*
