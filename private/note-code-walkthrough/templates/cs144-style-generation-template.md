# CS144-Style Code Walkthrough Generation Template

## Purpose

This template captures the strongest reusable qualities of the CS144 Lab walkthrough notes. It is the default content architecture for `note-code-walkthrough` unless the subject clearly requires a different order.

The goal is not to imitate CS144 terminology. The goal is to preserve its teaching rhythm:

```text
problem first
→ plain-language model
→ concrete object and state
→ one complete example
→ source implementation by responsibility phase
→ tests as behavioral contracts
→ actual verification
→ questions and conclusions
```

A generated walkthrough should feel like the reader is gradually discovering the implementation, not reading an audit report or repository inventory.

# 1. Default Reading Sequence

Use this order when applicable:

```markdown
# <subject title>

> [!summary]
> <problem, responsibility, central strategy, and boundary>

> [!note] 版本与归档范围
> <source version, implementation commit, verification boundary, historical evidence>

## 实验要求 / 要解决的问题

## 先用白话理解 <subject>

## 一探 <subject>
### Mermaid 结构解析
### 代码声明一览与概要解释
### 函数调用输入、输出、返回案例

## 逐小节分析代码实现
### <state / declaration / constructor>
### <main entrypoint responsibility phases>
### <helper / query / cleanup / error path>

## 测试用例与实现契约

## 实际构建、运行与输出记录

## 结果

## 性能 / 设计边界

## Q&A
```

Sections may be renamed or omitted when genuinely inapplicable, but the cognitive order should remain stable.

# 2. Opening Requirements

## 2.1 Summary Callout

The opening summary must answer in one compact paragraph:

- what problem exists before this component;
- what responsibility the component owns;
- what central strategy it uses;
- what it deliberately does not own when that boundary matters.

Do not begin with repository metadata, a file list, a large architecture diagram, or an exhaustive evidence table.

## 2.2 Version And Evidence Note

Keep version information in a compact callout near the opening.

Include only facts needed to interpret the source:

- repository and branch/tag/commit;
- implementation commit when different from current HEAD;
- files actually changed by the implementation;
- current versus historical build/test evidence;
- environment compatibility changes when they affect verification.

The evidence note supports the walkthrough. It must not become the main narrative.

# 3. Start From The Problem, Not The Architecture

The first normal section should explain the task or runtime problem in concrete terms.

Answer questions such as:

- What input or event can arrive?
- Why can it not be handled trivially?
- What output or effect does the caller expect?
- What state must persist between calls?
- What condition defines completion, failure, or cleanup?

When a lab specification or feature request exists, translate it into observable responsibilities before reading implementation files.

Use a small decision diagram only when it materially improves understanding.

# 4. Build A Plain-Language Mental Model

Before declarations and internal APIs, explain the subject in ordinary language.

Use the smallest useful metaphor or invariant, for example:

- a reassembler is a hole filler;
- a syscall stub is a user-side doorway into the kernel;
- a cache entry is an owned snapshot with expiry;
- an event loop is a dispatcher over readiness events;
- a retry controller is a paced recovery probe.

The metaphor must map directly to real state or source behavior. End the section with the state variables or invariants that make the metaphor precise.

# 5. Show The Concrete Object Before Deep Implementation

## 5.1 Structure Diagram

Use one small diagram when ownership, data movement, or state composition is nontrivial.

Typical choices:

- `classDiagram` for object and member composition;
- `flowchart` for one input's responsibility phases;
- `sequenceDiagram` for interactions across owners;
- `stateDiagram-v2` for lifecycle transitions.

The prose before the diagram must say what to observe. The prose after it must state the conclusion.

Do not create a decorative repository-wide architecture view when a declaration or small table is clearer.

## 5.2 Declaration Overview

Show a reading-sized version of the real declaration or exported surface.

Then add a compact behavioral-role table:

| Category | Interface or state | Meaning |
|---|---|---|
| input | ... | ... |
| progress | ... | ... |
| pending state | ... | ... |
| output | ... | ... |
| completion/error | ... | ... |

Translate names into behavior. Do not merely repeat types.

# 6. Include One Complete State-Evolution Example Early

Before splitting the implementation into many sections, provide one concrete example that can be mentally executed from start to finish.

Use real API names and representative values:

```cpp
Component x{capacity};

x.accept(...);  // state before → state after
x.accept(...);  // pending state changes
x.accept(...);  // missing condition is satisfied
```

For each call, state the important observable or internal difference.

A strong example covers several central behaviors at once, such as:

- out-of-order input followed by gap completion;
- configuration followed by `exec()` or child inheritance;
- allocation followed by a query and release;
- registration followed by dispatch and cleanup;
- write, timeout, retry, acknowledgment, and queue removal.

This example becomes the mainline that later implementation sections explain.

# 7. Walk Through Source By Responsibility Phase

Do not translate a long method line by line. Split it by semantic responsibility.

For every important method:

1. explain the method's overall job;
2. identify its responsibility phases;
3. show the real code snapshot for one phase;
4. explain input, state read, state written, and skipped work;
5. show a concrete boundary example when arithmetic or transitions are non-obvious;
6. close with the invariant established by that phase.

Use this section pattern:

````markdown
#### `<method>`：<one-sentence responsibility>

`<method>` can be read in N phases: ...

##### Phase 1: <purpose>

```<language>
<real source snapshot>
```

- Input and precondition:
- State read:
- State written:
- Early return or branch meaning:
- Skipped later work:
- Resulting invariant:

##### Concrete example

```text
state before: ...
input: ...
state after: ...
observable result: ...
```
````

Use code before detailed prose when the prose explains that exact code.

# 8. Explain Arithmetic And Ranges Visually

For index, offset, capacity, window, sequence number, or memory-range logic, use exact interval notation and small text diagrams.

Example:

```text
[first_acceptable, first_unacceptable)
        |------------------------|
             accepted range
```

Then show how the input intersects or moves relative to that range.

Do not say only “trim the invalid part” when the exact boundary determines correctness.

# 9. State Changes Must Be Observable

Every major section should answer:

```text
state before
→ event/input
→ selected branch
→ state written
→ observable output
```

For stateful components, distinguish:

- authoritative state;
- derived counters;
- pending queues or intervals;
- completion flags and terminal indexes;
- owned dependencies;
- caller-visible output.

When tests cannot inspect private state directly, explain the public observation path.

# 10. Tests Are Implementation Contracts

The test chapter comes after the implementation model is understandable.

## 10.1 Establish The Real Test Boundary

State the actual build/test command and classify selected tests when an aggregate target includes multiple layers.

Distinguish target-owned direct tests, integration tests, inherited regressions, optional/strict tests, built-but-unselected tests, and disabled tests when relevant.

## 10.2 Explain The Test Language

Introduce the minimum fixture, harness, action, expectation, time-control, and output-inspection vocabulary needed to read the cases.

For each helper, state what real method it calls or what output it observes.

## 10.3 Group Tests By Behavior

Group by the implementation contract, not filename order.

Possible families:

- construction or single input;
- ordered progression;
- duplicate or stale input;
- gaps, overlap, buffering, or windows;
- completion, EOF, or cleanup;
- invalid input or error path;
- inheritance, concurrency, timeout, retry, or reset;
- integration behavior.

## 10.4 Use Concrete Cases

For every important family, include at least one real case:

```markdown
### `<test or case>`：<behavior>

**Initial state**

**Injected input or event**

**Expected intermediate state**

**Oracle**

**Negative oracle**

**Implementation contract**

**Failure usually points to**
```

Include assertions such as “no output yet,” “state remains unchanged,” or “EOF must not be visible yet.”

A useful test explanation maps a failing case back to a source responsibility phase.

# 11. Put Build And Runtime Evidence Near The End

Recommended order:

```markdown
## 实际构建、运行与输出记录

### 原始构建 / 基线结果
### 环境兼容问题
### 最小兼容修改
### 聚焦测试
### 完整测试
```

For each command, state:

- where it ran;
- whether the result is current or historical;
- what passed or failed;
- whether failure occurred before target behavior was exercised;
- what the result proves and does not prove.

Do not lead the note with compiler logs or score tables.

# 12. Preserve Results, Alternatives, And Questions

## 12.1 Result

Close the main walkthrough with the implementation commit, PR, score, or final behavior summary.

## 12.2 Performance Or Alternative Implementations

Keep benchmark results or alternative designs when they expose a real tradeoff, such as:

- block operations versus per-byte work;
- indexed lookup versus scanning;
- cached derivation versus recomputation;
- central dispatch versus duplicated hooks.

Do not preserve unrelated performance folklore merely because it existed in the old note.

## 12.3 Q&A

Preserve or create Q&A when questions expose:

- misleading names;
- non-obvious early returns;
- why a state variable is necessary;
- why a simpler implementation fails;
- correctness versus optimization;
- possible refactors;
- boundaries with adjacent concepts.

Explain current behavior first. Label refactors and alternatives as suggestions.

# 13. Transform-Mode Preservation Rules

When rewriting an existing note:

- preserve useful observations and questions;
- preserve real commands, outputs, scores, benchmarks, PRs, and commit links;
- preserve meaningful historical context but label it historical;
- replace source screenshots with code blocks when source is available;
- replace hand-drawn relationships with Mermaid or text diagrams only when readability improves;
- remove duplicate image embeds after conversion;
- move long raw files and secondary logs to appendices or foldable callouts;
- do not erase the original learning trail merely to make the note uniform;
- do not let metadata migration or image-conversion notes dominate the opening.

The rewritten note should retain the original intellectual value while gaining a clearer teaching sequence.

# 14. Anti-Patterns

## Audit-Report Opening

Do not use this order:

```text
version matrix
→ repository diff table
→ evidence taxonomy
→ caveat list
→ only then explain the task
```

## Architecture Before Motivation

Do not begin with a large cross-layer diagram before the reader understands the concrete problem.

## Exhaustive File Inventory

Do not turn every touched file into an equal-level chapter. Group files by the behavior they jointly implement.

## Line-By-Line Translation

Explain responsibility phases, branches, state effects, and invariants instead.

## Abstract Examples

Do not use placeholder pseudocode when real API calls, values, test inputs, and outputs are available.

## Tests As A Score Only

A passing score does not explain behavior. Show setup, stimulus, oracle, and implementation contract.

## Repetition Across Representations

Do not repeat the same fact in prose, code, table, Mermaid, and summary. Give each representation one job.

# 15. Required Quality Checklist

## Narrative

- [ ] The note starts with the problem and responsibility, not metadata.
- [ ] A plain-language model appears before deep implementation.
- [ ] One complete concrete state-evolution example appears early.
- [ ] The mainline works without opening optional links.

## Source

- [ ] Real declarations and implementation snapshots are used.
- [ ] Large methods are split by responsibility phase.
- [ ] Every phase states state reads, writes, branch meaning, skipped work, and invariant.
- [ ] Non-obvious ranges or arithmetic have concrete examples.

## Tests

- [ ] The exact test command or target is recorded.
- [ ] Tests are grouped by behavioral contract.
- [ ] Every important family has a concrete case and oracle.
- [ ] Negative assertions are included where relevant.
- [ ] Failures map back to likely implementation sections.

## Evidence

- [ ] Current source facts and historical verification are separated.
- [ ] Build/test success is never invented.
- [ ] Environment compatibility failures are distinguished from implementation failures.

## Reader Experience

- [ ] Diagrams answer specific nontrivial questions.
- [ ] Code appears close to the explanation it supports.
- [ ] Long logs and secondary evidence do not interrupt the mainline.
- [ ] Useful original questions and evidence survive transform-mode.
- [ ] The final result feels like a guided source-reading session, not an audit report.
