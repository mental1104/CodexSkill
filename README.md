# Codex Skills

Personal Codex skill collection with a split between first-party skills and public upstream skills.

## Layout

- `ROUTER/`: runtime routing skill. It is installed as `${CODEX_HOME:-$HOME/.codex}/skills/ROUTER` when `ROUTER/SKILL.md` exists.
- `private/`: skills maintained directly in this repository.
- `public/obsidian-skills/`: public upstream skills from `kepano/obsidian-skills`, tracked as a git submodule.
- `scripts/install.sh`: links the optional `ROUTER` and every discovered skill into `${CODEX_HOME:-$HOME/.codex}/skills`.

## ChatGPT Chat Skills

These skills are currently written for ChatGPT chat-triggered workflows, not Codex coding or shell-execution workflows.

| Skill | Use when the user wants to... |
|---|---|
| `task-harvest` | turn the current conversation into a small JSON todo list |
| `english-harvest` | extract reusable English expressions from the current conversation |
| `leetcode-archive` | archive a completed LeetCode solving journey into the Obsidian repository, preserving every user code snapshot through the final AC version |
| `github-issue-harvest` | turn a discussion or repository problem into a focused, testable Chinese GitHub Issue |
| `github-pr-harvest` | draft or submit a repository-grounded Chinese PR covering implementation, verification, impact, review focus, and related items |

## Engineering Workflow Skills

| Skill | Use when the user wants to... |
|---|---|
| `dsa-refactor-lifecycle` | refactor an educational data structure or algorithm through compatibility audit, reusable algorithm extraction, teaching adaptation, industrial implementation, integration testing, readability cleanup, and draft PR delivery |

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
| `blue-espeon-note-style` | vault style, directory placement, naming, backlinks, Mermaid convention, single-thesis boundary |
| `latex-math-writing` | LaTeX math notation for calculus, linear algebra, probability/statistics, discrete math, and algorithms |
| `obsidian-frontmatter-metadata` | `source`, `tags`, `summary`, and `read_status` only |
| `source-walk` | source-code context snapshot reports under `/tmp` for ChatGPT analysis |

## Install

Fresh clone:

```bash
git clone --recurse-submodules <repo-url> codex-skills
cd codex-skills
./scripts/install.sh
```

Existing clone:

```bash
git submodule update --init --recursive
./scripts/install.sh
```

The installer creates symlinks, so editing this repository updates the installed skills immediately. It is written for the default Bash and core tools on macOS and Ubuntu.

Useful options:

```bash
./scripts/install.sh --dry-run
./scripts/install.sh --list
./scripts/install.sh --target /path/to/skills
./scripts/install.sh --force
```

If a destination already exists and points somewhere else, the script stops. Re-run with `--force` only when you want to replace those entries.

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