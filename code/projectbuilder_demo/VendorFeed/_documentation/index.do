*===============================================================
* index.do -- documentation source for VendorFeed
* Rendered to website/index.html by _runall.do (needs webdoc2).
* If webdoc2 is absent, projectbuilder writes a plain index.html
* directly, so the documentation always exists.
*===============================================================

* Build it with:  webdoc2 "index.do"   (see _runall.do)
* Content subcommands: wdinit, wputh1, wput (edit freely).

* wdinit injects webdoc2's header.html, which it locates with findfile
* -- so header.html has to be on the adopath or in the directory this
* renders from.  _runall.do takes care of that; see the note there.
wdinit index, replace
wputh1 VendorFeed
wput Monthly vendor extract; agency emails the file
wput <b>Source URL:</b> https://example.gov/vendor/monthly.csv
wput <b>Topic:</b> procurement
wput <b>Public-facing:</b> no
wput <b>Refresh timeline:</b> monthly
wput <b>Other notes:</b> (not recorded)
