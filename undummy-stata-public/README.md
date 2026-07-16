# undummy

Recombine a set of dummy/indicator variables into one categorical variable
in Stata.

Agency extracts and survey platforms often deliver categorical information
as one-hot columns: `race_1`, `race_2`, ... in an administrative file, or
one 0/1 column per answer choice in a Qualtrics-style export. Analysis in
Stata usually wants the opposite shape, a single labeled categorical
variable that works with factor-variable notation, `tabulate`, and graphs.
`undummy` is the bridge back: it verifies that the dummies are mutually
exclusive, combines them into one variable with categories numbered 1, 2,
..., and attaches value labels taken from an existing label
(`valuelab()`), from the dummy variable names (`varnames`), or under a new
label name (`newvaluelab()`). It is the inverse of
`tabulate, generate()`.

Dummies may be numeric or string (values of `0`, `"0"`, `" "`, or `""`
count as off), and a mixed set is allowed with `ignoretype`. The
`checkdummies` option runs the mutual-exclusivity check alone, which is
useful for telling a true single-select set apart from a
check-all-that-apply block before committing to the transformation. By
default the original dummies are dropped; `keepdummies` keeps them.

## Install

From GitHub:

```stata
net install undummy, from("https://raw.githubusercontent.com/ericabooth/undummy-stata-public/main/") replace force
help undummy
```

Requires Stata 16.0 or later. No dependencies.

## Quick start

```stata
sysuse auto, clear
tabulate foreign, generate(fd)
undummy fd1 fd2, generate(origin) varnames
tabulate origin
```

`origin` now holds 1 for the `fd1` (Domestic) rows and 2 for the `fd2`
(Foreign) rows, labeled with the dummy names. `r(generate)` returns the
new variable's name and `r(k)` the number of categories.

Full syntax:

```stata
undummy varlist [if] [in] [, generate(newvar) valuelab(labelname)
    varnames newvaluelab(labelname) ignoretype keepdummies checkdummies]
```

## Notes

- `undummy` errors (return code 459) if any observation has more than one
  dummy switched on, since such a set cannot be one categorical variable.
  Use `checkdummies` to test a set without changing the data.
- Observations with no dummy switched on get their own unlabeled category
  rather than being set to missing; inspect with `tabulate, missing`.
- Category numbers follow the sort order of the dummy set: first-listed
  dummy is category 1 for numeric dummies, but the order reverses for
  string dummies (empty strings sort first). `varnames` labels each
  category by matching values, so it is correct under either ordering.
- Stored results: `r(k)` (number of categories), `r(generate)` (new
  variable name), `r(base)` (first dummy in the varlist).

## Test battery

`test_undummy.do` runs the full battery (round trip through
`tabulate, generate()`, string dummies, mixed types, overlap detection,
and error cases) using only `sysuse` and synthetic data. Edit the
`$pkgroot` global at the top, then run in batch and check the log for
`r(NNN);` errors or failed assertions.

## Author

Eric A. Booth, Sr Researcher, Texas 2036

Support: eric.a.booth@gmail.com

## License

MIT. See [LICENSE](LICENSE).
