---
name: note-linear-achievement
description: Create or transform Obsidian notes that preserve how a goal was reached step by step. Use for goal-driven experiments, debugging journeys, implementation attempts, and exploratory processes.
---

# Note Linear Achievement

## Role

Create or transform linear achievement notes.

This note type preserves the path from goal to result.

Main reading mode: beginning to end.

## Modes

### transform-mode

Use for an existing note.

Improve readability while preserving the original process.

Add:

- stage headings;
- process overview;
- transition explanations;
- useful diagrams or tables;
- final successful path.

### materialize-mode

Use for current context, chat history, experiment output, or terminal output.

Extract:

- goal;
- constraints;
- attempts;
- observations;
- turning points;
- final result;
- review notes.

## Use When

Use when the future reader needs to understand:

- what goal was pursued;
- what was tried;
- what failed or changed;
- why the next step happened;
- how the final result was reached.

## Avoid

Use `note-conclusion-evidence` when the main value is conclusion and proof.

Use `note-operation-manual` when the main value is repeatable steps.

## Default Structure

1. Goal.
2. Initial constraints.
3. Process overview.
4. Stage-by-stage record.
5. Final achieved path.
6. Review.
7. Raw material archive when needed.

## Output Policy

After creating or editing the note, respond with:

```markdown
## 完成情况

- 类型：线性达成型
- 模式：transform-mode / materialize-mode
- 文件：`<path>`
- 主要改动：
  - ...
- 不确定点：
  - ...
```
