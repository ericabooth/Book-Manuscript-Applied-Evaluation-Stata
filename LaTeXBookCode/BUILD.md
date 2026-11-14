# Building the book PDF

## The normal build

From `LaTeXBookCode/`:

```bash
cd src && bash assemble.sh && cp main_assembled.tex ../main.tex && cd ..
pdflatex -interaction=nonstopmode main.tex
biber main
makeindex main.idx
pdflatex -interaction=nonstopmode main.tex
pdflatex -interaction=nonstopmode main.tex
```

Edit the chapter files in `src/chapters/`, never `main.tex`: the assemble step overwrites it.

## When biber will not run

The book uses biblatex 3.17, which needs biber 2.17. On some Macs neither available biber works:

- TeX Live 2022's biber is an x86_64 binary, and macOS no longer runs it.
- Homebrew's biber 2.22 does not match biblatex 3.17. It writes a `main.bbl` that biblatex rejects, and a failed biber run can leave `main.bbl` empty, which blanks every citation.

**Do not run biber on such a machine.** The committed `main.bbl` already holds every entry the book cites. When you add a citation, add its `.bbl` entry by hand instead:

1. Add the entry to `main.bib` and to the chapter's fragment in `src/bib_fragments/`.
2. Write the `.bbl` entry from it:

   ```bash
   python3 src/bbl_add.py newkey2026 anotherkey2025
   ```

   This places each entry alphabetically by first author. It handles article, book, incollection, inproceedings, techreport, misc, and online entries with the fields the book uses.
3. Compile without biber:

   ```bash
   cd src && bash assemble.sh && cp main_assembled.tex ../main.tex && cd ..
   pdflatex -interaction=nonstopmode main.tex
   makeindex main.idx
   pdflatex -interaction=nonstopmode main.tex
   pdflatex -interaction=nonstopmode main.tex
   ```

The log still says "Please (re)run Biber" and "There were undefined references". Those two lines come from biblatex noticing that biber did not run. They are harmless as long as the checks below pass.

## Checks after every build

```bash
grep -c '^! ' main.log                       # 0: no LaTeX errors
pdftotext main.pdf - | grep -c '??'          # 0: no unresolved cross-references
python3 - <<'EOF'                            # every cited key has a .bbl entry
import re
t = open('main.tex').read()
keys = {k.strip() for m in re.finditer(r'\\(?:paren|text|foot|auto|full)?cite[a-z]*\*?(?:\[[^\]]*\])*\{([^}]*)\}', t) for k in m.group(1).split(',')}
bbl = set(re.findall(r'\\entry\{([^}]*)\}', open('main.bbl').read()))
print('missing from main.bbl:', sorted(keys - bbl) or 'none')
EOF
```

A cited key that is missing from `main.bbl` prints in bold in the PDF as its bare key. Search the PDF for the key's name to confirm it rendered as author and year.

On a machine where biber 2.17 runs, the normal build regenerates `main.bbl` from `main.bib` and replaces the hand-written entries. That is expected.
