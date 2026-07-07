---
name: note-conclusion-evidence
description: Create or transform Obsidian notes that preserve conclusions, verification paths, and raw evidence in a top-down structure. Use for experiments, benchmarks, mechanism judgments, fact verification, and technical claims where the future reader wants conclusions first.
---

# Note Conclusion Evidence

## Role

Create or transform conclusion evidence notes.

This note type preserves what the user believes and why.

Main reading mode: top-down.

## Modes

### transform-mode

Use for an existing note.

Reorganize scattered material into:

- conclusions;
- verification sections;
- raw evidence archive;
- Obsidian links between conclusions, verification, and evidence.

### materialize-mode

Use for current context, chat history, experiment output, or terminal output.

Extract:

- conclusions;
- evidence;
- verification process;
- raw commands and outputs;
- boundaries;
- uncertainty.

## Use When

Use when the future reader wants:

- conclusions first;
- proof only when needed;
- raw material preserved;
- evidence that can be traced later.

## Avoid

Use `note-linear-achievement` when the main value is how the goal was reached.

Use `note-operation-manual` when the main value is direct execution.

## Default Structure

1. Core conclusions.
2. Conclusion-to-evidence table.
3. Verification process.
4. Boundaries and uncertainty.
5. Raw material archive.
6. Related links when useful.

## Link Rule

Each important conclusion should link to a verification section.

Each verification section should link to the raw evidence it depends on.

## Evidence Rule

Preserve commands, outputs, screenshots, metrics, source snippets, tables, and profile text when they support a conclusion.

Do not fabricate missing evidence.

## Output Policy

After creating or editing the note, respond with:

```markdown
## 完成情况

- 类型：结论证据型
- 模式：transform-mode / materialize-mode
- 文件：`<path>`
- 主要结论：
  - ...
- 不确定点：
  - ...
```
