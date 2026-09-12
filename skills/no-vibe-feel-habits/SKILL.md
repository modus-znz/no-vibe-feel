---
name: no-vibe-feel-habits
description: "Keep the repo maintained: git hygiene, honest commits, behavior tests, CI green. Load when committing or landing work."
---

# No vibe feel — habits

The layer that makes a repo look maintained instead of abandoned. Vibecoders commit obsessively and never clean; seasoned engineers treat the repo and its history as a product teammates read.

## Git hygiene

- **`.gitignore` is present and honest**: never `node_modules`, `.env`, `/dist`, `/build`, caches, secrets, or local tool state.
- **Secrets never get committed.** Not to a private repo, not "temporarily". Hardcoded secrets are a BLOCK. If one already shipped, rotate it — deleting it is not enough.
- **No `final_final2.py`, `Backup (3)`, or WIP checkpoints as history.** Git is the backup; branch, don't duplicate.
- **One logical change per commit.** A commit is one idea, green, and described by its message. "Fix typo in login" and "add pagination" in one commit is two things in one box.
- **Review your own diff before finishing** — `git diff` it exactly as you would someone else's. Your own un-reviewed diff is the footprint of a rushed session.

## Commit and PR structure

- **The summary says what; the body says why and what it deliberately does not include.** Structure is owned here.
- Convention: `fix(<scope>): what and why` — scope prefix, sentence-case summary, the reason in the body.
- **A decision ships with the alternative it rejected in the body**, so history is archaeology you never need to do.

## Tests

- **Prove behavior, not implementation.** The test fails for a real reason when the contract breaks and keeps passing through safe refactors.
- **Name tests as scenario + expectation**, not a leaf iterator: `it marks an overpaid invoice as flagged` beats `test2` or "should work".
- **Minimal snapshots.** Golden-test the contract, not the whole DOM. A snapshot wall that changes on every whitespace tweak is noise signed by CI.
- **A behavior change ships with a test**, or it ships with a plan, not a vibed-in "done".
- **CI runs lint + typecheck + tests, green before "done".** Run the project's lint script locally before calling work done.

## The repo as a product

- **README says what it does, how to run it, and its known limits** — three short sections. Marketing puff and a "full docs coming soon" line are the opposite of honest.
- **The bar for docs:** a fresh clone runs it without a conversation.
- **Setup is captured** — lockfile, env example, one line per service — so "runs on my machine" becomes "runs on checkout".

## No debug residue

- `console.log`/`print` debug lines shipped to main are a NIT at best, a data-leak at worst. If the log has value, make it a real logging line with context.
- A try/catch that logs and does nothing is the fast-lane lie — see `no-vibe-feel-writing`.

## Observability

The ban is half the rule; the other half is what a real log line looks like:

- Timestamp, level, a stable message, and structured context — the record id, the order id — so a failure is traceable without replaying state.
- In a catch, `logger.exception` keeps the traceback. A bare message that drops the cause turns a fifty-second find into a bisection.
- A correlation id ties one request's lines together across services; per-request context beats line-stamped noise.
- Logs carry nothing you would not print on a support ticket: no secrets, no raw PII.

## Integration

This sub-skill owns repository structure and hygiene; `no-vibe-feel-writing` owns the code any commit carries.
