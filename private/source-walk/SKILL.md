---
name: source-walk
description: Reconstruct the current source-code context for a concrete question and write a self-contained Markdown snapshot report under /tmp for ChatGPT to analyze later. Use when the user asks Codex to inspect a repository, trace relevant files, recover project context, or produce source evidence. This skill does not archive Obsidian notes, modify product code, make final decisions, or perform implementation work.
---

# Source Walk Skill

## Role

This skill is a **context reconstruction layer**.

Its only job is to inspect the current repository or source tree, reconstruct the relevant technical scene, and write a Markdown snapshot report under `/tmp` for ChatGPT to analyze.

Codex acts as the execution and evidence layer.
ChatGPT acts as the discussion, decision, and strategy layer.

## Trigger

Use this skill when the user asks to:

- inspect a code repository;
- trace a source-level mechanism;
- locate relevant files, functions, structs, classes, configs, tests, or scripts;
- reconstruct how a feature, bug, experiment, or requirement is currently represented in code;
- produce source evidence for ChatGPT review;
- create a project snapshot, context packet, or source scene report.

Typical wording:

- “还原一下这个仓库现场”
- “帮我看看这块源码现在是什么情况”
- “追一下这个参数/函数/对象”
- “把当前项目现场整理成报告给 ChatGPT 看”
- “生成一个 source snapshot”

## Non-Goals

This skill must not:

- modify product source code;
- refactor, format, or generate implementation patches;
- create or update Obsidian notes;
- append to existing long-term notes;
- create TODO lists in the user's vault;
- make final architecture decisions;
- recommend broad learning routes;
- run destructive commands;
- write files outside `/tmp`, except when the user explicitly overrides the output path.

If the user asks for decisions, tradeoffs, design choice, or next-step strategy, reconstruct the local context and put the evidence in the snapshot report. Do not decide for the user.

## Output Location

Always write one Markdown report under `/tmp`.

Default filename:

```text
/tmp/<repo-or-topic>-source-snapshot-YYYYMMDD-HHMMSS.md
```

Rules:

1. Create a new snapshot file for each run.
2. Do not append to old reports by default.
3. Do not write into Obsidian vaults.
4. Do not create deep directory trees.
5. If the user explicitly provides an output path, still prefer `/tmp` unless they clearly require another path.

## Workflow

1. Identify the user's concrete question.
2. Identify the repository root or source root.
3. Capture basic repository state:
   - current directory;
   - git branch and commit when available;
   - dirty working tree summary when available;
   - relevant top-level layout.
4. Locate the minimum relevant source files.
5. Read only enough code, config, scripts, tests, and docs to reconstruct the current scene.
6. Record concrete evidence with file paths and line numbers.
7. Write the snapshot report to `/tmp`.
8. Respond to the user only with the report path and a short summary of what was captured.

## Inspection Rules

Prefer read-only commands such as:

```bash
pwd
git rev-parse --show-toplevel
git status --short
git branch --show-current
git rev-parse HEAD
find . -maxdepth 3 -type f
rg -n "keyword|symbol|error|function"
sed -n 'START,ENDp' file
```

Do not run build, test, install, migration, cleanup, format, or generation commands unless the user explicitly asks. If such commands would help, mention them in the report as optional validation, but do not run them.

## Evidence Policy

## Remote Repository Boundary

This skill is local-source-first. It may inspect the current checkout with read-only filesystem and Git metadata commands, but it must not invoke GitHub API/connector tools, create or update Issues/PRs, publish review comments, or run `git push`.

If required evidence exists only on GitHub, delegate the smallest remote read to `github-operations`, then continue the snapshot from the returned evidence.


Every important claim in the report must be backed by evidence.

Use:

- repository-relative file paths;
- line numbers or line ranges;
- symbol names;
- short code excerpts only when necessary;
- command outputs only when they help reconstruct the scene.

Do not paste huge files. Quote focused snippets only.

Default to repository-relative local paths and line numbers. If a stable remote permalink or other GitHub-only evidence is required, request it through `github-operations`; this skill must not invoke GitHub tools directly.

## Report Shape

Write the report using this structure:

```markdown
# <topic> Source Snapshot

## 1. Snapshot Metadata

- Created at: <local datetime>
- Repository root: `<path>`
- Branch: `<branch or unknown>`
- Commit: `<commit or unknown>`
- Working tree: <clean / dirty summary / unknown>
- User question: <original or normalized question>

## 2. Scope

This report reconstructs:

- <what was inspected>
- <what was intentionally not inspected>

## 3. Current Scene Summary

- <fact 1 with evidence>
- <fact 2 with evidence>
- <fact 3 with evidence>

## 4. Relevant File Map

| Area | File | Why it matters |
|---|---|---|
| ... | `path` | ... |

## 5. Key Source Evidence

| Order | Location | Evidence | Meaning |
|---:|---|---|---|
| 1 | `path:line-line` | `<symbol / condition / call / config>` | ... |

## 6. Reconstructed Flow

Use a small tree, sequence, or Mermaid diagram only when it makes the scene easier for ChatGPT to analyze.

```text
entry_or_question
├── relevant_file_or_symbol
└── relevant_file_or_symbol
```

## 7. Boundaries And Uncertainties

- <what is uncertain>
- <what was not verified>
- <what may need a runtime test or human decision>

## 8. Suggested Questions For ChatGPT

- <question 1>
- <question 2>
- <question 3>
```

## Diagram Policy

Diagrams are optional.

Use a diagram only when it clarifies:

- control flow;
- data flow;
- lifecycle;
- ownership;
- async callback flow;
- state transition;
- module relationships.

Keep diagrams small: 5-9 nodes by default. Split large diagrams. Do not create decorative diagrams.

## Chat Response Policy

After writing the report, respond with only:

```text
已生成现场快照报告：/tmp/<file>.md

本次捕获：<1-3 bullets>
```

Do not paste the full report into chat unless the user asks.
Do not add broad advice.
Do not propose unrelated next steps.

## Minimal Success Criteria

A successful run must produce:

1. one Markdown report under `/tmp`;
2. repository metadata when available;
3. relevant file map;
4. source evidence with paths and line numbers;
5. reconstructed current scene;
6. boundaries and uncertainties;
7. suggested questions for ChatGPT;
8. no product code changes;
9. no Obsidian note writes.

## Good Example

User:

```text
帮我还原 FastAPI 这块执行器封装的源码现场，给 ChatGPT 分析。
```

Expected behavior:

- inspect relevant FastAPI/project files;
- find executor wrapper, route usage, tests, configs;
- write `/tmp/<repo>-executor-source-snapshot-<timestamp>.md`;
- respond only with the report path and 1-3 captured points.

## Bad Example

Wrong behavior:

- modify the executor implementation;
- create an Obsidian archive note;
- generate a long design recommendation in chat;
- run tests or benchmarks without being asked;
- expand into a general FastAPI concurrency tutorial.
