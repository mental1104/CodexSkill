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

Use when the user wants to turn current context, chat history, experiment output, terminal output, or Codex results into a new note.

Signals:

- “把刚才这轮归档成笔记”
- “生成一篇笔记”
- “沉淀成文档”
- “把这个实验结果归档”

Default: infer the route and proceed when obvious.

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

## Routing Table

| Input source | Note shape | Target skill | Mode |
|---|---|---|---|
| Existing note | Linear achievement | `note-linear-achievement` | `transform-mode` |
| Existing note | Conclusion evidence | `note-conclusion-evidence` | `transform-mode` |
| Existing note | Operation manual | `note-operation-manual` | `transform-mode` |
| Current context | Linear achievement | `note-linear-achievement` | `materialize-mode` |
| Current context | Conclusion evidence | `note-conclusion-evidence` | `materialize-mode` |
| Current context | Operation manual | `note-operation-manual` | `materialize-mode` |

## Route Decision Output

When route confirmation is useful, output:

```markdown
## 路线判断

- 输入来源：已有笔记 / 当前上下文
- 推荐类型：线性达成型 / 结论证据型 / 操作手册型
- 执行模式：transform-mode / materialize-mode
- 目标 Skill：`<skill-name>`
- 理由：
  - ...
  - ...
- 可选路线：
  - ...

是否按这个路线执行？
```

## Tie-Breaking Rules

1. Preserve process: choose `note-linear-achievement`.
2. Preserve belief and proof: choose `note-conclusion-evidence`.
3. Preserve repeatable action: choose `note-operation-manual`.
4. If multiple shapes apply, choose the user's stated future reading intention.
5. Do not combine note shapes unless the user explicitly asks.
