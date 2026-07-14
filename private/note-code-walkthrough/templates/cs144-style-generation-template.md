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

A walkthrough generated from this template should feel like a reader is gradually discovering the implementation, not reading an audit report or a repository inventory.

# 1. Default Reading Sequence

Use the following order when applicable:

```markdown
# <subject title>

> [!summary]
> <one-paragraph explanation of the problem, the component's responsibility, and its core strategy>

> [!note] 版本与归档范围
> <compact source version, implementation commit, verification boundary, and historical evidence>

## 实验要求 / 要解决的问题

## 先用白话理解 <subject>

## 一探 <subject>
### Mermaid 结构解析
### 代码声明一览与概要解释
### 函数调用输入、输出、返回案例

## 逐小节分析代码实现
### <constructor / state type / first responsibility block>
### <main entrypoint phase 1>
### <main entrypoint phase 2>
### <helper responsibility>
### <state query / cleanup / error path>

## 测试用例与实现契约

## 实际构建、运行与输出记录

## 结果

## 性能 / 设计边界

## Q&A
```

Sections may be renamed or omitted when genuinely inapplicable, but the cognitive order should remain stable.

# 2. Opening Requirements

## 2.1 Summary Callout

The opening summary must answer, in one compact paragraph:

- what problem exists before this component;
- what responsibility the component owns;
- what central strategy it uses;
- what it deliberately does not own when that boundary is important.

Do not begin with repository metadata, a file list, a large architecture diagram, or an exhaustive evidence table.

## 2.2 Version And Evidence Note

Keep version information in a compact callout near the opening.

Include only facts needed to interpret the source:

- repository and branch/tag/commit;
- implementation commit when different from current HEAD;
- files actually changed by the implementation;
- current versus historical build/test evidence;
- environment compatibility changes when they affect verification.

The evidence note supports the walkthrough. It must not become the walkthrough's main narrative.

# 3. Start From The Problem, Not The Architecture

The first normal section should explain the task or runtime problem in concrete terms.

Good opening questions include:

- What input can arrive?
- Why can it not be consumed immediately?
- What output does the caller expect?
- What state must persist between calls?
- What edge condition defines completion?

When a lab specification or feature request exists, translate it into observable responsibilities before reading implementation files.

Prefer a small decision diagram only when it makes the task materially easier to understand.

# 4. Build A Plain-Language Mental Model

Before declarations and internal APIs, explain the subject in ordinary language.

The explanation should introduce the smallest useful metaphor or invariant, for example:

- a reassembler is a hole filler;
- a syscall stub is a user-side doorway into the kernel;
- a cache entry is an owned snapshot with expiry;
- an event loop is a dispatcher over readiness events;
- a retry controller is a paced recovery probe.

The metaphor must then map directly to real state or source behavior. Do not leave it as decorative analogy.

A good section ends with the one or two state variables or invariants that make the metaphor precise.

# 5. Show The Concrete Object Before Deep Implementation

## 5.1 Structure Diagram

Use one small diagram when object ownership, data movement, or state composition is nontrivial.

Typical choices:

- `classDiagram` for object and member composition;
- `flowchart` for one input's responsibility phases;
- `sequenceDiagram` for interactions across owners;
- `stateDiagram-v2` for lifecycle transitions.

The prose before the diagram must say what to observe. The prose after it must state the conclusion.

Do not create a decorative repository-wide architecture view when a class, table, or code declaration is clearer.

## 5.2 Declaration Overview

Show a reading-sized version of the real declaration or exported surface.

Then add a compact table:

| Category | Interface or state | Meaning |
|---|---|---|
| input | ... | ... |
| progress | ... | ... |
| pending state | ... | ... |
| output | ... | ... |
| completion/error | ... | ... |

The table should translate names into behavioral roles. It should not merely repeat types.

# 6. Include One Complete State-Evolution Example Early

Before splitting the implementation into many sections, provide one concrete example that can be mentally executed from start to finish.

The example should use real API names and representative values:

```cpp
Component x{capacity};

x.accept(...);  // state before → state after
x.accept(...);  // pending state changes
x.accept(...);  // missing condition is satisfied
```

For each call, state the important observable or internal difference in a short comment or adjacent text.

A strong example covers several central behaviors at once, such as:

- out-of-order input followed by gap completion;
- configuration followed by `exec()` or child inheritance;
- allocation followed by a query and release;
- registration followed by dispatch and cleanup;
- write, timeout, retry, acknowledgment, and queue removal.

This example acts as the mainline that later implementation sections explain.

# 7. Walk Through Source By Responsibility Phase

Do not translate a long method line by line. Split it by semantic responsibility.

For every important method:

1. explain the method's overall job;
2. identify its responsibility phases;
3. show the real code snapshot for one phase;
4. explain input, state read, state written, and skipped work;
5. show a concrete boundary example when arithmetic or state transitions are non-obvious;
6. close with the invariant established by that phase.

Recommended method-section pattern:

```markdown
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
- Resulting invariant:

##### Concrete example

```text
state before: ...
input: ...
state after: ...
```
```

Use code before detailed prose when the prose is explaining that exact code.

# 8. Explain Arithmetic And Ranges Visually

For index, offset, capacity, window, sequence number, or memory-range logic, prefer small text diagrams with exact half-open or closed interval notation.

Example:

```text
[first_acceptable, first_unacceptable)
        |------------------------|
             accepted range
```

Then show how the input intersects or moves relative to that range.

Do not rely on abstract prose such as “trim the invalid part” when the exact boundary determines correctness.

# 9. State Changes Must Be Observable

Every major implementation section should answer:

```text
what state existed before
→ what event or input arrived
→ what branch executed
→ what state changed
→ what output became observable
```

For stateful components, explicitly distinguish:

- authoritative state;
- derived counters;
- pending queues or intervals;
- completion flags and terminal indices;
- owned dependencies;
- user-visible or caller-visible output.

When tests cannot inspect private state directly, explain the public observation path used instead.

# 10. Tests Are Implementation Contracts

The test chapter should come after the implementation model is understandable.

## 10.1 Begin With The Test Boundary

State the real build/test command and classify selected tests when the aggregate target includes multiple layers.

Keep this concise unless test registration is itself confusing.

## 10.2 Explain The Test Language

Introduce the minimum fixture, harness, action, and oracle vocabulary required to read the cases.

For each important helper, state what real method it calls or what state/output it observes.

## 10.3 Group Tests By Behavior

Group by the implementation contract being proven, not by filename order.

Examples:

- basic construction or single input;
- ordered progression;
- duplicate or stale input;
- gaps, overlap, or buffering;
- capacity/window limits;
- completion/EOF/cleanup;
- invalid address or error path;
- inheritance, concurrency, timeout, retry, reset;
- integration behavior.

## 10.4 Use Concrete Cases

For every important family, include at least one real case:

```markdown
### `<test or case>`：<behavior>

**Initial state**

**Injected input or event**

**Expected intermediate state**

**Oracle**

**Implementation contract**

**Failure usually points to**
```

Include negative assertions such as “no output yet,” “state remains unchanged,” or “EOF must not be visible yet.”

A useful test explanation should let the reader map a failing case back to a source responsibility phase.

# 11. Actual Build And Runtime Evidence Belongs Near The End

Record real commands and outputs after the conceptual and source walkthrough.

Recommended order:

```markdown
## 实际构建、运行与输出记录

### 原始构建 / 基线结果
### 环境兼容问题
### 最小兼容修改
### 聚焦测试
### 完整测试
```

For each command, explain:

- where it ran;
- whether the result is current or historical;
- what failed or passed;
- whether failure occurred before the target behavior was exercised;
- what the result proves and does not prove.

Do not lead the note with compiler logs or score tables.

# 12. Preserve Results, Performance, And Questions

## 12.1 Result

Close the main walkthrough with the implementation commit, PR, or final behavior summary.

## 12.2 Performance Or Alternative Implementations

Keep meaningful benchmark results or alternative designs when they illuminate a real tradeoff.

Explain why the alternative differs, such as:

- block operations versus per-byte work;
- indexed lookup versus scanning;
- cached derivation versus recomputation;
- central dispatch versus duplicated hooks.

Do not preserve unrelated performance folklore merely because it existed in the old note.

## 12.3 Q&A

Questions discovered during reading are valuable reusable material. Preserve or create a Q&A section when questions expose:

- misleading names;
- non-obvious early returns;
- why a state variable is necessary;
- why a simpler implementation fails;
- whether a branch is correctness or optimization;
- possible refactors;
- boundaries with adjacent concepts.

Each answer should first explain current behavior, then clearly label any suggested refactor or alternative.

# 13. Transform-Mode Preservation Rules

When rewriting an existing note:

- preserve the author's useful observations and questions;
- preserve real commands, outputs, scores, benchmarks, PRs, and commit links;
- preserve meaningful historical context but label it historical;
- replace source screenshots with real code blocks when source is available;
- replace hand-drawn structural diagrams with Mermaid or text diagrams only when readability improves;
- remove duplicate image embeds after their information is represented in text/code;
- move long raw files or secondary logs to appendices or foldable callouts;
- do not erase the original learning trail merely to make the note look uniform;
- do not let metadata migration notes or image-conversion notes dominate the opening.

The rewritten note should retain the original note's intellectual value while gaining a clearer teaching sequence.

# 14. Anti-Patterns

Do not produce any of the following as the default walkthrough:

## 14.1 Audit Report Opening

```text
version matrix
→ repository diff table
→ evidence taxonomy
→ source caveat list
→ only then explain the task
```

Evidence is necessary, but this order is poor for learning.

## 14.2 Architecture Before Motivation

Do not begin with a large cross-layer diagram before the reader understands the concrete problem.

## 14.3 Exhaustive File Inventory

Do not turn every touched file into an equal-level chapter. Group files by the behavior they jointly implement.

## 14.4 Line-By-Line Translation

Do not paraphrase every source line. Explain responsibility phases, branches, state effects, and invariants.

## 14.5 Abstract Example

Do not use placeholder pseudocode when real API calls, values, test inputs, and output are available.

## 14.6 Tests As A Score Only

A passing score does not explain behavior. Show representative setup, stimulus, oracle, and implementation contract.

## 14.7 Repetition Across Representations

Do not repeat the same fact in prose, code, table, Mermaid, and summary. Give each representation one job.

# 15. Required Quality Checklist

Before finishing, verify:

## Narrative

- [ ] The note starts with the problem and responsibility, not metadata.
- [ ] A plain-language model appears before deep implementation.
- [ ] One complete concrete state-evolution example appears early.
- [ ] The reader can follow the note without opening optional links.

## Source

- [ ] Real declarations and implementation snapshots are used.
- [ ] Large methods are split by responsibility phase.
- [ ] Every phase states state reads, writes, branch meaning, and invariant.
- [ ] Non-obvious ranges or arithmetic have concrete examples.

## Tests

- [ ] The exact test command or target is recorded.
- [ ] Tests are grouped by behavioral contract.
- [ ] Every important family has a concrete case and oracle.
- [ ] Negative assertions are included where relevant.
- [ ] Failures can be mapped back to likely implementation sections.

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
