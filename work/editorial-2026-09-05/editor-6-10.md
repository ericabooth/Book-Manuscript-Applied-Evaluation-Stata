# Chapters 6-10 editorial record
Read all five assigned chapter sources, including captions, boxes, code excerpts and exercises. Sources frozen in parent receipts. No new code examples or do-files added. Existing empirical outputs have not been comprehensively re-audited.

Applied 70 targeted edits.

## 1. 24_ch06.tex:3
Reason: Replace dramatic opening with concrete evaluation problem.
Before: Two agency files sit on your desk: student rosters from the education agency, wage records from the workforce agency. They describe the same people and share no common identifier, and the merge you build will have to survive an auditor asking how you knew these two rows were the same person. Linking data across sources and stacking it across years is where most administrative evaluation questions are actually won or lost.
After: An evaluator may need to link student rosters from an education agency to wage records from a workforce agency even when the files share no identifier. The resulting analysis depends on whether the linked rows describe the same people. We need to document how we made those decisions so that a colleague can review the links and repeat them when the next extract arrives.

## 2. 24_ch06.tex:5
Reason: Shorten exhaustive preview while preserving sequence and payoff.
Before: In this chapter we build longitudinal data you can defend, the kind that follows the same units across time (what Stata calls a panel). We link files with no shared key, treat crosswalks as data, trace every variable to its source, refuse bad data loudly, declare and reshape into analysis-ready panels, code the transitions that answer a director's first question, weigh whether the panel has outgrown do-files and belongs in a database, and handle missingness honestly. By the end you will be able to link two files that share no identifier and report the match rate and threshold that produced the link, keep a merge map and a match-rate concordance that say whether this year's refresh merged like last year's, stamp each variable with the source table and vintage it came from, declare and reshape a panel into the long form every later method assumes, and count the transitions that answer a director's question about where participants go. Every one of those steps leaves a record, because construction is the most error-prone stretch of the pipeline. That record is what you hand the auditor who asks how you knew two rows were the same person, and it is what lets next quarter's refresh run on the pipeline rather than on someone's memory of it.
After: In this chapter we link files, document their sources, and arrange repeated observations into a panel, a dataset that follows the same units over time. We then examine transitions and missing observations, and consider when a database would help us manage the files. You will learn to check a new extract against the previous release and explain how the panel was built, so that a later analyst can reproduce both the data and the decisions behind it.

## 3. 24_ch06.tex:25
Reason: Third displayed pair is rejected.
Before: Three accepted pairs read like this:
After: The following candidate pairs include accepted and rejected comparisons:

## 4. 24_ch06.tex:35
Reason: Remove personification.
Before: The third row is the honest failure.
After: The third row illustrates a missed link.

## 5. 24_ch06.tex:43
Reason: Avoid unsupported categorical superiority.
Before: which is why Jaro-Winkler suits names and plain edit distance does not.
After: This prefix adjustment can help with some name errors, but a first-letter error receives no such benefit; choose the comparator after inspecting the errors in your files.

## 6. 24_ch06.tex:118
Reason: Literal explanation.
Before: the participant wears someone else's wages.
After: you attach another person's wages to the participant.

## 7. 24_ch06.tex:120
Reason: Remove enumeration heading.
Before: \subsection{Two defenses that need no new statistics}
After: \subsection{Check sensitivity and report linkage quality}

## 8. 24_ch06.tex:121
Reason: Weakspot: actionable threshold interpretation, no false bound.
Before: Two defenses fit inside an ordinary evaluation workflow, and neither requires new statistics. First, treat the stored similarity score as a sensitivity dial: rerun the headline estimate at a stricter threshold and report whether it moves, which bounds how much the finding depends on the ambiguous middle band of matches.
After: You can use the stored similarity score to examine sensitivity: rerun the headline estimate at a stricter threshold and report whether it changes. Compare the linked sample as well as the estimate, because stricter acceptance can change which participants remain. This check describes sensitivity to the thresholds you tried; it does not bound all possible linkage error.

## 9. 24_ch06.tex:123
Reason: Remove enumerate-first prose.
Before: Second, deliver a linkage report as a standing artifact:
After: Keep a linkage report with the analysis:

## 10. 24_ch06.tex:123
Reason: Qualify causal claim.
Before: a rate gap across race or geography biases comparisons even when the overall rate looks healthy.
After: a rate gap across race or geography can bias comparisons if linked and unlinked participants differ on relevant outcomes.

## 11. 24_ch06.tex:204
Reason: Literal heading.
Before: \section{One workflow carries the year files to a panel that explains itself}
After: \section{Document the panel as you combine the yearly files}

## 12. 24_ch06.tex:346
Reason: Literal heading.
Before: \subsection{The payoff: a panel that answers for itself}
After: \subsection{Checking the saved panel and its source tags}

## 13. 24_ch06.tex:361
Reason: Remove enumeration claim.
Before: The three lines are three different guarantees.
After: Read each check for the question it answers.

## 14. 24_ch06.tex:361
Reason: Literal language.
Before: the tags were last blessed.
After: the data were last signed.

## 15. 24_ch06.tex:510
Reason: Correct actual pooled xtile and next-row operation.
Before: Cut log wage into within-year quartiles, look each worker's next quartile up with a one-period lead,
After: Cut log wage into quartiles using the pooled observations, look up each worker's quartile at her next recorded observation,

## 16. 24_ch06.tex:526
Reason: Correct caption to code.
Before: current within-year log-wage quartile (rows)
After: current pooled log-wage quartile (rows)

## 17. 24_ch06.tex:517
Reason: Weakspot: novice transition denominator, missing last observations, time gaps and cutpoints.
Before: tab wq wq_next, row nofreq
\end{verbatim}
}
After: tab wq wq_next, row nofreq
\end{verbatim}
}

Before using this matrix in your own report, decide what interval the transition is meant to describe. Here the next row may be several years later: \texttt{wq[\_n+1]} selects the next recorded observation within a woman, regardless of the gap in calendar time. The final observation for each woman has no next observation and is excluded from the table. Thus the denominator for a row percentage is the set of observed transitions beginning in that quartile, rather than all women who ever occupied it. For annual mobility, retain only pairs one year apart; for survey-wave mobility, report the range of elapsed times. Also note that the quartile cutpoints are pooled across years, so this example describes movement relative to the pooled wage distribution, not a worker's rank within her own year.

## 18. 24_ch06.tex:693
Reason: Remove banned idiom.
Before: frames earn their place when
After: frames are useful when

## 19. 24_ch06.tex:625
Reason: Remove enumeration pitch.
Before: Four commands cover nearly all of it, and you can read them as a sentence:
After: You can create, switch, and link frames with the following commands:

## 20. 24_ch06.tex:730
Reason: Weakspot: missingness cannot establish MAR; lead-in teaches investigation.
Before: Dropping a row is an analytic decision made in silence, so make the decision visible. Two views do that work here, one showing which variables go missing together and one showing how much each is missing, and by the end you will be able to say what casewise deletion would cost you in rows and whether the pattern justifies imputing instead of dropping. Missing values are rarely missing at random, so casewise deletion can quietly bias an estimate; we first diagnose the pattern with \texttt{misstable patterns}\index{misstable@\texttt{misstable}}, then decide.\marginnote{The methods literature names three regimes \parencite{rubin1987imputation}: missing completely at random (the gap is unrelated to anything), missing at random (explained by things you observe, a site, a wave, a survey mode), and missing not at random (driven by the unseen value itself, the client doing worst being the one who stopped answering). The table shows the shape; only reasoning about the mechanism says which regime you are in, and no command can rescue the third. The gap itself is also data: a missingness indicator that predicts the outcome is a finding about the program, not just a hole to fill.} That command tabulates which combinations of variables go missing together, and on a 200-row sample of the panel it prints a compact map of the structure:
\par
{\footnotesize
\begin{verbatim}
misstable patterns ln_wage hours tenure ///
    union wks_ue msp, frequency
After: Before fitting a model, find out which observations its missing-value exclusions would remove. We use \texttt{misstable patterns}\index{misstable@\texttt{misstable}} to see which variables are missing together, then compare the retained observations with those excluded. These checks help you describe the loss of information and investigate how it arose.\marginnote{The usual distinctions are missing completely at random, missing at random conditional on observed information, and missing not at random, where missingness still depends on the unobserved value after conditioning \parencite{rubin1987imputation}. A pattern table alone cannot distinguish these mechanisms. Ask how the agency collected the variable and why a value could be absent.} The following output summarizes a sample of the panel:

## 21. 24_ch06.tex:747
Reason: Correct missingness inference.
Before: and it would drop them on two specific variables rather than at random.
After: with most exclusions attributable to the missing union and unemployment records. The concentration of gaps does not establish whether the excluded observations differ systematically from the retained ones.

## 22. 24_ch06.tex:747
Reason: Avoid arbitrary size threshold.
Before: Only when missingness is substantial and plausibly related to observed covariates do you reach for multiple imputation
After: When the missingness mechanism and available predictors make the assumptions credible, consider multiple imputation

## 23. 24_ch06.tex:747
Reason: Correct command roles; added no executable example.
Before: Rubin's old rule of thumb was that five imputations suffice, but with 30 to 50 percent missing you want closer to the missing-fraction as a percentage, so 40 imputations, to keep the standard errors stable. And impute inside \texttt{mi estimate
After: Create imputed datasets with \texttt{mi impute}; then fit and pool the analysis with \texttt{mi estimate}. Include variables that predict the missing values and missingness, respect the panel structure, and examine the imputation diagnostics. Choose enough imputations for stable estimates and Monte Carlo errors rather than treating the fraction of missing cells as an automatic prescription.

## 24. 24_ch06.tex:765
Reason: Correct caption claim.
Before: almost all of it on those two variables, not at random.
After: mostly because of gaps in those two variables. This pattern alone does not identify the missingness mechanism.

## 25. 24_ch06.tex:783
Reason: Correct exercise.
Before: decide from the pattern alone whether casewise deletion would drop rows at random.
After: explain why the pattern alone cannot establish whether casewise deletion is unbiased, and name an observed characteristic to compare between retained and excluded cases.

## 26. 31_ch07.tex:3
Reason: Remove punchy opening and invented definitive ranking.
Before: A five-person site ranks worst in the state this quarter because one family moved away. The number is real, the ranking is nonsense, and a funder who reads it may cut the site's budget. Before any comparison or model, the numbers themselves have to be trustworthy: the scales have to measure what they claim, the sample has to stand in for the population, small-denominator rates have to be kept from shouting, and the study has to be large enough to see the effect it seeks.
After: At a site serving only a few families, one family's departure can change the completion rate enough to alter the site's rank. A funder who uses that ranking needs to know how uncertain the rate is. Similar questions arise when we combine survey items into a score, generalize from respondents to a population, or plan a study around an effect that may be hard to detect.

## 27. 31_ch07.tex:5
Reason: Replace exhaustive enumeration with useful preview.
Before: In this chapter we take up those four safeguards, building reliable scales, weighting for representativeness, stabilizing noisy small-site rates, and sizing a study so it can find the effect it was funded to find, plus two newer companions that sharpen them: a prediction band that keeps its promised coverage even when the model is wrong, and a variance split that says how much of the story sites can tell at all. Each one protects a downstream claim from a predictable way of being wrong, which is why they come before the analysis rather than after the reviewer catches the problem. We work each of them here on real or clearly labeled simulated data, in one do-file (\texttt{ch07\_trust.do}) that reruns end to end, so you see each safeguard demonstrated rather than only described. Work through it and you will be able to prune a six-item scale down to the items that hold together, quote a rate weighted back to the population rather than to whoever answered, publish a site ranking that reports shrunken rates for the smallest sites with their reliabilities printed beside them, and price what a planned study can detect before the budget locks, so that when a board asks whether the worst-ranked site is really the worst, or a funder asks what a null result from a small study meant, you answer from checks you already ran rather than from a caveat added at the end.
After: In this chapter we examine survey scales and weights, stabilize small-site rates, and calculate what a planned study can detect. We then build prediction intervals and estimate how much outcome variation remains between sites after accounting for measured predictors. The examples in \texttt{ch07\_trust.do} let you connect each diagnostic to a reporting decision: which comparisons the evidence supports, what uncertainty to show, and what to investigate before publishing.

## 28. 31_ch07.tex:121
Reason: Replace marketing metaphor with action.
Before: The data still speaks, but it stops shouting where it has nothing to say.
After: You retain each site's observed rate and report the adjusted estimate alongside it, so readers can see how much pooling changed the result.

## 29. 31_ch07.tex:78
Reason: Weakspot: alpha does not establish construct validity or group comparability; concrete troubleshooting.
Before: Translated for the program officer who owns the survey, 0.79 licenses group-level use: comparing this quarter's average engagement to last quarter's, or one cohort to another. It does not license decisions about individual caregivers, where the working floor is closer to 0.90. Hand the officer both halves in one sentence, the finding and its license: \enquote{the five-item scale is reliable enough for cohort comparisons, and we will not use it to flag individuals.}
After: Before adopting the shorter scale, read item~6 with the program team. Check whether its wording is reversed, whether its coding matches the other items, and whether it measures a part of engagement that the remaining questions omit. A higher alpha supports greater internal consistency in this sample; it does not establish that the scale measures engagement accurately or works equivalently across cohorts. If you revise the score, document the retained items and the rule for handling unanswered questions, then examine the revised scale in the next pilot before comparing waves. That gives the program officer a reasoned scoring decision rather than a cutoff treated as permission to use the score.

## 30. 31_ch07.tex:76
Reason: Avoid false no-information claim.
Before: so it adds noise rather than information,
After: so it has a weaker relationship with the latent variable than the other items,

## 31. 31_ch07.tex:76
Reason: Correct unsupported measurement invariance.
Before: Pruning the one bad item now buys comparability: this year's engagement score and next year's will measure the same thing across the waves Chapter~\ref{ch:surveys} taught you to collect.
After: A shorter score may be more internally consistent here, but comparability across waves still requires checking item wording, coding, and how the items behave in each wave.

## 32. 31_ch07.tex:118
Reason: Weight sensitivity not nonresponse validation.
Before: that stability is evidence that nonresponse is not driving the headline.
After: that stability shows limited sensitivity to these particular weights, although bias related to unmeasured differences may remain.

## 33. 31_ch07.tex:118
Reason: Weakspot: weight scale versus concentration, concrete next action.
Before: When raking has left a few respondents carrying weights above 30 or 40, investigate or trim before publishing: those few now stand in for whole demographic cells.
After: Inspect the distribution of relative weights and the effective sample size before publishing. Absolute weight values depend on their normalization; a value of 40 is not by itself a reason to trim. If a few respondents dominate the weighted estimate, investigate their cells and compare results under a documented trimming rule.

## 34. 31_ch07.tex:278
Reason: Remove absolute claim in heading.
Before: \section{Prediction intervals that keep their coverage when the model is wrong}
After: \section{Calibrating prediction intervals for new cases}

## 35. 31_ch07.tex:279
Reason: State condition beside guarantee.
Before: a bad model costs interval width, never the coverage rate.
After: the guarantee depends on exchangeability of calibration and new cases and on the prescribed calibration quantile. A weak predictor can produce wide intervals.

## 36. 31_ch07.tex:296
Reason: Correct finite sample quantile definition.
Before: their empirical $(1-\alpha)$ quantile;
After: their finite-sample-adjusted quantile, taken at rank $\lceil(n_{\mathcal C}+1)(1-\alpha)\rceil$ among the ordered calibration residuals, where $n_{\mathcal C}$ is the calibration sample size;

## 37. 31_ch07.tex:348
Reason: Weakspot: calibration versus test coverage.
Before: Across new respondents from the same population, 90\% of such bands contain the true wage, confirmed by the package's held-out coverage of 0.90.
After: Under exchangeability, the procedure targets at least 90\% marginal coverage for new cases. The reported calibration coverage of 0.90 checks the fitted band on the residuals used to set its width; it is not an independent test of future coverage.

## 38. 31_ch07.tex:357
Reason: Replace individual guarantee with marginal coverage.
Before: \enquote{the next participant's wage will fall between \$1 and \$13, and that promise does not depend on our wage model being right.}
After: \enquote{for participants exchangeable with our calibration sample, this procedure targets coverage of at least 90\% across new cases; the interval for this participant is about \$1 to \$13.}

## 39. 31_ch07.tex:425
Reason: Weakspot: remove invented ICC cutoffs and teach ranking uncertainty.
Before: It is worth agreeing on a decision rule for the ICC before anyone builds a site ranking, because the threshold is far easier to set while no site's position depends on it. Under a few percent, decline the ranking and say why: site differences are indistinguishable from noise, and the useful comparisons are between kinds of people, not kinds of sites. Near ten percent, as here, rank with the shrinkage of \S\ref{sec:shrink} and a stated caveat. Above twenty or thirty, site comparisons are the story, and the follow-up question becomes which site practices explain the gap. The one-sentence translation for the program officer: \enquote{about 9\% of what moves wages is the industry, so industry rankings are real but faint.}\marginnote{\texttt{hlmr2} covers linear mixed models fit by \texttt{mixed}; \texttt{melogit} and other generalized mixed models are out of scope. For random-slope models it sums the variance components and ignores their covariances, printing a note when it detects slopes, so treat that figure as an approximation.}
After: Use the ICC to describe clustering, then examine uncertainty in the site estimates before deciding whether to rank them. A small ICC can coexist with precisely estimated site differences when sites are large; a large ICC can coexist with uncertain rankings when sites are small. In this adjusted wage model, the ICC describes the share of residual variation between industries after accounting for grade and age. For a program scorecard, also examine site sample sizes, intervals around site estimates, and sensitivity to the adjustment variables. Those checks address whether neighboring ranks are distinguishable, which the ICC alone cannot tell you.\marginnote{\texttt{hlmr2} covers linear mixed models fit by \texttt{mixed}. For random-slope models its summary ignores covariances and is an approximation; consult the package's output note before interpreting it.}

## 40. 31_ch07.tex:421
Reason: Correct variance diagram caption denominator.
Before: each bar the full wage variance.
After: with different denominators: the ICC partitions residual variance after the fixed predictors, while the $R^2$ summary includes variation in their fitted contribution.

## 41. 32_ch08.tex:7
Reason: Remove long enumerated promise.
Before: We start with well-built descriptive comparison, which answers most evaluation questions credibly, add the decomposition that splits a group gap into composition and structure, move to the one causal method this book teaches in full, difference-in-differences, then to cost and return, and end with the discipline that keeps all of it honest. By the end you will be able to draft a claim sentence your design can actually support, split a group gap into the part your measured characteristics explain and the part they do not, estimate the effect of a staggered rollout against a comparison group that stays clean and show the event-study plot that licenses the causal reading, price a program as a range rather than a single ratio, and keep the two documents that put every specification on the record, a dated pre-analysis memo and a robustness ledger. You will want all of that the next time a board asks whether the program worked, a funder asks for the design in one paragraph, and a skeptical reader asks what else you tried. Throughout, rigor means matching the claim to the design, not maximizing the machinery, which is why the strongest and simplest tools come first.
After: We begin with descriptive comparisons and a decomposition of a group gap, then work through difference-in-differences for a staggered policy rollout. We finish by examining program costs and documenting alternative specifications. You will learn to match a claim to its comparison group, explain the assumptions that support it, and keep enough of the analysis record for a colleague to check your choices.

## 42. 32_ch08.tex:157
Reason: Correct statistical interpretation.
Before: and the $p$-value is zero,
After: and the displayed $p$-value rounds to zero,

## 43. 32_ch08.tex:98
Reason: Distinguish Bacon positive comparison weights from negative treatment-effect weights.
Before: some of those weights are \emph{negative}, which is precisely how a treatment that helps everyone can produce an overall estimate with the wrong sign.
After: the comparisons that use already-treated units as controls can subtract evolving treatment effects. In the decomposition into underlying treatment effects, some weights can be negative, which allows an overall estimate with the wrong sign.

## 44. 32_ch08.tex:117
Reason: Correct actual generating code without changing existing results.
Before: Each unit gets its own baseline level and each period a common shock, so that both fixed effects are real, and you add the dynamic effect only to treated unit-periods:
After: Each unit gets its own baseline level, and we add random disturbances and the dynamic effect to the unit-period observations. Although the variable is named \texttt{time\_fe}, its generating line draws a new value for every observation; it does not create a shock shared by all units in a period:

## 45. 32_ch08.tex:224
Reason: Correct causal license.
Before: That flat left half is the license to interpret the right half causally.
After: Those estimates are compatible with parallel pre-treatment trends, but their uncertainty and the program context still matter for the causal interpretation.

## 46. 32_ch08.tex:224
Reason: No proving assumption.
Before: which is the visual form of the parallel-trends\index{parallel trends} assumption holding.
After: which is consistent with parallel pre-treatment trends\index{parallel trends} in this simulation.

## 47. 32_ch08.tex:229
Reason: Correct caption.
Before: Read the flat left half first: it is the license to read the right half causally.
After: Read the pre-treatment estimates and their intervals first; similarity before treatment supports, but cannot establish, the counterfactual assumption needed afterward.

## 48. 32_ch08.tex:see diff
Reason: Weakspot: novice gvar construction and absorbing treatment.
Before: No preparation guidance before dripw
After: Added cohort-versus-treated paragraph

## 49. 32_ch08.tex:354
Reason: Remove banned idiom and qualify simulation.
Before: the program pays for itself across most plausible draws
After: discounted benefits exceed costs across most simulated draws

## 50. 32_ch08.tex:407
Reason: Remove banned idiom.
Before: the program pays for itself across nearly all plausible draws
After: discounted benefits exceed costs across nearly all draws under these assumptions

## 51. 32_ch08.tex:394
Reason: Correct false identical assumptions.
Before: Feed it the same effect, cost, discount, and horizon assumptions the hand-coded loop used:
After: Use the same effect, discount, and horizon settings, but note the change in cost distribution: the command below draws costs uniformly over the stated range, whereas the hand-coded loop uses a Normal distribution:

## 52. 32_ch08.tex:319
Reason: Weakspot: distinguish ROI and benefit-cost ratio.
Before: The naive ROI is a single ratio of discounted benefits to costs.
After: Here ROI is net discounted benefits divided by costs; the benefit-cost ratio instead divides gross benefits by costs.

## 53. 41_ch09.tex:5
Reason: Remove long marketing preview; correct all-examples nlsw claim.
Before: In this chapter we treat a graphic as an argument, not a decoration, and we take up the handful of choices that decide whether the argument reaches the reader: what to strip away, how to show distributions and categories so they read at a glance, how to draw coefficients instead of tabling them, how to put a story line on a trend, and how to write the finding into the caption so it stands on its own. Every figure in the chapter is built from data you already have (\texttt{sysuse nlsw88}) by one short do-file, \texttt{ch09\_graphs.do}, so each exhibit reruns and each is something you can adapt to your own outcome by editing one line. By the end you will be able to strip a default chart down to its data, draw a ranked category comparison that shows its own confidence intervals, put several models' estimates on one shared zero line, mark a go-live date on a trend, and write a caption that states the finding for a reader who never studies the plot. Aim every choice at a busy program officer who will give the graph a few seconds; if she gets the finding in that window, you have made your evidence accessible to the reader who acts on it, and refreshing that figure for next quarter's board takes a rerun rather than a rebuild.
After: In this chapter we revise category charts, draw regression estimates with their intervals, and annotate a trend at the date of a program change. We also write captions and plan related figures together. The examples in \texttt{ch09\_graphs.do} use the built-in \texttt{nlsw88} data and a simulated time series, so you can adapt the code while checking how each design choice affects what the reader can compare.

## 54. 41_ch09.tex:46
Reason: Qualify identity.
Before: The observed and fitted values correlate at exactly $R$,
After: For an ordinary least-squares regression with an intercept, evaluated on its estimation sample, the observed and fitted values correlate at $R$,

## 55. 41_ch09.tex:202
Reason: Correct causal inference from interval.
Before: A reader who would have skimmed past three regression tables sees in one glance that the union premium is real in pay and in hours, and that the experience gap, wider intervals and all, mostly reflects who joins unions rather than an effect of joining.
After: These regressions describe adjusted associations. Their intervals do not distinguish an effect of union membership from differences in who joins a union; that distinction requires the design reasoning in Chapter~\ref{ch:claims}.

## 56. 41_ch09.tex:207
Reason: Correct caption.
Before: so read that gap as selection into unions rather than an effect of them.
After: all three estimates are adjusted associations, and these regressions cannot separate selection into unions from a causal effect of membership.

## 57. 41_ch09.tex:212
Reason: Weakspot: units and common-scale misuse.
Before: One coefficient plot per outcome or subgroup, arranged on a common horizontal scale, with a reference line at zero. Keep the scale shared and the comparison stays immediate and fair: a reader sees which impacts are large and which cross zero without turning a page.
After: Draw estimates with a reference line at zero and label each outcome's units. Use a common horizontal scale when estimates have comparable units. Wage dollars, weekly hours, and years of experience differ in scale, so their numerical distances from zero do not measure relative substantive importance. Use separate labeled panels or an explicitly defined standardization when readers need to compare magnitudes across outcomes.

## 58. 41_ch09.tex:202
Reason: Weakspot: difference in significance versus significant difference, concrete reader decision.
Before: The callout below states the reusable pattern in one place, so you can rebuild the same exhibit for any set of outcomes or subgroups.
After: The callout below states the reusable pattern in one place, so you can rebuild the same exhibit for any set of outcomes or subgroups. When comparing subgroups, an interval that crosses zero in one group and excludes it in another does not establish that the groups differ. Estimate that difference directly, for example through the relevant interaction in a combined regression, and report its interval. This matters when a board is deciding whether to target services: separate significance labels can suggest a difference that the data do not resolve.

## 59. 41_ch09.tex:172
Reason: Correct N=1 visual interpretation.
Before: the single-observation farmers category collapses to a bare tick at the mean, so the eye sees at once which positions have real support.
After: the single-observation farmers category has no estimable within-category sampling variance. A bare tick there should be read as an unavailable interval, not as a precise estimate.

## 60. 41_ch09.tex:276
Reason: Remove unsupported causal recommendation.
Before: \enquote{Average days to placement fell four days after the new intake process; the change is worth keeping} passes;
After: \enquote{Average days to placement fell after the new intake process; the team can investigate whether other changes contributed before extending it} connects the finding to a decision;

## 61. 42_ch10.tex:5
Reason: Remove long enumeration and repeated marketing claims.
Before: We cover sparklines for scanning a large portfolio, a single command that emits fourteen interactive chart types, the judgment of when interactivity actually helps versus when it just adds motion, and the accessibility and maintenance checks that decide whether a page still works six months after you ship it. When you have worked through it, you will be able to build, straight from a do-file, a stripped-axis spark wall of every site in your portfolio, an interactive state map, a searchable table a client filters to their own row, and an animated bubble for the story that really is a trajectory, and to hand the build over with a refresh note that names who reruns it and when. The through-line is that infographic-quality output should come from a do-file, so the graphic is as replicable and as easily updated as any other output in the book, and so next quarter's board meeting gets the same map from a rerun instead of from you rebuilding it by hand.\marginnote{A quiet failure mode: an interactive chart that loads its plotting library from a live CDN (a content-delivery network, an outside server that hosts shared code) looks fine on your machine and blanks out on the client's, where the firewall blocks the outside request. Prefer libraries you can vendor locally.}
After: In this chapter we build small panels for comparing trends, an interactive state map, a searchable table, and an animated chart. We then test whether the intended readers can use the pages and document how to refresh them. You will learn to choose a form that fits the reader's task and preserve the source data, code, and dated output needed to reproduce a release.\marginnote{Some chart pages fetch a plotting library from an outside server when opened. Test the page on the client's network before delivery, because a blocked request can prevent the chart from appearing.}

## 62. 42_ch10.tex:8
Reason: Remove negate/assert rhetoric.
Before: They are not seven unrelated tricks.
After: The packages cover different stages of the work.

## 63. 42_ch10.tex:275
Reason: Remove overenumeration.
Before: The remaining ten types (column, line, area, combo, pie, donut, scatter, timeline, histogram, and the rest)
After: The other chart types

## 64. 42_ch10.tex:216
Reason: Weakspot: simulated animation is not empirical trend; concrete adaptation and label.
Before: Ask of any animation whether the story is the trajectory itself; here it is, states climbing together up the poverty-mortality diagonal over a decade, so the motion conveys information that no single frame contains.\marginnote[7mm]{One caveat about this panel: only 2024 and 2025 are real CHR releases; the earlier years are simulated to give the Play control frames to move through, which the chart's note says out loud.} When you build your own, feed \texttt{time()} a real panel and the animation is worth the motion; feed it filler and you have decoration. A second question worth settling before the build: who will press Play, and where? A walked-through talk has someone to press it; an emailed page usually does not, and for that audience the final frame exported as a static scatter shows the same finding without asking anyone to wait.
After: Use this animation to learn the controls, rather than to draw a conclusion about a decade of state trends. Only the 2024 and 2025 observations come from CHR releases; the earlier years were simulated to demonstrate movement through time. Keep that limitation in the visible chart note and any exported image. When adapting the example, replace the simulated rows with comparable observed releases and check whether changes in variable definitions or reference periods could create apparent movement. A static pair of observed years may be more informative when readers need a comparison rather than a demonstration of the Play control.

## 65. 42_ch10.tex:212
Reason: Correct caption clearly.
Before: The upward drift, poorer-child states have higher premature death, is the trajectory that justifies the motion.
After: Only 2024 and 2025 use observed CHR releases; earlier frames are simulated for the demonstration and do not document a historical trajectory.

## 66. 42_ch10.tex:382
Reason: Correct contradictory contrast threshold.
Before: Checking the labels and legend against the 3:1 floor
After: Checking normal-size text labels against 4.5:1 and essential graphical marks against 3:1

## 67. 42_ch10.tex:386
Reason: Correct repeated contrast threshold.
Before: check the labels and legend against the 3:1 floor
After: check normal-size text against 4.5:1 and essential graphical marks against 3:1

## 68. 42_ch10.tex:415
Reason: Correct exercise threshold.
Before: check the axis labels and legend against the 3:1 contrast floor
After: check normal-size axis and legend text against 4.5:1 and essential graphical marks against 3:1

## 69. 42_ch10.tex:391
Reason: Remove false permanent preservation guarantee.
Before: so the page cannot rot even though it also cannot update itself.
After: which removes that external dependency; browser changes and defects in the bundled code can still affect the page.

## 70. 42_ch10.tex:403
Reason: Weakspot: applied exercise falsely promised county geo from state-only tool and outputs that dofile does not build.
Before: \textbf{The build.} From the single \texttt{ch10\_smallmult.do} panel, ship three forms of the same numbers. For the brief, the static spark wall of Figure~\ref{fig:sparkwall}, which needs nothing to render and cannot break. For the portal, the \texttt{googlechart type(geo)} choropleth and \texttt{type(table)} search of Section~\ref{sec:gc-geo}, or their offline \texttt{sparkta2} equivalents if the agency firewall blocks the CDN. For the talk, the animated \texttt{type(bubble)} of Section~\ref{sec:gc-bubble}, used only because the trajectory is the point. Each deliverable is written by the same do-file from the same panel, so all three rebuild when next quarter's QCEW file posts, and Chapter~\ref{ch:portals} shows how \texttt{webdoc2} wraps the portal pieces into one shippable page. That is replicable (one do-file, three outputs), extensible (add a county, all three grow), accessible (each audience gets the form it can use), and actionable (the board plans in the counties and dollars every version reports).
\end{appliedexample}
After: \textbf{The build.} For the county brief, use the static spark wall built by \texttt{ch10\_smallmult.do}. An interactive table could present the same county-quarter values, provided you adapt the table example's columns and labels to those data. The \texttt{googlechart} geographic example in this chapter uses a different, state-level CHR file and cannot produce a county map from the QCEW panel. For a county map, use an available mapping tool with county boundaries or deliver a static map; \texttt{sparkta2} remains a proposed option until its source is released. Keep the state animation as a separate teaching demonstration because its earlier frames are simulated. Document the source and build command for each deliverable so that a colleague can refresh the intended dataset.

## Verification and remaining issues
Read revised prose and checked source-code alignment for transition cutpoints and the time_fe simulation. No TeX assembly or compile run (parent owns build). New mathematical quantile definition requires parent factual QA against conformal implementation. Existing chapter 8 subgroup code uses r(N) after regression; parent notified. Chapter 6 database guidance remains overly categorical and its salary estimates unsupported; parent should review scope. Preserve concrete examples, direct reader address and author technical vocabulary that already teach well.

### Follow-up 24_ch06
Reason: Remove remainder of replaced margin note, restore brace balance.
Before: .}, Stata's multiple-imputation machinery, which fits the model on every imputed copy and pools the results, never by filling in a single \enquote{best guess} that hides the uncertainty you just admitted to.}
After: .}

### Follow-up 24_ch06
Reason: Replace pedigree marketing with explanation.
Before: \subsection{Why the method holds up: a four-decade pedigree}
After: \subsection{How agreement patterns become match weights}

### Follow-up 24_ch06
Reason: Remove negate/assert lead.
Before: None of this machinery is improvised. The clean-block-score-threshold pattern
After: The clean-block-score-threshold pattern

### Follow-up 24_ch06
Reason: Replace command personification with clear mechanism.
Before: The \texttt{lower} option is the whole reason to reach for the command rather than a rounded merge: it refuses to attach a payment to a spell that started after the money moved, which a nearest-in-either-direction match would happily do.
After: With \texttt{lower}, you restrict candidate spells to those beginning on or before the payment date. Without a directional restriction, the closest date could be a later spell.

### Follow-up 24_ch06
Reason: Remove emotive framing.
Before: \section{Schema drift and the polluted year}
After: \section{Checking changes in extract structure and comparability}

### Follow-up 24_ch06
Reason: Remove negation contrast.
Before: We build the pipeline to refuse bad data loudly rather than average over it quietly.
After: We check each extract before adding it to the analysis, because a changed field can alter a result even when the do-file still runs.

### Follow-up 24_ch06
Reason: Reduce staccato enumeration while preserving output.
Before: The receipt is the point. Two rows changed, eight were already current, and nothing was overwritten silently;
After: The report distinguishes changed tags from those already current;

### Follow-up 24_ch06
Reason: Remove negation pattern.
Before: Notice what did not happen. The industry file never lost its level:
After: After linking, the industry file retains its original level:

### Follow-up 24_ch06
Reason: Clarify refresh needs summary recomputation.
Before: The women's file never gained rows. And when next quarter's extract arrives, the same two lines rebuild the comparison.
After: The women's file also retains its row count. Rebuild the industry summary and link it again when a new extract arrives.

### Follow-up 24_ch06
Reason: Remove categorical database claims and unsupported salary fraction.
Before: The case for staying in code is not sentiment. \textcite{long2009workflow} built the workflow this book extends on one idea, that every step from raw file to result is recorded in an auditable chain of do-files, and a database strains that idea at its strongest point: a database stores the current answer, while the do-file chain stores the reasoning, the commented line where you can see which source wins and why. Changing a definition mid-project, which research does weekly, is one line and a rerun in code; in a database it is a structure edit, a reload, and a conversation with whoever owns the dashboard. The costs also run one way. Storage is the cheapest thing in the shop and analyst time the most expensive, the license is the smallest line in a database budget, and the biggest line is the quarter-to-half of a salary for the person who keeps it running, a job that in a small shop otherwise falls, unfunded, to whoever was most enthusiastic in the meeting. The one discipline all of this depends on costs nothing and is already this book's rule: code makes data; people do not edit data.
After: For a small team, a documented chain of do-files may be enough to manage the analysis. \textcite{long2009workflow} emphasizes recording the steps from raw files to results so that an analyst can repeat and inspect them. A database can support the same principle when its loading and transformation queries are versioned. Compare the alternatives using the work your team actually performs: the size of joins, how often files arrive, who needs simultaneous access, and who will maintain the system. Include staff time in the cost estimate and retain a reproducible record of cleaning decisions whichever storage system you choose.

### Follow-up 24_ch06
Reason: Remove false hard limits and overenumeration.
Before: To hold that position credibly we have to be honest about the other side, where three limits are real walls. Stata works in memory, so when the largest file you routinely open stops fitting with room to merge, the work does not slow down, it stops. A person-triggered rebuild falls quietly behind data that arrive daily. And no amount of do-file discipline produces a log of which person read which rows, so a data-use agreement that demands one has made the decision for you.
After: A database becomes worth investigating when routine files exceed available memory, several users need controlled access at the same time, or a data-use agreement requires detailed access logs. Frequent data arrivals may instead be manageable with a scheduled do-file. Diagnose the constraint before choosing the system: a slow manual refresh and a need for row-level access controls are different problems.

### Follow-up 24_ch06
Reason: Replace arbitrary prohibitions with reproducible alternative.
Before: Table~\ref{tab:ch06-dbdecision} turns the choice into two groups of questions rather than a score, because the factors are not interchangeable: the first group are limits code cannot get around, the second are conditions that must all hold before buying helps. If you do buy, keep the build code as the source of truth and load \emph{cleaned} data into the database, never move the cleaning decisions into it; and never query it live from an analysis do-file. Have the database write files on a schedule and Stata read files, which keeps do-files portable and takes the fragile driver, the per-machine ODBC setup, and the single-sign-on dance off the critical path.\marginnote[-6mm]{A middle path worth knowing: DuckDB runs SQL over plain files with no server, no license, and nothing to administer, and handles joins bigger than memory. The robust arrangement is the same either way: let it write files and let every tool read files, rather than wiring tools to it live.}
After: Use Table~\ref{tab:ch06-dbdecision} to discuss requirements with the team responsible for maintaining the data. A dated extract gives an analysis a stable input even when the database changes, and it can spare collaborators a separate connection setup. If you query a database directly, record the query and preserve the result used for the analysis so that another analyst can reproduce the reported numbers.

### Follow-up 24_ch06
Reason: Remove hard decision algorithm in caption.
Before: \caption[The database decision in seven questions]{The database decision in seven questions, reached only after Figure~\ref{fig:ch06-combine} has ruled out appending, merging, and frames. Any \enquote{yes} in the first group is a limit code cannot get around; only then do the second group's conditions matter, and every one must hold or the purchase makes things worse. No yes in the first group means the decision is finished: stay in code.}
\label{tab:ch06-dbdecision}
\begin{tabular}{@{}p{9.8cm}p{4.2cm}@{}}
\hline
\multicolumn{2}{@{}p{14.2cm}@{}}{\emph{Limits code cannot get around: any yes points to a database}} \\
\hline
Does your largest working file crowd half the machine's memory? & Yes: a real wall \\
Do data arrive faster than a person can rerun the build? & Yes: a real wall \\
Does an agreement require a log of who read which rows? & Yes: a real wall \\
\hline
\multicolumn{2}{@{}p{14.2cm}@{}}{\emph{Conditions that must all hold before buying helps}} \\
\hline
Is a quarter to half of a salary funded, permanently, to run it? & No: fix this first \\
Will researchers who know the variables still do the cleaning? & No: do not buy \\
Can a definition change land in days, not weeks? & No: do not buy \\
Can every tool read the output without a fragile driver? & No: write files instead \\
\hline
\end{tabular}
\end{table*}
After: \caption[Questions to ask before adopting a database]{Questions for the evaluation team and the people who would maintain a database. Use the answers to identify the actual constraint, compare alternatives, and budget implementation and continuing support.}

### Follow-up 24_ch06
Reason: Correct categorical table.
Before: Limits code cannot get around: any yes points to a database
After: Requirements to investigate before choosing storage

### Follow-up 24_ch06
Reason: Remove arbitrary half memory cutoff.
Before: Does your largest working file crowd half the machine's memory? & Yes: a real wall
After: Do routine joins exceed available memory? & Compare larger-memory and database options

### Follow-up 24_ch06
Reason: Correct schedulable process.
Before: Do data arrive faster than a person can rerun the build? & Yes: a real wall
After: Do data arrive faster than the manual refresh? & Consider a scheduled build

### Follow-up 24_ch06
Reason: Make access requirement actionable.
Before: Does an agreement require a log of who read which rows? & Yes: a real wall
After: Does an agreement require row-level access logs? & Consult the data steward on supported systems

### Follow-up 24_ch06
Reason: Remove categorical claim.
Before: Conditions that must all hold before buying helps
After: Implementation and maintenance questions

### Follow-up 24_ch06
Reason: Remove unsupported numeric estimate.
Before: Is a quarter to half of a salary funded, permanently, to run it? & No: fix this first
After: Is continuing technical support funded? & Estimate staff time and assign responsibility

### Follow-up 24_ch06
Reason: Concrete review.
Before: Will researchers who know the variables still do the cleaning? & No: do not buy
After: Will domain experts review the cleaning rules? & Document and review transformations

### Follow-up 24_ch06
Reason: Remove arbitrary deadline.
Before: Can a definition change land in days, not weeks? & No: do not buy
After: Can staff revise a definition and reproduce old results? & Version queries and retain dated extracts

### Follow-up 24_ch06
Reason: Remove prescription.
Before: Can every tool read the output without a fragile driver? & No: write files instead
After: Can collaborators read the output with their tools? & Test connections or supply dated files

### Follow-up 31_ch07
Reason: Remove arbitrary alpha permissions.
Before: Alpha is not a fixed target: it rises mechanically with the number of items, so a long scale can clear 0.80 on padding alone. The conventional floor is 0.70 for research and 0.80 for high-stakes decisions, but a value above 0.95 usually signals redundant items, not virtue.
After: Alpha depends on both the number of items and their covariance. Interpret it alongside the content of the questions and the intended use of the score; a high value can reflect repetitive items and cannot by itself establish validity.

### Follow-up 31_ch07
Reason: Correct coefficient versus proportion of signal.
Before: we built item~6 to contain only 15\% of the shared signal
After: we gave item~6 a latent-variable coefficient of 0.15, compared with 1 for the other items

### Follow-up 31_ch07
Reason: Weakspot: reliability meaning.
Before: A site pulled halfway to the grand mean has a raw rate that is exactly 50\% reliable.
After: When the fitted weight is 0.5, the adjusted estimate gives equal weight to the site rate and the prior mean. Reliability here names that model-based weight; it is not a probability that the site rate is correct.

### Follow-up 31_ch07
Reason: Remove normative arithmetic fairness claim.
Before: The beneficiaries here are the small sites themselves. A stabilized rate protects a five-person program from a statistical accident, and a dashboard that offers every site that protection is fair enough to publish.\marginnote{Shrinkage is fairness expressed as arithmetic: it gives every site, however small, the same protection from statistical accident.}
After: Shrinkage can reduce the influence of chance variation in small sites, but it also pulls genuinely unusual sites toward the common mean. Show the raw rate, adjusted rate, and uncertainty together, and investigate whether sites serve populations too different to justify a shared prior.

### Follow-up 31_ch07
Reason: Correct repeated visual guarantee.
Before: the model only proposes the center; the calibration residuals set the width, which is why a wrong model costs width, never coverage
After: the fitted predictor sets the center; calibration residuals set the width. Coverage requires exchangeable new cases and the adjusted quantile

### Follow-up 31_ch07
Reason: Remove caption enumeration.
Before: Three steps, three named products. The split spends half the data on measuring the model's errors; the quantile turns those errors into a half-width; every new prediction then uses the same $\pm Q$.
After: We fit the predictor on one subset and use absolute prediction errors in a separate calibration subset to choose $Q$. Each new prediction then uses the same $\pm Q$.

### Follow-up 31_ch07
Reason: Reconcile scorecard with corrected alpha, weighting, conformal and ICC claims without restating unrelated sample numbers.
Before: \textbf{The safeguards, in the order the calendar needs them.} At the pilot, run \texttt{alpha} with the \texttt{item} option on the six-item scale: the whole-scale 0.76 hides a dead item, and pruning it lifts reliability to 0.79, licensed for cohort comparisons and withheld from individual-level flags. Before quoting any population rate, declare the design with \texttt{svyset} and compare weighted against unweighted: in the NHANES~II demonstration that gap was 0.42 raw against 0.37 weighted, and only the weighted figure describes the people served. Before the ranking ships, stabilize the small sites with \texttt{rateshrink}: on the section's own draw, the seven-case site that posted zero completions moves to 0.160 with its reliability printed beside it, and any site below the agreed reliability floor stays out of the bottom-five list. And before the next study is priced, put the budget on the power curve: at $N=300$ the design sees a four-point gain at 93~percent power, a three-point gain at 74, and a two-point gain at only 41, so the proposal promises the effect the design can find and no more. Alongside those four, run the two newer checks: a conformal band ($\pm 5.77$ wage-dollars in this chapter's example) answers \enquote{where will the next case land} without trusting the model, and the ICC (0.089 here) says how much signal a site ranking contains. Each check writes one line into the scorecard's methods note, and each line is the answer to a question the skeptical program officer of this chapter's opening was always going to ask.
\end{appliedexample}
After: \textbf{Applying the checks.} At the pilot, inspect the survey items and their coding before deciding whether to revise the engagement score. Before making a population claim, identify the target population and sampling design, then compare the estimate with and without the supplied weights. For site comparisons, examine caseloads and adjusted rates together with their uncertainty; discuss which differences are useful enough to act on. During planning, calculate power for effects that would change the program decision and revisit the design if those effects are hard to detect. Prediction intervals can inform planning for individual cases when new cases resemble the calibration sample, while the ICC describes clustering rather than authorizing a ranking. Record what each check showed and the decision it informed in the scorecard's methods note.

### Follow-up 31_ch07
Reason: Remove repeated guarantees and list-like ending.
Before: \paragraph{Where this leaves you.} Your scales measure one thing, with the dead-weight item pruned; your sample stands in for its population rather than for itself; your small-site rates no longer let one unlucky family sink a ranking; and your studies are sized on the whiteboard rather than in the final report. Applied Example~\ref{ae:ch07-scorecard} collects the chapter's numbers in one place.\marginnote{One distinction matters for the next chapter: a confidence interval brackets the \emph{average} effect, a prediction interval brackets where the \emph{next} site or person will land. The second is always wider, and a program director planning for one clinic wants the prediction interval, not the confidence interval you will be tempted to quote.} You can now also quote a prediction interval whose coverage does not depend on the model being right, and say how much of an outcome's variation sites can even explain before you rank sites at all. Because you ran the four checks against the planning calendar rather than the reporting deadline, there was time to repair each failure instead of footnoting it. Those four safeguards make the numbers trustworthy enough to compare, and in Chapter~\ref{ch:claims} we do the comparing, turning trustworthy numbers into defensible claims.
After: \paragraph{Where this leaves you.} You can now examine how a score was constructed, check the design behind a weighted estimate, and report small-site rates with appropriate uncertainty. Power calculations help you plan the study before enrollment, while prediction intervals and variance components address different questions about individual outcomes and clustering. These checks document the limits of the numbers you will compare in Chapter~\ref{ch:claims}; none removes the need to match the eventual claim to the study design.

### Follow-up 32_ch08
Reason: Remove nested numbered prose.
Before: First, treat the mediator as an outcome in its own right:
After: You can begin by treating the mediator as an outcome in its own right:

### Follow-up 32_ch08
Reason: Remove numbered prose.
Before: Second, if the client needs the formal decomposition,
After: If the client needs the formal decomposition,

### Follow-up 32_ch08
Reason: Remove enumeration.
Before: Two honest moves fit in an evaluation report.
After: The reporting choice depends on the question the evidence can support.

### Follow-up 41_ch09
Reason: Avoid comparative uncertainty across unlike units.
Before: the experience interval reaches back almost to it, so that difference is the shakiest of the three.
After: the experience interval approaches zero. Compare each interval in its own outcome units before deciding whether the corresponding association matters for the program.

Final follow-up: parent confirmed code/ch08_subgroups.do has a count after regress, so r(N) is valid in that file; initial flag closed. Database section revised to remove unsupported salary and memory cutoffs. No new code added.


## Final checks
All five chapter sources have matching brace and environment counts. All verbatim examples are identical to the frozen source baseline. Added narrative, revised captions and table guidance; added no executable examples. Parent owns compilation and numeric control runs. Removed remaining static-output immunity claim, corrected color-vision caption terminology and contrast-formula explanation.

Primary-source checks retrieved 2026-09-05: Stata mi impute/mi estimate distinction https://www.stata.com/features/overview/multiple-imputation/ and https://www.stata.com/support/faqs/statistics/clustering-and-mi-impute/ ; adjusted conformal quantile and exchangeability https://people.eecs.berkeley.edu/~angelopoulos/publications/downloads/gentle_intro_conformal_dfuq.pdf ; text contrast https://www.w3.org/WAI/WCAG21/Understanding/contrast-minimum . Existing references retained.

Novice improvements exceed 10 across these chapters: transition timing and denominator; missingness mechanisms; imputation workflow; alpha/validity troubleshooting; relative weight diagnostics; conformal calibration versus independent evaluation; ICC versus ranking precision; cohort-versus-treatment coding; ROI versus benefit-cost ratio; coefficient units; comparison of subgroup significance; simulation versus observed animation; county-versus-state tool boundaries; database requirements versus arbitrary cutoffs.
