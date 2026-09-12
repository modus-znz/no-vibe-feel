#!/bin/sh
# no-vibe-feel installer
#
# Copies (or symlinks) the no-vibe-feel skill family into the skills directory
# of the coding agent(s) you use. No dependencies and no network access; the
# only commands it runs are mkdir, rm on the five skill folders it owns, and
# cp or ln.
#
# Usage:
#   ./install.sh [options]            auto-detect installed agents, install to each
#   ./install.sh [options] <agent>    install for one agent
#   ./install.sh ls                   print the directory each agent name maps to
#
# Options:
#   --project     install into the current directory's project skills folder
#                 (requires an agent name)
#   --link        symlink to this checkout instead of copying, so `git pull`
#                 updates the installed skills
#   --uninstall   remove the five skill folders instead of installing
#   --dry-run     print what would change and change nothing
#   -h, --help    show this help
#
# Reinstalling replaces each skill folder rather than merging into it, so
# files removed upstream do not linger as stale instructions.

set -eu

SRC="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)/skills"
FAMILY="no-vibe-feel no-vibe-feel-writing no-vibe-feel-decisions no-vibe-feel-audit no-vibe-feel-habits"
AGENTS="claude opencode cursor codex gemini antigravity copilot windsurf agents"

mode=install
link=0
dry_run=0
project=0
agent=""

usage() {
    echo "usage: ./install.sh [--project] [--link] [--uninstall] [--dry-run] [ls | <agent>]" >&2
    echo "agents: $AGENTS" >&2
}

skills_dir_for() {
    case "$1" in
        claude|claude-code) echo "$HOME/.claude/skills" ;;
        opencode)           echo "$HOME/.config/opencode/skills" ;;
        cursor)             echo "$HOME/.cursor/skills" ;;
        codex)              echo "$HOME/.codex/skills" ;;
        gemini)             echo "$HOME/.gemini/skills" ;;
        antigravity)        echo "$HOME/.gemini/antigravity/skills" ;;
        copilot)            echo "$HOME/.copilot/skills" ;;
        windsurf)           echo "$HOME/.codeium/windsurf/skills" ;;
        agents)             echo "$HOME/.agents/skills" ;;
        *)                  echo "" ;;
    esac
}

# Project-level folders. Most agents read the shared .agents/skills; Claude
# Code and Windsurf use their own.
project_dir_for() {
    case "$1" in
        claude|claude-code) echo "$PWD/.claude/skills" ;;
        windsurf)           echo "$PWD/.windsurf/skills" ;;
        opencode|cursor|codex|gemini|antigravity|copilot|agents)
                            echo "$PWD/.agents/skills" ;;
        *)                  echo "" ;;
    esac
}

# The agent's own config directory; its presence means the agent is installed
# even if it has no skills directory yet.
agent_home_for() {
    dirname -- "$(skills_dir_for "$1")"
}

# Runs a command, or only prints it under --dry-run.
run() {
    if [ "$dry_run" -eq 1 ]; then
        printf '  would run:'
        printf ' %s' "$@"
        printf '\n'
    else
        "$@"
    fi
}

# Fail before touching any destination, so a broken or tampered checkout never
# leaves a partial install or copies something unexpected.
check_source() {
    if [ ! -d "$SRC" ] || [ -L "$SRC" ]; then
        echo "skills/ is missing or is a symlink: $SRC" >&2
        exit 1
    fi
    for skill in $FAMILY; do
        if [ ! -f "$SRC/$skill/SKILL.md" ]; then
            echo "missing from checkout: skills/$skill/SKILL.md" >&2
            exit 1
        fi
    done
    # A symlink inside skills/ could make cp read files outside the checkout.
    symlinks="$(find "$SRC" -type l)"
    if [ -n "$symlinks" ]; then
        echo "refusing to install: symlinks found in skills/:" >&2
        echo "$symlinks" >&2
        exit 1
    fi
    # Skill files are plain names; anything else (spaces, newlines, control
    # characters) is either a mistake or an attempt to confuse a reviewer.
    odd_names="$(find "$SRC" -name '*[!A-Za-z0-9._-]*')"
    if [ -n "$odd_names" ]; then
        echo "refusing to install: unexpected file names in skills/:" >&2
        echo "$odd_names" >&2
        exit 1
    fi
}

install_to() {
    dest="$1"
    run mkdir -p -- "$dest"
    for skill in $FAMILY; do
        run rm -rf -- "${dest:?}/$skill"
        if [ "$link" -eq 1 ]; then
            run ln -s -- "$SRC/$skill" "$dest/$skill"
            echo "  linked: $dest/$skill"
        else
            run cp -R -- "$SRC/$skill" "$dest/"
            echo "  installed: $dest/$skill"
        fi
    done
}

uninstall_from() {
    dest="$1"
    for skill in $FAMILY; do
        if [ -e "$dest/$skill" ] || [ -L "$dest/$skill" ]; then
            run rm -rf -- "${dest:?}/$skill"
            echo "  removed: $dest/$skill"
        fi
    done
}

apply_to() {
    if [ "$mode" = uninstall ]; then
        uninstall_from "$1"
    else
        install_to "$1"
    fi
}

for arg in "$@"; do
    case "$arg" in
        --link)      link=1 ;;
        --dry-run)   dry_run=1 ;;
        --uninstall) mode=uninstall ;;
        --project)   project=1 ;;
        -h|--help)   usage; exit 0 ;;
        -*)          echo "unknown option: $arg" >&2; usage; exit 2 ;;
        *)
            if [ -n "$agent" ]; then
                usage
                exit 2
            fi
            agent="$arg"
            ;;
    esac
done

if [ "$agent" = "ls" ]; then
    for name in $AGENTS; do
        printf '%-12s -> %s\n' "$name" "$(skills_dir_for "$name")"
    done
    exit 0
fi

if [ "$link" -eq 1 ] && [ "$mode" = uninstall ]; then
    echo "--link and --uninstall cannot be combined" >&2
    exit 2
fi

if [ "$project" -eq 1 ] && [ -z "$agent" ]; then
    echo "--project needs an agent name, e.g. ./install.sh --project claude" >&2
    exit 2
fi

if [ "$mode" = install ]; then
    check_source
fi

if [ -n "$agent" ]; then
    if [ "$project" -eq 1 ]; then
        dest="$(project_dir_for "$agent")"
    else
        dest="$(skills_dir_for "$agent")"
    fi
    if [ -z "$dest" ]; then
        echo "unknown agent: $agent" >&2
        usage
        exit 2
    fi
    apply_to "$dest"
    echo "done. reload your agent to pick up the change."
    exit 0
fi

echo "auto-detecting coding agents..."
matched_count=0
for name in $AGENTS; do
    if [ "$mode" = uninstall ]; then
        present="$(skills_dir_for "$name")"
    else
        present="$(agent_home_for "$name")"
    fi
    if [ -d "$present" ]; then
        echo "$name:"
        apply_to "$(skills_dir_for "$name")"
        matched_count=$((matched_count + 1))
    fi
done

if [ "$matched_count" -eq 0 ]; then
    echo "no known coding agent found on this machine." >&2
    echo "name one explicitly, e.g. ./install.sh claude" >&2
    exit 1
fi
echo "done. processed $matched_count agent(s). reload your agent(s) to pick up the change."
