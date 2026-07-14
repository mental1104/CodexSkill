---
name: note-code-walkthrough
description: Create or transform Obsidian source-code walkthrough notes for a concrete class, module, component, lab, or tightly scoped mechanism. Ground the note in a real repository version, teach the implementation through a problem-first and example-driven sequence, explain source by responsibility phase and state change, and use repository tests as behavioral contracts. Use for repository-backed code reading, open-source walkthroughs, implementation archives, and existing code-note rewrites.
---

# Note Code Walkthrough

## Role

Create or transform a source-code walkthrough note that lets the user's future self understand one concrete implementation subject without rediscovering the repository from scratch.

The note must read like a guided source-reading session:

```text
problem and responsibility
→ plain-language mental model
→ concrete object and state
→ one complete example
→ source implementation by responsibility phase
→ tests as behavioral contracts
→ actual verification
→ results, boundaries, and questions
```

Do not default to a repository audit report, a broad architecture tour, implementation chronology, or line-by-line source translation.

# Mandatory Generation Template

Before generating or transforming a walkthrough, read and apply:

```text
templates/cs144-style-generation-template.md
```

That file is the default content architecture and quality standard for this skill.

Its core requirements are mandatory unless genuinely inapplicable:

- start from the concrete problem or task, not metadata;
- give a compact version/evidence callout without letting it dominate;
- explain the subject in plain language before declarations and internals;
- show one complete state-evolution or input/output example early;
- walk through large methods by responsibility phase;
- keep real code close to the prose that explains it;
- explain state before, input, branch, state after, and observable output;
- treat tests as implementation contracts with setup, stimulus, oracle, and fault mapping;
- put build logs, scores, and historical verification near the end;
- preserve useful questions as Q&A in transform-mode;
- make the final note feel like the strongest CS144 Lab walkthroughs, without hard-coding CS144-specific terminology.

Do not silently revert to the older architecture-first sequence of:

```text
version matrix
→ repository topology
→ dependency inventory
→ large architecture diagram
→ implementation audit
→ task explanation
```

Evidence and architecture remain required where relevant, but they support the teaching sequence instead of replacing it.

# Modes

## `repository-mode`

Use when the source of truth is a local checkout, GitHub repository, branch, tag, or commit.

Required actions:

1. resolve the exact repository version;
2. inspect the target declarations and implementation;
3. find real callers, owners, dependencies, and outputs;
4. inspect build and test registration rather than guessing from filenames;
5. read actual target-owned test bodies and important fixtures;
6. run focused build/tests when the environment permits and verification is in scope;
7. never invent source behavior, test membership, output, or successful verification.

## `transform-mode`

Use when an existing Markdown code note is being rewritten.

Preserve useful original material:

- author observations;
- concrete examples;
- questions and confusing points;
- real commands and outputs;
- scores and benchmark records;
- PR and commit links;
- meaningful images and diagrams;
- historical environment issues.

Reorganize the material into the mandatory generation template. Re-audit current source and tests instead of assuming the old note is correct.

When source screenshots are available as real code, prefer code blocks. When a hand-drawn relationship is clearer as Mermaid or a text range diagram, replace it and remove the duplicate image reference.

Do not erase the original learning value merely to make the note visually uniform.

## `materialize-mode`

Use when chat context, source snapshots, review notes, terminal output, or previous analysis is being archived into a new walkthrough.

Verify important claims against the repository whenever available. If repository access is unavailable, label source behavior and test results as historical or unverified.

# Use When

Use this skill when the future reader needs to understand:

- what problem a class, module, component, lab, or mechanism solves;
- how an application or external caller reaches it;
- how its public/exported surface is used;
- how state changes across calls;
- how large methods divide into responsibility phases;
- why helpers and member fields exist;
- how a complete runtime scenario recombines the pieces;
- which tests belong to its responsibility boundary;
- how concrete tests prove behavior;
- where a failing case likely maps back into the implementation.

Typical signals:

- “代码走读”;
- “源码走读笔记”;
- “把这个类 / 模块 / Lab 梳理成笔记”;
- “从真实调用到内部实现讲清楚”;
- “把测试用例一起讲明白”;
- “重写这篇源码分析笔记”;
- “按人的认知顺序读代码”.

# Avoid

Use another skill when the primary reading intention is different:

- `note-linear-achievement`: preserve an exploration, debugging, or implementation journey;
- `note-conclusion-evidence`: preserve a conclusion and its proof;
- `note-operation-manual`: provide repeatable commands and procedures;
- `source-walk`: create only a temporary source snapshot;
- a concept-note skill: explain protocol or theory without centering one implementation.

A walkthrough may contain history, theory, commands, and conclusions, but its center is the implementation model of one concrete subject.

# Required Companion Skills

When writing into the Blue Espeon Obsidian vault:

- use `blue-espeon-note-style` for placement, naming, links, diagrams, and single-thesis boundaries;
- use `obsidian-frontmatter-metadata` as the required final metadata check;
- use `latex-math-writing` when mathematical notation appears;
- use `source-walk` only when a separate source snapshot is useful or direct inspection is unavailable.

Do not create dead wikilinks silently. Keep the minimum explanation inline even when a deeper note exists.

# Evidence And Honesty Rules

Every important implementation and test claim must be grounded in source evidence.

Record when available:

- repository;
- branch, tag, or commit;
- working-tree status;
- implementation commit when different from current HEAD;
- relevant source and test files;
- build entrypoints;
- exact test command or target;
- test selection rule;
- current and historical build/test status.

Distinguish clearly between:

- **source fact**: what the inspected code does;
- **test fact**: what a concrete test sets up, stimulates, and asserts;
- **build-selection fact**: which tests a command actually selects;
- **walkthrough interpretation**: the mental model derived from source;
- **design suggestion**: a possible refactor or alternative;
- **external standard**: what a specification requires;
- **historical evidence**: older results not revalidated against current source.

Never present a suggested refactor as current behavior. Never claim build or test success without actual evidence.

A filename, suite name, README list, screenshot, or score alone is not enough to claim behavioral coverage.

# Scope Boundary

Prefer one primary subject per main note:

- one class;
- one module;
- one component;
- one lab task group;
- one tightly coupled mechanism.

Do not turn a component walkthrough into a complete repository tour.

Use progressive depth for dependencies:

1. explain the minimum role inline;
2. deep-link to an exact heading when optional detail exists;
3. reuse or create a shared repository prerequisite for recurring glue;
4. use a dedicated dependency walkthrough when the dependency has substantial behavior and state;
5. return to the current mainline.

For tests:

- explain target-owned tests deeply;
- classify inherited regression tests without falsely attributing them to the target;
- explain representative integration tests at the relevant boundary;
- do not absorb every aggregate-target test into the main note.

# Investigation Workflow

## 1. Resolve The Exact Source Version

Capture:

- repository root or GitHub repository;
- branch, tag, or commit;
- dirty/clean status when available;
- exact target symbol, module, or lab;
- implementation commit and later compatibility commits when distinct.

When an existing note names an older revision, separate historical evidence from the newly inspected source.

## 2. Translate The Task Into Observable Responsibilities

Before reading implementation order, answer:

- What input or event arrives?
- Why can it not be handled trivially?
- What output or effect is expected?
- What state must persist between calls?
- What condition defines completion, failure, or cleanup?

This becomes the opening “实验要求 / 要解决的问题” section.

## 3. Find The Thin End-To-End Calling Slice

Locate only enough code to answer:

```text
external action
→ immediate owner / wrapper / generated stub
→ target entrypoint
→ important internal state or helper
→ output consumer / user-visible result
```

Do not expand every upper- or lower-layer implementation in the main note.

## 4. Audit Non-Obvious Types And Infrastructure

Inspect non-obvious types encountered in:

- the thin calling slice;
- declarations and signatures;
- ownership and lifecycle;
- important member state;
- real examples;
- test setup and oracle paths.

Classify each as:

| Condition | Treatment |
|---|---|
| obvious or standard | one-sentence inline explanation |
| complex domain object | dedicated dependency walkthrough |
| recurring repository glue | shared prerequisite note |
| complex test-only support | test infrastructure note |
| role cannot be verified | mark uncertainty |

Do not front-load all of this as a giant dependency inventory. Introduce each prerequisite before it becomes an obstacle.

## 5. Inspect The Target Surface

Collect:

- constructors, factories, registration hooks, and cleanup;
- public/exported methods or commands;
- private helpers;
- member variables or module state;
- source-defined invariants;
- error and early-return paths.

## 6. Build Read/Write And State Maps

For each important method or responsibility phase, determine:

- caller;
- input and precondition;
- direct callees;
- state read;
- state written;
- observable effect;
- early returns and skipped work;
- invariant established.

## 7. Find One Complete Concrete Example

Select a real API/test scenario that demonstrates the central mechanism through several calls or phases.

The example should have representative values and visible state evolution. It will appear before the detailed implementation walkthrough and serve as the note's mainline.

## 8. Establish The Test Responsibility Boundary

Inspect real build and test registration:

```text
source test file
→ built executable or artifact
→ registered test name
→ aggregate target / runner selection
→ exact command, regex, label, or dependency
```

Classify selected tests:

| Classification | Meaning |
|---|---|
| target-owned direct | directly drives the target and asserts its behavior |
| integration/end-to-end | crosses owners or runtime boundaries |
| inherited regression | verifies dependencies or earlier stages |
| optional/strict/extra | outside the default required target |
| built but unselected | compiled but absent from the requested command |
| disabled/skipped | present but inactive |

Read actual test bodies and important fixtures for every target-owned behavioral family.

## 9. Inspect Existing Notes And References

Search for:

- prerequisite notes;
- dependency walkthroughs;
- test-infrastructure notes;
- protocol/concept notes;
- authoritative external references.

Reuse exact headings. Links supplement local explanation; they do not replace it.

# Generation Contract

The detailed standard is in `templates/cs144-style-generation-template.md`. The following rules summarize what must appear in the generated note.

## 1. Opening

Begin with:

1. title;
2. one summary callout explaining problem, responsibility, strategy, and boundary;
3. one compact version/evidence callout;
4. the concrete task or runtime problem.

Do not begin with a large evidence table, repository map, audit findings, or build log.

## 2. Plain-Language Model

Explain the subject in ordinary language before deep source details.

The model must map to real state or invariants. A metaphor without a source mapping is insufficient.

## 3. Concrete Structure

Show only the structure needed to understand the current subject:

- one small ownership/data-flow/state diagram when useful;
- a reading-sized real declaration or exported surface;
- a compact role table for important interfaces and state.

## 4. Complete Example Before Deep Implementation

Provide one real, mentally executable example using actual API names and representative values.

Show:

```text
state before
→ call/input
→ pending or intermediate state
→ next call/event
→ state after
→ observable output
```

## 5. Implementation By Responsibility Phase

For each important method, use this pattern:

````markdown
#### `<method>`：<responsibility>

<overall phase breakdown>

##### Phase N: <purpose>

```<language>
<real source snapshot>
```

- input/precondition;
- state read;
- state written;
- branch/early-return meaning;
- skipped later work;
- resulting invariant;
- concrete boundary example when needed.
````

Do not paraphrase every line. Keep code snippets large enough to include the relevant condition, variables, and transition, but not entire unrelated files.

## 6. Ranges, Windows, And Arithmetic

Use exact interval notation and small text diagrams for:

- offsets;
- indexes;
- capacity windows;
- sequence-number ranges;
- memory ranges;
- cursor boundaries;
- one-past-end completion indexes.

Explain the exact before/after boundary. Do not use vague phrases such as “trim invalid data” when arithmetic determines correctness.

## 7. Tests As Contracts

The test chapter should contain:

```text
exact build/test selection
→ minimum fixture/harness vocabulary
→ behavior-based test families
→ representative concrete cases
→ oracle and negative assertions
→ implementation contract
→ likely fault location
```

For each important case:

```markdown
### `<test/case>`：<intent>

**Initial state**
**Injected event**
**Intermediate transition**
**Oracle**
**Negative oracle**
**Implementation contract**
**Failure usually points to**
```

Do not stop at “all tests passed” or a score.

## 8. Verification Near The End

Record actual commands, outputs, compatibility failures, focused tests, and full test results after the implementation and test model.

State what each result proves and does not prove. Keep current and historical results separate.

## 9. Results, Alternatives, And Q&A

Preserve meaningful:

- implementation commit and PR;
- final score or behavior;
- benchmarks;
- alternative implementations and tradeoffs;
- questions that expose non-obvious behavior;
- suggested refactors, clearly labeled as suggestions.

# Default Primary Note Architecture

Use this order unless a section is genuinely inapplicable:

```markdown
## AI摘要

## 正文

# <Title>

> [!summary]
> ...

> [!note] 版本与归档范围
> ...

## 实验要求 / 要解决的问题

## 先用白话理解 <subject>

## 一探 <subject>
### Mermaid 结构解析
### 代码声明一览与概要解释
### 函数调用输入、输出、返回案例

## 逐小节分析代码实现
### <state/declaration/constructor>
### <main method responsibility phases>
### <helpers/error/cleanup>

## 测试用例与实现契约

## 实际构建、运行与输出记录

## 结果

## 性能 / 设计边界

## Q&A
```

Adapt labels for non-class subjects:

- Public API may mean commands, handlers, callbacks, generated stubs, or protocol entrypoints;
- member state may mean module tables, queues, process fields, caches, or resources;
- construction/destruction may mean registration/startup and cleanup/shutdown;
- “实验要求” may become feature requirements or runtime problem.

# Transform-Mode Preservation Rules

When rewriting an existing note:

- preserve useful original observations and explanations;
- preserve real code, commands, outputs, scores, benchmarks, PRs, and links;
- preserve meaningful historical context but label it historical;
- preserve questions and convert them into Q&A when useful;
- preserve source images only when they add information unavailable in code/text;
- remove duplicate image references after conversion;
- move long raw files and secondary logs into appendices or foldable callouts;
- keep the original note's intellectual value while improving the teaching order.

Do not place metadata migration notes, image-conversion notes, or source-audit caveats at the center of the opening.

# Diagram Rules

Use a diagram only when it answers a nontrivial question better than code, prose, or a small table.

Good uses:

- object composition;
- cross-owner interaction;
- responsibility phases;
- state transitions;
- index/window movement;
- test setup, stimulus, and oracle.

Rules:

- one diagram answers one question;
- keep terminology and orientation stable;
- normally use 5–9 nodes;
- explain what to observe before it;
- state the conclusion after it;
- do not repeat the same fact in code, prose, table, and Mermaid;
- prefer text range diagrams for precise arithmetic;
- do not use decorative repository-wide architecture diagrams.

# Reader Experience Rules

- The note must support sequential reading and direct heading links.
- The mainline must remain understandable without opening optional links.
- Use stable vocabulary for directions, state, and lifecycle.
- Add concise cognitive checkpoints after long phases when useful.
- Keep raw logs and secondary evidence out of the main conceptual path.
- State omissions and scope boundaries explicitly.
- Use one primary representation per fact:
  - code proves behavior;
  - prose explains intent and reason;
  - tables compare roles, states, or coverage;
  - flowcharts show ordered responsibility;
  - sequence diagrams show interactions;
  - state diagrams show transitions;
  - text diagrams show precise ranges.

# Mandatory Validation Checklist

## Source Grounding

- [ ] Repository, revision, and target are recorded.
- [ ] Important source and test paths are correct.
- [ ] Current behavior is separated from history, standards, and suggestions.
- [ ] Build/test output is real or explicitly unverified.

## Narrative Quality

- [ ] The note starts with the problem, not metadata.
- [ ] A plain-language mental model appears before deep implementation.
- [ ] One complete concrete example appears early.
- [ ] The note follows the CS144-style generation template unless a section is inapplicable.
- [ ] The result reads like guided source reading, not an audit report.

## Source Explanation

- [ ] Real declarations and implementation snapshots are shown.
- [ ] Large methods are split by responsibility phase.
- [ ] Important phases state input, state read/write, branches, skipped work, and invariant.
- [ ] Non-obvious ranges and arithmetic use concrete examples.
- [ ] State changes and observable effects are explicit.

## Dependencies And Links

- [ ] Non-obvious types have a minimum inline explanation.
- [ ] Existing prerequisite/dependency notes were searched.
- [ ] Exact deep-link headings exist.
- [ ] Links supplement rather than replace local explanation.

## Tests

- [ ] Exact test command/target and selection rules were inspected.
- [ ] Target-owned, integration, regression, optional, unselected, and disabled tests are distinguished when relevant.
- [ ] Tests are grouped by behavior rather than filename order.
- [ ] Every important family has a concrete source-backed case.
- [ ] Oracles and negative assertions are explicit.
- [ ] Failures are mapped to likely implementation responsibility phases.

## Transform Preservation

- [ ] Useful original observations, questions, commands, outputs, and evidence survive.
- [ ] Replaced screenshots no longer remain as duplicate embeds.
- [ ] Historical evidence is labeled rather than silently upgraded to current verification.
- [ ] Metadata or image migration commentary does not dominate the note.

## Reader Experience

- [ ] Every diagram has a clear cognitive purpose.
- [ ] Code appears near the explanation it supports.
- [ ] Secondary evidence uses progressive disclosure.
- [ ] Vocabulary and visual orientation are stable.
- [ ] The mainline is understandable without optional links.

# Frontmatter Metadata Check Rule

Before finishing any generated or transformed Obsidian note, run the `obsidian-frontmatter-metadata` check.

When the Blue Espeon vault's current convention requires exactly four top-level keys, use:

```yaml
source: ...
tags:
  - ...
summary: ...
read_status: unread
```

Preserve additional metadata semantically in the body only when the active vault convention requires removing it from frontmatter.

# Output Policy

After creating or editing notes, respond with:

```markdown
## 完成情况

- 类型：代码走读型
- 模式：repository-mode / transform-mode / materialize-mode
- 主笔记：`<path>`
- 生成模板：CS144-style / adapted with reason
- 共享前置笔记：`<path>#<heading>` / 新建 / 更新 / 复用 / 无
- 独立依赖走读：`<path>` / 新建 / 更新 / 复用 / 无
- 测试基建笔记：`<path>` / 新建 / 更新 / 复用 / 无
- 源码版本：`<repo>@<branch-or-tag>:<commit>`
- 验证：
  - 编译：通过 / 失败 / 未运行
  - 测试：通过 / 部分通过 / 失败 / 未运行
- 主要覆盖：
  - 问题与白话模型
  - 具体对象、状态与完整调用案例
  - 分责任阶段源码走读
  - 测试契约与具体用例
  - 实际构建、运行和结果边界
  - Q&A / 性能 / 设计边界
- 未覆盖或不确定点：
  - ...
```

Do not paste the whole note into chat unless the user asks.
