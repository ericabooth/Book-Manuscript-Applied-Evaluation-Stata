# riskscan

A k-anonymity re-identification scan for Stata. `riskscan` measures how
exposed a de-identified dataset still is: it groups records by every
distinct combination of the quasi-identifiers you name (race, marital
status, industry, and the like), computes how many people share each
combination (the cell size *k*), and reports the distinct cells, the
records that are unique (*k* = 1), the records below a chosen threshold
(default *k* < 5), and a cell-size distribution binned as 1, 2-4, 5-10,
and >10. Missing values count as a level, because a group of records
missing on one column is still a findable cell.

Removing names and ID numbers is not de-identification. A record that is
unique on four ordinary columns is still findable by anyone who knows
those four facts, and combinations of ordinary columns single people out
far more often than intuition suggests. `riskscan` turns "is this file
safe to share?" from an argument into a measurement: a data steward,
an evaluator, and a lawyer can all read the same numbers before a file
goes out the door. With `sensitive()` it adds an l-diversity check,
counting cells where every member shares one value of a sensitive
attribute, a leak that k-anonymity alone does not catch. With `flag()`
it marks the at-risk records so you can coarsen or suppress them, and
its returned scalars let a do-file decide programmatically whether a
release passes.

The command reads only the data in memory, makes no network requests,
has no dependencies beyond Stata 16, and adds no variables unless you
ask for a flag.

## Install

From GitHub:

```stata
net install riskscan, from("https://raw.githubusercontent.com/ericabooth/riskscan-stata-public/main/") replace
```

From a local folder (a clone or download of this repository):

```stata
net install riskscan, from("/path/to/riskscan-stata-public/") replace
```

## Quick start

```stata
sysuse nlsw88, clear
riskscan race married collgrad industry
* 103 distinct cells; 24 people unique on four ordinary columns

riskscan race married collgrad industry, flag(risky) detail
tabulate industry if risky

riskscan race married collgrad industry, sensitive(union)
* r(l1_cells) = cells where every member shares one union status

if r(below) > 0 di as err "do not release: " r(below) " records below k=5"
```

## Syntax

```stata
riskscan varlist [if] [in] [, k(#) flag(newvar) sensitive(varname) detail]
```

- `k(#)` — threshold; records in cells smaller than `#` count as at risk (default 5)
- `flag(newvar)` — byte variable, 1 when the record's cell is below the threshold
- `sensitive(varname)` — l-diversity: distinct values of `varname` per cell; reports l=1 cells
- `detail` — list the smallest cells' quasi-identifier combinations (never sensitive values)

## Stored results

| Result | Meaning |
| --- | --- |
| `r(N)` | records scanned |
| `r(cells)` | distinct quasi-identifier cells |
| `r(k1)` | records unique on the quasi-identifiers (k = 1) |
| `r(below)` | records in cells smaller than the threshold |
| `r(kthreshold)` | the threshold used |
| `r(l1_cells)` | cells with a single sensitive value (only with `sensitive()`) |
| `r(varlist)` | the quasi-identifiers scanned (macro) |

## License

MIT. See [LICENSE](LICENSE).
