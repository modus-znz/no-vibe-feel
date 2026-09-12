---
name: no-vibe-feel-decisions
description: "Choose like a senior: smallest surface, stdlib-first, boring over clever, measure first. Load when picking architecture or tools."
---

# No vibe feel — decisions

The layer above craft: choices about architecture, libraries, structure. A vibecoder picks the exciting option that looks plausible; a seasoned engineer picks the one still defensible a year later. Everything here answers one question: *what is the smallest thing that solves the stated problem, and is it boring enough to maintain?*

## Over-engineering (the number-one vibe tell)

- A `Manager`, `Service`, `Repository`, `Factory`, or interface that exists to *look* industrial. One implementation, one caller = a costume. Delete it and call the function directly.
- A state library (Redux/Zustand), a DI container, or an ORM "because the app will grow" is speculating with the roadmap. The app grows decision by decision, and every unused layer is a tax on every session after.
- YAGNI is a discipline, not an insult. A knob you add today must be turned today, or it is debt priced at your future.

**The rule: machinery is earned by a requirement, not by momentum.** Before adding a layer, name the requirement that exercises it today. If you cannot, do not.

## Dependencies

- **stdlib and framework first.** `fetch` before axios, the built-in formatter before a date library, `useState` before a store. Add a dependency for capability, never for convenience.
- **Each dependency is a supply chain, a version matrix, and a doc you will re-read.** Ask what it does that the platform cannot.
- When you do add one, say why in the PR in one line: "axios, for interceptors shared across ~15 endpoints" — never "industry standard".
- Same for code you could write: a helper you control beats a dependency you audit.

## Boring beats clever

- **The unglamorous, well-understood option wins.** If two options do the job, choose the one you would not have to re-explain in a year.
- Clever is a smell on its own: `setTimeout` hacks, meta-programming, reflection where a table would do, regex that needs a comment to be parsed.
- Novelty is not an engineering argument. "This is how the cool team does it" is not a requirement.

## Performance chosen, not assumed

- **No premature optimization.** Don't memoize before measuring, cache before profiling, or build the queue before a customer reaches it.
- When performance matters, the profile names the hotspot; optimize that named line and prove the before/after.
- Designing for "scale" nobody asked for — the distributed system for ten users — is speculative generality with extra steps.
- Real N+1 and O(n²) in a hot path matter; a micro-optimization in a cold path is theatre.

## Decisions carry their rationale

- **Every non-obvious choice ships with the alternative it rejected**, in one sentence in the commit body or PR: "sqlite over postgres: single-user tool, zero ops".
- A commit that only says "fix stuff" surrenders the decision to archaeology. `no-vibe-feel-habits` owns the message structure so the choice survives.

## Spec discipline

- **Solve the stated problem, not the deduced one.** Building the generator-of-generators, the meta-framework, or the "configurable" version of a one-liner is vibe feel wearing ambition.
- If the requirement feels wrong, say so plainly and propose the smaller version — do not quietly expand the build to include everything you imagined.

## Integration

Carries these guardrails as defaults: no hardcoded secrets, no force-push without a request, no destructive DB operations without confirmation. The boring choice is also the safe one.
