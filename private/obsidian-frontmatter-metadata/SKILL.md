---
name: obsidian-frontmatter-metadata
description: Add or curate Obsidian YAML frontmatter metadata for Markdown notes, especially summary, aliases, and tags. Use when the user asks to generate, repair, dry-run, or batch-apply frontmatter metadata in an Obsidian vault while preserving note bodies and respecting tag whitelists.
---

# Obsidian Frontmatter Metadata

Use this skill to add or curate only these Obsidian YAML frontmatter fields:

- `summary`
- `aliases`
- `tags`

Pair this with the `obsidian-markdown` skill when Obsidian syntax details matter.

## Core Workflow

1. Identify the exact user-approved scope.
   - Respect a specified directory or file list.
   - Do not recurse into subdirectories unless explicitly requested.
   - Process only Markdown files unless explicitly told otherwise.
2. Inspect existing frontmatter and enough body content to understand the note.
   - Preserve all existing non-target fields.
   - Preserve reasonable existing `summary`, `aliases`, and `tags`.
   - Modify target fields only when missing, malformed, noncompliant, or clearly wrong.
3. Always dry-run first unless the user explicitly says to write immediately.
   - List every file to change.
   - Show current frontmatter status.
   - Mark each target field as `新增`, `保留`, `修正`, or `补充`.
   - Show the exact proposed frontmatter.
   - Include modification reason and uncertainty.
4. Wait for user confirmation before writing.
5. When writing, edit only frontmatter.
   - Do not modify note body content.
   - Do not rename, move, create unrelated notes, change links, images, attachments, or plugin config.
6. Validate after writing.
   - Check processed files start with `---` and have a closing `---`.
   - Check `aliases` and `tags` are YAML lists.
   - Check no singular `alias:` or `tag:` fields were introduced.
   - Check tags are in the allowed whitelist and each note has at most 3 tags.

## Summary Rules

- Write in Chinese.
- Default length: 200-300 units, where each Chinese character counts as 1 and each English word, acronym, code identifier, or product name counts as 1.
- Use 1-2 readable sentences; do not force a single overlong sentence.
- The summary should let the user understand the article's rough content without reading the body; reading the body should mainly add details.
- Cover:
  - the document's analysis object or design object
  - main modules, flows, or scenarios
  - key technical concepts
  - what the reader can decide or understand after reading it
- Do not evaluate quality.
- Do not add claims not supported by the note body.
- If the note is short or ambiguous, write conservatively and state uncertainty in the dry-run.

## Aliases Rules

- Use `aliases`, never `alias`.
- Use YAML list format.
- Generate or maintain 3-6 aliases; never exceed 6.
- Prefer:
  - filename-related terms
  - high-frequency domain keywords from the body
  - future search anchors the user might remember
  - pragmatic Chinese/English mixed phrases from the note
- Avoid generic aliases such as `学习`, `笔记`, `总结`.
- Preserve reasonable existing aliases and supplement missing search anchors.

## Tags Rules

- Use `tags`, never `tag`.
- Use YAML list format.
- Each note may have 0-3 tags.
- Do not force tags just to fill slots.
- If no tag fits, use `tags: []`.
- If existing tags are outside the whitelist, report them in dry-run and propose removal or replacement.
- If the user provides a whitelist, use that whitelist. Otherwise use this default whitelist:

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

## YAML Formatting

- Put frontmatter at the start of the file.
- If existing frontmatter exists, edit only the target fields inside it.
- If no frontmatter exists, insert a new block before the body.
- Use `aliases` and `tags` as YAML lists.
- Write YAML list items with two-space indentation under their key:
  ```yaml
  aliases:
    - "Example alias"
  tags:
    - algorithms
  ```
- Keep every property key at the top level unless the field is intentionally nested. Do not accidentally indent `tags`, `summary`, `aliases`, or status fields under a previous list item.
- Do not insert blank lines inside frontmatter unless there is a clear reason; blank lines make indentation mistakes harder to see in Obsidian Properties.
- Quote `summary` and aliases with double quotes by default.
- Escape double quotes inside quoted strings if needed.
- Quote strings containing YAML-sensitive characters such as `:`, `"`, `#`, `[`, `]`, `{`, `}`.
- Keep other existing frontmatter fields and ordering as stable as practical.

## Obsidian Property Validity

When Obsidian shows a frontmatter field as an invalid property, first check YAML structure, not only field names.

Common cause:

```yaml
aliases:
  - "Alias"
    tags:
  - algorithms
```

Here `tags` is incorrectly indented under the `aliases` list item. It must be top-level:

```yaml
aliases:
  - "Alias"
tags:
  - algorithms
```

Validation checklist:

- frontmatter starts with `---` on the first line and has a closing `---`;
- `summary`, `aliases`, `tags`, and status metadata are top-level keys;
- `aliases` and `tags` are YAML lists, not nested maps;
- list items are consistently indented with two spaces;
- YAML can be parsed by a standard parser before finishing.

## Dry-Run Output Shape

Use this structure unless the user asks for another format:

```text
文件：xxx.md
当前状态：已有 frontmatter / 无 frontmatter

字段变化：
- summary：新增 / 保留 / 修正
- aliases：新增 / 保留 / 补充 / 修正
- tags：新增 / 保留 / 修正

准备修改为：
---
summary: "..."
aliases:
  - "..."
tags:
  - ...
---

说明：
- 修改理由：
- 不确定之处：
```

End with:

- 将修改的文件数量
- 保留不变的文件数量
- 无法判断的文件数量
- 发现的不合规 tag
- 不确定之处

## Useful Local Checks

- List target files: `find TARGET_DIR -maxdepth 1 -type f -name '*.md' -print`
- Check first line: `head -n 1 FILE`
- Find bad singular fields: `rg -n '^(alias|tag):' TARGET_DIR -g '*.md'`
- Count generated summaries: `rg -l '^summary:' TARGET_DIR -g '*.md' | wc -l`
- Check frontmatter delimiters near the top with `awk` or `sed`.
