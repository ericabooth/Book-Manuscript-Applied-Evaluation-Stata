# Receipts: Applied Program Evaluation Using Stata

Thesis (one sentence): Use Stata as the command center of an embedded evaluation, pull data from APIs and surveys, build longitudinal data you can defend, produce evidence at the right level of rigor, and deliver reproducible, client-ready products, with the LLM as a coding partner rather than a replacement.
Document: LaTeXBookCode/main.tex (assembled from scratchpad chapters); companion code in code/.
Started: 2026-07-05 | Last updated: 2026-07-05

This ledger is the single source of truth for the book's numbers. Every worked-example number in the prose traces to a companion do-file that produced it. Re-verify by running the do-file (all use public data or seeded simulation) and reading its log.

## Claims ledger (verified worked-example numbers)

| # | Claim in prose | Value | Source do-file | Re-verify with | Verified | Status |
|---|---|---|---|---|---|---|
| 1 | Houston private-sector weekly wage, 2023 Q1 | \$1,900 | code/20_ch03_apis.do | `stata-mp -b do code/20_ch03_apis.do` (list block) | 2026-07-04 | verified |
| 2 | Austin / Dallas / Ft. Worth / San Antonio weekly wage | 1,862 / 1,839 / 1,391 / 1,270 | code/20_ch03_apis.do | same log | 2026-07-04 | verified |
| 3 | jsonplaceholder users returned; CDC mortality rows | 10 ; 52 (HTTP 200) | code/ch13_...→ch03_webapi.do | `stata-mp -b do code/ch03_webapi.do` (needs webapi on adopath) | 2026-07-04 | verified |
| 4 | TX public-school enrollment 2015; 2022; 2020 dip | 5,301,916 ; 5,519,724 ; ~122,000 | code/ch03_educationdata.do | `stata-mp -b do code/ch03_educationdata.do` (list block) | 2026-07-04 | verified |
| 5 | DiD: true ATT ; naive TWFE ; csdid (seed 20260704) | 4.83 ; 3.26 (bias -1.57) ; 4.86 (+0.03) | code/ch08_did.do | `stata-mp -b do code/ch08_did.do` (table block) | 2026-07-04 | verified |
| 6 | Backbone tripwire: N with wage<5 (two wrong guesses caught) | 757 (132, 278 failed) | code/ch13_backbone.do | `stata-mp -b do code/ch13_backbone.do` | 2026-07-05 | verified |
| 7 | Parallel bootstrap of tenure coef: reps ; SE ; 95% CI | 1000 ; 0.019 ; [0.112, 0.187] | code/ch13_parallel.do | `stata-mp -b do code/ch13_parallel.do` | 2026-07-05 | verified |
| 8 | Cronbach's alpha before/after dropping weak item (sim) | 0.7576 -> 0.7939 | code/ch07_trust.do | `stata-mp -b do code/ch07_trust.do` | 2026-07-04 | verified |
| 9 | External citations in bibliography, all web-verified | 18 works | LaTeXBookCode/main.bib | biblatex; see references.bib provenance | 2026-07-05 | verified |

Any figure or table number in a caption traces to the same do-file as the panel it describes.

## Task checklist (clearwriter pass, 2026-07-05)

- [x] Style sweep (banned-phrase grep; 0 "plain english", 0 moralizing, 0 generic hedges, fixed 1 "dramatic", 1 "very", table-cell dashes, appendix-title em-dashes)
- [x] Structure pass (thesis early, signposts tell the story)
- [x] Paragraph pass (three moves, one idea each)
- [x] Sentence pass (actors and objects named, jargon glossed, hedges specific)
- [x] Walk-through pattern where a technical concept is compressed
- [x] Numbers pass (all worked-example numbers traced to do-files above; frozen, not to be altered by editors)
- [ ] Cold read as the target reader
- [ ] Independent adversarial review (blindspot)

## Decisions log (including rejected alternatives and dead ends)

| Date | Decision | Reason | Alternatives rejected (and why) |
|---|---|---|---|
| 2026-07-05 | Citations use biblatex author-year (\textcite/\parencite), not numeric | Matches the book's author-year prose | numeric-comp (clashes with "Liu et al. (2024)" prose) |
| 2026-07-05 | Left one cosmetic "undefined references" biblatex backref warning | 0 real undefined refs/cites; class-file surgery would risk breakage | disabling backref/citecounter (loses "cited on pages") |
| 2026-07-05 | clearwriter pass is surgical refinement, not rewrite | Book already built on Gelman/Cox patterns; skill says do not over-rewrite clean prose | full rewrite (would risk breaking tested code/numbers) |
| 2026-07-04 | sparkta2 kept with %TODO-verify | source not yet public | printing an install line that would 404 |
