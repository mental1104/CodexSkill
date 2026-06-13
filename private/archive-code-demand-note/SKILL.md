---
name: archive-code-demand-note
description: Create a self-contained Obsidian archive note from a source code file plus an original requirement or demand brief. Use when the user asks to archive, document, or file a coding task into a notes/demand directory, especially when they provide a code path and raw requirements and want YAML frontmatter, implementation notes, and the complete single-file code embedded in the final Markdown note rather than linked externally.
---

# Archive Code Demand Note

## Overview

Create one self-contained Markdown note that preserves the original demand, summarizes the current implementation, and embeds the full source code at the end. Prefer this for demand archives, implementation handoff notes, and Obsidian vault records where the code is a single file or can reasonably fit in the note.

## Workflow

1. Confirm the exact input artifacts:
   - Source code path or code block.
   - Original requirement text.
   - Target archive directory.
   - Any requested note name; otherwise choose a concise Chinese filename from the task.
2. Read the source code before writing.
   - Identify defaults, environment variables, CLI flags, dependencies, external APIs, idempotency rules, error handling, and known tradeoffs.
   - Do not infer behavior that the code does not implement; separate "原始需求" from "当前实现" when they differ.
3. Inspect the target directory style.
   - Check nearby note naming, frontmatter conventions, and whether the directory contains readme/index notes.
   - Do not overwrite an existing note unless the user explicitly asks; if a name conflicts, choose a clear variant or ask when ambiguity is risky.
4. Create or update one Markdown note in the target directory.
   - Put YAML frontmatter at the top.
   - Preserve the original requirement in a dedicated section.
   - Explain current implementation with concrete references to functions, classes, commands, and defaults.
   - End with a `## 代码` section containing the complete source in a fenced code block.

## Frontmatter

Use only these default metadata fields unless the user or local directory style clearly requires more:

```yaml
---
summary: "中文摘要，说明需求目标、代码对象、核心流程、关键技术点和后续可判断的事项。"
aliases:
  - "3 到 6 个检索别名"
tags:
  - python
---
```

Follow these rules:

- Write `summary` in Chinese, normally 1-2 sentences.
- Use `aliases`, never `alias`; use a YAML list with 3-6 useful search anchors.
- Use `tags`, never `tag`; use a YAML list with at most 3 tags.
- Prefer the existing tag whitelist when the vault has one. If using the local default frontmatter skill conventions, choose from tags such as `python`, `api-design`, `project-design`, `wsl2`, `bash`, `git`, `database`, `network`, `security`, or `performance`.

## Note Shape

Use a practical structure like:

````markdown
# 标题

源文件位置：`/path/to/source.py`

## 原始目标

...原始需求整理...

## 当前实现

...代码实际行为...

## 关键配置

...默认参数、环境变量、命令...

## 核心流程

```text
读取参数
-> 校验输入
-> 执行业务流程
-> 输出统计
```

## 幂等与错误处理

...如果适用...

## 依赖

```bash
...
```

## 当前取舍

- ...

## 代码

```python
...完整代码...
```
````

Adjust headings to the domain, but keep the final code block inside the note. Do not use a wikilink or Markdown link as the primary way to associate the code when the user asks for a self-contained archive.

## Code Embedding

- Embed the exact source content unless the user asks for a cleaned-up version.
- Use the correct fenced code language, such as `python`, `bash`, `go`, `java`, or `text`.
- If the source is extremely large, tell the user and ask whether to embed it anyway or split the archive. For ordinary single-file scripts, embed it directly.
- If a code copy file was already created but the user wants self-contained notes, leave it alone unless explicitly asked to delete it; make the note itself self-contained.

## Validation

After writing, verify:

- The note starts with `---` and has a closing frontmatter delimiter.
- `summary`, `aliases`, and `tags` exist and use the expected shapes.
- No singular `alias:` or `tag:` fields were introduced.
- The final `## 代码` block exists.
- The embedded code block can be extracted and compared with the source, or parsed/compiled when feasible.
- The note contains no unintended `[[source_file]]` or similar code-link association when the user requested embedded code.
