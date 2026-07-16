# rateshrink

Empirical-Bayes shrinkage for noisy small-denominator rates in Stata.
Current version: 0.1.1.

Rates computed on tiny denominators are wild by construction. A single
failure at a five-person clinic can drop it to the bottom of a ranking that
decides its budget, even though the estimate carries almost no information.
`rateshrink` fixes this by pulling each unit's raw rate toward the overall
mean in proportion to how little data supports it: a site with 5 cases is
nudged hard toward the average, a site with 500 barely moves. The data
still speaks, but it stops shouting where it has nothing to say.

Two models are built in. The default, `type(ebbeta)`, is Beta-binomial
shrinkage for proportions (successes out of trials). `type(ebgamma)` is
Poisson-gamma shrinkage for event rates with exposure denominators
(events per person-year, per 1,000 residents, and so on), where the count
may exceed the denominator. In both cases the prior is estimated from the
data by the method of moments, each shrunken rate is the posterior mean (an
exact precision-weighted blend of the unit's raw rate and the grand mean),
and `ci(#)` adds equal-tailed posterior interval variables. With
`type(ebbeta)`, `rel(newvar)` also generates each unit's Beta-binomial
reliability, n/(n + alpha + beta), which is the weight the posterior mean
places on the unit's own data. After running, the command prints the estimated
prior and a one-line summary of the largest move and which unit moved
most.

Typical uses: stabilizing county or campus rates for public dashboards,
ranking program sites fairly when caseloads vary by two orders of
magnitude, and benchmarking clinics against a regional mean without letting
small-N noise drive the ordering.

## Install

From GitHub (once the repo is public):

```stata
net install rateshrink, from("https://raw.githubusercontent.com/ericabooth/rateshrink-stata-public/main/") replace force
help rateshrink
```

Requires Stata 16.0 or newer. No dependencies.

## Quick start

```stata
* 50 simulated sites, caseloads 5-500, completion rates near 0.20
clear
set seed 20260706
set obs 50
gen site  = _n
gen n     = 5 + int(495*runiform()^2)
gen ptrue = rbeta(8, 32)
gen y     = rbinomial(n, ptrue)

rateshrink, success(y) denominator(n) generate(pshrunk) ci(95) id(site)
return list
```

The output reports the estimated Beta prior, then a summary line such as
`largest move: site = 26, raw 0.0000 -> shrunken 0.1602`. Small
denominators with extreme raw rates move the most; large sites barely
change. For event rates against exposure, use
`type(ebgamma)`:

```stata
rateshrink, success(events) denominator(pyears) generate(rshrunk) type(ebgamma)
```

## Stored results

`rateshrink` is r-class:

| Result         | Meaning                                        |
| -------------- | ---------------------------------------------- |
| `r(N)`         | number of units used                           |
| `r(alpha)`     | estimated prior alpha                          |
| `r(beta)`      | estimated prior beta                           |
| `r(mean)`      | prior mean (the shrinkage target)              |
| `r(maxmove)`   | max \|raw - shrunken\| across units            |
| `r(meanrel)`   | mean Beta-binomial reliability (with `rel()`)  |
| `r(type)`      | shrinkage model used (`ebbeta` or `ebgamma`)   |
| `r(maxunit)`   | label of the unit that moved most              |
| `r(generate)`  | name of the generated variable                 |

## Notes and limits

The prior is estimated from the same data being shrunk, so with very few
units (under about 10) the prior itself is noisy. Weights and
covariate-adjusted (regression-based) shrinkage are not supported in this
version; for known structure, shrink within groups using `if`, or fit a
multilevel model. `rel()` is defined for the Beta-binomial model only;
combining it with `type(ebgamma)` exits with error 198.

## References

Field, S., Dong, F., Booth, E., Hastings, P., and Malone, P. (2026,
pre-print under review). "Rethinking 'Signal-To-Noise': A Coherent
Beta-Binomial Reliability Formulation for Assessing Quality Measures."
Far Harbor, LLC. Replication materials:
<https://github.com/ericabooth/BetaBinomialPaperMaterials>. The paper
shows that its CTT-coherent reliability statistic for a unit with
denominator n equals the empirical-Bayes shrinkage factor
n/(n + alpha + beta) under the Beta-binomial model (the quantity
`rel()` reports), and argues it is a more stable alternative to the
Adams (2009) signal-to-noise approach used in provider profiling.

## License

MIT. See [LICENSE](LICENSE). Copyright (c) 2026 Eric A. Booth.

## Authors

Eric A. Booth, Sr Researcher, Texas 2036 — support: eric.a.booth@gmail.com
