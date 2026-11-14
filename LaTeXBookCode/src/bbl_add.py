#!/usr/bin/env python3
"""Add bibliography entries to main.bbl by hand when biber cannot run.

    python3 src/bbl_add.py KEY [KEY ...]      # run from LaTeXBookCode/

Reads each KEY from main.bib and writes a biblatex 3.17 (authoryear) entry
into main.bbl at its alphabetical place (by first author's family name).
Handles @article, @book, @incollection, @inproceedings, @techreport, @misc,
and @online with the fields this book uses: author, title, journal or
booktitle, publisher, institution, volume, number, pages, year, doi, url.
Then compile with pdflatex, makeindex, pdflatex, pdflatex (no biber).
See BUILD.md for when and why.
"""
import hashlib, re, sys

BIB, BBL = "main.bib", "main.bbl"

def bib_entry(text, key):
    m = re.search(r"@(\w+)\s*\{\s*%s\s*," % re.escape(key), text)
    if not m:
        sys.exit("key not in main.bib: " + key)
    i, depth = text.index("{", m.start()), 0
    for j in range(i, len(text)):
        depth += {"{": 1, "}": -1}.get(text[j], 0)
        if depth == 0:
            break
    body = text[text.index(",", m.start()) + 1:j]
    fields, pos = {}, 0
    for fm in re.finditer(r"(\w+)\s*=\s*", body):
        if fm.start() < pos:
            continue
        k, s = fm.group(1).lower(), fm.end()
        if body[s] == "{":
            d = 0
            for e in range(s, len(body)):
                d += {"{": 1, "}": -1}.get(body[e], 0)
                if d == 0:
                    break
            fields[k], pos = body[s + 1:e], e + 1
        else:
            e = body.find(",", s)
            e = len(body) if e < 0 else e
            fields[k], pos = body[s:e].strip().strip('"'), e
    return m.group(1).lower(), {k: " ".join(v.split()) for k, v in fields.items()}

def people(author):
    out = []
    for p in re.split(r"\s+and\s+", author):
        if "," in p:
            fam, giv = [x.strip() for x in p.split(",", 1)]
        else:
            bits = p.split()
            fam, giv = bits[-1], " ".join(bits[:-1])
        out.append((fam, giv))
    return out

def initials(giv):
    parts = [g for g in re.split(r"[\s~]+", giv) if g]
    return "\\bibinitdelim ".join(g.strip("{}")[0] + "\\bibinitperiod" for g in parts)

def md5(s):
    return hashlib.md5(s.encode()).hexdigest()

def bbl_entry(key, typ, f, sortinithash):
    btype = {"online": "online", "misc": "misc"}.get(typ, typ)
    ppl = people(f.get("author", "Anonymous"))
    L = ["    \\entry{%s}{%s}{}" % (key, btype), "      \\name{author}{%d}{}{%%" % len(ppl)]
    for fam, giv in ppl:
        fam_c = fam.strip("{}")
        L += ["        {{un=0,uniquepart=base,hash=%s}{%%" % md5(fam + giv),
              "           family={%s}," % fam, "           familyi={%s\\bibinitperiod}," % fam_c[0]]
        if giv:
            L += ["           given={%s}," % giv.replace(" ", "\\bibnamedelima "),
                  "           giveni={%s}," % initials(giv)]
        L += ["           givenun=0}}%"]
    L += ["      }"]
    for nm in ("publisher", "institution"):
        if nm in f:
            L += ["      \\list{%s}{1}{%%" % nm, "        {%s}%%" % f[nm], "      }"]
    nh, fh = md5(key + "n"), md5(key + "f")
    for k, v in (("namehash", nh), ("fullhash", fh), ("bibnamehash", nh),
                 ("authorbibnamehash", nh), ("authornamehash", nh), ("authorfullhash", fh)):
        L.append("      \\strng{%s}{%s}" % (k, v))
    si = ppl[0][0].strip("{}")[0].upper()
    L += ["      \\field{sortinit}{%s}" % si, "      \\field{sortinithash}{%s}" % sortinithash(si),
          "      \\field{extradatescope}{labelyear}", "      \\field{labeldatesource}{year}",
          "      \\field{labelnamesource}{author}", "      \\field{labeltitlesource}{title}"]
    if "journal" in f: L.append("      \\field{journaltitle}{%s}" % f["journal"])
    if "booktitle" in f: L.append("      \\field{booktitle}{%s}" % f["booktitle"])
    if "number" in f: L.append("      \\field{number}{%s}" % f["number"])
    L.append("      \\field{title}{%s}" % f.get("title", ""))
    if "volume" in f: L.append("      \\field{volume}{%s}" % f["volume"])
    L.append("      \\field{year}{%s}" % f.get("year", ""))
    if "pages" in f:
        pg = f["pages"].replace("--", "-").split("-")
        L.append("      \\field{pages}{%s}" % "\\bibrangedash ".join(pg))
        span = int(pg[1]) - int(pg[0]) + 1 if len(pg) == 2 and pg[0].isdigit() and pg[1].isdigit() else 1
        L.append("      \\range{pages}{%d}" % span)
    for v in ("doi", "url"):
        if v in f:
            L += ["      \\verb{%s}" % v, "      \\verb %s" % f[v], "      \\endverb"]
    L.append("    \\endentry")
    return "\n".join(L) + "\n"

def main(keys):
    bib, bbl = open(BIB, encoding="utf-8").read(), open(BBL, encoding="utf-8").read()
    hashes = dict(re.findall(r"\\field\{sortinit\}\{(\S)\}\n\s*\\field\{sortinithash\}\{([0-9a-f]+)\}", bbl))
    def sih(letter):
        if letter not in hashes:
            sys.exit("no existing entry starts with %s; copy a sortinithash for it by hand" % letter)
        return hashes[letter]
    for key in keys:
        if "\\entry{%s}" % key in bbl:
            print("already in main.bbl:", key); continue
        typ, f = bib_entry(bib, key)
        new = bbl_entry(key, typ, f, sih)
        fam = people(f.get("author", "Anonymous"))[0][0].strip("{}").lower()
        # insert before the first existing entry whose first family name sorts after this one
        spots = [(m.start(), re.search(r"family=\{([^}]*)\}", bbl[m.start():m.start() + 600]))
                 for m in re.finditer(r"    \\entry\{", bbl)]
        at = next((s for s, fm in spots if fm and fm.group(1).strip("{}").lower() > fam), None)
        if at is None:
            at = bbl.index("  \\endsortlist") if "\\endsortlist" in bbl else len(bbl)
        bbl = bbl[:at] + new + bbl[at:]
        print("added", key, "(%s)" % typ)
    open(BBL, "w", encoding="utf-8").write(bbl)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    main(sys.argv[1:])
