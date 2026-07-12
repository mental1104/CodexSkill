---
name: note-code-walkthrough
description: Create or transform Obsidian source-code walkthrough notes that teach a concrete class, module, component, or tightly scoped mechanism from the reader's cognitive perspective: repository context, shared prerequisite infrastructure, application call chain, real public usage, construction and destruction, public/private implementation paths, member-state changes, complete scenarios, state machines, and behavioral tests. Use for repository-backed code reading, open-source walkthroughs, archived implementation notes, and existing code-note rewrites.
---

# Note Code Walkthrough

## Role

Create or transform a source-code walkthrough note that lets the user's future self understand one concrete implementation subject without rediscovering the repository from scratch.

The note must follow the reader's cognitive path, not source-file order and not implementation chronology.

Default reading direction:

```text
why this component matters
→ which repository infrastructure must already be understood
→ how the application reaches it
→ how its public surface is actually used
→ how the object is created and destroyed
→ how public behavior is implemented
→ how private responsibilities support it
→ how member state changes
→ how a complete lifecycle recombines the pieces
→ how tests prove the model
```

The main reader is the user's future self. Do not write a broad textbook chapter, a repository-wide tour, or a line-by-line source translation.

## Modes

### `repository-mode`

Use when the source of truth is a local checkout, GitHub repository, open-source repository, branch, tag, or commit.

Required actions:

1. resolve the repository root;
2. record branch, tag, commit, and working-tree status when available;
3. inspect the target implementation, declarations, callers, dependencies, tests, and build entrypoints;
4. inspect the thin application-to-target path and every non-obvious type on that path;
5. search existing notes before creating dependency or prerequisite notes;
6. use exact source paths and real code;
7. run focused build or tests when the environment permits and verification is in scope;
8. never invent source behavior, resolved links, or successful output.

### `transform-mode`

Use when an existing Markdown code note is being rewritten.

Preserve useful evidence, working examples, test records, images, and valid links, but reorganize the note into the cognitive order defined here. Re-audit dependencies instead of assuming the old note explained them adequately.

### `materialize-mode`

Use when current chat context, source snapshots, review notes, terminal output, or previous analysis is being archived into a new walkthrough.

Verify important claims against the repository whenever it is available. Chat summaries are not a substitute for current source evidence.

## Use When

Use this skill when the future reader wants to understand:

- where a class or component sits between the application and lower-level dependencies;
- what repository-specific wrappers, adapters, schedulers, containers, or runtime objects make that path work;
- how its public API is actually invoked;
- how constructors and destructors establish and close the lifecycle;
- why public and private methods are divided as they are;
- how methods read and modify member state;
- how large methods divide into responsibility blocks;
- how a complete runtime scenario crosses the component;
- how state-machine branches are covered;
- how tests construct scenarios and decide correctness.

Typical signals:

- “代码走读”;
- “源码走读笔记”;
- “把这个类 / 模块 / 组件梳理成笔记”;
- “从应用调用到内部实现讲清楚”;
- “分析 public / private 方法和成员状态”;
- “把这个开源仓库的实现归档”;
- “把测试用例也一起讲明白”;
- “把仓库里的 socket / adapter / runtime 前置讲清楚”;
- “重写这篇源码分析笔记”;
- “按人的认知顺序读代码”.

## Avoid

Use another skill when the primary future-reading intention is different:

- use `note-linear-achievement` to preserve an exploration, debugging, or implementation journey;
- use `note-conclusion-evidence` when the main value is a conclusion and its proof;
- use `note-operation-manual` when the reader only needs repeatable commands;
- use `source-walk` when the only requested output is a temporary source snapshot under `/tmp`;
- use a concept note when the subject is protocol or theory rather than one concrete implementation.

A walkthrough may contain history, conclusions, references, or commands, but those are supporting material. Its center thesis is the implementation model of one concrete code subject.

## Required Companion Skills

When writing into the Blue Espeon Obsidian vault:

- use `blue-espeon-note-style` for placement, naming, backlinks, wikilinks, diagram conventions, and single-thesis boundaries;
- use `obsidian-frontmatter-metadata` as a required final metadata check;
- use `latex-math-writing` when mathematical notation appears;
- use `source-walk` first only when a separate snapshot is useful or direct repository inspection is unavailable.

Do not create dead wikilinks silently. If a required note does not exist:

1. create it when the approved scope permits;
2. otherwise keep the minimum explanation inline and explicitly report the missing note.

## Evidence And Honesty Rules

Every important implementation claim must be grounded in current source evidence.

Record when available:

- repository;
- branch or tag;
- commit;
- relevant source files;
- relevant test files;
- build and test status.

Distinguish clearly between:

- **source fact**: what the current code does;
- **walkthrough interpretation**: the cognitive model derived from the code;
- **design suggestion**: a possible refactor or alternative;
- **external standard**: what an RFC, specification, or upstream reference requires;
- **historical evidence**: results from an older commit that have not been revalidated.

Never present a suggested refactor as current behavior. Never claim compilation or test success without actual evidence. Never replace a real usage example with pseudocode when repository-valid code is available.

# Note Ecosystem And Companion Note Types

A repository-backed walkthrough may produce or reuse several note kinds. They have different depth contracts.

## 1. Primary Walkthrough Note

The main note focuses on one class, module, component, or tightly coupled mechanism and performs the full outside-to-inside walkthrough.

Examples:

- `CS144 Lab4 TCP Connection`;
- `Redis ae Event Loop`;
- `Go net/http Transport Connection Pool`.

## 2. Dedicated Dependency Walkthrough

Use when an external dependency has substantial behavior, state, methods, or lifecycle and deserves its own complete walkthrough.

Examples:

- `TCPSegment structure and usage`;
- `TCPSender walkthrough`;
- `TCPReceiver walkthrough`.

This note may itself use the full rules in this skill.

## 3. Shared Repository Prerequisite Note

Use for repository-specific infrastructure that appears across multiple walkthroughs, is necessary for understanding ownership or data flow, but does not deserve a full walkthrough for every type.

Typical subjects:

- socket wrappers;
- adapter stacks;
- event-loop ownership;
- file-descriptor wrappers;
- framework containers;
- scheduler or callback glue;
- repository-specific test/runtime abstractions;
- template aliases or layered wrapper types whose names do not reveal their role.

Example:

```text
CS144 Socket、Adapter 与运行时调用链
├── TCPSpongeSocket
├── FdAdapter
├── TCPOverUDPSocketAdapter
├── LossyTCPOverUDPSocketAdapter
├── LossyTCPOverUDPSpongeSocket
├── UDPSocket
└── TunFD
```

Its center thesis is not “miscellaneous classes.” It must be a coherent shared mechanism such as:

> How this repository connects application I/O, the core protocol component, adapters, and the operating system.

## 4. Test Infrastructure Note

Use when fixtures, harnesses, custom actions, expectations, builders, or state factories must be understood before individual tests can be read comfortably.

Example:

- `CS144 TCPConnection 测试基建与夹具`.

## Companion Note Output Categories

Keep companion outputs classified:

```text
primary walkthrough
├── shared repository prerequisites
├── dedicated dependency walkthroughs
└── test infrastructure notes
```

Do not report all of them as an undifferentiated “伴随笔记” list.

# Scope Boundary

Prefer one primary subject per main note:

- one class;
- one module;
- one component;
- one tightly coupled mechanism.

Do not turn a class note into a complete repository tour.

External material must be handled through progressive depth:

1. give the minimum current-context explanation inline;
2. deep-link to an exact heading when optional detail exists elsewhere;
3. use a shared prerequisite note for reusable repository glue;
4. use a dedicated walkthrough when the dependency itself is complex;
5. return to the current mainline after establishing the boundary.

Good split:

```text
TCPConnection walkthrough
├── shared prerequisite: Socket、Adapter 与运行时调用链
│   ├── deep link: LossyTCPOverUDPSpongeSocket
│   └── deep link: UDPSocket
├── dependency walkthrough: TCPSegment
├── dependency walkthrough: TCPSender
├── dependency walkthrough: TCPReceiver
└── test infrastructure: TCPConnection Harness
```

Bad split:

```text
TCPConnection walkthrough
└── inline full explanations of UDP socket, EventLoop, adapters, TUN,
    TCPHeader, WrappingInt32, sender algorithms, receiver algorithms,
    and every test helper
```

Also bad:

```text
CS144 杂项
CS144 其他类
CS144 辅助知识
```

These names have no center thesis and become link graveyards.

# Investigation Workflow

Before writing, inspect enough source and existing notes to build a reliable cognitive model.

## 1. Resolve The Exact Source Version

Capture:

- repository root or GitHub repository;
- branch, tag, or commit;
- whether the worktree is dirty;
- the exact target symbol or module.

If an existing note names a source commit, compare it with the requested source before rewriting.

## 2. Find The Thin End-To-End Calling Slice

Locate only enough upper- and lower-layer code to answer:

- what the application or external caller does;
- which immediate owner, adapter, framework, scheduler, or container translates the event;
- which target public method is invoked;
- where target output goes;
- which object owns construction, polling, callbacks, and cleanup.

Do not expand all upper-layer internals in the main note.

## 3. Run A Dependency Readiness Audit

Inventory every non-obvious external type encountered in:

- the thin application-to-target slice;
- construction and ownership code;
- public signatures;
- important member state;
- real usage examples;
- complete lifecycle scenarios;
- test setup and integration code.

For every type, ask:

1. Can a first-time reader infer its role from the name alone?
2. Does the current paragraph explain why it exists?
3. Is its upstream caller or owner clear?
4. Is its downstream output or dependency clear?
5. Is it reused by multiple walkthrough notes?
6. Does it hide templates, inheritance, wrappers, adapters, callbacks, or layered ownership?
7. Would omitting it break understanding of the call chain even if the target's own methods are explained perfectly?

### Dependency Classification

| Type condition | Required treatment |
|---|---|
| Standard or obvious, one sentence is enough | explain inline only |
| Complex domain object with its own behavior/state | dedicated dependency walkthrough |
| Reused repository glue between application and core components | shared repository prerequisite note |
| Complex test-only support | test infrastructure note |
| Role cannot be verified | mark uncertainty; do not pretend it is understood |

### Shared Prerequisite Admission Rule

A type should normally enter a shared repository prerequisite note when at least two of these are true:

- it appears in two or more walkthrough notes;
- its name does not reveal its responsibility;
- it is built through templates, aliases, inheritance, or several wrappers;
- it sits on the critical application-to-target or target-to-OS path;
- ownership or data flow is unclear without it;
- repeating its explanation in each main note would create duplication;
- it has useful repository context but not enough depth for a full independent walkthrough.

A single strongly critical condition may be sufficient when the reader cannot understand the primary call chain without the type.

### Reuse Before Creation

Before creating a prerequisite note:

1. search the target directory and vault for an existing repository-level infrastructure note;
2. search aliases and likely old names;
3. inspect whether an existing note has a compatible center thesis;
4. append a missing section and backlink when appropriate;
5. create a new note only when no coherent reusable note exists.

Do not create per-primary-note duplicates such as:

```text
TCPConnection 前置知识
TCPReceiver 前置知识
TCPSender 前置知识
```

when one shared runtime-infrastructure note can serve all three.

## 4. Inspect The Target Surface

Collect:

- constructors, factories, registration hooks, and destructors;
- exported or public methods;
- private helpers;
- member variables or owned subcomponents;
- external types appearing in signatures or state;
- source-defined invariants and comments.

## 5. Build Read/Write And Call Maps

For every important method, determine:

- callers;
- direct callees;
- member state read;
- member state modified;
- external observable effects;
- early returns and skipped downstream work;
- invariants maintained.

## 6. Inspect Complete Runtime Scenarios

Find the normal lifecycle and meaningful mutually exclusive or exceptional branches.

For a stateful component, identify every meaningful state transition and its trigger.

## 7. Inspect Tests Before Writing The Test Chapter

Locate:

- test framework;
- fixtures;
- harnesses;
- custom actions and expectations;
- helper classes;
- scenario builders and state factories;
- test families;
- oracle mechanisms;
- build and test commands.

## 8. Inspect Existing Notes And References

Search for:

- shared repository prerequisite notes;
- dedicated dependency notes;
- source-specific companion notes;
- protocol or standard notes;
- test-infrastructure notes;
- authoritative external references.

Reuse valid notes and precise headings. Do not duplicate mature explanations inline.

# Core Cognitive Rules

## Rule 1: Start With A Short Goal

The opening goal should normally be one to three sentences. Answer only:

- what this subject is responsible for;
- why the reader would open this note.

Do not begin with broad history or a large conceptual introduction.

## Rule 2: Explain Repository Prerequisites Before They Become Obstacles

Before the first real usage example, identify only the non-obvious repository-specific types required to understand that example and the application call chain.

For each type, provide:

- one sentence explaining its current role;
- its position in the chain;
- an exact deep link to a shared prerequisite or dedicated dependency note when available.

The main note must remain understandable without opening the link. The link is for optional depth, not a replacement for local context.

Good:

```markdown
`LossyTCPOverUDPSpongeSocket` is the application-facing Sponge socket instantiated with a lossy UDP adapter stack. It still exposes socket-style connect/listen/read/write behavior; packet loss is injected below `TCPConnection`.

Details: [[CS144 Socket、Adapter 与运行时调用链#LossyTCPOverUDPSpongeSocket]]
```

Bad:

```markdown
See [[CS144 Socket、Adapter 与运行时调用链]].
```

Bad:

```markdown
LossyTCPOverUDPSpongeSocket starts the connection.
```

The second statement names the type but does not make it understandable.

## Rule 3: Explain The Application Connection Before Internal APIs

If the target is not directly called by application code, add a thin upper-layer slice before presenting its public API.

Explain:

```text
application action
→ repository-specific wrapper / owner
→ target public method
→ target output
→ adapter / lower layer / application-visible result
```

Only explain how the upper layer produces target inputs and consumes target outputs. Use precise links for infrastructure details.

## Rule 4: Use Real Public-API Examples Before The Declaration

Prefer several small, natural, repository-valid examples:

- construction or connection;
- input or write;
- receive or callback;
- read produced data;
- shutdown or lifecycle;
- state observation when useful.

A small example may cover two or three naturally related APIs. Do not force all public methods into one artificial example.

Examples must:

- use real types and plausible values;
- use real construction paths;
- show real outputs or observable state;
- compile or fit the repository's actual test/application environment when practical;
- avoid unmarked pseudocode placeholders.

When another complex type appears, explain its minimum interface surface, add a precise link, and continue the current scenario.

## Rule 5: Treat Construction And Destruction As Lifecycle Boundaries

Constructors, factories, initialization/registration methods, destructors, close methods, and cleanup hooks come before ordinary implementation details.

Explain:

```text
how the object is born
→ what owned objects are created
→ what initial invariants exist
→ what events it can accept
→ how it must leave
```

Cover:

- input configuration;
- owned subobjects;
- initial member state;
- post-construction invariants;
- clean versus unclean destruction;
- externally visible cleanup effects.

Use a decision diagram only when cleanup has meaningful branches or protocol effects.

## Rule 6: Explain Public Methods Twice

The first pass is a natural-language responsibility explanation after the declaration.

For every important public method, answer:

- who calls it;
- when it is called;
- what event it represents;
- what external result it can produce;
- how it affects the lifecycle.

Do not merely restate types.

The second pass is the later implementation walkthrough.

## Rule 7: Private Helpers Own Their Own Sections

A private helper does not belong to whichever public method is explained first.

In a public-method section:

- describe each helper in one or two sentences;
- state its role in the current path;
- deep-link to the helper's same-note section;
- do not inline its full implementation.

In the helper section:

- group by responsibility domain;
- explain implementation details;
- list every meaningful caller;
- provide links back to relevant public mainlines.

## Rule 8: Member Variables Are Explained Through Behavior

Do not write a long standalone essay for every member.

Provide a compact ledger containing:

- role;
- main readers;
- main writers;
- state kind: authoritative, derived, cache, queue, timer, flag, or owned component.

Then explain state evolution inside modifying methods.

## Rule 9: Large Methods Are Split By Responsibility

For methods of roughly tens of lines or more, identify coherent responsibility blocks.

A block should:

- solve one local purpose;
- have clear input conditions;
- use a small local-variable scope;
- produce a describable state or control result;
- establish conditions for the next block.

Blocks often happen to be 5-12 lines, but length is not the rule.

Explain local variables near first use and their lifetime. If source locality is poor, describe the factual layout and mark any refactor separately as a suggestion.

Do not translate every line. Explain responsibility, state transition, control guarantee, and skipped work after early returns.

## Rule 10: Complete Scenarios Follow Method-Level Understanding

After important public and private methods are explained, add:

- one realistic normal mainline;
- attached mutually exclusive or exceptional branches;
- a table mapping meaningful state transitions to scenarios;
- one final complete state-machine diagram when applicable.

Do not force active close, passive close, timeout, reset, success, and every error into one fake execution.

The mainline provides continuity. Branches provide completeness. The final state machine compresses the model.

## Rule 11: Tests Are Executable Behavioral Proof

Explain the language of the test suite before individual tests. Do not begin by pasting a random `TEST`, `TEST_F`, or custom Harness call.

## Rule 12: References Follow The Topic

Place one authoritative reference near the exact nontrivial topic it supports. Use the final reference section only for broader optional reading.

# Default Primary Note Architecture

Use this order unless a section is genuinely inapplicable. If omitted, state why.

```markdown
## 目标

## 阅读边界与导航

## 从应用到当前组件

## 理解本篇所需的外部类型

## Public API 的真实调用案例

## 类 / 模块声明

## 构造、初始化与析构

## Public API 职责说明

## 类内部责任划分

## 成员状态账本

## 实现走读
### 构造与析构实现
### Public 方法实现
### Private helper 实现

## 完整生命周期与状态分支

## 状态转换覆盖表

## 完整状态机

## 编译验证

## 测试基建与前置依赖

## 测试族与覆盖地图

## 重点测试用例走读

## 测试覆盖矩阵与失败定位

## 扩展阅读
```

`理解本篇所需的外部类型` must stay compact. It is not an excuse to repeat the shared prerequisite note.

For non-class subjects:

- “Public API” means exported functions, callbacks, handlers, commands, or protocol entrypoints;
- constructor/destructor may become initialization/registration/cleanup;
- member state may become module context, caches, tables, queues, or owned resources.

# Shared Repository Prerequisite Note

## Purpose

A shared prerequisite note is a repository-level context layer. It gives readers enough infrastructure knowledge to follow many primary walkthroughs without repeating the same explanation.

It is not:

- a full repository tour;
- a glossary of every type;
- a miscellaneous dump;
- a substitute for dedicated complex dependency walkthroughs.

## Naming And Center Thesis

Name by the shared mechanism, not by “other” or “miscellaneous.”

Good:

- `CS144 Socket、Adapter 与运行时调用链`;
- `Go net/http Transport 运行时组件`;
- `Redis 事件循环与文件事件基础设施`.

Bad:

- `CS144 其他类`;
- `CS144 杂记`;
- `辅助类说明`.

The title and opening must express one center thesis.

## Default Architecture

```markdown
## 目标

## 适用范围与引用方式

## 共享运行时总览

## 类型关系与包装层次

## `<type A>`

## `<type B>`

## `<type C>`

## 一个完整的跨层小场景

## 在其他走读笔记中的入口

## 需要独立走读的对象
```

## Per-Type Shallow Template

Use this template for each infrastructure type:

```markdown
## `<type>`

**一句话职责**

**位于哪里**

**谁创建或持有它**

**上游输入**

**下游输出**

**当前仓库如何使用**

**其他笔记需要记住什么**

**需要深挖时跳到哪里**
```

Optional additions when genuinely useful:

- one real declaration or construction expression;
- a tiny ownership diagram;
- a sequence fragment;
- one non-obvious lifecycle note.

Do not force a full Public/Private implementation walkthrough for every infrastructure type. If one type grows enough to require methods, state changes, lifecycle, and tests, split it into a dedicated dependency walkthrough and leave a summary plus link here.

## Wrapper And Alias Explanation

For layered aliases or templates, explicitly unfold the stack.

Example:

```text
LossyTCPOverUDPSpongeSocket
= TCPSpongeSocket<LossyTCPOverUDPSocketAdapter>
  └── LossyTCPOverUDPSocketAdapter
      └── TCPOverUDPSocketAdapter
          └── UDPSocket
```

Then explain the responsibility added by each layer. Do not merely restate inheritance or template syntax.

## Cross-Note Link Contract

A primary note should link to a precise heading:

```markdown
[[CS144 Socket、Adapter 与运行时调用链#LossyTCPOverUDPSpongeSocket]]
```

The exact heading must exist.

The primary note must also keep one local sentence explaining the type's current role. A reader who does not follow the link must still understand the current paragraph.

The prerequisite section should backlink to important primary notes when useful, but avoid exhaustive backlink lists that duplicate Obsidian's backlinks pane.

## Maintenance Contract

When a later walkthrough encounters another qualifying shared type:

1. update the existing prerequisite note;
2. add the missing section in the correct responsibility area;
3. add or repair precise deep links;
4. avoid creating a second overlapping prerequisite note;
5. split the note only when its center thesis has genuinely divided.

# Opening And Navigation Rules

## Goal

Keep the goal short.

## Coverage Boundary

State what the note covers and intentionally leaves to dependencies or prerequisites.

Example:

```text
本文重点：TCPConnection 的调用链、内部职责、状态变化和测试覆盖。
本文不展开：UDP socket 与 adapter 栈、TCPHeader 编解码、WrappingInt32 原理。
前置入口：[[CS144 Socket、Adapter 与运行时调用链#UDP 承载链]]。
```

## Intent-Based Navigation

For a long note, add a compact reading-intent index:

```markdown
- 想先理解仓库运行时前置：[[#理解本篇所需的外部类型]]
- 想先知道怎么用：[[#Public API 的真实调用案例]]
- 想看内部设计：[[#类内部责任划分]]
- 想查某个方法：[[#实现走读]]
- 想理解状态变化：[[#完整生命周期与状态分支]]
- 想排查测试：[[#测试覆盖矩阵与失败定位]]
```

Do not duplicate a full table of contents.

# Thin Application-To-Component Slice

This section is mandatory for a middle-layer or framework-owned target.

Answer:

1. what the application or external actor does;
2. what immediate owner translates it;
3. which target public method is invoked;
4. where target output goes;
5. which prerequisite types make this translation possible.

A compact table is often sufficient:

| External event | Immediate owner | Target API | Output consumer | Prerequisite context |
|---|---|---|---|---|
| application write | socket/event loop | `write()` | sender/output queue | exact deep link |
| network segment | adapter | `segment_received()` | receiver/ACK path | exact deep link |

Do not expand full owner or adapter implementation here.

# Real Usage Example Rules

## Multiple Small Examples First

Prefer scenario groups over one all-inclusive example. Each example answers one concrete question and has an observable result.

## Lifecycle APIs Versus Observation APIs

Main lifecycle APIs should later appear in the complete scenario. Accessors, diagnostics, metrics, and test-only methods may appear as observations and need not be forced into the mainline.

## Dependency Boundary In Examples

When an example uses another non-obvious type:

1. provide one local sentence explaining it;
2. show only fields/methods needed for the current call;
3. add an exact heading link when deeper material exists;
4. continue the scenario;
5. do not send the reader away before the current example makes sense.

# Declaration And Responsibility Explanation

## Show The Real Declaration

Present enough real declaration context to distinguish:

- construction and destruction;
- public/exported interface;
- private helpers;
- owned state;
- external types.

Mark omitted boilerplate.

## Public API Natural-Language Pass

For each important public method:

```markdown
### `method()`

- 调用者：...
- 调用时机：...
- 表示的事件：...
- 产生的外部结果：...
- 生命周期作用：...
```

Pure accessors may be grouped.

## Responsibility Map

Do not force shared helpers into a tree. Use a directed responsibility graph:

```text
external trigger
→ public entrypoints
→ internal responsibility domains
→ state sources / external dependencies
```

Recommended layers:

- application/network/timer/framework/test triggers;
- public methods;
- private responsibility domains;
- owned state and external components.

Use converging edges for shared helpers. Split spider-web diagrams. External dependencies should be visually distinguishable and accompanied by precise nearby links.

# Constructor And Destructor Walkthrough

## Constructor Template

```markdown
### 构造输入

### 创建的子对象

### 初始状态

| State | Initial value | Meaning |
|---|---|---|

### 构造后不变量

### 此时可以接受的事件
```

## Destructor Or Cleanup Template

```markdown
### 正常退出条件

### 未正常收尾时的处理

### 外部可观察效果

### 资源和状态最终结果
```

# Member State Ledger

Keep this section compact:

| Member | Role | Main readers | Main writers | State kind |
|---|---|---|---|---|

Do not fully explain state evolution here. Link to modifying methods.

# Public Method Implementation Template

For important public methods:

```markdown
## `<public method>`：<behavior label>

### 谁在什么时候调用

### 一个真实场景

### 调用前关键状态

### 主执行路径

### 读取与修改的状态

### 状态差分

### 外部可观察结果

### 调用的内部责任单元

- `<private helper>`：one- or two-sentence responsibility. [[#`<private helper>`]]

### 关键分支与早返回

### 维护的不变量
```

Simple entries may use a shorter form. Pure accessors normally belong in a table.

# Private Helper Implementation Template

Group helpers by responsibility domain, not declaration order or first caller.

```markdown
### `<private helper>`

**职责**

**调用者**
- [[#`public_a()`]]
- [[#`public_b()`]]

**读取状态**

**修改状态**

**实现与职责块**

**为什么独立存在**

**维护的不变量**

**返回主线**
- 返回 [[#`public_a()`]]
```

A reader who does not follow a helper link must understand the public mainline. A reader who follows it must have a return path.

# Large Method Walkthrough

Before explaining code, list responsibility blocks.

For each block, explain:

1. local purpose;
2. focused real code;
3. precondition;
4. local variables and lifetime;
5. state before and after;
6. what later blocks may assume;
7. what early return prevents.

This should allow mental execution without a debugger.

If a block has a reusable boundary and significant complexity, mark it as a possible helper extraction **suggestion**, not current source fact.

# State Change Presentation

Choose the smallest useful representation.

## Scalar, Boolean, Enum, Counter, Timer

Use a one-line transition or small table:

```text
_time_since_last_segment_received: 120 ms → 0 ms
```

## Sequence, Queue, Array, List

Use one to three snapshots demonstrating insertion, modification, or removal:

```text
initial: []
after connect(): [SYN]
after adapter pop(): []
```

## Map, Hash Table, Ledger

Use one to three keys:

```text
{}
→ {1000: SYN}
→ {1000: SYN, 1001: DATA("hello")}
→ {}
```

Do not enumerate unbounded containers.

## Owned Subobject State

Expose only the current method's relevant surface, such as bytes in flight, reassembled bytes, queue contents, current state, error, or EOF.

## Cross-Object Interaction

Use a sequence diagram when ownership and handoff matter.

## State Transition Logic

Use a state diagram when multiple events or conditions choose transitions.

## Responsibility Ordering

Use a flowchart when order cannot safely change.

# Diagram Admission Rule

A diagram is allowed only when it clarifies a nontrivial relationship that prose or a small table cannot show as clearly.

Prefer diagrams for:

- caller + callee + state effect;
- multiple conditions + transitions;
- public methods sharing helpers;
- runtime events crossing objects;
- layered wrapper/adapter ownership;
- lifecycle branches;
- test setup + stimulus + oracle.

Do not use diagrams for:

- flat lists;
- direct getters;
- one obvious assignment;
- `1 + 1 = 2` logic;
- decorative summaries already expressed elsewhere.

Additional rules:

- one diagram answers one question;
- keep 5-9 nodes by default;
- split large diagrams;
- keep orientation and terminology stable;
- keep application, target, adapter, and network positions consistent;
- explain what to observe before the diagram;
- state the conclusion after it;
- do not repeat the same fact in code, table, and diagram.

# Complete Lifecycle And State-Machine Coverage

## Normal Mainline

Build one realistic continuous scenario using real APIs and types.

For each important step show:

- trigger;
- public method;
- key private responsibility;
- input data/object;
- member-state difference;
- external output;
- logical state;
- links to method details.

## Attached Branches

Attach branches where behavior diverges:

- passive versus active close;
- success versus timeout;
- acknowledgment versus retransmission;
- valid input versus reset/error;
- ordered versus out-of-order data;
- open versus zero window.

## State Transition Coverage Table

| Transition | Trigger | Scenario location | Main method | Test coverage |
|---|---|---|---|---|

Every meaningful edge must appear or be explicitly out of scope.

## Final Complete State Machine

Place it after scenarios and branches. It compresses understanding; it must not be the first explanation of unfamiliar states.

# Reference Placement

## Local References

Insert authoritative references near the exact topic they support. Default to at most one primary reference per focused subsection.

Prefer:

1. current repository source or test;
2. official specification/RFC/language documentation;
3. upstream official source;
4. authoritative industrial implementation;
5. high-quality explanatory material.

State what it supports, the relevant section/symbol, and what to look for.

## Industry Comparison

When readers may ask whether production systems behave the same, add one authoritative comparison at that point and distinguish teaching from industrial implementation.

## End References

Use `扩展阅读` only for broader optional directions. Group by purpose and explain why each item is useful.

# Build Verification

Keep build coverage short:

- exact directory;
- exact command;
- actual result;
- what success proves;
- what it does not prove.

If unavailable, write `未验证` and the blocker.

# Test Chapter

## 1. Explain Test Infrastructure First

Identify:

- framework;
- fixtures;
- harnesses;
- scenario builders and state factories;
- custom actions/events;
- expectations/oracles;
- helpers;
- time simulation;
- input/output inspection;
- setup and teardown.

## 2. Split Nontrivial Test Infrastructure

Create or reuse a test-infrastructure note when:

- multiple files reuse a fixture/harness;
- two or more nontrivial custom helpers must be understood first;
- the harness hides a lifecycle/state machine;
- inline explanation would interrupt every test;
- the infrastructure deserves several sections.

Keep the minimum current interface inline, then deep-link. Do not split trivial helpers.

## 3. Group Tests By Behavioral Family

Do not default to file order. Possible families:

- construction/connection;
- data transfer;
- ordering/buffering;
- windows/flow control;
- close paths;
- timeout/retransmission;
- reset/error;
- integration/adapter behavior.

For each family explain overall behavior, state edges, methods/invariants, and case differences.

## 4. Explain Intent Before Code

```text
what the test proves
→ initial state
→ injected events
→ expected transitions
→ oracle
→ actual code
→ likely implementation fault
```

## 5. Test Oracle Rule

Every important test must state how correctness is observed:

- return value;
- thrown error;
- emitted message/segment;
- queue contents;
- fields;
- output bytes;
- state transition;
- timer;
- final hash/integration result;
- absence of unexpected work.

## 6. Test Case Template

```markdown
### `<test name>`：<intent>

**测试意图**

**初始状态**

**注入事件**

**状态变化**

**测试预言机**

**实际测试代码**

**覆盖的方法与不变量**

**失败通常意味着什么**
```

## 7. Explanation Depth

- **index**: one-line intent, stimulus, assertion;
- **standard**: initial state, events, state difference, oracle;
- **deep**: staged execution, diagrams, fixture expansion, snapshots, failure localization.

Do not give every test equal space.

## 8. Complex Tests Use Phases

```text
setup
→ establish state
→ inject stimulus
→ advance time/external events
→ assert intermediate state
→ inject recovery/branch
→ assert final state
```

Each phase should close with state changes and its assertion.

## 9. Coverage Matrix

| Behavior or invariant | Implementation method | Test family | Concrete test | Failure signal |
|---|---|---|---|---|

Reveal tested claims, covered state transitions, methods lacking direct coverage, and likely fault locations.

# Reader Experience Rules

## Support Sequential And Nonlinear Reading

The note must work from beginning to end and through direct heading links.

## Provide Return Paths

Deep helper, dependency, shared-prerequisite, and test-infrastructure sections should provide caller/context links back to the mainline when helpful.

## Link Does Not Replace Explanation

Every non-obvious external type must have a minimum local explanation before a link. No paragraph should become unintelligible when links are not opened.

## Prefer Precise Heading Links

Use the exact relevant heading, not only the note root:

```markdown
[[Repository Runtime Infrastructure#SpecificAdapter]]
```

Verify that the target heading exists. Avoid aliases inside Markdown table cells when they could break parsing.

## Add Cognitive Checkpoints

After long phases:

```markdown
> [!summary] 读到这里应当明确
> - ...
> - ...
```

Useful after public usage, responsibility mapping, method implementation, lifecycle, and tests.

## Preserve Stable Vocabulary

Choose one set of directional terms and keep it throughout, for example local/peer, application/network, inbound/outbound, sender/receiver, source/final queue.

## Keep Code Context Just Large Enough

Include containing method, relevant condition, local variables, and transition to the next block. Avoid isolated unexplained calls and huge files.

## Use One Primary Representation Per Fact

- code proves implementation;
- prose explains intent/reason;
- table shows comparison/state difference;
- flowchart shows ordered responsibility;
- sequence diagram shows object interaction;
- state diagram shows transitions.

Avoid repeating one fact in every form.

## Use Progressive Disclosure

Keep raw logs, full declarations, repetitive tests, and secondary evidence in foldable callouts or appendices when they interrupt the mainline.

## Make Omission Explicit

If a method, branch, dependency, prerequisite type, transition, build target, or test family is omitted, state why and where the reader should go instead.

# Mandatory Validation Checklist

Before finishing, verify all applicable items.

## Source Grounding

- [ ] Repository, branch/tag, and commit are recorded when available.
- [ ] Source and test paths are correct.
- [ ] Important claims are grounded in current source.
- [ ] Build/test outputs are real or explicitly unverified/historical.
- [ ] Current behavior is separated from suggestions and standards.

## Dependency Readiness

- [ ] Every non-obvious type in the application slice, examples, signatures, ownership, lifecycle, and tests was audited.
- [ ] Every such type has a minimum local explanation.
- [ ] Each type was classified as inline, dedicated walkthrough, shared prerequisite, test infrastructure, or unresolved.
- [ ] Existing repository-level prerequisite notes were searched before creating new ones.
- [ ] Shared infrastructure is not duplicated across per-component prerequisite notes.
- [ ] Shared prerequisite notes have a coherent center thesis and non-miscellaneous name.
- [ ] Wrapper/template/alias stacks are unfolded when names hide composition.
- [ ] Exact deep-link headings exist.
- [ ] Links supplement rather than replace local context.

## Cognitive Order

- [ ] Goal is short.
- [ ] Coverage boundary is explicit.
- [ ] A middle-layer target has a thin application-to-component slice.
- [ ] Required external-type context appears before it blocks the reader.
- [ ] Real public usage appears before internal implementation.
- [ ] Examples use real types and values.
- [ ] Multiple small examples replace an artificial all-API example.

## Declaration And Lifecycle

- [ ] Real declaration/exported surface is shown.
- [ ] Construction and destruction/cleanup precede ordinary internals.
- [ ] Every important public API has caller, timing, event, result, and lifecycle role.
- [ ] Private responsibilities are grouped by domain.
- [ ] Shared helpers are not falsely owned by one public method.

## Method Detail

- [ ] Public mainlines explain helper roles without duplicating internals.
- [ ] Important private helpers have dedicated sections and caller backlinks.
- [ ] Important methods show read set, write set, state difference, observable result, and invariants.
- [ ] Large methods are divided into cohesive responsibility blocks.
- [ ] Early returns state skipped later work.
- [ ] Member state is explained through modifying methods.
- [ ] Containers use only enough snapshots to explain rules.

## Diagrams And Links

- [ ] Every diagram answers a nontrivial question.
- [ ] No obvious assignment or flat list receives a decorative diagram.
- [ ] Orientation and terminology are stable.
- [ ] Same-note deep links have return paths.
- [ ] External links resolve or missing notes are reported.
- [ ] Primary notes link to precise prerequisite/dependency headings.
- [ ] Code, prose, tables, and diagrams do not redundantly repeat facts.

## Lifecycle Completeness

- [ ] One realistic normal lifecycle is complete.
- [ ] Mutually exclusive and exceptional behavior is attached as branches.
- [ ] Every meaningful transition appears in the coverage table or is out of scope.
- [ ] A final complete state machine exists when applicable.

## References

- [ ] Topic-specific authoritative references appear near relevant sections.
- [ ] Local sections do not contain link dumps.
- [ ] Teaching implementation, specification, and industrial comparison are distinguished.
- [ ] Broader optional references are grouped at the end.

## Build And Tests

- [ ] Build verification is short and factual.
- [ ] Test infrastructure precedes individual tests.
- [ ] Nontrivial test infrastructure is split or linked appropriately.
- [ ] Tests are grouped by behavioral family.
- [ ] Important tests explain intent before code.
- [ ] Every important test names its oracle.
- [ ] Complex tests are divided into phases with state changes.
- [ ] A coverage/failure-localization matrix closes the test chapter.

## Reader Experience

- [ ] Long notes have intent-based navigation.
- [ ] Long phases have concise cognitive checkpoints.
- [ ] Vocabulary and visual orientation remain stable.
- [ ] Secondary evidence uses progressive disclosure.
- [ ] Omitted material is explicitly marked.
- [ ] The mainline remains understandable without opening optional links.

# Frontmatter Metadata Check Rule

Before finishing any generated or transformed Obsidian note, use `obsidian-frontmatter-metadata` as a required check.

Preserve valid top-level metadata, especially:

- `summary`;
- `aliases`;
- `tags`;
- repository, branch, commit, source files, and test status when present.

Do not accidentally nest metadata under YAML list items.

# Output Policy

After creating or editing notes, respond with:

```markdown
## 完成情况

- 类型：代码走读型
- 模式：repository-mode / transform-mode / materialize-mode
- 主笔记：`<path>`
- 共享前置笔记：
  - `<path>#<heading>` / 新建 / 更新 / 复用 / 无
- 独立依赖走读：
  - `<path>` / 新建 / 更新 / 复用 / 无
- 测试基建笔记：
  - `<path>` / 新建 / 更新 / 复用 / 无
- 源码版本：`<repo>@<branch-or-tag>:<commit>`
- 验证：
  - 编译：通过 / 失败 / 未运行
  - 测试：通过 / 部分通过 / 失败 / 未运行
- 主要覆盖：
  - 应用到组件调用链
  - 仓库级前置与外部类型
  - Public API 与构造/析构
  - Public/Private 实现和状态变化
  - 完整生命周期与状态机
  - 测试基建、用例和覆盖矩阵
- 未覆盖或不确定点：
  - ...
```

Do not paste the whole note into chat unless the user asks.
