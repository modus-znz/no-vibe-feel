# Stack pocket-guides

Fast tells per stack. The general pattern catalog lives in the parent skill; these name what a seasoned codebase looks like in the stacks covered here.

## TypeScript / React

### Vibe tells

- `interface Props { [key: string]: any }` as an escape hatch.
- Four booleans drilled across six levels of props when composition or context was due.
- `useEffect` computing derived state (`setFiltered(filter(items))`) — derived data does not belong in an effect.
- `useCallback`/`useMemo` on every binding, optimising what is not slow (see `no-vibe-feel-decisions` on measured performance).
- `key={index}` on a reorderable list.
- Fetch in the component body; no loading/empty/error states.
- `console.log` guards left in; `as unknown as X` chains; `axios` where `fetch` suffices; Redux where `useState` or `useContext` carries the state.
- One giant presentational JSX return with a nested ternaries ladder inside.
- Boolean flags as props: `invert`, `hideLabel`, `halfOpen`.
- A `<div onClick>` pretending to be a button; controls with no accessible name.
- Focus dropped when a modal opens or a route changes; `color` as the only error/state signal.

### Seasoned defaults

- Derived data is computed inline (`const filtered = filter(items)`), no effect required.
- Effects exist only for side effects, with cleanup.
- `key` comes from a stable id.
- Load/empty/error are first-class siblings of the happy render, not afterthoughts.
- One data-fetching layer; raw fetch is the default until a query library is genuinely earned.
- Props stay flat, named, and typed; state lives as low as it can while still being honest.
- Errors are typed and surfaced near where they occurred — never a silent `.catch`.
- Every control has a name and a keyboard path; focus moves deliberately on open and close.
- State changes are announced, not just painted.

## Python / Odoo

### Vibe tells

- `except Exception: pass`, or a bare `except:` (which also swallows `KeyboardInterrupt`).
- `logger.warning(...)` then `return False`, disguising a missing record as an ordinary no.
- Mutating `self` in a compute that is not stored.
- `search`/`browse` inside a loop — the Odoo N+1.
- Hardcoded magic `int`/`str` values instead of named selection constants.
- A giant `_compute_*` method doing three unrelated jobs.
- Re-`create`ing a partner/record on every write instead of checking it exists first.
- `sudo()` as a blanket at the top of a method, bypassing every access rule instead of scoping the one that is missing.
- `dict(**data)` rubber-stamping untrusted input into `create`/`write`.

### Seasoned defaults

- Keep `search`/`browse` out of loops; batch with `domain` instead of per-row calls.
- Stored computes declare their deps; computed-only fields stay unstored and named for what they mean.
- Selection fields have named constants, not magic integers.
- `_get_default_*` methods over hardcoded default values.
- Specific exceptions; `sudo()` scoped to exactly the missing access, smallest window.
- Results of `create`/`write` are checked where failure is a real branch.

## Python / FastAPI

REST bridges and internal HTTP services — the rules that keep an HTTP boundary honest.

### Vibe tells

- A handler that returns `{"error": "some string"}` and hopes the client guesses — no status code, no response schema.
- Unvalidated `request.body` / raw `dict` passed straight into an ORM `create` — mass-assignment, the same disease as Odoo's `dict(**data)`.
- Sync DB or slow IO inside an `async` handler, blocking the event loop.
- Auth/tenant checks copy-pasted into every handler body instead of one dependency.
- A route wrapping everything in `except Exception` and returning 200 anyway.

### Seasoned defaults

- pydantic models at the boundary; `response_model` is the contract, and 4xx bodies serialize in the same shape as 2xx.
- Auth and tenant resolution are dependencies resolved at the boundary, not inside the handler body; authorization at the decision point.
- Blocking work runs off the loop — a worker, or an honestly sync route — never a magical `async` that still blocks.
- Errors are raised and mapped once by an exception handler, to status + payload.
