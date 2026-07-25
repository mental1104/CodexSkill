# Code Walkthrough Generation Template

## Purpose

Render a completed walkthrough IR into a reader-centered Obsidian note.

The template preserves the strongest teaching rhythm of the CS144 Reassembler note while allowing the chapter topology to change by archetype.

The default rhythm is:

```text
problem
→ plain-language model
→ concrete structure
→ golden trace
→ responsibility-oriented source
→ hotspot boundaries and counterexamples
→ tests as contracts
→ actual verification
→ results, tradeoffs, and questions
```

Do not use this template to replace investigation, evidence normalization, hotspot ranking, or quality review.

## Default Opening

```markdown
## AI摘要

## 正文

# <Title>

> [!summary]
> <problem, responsibility, central strategy, and boundary>

> [!note] 版本与证据范围
> <repository, revision, input type, verification level, current versus historical evidence>

## 要解决的问题
```

The first normal section must explain:

- what arrives or happens;
- why trivial handling is insufficient;
- what the caller expects;
- what state or invariant must persist;
- what defines completion, failure, or cleanup.

Do not begin with a repository map, version matrix, build log, or exhaustive file list.

## Plain-Language Model

```markdown
## 先用白话理解 <subject>
```

Use the smallest useful model.

The model must end by mapping the metaphor to real source elements:

- fields;
- queues;
- ranges;
- ownership;
- lifecycle;
- protocol states;
- loop invariants.

A metaphor without source mapping is insufficient.

## Concrete Structure

```markdown
## 一探 <subject>

### 真实入口与责任边界
### 声明、状态或数据结构
### Golden Trace：<scenario>
```

Show only what is necessary for the current subject.

Use:

- one small ownership or data-flow diagram when nontrivial;
- a reading-sized real declaration;
- a compact role table;
- the complete golden trace.

The golden trace must appear before detailed implementation.

## Archetype-Specific Mainline

### Stateful Component

```markdown
## 状态、窗口与不变量
## 逐阶段分析核心入口
## 终止、EOF、清理或错误状态
```

### Pure Algorithm Or Data Structure

```markdown
## 输入模型与核心不变量
## 一次完整迭代推演
## 核心操作与正确性
## 复杂度与表示取舍
```

### Cross-Layer Call Chain

```markdown
## 从外部动作到目标入口
## 边界转换、所有权与校验
## 核心处理与返回路径
```

### Concurrent Or Asynchronous Mechanism

```markdown
## 执行实体与调度关系
## 一条完整时间线
## 同步、共享状态与顺序保证
## 取消、超时、关闭与失败传播
```

### PR Or Feature Change

```markdown
## 原行为与需求缺口
## 新行为与契约变化
## 按责任解释实现差异
## 兼容性与回归边界
```

### Failure-Driven Execution Path

```markdown
## 可观察症状与触发输入
## 实际执行路径
## 偏离不变量的位置
## 根因、修复边界与回归保护
```

## Responsibility Phase Pattern

Use for every important method or execution stage:

````markdown
#### `<symbol>`：<one-sentence responsibility>

<overall phase breakdown and the Golden Trace step explained here>

##### Phase N: <purpose>

```<language>
<focused real source>
```

- Input and precondition:
- State read:
- Decision or branch:
- State written:
- Side effect:
- Skipped later work:
- Resulting invariant:
- Public observation:
````

Do not mechanically fill every bullet when a phase is simple. Preserve the semantic questions, not visual ceremony.

## Hotspot Expansion Pattern

For L3+ hotspots:

```markdown
##### 精确边界

<range diagram, timeline, state table, or ownership map>

##### 代表案例

<case partition covering materially different branches>

##### 为什么不能更简单

<small counterexample>

##### 测试如何证明

<oracle, negative oracle, and fault mapping>
```

Use exact intervals and one-past-end notation for arithmetic.

Do not say only “裁剪无效部分”“处理边界”“更新状态”.

## Test Chapter

```markdown
## 测试用例与实现契约

### 测试选择边界
### Fixture / Harness 最小词汇
### <behavior family>
### 源码责任与失败定位
```

For each representative case:

```markdown
### `<test/case>`：<intent>

**Initial state**

**Stimulus**

**Expected intermediate transition**

**Oracle**

**Negative oracle**

**Implementation contract**

**Failure usually points to**
```

Tests should be grouped by behavior.

Do not stop at “all tests passed”.

## Verification Chapter

```markdown
## 实际构建、运行与输出记录

### 基线或原始构建
### 环境兼容问题
### 聚焦验证
### 完整验证
```

For every command state:

- where it ran;
- revision;
- whether it is current or historical;
- result;
- whether target behavior was exercised;
- what the result proves;
- what it does not prove.

Keep long logs collapsed or summarized.

## Closing

```markdown
## 结果

## 性能、设计取舍与边界

## Q&A
```

Use Q&A for:

- misleading names;
- non-obvious early returns;
- why state exists;
- why a simpler approach fails;
- correctness versus optimization;
- boundaries with adjacent concepts;
- clearly labeled refactor suggestions.

Explain current behavior before suggestions.

## Representation Discipline

- Code proves what exists.
- Prose explains why and consequence.
- Tables compare.
- Flowcharts order responsibilities.
- Sequence diagrams show cross-owner interaction.
- State diagrams show lifecycle.
- Text diagrams show precise ranges.
- Call trees show one concrete trace.

Do not repeat the same fact in four forms.

## Transform-Mode Preservation

Preserve:

- author observations;
- real examples;
- questions and confusion;
- commands and outputs;
- scores and benchmarks;
- PR and commit links;
- useful images and diagrams;
- environment history.

Reorganize them around the chosen archetype and golden trace.

Do not let metadata migration, image conversion, or source-audit commentary dominate the opening.

## Reader Experience

The final note must:

- support sequential reading and direct heading links;
- remain understandable without optional links;
- use stable vocabulary and orientation;
- state omissions;
- keep evidence close to the claim it supports;
- place secondary details behind progressive disclosure;
- make the hardest part easier than reading the source unaided.
