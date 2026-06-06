#!/usr/bin/env bash
#
# Symlink every rule and skill from this repo into your Claude config.
#
# Each rule (rules/*.md) and each skill (skills/<name>/) is linked individually,
# so you can also link just the ones you want by hand instead of running this.
#
# Usage:
#   ./install.sh [options]
#
# Options:
#   --rules-dir DIR    Destination for rules  (default: ~/.claude/rules)
#   --skills-dir DIR   Destination for skills (default: ~/.claude/skills)
#   --rules-only       Link rules only
#   --skills-only      Link skills only
#   --force            Overwrite existing files/symlinks at the destination
#   -h, --help         Show this help

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

RULES_DIR="${HOME}/.claude/rules"
SKILLS_DIR="${HOME}/.claude/skills"
DO_RULES=1
DO_SKILLS=1
FORCE=0

usage() {
  cat <<'EOF'
Symlink every rule and skill from this repo into your Claude config.

Each rule (rules/*.md) and each skill (skills/<name>/) is linked individually,
so you can also link just the ones you want by hand instead of running this.

Usage:
  ./install.sh [options]

Options:
  --rules-dir DIR    Destination for rules  (default: ~/.claude/rules)
  --skills-dir DIR   Destination for skills (default: ~/.claude/skills)
  --rules-only       Link rules only
  --skills-only      Link skills only
  --force            Overwrite existing files/symlinks at the destination
  -h, --help         Show this help
EOF
  exit "${1:-0}"
}

while [ $# -gt 0 ]; do
  case "$1" in
    --rules-dir)  RULES_DIR="$2"; shift 2 ;;
    --skills-dir) SKILLS_DIR="$2"; shift 2 ;;
    --rules-only)  DO_SKILLS=0; shift ;;
    --skills-only) DO_RULES=0; shift ;;
    --force) FORCE=1; shift ;;
    -h|--help) usage 0 ;;
    *) echo "Unknown option: $1" >&2; usage 1 ;;
  esac
done

# Symlink $1 into directory $2, respecting --force.
link_one() {
  local src="$1" dest_dir="$2"
  local name dest
  name="$(basename "$src")"
  dest="${dest_dir}/${name}"

  if [ -e "$dest" ] || [ -L "$dest" ]; then
    if [ "$FORCE" -eq 1 ]; then
      rm -rf "$dest"
    else
      echo "  skip   ${name} (already exists; use --force to overwrite)"
      return
    fi
  fi

  ln -s "$src" "$dest"
  echo "  link   ${name}"
}

if [ "$DO_RULES" -eq 1 ]; then
  echo "Rules -> ${RULES_DIR}"
  mkdir -p "$RULES_DIR"
  for rule in "${REPO_DIR}"/rules/*.md; do
    [ -e "$rule" ] || continue
    link_one "$rule" "$RULES_DIR"
  done
fi

if [ "$DO_SKILLS" -eq 1 ]; then
  echo "Skills -> ${SKILLS_DIR}"
  mkdir -p "$SKILLS_DIR"
  for skill in "${REPO_DIR}"/skills/*/; do
    [ -d "$skill" ] || continue
    link_one "${skill%/}" "$SKILLS_DIR"
  done
fi

echo "Done."
