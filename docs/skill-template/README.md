# Skill template

A starting point for a new skill in the family. It lives outside `skills/` and
is not named `SKILL.md`, so installers and `npx skills add` never pick it up.

1. Copy it: `mkdir skills/no-vibe-feel-<topic> && cp docs/skill-template/SKILL.template.md skills/no-vibe-feel-<topic>/SKILL.md`.
2. Set `name` to the folder name (lowercase, hyphens) and keep `description`
   under 135 characters with the trigger first. CI enforces both.
3. Add the folder name to `FAMILY` in `install.sh` and to the Skills table in
   `README.md`.
4. Run `skills-ref validate skills/no-vibe-feel-<topic>` and add a
   `CHANGELOG.md` entry.

Open an issue before starting a new skill: the family is small on purpose.
