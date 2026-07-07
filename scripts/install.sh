#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"
target="${CODEX_HOME:-$HOME/.codex}/skills"
force=0
dry_run=0
list_only=0
private_root="$repo_root/private"
public_root="$repo_root/public/obsidian-skills/skills"

usage() {
  cat <<'USAGE'
Usage: scripts/install.sh [options]

Link every skill in this repository into ${CODEX_HOME:-$HOME/.codex}/skills.

Options:
  --target DIR   Link into DIR instead of the default skills directory.
  --list         List discovered skills without changing files.
  --force        Replace existing destination entries.
  --dry-run      Print actions without changing files.
  -h, --help     Show this help.
USAGE
}

log() {
  printf '%s\n' "$*"
}

die() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

run_cmd() {
  if [ "$dry_run" -eq 1 ]; then
    printf '[dry-run]'
    printf ' %q' "$@"
    printf '\n'
  else
    "$@"
  fi
}

canonical_dir() {
  local dir="$1"

  [ -d "$dir" ] || return 1
  (cd "$dir" >/dev/null 2>&1 && pwd -P)
}

same_symlink_target() {
  local dest="$1"
  local source_dir="$2"
  local dest_real
  local source_real

  [ -L "$dest" ] || return 1

  dest_real="$(canonical_dir "$dest" 2>/dev/null || true)"
  source_real="$(canonical_dir "$source_dir")"
  [ -n "$dest_real" ] && [ "$dest_real" = "$source_real" ]
}

prepare_destination() {
  local dest="$1"

  if [ ! -e "$dest" ] && [ ! -L "$dest" ]; then
    return
  fi

  if [ "$force" -eq 1 ]; then
    run_cmd rm -rf "$dest"
    return
  fi

  die "$dest already exists. Re-run with --force to replace it."
}

link_skill() {
  local source_dir="$1"
  local label="$2"
  local name
  local dest

  [ -f "$source_dir/SKILL.md" ] || return

  name="$(basename "$source_dir")"
  dest="$target/$name"

  if same_symlink_target "$dest" "$source_dir"; then
    log "Already linked $name ($label)"
    return
  fi

  prepare_destination "$dest"
  run_cmd ln -s "$source_dir" "$dest"
  log "Linked $name ($label)"
}

for_each_skill() {
  local callback="$1"
  local root
  local label
  local dir

  for root in "$private_root" "$public_root"; do
    [ -d "$root" ] || continue

    if [ "$root" = "$private_root" ]; then
      label="private"
    else
      label="public"
    fi

    for dir in "$root"/*; do
      [ -d "$dir" ] || continue
      [ -f "$dir/SKILL.md" ] || continue

      "$callback" "$dir" "$label"
    done
  done
}

list_skill() {
  local source_dir="$1"
  local label="$2"

  printf '%-8s %s\n' "$label" "$(basename "$source_dir")"
}

ensure_public_skills() {
  if [ -d "$public_root" ]; then
    return
  fi

  if [ -d "$repo_root/public/obsidian-skills" ] && command -v git >/dev/null 2>&1; then
    log "Initializing public skill submodule..."
    run_cmd git -C "$repo_root" submodule update --init --recursive public/obsidian-skills
  fi

  if [ "$dry_run" -eq 0 ] && [ ! -d "$public_root" ]; then
    die "public skills not found: $public_root"
  fi
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --target)
      [ "$#" -ge 2 ] || die "--target requires a directory"
      target="$2"
      shift 2
      ;;
    --target=*)
      target="${1#--target=}"
      shift
      ;;
    --list)
      list_only=1
      shift
      ;;
    --force)
      force=1
      shift
      ;;
    --dry-run)
      dry_run=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      die "unknown option: $1"
      ;;
  esac
done

if [ "$list_only" -eq 1 ]; then
  for_each_skill list_skill
  exit 0
fi

ensure_public_skills
run_cmd mkdir -p "$target"
for_each_skill link_skill

log "Done. Target: $target"
