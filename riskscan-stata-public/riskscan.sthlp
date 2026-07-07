{smcl}
{* *! version 0.1.0  2026-07-06}{...}
{viewerjumpto "Syntax" "riskscan##syntax"}{...}
{viewerjumpto "Description" "riskscan##description"}{...}
{viewerjumpto "Options" "riskscan##options"}{...}
{viewerjumpto "Remarks" "riskscan##remarks"}{...}
{viewerjumpto "Examples" "riskscan##examples"}{...}
{viewerjumpto "Stored results" "riskscan##results"}{...}
{viewerjumpto "Author" "riskscan##author"}{...}

{title:Title}

{p2colset 5 17 19 2}{...}
{p2col :{cmd:riskscan} {hline 2}}k-anonymity re-identification scan over quasi-identifiers{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:riskscan} {varlist} {ifin} [{cmd:,} {it:options}]

{synoptset 22 tabbed}{...}
{synopthdr}
{synoptline}
{synopt :{opt k(#)}}re-identification threshold; records in cells smaller than {it:#} are counted as at risk (default {cmd:k(5)}){p_end}
{synopt :{opt fl:ag(newvar)}}generate byte {it:newvar} = 1 when the record's cell size is below the threshold, 0 otherwise{p_end}
{synopt :{opt sen:sitive(varname)}}also compute l-diversity: the number of distinct values of {it:varname} within each cell; reports cells with l=1{p_end}
{synopt :{opt det:ail}}list the highest-risk quasi-identifier combinations (smallest cells first); sensitive values are never listed{p_end}
{synoptline}
{p2colreset}{...}

{pstd}
{varlist} names the quasi-identifiers: the ordinary columns (race, marital
status, industry, ...) whose combination could single a person out.
Missing values count as a level, so a group of records missing on one
column is still a cell.


{marker description}{...}
{title:Description}

{pstd}
{cmd:riskscan} measures how exposed a de-identified dataset still is.
It groups the records by every distinct combination of the
quasi-identifiers in {varlist}, computes the cell size {it:k} for each
record (how many people share that exact combination), and reports the
number of distinct cells, the records that are unique ({it:k}=1), the
records below the {opt k()} threshold, and a distribution of cell sizes
binned as {it:k}=1, 2-4, 5-10, and >10.

{pstd}
A record with {it:k}=1 is unique on those columns: strip the name and the
person is still findable by anyone who knows those few facts.  The scan
turns "is this file safe to share?" from an argument into a measurement
that an evaluator and a lawyer can both read.

{pstd}
With {opt sensitive()}, {cmd:riskscan} adds an l-diversity check: within
each cell it counts the distinct values of the sensitive variable and
reports the cells where only one value occurs (l=1).  Such a cell leaks
the sensitive value to anyone who knows a person belongs to it, even when
the cell itself is large; k-anonymity alone does not catch this.

{pstd}
{cmd:riskscan} reads the data in memory and makes no network requests.
It adds no variables unless you ask for one with {opt flag()}.


{marker options}{...}
{title:Options}

{phang}{opt k(#)} sets the threshold below which a cell is considered
thin.  The default, {cmd:k(5)}, is a common data-use-agreement floor:
records in cells of fewer than five people are counted in {cmd:r(below)}
and, with {opt flag()}, flagged.  {it:#} must be a positive integer.{p_end}

{phang}{opt flag(newvar)} generates byte {it:newvar} equal to 1 when the
record's cell holds fewer than {opt k()} people and 0 otherwise (missing
outside the {opt if}/{opt in} sample).  {it:newvar} must not already
exist.  Use it to inspect, suppress, or coarsen the risky records
downstream.{p_end}

{phang}{opt sensitive(varname)} names the sensitive attribute (a
diagnosis, a benefit flag, a wage) and computes the number of distinct
values it takes inside each quasi-identifier cell.  Cells where every
member shares one value (l=1) are counted in {cmd:r(l1_cells)}.  Missing
counts as a value, consistent with the treatment of the
quasi-identifiers.  {it:varname} may not also appear in {varlist}.{p_end}

{phang}{opt detail} lists the quasi-identifier combinations of the cells
below the threshold, smallest first, one row per cell with its cell size,
capped at 30 rows.  The values of the {opt sensitive()} variable are
never printed, so the listing itself is safe to leave in a log.{p_end}


{marker remarks}{...}
{title:Remarks}

{pstd}
The scan implements the standard k-anonymity recipe: an
{helpb egen}{cmd:, group(}{it:varlist}{cmd:) missing} over the
quasi-identifiers followed by a {cmd:bysort} cell count, so its numbers
match a hand-rolled check line for line.  What it adds is the reporting
(the cell-size distribution, the unique-record count, the l-diversity
check) and the returned scalars, which make the scan usable inside a
do-file that decides programmatically whether a file may be released.

{pstd}
Two follow-up moves usually empty the {it:k}=1 bin: coarsen the
highest-cardinality column first (detailed industry or occupation codes,
single years of age, five-digit ZIP), then suppress the few singletons
that remain.  Re-run {cmd:riskscan} after each change; the point of the
returned scalars is to make that loop scriptable.


{marker examples}{...}
{title:Examples}

{pstd}Scan four ordinary columns of the 1988 wage survey{p_end}
{phang2}{cmd:. sysuse nlsw88, clear}{p_end}
{phang2}{cmd:. riskscan race married collgrad industry}{p_end}

{pstd}Flag the records in cells of fewer than 5, then inspect them{p_end}
{phang2}{cmd:. riskscan race married collgrad industry, flag(risky)}{p_end}
{phang2}{cmd:. tabulate industry if risky}{p_end}

{pstd}List the highest-risk combinations{p_end}
{phang2}{cmd:. riskscan race married collgrad industry, detail}{p_end}

{pstd}Check l-diversity of a sensitive attribute within each cell{p_end}
{phang2}{cmd:. riskscan race married collgrad industry, sensitive(union)}{p_end}

{pstd}Use the returned scalars to gate a release script{p_end}
{phang2}{cmd:. riskscan race married collgrad industry, k(5)}{p_end}
{phang2}{cmd:. if r(below) > 0 di as err "do not release: " r(below) " records below k=5"}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:riskscan} stores the following in {cmd:r()}:

{synoptset 18 tabbed}{...}
{p2col 5 18 22 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}records scanned{p_end}
{synopt:{cmd:r(cells)}}distinct quasi-identifier cells{p_end}
{synopt:{cmd:r(k1)}}records unique on the quasi-identifiers (k=1){p_end}
{synopt:{cmd:r(below)}}records in cells smaller than the threshold{p_end}
{synopt:{cmd:r(kthreshold)}}the threshold used{p_end}
{synopt:{cmd:r(l1_cells)}}cells with a single sensitive value (only with {opt sensitive()}){p_end}

{p2col 5 18 22 2: Macros}{p_end}
{synopt:{cmd:r(varlist)}}the quasi-identifiers scanned{p_end}
{p2colreset}{...}


{marker author}{...}
{title:Author}

{pstd}
Eric A. Booth, Sr Researcher, Texas 2036{break}
Support: {browse "mailto:eric.a.booth@gmail.com":eric.a.booth@gmail.com}

{pstd}
riskscan accompanies the k-anonymity and disclosure-control workflow
documented in the authors' applied-evaluation book; the scan formalizes
that chapter's worked pattern.
