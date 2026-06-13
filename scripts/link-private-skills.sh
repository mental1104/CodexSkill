#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"
installer="$script_dir/install.sh"
default_target="${CODEX_HOME:-$HOME/.codex}/skills"

targets=()
dry_run=0
force=0
backup_existing=1

usage() {
  cat <<'USAGE'
Usage: scripts/link-private-skills.sh [options]

Link this repository's private skills into Codex runtime skill directories.

By default this links private/* into:
  ${CODEX_HOME:-$HOME/.codex}/skills

Options:
  --target DIR       Link private skills into DIR. Can be used multiple times.
  --workspace DIR    Link private skills into DIR/.codex/skills.
  --here             Link private skills into ./.codex/skills from the current directory.
  --global           Also link into ${CODEX_HOME:-$HOME/.codex}/skills.
  --no-backup        Fail if an existing destination already exists.
  --force            Remove existing destinations instead of backing them up.
  --dry-run          Print actions without changing files.
  -h, --help         Show this help.

Examples:
  scripts/link-private-skills.sh
  scripts/link-private-skills.sh --target "$HOME/.codex/skills"
  scripts/link-private-skills.sh --workspace "/path/to/project"
  scripts/link-private-skills.sh --global --workspace "/path/to/project"
USAGE
}

die() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

add_target() {
  local target="$1"
  local existing

  [ -n "$target" ] || die "target cannot be empty"

  for existing in "${targets[@]}"; do
    [ "$existing" = "$target" ] && return
  done

  targets+=("$target")
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --target)
      [ "$#" -ge 2 ] || die "--target requires a directory"
      add_target "$2"
      shift 2
      ;;
    --target=*)
      add_target "${1#--target=}"
      shift
      ;;
    --workspace)
      [ "$#" -ge 2 ] || die "--workspace requires a directory"
      add_target "$2/.codex/skills"
      shift 2
      ;;
    --workspace=*)
      add_target "${1#--workspace=}/.codex/skills"
      shift
      ;;
    --here)
      add_target "$PWD/.codex/skills"
      shift
      ;;
    --global)
      add_target "$default_target"
      shift
      ;;
    --no-backup)
      backup_existing=0
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

[ -x "$installer" ] || die "installer is not executable: $installer"
[ -d "$repo_root/private" ] || die "private directory not found: $repo_root/private"

if [ "${#targets[@]}" -eq 0 ]; then
  add_target "$default_target"
fi

for target in "${targets[@]}"; do
  args=(--private-only --mode symlink --target "$target")

  if [ "$dry_run" -eq 1 ]; then
    args+=(--dry-run)
  fi

  if [ "$force" -eq 1 ]; then
    args+=(--force)
  fi

  if [ "$backup_existing" -eq 0 ]; then
    args+=(--no-backup)
  fi

  printf 'Linking private skills into %s\n' "$target"
  "$installer" "${args[@]}"
done
