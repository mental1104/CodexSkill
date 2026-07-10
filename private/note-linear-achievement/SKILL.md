---
name: note-linear-achievement
description: Create or transform Obsidian notes that preserve how a goal was reached step by step. Use for goal-driven experiments, debugging journeys, implementation attempts, and exploratory processes. The note is primarily for the user's own future rereading: start with a high-density overview, then explain details.
---

# Note Linear Achievement

## Role

Create or transform linear achievement notes.

This note type preserves the path from goal to result.

Main reading mode: beginning to end.

The reader is primarily the user's future self, not a public audience. Do not write like a public tutorial. Be direct, dense, and useful for rereading.

## Modes

### transform-mode

Use for an existing note.

Improve readability while preserving the original process.

Add:

- stage headings;
- a process overview at the top;
- transition explanations only where they prevent confusion;
- useful diagrams, tables, or full examples;
- final successful path.

Remove or compress:

- obvious motivation;
- broad background;
- generic learning objectives;
- long explanations of why the topic matters.

### materialize-mode

Use for current context, chat history, experiment output, or terminal output.

Extract:

- the main path;
- attempts;
- failed concrete attempts with original code, commands, configs, error output, or terminal output preserved verbatim;
- observations;
- turning points;
- final result;
- reusable fragments;
- review notes.

Do not invent a long goal/background section when the topic itself already implies the goal.

## Use When

Use when the future reader needs to understand:

- what was tried;
- what changed;
- why the next step happened;
- how the final result was reached;
- which final example, table, command, or diagram covers the whole note.

## Avoid

Use `note-conclusion-evidence` when the main value is conclusion and proof.

Use `note-operation-manual` when the main value is repeatable steps.

## Opening Rule

The opening is the most important part of the note.

Start with the most useful high-density material first.

Default opening order:

1. Mermaid overview diagram.
2. One complete example, command block, table, or artifact that covers the whole note.
3. Short key observation list.
4. Only then split into detailed stages.

For programming/library/API notes, put a complete runnable or copyable example near the top before explaining individual APIs.

For non-code notes, replace the code block with the equivalent whole-picture artifact, such as:

- process table;
- command sequence;
- architecture diagram;
- before/after comparison;
- final checklist;
- timeline.

Do not begin with generic sections such as:

- why this matters;
- learning objective;
- initial conditions;
- broad conceptual background.

Only include such sections when they carry non-obvious constraints.

## Failed Attempt Preservation Rule

When the source material includes a failed concrete attempt, preserve the exact original material before summarizing or explaining it.

Concrete attempts include:

- code snippets;
- shell commands;
- SQL statements;
- config fragments;
- terminal output;
- compiler/runtime errors;
- benchmark commands and results;
- tool prompts or generated patches when they materially affected the path.

For each important failed attempt, prefer this local structure:

```markdown
### Attempt N: <short label>

Original attempt:

```<language-or-text>
<verbatim code / command / output>
```

Observation:

- <what failed or looked wrong>

Adjustment:

- <what changed next>
```

Do not paraphrase a failed command, code block, or error message when the exact text is available.

Compress only when the raw material is huge. If compressed, keep the decisive lines verbatim and say what was omitted.

If multiple failed attempts differ only trivially, preserve one representative verbatim attempt and summarize the repeated variants in a compact table.

## Default Structure

Prefer:

1. AI摘要.
2. Overview diagram.
3. Whole-note example / table / command block / artifact.
4. Key observations.
5. Stage-by-stage breakdown.
6. Final achieved path.
7. Review.
8. Raw material archive when needed.

## Detail Rules

After the opening artifact, explain details in the same order the reader will encounter them.

Each stage should answer only:

- what this part does;
- what to notice;
- what changed from the previous stage;
- what mistake to avoid.

Keep explanations short. Prefer code, tables, and diagrams over prose.

## Diagram Rules

Use diagrams to reduce process fatigue, not for decoration.

Good diagrams:

- stage flow;
- attempt-to-result flow;
- debugging branch flow;
- experiment group flow;
- API usage flow.

Keep diagrams small. Prefer 5-9 nodes.

## Math Formatting Rule

If the generated or transformed note contains LaTeX math, LaTeX formula blocks, or LaTeX code blocks, also use `latex-math-writing`.

The note shape still follows `note-linear-achievement`, but all inline math and block math must satisfy `latex-math-writing` so Obsidian renders it correctly.

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
