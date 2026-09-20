---
name: note-code-walkthrough
description: Create or transform evidence-grounded Obsidian walkthroughs for a concrete implementation subject. Normalize repository, PR, file, snippet, log, note, or chat input into a source model; choose the correct reading archetype; identify cognitive hotspots; build one golden execution trace; connect source state to behavioral tests; and pass a scored quality gate before delivery.
---

# Note Code Walkthrough

## Role

Create a durable source-code walkthrough that lets the user's future self answer:

> 这个具体实现为什么存在，从真实入口到内部状态、边界和测试到底怎样运行？

The result must be a guided source-reading document, not:

- a repository audit;
- a file inventory;
- a line-by-line translation;
- a generic architecture overview;
- a test-name list;
- an implementation plan presented as current behavior.

The skill must be able to accept incomplete or irregular inputs without inventing missing evidence. “Handle any input” means:

```text
normalize the input
→ determine the evidence ceiling
→ reconstruct the implementation model
→ choose the right reading archetype
→ explain the difficult parts deeply
→ generate the strongest honest document allowed by the evidence
```

## Mandatory Companion Files

Read and apply these files before writing the note:

1. `input-adapters/input-normalization.md`
2. `analysis/walkthrough-ir.md`
3. `archetypes/reading-archetypes.md`
4. `analysis/hotspot-depth.md`
5. `analysis/golden-trace-test-map.md`
6. `templates/cs144-style-generation-template.md`
7. `rubrics/quality-gate.md`
8. `golden-cases/regression-suite.md`

These files have distinct responsibilities:

| File | Responsibility |
|---|---|
| input normalization | decide what can and cannot be claimed from the supplied input |
| walkthrough IR | hold the complete implementation model before prose generation |
| reading archetypes | choose the cognitive topology of the note |
| hotspot depth | decide where explanation effort must concentrate |
| golden trace and test map | close the loop from input to state to observable behavior |
| generation template | render the model into a readable Obsidian note |
| quality gate | reject formally complete but cognitively weak drafts |
| regression suite | verify that the skill generalizes beyond one CS144-style class |

Do not duplicate their full contents in the generated note.

## Modes

### `repository-mode`

Use when a local checkout, repository evidence packet, branch, tag, commit, or remote repository is the primary source of truth.

For local source, inspect the checkout directly. When evidence exists only on GitHub, request the smallest required remote read through `github-operations` and consume the returned evidence. This skill must not invoke GitHub tools or perform remote mutations directly. If the gateway is unavailable, continue from local or user-provided evidence and mark the remote evidence as unavailable rather than bypassing the gateway.

Required behavior:

- resolve the exact revision;
- inspect the target declaration and implementation;
- find real callers, owners, dependencies, outputs, build registration, tests, and fixtures;
- run focused verification when the environment permits and verification is in scope;
- distinguish current source from historical results.

### `transform-mode`

Use when an existing Markdown code note is being rewritten.

Required behavior:

- preserve useful observations, questions, diagrams, commands, outputs, scores, links, and historical context;
- re-audit current source and tests instead of trusting the old note;
- reorganize by cognition rather than original chronology;
- remove duplicated screenshots only after their information is preserved;
- label historical evidence instead of silently upgrading it to current verification.

### `materialize-mode`

Use when the source is chat context, a source snapshot, terminal output, review notes, logs, screenshots, or scattered analysis.

Required behavior:

- normalize the available evidence before drafting;
- verify important claims against the repository whenever possible;
- when repository access is unavailable, state the evidence ceiling and mark unresolved claims;
- never manufacture callers, lifecycle, test coverage, build success, or production behavior.

## Scope Boundary

Prefer one primary implementation subject:

- one class;
- one module;
- one component;
- one algorithm implementation;
- one cross-layer mechanism;
- one tightly coupled feature slice;
- one PR-sized behavior change.

Do not expand into a whole repository tour merely because dependencies exist.

Use progressive depth:

1. explain the minimum dependency role inline;
2. deep-link to an exact existing heading when optional detail exists;
3. reuse a shared prerequisite for recurring repository glue;
4. create or update a dedicated dependency walkthrough only when it has an independent stateful behavior;
5. return to the main subject immediately.

## Evidence And Honesty

Every important implementation and test claim must be classifiable as one of:

- **source fact**: directly visible in inspected source;
- **test fact**: directly visible in a concrete test or fixture;
- **build-selection fact**: derived from actual build or test registration;
- **runtime fact**: observed from an executed command;
- **walkthrough interpretation**: a mental model derived from evidence;
- **historical evidence**: previously recorded but not revalidated;
- **external requirement**: specification or authoritative document;
- **design suggestion**: a possible refactor or alternative.

Never present an interpretation, external requirement, or suggestion as current source behavior.

A filename, README list, screenshot, suite name, score, or passing aggregate target is not enough to claim behavioral coverage.

## Mandatory Execution Pipeline

### 1. Normalize The Input

Apply `input-adapters/input-normalization.md`.

Produce an internal input contract containing:

```yaml
input_kind:
evidence_level:
repository:
revision:
target:
available_sources:
missing_sources:
allowed_claims:
forbidden_claims:
verification_ceiling:
```

Do not draft before this contract is coherent.

### 2. Resolve The Subject And Future Reading Question

State internally:

- the one implementation subject;
- the concrete problem it owns;
- the user-visible or caller-visible result;
- deliberate exclusions;
- the future question the note must answer.

If the supplied scope contains several independent subjects, keep the one necessary for the central behavior and split only when another subject has an independent future-reading intention.

### 3. Reconstruct The Thin End-To-End Slice

Locate only enough code to establish:

```text
external action or test stimulus
→ immediate owner, wrapper, or generated boundary
→ target entrypoint
→ important state and helpers
→ side effect or output consumer
→ public observation path
```

Do not front-load every dependency.

### 4. Build The Walkthrough IR

Complete `analysis/walkthrough-ir.md` before prose generation.

The IR must contain, when applicable:

- target thesis and scope;
- entrypoints and callers;
- authoritative, derived, pending, terminal, and external state;
- ownership and lifecycle;
- branches, early returns, error paths, cleanup, and skipped work;
- invariants;
- concurrency and ordering;
- exact ranges or arithmetic;
- golden trace;
- cognitive hotspots;
- test responsibility map;
- evidence and uncertainties.

If an IR field cannot be verified, mark it unknown instead of guessing.

### 5. Choose One Reading Archetype

Apply `archetypes/reading-archetypes.md`.

Choose the primary archetype:

- stateful component;
- pure algorithm or data structure;
- cross-layer call chain;
- concurrent or asynchronous mechanism;
- PR or feature change;
- failure-driven execution path.

A note may borrow one supporting section from another archetype, but it must keep one primary cognitive topology.

### 6. Detect Cognitive Hotspots And Allocate Depth

Apply `analysis/hotspot-depth.md`.

Do not explain every symbol equally. Increase depth for code that contains:

- coupled state changes;
- non-obvious branches or early returns;
- range, offset, capacity, sequence, or memory arithmetic;
- hidden invariants;
- ordering, ownership, lifecycle, or concurrency constraints;
- derived counters synchronized with another structure;
- names that obscure behavior;
- failure paths with large consequences;
- tests concentrated around one responsibility phase;
- user questions or previous confusion.

Every level-3 or level-4 hotspot needs a concrete boundary case and a counterexample showing why a simpler reading or implementation fails.

### 7. Select One Golden Trace

Apply `analysis/golden-trace-test-map.md`.

Choose one representative scenario that crosses several central responsibilities.

The trace must use real names and values where available:

```text
state before
→ input or event
→ selected branch
→ state written
→ helper or dependency interaction
→ next event
→ final observable output
→ representative test oracle
```

This trace is the note's spine. Later implementation and test sections must reconnect to it rather than becoming isolated explanations.

### 8. Establish The Test Responsibility Boundary

Inspect the actual path:

```text
source test file
→ built executable or artifact
→ registered test name
→ aggregate target or runner
→ exact selection rule
```

Classify tests as:

- target-owned direct;
- integration or end-to-end;
- inherited regression;
- optional, strict, or extra;
- built but unselected;
- disabled or skipped.

Read real bodies and fixtures for every target-owned behavioral family. Do not attribute all aggregate-target tests to the current subject.

### 9. Generate The Note

Use `templates/cs144-style-generation-template.md`.

The generated note must:

- begin with the problem and responsibility;
- explain a plain-language model before internals;
- show the concrete object or execution slice;
- present the golden trace early;
- walk through source by responsibility phase;
- deepen only at detected hotspots;
- connect tests to behavior, oracle, and likely fault location;
- put build logs and verification near the end;
- preserve meaningful questions and alternatives without letting them replace current behavior.

### 10. Run The Quality Gate

Apply `rubrics/quality-gate.md`.

A checklist is insufficient. Score the draft, identify the three weakest dimensions, and repair them.

The note is not complete when:

- a fatal defect exists;
- the score is below the threshold;
- the golden trace is disconnected from implementation or tests;
- the hardest code received only shallow explanation;
- source and historical evidence are mixed;
- the mainline depends on opening optional links.

### 11. Run Regression Reasoning

Use `golden-cases/regression-suite.md` as a mental regression suite.

Confirm that the design choices in the current note would still make sense for at least one contrasting archetype. This prevents accidental overfitting to CS144-style stateful classes.

### 12. Apply Vault Metadata And Delivery Rules

When writing into the Blue Espeon vault:

- use `blue-espeon-note-style`;
- run `obsidian-frontmatter-metadata`;
- use `latex-math-writing` when mathematical notation appears;
- do not create dead wikilinks;
- prefer repository-relative paths; when a stable remote permalink is useful, consume one returned by `github-operations` instead of constructing or fetching it directly;
- preserve the minimum explanation inline even when a deeper note exists.

## Representation Rules

Use one primary representation per fact:

| Representation | Best use |
|---|---|
| code | prove the actual implementation |
| prose | explain responsibility, reason, and consequence |
| table | compare roles, states, or coverage |
| flowchart | ordered responsibility phases |
| sequence diagram | cross-owner interaction |
| state diagram | lifecycle or protocol transitions |
| text range diagram | exact boundaries and arithmetic |
| call tree | one concrete execution trace |

A diagram must answer a nontrivial question. Decorative repository-wide diagrams are forbidden.

Code must appear close to the prose that interprets it.

## Transform Preservation

When rewriting an existing note:

- preserve the author's learning questions and useful misunderstandings;
- preserve real commands, outputs, scores, benchmarks, PRs, commits, and images when they carry unique evidence;
- keep historical failures when they explain a current boundary;
- move long raw logs and secondary evidence into appendices or foldable callouts;
- remove duplicated screenshots only after the equivalent code, diagram, or explanation is present;
- do not erase the original intellectual value merely to enforce uniform formatting.

## Verification Levels

Use one of these labels:

| Level | Meaning |
|---|---|
| static | source and test code inspected, nothing executed |
| focused | target build or focused tests executed |
| full | relevant aggregate suite executed |
| historical | result preserved from an older run |
| unavailable | verification could not be performed |

State what each result proves and does not prove.

An environment failure that occurs before target behavior is exercised is not an implementation failure.

## Output Policy

After creating or editing a note, respond with:

```markdown
## 完成情况

- 类型：代码走读型
- 模式：repository-mode / transform-mode / materialize-mode
- 主笔记：`<path>`
- 输入类型与证据等级：`<kind>` / `<level>`
- 走读原型：<archetype>
- Golden Trace：<one-line scenario>
- 认知热点：<top hotspots>
- 源码版本：`<repo>@<revision>`
- 验证等级：static / focused / full / historical / unavailable
- 质量门禁：<score>/100，fatal defects=0
- 主要覆盖：
  - 问题、责任与白话模型
  - 具体对象或端到端调用切片
  - Golden Trace 与状态演化
  - 分责任阶段源码走读
  - 热点边界、反例与不变量
  - 测试契约、oracle 与故障映射
- 未覆盖或不确定点：
  - ...
```

Do not paste the complete note into chat unless the user asks.
