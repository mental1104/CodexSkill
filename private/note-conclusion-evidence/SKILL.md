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
- raw material archive when needed;
- Obsidian heading links between conclusions, proof, and raw material.

### materialize-mode

Use for current context, chat history, experiment output, or terminal output.

Extract:

- conclusions;
- evidence;
- proof process;
- short commands and outputs needed for the proof;
- long reproducible materials when needed;
- lifecycle bootstrap material when the proof assumes a prepared state;
- boundaries;
- uncertainty.

## Use When

Use when the future reader wants:

- conclusions first;
- selective proof reading;
- evidence that can be traced later;
- reproducible raw material when the proof depends on long scripts, long outputs, reusable setup artifacts, or a non-trivial lifecycle bootstrap.

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
| `<conclusion>` | `[[#4.1 Proof - <name>]]` | `[[#9.1 Raw - <name>]]` or `none` | `<short boundary>` |

This table is the main reading entrance.

Do not put long explanations before this table.

## Default Structure

Prefer this structure:

1. AI摘要.
2. Conclusion index table.
3. Optional context only when it changes how conclusions should be read.
4. Linear proof processes.
5. Boundaries and uncertainty.
6. Raw material archive when needed.

Do not add a generic `reading scope` section by default.

Proof sections may start around section 4 or 5. The exact number is less important than keeping the top conclusion table jumpable.

## Proof Process Rules

Each proof section must be linear.

It should explain:

1. what question this conclusion answers;
2. what initial state the proof starts from;
3. what evidence was inspected;
4. the exact short commands, interactions, or observations that form the main proof path;
5. the expected output and state change after each important command or interaction;
6. how the evidence leads to the conclusion;
7. what boundary or exception remains;
8. which raw material can reproduce or verify it, if raw material is needed.

Keep the proof on the main road.

Do not dump every detail into the proof section.

Short terminal commands, short Redis/SQL interactions, short benchmark commands, compact tables, and short outputs belong directly in the proof section when they make the proof clearer.

Do not move short commands to the raw material archive merely because they are commands.

## Proof State Annotation Rules

For command-line, Redis, SQL, shell, REPL, API, or similar interactive proof steps, do not list commands without state annotations.

Each command or logical command group should make clear:

- command;
- expected output;
- state before or assumption;
- state after;
- why this state change matters to the conclusion.

Prefer a table when commands form a sequence:

| Step | Command | Expected output | State after |
|---|---|---|---|
| 1 | `SADD lab:set:a alice bob` | `2` | `lab:set:a = {alice,bob}` |
| 2 | `SISMEMBER lab:set:a alice` | `1` | `alice` is confirmed as a member |

Use command blocks only when the exact copyable command is the main value, and add comments or nearby text for output and state.

Bad:

```redis
SADD lab:set:a alice bob charlie
SISMEMBER lab:set:a alice
SCARD lab:set:a
```

Good:

| Step | Command | Expected output | State after |
|---|---|---|---|
| 1 | `SADD lab:set:a alice bob charlie` | `3` | `lab:set:a = {alice,bob,charlie}` |
| 2 | `SISMEMBER lab:set:a alice` | `1` | confirms `alice` exists |
| 3 | `SCARD lab:set:a` | `3` | confirms the set has 3 members |

The reader should not need to mentally simulate the state machine.

## Raw Material Boundary

Raw material is not every command or every output.

Raw material means material that is too large, too reusable, or too interruptive to inline into the proof process, but is still needed to reproduce, inspect, or rebuild the conclusion.

Typical raw material:

- long scripts;
- lifecycle bootstrap commands that create the runtime state used by proof sections;
- long one-shot setup commands that create directories, files, services, or full experiment scaffolding;
- full benchmark harnesses;
- file trees;
- config files;
- long outputs;
- logs;
- pprof or trace text;
- source snippets that are too long for the proof path;
- screenshots or tables that would break the main proof flow;
- original conversation fragments or references that are too long to inline.

Not raw material by default:

- short `bash` commands;
- short Redis, SQL, or shell interactions;
- compact command output;
- small result tables;
- one or two-line observations.

These should usually stay inside the proof section.

## Lifecycle Bootstrap Rule

If a proof section begins from a prepared state, the raw material archive must explain how to reach that state from zero.

This includes enough lifecycle material to answer:

```text
empty environment / fresh repo / no service
-> service running
-> dependencies available
-> test data created
-> proof section initial state reached
```

For Redis-like notes, this usually means preserving:

- how Redis was started;
- how the target port was chosen;
- how connectivity was checked;
- how test keys were cleaned;
- how test data was seeded;
- how to verify the initial key state before the proof command begins;
- how to clean up afterward.

For application experiments, this usually means preserving:

- setup script or file tree creation;
- dependency install command;
- app start command;
- workload or benchmark start command;
- health check;
- cleanup command.

If the lifecycle bootstrap is short and only used once, it may still be placed in raw material when it would distract from conclusion proof.

Proof sections should link to this raw material when they assume that starting state.

## Raw Material Rules

The end of the note should include a raw material archive when the note has real raw material or when a non-trivial lifecycle bootstrap is required.

For code or experiments, preserve enough to rerun or rebuild:

- scripts;
- file content or file tree;
- parameters;
- environment assumptions;
- lifecycle bootstrap from zero to proof initial state;
- execution method;
- key long outputs;
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

Prefer idempotent and single-shot reproduction materials.

If a script is required, include the script or the exact path plus enough content to recreate it.

Never keep only a vague note like `ran benchmark` or `see script` without enough reproducible detail.

## Link Rules

Use Obsidian heading links:

```markdown
[[#4.1 Proof - Redis pipeline improves throughput]]
[[#9.1 Raw - Redis benchmark harness]]
[[#9.2 Raw - Lifecycle bootstrap]]
```

Every important conclusion links to one proof section.

Every proof section links to raw material only when raw material exists or when it assumes a lifecycle/bootstrap state.

Raw material sections may link back to the proof section when useful.

## Evidence Rule

Preserve commands, outputs, screenshots, metrics, source snippets, tables, and profile text when they support a conclusion.

Choose placement by size and reading flow:

- short and proof-critical: proof section;
- long, reusable, or lifecycle/bootstrap material: raw material archive.

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
  - `结论 -> proof -> raw material/none`
- 不确定点：
  - ...
```
