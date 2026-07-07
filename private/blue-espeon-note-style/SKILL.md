---
name: blue-espeon-note-style
description: Blue Espeon Obsidian vault convention layer. Use only to decide note style, template shape, directory placement, naming, wikilinks, backlinks, Mermaid usage, and single-thesis boundaries. This skill is not a primary document-rewrite executor; pair its conventions with a concrete editing skill such as general-document-optimization, technical-document-optimization, or obsidian-frontmatter-metadata.
---

# Blue Espeon Note Style

## Role

This skill defines **vault conventions** for the Blue Espeon Obsidian vault.

It answers:

- where a note should live;
- how a note should be named;
- whether a new note should be a companion note or a reusable topic note;
- what template shape the note should follow;
- how backlinks and wikilinks should be placed;
- whether Mermaid is useful;
- whether the note has one center thesis or should be split.

It does not perform full note rewrites by itself.

## Use When

Use this skill when the task involves:

- creating or placing a note in the Blue Espeon vault;
- deciding note directory or naming;
- adding companion-note backlinks;
- checking whether a note violates the single-thesis rule;
- applying vault-level style expectations to another Obsidian editing skill.

## Do Not Use As Primary Skill When

- The task only changes YAML metadata: use `obsidian-frontmatter-metadata`.
- The task rewrites an old non-technical note: use `general-document-optimization`.
- The task rewrites an old technical note, experiment note, code note, or test note: use `technical-document-optimization`.
- The task reconstructs source-code context for ChatGPT: use `source-walk`.

When paired with another skill, this skill supplies conventions only. The concrete editing skill owns the workflow.

## Core Vault Rules

### Default Note Template

Every new Markdown content note in the Blue Espeon vault should follow `Templates/default-note.md` unless the target directory clearly uses another established pattern.

Keep:

- `read_status`;
- `read_depth`;
- `read_at`;
- `read_note`;
- `## AI摘要`;
- `## 正文`.

Generated note content goes under `## 正文`.
Fill `## AI摘要` only when a concise summary is available.

This template rule does not apply to skills, plugin files, templates, or other control/configuration documents.

### Companion Notes

Use a same-directory companion note only when the new note is source-specific or project-specific.

For a companion note:

1. Place it beside the source note.
2. Preserve the local naming scheme.
3. Add a top-line backlink such as:

```markdown
关联笔记：[[Source Note#Section]]
```

4. Add a short forward wikilink in the source note near the relevant section.

### Reusable Topic Notes

For durable reusable knowledge, choose the best existing topic directory instead of blindly placing the note beside the source note.

A reusable note should have one center thesis.

Good:

- `FastAPI CPU密集型任务执行器设计`
- `FastAPI同步阻塞代码发现机制`
- `FastAPI与上层网关超时配置同步`

Bad:

- `FastAPI网关并发与CPU任务方案` when it mixes ContextVar, K8S memory, precomputation, static analysis, and experiments as peer topics.
- `网关数据模型与分层设计` when it mixes application layers, Redis async, Serializer APIs, response envelopes, and domain table design.

If the thesis sentence needs "and" to join unrelated topics, split the note.

### Directory Placement

Choose by durable subject, not by where the question originated.

- Project-specific design, requirements, incidents, or implementation decisions: `Archive/500-Project/<project>/...`.
- Reusable programming language, framework, library, code pattern, tests, or runtime behavior: `Archive/200-Program/210-Code/<language>/...`.
  - FastAPI, Starlette, ASGI, API middleware, response handling, concurrency, or app architecture: `Archive/200-Program/210-Code/Python/fastapi`.
  - Python asyncio/event loop/concurrency concepts not tied to FastAPI: `Archive/200-Program/210-Code/Python/asyncio`.
  - SQLAlchemy: `Archive/200-Program/210-Code/Python/sqlalchemy`.
  - pytest/testing technique: `Archive/200-Program/210-Code/Python/pytest`.
  - Python standard library behavior: `Archive/200-Program/210-Code/Python/stdlib`.
- Infrastructure products and operations: `Archive/300-Infras/<technology>`.
- Computer-science concepts independent of one implementation stack: `Archive/100-Computer Science/...`.
- Software/tool usage not primarily code-library knowledge: `Archive/600-Software/...`.
- Playbooks, learning maps, debugging guides, and cross-topic guidance: `Guide/...`.

Do not create a new directory just to avoid a decision. If no existing directory is clearly suitable, ask the user or report uncertainty.

## Wikilink Rules

Use wikilinks for:

- real prerequisites;
- source notes;
- durable related notes;
- companion-note navigation.

Do not wikilink every noun.
Do not add decorative links.
Do not use Obsidian table cells with `[[#heading|alias]]`; the `|` can break Markdown table parsing. Use `[[#heading]]: explanation` instead.

## Mermaid Rules

Mermaid is a navigation aid, not decoration.

Use Mermaid when the note explains:

- decision flow;
- lifecycle;
- runtime pipeline;
- diagnosis workflow;
- control/data flow;
- state transition.

Default: 5-9 nodes.
Split large diagrams.
Place the diagram near the paragraph it explains.
Add one sentence before and after the diagram to explain what to observe and what conclusion to take.

Do not use Mermaid for flat lists, simple definitions, or decorative summaries.

## Example Rules

When the note teaches a library, package, framework, CLI, or API through examples:

1. Prefer complete minimal examples that can compile or run.
2. For Go examples, use a full `package main` program unless the user asks otherwise.
3. Comment library-specific lines, not obvious language syntax.
4. Keep workspace setup, file paste, dependency install, compile, and run steps separate when the reader must act between steps.
5. If local verification is possible, paste actual build/run output.

## Output Contract

When this skill is used alone, return only a style decision packet:

```markdown
## Blue Espeon Style Decision

- Note type: companion / reusable topic / inline expansion
- Suggested location: `<path>`
- Naming rule: <rule>
- Required backlinks: <yes/no + where>
- Template: <default-note / existing local pattern / unknown>
- Mermaid: <needed / not needed + reason>
- Split required: <yes/no + reason>
- Uncertainty: <max 3 bullets>
```

When paired with another skill, do not output a separate long report unless the user asks.
