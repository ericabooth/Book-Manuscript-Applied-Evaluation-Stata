# projectbuilder

Scaffold a data-analysis project in Stata with one command: a raw-data
folder, an analytic-data folder, an output folder, a documentation folder,
and a numbered do-file pipeline. If the data already exists, `projectbuilder`
also copies it in, converts it, appends it into one analytic file, and writes
a documentation page. If the data comes later, scaffold now and rerun with
`rebuild` on every refresh.

Companion package to *Applied Program Evaluation Using Stata* (Booth & Teas).
It is a generalization of the author's production project-scaffolding tool,
rewritten so it runs anywhere: no organization-specific paths, no template
folders, no shell calls, same behavior on macOS, Windows, and Linux.

## Install

From GitHub:

```stata
net install projectbuilder, from("https://raw.githubusercontent.com/ericabooth/projectbuilder-stata-public/main/") replace force
help projectbuilder
```

Requires Stata 16.0 or newer. No hard dependencies.

## Quick start

**Workflow A — the data already exists.** Point `data()` at a folder of files
(and/or `url()` at a source address). `projectbuilder` copies the files into
`01_raw/`, converts them into `01_raw/_converted/`, appends them into
`02_cleaned/<project>_analytic.dta`, and builds the documentation:

```stata
cd "~/projects"
projectbuilder CountyBudgets,                                     ///
    data("~/Desktop/budget_drop")                                ///
    description("County budget CSVs, one row per dept per FY")   ///
    topic("local government, budgets") publicfacing(unsure)      ///
    timeline("annual") outcomes(total_budget) over(year dept) descsave
```

**Workflow B — data later.** Scaffold now with no `data()`/`url()`, drop files
into `01_raw/` when they arrive, then rebuild. Every refresh is another
`rebuild`; it never overwrites a do-file you have edited unless you add
`replace`:

```stata
projectbuilder VendorFeed, description("Monthly vendor extract")
* ... later, after dropping files into VendorFeed/01_raw/ ...
projectbuilder VendorFeed, rebuild
```

This creates:

```
VendorFeed/
├── 01_raw/                raw source files (write-once)
│   ├── _archive/
│   └── _converted/        one .dta per raw file (convertanything)
├── 02_cleaned/            <project>_analytic.dta lives here
│   └── _archive/
├── 03_output/             logs, tables, exhibits
│   └── _archive/
├── _code/
│   ├── 000_control.do         every path in one place; run-all block
│   ├── 100_data_download.do
│   ├── 200_data_management.do convertanything -> combineall
│   ├── 300_labels.do
│   ├── 400_data_profiler.do
│   ├── 500_aggregation.do
│   ├── 600_analysis.do
│   └── _archive/
├── _documentation/
│   ├── index.do           webdoc2 source
│   ├── _runall.do          renders website/index.html
│   ├── Readme.md
│   ├── website/index.html
│   └── _archive/
└── _archive/
```

`000_control.do` pins the Stata version, stamps `$root` with the absolute path
of the new folder (one loudly commented line to edit if the project moves),
derives `$raw`, `$converted`, `$cleaned`, `$output`, `$code`, and `$docs` from
it, and ends with a run-all block over the numbered pipeline.

## Optional dependencies

None are required. Each is detected with `capture which`; if it is missing,
the generated do-file still contains the call (a working example), the
automatic pass skips that step, and a one-line note names the install command.

| Package | What it adds | Install |
|---------|--------------|---------|
| `convertanything` | bulk-convert `01_raw/` to `.dta` in `01_raw/_converted/` | `net install convertanything, from("https://raw.githubusercontent.com/ericabooth/convertanything-stata-public/main/")` |
| `combineall` | append/merge the converted files into the analytic file | `net install combineall, from("https://raw.githubusercontent.com/ericabooth/combineall-stata-public/main/")` |
| `descsave` | Excel codebook from `300_labels.do` | `ssc install descsave` |
| `srctag` / `srcfind` | tag and search each variable's source lineage | author's GitHub |
| `webdoc2` | render a richer `index.html` | `ssc install webdoc`, then `net install webdoc2` (author's GitHub) |

When `webdoc2` is absent, `projectbuilder` writes a plain but complete
`index.html` and `Readme.md` directly, so the documentation always exists.

## Stored results

`projectbuilder` is `rclass` and stores:

- `r(project)` — project label (slashes become underscores)
- `r(path)` — absolute path of the project folder
- `r(nraw)` — number of files in `01_raw/`
- `r(nconverted)` — number of `.dta` files in `01_raw/_converted/`
- `r(rebuilt)` — `1` if this call refreshed an existing project, else `0`

## Testing

`test_projectbuilder.do` scaffolds into a temporary directory and checks both
workflows, the rebuild idempotence and edit-preservation guarantee, the clobber
refusal (602), name and option validation (198), nesting, and the generated
control file. Synthetic data only; nothing is committed. Run it from any
scratch directory:

```
stata-mp -b do test_projectbuilder.do
```

## Authors

Eric A. Booth, Sr Researcher, Texas 2036 (eric.a.booth@gmail.com)

Elizabeth Teas, Sr Research Scientist, Far Harbor, LLC (elizabeth@farharbor.com)

Support: eric.a.booth@gmail.com

## License

MIT. See [LICENSE](LICENSE).
