#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

list_tree() {
  local root="$1"
  local label="$2"
  local skill_md

  [ -d "$root" ] || return

  find "$root" -mindepth 2 -maxdepth 2 -type f -name SKILL.md -print | sort | while IFS= read -r skill_md; do
    printf '%-8s %s\n' "$label" "$(basename "$(dirname "$skill_md")")"
  done
}

list_tree "$repo_root/private" private
list_tree "$repo_root/public/obsidian-skills/skills" public
