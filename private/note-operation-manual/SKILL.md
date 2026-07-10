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
- shortest working steps;
- copyable commands;
- only essential verification checks;
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
4. Minimal verification.
5. Common errors.
6. Rollback or cleanup.
7. Links to deeper explanation only when useful.

## Writing Rule

Keep it short.

Prefer commands and checks over explanation.

Do not explain theory unless it prevents a dangerous mistake.

## Math Formatting Rule

If the generated or transformed note contains LaTeX math, LaTeX formula blocks, or LaTeX code blocks, also use `latex-math-writing`.

The note shape still follows `note-operation-manual`, but all inline math and block math must satisfy `latex-math-writing` so Obsidian renders it correctly.

## Quiet Command Rule

Operation manuals should follow command-line ergonomics:

```text
No response is often the best response.
```

Do not add `Expected output` or `State after` after every command by default.

For most setup/configuration procedures, provide a clean sequence of copyable commands and let the user execute them top to bottom.

Only include expected output or state notes when:

- the command is a verification checkpoint;
- the output is needed to copy into the next step;
- the operation is destructive, dangerous, or hard to undo;
- the command commonly fails in a confusing way;
- the output is the user's only evidence that setup worked;
- different output changes the next action.

Good:

```bash
git config --global user.name "mental1104"
git config --global user.email "mental1104@gmail.com"
git config --global init.defaultBranch main
```

Then one verification block:

```bash
git config --global --list
```

Bad:

```markdown
Expected output: no output means success
State after: user.name is configured
```

Do not repeat this after every quiet command.

## Command Style

Commands should be directly copyable.

Prefer one coherent command block per phase.

Add short comments only when they prevent misuse.

Avoid wrapping every command in prose.

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
