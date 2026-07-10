# Manuscript source (durable copy)

The book is written as one file per chapter and assembled into
`../main.tex`. This folder is the authoritative, version-controlled copy of
that source. (It previously lived only in a scratch directory under
`/private/tmp`, which the OS prunes — six files were lost that way once.)

- `chapters/` one .tex per chapter/part/appendix; `ASSEMBLY_ORDER.txt` fixes the order
- `00_preamble.tex` the preamble (packages, kaobook styles, tikz styles, amsmath)
- `bib_fragments/` per-chapter biblatex fragments, merged into `../main.bib`
- `assemble.sh` concatenates in ASSEMBLY_ORDER into `main_assembled.tex`

Rebuild:
```
bash assemble.sh && cp main_assembled.tex ../main.tex
cd .. && pdflatex main && biber main && makeindex main.idx && pdflatex main && pdflatex main
```
