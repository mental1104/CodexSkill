---
name: book-operation-manual-extract
description: Extract reusable operation manual notes from book reading notes. Use when the source is a book chapter, reading note, tutorial note, or book-specific project context and the goal is to free future execution from the book narrative. This skill decides what to extract, skip, deduplicate, merge, or link back to, then uses note-operation-manual as the final note shape.
---

# Book Operation Manual Extract

## Role

Extract reusable operation manuals from book reading notes.

This skill is a front-end extraction and merge decision layer.

It should:

1. identify executable material in book notes;
2. remove book-specific narrative and chapter context;
3. skip sections that do not contain repeatable operations;
4. search existing notes before creating new manuals;
5. decide whether to create, update, merge, or only backlink;
6. use `note-operation-manual` as the final output contract.

## Relationship To Other Skills

Use this skill before `note-operation-manual` when the source is a book or reading note.

`book-operation-manual-extract` owns:

- extraction gate;
- skip decision;
- concept normalization;
- deduplication;
- merge strategy;
- source backlink strategy.

`note-operation-manual` owns:

- final manual structure;
- concise command-first writing;
- verification, common errors, rollback, and cleanup sections.

Use `blue-espeon-note-style` as a convention layer when deciding:

- reusable topic note vs companion note;
- target directory;
- naming;
- wikilinks and backlinks;
- whether the note should be split.

## Use When

Use when the user asks to extract executable notes from book-related material.

Signals:

- “从书籍笔记里提取操作手册”
- “从阅读笔记里抽取可复用步骤”
- “把这章整理成可执行操作手册”
- “把这本书里能复用的命令提取出来”
- “只提取未来能直接执行的命令和代码块”
- “不适合抽离的跳过”
- “先查已有笔记去重”
- “能合并就合并，不要重复新建”
- “如果已有同主题手册，就更新已有笔记”

Default trigger phrase:

```text
从这篇书籍笔记里提取可复用操作手册；先查现有笔记去重，能合并就合并，不适合抽离的跳过。
```

## Avoid

Do not use this skill for ordinary experiment records, chat history, terminal output, or source-reading notes unless the user explicitly says the source is book-like or reading-note-like.

For normal operation manuals from current context, use `note-operation-manual` directly.

For conclusions, claims, and evidence that are not meant to be executed, use `note-conclusion-evidence`.

For process history, attempts, failures, and learning trajectory, use `note-linear-achievement`.

## Extraction Gate

Before writing anything, ask:

```text
Will the future reader execute this without reading the original book chapter?
```

If no, skip.

If yes, extract only:

- commands;
- runnable code blocks;
- configuration snippets;
- setup steps;
- minimal verification checks;
- common errors that affect execution;
- rollback or cleanup steps;
- useful source backlinks.

## Skip Rule

Skip the source note or section when it does not contain a repeatable operation.

Skip when the content is mainly:

- concept explanation;
- historical background;
- author narrative;
- design philosophy;
- one-off project context;
- incomplete pseudo code;
- non-runnable fragments;
- opinions without executable steps;
- commands that only work inside the book demo project and have no reuse value;
- theory that can be linked back to the reading note instead of being copied.

Do not force an operation manual.

When skipped, report only:

```markdown
## 跳过情况

- 来源：`<source note path>`
- 原因：没有可复用操作流程 / 只有概念解释 / 只适用于书中 demo 项目
- 建议：
  - 保留在原阅读笔记中
  - 如需沉淀，可改走 `note-conclusion-evidence`
```

## Workflow

### 1. Inspect Source

Read the source note or section.

Identify:

- book title or source note;
- chapter or section anchor;
- technology or domain;
- executable fragments;
- surrounding assumptions;
- whether the content depends on a book-specific project.

### 2. Extract Operation Candidates

Extract only candidate procedures that can be repeated later.

For each candidate, capture:

- operation goal;
- prerequisites;
- commands or code blocks;
- required files or paths;
- verification command or observable result;
- common failure mode;
- cleanup or rollback if relevant;
- source backlink.

### 3. Normalize Concept

Create a canonical operation concept before searching.

Include:

- canonical topic name;
- aliases;
- related Chinese and English terms;
- key commands, APIs, functions, config keys, or file names;
- target technology or language;
- operation intent.

Prefer action-oriented names.

Good:

- `Redis Pipeline 基准测试操作手册`
- `Linux tc netem 延迟注入操作手册`
- `ffmpeg GIF 转 MP4 操作手册`

Bad:

- `《Redis 实战》第 4 章操作手册`
- `第 3 章命令整理`
- `书籍笔记操作手册`

### 4. Search Existing Notes

Before creating a new manual, search existing notes using:

1. exact canonical title;
2. aliases;
3. key commands or APIs;
4. technology + operation intent;
5. source backlinks if this may already have been extracted.

Inspect likely matches before deciding.

Do not create duplicate manuals only because the source book is different.

### 5. Decide Merge Strategy

Use this table:

| Situation | Decision |
|---|---|
| Existing manual already covers most steps | Do not create a new note; add source backlink only if useful |
| Existing manual covers the main path but misses a practical command/check | Update existing manual |
| Existing manual has the same mechanism but a different language/tool | Add a subsection or cross-link, depending on note boundary |
| New source gives a shorter or safer executable path | Update the existing manual and keep the older source as a deeper link |
| New source is book-demo-specific and not reusable | Create companion note only if the user needs to run that demo; otherwise skip |
| Candidate contains multiple unrelated operations | Split into multiple manuals |
| Candidate is mostly explanation with no executable steps | Skip |

Priority when merging:

```text
local verified command > official/stable command > book example command > book-demo-only command
```

### 6. Choose Note Type

Choose `reusable topic note` when the operation is durable and useful outside the source book.

Choose `companion note` only when the operation is tied to a specific book project or local demo.

Do not place a reusable manual beside the book note just because the source came from a book.

### 7. Generate Final Manual

Generate or update the final note using `note-operation-manual`.

Preserve a short source section near the end:

```markdown
## 来源与延伸

- 来源：[[Source Book Note#Section]]
- 相关：[[Existing Related Manual]]
```

Do not copy long explanations from the book.

Do not include book summary, author narrative, or chapter structure unless needed to prevent a dangerous mistake.

## Output Policy

After execution, respond with one of the following.

### Created Or Updated

```markdown
## 完成情况

- 类型：书籍操作手册抽取
- 最终类型：操作手册型
- 模式：transform-mode
- 文件：`<path>`
- 处理方式：新建 / 更新已有 / 合并已有 / 仅补充回链
- 来源：
  - `[[source note#section]]`
- 主要步骤：
  - ...
- 去重结果：
  - ...
- 不确定点：
  - ...
```

### Skipped

```markdown
## 跳过情况

- 来源：`<source note path>`
- 原因：...
- 建议：...
```
