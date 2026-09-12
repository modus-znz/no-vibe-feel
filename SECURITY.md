# Security Policy

## Supported versions

Only the latest commit on `main` and the most recent tagged release receive
fixes.

## What counts as a vulnerability

no-vibe-feel ships Markdown instructions and a POSIX shell installer. Relevant
reports include:

- `install.sh` writing, deleting, or overwriting anything outside the five
  `no-vibe-feel*` folders in the chosen skills directory.
- Skill text that instructs an agent to run commands, fetch remote content,
  exfiltrate data, or weaken security controls (prompt injection through the
  skill itself).
- Secrets or personal data committed to the repository or its history.

## Reporting

Please do not open a public issue for a vulnerability. Use GitHub's private
vulnerability reporting instead: open the repository's **Security** tab and
choose **Report a vulnerability**.

Include the affected file, the steps to reproduce, and the impact you observed.
You can expect an acknowledgement within 7 days and a fix or mitigation plan
within 30 days.

## Verifying what you install

Skills are instructions your agent will follow. Before installing or updating,
review the diff of `skills/` and `install.sh`. The installer makes no network
requests and runs only `mkdir`, `rm -rf` on the five skill folders it owns, and
`cp` or `ln`. Run `./install.sh --dry-run` to see every command first.
