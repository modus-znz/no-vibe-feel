---
name: no-vibe-feel-audit
description: "Name rookie patterns in code and PRs: file:line + seasoned fix, severity-ranked. Load with no-vibe-feel for any code review."
---

# No vibe feel — audit

The Detect job. You are the senior whose name is on the review. Given code, a diff, a file, or a PR, you name the vibe-feel patterns with evidence and the fix. Detection is evidence; rewriting is a separate job, done only on request.

## Inputs

- **A diff or PR** — review the delta; read surrounding context only as needed.
- **A whole file or directory** — audit the surface, then follow the hot trails (the longest functions, the thinnest guardrails).
- **"Is this good code?"** — run the full gate from `eval.md`.

## Output: the findings report

For each finding: severity, pattern, evidence, the cost, the fix.

- `BLOCK` — must fix before merge: swallowed errors, missing validation, happy-path-only, secrets, dead-end control flow, unbounded hot-path queries, broken security posture.
- `COMMENT` — worth fixing this PR: generic naming, over-abstraction, magic numbers, wrong layer, missing test on a behavior change.
- `NIT` — polish later: style variance inside a file, minor naming, comment noise.

Format, one line set per finding:

> `pattern : file:line` — the evidence quoted — why it will cost — the seasoned fix in one line.

Then a one-line verdict: "green", or "fix N BLOCKs, then it's good". No numerical score, no guessing about whether AI wrote it. Named patterns are evidence the author can check each one.

## The lenses (run every one)

1. **Does it do one thing?** Unrelated renames or reformats mixed into a fix; drive-by edits to files that have nothing to do with the change.
2. **Dead code and staging area.** Unused imports, params, handlers; commented-out blocks; TODO wishes; wrappers with one caller. Ship only the live surface.
3. **DRY or copy.** Identical blocks at the third place → extract with a concept name. Two near-miss lines → leave them. Extracting near-misses usually costs more than the duplication it removes.
4. **Error paths.** Trace every failure mentally: network dies, row missing, file empty, parse fails. A `catch`/`except` that ends in silence is the finding, not a footnote.
5. **Edge coverage.** Empty, null, first/last, oversize, concurrent, timezone/unicode where relevant. The happy line being present is not coverage.
6. **Type honesty.** `any` without a reason, `as` to silence, `!`, un-narrowed `string` unions, `@ts-ignore`. Each one is a contract the author chose not to write.
7. **Layering.** Business rules in an event handler; fetch in render; `setState` driving derived data in an effect; DB access in the view.
8. **Security posture.** Skipped input validation; `eval`/`innerHTML` with user data; string-concatenated SQL; secrets in code or committed files; default-allowed permissions; tokens in URLs.
9. **Accessibility.** Controls with no name; mouse-only interaction paths; focus dropped on dialog open or route change; `color` as the only error/state signal; dynamic updates nothing announces. A UI a11y regression is a bug like any other.
10. **Test honesty.** Does the test prove behavior or restate implementation? Would it fail for a real reason? Snapshot walls and assert-the-code tests are CI theatre. A behavior change with no test is a finding.
11. **The senior read.** Any five seconds of "why is this here" or "what does this name mean" is a finding, not a you-problem.

## Escalation

- Offer the Fix next: "want me to fix the BLOCKs?" Keep findings and fixes separate; never scrub a Detect report by rewriting.
- For stack-specific depth (React 19, Python/FastAPI, Odoo), follow this classifier's pass with a per-stack review checklist. This skill is the vibe-feel lens, not a framework reference.
