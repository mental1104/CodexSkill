---
name: technical-document-optimization
description: Optimize Obsidian technical notes and old engineering documents from an article-lifecycle perspective, especially notes that include code paths, implementation analysis, tests, diagrams, images, YAML frontmatter, wikilinks, and code archive/explanation. Use when the user asks to improve a technical note, code explanation note, algorithm/data-structure note, implementation archive, test explanation, or technical document readability while preserving the original body and marking additions.
---

# Technical Document Optimization

Use this skill to review and transform technical Obsidian notes into readable, maintainable technical documentation. It combines old-note lifecycle review, Obsidian Markdown conventions, code explanation, implementation archiving, and test-case explanation.

## Core Rules

- Diagnose before editing unless the user explicitly confirms direct changes.
- Preserve the original body and intent. Do not rewrite into marketing, textbook, or blog style.
- New prose added to the note must use Obsidian highlight syntax: `==新增内容==`.
- Code blocks copied from source do not need highlight marks, but the explanatory prose around them does.
- Prefer direct, searchable, reusable wording.
- Do not introduce external facts unless the user provided them or they are verified from local source files.
- If images exist, explain what each image means and how it connects the previous and next paragraphs.
- Use wikilinks only for truly relevant prerequisites or related notes.
- Keep implementation analysis at the end after conceptual and business intuition is established.

## Diagnosis Stage

When the user provides a note path or content, first inspect the note and any referenced local source/test files. Then output:

````markdown
# 旧笔记改造建议

## 总体判断

这篇笔记目前的问题是：

## 需要修改的地方

### 1. xxx

- 问题：
- 为什么需要改：
- 建议怎么改：

## 可能缺失的前置知识

- [[xxx]]
  - 缺失原因：
  - 建议补充位置：

## 建议更新的 YAML Front Matter

```yaml
---
title:
summary:
tags:
  -
aliases:
  -
related:
  - "[[]]"
created:
updated:
---
```

## 等待确认

请确认是否按以上方案改造。
````

If the user has already confirmed, proceed to edit.

## Required Note Structure

For technical notes, prefer this order:

1. YAML frontmatter.
2. Title.
3. Summary callout.
4. Prerequisite callout if needed.
5. Plain-language concept explanation.
6. What problem this concept solves.
7. Suitable business or engineering scenarios.
8. Diagrams, images, and examples with bridging explanations.
9. Complexity, tradeoffs, advantages, and disadvantages.
10. Implementation and test analysis at the end.
11. Related links.

## YAML Frontmatter

Create or update:

```yaml
---
title: 笔记标题
summary: 用一到三句话说明这篇笔记解决什么问题、核心结论是什么
tags:
  - 标签1
  - 标签2
aliases:
  - 可能会搜索到的别名1
related:
  - "[[相关笔记1]]"
created:
updated: YYYY-MM-DD
---
```

Rules:

- `title`: clear and searchable.
- `summary`: explain what the note solves, what it covers, and the core conclusion.
- `tags`: only theme/use tags, no status/source tags.
- `aliases`: search anchors, old titles, common Chinese/English names.
- `related`: only strongly related notes.
- `created`: preserve existing value if present, otherwise leave blank.
- `updated`: current date.

## Concept And Intuition

Before formulas, interfaces, or implementation:

- Explain the concept in plain language a beginner can understand.
- Add a section such as `## ==先用白话理解 xxx==`.
- Add a section such as `## ==xxx 解决了什么问题==`.
- If useful, add real-world/business cases under `## ==什么业务适合建模成 xxx==`.
- Include a warning section for unsuitable cases if misuse is likely.

## Images, Callouts, And Mermaid

- Every existing image should have surrounding prose:
  - before the image: what the reader should look at;
  - after the image if needed: what conclusion follows.
- Use callouts sparingly for memory hooks, prerequisites, warnings, and summaries:
  - `[!summary]`
  - `[!note]`
  - `[!tip]`
  - `[!warning]`
- Use Mermaid when it clarifies flow, selection criteria, architecture, or mapping from business objects to technical structures.
- Mermaid node labels should be quoted when they include brackets or symbols, e.g. `A["A[i][j]"]`.

## Implementation Analysis

Only use this section when code paths or implementation are part of the task.

Read the implementation file and relevant parent/abstract classes before writing. If a test path is provided, read it too.

Implementation section must be near the end and follow this pattern:

1. Source and test paths.
2. Interface/class declaration first.
3. Then each class member or function under its own third-level heading.
4. Under each heading:
   - paste the relevant function/class snippet;
   - explain what the function does;
   - connect it to the concept and complexity discussion;
   - mention which tests verify it when applicable.

Do:

- Include the complete public interface/class declaration if it helps orientation.
- Paste individual functions or small related snippets independently.
- Explain OOP relationships, inheritance, abstract methods, and interface contracts.
- Highlight why implementation choices match the note’s conceptual model.

Do not:

- Paste the entire source file as one block.
- Add line-by-line comments for every trivial expression.
- Put implementation analysis before the reader has conceptual intuition.
- Explain unrelated source code just because it is nearby.

## Test Analysis

When tests are relevant, create a dedicated section. For each important test case include:

- test case name;
- test method;
- key code snippet;
- test idea;
- implementation contract being verified.

Prefer grouped test coverage:

- basic data-structure semantics;
- accessor and mutation invariants;
- algorithm/interface contract;
- special graph behavior or edge cases;
- file parsing or constructor variants;
- smoke tests.

Do not paste the entire test file. Only quote focused snippets.

## Validation Checklist

Before finishing:

- Frontmatter exists and fields are coherent.
- Added prose is highlighted with `==...==`.
- Title, summary, body, conclusion, and related links are consistent.
- A reader can read linearly without sudden unexplained concepts.
- Prerequisites are linked instead of over-explained.
- Images have bridging explanation.
- Implementation is at the end.
- Code snippets are focused, not whole-file dumps.
- Test explanation names concrete test cases and their purpose.
