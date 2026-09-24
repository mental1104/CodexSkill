# Codex Skills

Personal Codex skill collection with a split between first-party skills and public upstream skills.

## Layout

- `ROUTER/`: runtime routing skill. It is installed as `${CODEX_HOME:-$HOME/.codex}/skills/ROUTER` when `ROUTER/SKILL.md` exists.
- `private/`: skills maintained directly in this repository.
- `public/obsidian-skills/`: public upstream skills from `kepano/obsidian-skills`, tracked as a git submodule.
- `install.sh`: root-level installer. By default it links only the audited enterprise-safe Skill allowlist into `${CODEX_HOME:-$HOME/.codex}/skills`; pass `--all` to install `ROUTER` and every discovered Skill.

## Mandatory Coding Skill

`code-comment-writing` is a mandatory companion skill for both ChatGPT and Codex whenever a request creates, modifies, refactors, fixes, or outputs executable code.

It requires:

- Chinese-first documentation for every class, function, method, parameter, and return value;
- explicit comments for short-circuit, mainline, failure, state, concurrency, and performance-sensitive paths;
- language-appropriate docstrings or documentation comments;
- a final comment-quality review before code is considered complete.

The skill enables implicit invocation through `private/code-comment-writing/agents/openai.yaml`. It should be loaded alongside repository-specific and task-specific coding skills rather than replacing them.

## ChatGPT Chat Skills

The following skills are primarily written for ChatGPT chat-triggered workflows rather than general Codex coding or shell-execution workflows.

| Skill | Use when the user wants to... |
|---|---|
| `personal-vault-retrieval` | retrieve personal notes, archived conclusions, previous experiments, project documents, technical routes, tasks, or roadmaps from `mental1104/Obsidian` |
| `task-harvest` | turn the current conversation into a small JSON todo list |
| `calendar-harvest` | turn a short natural-language schedule request into a deterministic five-field calendar-event JSON array |
| `english-harvest` | extract reusable English expressions from the current conversation |
| `leetcode-archive` | archive a completed LeetCode solving journey into the Obsidian repository, preserving every user code snapshot through the final AC version |
| `github-operations` | act as the single gateway for GitHub remote reads/writes, Issue/PR mutations, review publication, and push |
| `github-issue-harvest` | turn a discussion or repository problem into a focused, testable Chinese GitHub Issue payload |
| `github-pr-harvest` | draft repository-grounded Chinese PR content covering implementation, verification, impact, review focus, and related items |
| `github-pr-dialogue-review` | define conversational PR review semantics, anchors, thread reuse, and comment payloads |
| `code-walkthrough-review` | build a scoped source context from a business journey, answer walkthrough questions without unsolicited expansion, and review maintainability concerns one item at a time |

`personal-vault-retrieval` treats the private `mental1104/Obsidian` repository on `main` as the source of truth for the user's archived experiments, benchmarks, profiling results, project documents, learning records, technical routes, tasks, and roadmaps. It searches exact terms before broader variants, cites real paths, preserves privacy, and distinguishes vault conclusions from inference and assistant suggestions.

`github-operations` is the only GitHub execution boundary. Generic skills may request repository/PR/Issue evidence or prepare mutation payloads, but they do not invoke GitHub tools or `git push` directly. The Issue/PR specialist skills own content and review semantics; `github-operations` verifies the target and authorization and performs the remote operation.

`github-pr-dialogue-review` binds a PR and current head SHA as a review model, reuses inline-thread semantics, refreshes anchors after new evidence, and sends authorized remote operations through `github-operations`.

`code-walkthrough-review` uses a business request, message, task, or lifecycle as the reading boundary. It establishes a compact context map, automatically anchors pasted fragments when repository evidence permits, applies maintainability gates with explicit exceptions, and keeps candidate concerns in a version-bound one-item dialogue queue. The included `references/chatgpt-project-prompt.md` is repository-agnostic and can be copied into a ChatGPT Project.

## Workflow Skills

| Skill | Use when the user wants to... |
|---|---|
| `note-work-delivery` | advance unchecked work from one Obsidian note through GitHub issues and PRs when frontmatter `source` names a GitHub repository, or directly in ChatGPT when it does not |

`note-work-delivery` is invoked directly by requests such as “推进这篇笔记里的待办”. It keeps execution orchestration separate from the archive `ROUTER`; once work is accepted, final source-note refresh is handed back through `ROUTER` and the selected transform-mode note skill.

## Active Note Skills

The Obsidian note system is organized by future reading intention, not by "general vs technical" topic category.

| Skill | Use when the future reader wants to... |
|---|---|
| `note-linear-achievement` | understand how a goal was reached step by step |
| `note-conclusion-evidence` | read conclusions first, then drill down into verification and raw evidence |
| `note-operation-manual` | follow the shortest repeatable procedure without reading theory |
| `note-code-walkthrough` | understand a concrete class, module, or component from application usage through internals, lifecycle, state changes, and tests |

`note-code-walkthrough` supports:

- `repository-mode` for a local or GitHub repository, branch, tag, or commit;
- `transform-mode` for rewriting an existing code note;
- `materialize-mode` for turning current analysis or a source snapshot into a durable walkthrough.

Helper skills:

| Skill | Narrow responsibility |
|---|---|
| `code-comment-writing` | mandatory Chinese-first documentation and critical-path comments for code creation and modification |\n| `python-code-style` | personal Python static-analysis-first, typed-boundary, read-only-input, and visible-state-change conventions |
| `blue-espeon-note-style` | vault style, directory placement, naming, backlinks, Mermaid convention, single-thesis boundary |
| `latex-math-writing` | LaTeX math notation for calculus, linear algebra, probability/statistics, discrete math, and algorithms |
| `obsidian-frontmatter-metadata` | `source`, `tags`, `summary`, and `read_status` only |
| `source-walk` | source-code context snapshot reports under `/tmp` for ChatGPT analysis |

## Install

Fresh clone:

```bash
git clone https://github.com/mental1104/CodexSkill.git
cd CodexSkill
./install.sh
```

The installer initializes and synchronizes the public Skill submodule automatically, so a separate recursive clone or manual submodule update is not required for normal installation.

For an existing clone, the fast update path is:

```bash
git pull --ff-only
./install.sh
```

The installer creates symlinks, so repository updates immediately flow through to installed first-party skills. Running the installer after each pull also refreshes the public submodule to the revision recorded by the repository.

### Default Safe Install

Running `./install.sh` with no mode flag uses the audited default-deny enterprise-safe allowlist.

It excludes:

- `ROUTER`
- `github-operations`
- `github-issue-harvest`
- `github-pr-dialogue-review`
- `github-pr-harvest`
- `home-lan-device-ops`
- `leetcode-archive`
- `note-work-delivery`
- `personal-vault-retrieval`

The remaining currently reviewed private skills are allowed, including `python-code-style`, `cpp-code-style`, `code-comment-writing`, `source-walk`, `code-walkthrough-review`, note/harvest helpers, and other coding policy skills.

The currently reviewed public `kepano/obsidian-skills` skills are also allowlisted:

- `defuddle`
- `json-canvas`
- `knap`
- `obsidian-bases`
- `obsidian-cli`
- `obsidian-markdown`

New private or public skills are not installed by default until they are explicitly added to the allowlist in `install.sh` after review.

When the default mode runs after an earlier `--all` installation, it removes only disallowed symlinks that still point back into this repository. It does not delete unrelated user-managed files or directories.

### Install Everything

To install `ROUTER` and every discovered private/public Skill:

```bash
./install.sh --all --list
./install.sh --all
```

The legacy `--enterprise` flag remains accepted as a compatibility alias for the default safe mode.

Useful options:

```bash
./install.sh --dry-run
./install.sh --list
./install.sh --target /path/to/skills
./install.sh --force
```

If a destination already contains the same Skill name, the installer replaces that file, directory, or symlink automatically. A symlink that already points to the correct source is kept unchanged. `--force` remains accepted for backward compatibility but is no longer required.

## Update Public Skills

```bash
git submodule update --remote public/obsidian-skills
git add public/obsidian-skills
git commit -m "Update public obsidian skills"
```

## Push A New GitHub Repository

After creating an empty GitHub repository:

```bash
git remote add origin <repo-url>
git push -u origin main
```
