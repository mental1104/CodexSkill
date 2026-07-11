---
name: ROUTER
description: Routing layer for Codex skills. Use to choose one primary skill and mode before creating or transforming Obsidian notes. This router does not write notes itself.
---

# Codex Skill Router

## Role

ROUTER only chooses the route.

It decides:

1. input source;
2. note shape;
3. target skill;
4. mode;
5. whether confirmation is needed.

It does not write the final note.

## Helper Skills

- `blue-espeon-note-style`: vault style, placement, naming, backlinks, Mermaid convention, and single-thesis boundary.
- `obsidian-frontmatter-metadata`: `summary`, `aliases`, and `tags` only.
- `source-walk`: source-code context snapshot report under `/tmp` for ChatGPT analysis.

## Specialized Front-End Skills

### `book-operation-manual-extract`

Use before `note-operation-manual` when the source is a book chapter, reading note, tutorial note, or book-specific project context and the user wants reusable executable procedures.

This skill decides what to extract, skip, deduplicate, merge, or backlink.

Signals:

- “从书籍笔记里提取操作手册”
- “从阅读笔记里抽取可复用步骤”
- “把这章整理成可执行操作手册”
- “只提取未来能直接执行的命令和代码块”
- “不适合抽离的跳过”
- “先查已有笔记去重”
- “能合并就合并，不要重复新建”
- “如果已有同主题手册，就更新已有笔记”

Default route:

1. Use `book-operation-manual-extract` for extraction, skip decision, deduplication, and merge strategy.
2. Use `note-operation-manual` for the final manual structure.

### `source-walk` Before `note-code-walkthrough`

Use `source-walk` first only when the user wants a separate source snapshot, the note writer cannot inspect the repository directly, or repository evidence must be reconstructed before the final walkthrough is written.

Default route:

1. Use `source-walk` to create a temporary evidence packet under `/tmp`.
2. Use `note-code-walkthrough` in `materialize-mode` to create the final Obsidian note from that packet plus any current repository evidence.

Do not require `source-walk` when `note-code-walkthrough` can inspect the repository directly in `repository-mode`.

## Input Source

### `transform-mode`

Use when the user provides or points to an existing Markdown note.

Signals:

- “改造这篇旧笔记”
- “优化这个 md”
- “把这篇笔记转成...”
- “基于这个已有笔记整理”

Default: inspect the note, recommend a route, then wait for confirmation unless the user explicitly asked to write directly.

### `materialize-mode`

Use when the user wants to turn current context, chat history, experiment output, terminal output, Codex results, or a source snapshot into a new note.

Signals:

- “把刚才这轮归档成笔记”
- “生成一篇笔记”
- “沉淀成文档”
- “把这个实验结果归档”
- “把这份源码现场报告整理成笔记”

Default: infer the route and proceed when obvious.

### `repository-mode`

Use when the primary source of truth is a local checkout, GitHub repository, open-source repository, branch, tag, or commit and the user wants a repository-grounded code walkthrough note.

Signals:

- “读这个仓库并生成代码走读笔记”
- “基于当前分支整理这个类”
- “按这个 commit 归档源码实现”
- “把这个开源仓库的模块梳理清楚”
- “从应用调用到测试完整走读”

Default: resolve repository, branch/tag, commit, target symbol, callers, dependencies, tests, and build status, then use `note-code-walkthrough` directly.

## Note Shape

### `note-linear-achievement`

Use when the future reader wants to understand how a goal was reached step by step.

Signals: goal, attempts, failures, observations, turning points, final path.

### `note-conclusion-evidence`

Use when the future reader wants conclusions first, then optional drill-down into verification and raw evidence.

Signals: conclusions, claims, verification, metrics, evidence, raw commands, outputs, screenshots, source snippets.

### `note-operation-manual`

Use when the future reader wants to perform an operation without understanding the whole exploration or theory.

Signals: fixed procedure, setup steps, commands, expected output, common errors, rollback, cleanup.

### `note-code-walkthrough`

Use when the future reader wants to understand one concrete class, module, component, or tightly scoped mechanism from outside to inside.

Required cognitive path:

```text
application relevance
→ thin upper-layer calling slice
→ real public usage
→ declaration and construction/destruction
→ public behavior
→ private responsibilities
→ member-state changes
→ complete lifecycle and state branches
→ test infrastructure and behavioral proof
```

Signals:

- code walkthrough or source walkthrough;
- repository, branch, tag, commit, class, module, component, implementation;
- public/private methods, constructor/destructor, member state;
- callers, call chain, lifecycle, state machine;
- fixtures, harnesses, test cases, coverage matrix;
- “按人的认知顺序读代码”;
- “把应用层到内部实现打穿”;
- “把这个类和测试完整归档”.

Do not route a repository-backed code walkthrough to `note-linear-achievement` merely because the implementation has an execution order. Choose by future reading intention, not by the presence of a sequence.

## Routing Table

| Input source | Note shape | Target skill | Mode |
|---|---|---|---|
| Existing note | Linear achievement | `note-linear-achievement` | `transform-mode` |
| Existing note | Conclusion evidence | `note-conclusion-evidence` | `transform-mode` |
| Existing note | Operation manual | `note-operation-manual` | `transform-mode` |
| Existing code note | Code walkthrough | `note-code-walkthrough` | `transform-mode` |
| Book or reading note | Operation manual extraction | `book-operation-manual-extract` → `note-operation-manual` | `transform-mode` |
| Current context | Linear achievement | `note-linear-achievement` | `materialize-mode` |
| Current context | Conclusion evidence | `note-conclusion-evidence` | `materialize-mode` |
| Current context | Operation manual | `note-operation-manual` | `materialize-mode` |
| Current context or source snapshot | Code walkthrough | `note-code-walkthrough` | `materialize-mode` |
| Repository / branch / tag / commit | Code walkthrough | `note-code-walkthrough` | `repository-mode` |
| Repository evidence packet required first | Code walkthrough | `source-walk` → `note-code-walkthrough` | snapshot → `materialize-mode` |

## Route Decision Output

When route confirmation is useful, output:

```markdown
## 路线判断

- 输入来源：已有笔记 / 当前上下文 / 代码仓库
- 推荐类型：线性达成型 / 结论证据型 / 操作手册型 / 代码走读型
- 执行模式：transform-mode / materialize-mode / repository-mode
- 目标 Skill：`<skill-name>`
- 理由：
  - ...
  - ...
- 前置 Skill：`source-walk` / `book-operation-manual-extract` / 无
- 可选路线：
  - ...

是否按这个路线执行？
```

## Tie-Breaking Rules

1. Preserve process: choose `note-linear-achievement`.
2. Preserve belief and proof: choose `note-conclusion-evidence`.
3. Preserve repeatable action: choose `note-operation-manual`.
4. Preserve an implementation model from application call chain through internals and tests: choose `note-code-walkthrough`.
5. If the source is a book or reading note and the user asks for reusable executable steps, choose `book-operation-manual-extract` before `note-operation-manual`.
6. If the source is a repository and the reader wants only temporary evidence for ChatGPT, choose `source-walk`; if the reader wants a durable Obsidian walkthrough, choose `note-code-walkthrough`.
7. If a code note mainly preserves how a bug was discovered and fixed, prefer `note-linear-achievement`; if it mainly explains how the current implementation works, prefer `note-code-walkthrough`.
8. If a code note mainly preserves benchmark conclusions and evidence, prefer `note-conclusion-evidence`; if the benchmark is only verification of an implementation walkthrough, keep `note-code-walkthrough`.
9. If multiple shapes apply, choose the user's stated future reading intention.
10. Do not combine note shapes unless the user explicitly asks.