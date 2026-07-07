---
name: technical-document-optimization
description: Technical Obsidian note execution layer. Use to diagnose or improve existing technical notes, experiment notes, benchmark notes, debugging notes, implementation notes, code explanation notes, test explanation notes, or screenshot-heavy engineering notes. Choose exactly one mode per run. For vault style and placement, follow blue-espeon-note-style. For metadata-only edits, use obsidian-frontmatter-metadata.
---

# Technical Document Optimization

## Role

This skill is the **technical note execution layer**.

It improves existing technical Obsidian notes while preserving original intent, evidence, and useful raw material.

It should not own vault-wide conventions.

Delegate:

- Vault style, directory placement, naming, backlinks, Mermaid conventions, and single-thesis boundaries: `blue-espeon-note-style`.
- Metadata-only edits: `obsidian-frontmatter-metadata`.
- Source-code scene reconstruction for ChatGPT: `source-walk`.
- Non-technical note rewriting: `general-document-optimization`.

## Mode Selection

Choose exactly one mode per run.

Do not combine modes unless the user explicitly asks.

### 1. `refactor-note-mode`

Use for old technical notes that need better structure, readability, section order, examples, diagrams, prerequisites, or related links.

Effect:

- conclusion first;
- clearer concept bridge;
- better explanation order;
- examples placed near explanations;
- raw fragments preserved near the end when useful.

### 2. `experiment-archive-mode`

Use for experiment, benchmark, debugging, performance, pprof, trace, or fact-verification notes.

Effect:

- core conclusions first;
- verification process linked to evidence;
- commands, outputs, metrics, key profile text, and raw data preserved in Markdown;
- boundaries and failure cases stated explicitly.

### 3. `implementation-analysis-mode`

Use for notes explaining source implementation, function behavior, class/module boundaries, or tests.

Effect:

- source and test paths listed;
- important symbols explained;
- snippets kept focused;
- implementation details placed after concept and engineering intuition.

This mode may inspect local source/test files referenced by the note, but it should not become a full project snapshot. Use `source-walk` for that.

### 4. `screenshot-note-mode`

Use for screenshot-heavy engineering notes.

Effect:

- each image gets context before and interpretation after;
- screenshots are tied to claims;
- missing text evidence is reported as uncertainty.

## Non-Goals

This skill must not:

- make final architecture decisions;
- generate broad tutorials unrelated to the note;
- invent measurements, outputs, or source behavior;
- move or rename notes unless explicitly asked;
- create implementation changes;
- do metadata-only work when `obsidian-frontmatter-metadata` fits better;
- reconstruct a whole repository scene when `source-walk` fits better.

## Core Rules

1. Diagnose before editing unless the user explicitly confirms direct changes.
2. Preserve original body, intent, evidence, and useful raw material.
3. Do not rewrite into marketing, textbook, or blog style.
4. Prefer direct, searchable, reusable wording.
5. Do not introduce external facts unless provided by the user, verified from local files, or explicitly requested as web-verified extension reading.
6. Keep raw commands, outputs, source archives, and long evidence near the end.
7. Keep implementation details after conceptual and engineering intuition.
8. Use Mermaid only when it clarifies a concrete flow, lifecycle, state transition, validation chain, or mapping.
9. Do not add decorative diagrams, decorative callouts, or broad related reading.

## Diagnosis Output

When asked to diagnose first, output:

```markdown
# 技术笔记改造建议

## 1. 选择的模式

- Mode: `<refactor-note / experiment-archive / implementation-analysis / screenshot-note>`
- Reason: <why this mode fits>

## 2. 总体判断

这篇笔记目前的主要问题是：

## 3. 需要修改的地方

### 1. <issue>

- 问题：
- 为什么需要改：
- 建议怎么改：

## 4. 需要保留的原始证据

- <commands / outputs / screenshots / source snippets / tables>

## 5. 不确定点

- <max 3 bullets>

## 6. 等待确认

请确认是否按以上方案改造。
```

If the user already asked to write directly, edit directly.

## Mode Structures

### `refactor-note-mode`

Prefer:

1. YAML frontmatter.
2. Title.
3. Summary or AI摘要.
4. Core conclusion or thesis.
5. Concept bridge.
6. Problem solved.
7. Mechanism / workflow.
8. Examples.
9. Boundaries / caveats / tradeoffs.
10. Original/raw material when useful.
11. Related links.

### `experiment-archive-mode`

Prefer:

1. Core conclusion table.
2. Environment and scope.
3. Verification process.
4. Key metrics and observations.
5. Why the evidence supports the conclusion.
6. Boundaries and failure cases.
7. Archive section for source paths, exact commands, actual outputs, key profile text, raw data, and regeneration instructions.
8. Related links only when useful.

Evidence rule:

- Each opening conclusion must link to a concrete verification subsection.
- Each verification subsection must link to supporting archived evidence.
- If a command succeeds with no output, write `无输出，退出码 0`.
- If a command fails, record the real error and blocker.
- Do not fabricate expected output.

### `implementation-analysis-mode`

Prefer:

1. Core conclusion.
2. Source/test map.
3. Conceptual role of the implementation.
4. Important objects/functions/classes.
5. Focused snippets with path and line numbers.
6. Call path or lifecycle when useful.
7. Test coverage and behavioral contract.
8. Boundaries and uncertain areas.

### `screenshot-note-mode`

Prefer:

1. What the screenshot shows.
2. What claim it supports.
3. Text evidence that confirms or limits it.
4. Interpretation.
5. Missing evidence or uncertainty.

## Validation Checklist

Before finishing, check:

- exactly one mode was selected;
- original intent is preserved;
- no unsupported facts were added;
- metadata rules did not drift from `obsidian-frontmatter-metadata`;
- vault style did not drift from `blue-espeon-note-style`;
- raw evidence was preserved when needed;
- diagrams are useful and small;
- experiment conclusions can be traced to evidence.

## Chat Output Policy

After editing, do not paste the full note unless the user asks.

Return:

```markdown
## 完成情况

- Mode: `<mode>`
- Edited: `<path>`
- Main changes:
  - ...
  - ...
- Evidence preserved:
  - ...
- Uncertainty:
  - ...
```
