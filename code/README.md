# Companion code — Applied Program Evaluation Using Stata

Every worked example in the book is a do-file here, and every one downloads only
public data (most with a single `import delimited` from a URL, no login). The
figures in the book are produced by these files.

## Setup (once)

1. Put this project folder anywhere on your machine.
2. Open `00_control.do` and edit the single `global root` line to point at the
   project folder. That is the only path you ever edit.
3. Run `01_install.do` once to fetch the community packages the book uses,
   plus the authors' `webapi` package from
   [WebAPI-stata-public](https://github.com/ericabooth/WebAPI-stata-public).
   The other suite packages (`googlechart`, `googlesheets`, `statashiny`,
   `webdoc2`) sit in a commented block in the same file — uncomment the ones
   you want; each installs from its public GitHub repo with one `net` command.

## The twelve book packages

Twelve tools the book teaches were built alongside it, each in its own
`<name>-stata-public/` folder one level up from this one: `projectbuilder`
(scaffold a project, ingest data, rebuild docs on every refresh),
`combineall` (append/merge/convert a whole folder, with vintage-aware
harmonization), `cxchangelog` (cross-wave survey codebooks), `datadictionary`
(over-time codebook: per-wave stats, missingness, value-label diffs,
five-sheet Excel export), `undummy`
(recombine one-hot columns into one categorical), `rateshrink`
(empirical-Bayes rate stabilization), `conformalpred` (split-conformal
prediction intervals), `hlmr2` (Nakagawa multilevel R-squared), `twinmatch`
(Mahalanobis policy twins), `roisim` (Monte Carlo ROI with tornado export),
`suppress` (small-cell + complementary suppression), and `riskscan`
(k-anonymity scan).
Each folder holds the ado, a SMCL help file, a `test_<name>.do` battery that
runs on synthetic or shipped Stata data, and installation files. They publish
to the authors' GitHub with the book; until then, `01_install.do` shows how
to install them from the local folders.

`projectbuilder` composes the others: it calls `convertanything` to turn a
raw drop into `.dta`, then `combineall` to append those into the analytic
file, then writes a documentation site (prettier when `webdoc2` is present).
Each is optional and degrades gracefully if it is not installed.

## Running an example

Launch Stata in the project folder, then either:

- run `00_control.do` to load the paths, then run any chapter do-file, or
- open `00_control.do`, set `local run_all 1`, and run it to rebuild everything
  in order.

## Files

| File | Chapter | What it does |
|------|---------|--------------|
| `00_control.do` | 2 | Master control: sets all paths and preferences in one place; can run the whole pipeline in order. |
| `01_install.do` | 2 | One-time install of the packages the book uses. |
| `ch01_reach.do` | 1 | Simulated program enrollment vs. a rural-reach target; the one-page-answer bar figure. |
| `ch02_benchmark.do` | 2 | Expands `nlsw88` to ~2M rows; times `collapse` vs `gcollapse`, `egen` vs `gegen`. |
| `ch02_projectbuilder.do` | 2 | Scaffolds a project two ways with `projectbuilder`: data-on-disk (Method A) and scaffold-now/`rebuild`-on-refresh (Method B); chains `convertanything` -> `combineall` into the analytic file. Creates folders, so run it standalone. |
| `20_ch03_apis.do` | 3 | Downloads BLS QCEW county wages (no key); builds the wage-comparison figure. |
| `ch03_webapi.do` | 3 | JSON APIs in one line with `webapi` (jsonplaceholder, CDC); no key, stdlib Python. |
| `ch03_educationdata.do` | 3 | Urban Institute CCD enrollment (no key); Texas state-year enrollment trend. |
| `ch04_chr.do` | 4 | Downloads the County Health Rankings analytic CSV; cleans the label row; county scatter. |
| `ch05_monitoring.do` | 5 | Simulated survey response monitoring; control chart + alert list + Likert alpha. |
| `ch05_datadictionary.do` | 5 | The label round-trip across languages: `datadictionary, dofile()` writes a relabel do-file; export `nolabel` → edit elsewhere → re-import → `do` it back with a re-ingestion receipt; also the `dictionary()` infile read. |
| `ch06_longitudinal.do` | 6 | `nlswork` panel description; missingness map; wage-quartile transition matrix; fuzzy merge. |
| `ch07_trust.do` | 7 | Reliability alpha; NHANES II weighting; empirical-Bayes shrinkage; power curve. |
| `ch08_did.do` | 8 | Simulated staggered adoption; naive TWFE vs `csdid`; event study; ROI Monte Carlo. |
| `ch08_oaxaca.do` | 8 | Blinder-Oaxaca decomposition of the white-Black wage gap in `nlsw88` (no key); `oaxaca` + `coefplot`; explained vs unexplained with tripwires. |
| `ch09_graphs.do` | 9 | Before/after data-ink pair; coefficient small-multiples; annotated run chart. |
| `ch10_smallmult.do` | 10 | QCEW quarterly wage small-multiples ("spark wall") for six Texas counties. |
| `ch10_googlechart.do` | 10 | Six `googlechart` interactive HTML charts (geo, bar, scatter, animated bubble, searchable table, divbar) on CHR&R 2025 state data; no key, builds offline. |
| `ch11_tables.do` | 11 | Builds a real LaTeX earnings table the manuscript ingests via `\input`; putexcel. |
| `ch12_dashboardbuilder.do` | 12 | Two `dashboardbuilder` KPI dashboards (two-minute build; benchmark explorer with selector/refvalue) into `dashboards/`; self-contained HTML, no CDN; tripwires guard the (rawsum) reference row. |
| `ch12_portal.do` | 12 | Suite capstone: chains webapi/googlesheets → googlechart/statashiny → webdoc2 into one offline portal. |
| `ch11_googlesheets.do` | 11 | `googlesheets` workflow on CHR data (export, format, put matrix, native live charts); display-only (OAuth). |
| `ch13_backbone.do` | 13 | The Stata-as-backbone loop: an LLM-proposed step made trustworthy by `assert` tripwires and a batch log. |
| `ch13_parallel.do` | 13 | Parallel patterns: a 4-way bootstrap split across instances, and a fan-out QC harness (judge by log, not exit code). |
| `ch13_validation.do` | 13 | Simulated AI validation: kappa, multi-model consensus, four-fifths fairness check. |
| `ch14_kanon.do` | 14 | k-anonymity on `nlsw88` as an admin stand-in; coarsening; small-cell suppression. |
| `ch15_bench.do` | 15 | Mata vs loop vs vectorized timing benchmark. |

Numbering leaves gaps so new steps slot in without renaming the rest. Every
figure in the book is produced by one of these files.

## Data note

No data is committed to this repository. Everything downloads at run time from
public sources. Two sources (Census ACS via `getcensus`, FRED via `import fred`)
need a free API key; setup is in Appendix A of the book.
