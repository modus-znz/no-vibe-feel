# Contributing

Thanks for wanting to make no-vibe-feel sharper. Keep the bar: every change to
a skill is judged against the seven gates in `no-vibe-feel/eval.md`, the same
way the skills judge code.

## What is worth a PR

- A wrong or misleading example in a skill or a pocket-guide.
- A seasoned default that the current text contradicts.
- A new stack pocket-guide, as long as it follows the existing shape: vibe
  tells first, seasoned defaults second, no fluff.
- A sharper gate or a written fix for an edge the rubric misses.

Ask first if the addition is a new section or new skill — the family is small
on purpose, and every section is a tax on every session that loads the skill.

## Process

1. Fork the repository and clone it.
2. Create a branch: `git checkout -b fix/your-fix`.
3. Make the change. If it touches a skill, update its description if needed
   (keep it under ~135 chars so it stays within session listing budgets) and
   run the official Agent Skills validator, the same one CI runs:

   ```bash
   pip install "git+https://github.com/agentskills/agentskills#subdirectory=skills-ref"
   skills-ref validate skills/no-vibe-feel    # repeat for the folder you changed
   ```

   CI also checks that each description stays within 135 characters and
   renders with `skills-ref to-prompt`. If you changed a rule, run the
   matching eval locally (`claude plugin eval . --case '<name>'`, see
   `evals/README.md`). Add an entry to `CHANGELOG.md` under **Unreleased**.

4. Verify the skill family still works end to end: install it into a scratch
   skills directory and ask your agent to run an audit on a small file.
5. Commit with a message that says what and why: `feat(no-vibe-feel-writing):
   add accessibility section`.
6. Open a pull request. Describe the change and the reasoning. Reviews are
   expected within a few days.

## Releasing

Maintainers bump `version` in `.claude-plugin/plugin.json`, move the
**Unreleased** entries under a new version heading in `CHANGELOG.md`, and push
a signed tag (`git tag -s v1.2.0`). The release workflow refuses a tag whose
version has no changelog section or disagrees with `plugin.json`.

## Ground rules

- No emojis in code, paths, or frontmatter descriptions.
- No `curl | bash` equivalents, no install steps that hide what they run.
- No weakening a gate to make a finding disappear — if a gate is wrong, fix
  the gate and say why.
- Tests and CI are welcome but must not require network access to run.

## Reporting issues

Open an issue with what you expected, what the skill produced instead, and the
context (agent, file type, and the code it was pointed at). A reproduce-able
one-liner beats a description.
