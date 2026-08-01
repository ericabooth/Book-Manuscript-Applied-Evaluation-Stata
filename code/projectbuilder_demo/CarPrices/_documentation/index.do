*===============================================================
* index.do -- documentation source for CarPrices
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
wputh1 CarPrices
wput Dealer price extracts, one file per model year
wput <b>Source URL:</b> (none recorded)
wput <b>Topic:</b> prices, vehicles
wput <b>Public-facing:</b> unsure
wput <b>Refresh timeline:</b> annual, each October
wput <b>Other notes:</b> (not recorded)
