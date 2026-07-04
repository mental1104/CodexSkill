---
name: source-walk
description: Demand-driven source code reading and archival. Use when the user asks to trace, explain, or document source code for a concrete question. Appends each round to an Obsidian temp Markdown note, records file paths and line numbers, generates tree-style call chains, and preserves unresolved questions as Obsidian tasks.
---

# Source Walk Skill

## Purpose

This skill performs demand-driven source code reading.

Do not read source code linearly from entry to bottom. Start from the user's concrete question, locate the minimum relevant source path, explain the mechanism, and append the round to a temporary Markdown note.

The goal is not just to answer once. The goal is to create a traceable source-reading record that the user can later summarize and archive into Obsidian.

## Trigger Conditions

Use this skill when the user asks to:

- read source code
- trace a function
- trace a parameter
- trace an object
- explain a concrete source-level mechanism
- inspect a call chain
- archive a source-reading round
- connect an experiment or requirement to source code
- produce source evidence with file paths and line numbers

Typical user wording:

- “看一下这个源码”
- “这个参数一路怎么传”
- “从实验现象反推源码”
- “给我源码走读”
- “把这一轮走读归档”
- “追一下这个函数”
- “帮我生成 Codex 源码阅读笔记”

## Core Principles

1. Read source code only for the current question.
2. Prefer source evidence over broad explanation.
3. Every answer must be grounded in file paths and line numbers.
4. Every source-walk round must be appended to the active temporary Markdown note.
5. Each user question becomes one level-3 Markdown heading.
6. Preserve both human explanation and machine-checkable source references.
7. Do not modify product source code unless the user explicitly asks.
8. Do not create heavy diagrams by default.
9. Use Mermaid only when control flow, state transitions, async callbacks, lifecycle phases, or branching paths are hard to explain with plain text.
10. Use Markdown tables when raw facts, structs, flags, fields, source locations, or experimental numbers need comparison.
11. Unresolved questions must use Obsidian task syntax: `- [ ]`.

## Data Structure and Lifecycle Policy

When the user asks about a data structure, object layout, class, struct, enum, encoding, or memory layout:

1. Treat the question as a lifecycle question, not just a definition lookup.
2. Include the relevant class/struct/typedef/macro definitions in the note. Keep excerpts minimal and source-linked.
3. For each focus object, list it as a bullet under `关注对象`; do not flatten multiple objects with slashes.
4. Immediately after the metadata, add one level-4 heading per focus object and paste its source:
   - For variables, constants, macros, enum values, and fields, use a one-line code snippet.
   - For class/struct/typedef definitions, use a fenced code block plus a text memory/layout diagram when layout matters.
5. If the user did not name a concrete runtime entry, choose a minimal real business entry and state the assumption. For example, use a `redis-cli SET key value` path when explaining Redis string creation.
6. Explain the lifecycle from entry to exit: command/API entry, parsing or lookup, allocation, initialization, storage/reference ownership, read/use, mutation or encoding conversion, and destruction/freeing. Include only stages that exist in the relevant code path.
7. Put the same layout diagram in the note, not only in the chat response.
8. Tables and diagrams must have a short sentence explaining what they are for and how they connect to the lifecycle.

## Temp Note Location Policy

The temporary source-walk note should be saved as a Markdown file.

Resolve the temp note directory in this order:

1. If `$OBSIDIAN_TEMP` exists, save directly under `$OBSIDIAN_TEMP`.
2. Else if `$OBSIDIAN_VAULT` exists, save directly under `$OBSIDIAN_VAULT/Craft`.
3. Else save directly under `/tmp`.

Do not create deep nested directories by default.

Filename format:

```text
YYYY-MM-DD-<topic>-source-walk.md
```

Examples:

```text
2026-07-04-redis-sds-source-walk.md
2026-07-04-epoll-wakeup-source-walk.md
2026-07-05-go-net-http-source-walk.md
```

If the user provides an explicit temp note path, use the provided path.

If the active temp note already exists, append to it.

If it does not exist, create it.

Do not rewrite previous rounds unless the user explicitly asks.

## Expected Obsidian Paths

With the following environment variables:

```bash
export OBSIDIAN_VAULT="/mnt/c/Users/menta/Documents/ObsidianVaults/BlueEspeon"
export OBSIDIAN_TEMP="$OBSIDIAN_VAULT/Craft"
```

A Redis SDS source-walk note should be written to:

```text
/mnt/c/Users/menta/Documents/ObsidianVaults/BlueEspeon/Craft/2026-07-04-redis-sds-source-walk.md
```

Its relative path inside the Obsidian vault is:

```text
Craft/2026-07-04-redis-sds-source-walk.md
```

## Active Note Resolution

Before answering a source-walk question:

1. Determine the topic.
2. Resolve the temp note path.
3. If the user explicitly provides an active note path, use it.
4. Otherwise, infer a concise topic from the repository name and the current source question.
5. Use the current local date for the file name.
6. If the temp note exists, append to it.
7. If the temp note does not exist, create it with a short front section.

Initial temp note front section:

```markdown
# <topic> 源码走读临时笔记

- 创建时间：<local datetime>
- 状态：临时走读
- 来源：<experiment / requirement / conversation context if known>
- 归档目标：待整理

## 走读记录
```

## Source Link Policy

For every cited source location, record:

1. Local file path.
2. Line number or line range.
3. Function, method, struct, field, or symbol name when available.
4. GitHub URL if the file belongs to a Git repository with a GitHub remote.

When possible, detect:

- repository root
- current branch
- current commit hash
- origin remote URL
- relative path from repository root

If the repository has a GitHub remote, generate a GitHub source URL.

Preferred URL format:

```text
https://github.com/<owner>/<repo>/blob/<branch-or-commit>/<relative-path>#L<start>-L<end>
```

Prefer commit permalink as evidence when available.

Branch links are allowed for convenience, but commit links are better for stable archival.

If the repository has no GitHub remote, record the local absolute path only.

In Markdown output, every non-code source location must be a clickable Markdown link whenever a URL exists. Use the source position as the label. Do not wrap the whole Markdown link in backticks.

Examples:

```markdown
- GitHub：[src/sds.c:123-L170](https://github.com/redis/redis/blob/unstable/src/sds.c#L123-L170)
- 固定证据：[src/sds.c:123-L170](https://github.com/redis/redis/blob/<commit-sha>/src/sds.c#L123-L170)
- 本地：`/home/mental1104/code/redis/src/sds.c:123`
```

## Per-Round Markdown Format

Every source-walk round must be appended using this structure:

```markdown
### QNN <本轮源码问题>

- 时间：<local datetime>
- 来源：<related experiment / requirement / note, preferably Obsidian wikilink if known>
- 关注对象：
  - `<object_or_symbol>`：<why it matters>
  - `<object_or_symbol>`：<why it matters>
- 源码位置：
  - GitHub：[<relative-path>:<start>-L<end>](<GitHub URL if available>)
  - 固定证据：[<relative-path>:<start>-L<end>](<commit permalink if available>)
  - 本地：`<absolute-or-repo-relative-path>:<line>`

#### `<focus object or symbol>`

- 位置：[<relative-path>:<line>](<GitHub or commit URL if available>)

For a variable, constant, macro, enum value, or field:

```c
<one-line source definition>
```

For a class/struct/typedef or memory-relevant object:

```c
<minimal class/struct/typedef source definition>
```

```text
<memory/layout diagram when the question is about data structure or layout>
```

#### 省流结论

- <conclusion 1>
- <conclusion 2>
- <conclusion 3>

#### 参数 / 调用树 / 生命周期树

```text
<root_function>(<path>:<line>)
├── 1. <callee_a>(<path>:<line>)
├── 2. <callee_b>(<path>:<line>)
│   └── 2.1 <deeper_callee>(<path>:<line>)
└── 3. <callee_c>(<path>:<line>)
```

#### 关键证据

List evidence in execution, call-chain, or lifecycle order. Do not sort by file path.

| 顺序 | 位置 | 证据 | 生命周期阶段 / 说明 |
|---:|---|---|---|
| 1 | [<file>:<line>](<GitHub or commit URL if available>) | `<symbol / branch / assignment / condition>` | <why it matters at this point in the path> |

#### 走读解释

<Explain the relevant path from start to end. For data-structure questions, walk through creation, initialization, ownership/storage, read or mutation behavior, encoding conversion if relevant, and destruction/freeing. Avoid unrelated branches.>

#### 图 / 表

<Before every table or diagram, explain what it is for and which lifecycle stage it clarifies. If no table/diagram is needed, say why.>

#### 未解决问题

- [ ] <actionable follow-up source-reading question>
```

## QNN Numbering Rules

When appending a new round:

1. Inspect the existing note if it exists.
2. Find the largest existing `### QNN`.
3. Use the next number.
4. If no previous question exists, start from `Q01`.

Examples:

```markdown
### Q01 SDS 为什么不用普通 C 字符串
### Q02 SDS 扩容策略在哪里
### Q03 SDS 和 Redis object 编码有什么关系
```

## Call Tree Rules

Use a tree format to represent parameter, object, or control-flow movement.

Rules:

1. Top to bottom means execution order.
2. Same level means sequential calls in the current function.
3. Deeper indentation means the parameter or object enters a nested function.
4. Returning to a previous indentation level means the nested call completed.
5. If a node has no child, the parameter or object did not continue into deeper calls there.
6. Use numbering to preserve order.
7. Do not pretend the full runtime path is known if only static source evidence is available.
8. Mark inferred paths clearly when necessary.

Example:

```text
function_a(src/a.c:10)
├── 1. function_b(src/b.c:20)
├── 2. function_c(src/c.c:30)
│   └── 2.1 function_d(src/d.c:40)
└── 3. function_e(src/e.c:50)
```

Meaning:

```text
function_a starts
├── first enters function_b
├── then enters function_c
│   └── function_c enters function_d
└── finally function_a continues and enters function_e
```

This is not a full runtime stack.

This is not a complete static call graph.

This is a demand-driven source-reading tree for the current question.

Keep it small enough to fit in a note.

Prefer 3-12 nodes unless the user explicitly asks for a larger trace. For data-structure lifecycle questions, 8-16 nodes are acceptable when needed to show creation through destruction.

Paths inside code blocks are not clickable in many Markdown renderers, so keep clickable source links in `源码位置`, focus-object source blocks, and `关键证据`.

## Mermaid / Diagram Policy

Do not output Mermaid by default.

Use Mermaid only when one of these is true:

1. There is a lifecycle.
2. There is a state machine.
3. There is async callback flow.
4. There is event-driven control flow.
5. There are multiple branching execution paths.
6. Plain tree text is not enough.

Use Markdown tables when comparing:

- struct fields
- flags
- enum values
- source locations
- function responsibilities
- experimental numbers
- data layout
- state transitions

SVG output is optional and should only be produced when explicitly useful.

Do not leave a table or diagram as a detached artifact. Add one sentence before it that states its purpose and one sentence after it that states the conclusion the reader should take from it.

## Answer Policy

After appending the source-walk round to the temp note, respond to the user with:

1. The direct answer to the current source question.
2. The key source locations used.
3. The tree-style call chain when relevant.
4. A short note saying the round has been appended.
5. The active temp note path.
6. The Obsidian-relative path if the note is inside `$OBSIDIAN_VAULT`.

Do not over-explain unrelated source code.

Do not ask many follow-up questions.

Prefer giving 1-3 possible next source-walk directions as unchecked Obsidian tasks.

## Finalize Policy

When the user says finalize, archive, summarize, close this source walk, or asks to produce a formal Obsidian note:

1. Read the active temp note.
2. Produce a clean final Obsidian note.
3. Keep the original question-driven structure.
4. Add a top-level summary.
5. Add a mental model section.
6. Add a source map section.
7. Preserve source links and line references.
8. Preserve unresolved questions as `- [ ]` tasks.
9. Link back to the original experiment or requirement note if provided.
10. Do not delete the temp note unless the user explicitly asks.

Suggested final note structure:

```markdown
# <topic> 源码走读：<from what question to what mechanism>

## 头部结论

- ...
- ...
- ...

## 来源

- 来源实验：[[...]]
- 临时走读：[[Craft/...]]

## 读这块源码的心智模型

...

## Source Map

| 问题 | 关键函数 / 对象 | 文件 | 作用 |
|---|---|---|---|
| ... | ... | ... | ... |

## 问题走读记录

### Q01 ...

...

### Q02 ...

...

## 总调用树

```text
...
```

## 未解决问题

- [ ] ...
- [ ] ...

## 相关链接

- [[...]]
```

## Safety and Modification Policy

This skill is for reading and documenting source code.

Do not modify source code.

Do not run destructive commands.

Do not rewrite user notes except the active temp source-walk note.

Appending to the temp source-walk note is allowed.

Creating a final Obsidian note is allowed when the user asks to finalize or archive.

## Minimal Successful Output

A successful source-walk round must contain:

1. A direct answer.
2. Clickable Markdown source links for GitHub-backed file locations.
3. Source evidence ordered by execution, call-chain, or lifecycle sequence.
4. Tree-style call chain when applicable.
5. Appended Markdown round under `### QNN`.
6. Unresolved follow-ups as `- [ ]`.
7. Active temp note path.
8. For data-structure questions, focus-object source snippets, memory/layout diagrams, and lifecycle explanation from creation to destruction.
