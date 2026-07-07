---
name: note-operation-manual
description: Create or transform Obsidian notes that preserve the shortest repeatable procedure for doing something. Use for SOPs, setup guides, commands, configuration steps, troubleshooting checklists, and operation records where the future reader wants to execute without reading theory.
---

# Note Operation Manual

## Role

Create or transform operation manual notes.

This note type preserves repeatable action.

Main reading mode: execute step by step.

## Modes

### transform-mode

Use for an existing note.

Compress it into a practical procedure.

Remove or move away:

- long background;
- exploration history;
- theory;
- unrelated alternatives.

### materialize-mode

Use for current context, chat history, terminal output, or final working commands.

Extract:

- prerequisites;
- steps;
- commands;
- expected output;
- common errors;
- rollback or cleanup.

## Use When

Use when the future reader wants to:

- install something;
- configure something;
- run a fixed command sequence;
- troubleshoot a known problem;
- repeat a known working path.

## Avoid

Use `note-linear-achievement` when the main value is process history.

Use `note-conclusion-evidence` when the main value is proof.

## Default Structure

1. Purpose.
2. Prerequisites.
3. Steps.
4. Expected result.
5. Common errors.
6. Rollback or cleanup.
7. Links to deeper explanation only when useful.

## Writing Rule

Keep it short.

Prefer commands, checks, and expected output over explanation.

Do not explain theory unless it prevents a dangerous mistake.

## Output Policy

After creating or editing the note, respond with:

```markdown
## 完成情况

- 类型：操作手册型
- 模式：transform-mode / materialize-mode
- 文件：`<path>`
- 主要步骤：
  - ...
- 不确定点：
  - ...
```
