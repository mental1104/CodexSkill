#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
target="${CODEX_HOME:-$HOME/.codex}/skills"
mode="symlink"
install_private=1
install_public=1
backup_existing=1
force=0
dry_run=0
timestamp="$(date +%Y%m%d-%H%M%S)"

usage() {
  cat <<'USAGE'
Usage: scripts/install.sh [options]

Install Codex skills into ${CODEX_HOME:-$HOME/.codex}/skills.

Options:
  --target DIR       Install into DIR instead of the default skills directory.
  --mode MODE        Install mode: symlink or copy. Default: symlink.
  --private-only     Install only private skills.
  --public-only      Install only public submodule skills.
  --no-private       Skip private skills.
  --no-public        Skip public skills.
  --no-backup        Fail if a destination already exists.
  --force            Remove existing destinations instead of backing them up.
  --dry-run          Print actions without changing files.
  -h, --help         Show this help.
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

next_backup_path() {
  local dest="$1"
  local candidate="${dest}.backup-${timestamp}"
  local i=1

  while [ -e "$candidate" ] || [ -L "$candidate" ]; do
    candidate="${dest}.backup-${timestamp}-${i}"
    i=$((i + 1))
  done

  printf '%s\n' "$candidate"
}

same_symlink_target() {
  local dest="$1"
  local source_dir="$2"

  [ -L "$dest" ] || return 1

  if [ "$(readlink "$dest")" = "$source_dir" ]; then
    return 0
  fi

  if command -v realpath >/dev/null 2>&1; then
    [ "$(realpath "$dest" 2>/dev/null || true)" = "$(realpath "$source_dir")" ]
    return
  fi

  return 1
}

prepare_destination() {
  local dest="$1"
  local backup

  if [ ! -e "$dest" ] && [ ! -L "$dest" ]; then
    return
  fi

  if [ "$force" -eq 1 ]; then
    run_cmd rm -rf -- "$dest"
    return
  fi

  if [ "$backup_existing" -eq 1 ]; then
    backup="$(next_backup_path "$dest")"
    run_cmd mv -- "$dest" "$backup"
    log "Backed up existing $(basename "$dest") to $backup"
    return
  fi

  die "$dest already exists. Re-run with --force or allow backups."
}

install_skill() {
  local source_dir="$1"
  local label="$2"
  local name
  local dest

  [ -f "$source_dir/SKILL.md" ] || return

  name="$(basename "$source_dir")"
  dest="$target/$name"

  if same_symlink_target "$dest" "$source_dir"; then
    log "Already installed $name ($label)"
    return
  fi

  prepare_destination "$dest"

  if [ "$mode" = "symlink" ]; then
    run_cmd ln -s "$source_dir" "$dest"
  else
    run_cmd cp -a "$source_dir" "$dest"
  fi

  log "Installed $name ($label)"
}

install_tree() {
  local root="$1"
  local label="$2"
  local skill_md

  [ -d "$root" ] || return

  find "$root" -mindepth 2 -maxdepth 2 -type f -name SKILL.md -print | sort | while IFS= read -r skill_md; do
    install_skill "$(dirname "$skill_md")" "$label"
  done
}

ensure_public_submodule() {
  local public_root="$repo_root/public/obsidian-skills/skills"

  if [ "$install_public" -eq 0 ]; then
    return
  fi

  if [ -d "$public_root" ]; then
    return
  fi

  if command -v git >/dev/null 2>&1; then
    log "Initializing public skill submodule..."
    run_cmd git -C "$repo_root" submodule update --init --recursive public/obsidian-skills
  fi

  if [ "$dry_run" -eq 0 ] && [ ! -d "$public_root" ]; then
    die "public/obsidian-skills is not initialized"
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
    --mode)
      [ "$#" -ge 2 ] || die "--mode requires symlink or copy"
      mode="$2"
      shift 2
      ;;
    --mode=*)
      mode="${1#--mode=}"
      shift
      ;;
    --private-only)
      install_private=1
      install_public=0
      shift
      ;;
    --public-only)
      install_private=0
      install_public=1
      shift
      ;;
    --no-private)
      install_private=0
      shift
      ;;
    --no-public)
      install_public=0
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

case "$mode" in
  symlink|copy) ;;
  *) die "--mode must be symlink or copy" ;;
esac

run_cmd mkdir -p "$target"
ensure_public_submodule

if [ "$install_private" -eq 1 ]; then
  install_tree "$repo_root/private" private
fi

if [ "$install_public" -eq 1 ]; then
  install_tree "$repo_root/public/obsidian-skills/skills" public
fi

log "Done. Target: $target"
