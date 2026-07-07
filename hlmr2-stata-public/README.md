# hlmr2

Nakagawa marginal and conditional R-squared after `mixed` in Stata.

`hlmr2` is a postestimation command for linear multilevel
(mixed-effects) models fit by `mixed`. It computes the two R-squared
statistics proposed by Nakagawa and Schielzeth (2013): the **marginal**
R-squared, the share of outcome variance explained by the fixed effects
alone, and the **conditional** R-squared, the share explained by the
fixed and random effects together. These give a single, comparable
answer to "how much does this model explain?" — a question `mixed`
itself does not answer, since it reports no R-squared.

The command builds the statistics from three pieces: the variance of
the fixed-portion linear predictor over the estimation sample, the sum
of the random-effect variance components, and the residual variance.
Variance components are read from `estat sd`, and `hlmr2` accepts both
the `sd()` and `var()` parameter labels that different Stata versions
produce, so the same do-file runs anywhere. Models with one or more
nested random-effects levels are supported (for example, students
within campuses within districts). All results are stored in `r()`, so
the statistics are easy to collect across many models in a loop.

In an intercept-only model the marginal R-squared is zero and the
conditional R-squared equals the intraclass correlation, which makes
the command easy to sanity-check against `estat icc`.

## Install

From GitHub (once the repository is public):

```stata
net install hlmr2, from("https://raw.githubusercontent.com/ericabooth/hlmr2-stata-public/main/") replace
```

From a local copy of this folder:

```stata
net install hlmr2, from("/path/to/hlmr2-stata-public/") replace
```

Requires Stata 16 or newer. No dependencies beyond official Stata.

## Quick start

```stata
sysuse nlsw88, clear
mixed wage grade age || industry:
hlmr2

* keep the numbers without the table
hlmr2, nodisplay
display "Marginal R2 = " r(r2_m) "  Conditional R2 = " r(r2_c)
```

## Options

| Option | What it does |
|---|---|
| `nodisplay` | suppress the printed table; results still stored in `r()` |
| `format(%fmt)` | display format for the table (default `%9.4f`) |
| `variance` | read the `var()`-labeled table from `estat sd, variance` instead of the `sd()` one; results are identical |

## Stored results

| Result | Contents |
|---|---|
| `r(r2_m)` | marginal R-squared (fixed effects only) |
| `r(r2_c)` | conditional R-squared (fixed + random effects) |
| `r(var_f)` | variance of the fixed-portion linear predictor |
| `r(var_ran)` | sum of the random-effect variance components |
| `r(var_e)` | residual variance |
| `r(N)` | observations in the estimation sample |
| `r(depvar)` | dependent variable name (macro) |

## Limitations (v0.1.0)

- Linear `mixed` models only; `melogit`, `mepoisson`, and other
  generalized linear mixed models are not supported.
- For random-slope models, `hlmr2` sums the variance components and
  ignores their covariances — an approximation of the exact formula
  (Johnson 2014). A note is printed when random slopes are detected.

## References

- Nakagawa, S., and H. Schielzeth. 2013. A general and simple method
  for obtaining R-squared from generalized linear mixed-effects models.
  *Methods in Ecology and Evolution* 4(2): 133-142.
- Johnson, P. C. D. 2014. Extension of Nakagawa & Schielzeth's
  R-squared(GLMM) to random slopes models. *Methods in Ecology and
  Evolution* 5(9): 944-946.

## License

MIT. See [LICENSE](LICENSE). Copyright (c) 2026 Eric A. Booth.

## Authors

Eric A. Booth, Sr Researcher, Texas 2036. Support: eric.a.booth@gmail.com
