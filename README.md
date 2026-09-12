# no-vibe-feel

Portable agent skills that hold AI coding agents to senior-engineer standards
when they write code, and give them a structured way to review it.

Built on the open **Agent Skills** (`SKILL.md`) format, so the same five
folders work in Claude Code, opencode, Cursor, Codex, Gemini CLI, Antigravity,
GitHub Copilot, Windsurf, and any other agent that reads that format.

[![CI](https://github.com/modus-znz/no-vibe-feel/actions/workflows/ci.yml/badge.svg)](https://github.com/modus-znz/no-vibe-feel/actions/workflows/ci.yml)
[![Release](https://img.shields.io/github/v/release/modus-znz/no-vibe-feel)](https://github.com/modus-znz/no-vibe-feel/releases)
[![OpenSSF Scorecard](https://api.scorecard.dev/projects/github.com/modus-znz/no-vibe-feel/badge)](https://scorecard.dev/viewer/?uri=github.com/modus-znz/no-vibe-feel)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Format: Agent Skills](https://img.shields.io/badge/format-Agent%20Skills-5B4B8A.svg)](https://agentskills.io)

## Overview

AI coding tools reliably produce code that compiles and passes the happy path,
yet carries costs that surface later: vague names, swallowed errors, and
unexplained type escapes. For example:

```ts
// Before: compiles and runs, but hides its failures
const handleChange = async (data: any) => {
  try {
    const result = await fetchData(data)
    setResult(result)
  } catch (e) {
    console.log(e)
  }
}
```

```ts
// After: named for its purpose, with a failure path the UI can act on
const loadInvoiceSummary = async (invoiceId: string) => {
  try {
    const summary = await fetchInvoiceSummary(invoiceId)
    setInvoiceSummary(summary)
  } catch (cause) {
    setInvoiceError(new LoadInvoiceError(invoiceId, cause))
  }
}
```

The first version has three problems a reviewer would flag: the input has no
meaningful name, the error is logged and then discarded, and the argument is
typed `any` without a stated reason.

no-vibe-feel packages the standards applied in a thorough code review as
skills an agent can follow: precise naming, real error handling, minimal
abstraction, covered edge cases, honest tests, and a well-maintained
repository. All five skills validate against the Agent Skills specification
with zero errors and zero warnings.

## Skills

| Skill | Purpose |
|---|---|
| `no-vibe-feel` | Entry point. Chooses **Fix** (write with discipline) or **Detect** (review) for the task, applies seven write-time gates, and loads the relevant sub-skill. |
| `no-vibe-feel-writing` | Implementation craft: naming, comments, error handling, concurrency, types, security, accessibility, edge cases, and function shape. Includes stack guides for TypeScript/React, Python/Odoo, and Python/FastAPI. |
| `no-vibe-feel-decisions` | Design choices: smallest viable surface, standard library first, simple over clever, measure before optimizing, and document the rejected alternative. |
| `no-vibe-feel-audit` | Code review. Eleven review lenses; findings are graded `BLOCK` / `COMMENT` / `NIT` with `file:line` and a concrete fix. Findings are grounded in evidence and never speculate about authorship. |
| `no-vibe-feel-habits` | Repository practice: git hygiene, clear commits, behavior-focused tests, useful logging, and accurate documentation. |

Each skill is a concise `SKILL.md`. Longer reference material is loaded only
when needed (the stack guides live in `no-vibe-feel-writing/references/`).
The seven gates and the scoring rubric are defined in `no-vibe-feel/eval.md`.

## Installation

The skills are plain Markdown, so you can review every file before installing.
Pick whichever route suits your setup.

### With the installer (no dependencies)

```bash
git clone https://github.com/modus-znz/no-vibe-feel.git
cd no-vibe-feel
./install.sh          # detects installed agents and installs for each
```

To install for a single agent:

```bash
./install.sh claude       # Claude Code
./install.sh opencode     # opencode
./install.sh cursor       # Cursor
./install.sh codex        # Codex
./install.sh gemini       # Gemini CLI
./install.sh antigravity  # Antigravity
./install.sh copilot      # GitHub Copilot
./install.sh windsurf     # Windsurf
./install.sh agents       # the shared ~/.agents/skills directory
./install.sh ls           # show the directory each name maps to
```

Options combine with any agent name:

| Option | Effect |
|---|---|
| `--project` | Install into the current project (`.claude/skills`, `.windsurf/skills`, or the shared `.agents/skills`) instead of your home directory. |
| `--link` | Symlink to the clone instead of copying, so `git pull` updates the installed skills. |
| `--dry-run` | Print every command the installer would run, and change nothing. |
| `--uninstall` | Remove the five `no-vibe-feel*` folders. Without an agent name, removes them from every agent that has them. |

Re-running the installer replaces each skill folder rather than merging into
it, so files removed in a newer version do not remain behind. Before copying,
it refuses a checkout that contains symlinks or unexpected file names under
`skills/`.

### With `npx skills`

If you use the [`skills`](https://github.com/vercel-labs/skills) CLI, it
installs all five skills and supports many more agents:

```bash
npx skills add modus-znz/no-vibe-feel
```

### As a Claude Code plugin

```bash
claude plugin marketplace add modus-znz/no-vibe-feel
claude plugin install no-vibe-feel@no-vibe-feel
```

### Skills directories

| Agent | Global skills directory |
|---|---|
| Claude Code | `~/.claude/skills/` |
| opencode | `~/.config/opencode/skills/` |
| Cursor | `~/.cursor/skills/` |
| Codex | `~/.codex/skills/` |
| Gemini CLI | `~/.gemini/skills/` |
| Antigravity | `~/.gemini/antigravity/skills/` |
| GitHub Copilot | `~/.copilot/skills/` |
| Windsurf | `~/.codeium/windsurf/skills/` |
| Shared | `~/.agents/skills/` |

Several agents (including Gemini CLI, Cursor, and GitHub Copilot) also read the
shared `~/.agents/skills/` directory. For any other agent, copy the five folders
under `skills/` into its skills directory.

## Usage

Once installed, no further setup is needed. The entry-point skill activates
when a task involves writing, refactoring, or reviewing code. You can also
invoke it directly:

> "Review this diff with no-vibe-feel." Runs the audit lenses and returns
> `BLOCK` / `COMMENT` / `NIT` findings with `file:line` references and fixes.
>
> "Rewrite this handler with no-vibe-feel discipline." Writes against the
> seven gates and reports which patterns it avoided.

The skills only affect coding work; they do not change agent behavior
elsewhere.

## Design principles

- **Evidence-based review.** Every finding names a pattern, cites the
  `file:line`, explains the cost, and proposes a fix the author can verify.
- **Focused scope.** The skills cover code. Prose style is out of scope and
  can be paired with a separate writing skill if you use one.
- **Simplicity by default.** No meta-programming or configuration options that
  the current requirement does not need.
- **Self-verification.** After a rewrite, the agent checks its own output
  against the seven gates before reporting completion.
- **Transparent.** The skills are plain text with no telemetry or network
  calls. The installer only creates directories and copies files.

## Security

Agent skills are instructions your coding agent will follow, so review them as
you would any dependency. This repository installs by copying files: there is
no `curl | bash`, no build step, and nothing that runs during an agent session.
Releases are created from signed tags, and every workflow pins its actions to
a commit SHA with read-only default permissions.
Review `skills/` before installing and check the diff when you update.
To report a vulnerability, see [SECURITY.md](SECURITY.md). Release notes are
in [CHANGELOG.md](CHANGELOG.md).

## Contributing

Contributions that sharpen a gate, add a stack guide, or correct an example
are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md) for the process; every pull
request is checked against the seven gates before merge. Behavioural evals
for the skills live in [`evals/`](evals/README.md), and a starting point for a
new skill is in [`docs/skill-template/`](docs/skill-template/README.md).

## Limitations

- The skills identify patterns; they cannot prove a codebase is correct, and
  they do not attempt to determine whether code was AI-generated.
- Dedicated stack guides cover TypeScript/React, Python/Odoo, and
  Python/FastAPI. Other stacks are handled by the general guidance.
- `eval.md` intentionally keeps seven gates; security and accessibility are
  covered within gates 4 and 5.

## License

Released under the MIT License. See [LICENSE](LICENSE).
