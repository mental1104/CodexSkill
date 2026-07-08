---
name: note-conclusion-evidence
description: Create or transform Obsidian notes that preserve conclusions, proof paths, and reproducible evidence in a conclusion-first chained structure. Use when the reader wants conclusions first, then a linear proof path, and only then raw material when the proof needs it.
---

# Note Conclusion Evidence

## Role

Create or transform conclusion-evidence Obsidian notes.

This note type preserves:

- what conclusion is believed;
- how it was proven;
- what raw material can reproduce or inspect the proof when needed.

Main reading mode: collapsed-heading, top-down, selective jump reading.

## Core Structure

Use a chained three-hop structure:

```text
conclusion -> linear proof process -> raw material / reusable note / none
```

Do not create two parallel links like:

```text
conclusion -> proof process
conclusion -> raw material
```

The conclusion index is only an entrance into proof sections. Raw material should be reached from the proof process, not directly from the conclusion index.

## Modes

### transform-mode

Use for an existing note.

Reorganize scattered material into:

- conclusion index table;
- linear proof sections;
- raw material archive when needed;
- links from conclusions to proof sections;
- links from proof sections to raw material only when needed.

### materialize-mode

Use for current context, chat history, experiment output, or terminal output.

Extract:

- conclusions;
- evidence;
- proof process;
- short copyable commands and outputs needed for proof;
- raw material only when proof needs extra context or reproducibility material;
- lifecycle bootstrap material when the proof assumes a prepared state;
- reusable lifecycle references when a shared note already exists or should exist;
- boundaries and uncertainty.

## Use When

Use when the future reader wants:

- conclusions first;
- selective proof reading;
- evidence that can be traced later;
- reproducible raw material when the proof depends on scripts, long outputs, setup artifacts, logs, traces, screenshots, or context that would interrupt the main proof.

## Avoid

Use `note-linear-achievement` when the main value is how a goal was reached.

Use `note-operation-manual` when the main value is direct execution.

## Required Opening

The note may start with `AI摘要`.

The first body section after `AI摘要` must be a conclusion index table.

The conclusion index table must link to proof sections only.

Recommended columns:

| Conclusion | Proof process | Confidence / boundary |
|---|---|---|
| `<conclusion>` | `[[#4.1 Proof - <name>]]` | `<short boundary>` |

Do not include a raw material column in the conclusion index by default.

Do not place raw material links in the conclusion index unless the user explicitly asks for a raw-material map.

The table is the main reading entrance. Do not put long explanations before it.

## Default Structure

Prefer this structure:

1. AI摘要.
2. Conclusion index table.
3. Optional context only when it changes how conclusions should be read.
4. Linear proof processes.
5. Boundaries and uncertainty.
6. Raw material archive when needed.

Do not add a generic `reading scope` section by default.

Do not add `Reusable note proposal`, `可复用笔记建议`, or similar confirmation sections inside the generated note body.

## Proof Process Rules

Each proof section must be linear and stay on the main road.

It should explain:

1. what question this conclusion answers;
2. what initial state the proof starts from;
3. what evidence was inspected;
4. the exact short commands, interactions, observations, or compact tables that form the proof path;
5. expected output or state change only when it helps the proof;
6. how the evidence supports the conclusion;
7. boundaries or exceptions;
8. raw material / reusable note link only when the proof needs it.

Short Bash, Redis, SQL, shell, API, benchmark commands, compact outputs, and small tables belong directly in the proof section when they clarify the proof.

Do not move short commands to raw material only because they are commands.

## Raw Material Link Timing Rule

Raw material links must be introduced from inside proof sections, not from the conclusion index.

Link to raw material only when one of these is true:

- the proof section would be too long if the material were inlined;
- the proof code or excerpt is not enough to explain the conclusion;
- the reader must first understand setup/context before trusting the proof;
- the material is needed to reproduce the result;
- the material is a long script, harness, trace, log, screenshot, file tree, or long output;
- the proof uses a prepared lifecycle state that needs setup explanation.

Do not link to raw material when the proof section is already self-contained.

Good pattern:

```markdown
## 4.1 Proof - ZRANGEBYSCORE cost grows with returned members

Question: ...

Main path:
1. Run the compact benchmark command.
2. Compare small range and large range output.
3. The QPS drop follows returned member count.

Raw material, only if you need to rebuild the dataset: [[#9.1 Raw - ZSet benchmark seed data]]
```

Bad pattern:

```markdown
| Conclusion | Proof process | Raw material |
|---|---|---|
| `ZRANGEBYSCORE` slows down with many returned members | [[#4.1 Proof - ...]] | [[#9.1 Raw - ...]] |
```

The reader should first read the proof. The proof decides whether raw material is needed.

## Copyable Command Rule

Proof commands should remain directly copyable whenever possible.

Do not turn runnable command sequences into Markdown tables just to annotate state.

Prefer annotated command blocks plus nearby output/state comments.

Good forms:

- shell comments that do not break execution;
- separate expected-output blocks when output matters;
- short state-before/state-after text only when it prevents confusion;
- tables only for non-copyable summaries.

The reader should not need to mentally simulate a state machine, but the command block should still be copyable.

## Raw Material Boundary

Raw material is not every command or every output.

Raw material means material that is too large, reusable, or disruptive to inline, but still needed to reproduce, inspect, or rebuild the conclusion.

Typical raw material:

- long scripts;
- lifecycle bootstrap commands;
- one-shot setup commands that create directories, files, services, or experiment scaffolding;
- benchmark harnesses;
- file trees;
- config files;
- long outputs;
- logs;
- pprof or trace text;
- long source snippets;
- screenshots or large tables;
- long source conversation fragments or references.

Usually not raw material:

- short Bash/Redis/SQL/shell interactions;
- compact command output;
- small result tables;
- one or two-line observations.

These usually stay inside proof sections.

## Lifecycle Bootstrap Rule

If a proof starts from a prepared state, the proof section should either:

- include the short setup inline if it is small and local; or
- link to raw material / reusable note if the setup would distract from the proof.

Lifecycle path:

```text
empty environment / fresh repo / no service
-> service running
-> dependencies available
-> test data created
-> proof initial state reached
```

For Redis-like notes, preserve inline or link to:

- how Redis was started;
- target port;
- connectivity check;
- test key cleanup;
- seed data;
- initial key-state verification;
- cleanup.

For application experiments, preserve inline or link to:

- setup script or file tree;
- dependency install;
- app start;
- workload or benchmark command;
- health check;
- cleanup.

## Reusable Lifecycle Material Rule

Do not duplicate common lifecycle/bootstrap material across many notes.

Before embedding lifecycle material, check whether the vault already has a suitable reusable note, for example:

```markdown
[[Redis 本地实验环境]]
[[Redis Docker 启动与清理]]
[[FastAPI CPU-bound Benchmark 实验环境]]
```

If a suitable note exists, link to it from the relevant proof section or raw material section instead of copying the setup again.

If no suitable note exists and the setup is likely to be reused, finish the current Obsidian note first. Do not put the reusable-note proposal inside the Obsidian note body.

After the note is complete, put the reusable-note proposal in the Codex/chat response only, and ask the user whether to create it and where it should live.

Propose a reusable note when the material is:

- common across multiple notes;
- likely to be referenced by 3 or more notes;
- stable enough to maintain once;
- about environment setup, service startup, dependency install, benchmark harness setup, or shared cleanup;
- not specific to one conclusion.

Embed material directly in current raw material when it is:

- one-off;
- experiment-specific;
- tightly coupled to this note's evidence;
- unlikely to be reused;
- short enough that a separate note would add navigation overhead.

Do not create a new reusable note without explicit user confirmation.

Do not put reusable-note proposals inside the generated Obsidian note body.

## Raw Material Rules

The end of the note should include raw material only when the note has real raw material or non-trivial lifecycle bootstrap.

For experiments, preserve enough to rerun or rebuild:

- scripts;
- file content or file tree;
- parameters;
- environment assumptions;
- lifecycle bootstrap, reusable note link, or local minimal bootstrap;
- execution method;
- key long outputs;
- benchmark tables;
- logs;
- pprof or trace text;
- source snippets.

Never write vague references like `ran benchmark`, `see script`, or `see Redis setup` without enough local detail or a concrete Obsidian link.

## Link Rules

Use Obsidian heading links.

Correct link direction:

```markdown
[[#4.1 Proof - Redis pipeline improves throughput]]
```

Then inside that proof section, only if needed:

```markdown
Raw material: [[#9.1 Raw - Redis benchmark harness]]
Shared setup: [[Redis 本地实验环境]]
```

Every important conclusion links to one proof section.

Proof sections link to raw material only when the proof needs extra context, reproduction material, or lifecycle setup.

Raw material sections may link back to proof sections when useful.

Do not make the conclusion index a raw-material map.

## Evidence Rule

Choose placement by size and reading flow:

- short and proof-critical: proof section;
- long, reusable, lifecycle/bootstrap, or context-heavy material: raw material archive or linked reusable note;
- raw material link timing: from proof section at the moment the reader needs it.

Preserve copyability for proof commands.

Do not fabricate missing evidence. Mark missing evidence explicitly.

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
  - `结论 -> proof -> raw material/reusable note/none`
- 可复用笔记建议：
  - 是否建议新开：是/否
  - 建议标题：`...`
  - 建议原因：...
  - 需要用户确认目录：是/否
- 不确定点：
  - ...
```

Reusable-note proposals belong in this Codex/chat response only, not in the generated Obsidian note body.
