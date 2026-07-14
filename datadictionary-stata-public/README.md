# datadictionary

Enhanced, over-time-ready codebook generator for Stata — a modern `descsave`.

A codebook answers "what is in this file?"; a longitudinal codebook has to
answer "what was in this file in each wave, and what changed?" `datadictionary`
does both. It writes one codebook row per variable — storage type, display
format, variable label, value-label name, N nonmissing, % missing, distinct
values, numeric summary statistics, example values (top categories with
frequencies for labeled variables), stored `notes`, and characteristics,
including the `srctag` char written by the author's
`combineall`/`projectbuilder` tools — to the screen, to a machine-readable
`.dta`, and to a multi-sheet Excel workbook.

The headline feature is files mode: point `datadictionary` at the original wave
files (`files()` or `folder()`), and it harvests per-wave metadata and
detects changes across waves — variables added or dropped, storage types,
variable labels, value-label sets (categories added, removed, or relabeled),
and display formats. This is only possible in files mode, because stitching
waves into one file destroys per-wave value labels: after `append` only one
definition per label name survives, so wave-specific category sets can no
longer be compared. Files mode exists for exactly this reason — run it over
the original wave files, before or alongside stitching, to keep that history.

In-memory mode documents the dataset in memory (optionally restricted by
`varlist`/`if`/`in`), and with `wave(varname)` adds a per-wave missingness
grid for a stitched file. A variable that is all-missing within a wave is
reported as `absent`, meaning *absent or never answered* — the two cannot be
distinguished in a stitched file. The caller's data are preserved and
restored untouched in both modes. There are no dependencies beyond
Stata 16.0.

## Install

From GitHub:

```stata
net install datadictionary, from("https://raw.githubusercontent.com/ericabooth/datadictionary-stata-public/main/") replace
```

Or from a local copy of this folder:

```stata
net install datadictionary, from("/path/to/datadictionary-stata-public/") replace
```

**Colon-path warning:** Stata's `net install` fails when the `from()` path
contains a colon (`:`), as some macOS folder names do. If this folder lives
under such a path, copy it to a colon-free location (for example
`/tmp/datadictionary-stata-public/`) and install from there — or use the GitHub
URL above.

## Quick start

```stata
* one dataset, full codebook to screen, .dta, and Excel
sysuse auto, clear
datadictionary, excel(auto_codebook) saving(auto_codebook) replace
return list

* three wave files: per-wave codebook + change detection
datadictionary, files("staff_w1.dta staff_w2.dta staff_w3.dta") ///
    wavenames("2019 2021 2023")                           ///
    excel(staff_codebook) saving(staff_codebook) replace

* the same, taking every matching file in a folder (sorted by filename)
datadictionary, folder("waves") pattern("staff_*.dta") excel(staff_codebook) replace

* a stitched long file: per-wave presence and missingness
datadictionary, wave(wave) excel(stitched_codebook) replace
```

The Excel workbook contains an `Overview` sheet (sources, N and variable
count per wave, generation date, notes count), a `Variables` sheet (the
codebook rows; with a `wave` column in files mode), a `ValueLabels` sheet
(label name, value, text; per wave in files mode), and — in files mode — a
`Changes` sheet (one row per detected change: wave-pair, variable, change
type, before, after) plus a `Missingness` sheet (variable × wave grid of
% missing; also written in in-memory `wave()` mode). Header rows are bold.

## Syntax

```
in-memory:  datadictionary [varlist] [if] [in] [, wave(varname) shared_options]

files mode: datadictionary, files("w1.dta w2.dta ...") [wavenames("n1 n2 ...") shared_options]
            datadictionary, folder(dirpath) [pattern(str) wavenames("n1 n2 ...") shared_options]

shared_options: excel(filename) saving(filename) replace
                examples(#) top(#) nochars nonotes
```

See `help datadictionary` for details on every option.

## Stored results

`datadictionary` stores the following in `r()`:

| Result        | Meaning                                                              |
| ------------- | -------------------------------------------------------------------- |
| `r(nvars)`    | number of codebook rows: variables documented (variable-waves in files mode) |
| `r(nchanges)` | number of changes detected across waves (0 outside files mode)        |
| `r(xlsx)`     | path of the Excel workbook written (only with `excel()`)              |
| `r(dta)`      | path of the codebook dataset written (only with `saving()`)           |

## Related work

- Roger Newson's `descsave` (SSC) exports variable-level attributes to a
  dataset or do-file; `datadictionary` adds over-time change detection, missingness
  patterns, example values, and the notes/chars/srctag harvest.
- Kishor Das's `codebookout` (SSC) writes a one-dataset codebook to Excel;
  `datadictionary` adds the multi-wave file comparison and the multi-sheet workbook
  (value labels, changes, missingness).
- Built-in `codebook` prints a rich per-variable report but stores no
  machine-readable product; `datadictionary` writes one (`saving()`) plus the Excel
  workbook, and tracks how the file changes across waves.

## Limitations in v1.0.0

- Change detection compares consecutive waves; a variable that skips a wave
  is counted as dropped and then added.
- Value-label text longer than 80 characters is truncated in the
  `ValueLabels` sheet and in the change-detection signatures (a `uselabel`
  limit); truncation is identical in every wave, so detection is unaffected.
- Example values and top categories are truncated to 2,000 characters per
  cell.

## License

MIT. See [LICENSE](LICENSE). Copyright (c) 2026 Eric A. Booth.

Support: eric.a.booth@gmail.com
