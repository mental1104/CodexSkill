#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"
target="${CODEX_HOME:-$HOME/.codex}/skills"
force=0
dry_run=0
list_only=0
enterprise=0
router_root="$repo_root/ROUTER"
private_root="$repo_root/private"
public_root="$repo_root/public/obsidian-skills/skills"

# 打印安装脚本帮助；企业模式只安装经过显式审计的 allowlist Skill。
usage() {
  cat <<'USAGE'
Usage: scripts/install.sh [options]

Link the optional repository ROUTER and discovered skills into ${CODEX_HOME:-$HOME/.codex}/skills.

Options:
  --target DIR   Link into DIR instead of the default skills directory.
  --list         List skills selected by the current install mode without changing files.
  --enterprise   Install only the audited enterprise-safe Skill allowlist.
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

# 判断一个 Skill 是否进入企业安全 allowlist。
#
# 参数：
#   $1: Skill 来源标签，例如 private、public 或 router。
#   $2: Skill 目录名。
# 返回：
#   0 表示允许企业模式安装；非 0 表示跳过。
#
# 新增 Skill 默认不进入企业环境，必须经过单独安全审计后显式加入此处。
# github-operations 及可执行 GitHub 写入的专项 Skill 故意不在企业 allowlist 中；
# github-actions-ci-policy 仅包含规则约束，不执行远程 GitHub 操作，因此可以安装。
is_enterprise_safe_skill() {
  local label="$1"
  local name="$2"

  case "$label" in
    private)
      case "$name" in
        archive-code-demand-note|blue-espeon-note-style|book-operation-manual-extract|calendar-harvest|code-comment-writing|code-walkthrough-review|english-harvest|github-actions-ci-policy|latex-math-writing|note-code-walkthrough|note-cognitive-convergence|note-conclusion-evidence|note-linear-achievement|note-operation-manual|obsidian-frontmatter-metadata|source-walk|task-harvest)
          return 0
          ;;
      esac
      ;;
    public)
      case "$name" in
        defuddle|json-canvas|knap|obsidian-bases|obsidian-cli|obsidian-markdown)
          return 0
          ;;
      esac
      ;;
  esac

  return 1
}

# 遍历当前安装模式允许的 Skill，并把目录与来源标签交给回调函数。
#
# 参数：
#   $1: 回调函数名；回调接收 source_dir 和 label 两个参数。
# 副作用：
#   普通模式遍历 ROUTER、private 和 public；企业模式遍历 private/public 中显式 allowlist 的 Skill。
for_each_skill() {
  local callback="$1"
  local root
  local label
  local dir
  local name

  if [ "$enterprise" -eq 0 ] && [ -f "$router_root/SKILL.md" ]; then
    "$callback" "$router_root" router
  fi

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

      name="$(basename "$dir")"
      if [ "$enterprise" -eq 1 ] && ! is_enterprise_safe_skill "$label" "$name"; then
        continue
      fi

      "$callback" "$dir" "$label"
    done
  done
}

list_skill() {
  local source_dir="$1"
  local label="$2"

  printf '%-8s %s\n' "$label" "$(basename "$source_dir")"
}

# 确保需要的 public Skill 子模块存在。
#
# 普通模式和企业模式都可能安装 public Skill；企业模式仍会在遍历阶段应用显式 allowlist。
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
    --enterprise)
      enterprise=1
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
