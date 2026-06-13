---
name: general-document-optimization
description: Optimize general Obsidian notes and old non-technical documents from an article-lifecycle perspective, improving title, summary, frontmatter, logic, linear readability, prerequisites, images, diagrams, callouts, and related wikilinks while preserving the original body and marking additions. Use when the user asks to improve a note but does not need code implementation, source-file, or test-case analysis.
---

# General Document Optimization

Use this skill to review and transform old Obsidian notes into coherent, searchable, maintainable documents. This is the non-technical version: it excludes source-code implementation analysis and test-case explanation.

## Core Rules

- Diagnose before editing unless the user explicitly confirms direct changes.
- Preserve the original body and intent.
- New prose added to the note must use Obsidian highlight syntax: `==新增内容==`.
- If text is only moved, reordered, or typo-corrected, highlight is not required.
- Do not rewrite into marketing, textbook, or public-account style.
- Prefer concise, direct, searchable, reusable wording.
- Do not add unsupported facts.
- Use wikilinks only for real prerequisites or related notes.

## Diagnosis Stage

When the user provides a note path or content, first inspect the note. Then output:

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

## Required Review Dimensions

Check whether:

- title accurately summarizes the body;
- opening explains what the note is about;
- summary helps future readers decide whether to read;
- paragraphs are in a natural order;
- concepts appear after enough context;
- conclusion follows from the body;
- images or diagrams are explained;
- prerequisites are linked;
- related links are useful, not decorative;
- the note can be read linearly from top to bottom.

## Recommended Note Structure

Use this order when appropriate:

1. YAML frontmatter.
2. Title.
3. Summary callout.
4. Prerequisite callout if needed.
5. Plain-language concept or topic explanation.
6. What problem the note answers.
7. Main body reorganized for linear reading.
8. Images/diagrams with bridging explanations.
9. Takeaways or conclusion.
10. Related links.

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
- `summary`: explain the note’s object, scope, and conclusion.
- `tags`: only theme/use tags, no status/source tags.
- `aliases`: search anchors, old titles, common names.
- `related`: only strongly related notes.
- `created`: preserve existing value if present, otherwise leave blank.
- `updated`: current date.

## Prerequisites And Wikilinks

If a reader may lack necessary background:

```markdown
## 可能缺失的前置知识

- [[前置知识笔记名]]
  - 缺失原因：
  - 建议补充位置：
```

If the note name is unknown:

```markdown
- [[待补：xxx]]
  - 缺失原因：
  - 建议之后新建或链接已有笔记。
```

Do not force long prerequisite explanations into the current note unless they are necessary to understand the note.

## Images, Callouts, And Mermaid

- Every image should have surrounding prose:
  - before the image: what to look at;
  - after the image if needed: what conclusion follows.
- Use callouts sparingly:
  - `[!summary]` for summary;
  - `[!note]` for memory hooks or context;
  - `[!tip]` for selection rules;
  - `[!warning]` for misuse or caveats.
- Use Mermaid only when it improves readability, such as flow, decision trees, timelines, mappings, or relationships.
- Mermaid node labels should be quoted when they include brackets or symbols.

## Output After Editing

When editing a file, report:

- file path;
- major structural changes;
- frontmatter changes;
- any added prerequisites/related links;
- any sections still uncertain.

## Validation Checklist

Before finishing:

- Frontmatter exists and fields are coherent.
- Added prose is highlighted with `==...==`.
- Title, summary, body, and conclusion are consistent.
- A reader can read linearly without sudden unexplained concepts.
- Prerequisites are linked instead of over-explained.
- Images have bridging explanation.
- Callouts and Mermaid diagrams improve readability rather than decorate.
- No code implementation or test analysis is added; use `technical-document-optimization` for that.
