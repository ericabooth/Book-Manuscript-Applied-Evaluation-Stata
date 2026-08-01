*===============================================================
* _runall.do -- build website/index.html for VendorFeed
*===============================================================
* Prettier docs use webdoc2 (author's GitHub; needs -ssc install webdoc-).
* projectbuilder always writes website/index.html directly as a
* fallback; this renders the webdoc2 version when it is available.
capture which webdoc2
if _rc {
    di as txt "webdoc2 not installed; using the built-in website/index.html."
    di as txt "  ssc install webdoc"
    di as txt `"  net install webdoc2, from("https://raw.githubusercontent.com/ericabooth/webdoc2-stata-public/main/") replace"'
}
else {
    * cd so webdoc2 finds index.do.  The path is stamped literally
    * rather than taken from $docs: projectbuilder runs this file
    * itself under -builddocs-, and at that point 000_control.do has
    * not run, so $docs is undefined.
    * wdinit finds webdoc2's header.html with -findfile-, i.e. on the
    * adopath or in the current directory.  webdoc2 ships header.html as
    * an ANCILLARY file, so -net install webdoc2- never places it and
    * -net get webdoc2- leaves it in whatever directory you were in.
    * Since the render happens from _documentation/, look for it HERE,
    * before the cd, and carry a copy over if we found one.  Passing it
    * through wdinit's headerfile() is not an option: that goes through
    * findfile too, so it takes a findable NAME, not a path.
    local hf ""
    capture findfile "header.html"
    if !_rc {
        local hf "`r(fn)'"
        if substr("`hf'", 1, 1) != "/" & !regexm("`hf'", "^[a-zA-Z]:") {
            local hf "`c(pwd)'/`hf'"   // absolute: we are about to cd
        }
    }

    local here "/Users/ebooth/Documents/GitHub/Book Manuscript:Applied Evaluation-Stata/code/projectbuilder_demo/VendorFeed/_documentation"
    cd "`here'"

    * Borrow header.html only if this folder does not already have one,
    * and put it back the way we found it afterwards.
    local borrowed 0
    capture confirm file "header.html"
    if _rc & "`hf'" != "" {
        capture copy "`hf'" "header.html"
        if !_rc local borrowed 1
    }
    capture noisily webdoc2 "index.do"
    local wrc = _rc
    if `wrc' {
        di as txt "webdoc2 render skipped; the built-in website/index.html remains."
    }
    else {
        * webdoc2 writes index.html BESIDE index.do, but the project's
        * documentation page is website/index.html -- that is what the
        * run points you at, and what the built-in fallback writes.
        * Put the rendered page where everything says it is.
        capture copy "`here'/index.html" "`here'/website/index.html", replace
        if _rc {
            di as txt "webdoc2 rendered index.html, but it could not be copied"
            di as txt "into website/; the built-in page remains."
            local wrc = 603
        }
    }
    if `borrowed' capture erase "header.html"
    * Hand the outcome back: projectbuilder decides what to report from
    * this file's return code, so swallowing it here made every render
    * look successful.
    exit `wrc'
}
