* test_surveypull.do -- behavioral contract for surveypull (dry-run architecture)
clear all
adopath ++ "`c(pwd)'"
set varabbrev off

* --- (1) redcap dry run returns the exact webapi call ------------------------
surveypull redcap, url(https://redcap.example.edu/api/) token(ABC123) dryrun
assert strpos(`"`r(cmd)'"', "webapi post using") == 1
assert strpos(`"`r(cmd)'"', "token=ABC123") > 0
assert strpos(`"`r(cmd)'"', "content=record") > 0
assert strpos(`"`r(cmd)'"', "format=csv") > 0

* --- (2) content and saving flow through -------------------------------------
surveypull redcap, url(https://x.org/api/) token(T) content(metadata) ///
    saving(out.csv) replace dryrun
assert strpos(`"`r(cmd)'"', "content=metadata") > 0
assert strpos(`"`r(cmd)'"', `"saving("out.csv", replace)"') > 0

* --- (3) qualtrics prints all three calls, sends nothing ---------------------
surveypull qualtrics, datacenter(ca1) token(TOK) survey(SV_123) dryrun
assert strpos(`"`r(cmd1)'"', "webapi post") == 1
assert strpos(`"`r(cmd1)'"', "SV_123/export-responses") > 0
assert strpos(`"`r(cmd1)'"', "X-API-TOKEN:TOK") > 0
assert strpos(`"`r(cmd2)'"', "webapi get") == 1
assert strpos(`"`r(cmd3)'"', "curl") == 1

* --- (4) bad subcommand errors cleanly ----------------------------------------
capture noisily surveypull monkey, url(x) token(y)
assert _rc == 198

di as res "ALL TESTS PASSED"
