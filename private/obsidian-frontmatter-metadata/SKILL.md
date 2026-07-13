---
name: obsidian-frontmatter-metadata
description: Normalize Obsidian note YAML frontmatter to the compact Blue Espeon four-field contract: source, tags, summary, and read_status. Use for generating, repairing, dry-running, or batch-applying note metadata while preserving the Markdown body.
---

# Obsidian Frontmatter Metadata

Use this skill to generate or normalize note frontmatter to exactly four fields:

- `source`
- `tags`
- `summary`
- `read_status`

Do not add `title`, `aliases`, `created`, `updated`, `related`, `repo`, `branch`, `source_commit`, `source_files`, `test_status`, `read_depth`, `read_at`, `read_note`, or other convenience fields.

This four-field rule applies to content notes. It does not apply to skill files, plugin files, templates, or other control/configuration documents.

## Canonical Shape

Keep this field order:

```yaml
---
source: ""
tags: []
summary: ""
read_status: unread
---
```

Use a YAML list for `tags` when tags exist:

```yaml
---
source: "https://example.com/source"
tags:
  - network
  - cpp
summary: "一句或两句说明本文讨论什么、得到什么结论。"
read_status: unread
---
```

## Core Workflow

1. Identify the exact user-approved file or directory scope.
2. Inspect the existing frontmatter and enough body content to understand the note.
3. Unless the user explicitly requests immediate writing, show a dry-run first.
4. When writing, replace the frontmatter with the four-field canonical shape.
5. Preserve the Markdown body byte-for-byte whenever practical.
6. Validate that the file starts with one valid YAML block and contains no extra frontmatter keys.

## Field Rules

### source

- Preserve a useful existing source URL, repository location, book/article identifier, or supplied source description.
- Prefer one concise scalar value instead of a large nested structure or long file list.
- If the source is unknown, use `source: ""`; do not invent one.
- Move detailed source files, commit notes, test status, and related links into the body only when they are genuinely useful.

### tags

- Use `tags`, never `tag`.
- Use a YAML list.
- Keep 0-3 durable retrieval tags; do not fill slots for appearance.
- If no tag fits, use `tags: []`.
- Preserve reasonable existing tags and remove decorative or overly specific tags.

Default whitelist when the user has not supplied another one:

```text
cpp
go
python
algorithms
data-structures
computer-architecture
operating-system
network
database
linux
bash
calculus
linear-algebra
probability
discrete-math
numerical-analysis
docker
kubernetes
postgresql
redis
pulsar
flink
clickhouse
distributed-systems
project-design
api-design
security
design-patterns
concurrency
performance
cmake
git
wsl2
video-editing
```

### summary

- Write in Chinese unless the note itself requires another language.
- Use 1-2 readable sentences.
- State the analysis/design object, main path, and practical conclusion.
- Do not evaluate the note's quality or add unsupported claims.
- Keep it compact enough to scan in Obsidian Properties.

### read_status

- Preserve a valid existing value.
- For a newly generated or normalized unread note, default to `unread`.
- Do not generate companion fields such as `read_depth`, `read_at`, or `read_note`.

## YAML Formatting

- Put frontmatter at the very start of the file.
- Keep all four keys at the top level.
- Use two-space indentation for tag list items.
- Quote `source` and `summary` when YAML-sensitive characters may appear.
- Do not insert blank lines inside frontmatter.
- Remove every frontmatter key outside the four-field contract.

## Dry-Run Output Shape

```text
文件：xxx.md
当前字段：...
将保留：source / tags / summary / read_status
将移除：...

准备修改为：
---
source: "..."
tags:
  - ...
summary: "..."
read_status: unread
---

说明：
- source 取值依据：
- tag 调整：
- 不确定之处：
```

## Validation Checklist

- frontmatter has exactly four top-level keys;
- key order is `source`, `tags`, `summary`, `read_status`;
- `tags` is a YAML list;
- no deprecated or convenience metadata remains;
- the Markdown body is unchanged.
