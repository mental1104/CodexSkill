---
name: general-document-optimization
description: Optimize general Obsidian notes and old non-technical documents from an article-lifecycle perspective, improving title, summary, frontmatter, logic, linear readability, conclusion/theme-first structure, wikilink navigation, prerequisites, images, diagrams, callouts, and related links while preserving the original body. Use when the user asks to improve a note but does not need code implementation, source-file, or test-case analysis.
---

# General Document Optimization

Use this skill to review and transform old Obsidian notes into coherent, searchable, maintainable documents. This is the non-technical version: it excludes source-code implementation analysis and test-case explanation.

## Core Rules

- Diagnose before editing unless the user explicitly confirms direct changes.
- Preserve the original body and intent.
- Add new prose directly in normal Obsidian Markdown. Do not visually mark additions unless the user explicitly asks.
- Do not rewrite into marketing, textbook, or public-account style.
- Prefer concise, direct, searchable, reusable wording.
- Do not add unsupported facts.
- Use wikilinks only for real prerequisites or related notes.
- Prefer total-to-detail organization when the note is an overview, introduction, archive, reading note, or concept map: start from conclusions/themes, link to supporting process sections, and keep original/raw information near the end.

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
- the opening can serve as a navigation surface when the note has several themes, conclusions, or supporting details;
- the note can be read linearly from top to bottom.

## Recommended Note Structure

Use this order when appropriate:

1. YAML frontmatter.
2. Title.
3. Summary callout.
4. Conclusion/theme navigation when the note benefits from a total-to-detail structure.
5. Prerequisite callout if needed.
6. Plain-language concept or topic explanation.
7. What problem the note answers.
8. Supporting process, reasoning, examples, or evidence reorganized for linear reading.
9. Images/diagrams with bridging explanations.
10. Original/raw information archive when the source note contains scattered records, excerpts, meeting notes, observations, or source material.
11. Takeaways or conclusion.
12. Related links.

## Total-To-Detail Wikilink Navigation

Use this mode for non-technical notes that should be read from the answer/topic outward rather than from old chronological fragments: introductions, overview notes, learning maps, reading notes, research notes, meeting summaries, and archive notes.

Structure:

1. Put the core conclusion, topic, or decision at the top.
2. Make the first substantial section a navigation surface. Use a short list or table where each item links to:
   - a concrete support section in the same note, such as `[[#支撑过程：xxx]]`;
   - real detail notes, prerequisites, or follow-up notes when they already exist.
3. In the middle, explain the supporting process: reasoning path, examples, observations, comparisons, image explanations, or evidence.
4. Near the end, preserve original/raw information: old fragments, copied source material, meeting records, reading excerpts, or unprocessed observations.
5. End with related links or next reading only when they help the reader continue.

Rules:

- The opening should answer "what is this note saying?" before asking the reader to inspect the details.
- Do not scatter raw material before the conclusion unless the note is intentionally a diary or chronological log.
- Do not turn every noun into a wikilink. Use wikilinks as routing handles from theme to support, from support to prerequisite, and from conclusion to related detail.
- When using an Obsidian table, avoid wikilink alias syntax such as `[[#heading|alias]]`; the `|` can break Markdown table parsing. Use `[[#heading]]: explanation` or place the link outside the table.
- If no real local target exists, use plain text or a deliberate placeholder such as `[[待补：xxx]]` with a short reason.

Suggested skeleton:

```markdown
> [!summary]
> 一句话说明主题、结论和阅读方向。

## 核心结论 / 主题导航

| 主题 | 先记住什么 | 支撑过程 / 细节 |
|---|---|---|
| [[#支撑过程：xxx]] | 结论或主题判断。 | [[相关细节笔记]] |

## 支撑过程：xxx

原笔记内容重排或新增桥接说明。

## 原始信息 / 资料归档

原始片段、摘录、记录或未加工信息。
```

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
- Added prose reads naturally in the note and is not visually marked unless requested.
- Title, summary, body, and conclusion are consistent.
- Conclusion/theme navigation, when present, links to concrete supporting sections or real related notes.
- Raw/original information is preserved but does not block the reader from seeing the main conclusion first.
- A reader can read linearly without sudden unexplained concepts.
- Prerequisites are linked instead of over-explained.
- Images have bridging explanation.
- Callouts and Mermaid diagrams improve readability rather than decorate.
- No code implementation or test analysis is added; use `technical-document-optimization` for that.
