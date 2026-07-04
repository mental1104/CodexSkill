---
name: blue-espeon-note-style
description: "Create or extend technical Obsidian notes in the Blue Espeon vault following the user's established note-generation preferences: same-directory supplement notes, explicit wikilink backlinks, Mermaid flowcharts in necessary sections, concrete examples, reference links, best-fit vault directory placement for reusable topic notes, and stepwise library/tutorial notes with compile-ready examples plus build/run outputs. Use when the user asks to generate or revise notes in this vault and wants the output to match the existing style, especially for third-party library usage notes or technical notes extracted from project reviews."
---

# Blue Espeon Note Style

Use this skill when writing or revising technical notes in this vault and the user wants the output to follow their established note style. If the target file is Markdown in Obsidian, use this skill together with `obsidian-markdown`.

## Core Preferences

- Every new Markdown content note in the Blue Espeon vault must be based on `Templates/default-note.md`: keep the `read_status`, `read_depth`, `read_at`, and `read_note` frontmatter keys, include `## AI摘要` and `## 正文`, and place generated note content under `## 正文`. Fill `## AI摘要` only when a concise summary is available. This template rule does not apply to skills, plugin files, templates, or other control/configuration documents.
- Default new companion notes to the **same directory** as the source note only when the new note is source-specific or project-specific. For durable technical topic notes, first choose the best existing vault directory using the placement rules below.
- Preserve the existing local naming scheme instead of inventing a new one. For sequenced notes, continue adjacent names such as `2-3a`, `2-3b`.
- When a new note expands an existing section, create an **explicit double link**:
  - In the source note, add a short wikilink near the relevant heading.
  - In the new note, add a top-line backlink such as `关联笔记：[[Source Note#Section]]`.
- For explanatory technical notes, include **Mermaid flowcharts in necessary sections**. Prefer diagrams for decision flow, lifecycle flow, compiler/runtime pipeline, or diagnosis workflow. Do not add decorative diagrams.
- Prefer **concrete, compilable or runnable examples** when explaining language features, compiler behavior, tools, or APIs.
- When discussing implementation details, internals, standards, or current behavior, include **reference links** and note the relevant version/date when it matters.
- Keep prose **concise, direct, and structured**, but detailed enough to support follow-up analysis.
- Prefer one independent note per single center thesis. Do not create "Q&A aggregate topic notes" whose structure is just a bundle of unrelated review questions.

## Library Tutorial Rules

Use these rules when the note teaches a library, package, framework, CLI, or API through examples.

- Every code block must be a **complete minimal unit** that can be compiled or run on its own. For Go, each example should be a full `package main` program unless the user explicitly wants a library snippet instead.
- For Go library notes, add **succinct code comments on every library-related line or block** inside the Go code block. Comment the import, constructor/setup calls, key helper functions, and important method calls that belong to the library. Do **not** waste comments on obvious Go syntax that is unrelated to the library.
- Do not merge "prepare workspace" and "compile" into one command block when the reader must paste a file in between. The default order is:
  1. create directory and `cd`
  2. instruct the reader to save the example as `main.go` (or the exact required filename)
  3. initialize dependencies and compile
  4. show compile result
  5. show run command
  6. show run result
- If local verification is possible, paste the **actual build output** and **actual run output** into the note. If a successful build normally produces no output, show proof of success in a compact way, for example by listing the generated binary.
- If version resolution matters, record the checked date and the resolved version in the note body.
- Keep examples operational for copy-paste use. Avoid hidden prerequisites between adjacent command blocks.

## Writing Workflow

1. Identify the anchor note and its directory.
2. Decide whether the task is:
   - an inline expansion inside the existing note, or
   - a new companion note that should live beside it.
3. Before creating a new note, decide whether it is a project/source companion note or a reusable topic note:
   - Project/source companion notes stay beside the source note.
   - Reusable topic notes go to the best existing topic directory, even when the question was discovered while reviewing a project note.
   - Add backlinks both ways so the original project note keeps the review trail.
4. For reusable topic notes, identify the single center thesis before writing:
   - The title should state one reusable technical question, design decision, or mechanism.
   - If the draft needs several unrelated source Q&A items to justify its table of contents, split it into multiple notes.
   - A note may cite several Q&A entries only when they all support the same thesis.
   - Avoid section lists that mirror the source Q&A order; reorganize by concept, decision flow, mechanism, example, and caveat.
5. Use `tree` or nearby `readme.md` files to inspect the relevant vault hierarchy before choosing a destination when the directory is not obvious.
6. If creating a companion note:
   - place it in the same directory;
   - continue the local naming pattern;
   - add the backlink line at the top;
   - add a forward wikilink in the source note at the relevant section.
7. Structure the content so that the reader can scan it top-down:
   - definition or scope;
   - mechanism or workflow;
   - examples;
   - caveats or boundaries;
   - references when needed.
8. Add Mermaid diagrams to sections where process understanding matters.
9. Minimize churn in existing notes. Only edit the source note where the new cross-link is relevant.

## Single-Thesis Note Rule

When extracting durable notes from review Q&A, the Q&A entries are evidence and backlinks, not the outline. Before creating a topic note, write the intended center thesis in one sentence. If that sentence needs "and" to join unrelated topics, split the note.

Good examples:

- `FastAPI CPU密集型任务执行器设计`: one thesis about where and how CPU-heavy work should leave the event loop.
- `FastAPI同步阻塞代码发现机制`: one thesis about catching sync blocking calls in async routes.
- `FastAPI与上层网关超时配置同步`: one thesis about coordinating app timeout and gateway timeout.

Poor examples:

- `FastAPI网关并发与CPU任务方案` when it includes ContextVar, K8S memory, low-frequency precomputation, static analysis, and experiments as peer sections.
- `网关数据模型与分层设计` when it mixes application layers, Redis async, Serializer APIs, response envelopes, and domain table design.

If several split notes are useful as a learning path, create at most one short index/map note only when it adds navigation value. The index should contain links and ordering guidance, not full answers copied from each child note.

## Directory Placement Rules

Choose the destination by the note's durable subject, not merely by the note where the question originated.

- **Project-specific design, requirements, incident context, or implementation decisions**: keep under `Archive/500-Project/<project>/...`.
- **Reusable programming language, framework, library, code pattern, tests, or runtime behavior**: use `Archive/200-Program/210-Code/<language>/...`.
  - Python + FastAPI, Starlette, ASGI, API middleware, response handling, FastAPI concurrency, or FastAPI app architecture: `Archive/200-Program/210-Code/Python/fastapi`.
  - Python asyncio/event loop/concurrency concepts not tied to FastAPI: `Archive/200-Program/210-Code/Python/asyncio`.
  - Python SQLAlchemy usage: `Archive/200-Program/210-Code/Python/sqlalchemy`.
  - Python pytest/testing technique: `Archive/200-Program/210-Code/Python/pytest`.
  - Python standard-library behavior: `Archive/200-Program/210-Code/Python/stdlib`.
- **Infrastructure products and operations**: use `Archive/300-Infras/<technology>` such as `Redis`, `Clickhouse`, `Kubernetes`, `Docker`, `PostgreSQL`, or `Pulsar`.
- **Computer-science concepts independent of one implementation stack**: use `Archive/100-Computer Science/...`, such as Architecture, Operating System, Network, Database, or Distributed System.
- **Software/tool usage not primarily code-library knowledge**: use `Archive/600-Software/...`.
- **Playbooks, learning maps, debugging guides, and cross-topic guidance**: use `Guide/...`.

When a project review produces a reusable topic note, put the new note in the reusable topic directory and link it from the project note's Q&A. Example: FastAPI gateway status-code and middleware analysis belongs in `Archive/200-Program/210-Code/Python/fastapi`, not in `Archive/500-Project/<project>/...`.

Do not create a broad reusable note only because several Q&A entries came from one project review session. Split by durable subject first, then place each note in its best directory.

Do not create a new directory just to avoid a decision. If no existing directory is clearly suitable, ask the user to choose the destination.

For library tutorial notes, refine the content-structure step into this concrete section pattern:

1. short purpose/when to use
2. one full example program
   - for Go examples, annotate the library-specific parts with concise comments
3. workspace creation commands
4. explicit "paste into `main.go`" instruction
5. compile commands
6. compile result
7. run commands
8. run result
9. brief caveats or selection guidance

## Diagram Rules

- Add at least one Mermaid diagram when the note explains:
  - a decision process;
  - a multi-stage implementation pipeline;
  - a diagnostic workflow;
  - a lifecycle or state transition.
- Prefer `flowchart TD` or `flowchart LR`.
- Keep node text short and analytic. The diagram should help later reasoning, not just restate prose.
- For medium notes, 1 to 3 diagrams is the default sweet spot.

Example:

````markdown
```mermaid
flowchart TD
    A["发现问题或概念"] --> B["拆成判断步骤"]
    B --> C{"是否需要跨函数/跨阶段说明？"}
    C -->|"否"| D["写正文示例"]
    C -->|"是"| E["补 Mermaid 流程图"]
```
````

## Cross-Link Pattern

Use this pattern when making a companion note:

````markdown
关联笔记：[[原笔记名#相关章节]]

# 新笔记标题
````

In the source note, use a short local sentence near the heading, for example:

```markdown
更详细的说明见：[[新笔记名]]
```

## Reference Rules

- Prefer official or primary sources when the note describes implementation details.
- Use Markdown links for external references.
- If the topic is version-sensitive, state the checked date and version in the note body.
- Do not pad the note with low-signal links; include only the references that support the explanation.

## Editing Discipline

- Preserve the tone and section style of nearby notes.
- Do not rename existing notes unless the user explicitly asks.
- Do not add frontmatter unless the surrounding note set already uses it or the user asks for it.
- When updating an existing note, avoid large rewrites if a targeted insert is enough.

## Default Output Shape

For a new technical companion note, this is the preferred baseline:

1. Backlink line
2. H1 title
3. Short scope/definition section
4. Mechanism section with one Mermaid diagram if needed
5. Concrete examples
6. Caveats or interpretation notes
7. Reference links when the topic depends on external authority

For a library usage note, prefer this stricter baseline instead:

1. H1 title
2. short scope and 2 to 4 key takeaways
3. note that each code block is independently compilable/runnable
4. repeated per-example structure:
   - full example program
   - concise comments on the library-specific lines inside the Go code
   - workspace creation commands
   - instruction to save as `main.go`
   - compile commands
   - compile result
   - run commands
   - run result
5. selection guidance or caveats
