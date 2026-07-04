# Companion code — Applied Program Evaluation Using Stata

Every worked example in the book is a do-file here, and every one downloads only
public data (most with a single `import delimited` from a URL, no login). The
figures in the book are produced by these files.

## Setup (once)

1. Put this project folder anywhere on your machine.
2. Open `00_control.do` and edit the single `global root` line to point at the
   project folder. That is the only path you ever edit.
3. Run `01_install.do` once to fetch the community packages the book uses.

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
| `20_ch03_apis.do` | 3 | Downloads BLS QCEW county wages (no key) and builds the wage-comparison figure. |

More chapter do-files are added as the manuscript is drafted. Numbering leaves
gaps (10, 20, 30, ...) so new steps slot in without renaming the rest.

## Data note

No data is committed to this repository. Everything downloads at run time from
public sources. Two sources (Census ACS via `getcensus`, FRED via `import fred`)
need a free API key; setup is in Appendix A of the book.
