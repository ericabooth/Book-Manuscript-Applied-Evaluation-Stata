#!/bin/bash
# Assemble the manuscript from per-chapter files in ASSEMBLY_ORDER
set -e
D="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTFILE="$D/main_assembled.tex"
: > "$OUTFILE"
while IFS= read -r name; do
  if [ "$name" = "00_preamble" ]; then
    cat "$D/00_preamble.tex" >> "$OUTFILE"
  else
    cat "$D/chapters/$name.tex" >> "$OUTFILE"
  fi
done < "$D/chapters/ASSEMBLY_ORDER.txt"
wc -l "$OUTFILE"
