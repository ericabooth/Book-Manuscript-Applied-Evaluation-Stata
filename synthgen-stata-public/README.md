# synthgen

Generate a rank-preserving **synthetic stand-in dataset** in Stata. Collaborators can use the stand-in to develop code while the source file remains in its approved environment. Assess the generated file before release because it may reproduce source-row combinations.

```stata
sysuse nlsw88, clear
synthgen wage grade tenure age hours, frame(synth) seed(20260730)
frame synth: summarize
```

## What it does

- **Empirical margins, exactly.** Every synthetic value is a value observed in the source, drawn with the source's frequencies — minimums, maximums, and category codes are always respected, and value/variable labels travel with the file.
- **Rank correlations preserved.** A Gaussian copula correlates normal scores on the source's complete cases and maps the joint draw back through each variable's empirical quantiles, so Spearman correlations survive.
- **Missingness re-imposed** per variable (independently; documented limitation).
- **Loud refusals, no overrides.** String variables are refused (encode categories first); numeric variables whose nonmissing values are all distinct are refused as ID-shaped — synthetic identifiers are a re-identification hazard, not a feature.
- **A fidelity and match diagnostic** on every run: worst standardized mean gap, worst pairwise rank-correlation gap, and the count of generated rows that exactly match a source row. These statistics do not establish that the generated file is safe to release.

## Install

```stata
net install synthgen, from("https://raw.githubusercontent.com/ericabooth/synthgen-stata-public/main/") replace force
discard
which synthgen
help synthgen
```

## Requirements

Stata 16 or newer (frames). No Python or other external dependencies.

## Testing

`test_synthgen.do` is the package's battery (refusals, shape/range/label checks, utility tolerances, seed determinism, missing-share preservation, categorical snapping). Run it from the package folder:

```stata
do test_synthgen.do
```

## Authors

Eric A. Booth, Sr Researcher, Texas 2036 (eric.a.booth@gmail.com)
Elizabeth Teas, Sr Research Scientist, Far Harbor, LLC

Issues and PRs welcome.
