# projectbuilder

Scaffold a data-analysis project folder in Stata with one command: a
five-folder layout, a control file that holds every path in one place, a
numbered do-file pipeline, and a README stamped with the project's
metadata.

Companion package to *Applied Program Evaluation Using Stata* (Booth &
Teas); the scaffold is the project layout the book uses throughout. The
design grew out of the authors' production scaffolding tool, generalized
here so it runs anywhere: no organization-specific paths and no template
folders required.

## Install

From GitHub:

```stata
net install projectbuilder, from("https://raw.githubusercontent.com/ericabooth/projectbuilder-stata-public/main/") replace
```

From a local folder (a clone or download of this repository):

```stata
net install projectbuilder, from("/path/to/projectbuilder-stata-public/") replace
```

Requires Stata 16.0 or newer. No dependencies.

## Quick start

```stata
cd "~/projects"
projectbuilder LaborDept/UnempClaims,                        ///
    description("Monthly county unemployment claims")       ///
    url("https://example.gov/data/claims.csv")               ///
    outcomes(claims_rate claims_n) over(county year)         ///
    descsave topic("labor markets") publicfacing(yes)        ///
    timeline(monthly)
```

This creates:

```
LaborDept/UnempClaims/
├── README.md          project name, date, author, metadata, this tree
├── raw/               untouched downloads (write-once; never edited)
├── clean/             analysis-ready .dta files
├── code/
│   ├── 00_control.do      every path in one place; run-all block
│   ├── 100_ingest.do      fetch raw source files into $raw
│   ├── 200_clean.do       raw -> analysis-ready .dta in $clean
│   ├── 300_analyze.do     clean -> tables in $output
│   ├── 400_visualize.do   graphs exported to $figures
│   └── 500_report.do      assemble the deliverable in $output
├── output/            logs and tables
└── figures/           exported graphs
```

`00_control.do` pins the Stata version, stamps `$root` with the absolute
path of the new folder (one loudly commented line to edit if the project
ever moves), derives `$raw`, `$clean`, `$code`, `$output`, and `$figures`
from it, and ends with a run-all block: flip `local run_all` to `1` and
the whole pipeline rebuilds in order.

The metadata options do double duty. Everything you pass is stamped into
the project README, and three options also seed the stubs: `url()` becomes
the download-target comment in `100_ingest.do`, `outcomes()` and `over()`
become suggested locals in `300_analyze.do`, and `descsave` adds a
commented codebook-export call (via `descsave` from SSC) to
`200_clean.do`.

## Design notes

- **Refuses to clobber.** If the target folder already exists,
  `projectbuilder` stops with error 602 and changes nothing.
- **Write-once raw.** The layout's one load-bearing distinction: raw
  files are downloaded and never edited, so a cleaning bug is always one
  rerun away from repair.
- **Numbered by hundreds.** The folder listing is the run order, and the
  gaps are on purpose: a new step slots in as `150_` without renaming
  the rest.
- **Self-contained and cross-OS.** Every scaffold file is written by the
  ado itself using Stata's `mkdir` and `file` commands; no template
  folder, no shell calls, same behavior on macOS, Windows, and Linux.
- **Stored results.** `r(path)` and `r(project)` let a calling do-file
  pick up where the scaffold left off.

## Syntax

```
projectbuilder Source[/Subsource] [, description(string) url(string)
    path(string) topic(string) publicfacing(yes|no|unsure)
    timeline(string) othernotes(string) outcomes(varlist) over(varlist)
    descsave]
```

`path()` sets the base directory (default: current working directory).
`Source/Subsource` nests the project one level under the base.
`outcomes()` and `over()` are capped at 10 items each, with a note when
trimmed. See `help projectbuilder` after installing for the full option
descriptions and three worked workflows (local files only; refreshing
with a new data vintage; source with a public URL).

## Testing

`test_projectbuilder.do` scaffolds into a temporary directory and checks
the full file tree, runs the generated control file, and exercises the
clobber refusal, nesting, metadata stamping, and name validation. Run it
from any scratch directory:

```
stata-mp -b do test_projectbuilder.do
```

## Authors

Eric A. Booth, Sr Researcher, Texas 2036

Support: eric.a.booth@gmail.com

## License

MIT. See [LICENSE](LICENSE).
