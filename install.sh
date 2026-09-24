#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
target="${CODEX_HOME:-$HOME/.codex}/skills"
dry_run=0
list_only=0
install_all=0
router_root="$repo_root/ROUTER"
private_root="$repo_root/private"
public_root="$repo_root/public/obsidian-skills/skills"

# 打印安装脚本帮助。
#
# 默认模式使用经过审计的 enterprise-safe allowlist；只有显式传入 --all
# 才安装 ROUTER 和仓库中发现的全部 Skill。
usage() {
  cat <<'USAGE'
Usage: ./install.sh [options]

Link repository skills into ${CODEX_HOME:-$HOME/.codex}/skills.
By default, only the audited enterprise-safe allowlist is installed.

Options:
  --target DIR   Link into DIR instead of the default skills directory.
  --list         List skills selected by the current install mode without changing files.
  --all          Install ROUTER and every discovered private/public Skill.
  --enterprise   Compatibility flag for the default audited allowlist mode.
  --force        Compatibility flag; existing destination entries are replaced by default.
  --dry-run      Print actions without changing files.
  -h, --help     Show this help.
USAGE
}

# 输出一行普通安装日志。
#
# 参数：
#   $@: 要输出的日志内容。
log() {
  printf '%s\n' "$*"
}

# 输出错误并立即终止安装。
#
# 参数：
#   $@: 错误说明。
die() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

# 执行安装命令；dry-run 模式下只打印命令而不产生副作用。
#
# 参数：
#   $@: 待执行的命令及参数。
run_cmd() {
  if [ "$dry_run" -eq 1 ]; then
    printf '[dry-run]'
    printf ' %q' "$@"
    printf '\n'
  else
    "$@"
  fi
}

# 返回目录解析符号链接后的规范绝对路径。
#
# 参数：
#   $1: 待解析目录。
# 返回：
#   目录存在时输出规范路径并返回 0；目录不存在时返回非 0。
canonical_dir() {
  local dir="$1"

  [ -d "$dir" ] || return 1
  (cd "$dir" >/dev/null 2>&1 && pwd -P)
}

# 判断目标软链是否已经指向给定 Skill 来源目录。
#
# 参数：
#   $1: 目标软链路径。
#   $2: Skill 来源目录。
# 返回：
#   指向同一规范目录时返回 0，否则返回非 0。
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

# 为即将安装的 Skill 准备目标路径。
#
# 参数：
#   $1: 目标 Skill 路径，例如 ~/.codex/skills/<skill-name>。
# 副作用：
#   若目标已存在，无论是目录、文件还是软链，都会先删除再由调用方创建新软链。
#   正确指向当前来源的软链会在 link_skill 中提前返回，不会进入本函数。
prepare_destination() {
  local dest="$1"

  if [ ! -e "$dest" ] && [ ! -L "$dest" ]; then
    return
  fi

  # Skill 安装目录中的同名项视为旧安装，默认直接替换，保证重复安装和升级无需额外参数。
  run_cmd rm -rf "$dest"
}

# 将一个包含 SKILL.md 的目录链接到 Codex Skill 目录。
#
# 参数：
#   $1: Skill 来源目录。
#   $2: 来源标签，例如 router、private 或 public。
# 副作用：
#   创建或替换目标 Skill 软链。
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

# 判断一个 Skill 是否进入默认 enterprise-safe allowlist。
#
# 参数：
#   $1: Skill 来源标签，例如 private 或 public。
#   $2: Skill 目录名。
# 返回：
#   0 表示默认安装；非 0 表示只有 --all 模式才安装。
#
# 新增 Skill 默认不进入安全安装集合，必须经过单独审计后显式加入此处。
# github-operations 及可执行 GitHub 写入的专项 Skill 故意不在 allowlist 中；
# github-actions-ci-policy 仅包含规则约束，不执行远程 GitHub 操作，因此可以安装。
is_enterprise_safe_skill() {
  local label="$1"
  local name="$2"

  case "$label" in
    private)
      case "$name" in
        archive-code-demand-note|blue-espeon-note-style|book-operation-manual-extract|calendar-harvest|code-comment-writing|cpp-code-style|code-walkthrough-review|english-harvest|github-actions-ci-policy|latex-math-writing|note-code-walkthrough|note-cognitive-convergence|note-conclusion-evidence|note-linear-achievement|note-operation-manual|obsidian-frontmatter-metadata|python-code-style|source-walk|task-harvest)
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

# 遍历仓库中实际存在的全部 Skill。
#
# 参数：
#   $1: 回调函数名；回调接收 source_dir 和 label 两个参数。
# 副作用：
#   依次调用回调，不改变 Skill 选择策略。
for_each_repo_skill() {
  local callback="$1"
  local root
  local label
  local dir

  if [ -f "$router_root/SKILL.md" ]; then
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
      "$callback" "$dir" "$label"
    done
  done
}

# 遍历当前安装模式选中的 Skill。
#
# 参数：
#   $1: 回调函数名；回调接收 source_dir 和 label 两个参数。
# 副作用：
#   --all 模式遍历全部 Skill；默认模式只遍历 enterprise-safe allowlist。
for_each_selected_skill() {
  local callback="$1"
  local root
  local label
  local dir
  local name

  if [ "$install_all" -eq 1 ]; then
    for_each_repo_skill "$callback"
    return
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
      if is_enterprise_safe_skill "$label" "$name"; then
        "$callback" "$dir" "$label"
      fi
    done
  done
}

# 删除由本仓库安装、但不属于默认安全集合的旧软链。
#
# 参数：
#   $1: Skill 来源目录。
#   $2: 来源标签。
# 副作用：
#   仅当目标是指回本仓库当前 Skill 的软链时才删除，不触碰用户自己维护的同名文件或目录。
remove_disallowed_repo_link() {
  local source_dir="$1"
  local label="$2"
  local name
  local dest

  [ "$install_all" -eq 0 ] || return

  name="$(basename "$source_dir")"
  if [ "$label" != "router" ] && is_enterprise_safe_skill "$label" "$name"; then
    return
  fi

  dest="$target/$name"
  if same_symlink_target "$dest" "$source_dir"; then
    run_cmd rm -f "$dest"
    log "Removed $name ($label; not selected by default)"
  fi
}

# 输出一个被当前模式选中的 Skill。
#
# 参数：
#   $1: Skill 来源目录。
#   $2: 来源标签。
list_skill() {
  local source_dir="$1"
  local label="$2"

  printf '%-8s %s\n' "$label" "$(basename "$source_dir")"
}

# 将 public Skill 子模块同步到主仓库记录的 revision。
#
# 这样主仓库执行 git pull 后，再运行 ./install.sh 就能同时刷新 public Skill，
# 不需要用户额外记住 git submodule update。
#
# 副作用：
#   在 Git 工作树中初始化或更新 public/obsidian-skills 子模块。
sync_public_skills() {
  if command -v git >/dev/null 2>&1 &&
     git -C "$repo_root" rev-parse --git-dir >/dev/null 2>&1; then
    log "Syncing public skill submodule..."
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
    --all)
      install_all=1
      shift
      ;;
    --enterprise)
      # 兼容旧调用；enterprise-safe allowlist 现在已经是默认模式。
      install_all=0
      shift
      ;;
    --force)
      # 兼容旧调用；覆盖现有同名 Skill 已经是默认行为。
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
  for_each_selected_skill list_skill
  exit 0
fi

sync_public_skills
run_cmd mkdir -p "$target"

if [ "$install_all" -eq 0 ]; then
  # 清理此前 --all 安装留下的仓库自有高权限 Skill，保证默认模式真正回到安全集合。
  for_each_repo_skill remove_disallowed_repo_link
fi

for_each_selected_skill link_skill

log "Done. Target: $target"
