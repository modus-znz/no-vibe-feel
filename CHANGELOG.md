# Changelog

All notable changes to this project are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the project uses
[Semantic Versioning](https://semver.org/).

## [Unreleased]

## [1.1.0] - 2026-09-13

### Fixed

- `install.sh gemini` now installs to `~/.gemini/skills` (Gemini CLI) instead
  of the Antigravity directory.
- Auto-detection no longer breaks when `$HOME` contains spaces.
- Reinstalling replaces each skill folder, so files removed upstream no longer
  linger.
- The installer validates the checkout before copying and rejects extra
  arguments.
- `no-vibe-feel-writing` no longer claims `except Exception` catches
  `KeyboardInterrupt`; only a bare `except:` does.

### Added

- Installer targets for `antigravity`, `copilot`, `windsurf`, and the shared
  `agents` directory (`~/.agents/skills`).
- Installer options `--project`, `--link`, `--dry-run`, and `--uninstall`.
- The installer refuses a checkout with symlinks or unexpected file names in
  `skills/`.
- Claude Code plugin and marketplace manifests (`.claude-plugin/`).
- Documented install through `npx skills add modus-znz/no-vibe-feel`.
- Behavioural evals in `evals/` for `claude plugin eval`.
- Skill template in `docs/skill-template/`.
- Release workflow that publishes a GitHub Release from the changelog on a
  version tag, and an OpenSSF Scorecard workflow.
- CI checks for description length, `skills-ref to-prompt`, manifest
  agreement, and every installer mode.
- Social preview image in `.github/social-preview.png`.
- CI: shellcheck, markdownlint, `skills-ref validate`, and an installer smoke
  test.
- `SECURITY.md`, `CHANGELOG.md`, issue and pull request templates, Dependabot
  for GitHub Actions, `.gitignore`, `.gitattributes`, `.editorconfig`.

### Changed

- README rewritten in a neutral, professional register.
- Skills no longer reference project-specific conventions or external
  companion skills.

### Removed

- `AUDIT.md` (internal review notes).

## 1.0.0 - 2026-09-12

### Added

- Initial release: `no-vibe-feel`, `no-vibe-feel-writing`,
  `no-vibe-feel-decisions`, `no-vibe-feel-audit`, `no-vibe-feel-habits`, and
  `install.sh`.

[Unreleased]: https://github.com/modus-znz/no-vibe-feel/compare/v1.1.0...HEAD
[1.1.0]: https://github.com/modus-znz/no-vibe-feel/releases/tag/v1.1.0
