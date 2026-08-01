# projectbuilder

Scaffold a data-analysis project in Stata with one command: a raw-data
folder, an analytic-data folder, an output folder, a documentation folder,
and a numbered do-file pipeline. If the data already exists, `projectbuilder`
also copies it in, converts it, appends it into one analytic file, and writes
a documentation page. If the data comes later, scaffold now and rerun with
`rebuild` on every refresh.

Companion package to *Applied Program Evaluation Using Stata* (Booth & Teas).
It runs anywhere: no organization-specific paths, no template folders, no shell
calls, and the same behavior on macOS, Windows, and Linux.

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
`01_raw/` and builds the documentation. The conversion into
`01_raw/_converted/` requires `convertanything`, and the append into
`02_cleaned/<project>_analytic.dta` requires `combineall`; neither is installed
by default, and the run prints the install command for whichever is missing.

```stata
cd "~/projects"
projectbuilder CountyBudgets,                                     ///
    data("~/Desktop/budget_drop")                                ///
    description("County budget CSVs, one row per dept per FY")   ///
    topic("local government, budgets") publicfacing(unsure)      ///
    timeline("annual") outcomes(total_budget) over(year dept) descsave
```

Check that `02_cleaned/CountyBudgets_analytic.dta` exists before running
`300_labels.do`, which opens it. If the optional companions were missing, the
file is not there yet and `300_labels.do` stops with `r(601)`.

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
│   ├── index.do             webdoc2 source
│   ├── _runall.do           renders website/index.html
│   ├── _project_meta.txt    recorded metadata, read back on rebuild
│   ├── Readme.md
│   ├── website/index.html
│   └── _archive/
└── _archive/
```

`000_control.do` pins the language version, stamps `$root` with the absolute
path of the new folder (one loudly commented line to edit if the project moves),
derives `$raw`, `$converted`, `$cleaned`, `$output`, `$code`, and `$docs` from
it, and ends with a run-all block over the numbered pipeline. The pin is
`version 16.0`, this package's own floor, not the release of the Stata that
generated the file, so the control file still runs for a teammate on an older
Stata. Raise it by hand if the project needs newer syntax.

## Recorded metadata

`description()`, `url()`, `topic()`, `publicfacing()`, `timeline()`,
`othernotes()`, `outcomes()`, `over()`, and the creation date are written to
`_documentation/_project_meta.txt` as `key=value` lines and read back on every
later call. A bare `rebuild` therefore keeps the metadata recorded at scaffold
time instead of resetting it to placeholders; an option given on the current
call replaces the recorded value. The `Created` row is the first-scaffold date
and is not restamped by a rebuild; the build date and time appear in the footer
of `index.html` and `Readme.md`.

`_documentation/index.do` is guarded like the numbered do-files, so a `rebuild`
without `replace` leaves it as written. Because it and the regenerated
`index.html` both come from the same recorded metadata, they agree after a
rebuild unless you edit one of them by hand.

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

## Your data in memory

`projectbuilder` leaves the dataset in memory exactly as it found it. The
automatic pass does load data — `convertanything` runs with `clear`, and
`combineall` does its own `use` and `save` — so the command wraps that pass in
`preserve`. Scaffolding or refreshing in the middle of an analysis session does
not cost you your data. `noautoconvert` skips the pass, and with it the
`preserve`.

## Testing

`test_projectbuilder.do` scaffolds into a temporary directory and checks both
workflows, the rebuild idempotence and edit-preservation guarantee, metadata
preservation across a rebuild, the seeded-`_converted/` combine path, the
clobber refusal (602), name and option validation (198), nesting, HTML escaping,
and the generated control file. It also runs every example printed in the help
file, and the clickable *Try it now* walkthrough, so the documentation cannot
drift from the code. Synthetic data only; nothing is committed.

The test finds the package itself: it uses the first of an argument, an
existing `$pkgroot`, the current directory, or `findfile projectbuilder.ado`.
Run it from the package folder with no arguments, or from any scratch directory
by naming the package folder:

```
stata-mp -b do test_projectbuilder.do
stata-mp -b do test_projectbuilder.do "/path/to/projectbuilder-stata-public"
```

## Changes in 2.0.1

- The dataset in memory is preserved across the automatic convert/combine pass.
  It used to be silently replaced by the converted file.
- The generated `400_data_profiler.do` runs under the `version 16.0` pin that
  `000_control.do` sets. It used to emit Stata 17 `table, statistic()` syntax
  and stop with r(198).
- `builddocs` renders. The generated `_runall.do` now carries a literal
  documentation path instead of `$docs`, which is undefined at the point
  `projectbuilder` runs that file.
- A backtick in any option value is refused up front, naming the option. It
  used to abort partway through and leave a half-built folder that blocked the
  corrected re-run with 602.
- A tilde in a value survives into the generated files. `url(".../~Dave/...")`
  used to be written out as `.../$ave/...`.
- A `$` or a backtick recorded in `_project_meta.txt` survives a rebuild.
- A relative `path()` is resolved, so `r(path)` and `$root` are absolute as
  documented.
- Failures are reported rather than swallowed: files `data()` could not copy, a
  base that exists but is not writable, and directories that cannot be listed.
- Directory tests use Mata's `direxists()` in place of `confirm file dir/.`.

First-run clarity, from watching new readers work through the help:

- The "Next steps" block no longer tells you to review an analytic file that was
  never created. Without the optional companions — the default state — it now
  says the file is missing and gives the two ways to get one.
- A `data()` folder that does not exist is reported as an error rather than a
  passing note, so an empty project no longer looks like a success.
- `rebuild` on a project that does not exist still scaffolds one, which is what
  makes it safe in a scheduled script, but it now says that is what it did. A
  mistyped name used to look like a successful refresh. `r(rebuilt)` is `1` only
  when an existing project was refreshed.
- The help gained a Quick start, and Workflow A now creates the folder its
  example reads from, so its first worked example runs as printed.
- The Options section documents the `des()` / `desc` abbreviation split and the
  fact that options changing a guarded do-file need `replace` to take effect.

What the command prints now matches the help around it:

- The `Rerun:` hint is copy-pasteable. It used to drop the `path()` you built
  with, so pasting it from another directory made a second empty project, and
  it printed a name with spaces unquoted, which the command itself rejects.
- The console said "Method B" where the help says Workflow B.
- `descsave` is recorded in `_project_meta.txt` like every other option. A bare
  rebuild used to report it as `no`, and `rebuild replace` deleted the codebook
  call it had written.
- A bare rebuild says when `outcomes()`/`over()`/`descsave` were recorded but
  `_code/` was left alone, and `replace` says when it overwrote your edits.
  Nothing is archived automatically; the `_archive/` folders are yours.
- `builddocs` runs the render quietly and reports one line either way. It used
  to echo the whole of `_runall.do` and end in a bare `r(601)` that read as a
  crash when it was caught.
- `publicfacing()` trims surrounding spaces; `othernotes()` is echoed in the
  summary like the other metadata; `description()` reaches the header of
  `000_control.do`, which the help had claimed all along.
- `Readme.md` gets Markdown escaping rather than HTML: `R&D` stayed `R&amp;D`
  in a file people read raw.
- Warnings when the converted count does not match the raw count — same-stem
  files overwriting each other, or stale output from a raw file since deleted.
- `path()` naming an existing file says so instead of "not found".

## Authors

Eric A. Booth, Sr Researcher, Texas 2036 (eric.a.booth@gmail.com)

Elizabeth Teas, Sr Research Scientist, Far Harbor, LLC (elizabeth@farharbor.com)

Support: eric.a.booth@gmail.com

## License

MIT. See [LICENSE](LICENSE).
