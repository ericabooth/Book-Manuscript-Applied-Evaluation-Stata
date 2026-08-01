# Submission tracker — Applied Program Evaluation Using Stata

Four packages are ready in this folder. Each subfolder has the same three files plus the publisher's own blank form: `00_HOW_TO_SUBMIT.md`, `01_cover_letter*.md`, `02_proposal*.md`.

| Press | Folder | Route | Decision time | Cost to you | Sent | Reply |
|---|---|---|---|---|---|---|
| **Stata Press** | *(root of this folder)* | email `service@stata-press.com` | ~3 weeks | none | | |
| **Vernon Press** | `Vernon_Press/` | email `submissions@vernonpress.com` | ack 1 wk, decision ~2 wks | none | | |
| **Policy Press / Bristol UP** | `PolicyPress_BristolUP/` | email Paul Stevens, `paul.stevens@bristol.ac.uk` | 6–8 wks after it goes to review | none | | |
| **Anthem Press** | `Anthem_Press/` | email `proposal@anthempress.com` | 3–4 wks | none | | |

## Suggested order

All four at once, with disclosure (see below). They run on different clocks. Vernon answers in about two weeks, Anthem in three to four, Stata Press in three, Bristol in six to eight after an initial conversation, so sequencing them would burn months for no gain.

If you would rather stage it: Stata Press and Vernon first (fastest answers, best fit and cleanest terms respectively), then Bristol and Anthem two weeks later.

---

## Standing constraint: this is a personal project

**Neither author is publishing this book under an employer's branding, terms, or sponsorship, and neither employer holds IP rights in any of it.** The work draws on knowledge built up across both careers, not on any company's project. Everything in these packages is written to that footing:

- **Every proposal and cover letter now states it explicitly**, in a short "note on rights and affiliation" or an equivalent sentence in the letter. A publisher's contracts person needs to know who holds rights before drafting, so saying it up front is a courtesy, not a disclaimer.
- **The Stata Press proposal PDF carried a real problem, now fixed.** It is typeset with the shared `tx2036.sty`, which embeds `pdftitle={Texas 2036 Data Governance Guide}` and `pdfauthor={Texas 2036 Data & Research}` into the file. Any editor opening Document Properties would have seen an institution named as the author. The `.tex` now overrides both, so the metadata reads *Applied Program Evaluation Using Stata: Book Proposal* by *Eric A. Booth and Elizabeth Teas*. The style is used for typography only and no logo or institutional mark appears anywhere in the document. **If that style file is ever updated or the proposal is rebuilt elsewhere, re-check `pdfinfo` before sending.**
- **Correspondence should use personal contact details**, not a work address or work phone. Anthem's form has explicit "Work address" and "Work telephone" fields; use personal ones. A contract should not route through an employer's mailroom.

**One judgement call you may want to reverse.** I kept your current positions in the author biographies, because a press needs to know the authors are practising professionals and that is where the book's credibility comes from. Affiliation there is biographical context, not a claim of institutional authorship, and the rights note directly beneath it says so. If you meant that the affiliations should not appear at all, say so and I will strip them to "applied evaluation and policy practitioner" style descriptions in every file. It is a ten-minute change.

---

## Is it legal or ethical to send to several publishers at once?

**Legally: yes, no issue.** A proposal is not a contract and grants nobody exclusivity. You keep copyright in the manuscript throughout. Nothing binds you until you sign a publishing agreement.

Three things would change that, none of which apply here as far as I can see:

1. **A press that explicitly requires exclusive consideration.** Some do, as a stated condition of submission. I read the submission pages for all four of these and none of them asks for exclusivity. That is not a guarantee, so if any of them sends you terms that mention exclusive consideration, that becomes binding once you agree to it.
2. **An option clause in a prior book contract**, giving a previous publisher first refusal on your next book. If either of you has published a book before, check that contract.
3. **Signing with two presses.** Obviously. Once you accept an offer, withdraw everywhere else the same week.

**Ethically: accepted practice for books, provided you disclose it.** This is the part worth getting right, and it is where book publishing differs sharply from journals.

Simultaneous submission to journals is a genuine ethics violation, because it duplicates unpaid peer-review labour and risks duplicate publication. **Book proposals are not held to that standard.** Multiple submission is normal and presses expect it. What they ask in return is that you tell them.

Two of these four ask you directly, which tells you how routine it is:

- **Bristol University Press** invites it in their guidelines: *"if there are any circumstances we should bear in mind from the point of view of timing (for instance if the proposal is under consideration by another publisher), please do let us know."* They say it helps them move faster.
- **Anthem Press** puts *"Have you contacted other publishers?"* on the proposal form itself.

So the rule is disclosure, not exclusivity. Three practical obligations follow:

- **Say so up front**, in the cover letter or the form field. One sentence: "We should mention the proposal is also under consideration at [X]."
- **Tell them immediately if you get an offer elsewhere.** Presses spend real money commissioning external peer review. Letting a press pay for reviews on a book you have already promised to someone else is the one move that genuinely damages a reputation in a small field.
- **Withdraw promptly and politely** everywhere else once you sign. Thank them; you may want them next time.

The reputational risk runs entirely through concealment, not through multiplicity. A press that learns from you that it has competition is fine. A press that learns it from someone else, after paying two reviewers, is not.

*(I am not a lawyer and this is not legal advice. If either of your employers has an IP interest in work-for-hire, that is a separate question worth asking them about before you sign anything. It has nothing to do with multiple submission, but a contract is when it would surface.)*

---

## What you still have to supply

The same three gaps appear in every package, because they are yours to fill and I would not invent them:

1. **CVs for both of you.** Required by Bristol and Anthem; useful everywhere.
2. **Peer reviewer names, affiliations, and emails.** Bristol wants at least four and asks for diversity including Global South institutions. Anthem wants five to ten and asks you to flag which are personally known to you. Each proposal has a table showing the kinds of reviewer to name. **I left these blank deliberately**, because fabricated reviewer details get caught immediately, and choosing who reviews your book is your call.
3. **Concrete demand evidence.** Workshop enrolment numbers, package download counts, or a professional association that would promote the book. This is the single most persuasive thing you can add, and it matters most at Anthem, where a committee including sales and marketing decides.

Bristol also asks for course information, which is worth filling precisely because the book is being pitched there as a Learning Resource.

## Sample chapter

I recommend **Chapter 13, "Using AI without getting burned"** everywhere. It is the chapter an editor can judge without knowing Stata, it is the most obviously current, and there is no competing title on the subject anywhere. Chapter 2 is the alternate if you would rather lead with the workflow spine; Bristol gets both.

**Vernon is the exception on volume:** their guidance says *"Please do not forward complete manuscripts as part of a proposal."* One chapter only. Bristol, by contrast, invites a complete draft if available.

## Facts every package uses

Verified against the manuscript, so they are consistent across all four:

- 328 pages, 15 chapters, 4 appendices
- ~155,000 words including references and appendices
- 65 figures, 32 tables
- No permissions to clear: all data public or simulated, all figures ours
- No part previously published
- Every printed number generated by a companion do-file
