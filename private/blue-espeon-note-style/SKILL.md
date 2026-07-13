---
name: blue-espeon-note-style
description: Blue Espeon Obsidian vault convention layer. Use only to decide note style, template shape, directory placement, naming, wikilinks, backlinks, visualization choice and syntax, and single-thesis boundaries. This skill is not a primary document-rewrite executor; pair its conventions with a concrete note-writing or editing skill.
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
- whether a visual is useful;
- which supported visualization syntax should be used;
- whether the note has one center thesis or should be split.

It does not perform full note rewrites by itself.

## Use When

Use this skill when the task involves:

- creating or placing a note in the Blue Espeon vault;
- deciding note directory or naming;
- adding companion-note backlinks;
- checking whether a note violates the single-thesis rule;
- deciding whether Mermaid, Charts, Dataview, Markmap, Infographic, or an existing Excalidraw asset should appear;
- applying vault-level style expectations to another Obsidian editing skill.

## Do Not Use As Primary Skill When

- The task only changes YAML metadata: use `obsidian-frontmatter-metadata`.
- The task rewrites an old non-technical note: use the matching general document optimization skill.
- The task rewrites an old technical note, experiment note, code note, or test note: use the matching technical document optimization skill.
- The task reconstructs repository evidence: use `source-walk` or `note-code-walkthrough` according to the router.

When paired with another skill, this skill supplies conventions only. The concrete editing skill owns the workflow and final note.

# Core Vault Rules

## Default Note Template

Every new Markdown content note in the Blue Espeon vault may reuse the body structure from `Templates/default-note.md`, unless the target directory clearly uses another established pattern.

The YAML frontmatter is stricter than the template and must contain exactly these four fields:

```yaml
---
source: ""
tags: []
summary: ""
read_status: unread
---
```

Keep:

- `source`;
- `tags`;
- `summary`;
- `read_status`;
- `## AI摘要`;
- `## 正文`.

Do not add convenience metadata such as `title`, `aliases`, `created`, `updated`, `related`, `repo`, `branch`, `source_commit`, `source_files`, `test_status`, `read_depth`, `read_at`, `read_note`, or visualization-plugin settings.

Generated note content goes under `## 正文`.

Fill `## AI摘要` only when a concise summary is available.

This template rule does not apply to skills, plugin files, templates, or other control/configuration documents.

## Companion Notes

Use a same-directory companion note only when the new note is source-specific or project-specific.

For a companion note:

1. Place it beside the source note.
2. Preserve the local naming scheme.
3. Add a top-line backlink such as:

```markdown
关联笔记：[[Source Note#Section]]
```

4. Add a short forward wikilink in the source note near the relevant section.

## Reusable Topic Notes

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

## Directory Placement

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

# Wikilink Rules

Use wikilinks for:

- real prerequisites;
- source notes;
- durable related notes;
- companion-note navigation.

Do not wikilink every noun.

Do not add decorative links.

Do not use Obsidian table cells with `[[#heading|alias]]`; the `|` can break Markdown table parsing. Use `[[#heading]]: explanation` instead.

# Visualization Operating Model

## Pilot Scope

This is the v1 pilot visualization set:

| Capability | Status | Rendering dependency |
|---|---|---|
| Mermaid | stable default | Obsidian built-in Mermaid support |
| `chart` code blocks | stable default | Charts community plugin |
| `dataview` / `dataviewjs` | stable when data is vault-derived | Dataview community plugin |
| DataviewJS-rendered charts | stable with constraints | Dataview + Charts |
| `markmap` code blocks | stable for outline views | Mindmap NextGen |
| `infographic` code blocks | experimental | BRAT + `hcg1023/obsidian-infographic` |
| Excalidraw embeds | existing assets only | Excalidraw community plugin |
| Plotly, ECharts, Tracker, custom HTML/JS | disabled in v1 | do not generate by default |

Do not invent another visualization syntax because it looks plausible.

## Visual Selection Order

Choose the lightest representation that answers the reader's question:

1. prose or a Markdown list for a simple definition or flat set;
2. Markdown table when exact values or side-by-side comparison matter;
3. Mermaid for process, relationship, lifecycle, state, or control/data flow;
4. Charts for numeric comparison, trend, distribution, or composition;
5. Dataview + Charts only when the source data should update from vault metadata;
6. Markmap for a hierarchical overview of one note or one knowledge area;
7. Infographic for a compact explanatory sequence or conclusion-first narrative;
8. an existing Excalidraw asset for a manually curated explanatory drawing.

A visual is optional. Do not add one merely to make the note look richer.

## General Visual Rules

Every generated visual must satisfy all of these rules:

1. It answers one explicit reading question.
2. It appears next to the paragraph it supports.
3. Add one sentence before it explaining what to inspect.
4. Add one sentence after it stating the takeaway.
5. Keep the underlying claim understandable without the plugin rendering.
6. Do not repeat the whole surrounding section inside the visual.
7. Prefer zero to three visuals in a normal note.
8. More than three visuals require an evidence-heavy note, a long code walkthrough, or a clear multi-stage explanation.
9. Never use a chart to hide missing data, unclear units, or unsupported conclusions.
10. Never fetch remote data or execute network requests from a generated visualization block.

For `note-conclusion-evidence`, when exact values support the conclusion, preserve the source-of-truth values in a compact Markdown table or raw evidence section. Treat the chart as a derived reading aid, not the only copy of the data.

## Renderability Contract

Before emitting a plugin-backed visual, verify:

- the fenced-code language is exactly supported;
- indentation is internally consistent;
- labels and numeric series align;
- units are explained outside raw numeric arrays;
- no unverified template name, option, field, or API is invented;
- any vault path, tag, property, note name, or Excalidraw asset actually exists or is explicitly provided;
- a plain-text conclusion remains when rendering fails.

If renderability cannot be established, use a Markdown table, list, or Mermaid instead.

# Mermaid Rules

Mermaid is a navigation and mechanism aid, not decoration.

Use Mermaid when the note explains:

- decision flow;
- lifecycle;
- runtime pipeline;
- diagnosis workflow;
- control/data flow;
- state transition;
- component or ownership relationship.

Default: 5-9 nodes.

Split large diagrams.

Prefer short node labels. Put long explanations in prose, not inside nodes.

Place the diagram near the paragraph it explains.

Do not use Mermaid for:

- flat lists;
- simple definitions;
- numeric trends;
- dense benchmark data;
- decorative summaries.

# Charts Rules

## When To Use

Use a `chart` block for static numeric data embedded in the current note.

Preferred chart types:

- `bar`: categorical comparison or ranking;
- `line`: ordered progression or time series;
- `pie` or `doughnut`: one meaningful whole with no more than six categories;
- `radar`: only when several entities share the same small set of comparable dimensions.

Prefer a Markdown table over a pie chart when exact comparison matters.

## Canonical Syntax

Use the Charts plugin YAML-style code block:

````markdown
```chart
type: line
labels: [0ms, 10ms, 20ms, 50ms]
series:
  - title: p95 latency
    data: [1.2, 11.4, 21.8, 52.1]
  - title: p99 latency
    data: [1.8, 12.7, 23.4, 55.6]
```
````

## Static Chart Constraints

- Use the fenced-code language `chart`, singular.
- `type`, `labels`, and `series` are required for the default generated form.
- Every `series[*].data` array must have exactly the same length as `labels`.
- Data values must be numbers, not strings containing units.
- Put the unit in the series title, chart-adjacent sentence, heading, or source table.
- Quote labels when they contain commas, colons, brackets, leading symbols, or other YAML-sensitive characters.
- Keep one chart focused on one comparison.
- Prefer one to three series.
- Prefer 3-12 visible categories; split larger comparisons or use a table.
- Keep category order meaningful and deterministic.
- Do not hard-code decorative colors by default.
- Do not emit undocumented Chart.js options merely to improve appearance.
- Do not use 3D effects.
- Do not create a chart when the data is incomplete or only verbally estimated unless the note clearly labels it as an estimate.

# Dataview And Dynamic Chart Rules

## When To Use Dataview

Use plain `dataview` when the reader needs a live table or list from existing note metadata.

Use `dataviewjs` only when:

- the data spans multiple notes;
- filtering, transformation, aggregation, or chart rendering is required;
- the relevant properties and query scope are verified;
- static chart data would become stale or duplicate an existing vault dataset.

Do not introduce Dataview solely to avoid writing a short static table.

## DataviewJS + Charts API

The supported rendering API is:

```javascript
window.renderChart(chartData, this.container);
```

Canonical structure:

````markdown
```dataviewjs
const pages = dv.pages('"VERIFIED/PATH"')
  .where((page) => page.metric != null)
  .sort((page) => page.date, "asc");

const labels = pages.map((page) => page.file.name).values;
const values = pages.map((page) => Number(page.metric)).values;

if (labels.length === 0) {
  dv.paragraph("暂无可视化数据。");
} else {
  const chartData = {
    type: "bar",
    data: {
      labels,
      datasets: [
        {
          label: "Metric",
          data: values,
        },
      ],
    },
  };

  window.renderChart(chartData, this.container);
}
```
````

Replace `VERIFIED/PATH`, `metric`, `date`, and labels with values verified from the target vault. Never leave placeholders in a final note.

## Dynamic Chart Constraints

- Use `dataviewjs`, not `dataview`, for `window.renderChart`.
- Use only local vault metadata and Dataview page data.
- Do not use `fetch`, remote URLs, filesystem APIs, shell commands, or hidden side effects.
- Filter null and non-numeric values before charting.
- Convert numeric properties explicitly with `Number(...)` when needed.
- Sort rows explicitly when order carries meaning.
- Provide an empty-state message.
- Keep chart construction local to the block; do not depend on undeclared globals except `dv`, `this.container`, and `window.renderChart`.
- Do not mutate notes or metadata from visualization code.
- When a static snapshot is the actual evidence, prefer a static `chart` block plus the raw table.

# Markmap Rules

Use a `markmap` block for a compact hierarchical overview.

Canonical syntax:

````markdown
```markmap
# Redis 字符串

## 对象结构
- redisObject
- SDS

## 编码
- int
- embstr
- raw

## 转换条件
- append
- setrange
- 长度超过阈值
```
````

Constraints:

- Use the fenced-code language `markmap`.
- Use exactly one `#` root.
- Prefer two to four hierarchy levels.
- Prefer three to seven major branches.
- Keep node text short; avoid paragraph-length nodes.
- Use headings and lists, not tables.
- Do not copy the entire note into the markmap.
- Place it near the beginning as a reading map, or near a section that needs a local hierarchy.
- Do not add `markmap` plugin settings to YAML frontmatter; the vault frontmatter remains exactly four fields.
- Use global plugin settings for appearance.

# Infographic Rules

## Status

`infographic` is experimental in v1.

Use at most one infographic in a normal note. It must materially improve explanatory reading over Mermaid, a table, or Markmap.

Only use template names verified in this skill until the allowlist is deliberately expanded.

## Allowed Templates

### Sequential explanation

Use `list-row-simple-horizontal-arrow` for a short ordered sequence:

````markdown
```infographic
infographic list-row-simple-horizontal-arrow
data
  items
    - label Step 1
      desc Start
    - label Step 2
      desc In Progress
    - label Step 3
      desc Complete
```
````

### Narrative bar comparison

Use `chart-bar-plain-text` for a small bar comparison with explanatory labels:

````markdown
```infographic
infographic chart-bar-plain-text
data
  title 延迟注入结果
  desc 展示不同网络延迟下的 p95 变化，单位为毫秒
  items
    - label 0ms
      value 1.2
      desc 基线
    - label 10ms
      value 11.4
      desc 基本随 RTT 线性增加
    - label 20ms
      value 21.8
      desc 趋势保持
```
````

## Infographic Constraints

- Use the fenced-code language `infographic`.
- This syntax is an indentation-sensitive DSL, not YAML.
- Preserve the `infographic <template>` line.
- Use two-space indentation consistently.
- Do not add colons after `data`, `items`, `label`, `desc`, or `value`.
- Do not invent template names.
- Keep ordered sequences to roughly three to seven items.
- Keep `label` concise and `desc` to one short explanatory sentence.
- Use numeric `value` for chart templates.
- Do not rely on icons, themes, palettes, or advanced options by default.
- Add a plain-text explanation before and after the block because this plugin is experimental.
- If the syntax or template cannot be verified, fall back to Mermaid, Charts, Markmap, or a Markdown table.

# Excalidraw Rules

Excalidraw is a manually curated visual asset, not a Markdown data-syntax default.

A note-writing skill may embed an Excalidraw drawing only when:

- the asset already exists;
- its exact vault path is verified;
- the drawing materially explains architecture, spatial relationships, annotations, or a complex mechanism.

Do not:

- invent an Excalidraw filename or path;
- output a fake Excalidraw code block;
- claim that a drawing was created when only Markdown was generated;
- require Excalidraw for the note to remain understandable.

When no asset exists, describe the recommended drawing in prose only if the user asked for a future manual visual.

# Disabled Visualization Forms In v1

Do not generate the following by default:

- Plotly code;
- ECharts code;
- Tracker query syntax;
- raw HTML dashboards;
- iframe embeds;
- remote JavaScript or CSS;
- Canvas JSON;
- hand-written SVG;
- custom plugin APIs not documented in this skill.

These may be added later after a real use case, verified syntax, mobile behavior, and export behavior have been tested.

# Example Rules

When the note teaches a library, package, framework, CLI, or API through examples:

1. Prefer complete minimal examples that can compile or run.
2. For Go examples, use a full `package main` program unless the user asks otherwise.
3. Comment library-specific lines, not obvious language syntax.
4. Keep workspace setup, file paste, dependency install, compile, and run steps separate when the reader must act between steps.
5. If local verification is possible, paste actual build/run output.
6. Do not replace executable examples with diagrams; visuals support the example rather than becoming the example.

# Output Contract

When this skill is used alone, return only a style decision packet:

```markdown
## Blue Espeon Style Decision

- Note type: companion / reusable topic / inline expansion
- Suggested location: `<path>`
- Naming rule: <rule>
- Required backlinks: <yes/no + where>
- Template: <default-note / existing local pattern / unknown>
- Visualization: <none / Mermaid / Charts / Dataview / Dataview+Charts / Markmap / Infographic / existing Excalidraw>
- Rendering dependency: <built-in / plugin names / none>
- Plain-text fallback: <how the note remains readable without rendering>
- Split required: <yes/no + reason>
- Uncertainty: <max 3 bullets>
```

When paired with another skill, do not output a separate long report unless the user asks.

The final note writer must silently apply the renderability checklist before returning the note.
