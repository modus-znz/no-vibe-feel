---
name: no-vibe-feel-writing
description: "Senior code habits: exact names, why-comments, real error handling, honest types, edges handled. Load when writing or changing code."
---

# No vibe feel — writing

The craft layer: functions, names, errors, types, edges, shape. Applies to every line you write or change. Readability is the feature — code is read ten times for every one time it is written. If the reader asks "what does this name mean", "what happens on failure", or "what if it's empty", you shipped vibe feel.

## Naming

- **Name the concept, not the storage or the type.** `users`, not `array` or `list`; `customer_id`, not bare `id` in a billing context; `isPaid`, not `flag`.
- **No generics.** `data`, `data2`, `result`, `temp`, `val`, `item`, `stuff`, `handleChange`, `process`, `doStuff` — all of them describe the lack of an idea, not the idea.
- **No type-in-name** except where the domain already says it: `userList` is a smell; `isLoading` for a boolean is fine.
- **No abbreviations that exist only to be short.** `tmp`, `user_accnt`, `idx`, `evt`. Full words cost nothing to write and every session after to decode.
- **No joke or commit-vibe names.** `dataBender`, `whatEven`, `final_real_v2` age badly inside six months.
- **Narrow as you go, in the domain's language.** Good: `activeSessionsByHorse`. Bad: `arr`, `obj2`, `thething`.

## Comments

- **What-comments are wiring noise.** "// increment i by 1" — delete. The code says what it does.
- **Why-comments carry the value.** "// these stay strings because the upstream API rejects JSON numbers" — reasons that survive a read of the code.
- **Never ship commented-out code.** Delete it or the feature. Alt-history belongs in git, not the file.
- **A TODO with no owner is a wish.** Either do it, file it, or say precisely what is missing and who must decide.
- **One doc-comment per public unit at most.** A wall of `@param` lines is theatre when the signature already says it.

## Error handling (the fastest senior tell)

- **Bare `catch {}` swallows the failure and lies to every caller. Never.**
- A catch must do one of three: **recover** (safe default or retry), **convert** (wrap in a meaningful error: what failed, where, with what data), or **re-raise** (let a caller that can act decide).
- `catch(e) { console.error(e) }` is not handling — the function returns normally and the world moves on. That is the lie that makes outages mysterious.
- **Errors are values that travel with context.** In Python, raise the specific exception or attach metadata; never `except: pass`, never a bare `except:` (it also swallows `KeyboardInterrupt` and `SystemExit`), never a blanket `except Exception` that hides which failure happened. In TS, typed error subclasses beat `string`, and beat `unknown` with no branch.
- **Distinguish recoverable from fatal.** A missing optional is a default; a failed write is a surfaced failure. Know which one you are in.
- **Don't use exceptions for control flow** that a boolean would answer honestly.

## Concurrency & async

- **An `await` is a yield point.** State read before it can be stale after it. Re-read the state, or derive from the awaited result — never trust memory of what the world was before the yield.
- **Retried writes need an idempotency key or an in-flight guard.** Double-click, double-webhook, retried POST: the second write is either refused or a no-op, not a second record.
- **Check-then-act races.** A condition checked in one step and acted on in a later one is TOCTOU. Make the act itself the check: an atomic compare-and-set, a unique constraint, a conditional update.
- **Never mutate shared state mid-await and expect the next line to see it.** Re-entrancy assumptions are where "works on my machine" becomes "works on mine, breaks in prod".

## Security

Seasoned code is secure at birth, not caught at review:

- **Validate input at the trust boundary** — length, shape, allowed values — and assume the client and every connected service are hostile until proven otherwise.
- **Parameterize queries and API calls.** String-concatenated SQL, ODBC, or URL data is an injection by construction.
- **Authorization is checked where the permission is decided**, per record or per method — not once at the top of a request and never inside the view layer.
- **Secrets live in the environment**, not in code, mocks, docs, or commits. They stay out of logs and out of error messages (no echoing an upstream password back to a caller).
- **User-supplied data that renders is escaped at the output edge** — a renderer API, never raw `innerHTML`/`mark_safe`/template-format gymnastics.

## Accessibility

UI code's silent contract — a user who cannot see, hear, or use a mouse must still reach every feature:

- **Every control has a name** an assistive tech can read: a real `<label>` or a purposeful `aria-label`, never nothing.
- **Keyboard is a first-class input**: focusable, `:focus-visible`, reachable tab order, no mouse-only paths.
- **Color is never the only signal.** An error is icon + text; a state change is text + color.
- **Focus is managed where the UI changes** — moved into a dialog on open, restored on close, never silently dropped on route change.

## Types

- **`any` only with `// reason:`.** The trade-off must be stated where it is made.
- **`as` assertions that silence the type system are a confession.** If the type is wrong, fix the type or narrow with a real guard; don't paint over it.
- **Type what varies, not everything.** Union types not `string`: `'pending' | 'active' | 'closed'` beats `status: string`.
- **Boolean-flag parameters are a smell.** `save(order, true)` says nothing. Split the call or name the sender (`force`), never an anonymous `true`.
- **Non-null `!` and `@ts-ignore` skip the contract.** They surface where the invariant is actually unknown — leave a why, or fix the invariant.

## Edges

Every function has input edges, and they are part of the contract:

- Empty and null and missing-record inputs.
- First and last elements; off-by-one ranges; zero- and one-length collections.
- Oversized inputs (a whole HTML page where a title was expected).
- Concurrent or duplicate calls (double-submit, double-webhook).
- Unicode, timezone, and locale where user data passes.

If you only implemented the happy line, you implemented the demo, not the thing.

## Shape

- **One job per function; name the job.** If the name needs "and", split.
- **The function reads top to bottom at one level of abstraction.** A 400-line handler that hops between SQL, the DOM, and business rules is three functions pretending to be one.
- **Extract at the third real repetition, with a concept name** — not the second, and never because mere lines look alike.
- **Twice is often fine duplicated.** Five lines copied twice is frequently clearer than the abstraction that collapses them.
- **Readability beats clever.** A plain loop beats a one-line `reduce`; an explicit `if` beats a ternary chain; a named constant beats a magic number at its second occurrence.
- **Match the file's existing idiom.** Mixed `async/await` + `.then`, two quote styles, three import orders in one file = vibe feel in one package.

## Stack pocket-guides

The TypeScript/React, Python/Odoo, and Python/FastAPI tells live in `references/stack-pocketguides.md`. Read them when working in those stacks.

## Integration

Prose inside code — comments, messages, labels — is concrete: no throat-clearing, no filler. Edit surgically, touching only what the task requires; this file governs what seasoned looks like when you are done.
