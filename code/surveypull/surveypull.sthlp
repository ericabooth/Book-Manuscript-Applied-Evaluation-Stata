{smcl}
{* *! version 1.0.0  28jul2026}{...}
{title:Title}

{p2colset 5 19 21 2}{...}
{p2col :{cmd:surveypull} {hline 2}}Platform-aware survey downloads built on {helpb webapi}{p_end}
{p2colreset}{...}

{title:Syntax}

{p 8 16 2}{cmd:surveypull redcap ,} {opt url(string)} {opt tok:en(string)} [{opt con:tent(string)} {opt sav:ing(filename)} {cmd:dryrun} {cmd:replace}]

{p 8 16 2}{cmd:surveypull qualtrics ,} {opt data:center(id)} {opt tok:en(string)} {opt sur:vey(id)} [{cmd:dryrun}]

{title:Description}

{pstd}
Each survey platform speaks its own dialect of the same idea, and
{cmd:surveypull} owns that lore so a do-file does not have to.  For REDCap
it builds and (unless {cmd:dryrun}) executes the single tokened POST that
returns the records as CSV, through {helpb webapi}.  For Qualtrics, whose
export is a three-step request-poll-download dance ending in a zip Stata
cannot yet ingest directly, {cmd:surveypull} prints the three exact calls,
ready to run or to hand a shell script; this version is dry-run only for
Qualtrics and says so.

{pstd}
{cmd:dryrun} prints the call without sending anything, which is also the
safe way to check a token never ends up in a log you plan to share.

{title:Stored results}

{synoptset 14 tabbed}{...}
{p2col 5 14 18 2: Macros}{p_end}
{synopt:{cmd:r(cmd)}}the REDCap call built{p_end}
{synopt:{cmd:r(cmd1)}-{cmd:r(cmd3)}}the Qualtrics calls built{p_end}

{title:Author}

{pstd}Eric A. Booth.  Companion tool to {it:Applied Program Evaluation Using Stata}.
