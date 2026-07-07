---
name: note-conclusion-evidence
description: Create or transform Obsidian notes that preserve conclusions, verification paths, and raw evidence in a top-down three-hop structure. Use when the future reader wants conclusions first, then selective jump links into linear proof processes and reproducible raw materials.
---

# Note Conclusion Evidence

## Role

Create or transform conclusion evidence notes.

This note type preserves what the user believes, how each conclusion was proven, and how to reproduce or inspect the original material.

Main reading mode: top-down and selective jump reading.

The note must support collapsed-heading reading in Obsidian: the reader can collapse the whole note, open only the conclusion table, then jump to the proof process for one conclusion, then jump to raw material only if needed.

## Core Structure

A conclusion evidence note must use a three-hop structure:

1. Conclusion index.
2. Linear proof process.
3. Raw material archive.

Every important conclusion should follow:

```text
conclusion -> proof process -> raw material
```

Do not flatten everything into one long explanation.

## Modes

### transform-mode

Use for an existing note.

Reorganize scattered material into:

- conclusion index table;
- linear proof sections;
- raw material archive;
- Obsidian heading links between conclusions, proof, and raw material.

### materialize-mode

Use for current context, chat history, experiment output, or terminal output.

Extract:

- conclusions;
- evidence;
- proof process;
- raw commands and outputs;
- boundaries;
- uncertainty;
- reproducible materials.

## Use When

Use when the future reader wants:

- conclusions first;
- selective proof reading;
- raw material preserved;
- evidence that can be traced and reproduced later.

## Avoid

Use `note-linear-achievement` when the main value is how a goal was reached.

Use `note-operation-manual` when the main value is direct execution.

## Required Opening

The note may start with `AI摘要`.

The first body section after `AI摘要` must be a conclusion index table.

The conclusion index table must contain Obsidian links to proof sections.

Recommended columns:

| Conclusion | Proof process | Raw material | Confidence / boundary |
|---|---|---|---|
| `<conclusion>` | `[[#4.1 Proof - <name>]]` | `[[#9.1 Raw - <name>]]` | `<short boundary>` |

This table is the main reading entrance.

Do not put long explanations before this table.

## Default Structure

Prefer this structure:

1. AI摘要.
2. Conclusion index table.
3. Reading map or scope boundary, only if useful.
4. Linear proof processes.
5. Boundaries and uncertainty.
6. Raw material archive.

Proof sections may start around section 4 or 5. The exact number is less important than keeping the top conclusion table jumpable.

## Proof Process Rules

Each proof section must be linear.

It should explain:

1. what question this conclusion answers;
2. what evidence was inspected;
3. how the evidence leads to the conclusion;
4. what boundary or exception remains;
5. which raw material can reproduce or verify it.

Keep the proof on the main road.

Do not dump every detail into the proof section.

If a detail needs a long command, script, table, output, screenshot, source snippet, or transcript, link to the raw material archive instead.

Good proof section shape:

```markdown
## 4.1 Proof - <conclusion name>

Question: ...

Main path:
1. ...
2. ...
3. ...

Therefore: ...

Raw material: [[#9.1 Raw - <name>]]
```

## Raw Material Rules

The end of the note must include a raw material archive.

Raw material means whatever is needed to reproduce, verify, or inspect the conclusion.

For code or experiments, preserve:

- scripts;
- commands;
- parameters;
- environment assumptions;
- execution method;
- key outputs;
- benchmark tables;
- logs;
- pprof or trace text;
- source snippets.

For non-code notes, preserve:

- source quotes or excerpts;
- screenshots;
- tables;
- original observations;
- conversation fragments;
- decision records;
- references.

Raw material should be append-only when possible.

Prefer idempotent and single-shot reproduction commands.

If a script is required, include the script or the exact path plus enough content to recreate it.

Never keep only a vague note like `ran benchmark` or `see script` without enough reproducible detail.

## Link Rules

Use Obsidian heading links:

```markdown
[[#4.1 Proof - Redis pipeline improves throughput]]
[[#9.1 Raw - Redis benchmark commands]]
```

Every important conclusion links to one proof section.

Every proof section links to one or more raw material sections.

Raw material sections may link back to the proof section when useful.

## Evidence Rule

Preserve commands, outputs, screenshots, metrics, source snippets, tables, and profile text when they support a conclusion.

Do not fabricate missing evidence.

Mark missing evidence explicitly.

## Output Policy

After creating or editing the note, respond with:

```markdown
## 完成情况

- 类型：结论证据型
- 模式：transform-mode / materialize-mode
- 文件：`<path>`
- 主要结论：
  - ...
- 证据链：
  - `结论 -> proof -> raw material`
- 不确定点：
  - ...
```
