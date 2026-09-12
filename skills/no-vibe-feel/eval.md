# Eval rubric

Gate each finding, and after any Fix gate your own output. A change is not done until all seven pass. For each gate: pass, or name the exact violation.

## The seven gates

1. **Smallest surface.**
Pass: no unused layer, dependency, knob, adapter, or abstraction that the current requirement does not exercise.
Fail examples: `AbstractRepository` with one implementation; axios added where `fetch` suffices; `useMemo` on two lines of plain math; a "config" the app can never change.

2. **Senior one-pass read.**
Pass: a competent developer of the stack understands the change in one read of the diff, top to bottom, without asking "why is this here?".
Fail examples: a 400-line handler; nested ternary chains; a function that incidentally mutates its caller's state; a rename mixed into an unrelated fix.

3. **Exact naming.**
Pass: every identifier names the concept in the domain language.
Fail examples: `data`, `result`, `temp`, `val`, `item`, `handleChange`, `processData`; name-of-type (`isErrorBoolean`); name-of-implementation (`userArray`); joke or commit-vibe names.

4. **Errors end somewhere.**
Pass: every failure path has a consequence — recover, convert to a meaningful error, or re-raise.
Fail examples: `catch {}`; `catch(e){console.log(e)}` that then returns normally; `.catch(() => {})`; validation stripped so the happy path clears; `except: pass`.

5. **Edges handled.**
Pass: empty, null, missing-record, oversized, concurrent/duplicate, first/last, and timezone/unicode edges exist where the input can produce them.
Fail examples: `.map` over possibly-undefined; a UI that fetches with no loading/empty/error state; integer division where a zero is possible; double-submit unguarded.

6. **A test proves the behavior.**
Pass: the behavior contract is encoded and fails for a real reason on breakage.
Fail examples: no test on a behavior change; a test that asserts implementation (`expect(sum(a,b)).toBe(a+b)` for `return a + b`); a full-DOM snapshot; a test named "should work".

7. **Ship-under-your-name.**
Pass: you would defend this diff in review without cringing.
Aggregate gate: any of 1-6 failing means this fails.

## Scoring

All seven pass = done. Any fail = fix the exact violation, re-gate, then report what moved. Do not report a change as complete with an open gate; if one stays open, say which and why.
