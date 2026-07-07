# Ready-to-push repo additions

The `convertanything-stata-public` and `importR-stata` repos are missing the
`stata.toc` + `.pkg` files that make `net install` work (they currently 404
with r(601)). Drop the files in each subfolder here into the matching GitHub
repo root, and the `net install` lines the book prints will resolve.

Verified 2026-07-06: convertanything.ado converts a mixed CSV/xlsx/dta folder
tree cleanly; importR.ado loads and dispatches to the R or Python bridge.
