# Chapters 11–15 editorial record, 2026-09-05

Authoritative files: LaTeXBookCode/src/chapters/43_ch11.tex, 44_ch12.tex, 51_ch13.tex, 52_ch14.tex, 53_ch15.tex. Preserved chapter order and broad AI-chapter voice; retained useful technical contrasts and procedural lists. No assembled file edits, compilation, or commits.

213 recorded exact prose replacements (175 initial + 38 polish), plus code/excerpt repairs. The JSON companions retain before/after text for all recorded replacements. Additional code changes are visible in git diff.

## Teaching repairs

1. `43_ch11.tex:10`. Before: A cell-error probability was treated as certainty that a final result is wrong. After: Explained independence and constant-error assumptions; distinguished formula-cell errors from errors in the final result; recomputed 1-.98^200 = .9824120534.

2. `43_ch11.tex:65`. Before: Simulated earnings coefficients were described as the value of training and a stronger labor market. After: Explained conditional association and selection concerns, preserving the reporting example without a causal interpretation of simulated records.

3. `43_ch11.tex:138`. Before: Exporting stored results was said to eliminate all disagreement. After: Added checks of coefficient, standard error, sample size, active estimates, and destination labels. Added visible estimates restore m2 in the manuscript snippet.

4. `43_ch11.tex:336`. Before: A row-count assertion was described as verifying the entire export. After: Explained what counts miss, how to inspect a failed import, and how to compare identifiers and numeric values with a saved export.

5. `44_ch12.tex:12`. Before: A top-to-bottom do-file was said to eliminate hidden state automatically. After: Added a clean-session procedure and explicit inputs/settings check.

6. `44_ch12.tex:67`. Before: Generated reports were said to make prose/number disagreement impossible. After: Used the existing fixed urban-site sentence to show how narrative becomes stale; explained numeric insertion versus substantive review.

7. `44_ch12.tex:321`. Before: Table treated offline portals as self-updating and Excel as noninteractive/nonreplicable. After: Rebuilt comparison table and aligned decision caption: offline portal is an interactive snapshot that must be rebuilt and redistributed.

8. `44_ch12.tex:487`. Before: CDC mortality ingest was implied to feed uninsured/site-completion panels. After: Marked existing sequence as an assembly sketch, explained required dataset switches, and replaced an impossible exercise with a variable-source check.

9. `51_ch13.tex:119`. Before: A guessed assertion count was fixed by accepting whatever Stata printed. After: Added diagnosis of definition, sample restriction, and expected value before changing a check.

10. `51_ch13.tex:296`. Before: Kappa explanation used wrong denominator and a universal green light. After: Clarified observed versus expected shares of notes and recomputed .8241; added category counts, consequences, and planned threshold interpretation.

11. `51_ch13.tex:447`. Before: Character edit distance was called semantic confidence. After: Explained paraphrases and short negations, distinguished stability from accuracy, and prescribed review of flagged and unflagged records.

12. `51_ch13.tex:466`. Before: PPI variance treated nested gold labels as an independent sample. After: Added 2 Cov(machine,gap)/N term to equation and existing companion dofile; stated iid population target and finite-caseload distinction. Verified corrected interval .232 to .343.

13. `51_ch13.tex:593`. Before: capture assert printed BLOCKED but did not stop. After: Added exit 459 and count diagnostic in excerpt; supplied code/ch13_injection_gate.do with rejected/resolved/on-list-wrong test cases.

14. `51_ch13.tex:659`. Before: Fairness acronyms and denominators were unexplained. After: Defined TPR/FPR/precision denominators; explained dependence of simulated need on simulated score and limits of four-fifths screening.

15. `52_ch14.tex:86`. Before: Cell-display keep changed person data before riskscan/coarsening. After: Added preserve/restore around the cell display and explained change of analysis unit; companion code already used preservation.

16. `52_ch14.tex:230`. Before: Hand suppression called zero primary, tool called it complementary. After: Aligned prose, caption and existing dofile: three positive primary suppressions plus three complementary cells, including mining zero.

17. `52_ch14.tex:347`. Before: A scanning manifest was described as evidence that fields were removed. After: Separated scan receipt from removal decisions/code; limited k-anonymity and synthetic checks to assessed information and release context.

18. `53_ch15.tex:67`. Before: A new command could appear unchanged because of ado path or loaded program. After: Added which dsload and fresh-session/drop-program troubleshooting around the existing skeleton.

19. `53_ch15.tex:177`. Before: A comment header was said to enforce language version. After: Distinguished package release comment from executable version statement in prose and checklist.

20. `53_ch15.tex:100`. Before: writeinput was implied to solve confidentiality by serializing real records. After: Added requirement for a nonconfidential stand-in and explicit warning that serialization does not anonymize values.

## Verification

- Stata MP full path: `/Applications/StataNow/StataMP.app/Contents/MacOS/stata-mp`.
- From `code/`, `stata-mp -b do ch13_validation.do` completed through `FAIRCHECK_DEMO_OK`, with no Stata error terminator. Nested covariance = -0.047159; corrected prevalence = 0.288; 95% interval = [0.232, 0.343]. The unchanged kappa and fairness examples also executed.
- `stata-mp -b do ch13_injection_gate.do` completed through `INJECTION_GATE_TESTS_PASSED`. Rejected batch returned 459 to the harness; two flags verified; resolved batch passed; an incorrect allowed label passed as expected, demonstrating the gate's limit.
- `stata-mp -b do ch14_kanon.do` completed through `SYNTHGEN_DEMO_OK`. Controls: distinct cells 103, unique people 24, coarsened unique people 3, coarsened cells 39. Positive primary suppressions now agree with manuscript and package behavior.
- `stata-mp -b do ch11_tables.do` completed through DONE / end of do-file. It regenerated tracked data/workbook files; their timestamps/container metadata may differ. Root may restore those two generated tracked files if there is no intended content change.
- `git diff --check` passed. All five chapter files have balanced raw brace counts and no unexpected ASCII controls. Root owns compile and visual QA.
- Logs generated in code/: ch11_tables.log, ch13_validation.log, ch14_kanon.log, ch13_injection_gate.log. They may be moved to work/ after root's review or removed once this verification record is retained. Do not remove the new ch13_injection_gate.do deliverable.

## Sources consulted

- Cox, How to debug, part I, 2026: https://journals.sagepub.com/doi/full/10.1177/1536867X261425801 (read 2026-09-05). General inspiration: inspect small cases, read errors and help, distinguish expected behavior from implemented behavior; no copied prose.
- Stata capture manual: https://www.stata.com/manuals/pcapture.pdf (2026-09-05), confirming capture permits continuation and explicit exit is needed for the shown gate.
- Stata version manual: https://www.stata.com/manuals/pversion.pdf (2026-09-05), confirming executable version semantics.
- HHS de-identification guidance: https://www.hhs.gov/hipaa/for-professionals/special-topics/de-identification/index.html (2026-09-05), supporting Safe Harbor actual-knowledge condition and Expert Determination qualifications.
- EEOC Uniform Guidelines questions and answers: https://www.eeoc.gov/laws/guidance/questions-and-answers-clarify-and-provide-common-interpretation-uniform-guidelines (2026-09-05), limiting four-fifths guidance to its screening and employment-selection context.
- Existing PPI source retained; nested-sample covariance correction follows Var(M_N + D_n) = Var(M)/N + Var(D)/n + 2 Cov(M,D)/N when gold is nested in iid N. This is not the variance for a fixed finite caseload, complex sample, or prompt trained on its validation labels.

## Remaining review limits

- All existing empirical citations were not comprehensively audited. Existing Sweeney/Panko/Reinhart source-history claims, package claims, source vintages, and archival-service claims warrant the root review; no claim that the entire evidence base was verified is made here.
- Ch12 webdoc/statashiny snippets and network-dependent portal remain existing illustrative material; full independent package/API syntax and browser behavior were not validated. The contradictory dataset flow is now disclosed as a sketch. Root should decide whether further implementation is required before publication.
- Newly added estimates restore m2 is a use of the existing stored model in the manuscript's export snippet. Existing ch11_tables.do uses another output filename and already controls its estimation order; no new code-only example was created for that insertion.
- Numeric snippets now match tested results where changed. The PPI full equation is wider than before; root should inspect its layout after compilation.
- No visible authorship attribution added. Necessary subject-matter references to AI/LLMs remain in the AI chapter. Editorial receipts and scripts belong in work/, outside delivered book materials.

The original draft already provides practical scenarios, complete worked structures, and useful connections among Stata commands; these were retained where they explain the reader's task clearly.
