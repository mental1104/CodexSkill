---
name: note-code-walkthrough
description: Create or transform Obsidian source-code walkthrough notes that teach a class, module, or component from the reader's cognitive perspective: application context, real public usage, class design, constructor/destructor lifecycle, public and private implementation paths, state changes, complete scenarios, and test coverage. Use for repository-backed code reading, open-source walkthroughs, archived implementation notes, and existing code-note rewrites.
---

# Note Code Walkthrough

## Role

Create or transform a source-code walkthrough note that lets the user's future self understand a concrete class, module, component, or tightly scoped mechanism without having to rediscover the repository from scratch.

The note must follow the reader's cognitive path, not the source file's physical order and not the chronological order in which the code was written.

Default reading direction:

```text
why this component is relevant
→ how the application reaches it
→ how its public surface is actually used
→ how the object is created and destroyed
→ how public behavior is implemented
→ how private responsibilities support that behavior
→ how state changes across a complete lifecycle
→ how tests prove the model
```

The main reader is the user's future self. Do not write a public tutorial, broad textbook chapter, or line-by-line translation of source code.

## Modes

### `repository-mode`

Use when the source of truth is a local checkout, GitHub repository, open-source repository, branch, tag, or commit.

Required actions:

1. resolve the repository root;
2. record branch, commit, and working-tree status when available;
3. inspect the target implementation, declarations, callers, dependencies, tests, and build entrypoints;
4. use exact source paths and real code;
5. run focused build or tests when the environment permits and the task includes verification;
6. never invent missing source behavior or successful output.

### `transform-mode`

Use when an existing Markdown code note is being rewritten.

Preserve useful source evidence, working examples, test records, and links, but reorganize the note into the cognitive order defined here. Do not preserve a poor section order merely because it already exists.

### `materialize-mode`

Use when current chat context, source snapshots, review notes, terminal output, or previous analysis is being archived into a new code walkthrough note.

Verify important code claims against the repository whenever the repository is available. Chat summaries are not a substitute for current source evidence.

## Use When

Use this skill when the future reader wants to understand:

- where a class or component sits between the application and lower-level dependencies;
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
- “重写这篇源码分析笔记”;
- “按人的认知顺序读代码”.

## Avoid

Use another skill when the primary future-reading intention is different:

- use `note-linear-achievement` to preserve an exploration, debugging, or implementation journey;
- use `note-conclusion-evidence` when the main value is a conclusion and its proof;
- use `note-operation-manual` when the reader only needs repeatable commands;
- use `source-walk` when the only requested output is a temporary source snapshot under `/tmp`;
- use a concept note when the subject is protocol or theory rather than one concrete implementation.

A code walkthrough may contain historical failures, conclusions, or commands, but those are supporting material. Its center thesis is the implementation model of one concrete code subject.

## Required Companion Skills

When writing into the Blue Espeon Obsidian vault:

- use `blue-espeon-note-style` for placement, naming, backlinks, wikilinks, diagram conventions, and single-thesis boundaries;
- use `obsidian-frontmatter-metadata` as a required final metadata check;
- use `latex-math-writing` when mathematical notation appears;
- use `source-walk` first only when a separate source snapshot is useful or direct repository inspection is unavailable.

Do not create dead wikilinks silently. If a necessary companion note does not exist:

1. create it when the user's scope permits;
2. otherwise report the missing companion note explicitly instead of pretending the link resolves.

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
- **design suggestion**: a possible refactor or alternative, not current behavior;
- **external standard**: what an RFC, specification, or upstream reference requires.

Never present a suggested refactor as though it already exists.
Never claim that code compiles or tests pass without actual verification evidence.
Never replace a real usage example with pseudocode when the repository provides enough information to write compilable or repository-valid code.

## Scope Boundary

Prefer one primary subject per note:

- one class;
- one module;
- one component;
- one tightly coupled mechanism;
- one test infrastructure layer.

Do not turn a class note into a complete repository tour.

External dependencies should be handled as follows:

- explain only the interface surface needed by the current note;
- link to an existing dedicated note when deeper understanding is optional;
- create a companion note when the dependency itself requires substantial explanation;
- return to the current mainline after the dependency boundary is established.

Good split:

```text
TCPConnection walkthrough
├── link: TCPSegment structure and usage
├── link: TCPSender walkthrough
├── link: TCPReceiver walkthrough
└── link: TCPConnection test infrastructure
```

Bad split:

```text
TCPConnection walkthrough
└── inline full explanations of TCPHeader, WrappingInt32, ByteStream,
    EventLoop, TUN, UDP adapter, every sender algorithm, and every test fixture
```

## Investigation Workflow

Before writing, inspect enough source to build a reliable cognitive model.

### 1. Resolve The Exact Source Version

Capture:

- repository root or GitHub repository;
- branch, tag, or commit;
- whether the worktree is dirty;
- the exact target symbol or module.

If an existing note names a source commit, compare it with the current requested source before rewriting.

### 2. Find The Thin End-To-End Calling Slice

Locate only enough upper-layer code to answer:

- what the application or external caller does;
- which immediate owner, adapter, framework, scheduler, or container invokes the target;
- how application events become target public-method calls;
- where the target's outputs go.

Do not expand the full upper-layer implementation here.

### 3. Inspect The Target Surface

Collect:

- constructors, factory functions, and destructors;
- exported or public methods;
- private helpers;
- member variables or owned subcomponents;
- external types appearing in signatures or state;
- source-defined invariants and comments.

### 4. Build Read/Write And Call Maps

For every important method, determine:

- callers;
- direct callees;
- member state read;
- member state modified;
- external observable effects;
- early returns and skipped downstream work;
- invariants maintained.

### 5. Inspect Complete Runtime Scenarios

Find the normal lifecycle and meaningful mutually exclusive or exceptional branches.

For a stateful component, identify every important state transition and the event that triggers it.

### 6. Inspect Tests Before Writing The Test Chapter

Locate:

- test framework;
- fixtures;
- test harnesses;
- custom event or expectation types;
- helper classes;
- scenario builders;
- individual test families;
- assertion or oracle mechanisms;
- build and test commands.

### 7. Inspect Existing Notes And References

Search for:

- existing dependency notes;
- source-specific companion notes;
- protocol or standard notes;
- test-infrastructure notes;
- authoritative external references.

Reuse valid notes and links. Do not duplicate a mature dependency explanation inline.

## Core Cognitive Rules

### Rule 1: Start With A Short Goal

The opening goal should normally be one to three sentences.

It only needs to answer:

- what this subject is responsible for;
- why the reader would open this note.

Do not begin with broad history, generic motivation, or a large conceptual introduction. The future reader has already chosen to open the note.

### Rule 2: Explain The Application Connection Before Internal APIs

If the target is not directly called by application code, add a thin upper-layer slice before presenting its public API.

Explain:

```text
application action
→ immediate upper-layer component
→ target public method
→ target output
→ lower layer or application-visible result
```

Only explain how the upper layer produces the target's inputs and consumes its outputs. Link to the upper-layer walkthrough for implementation details.

### Rule 3: Use Real Public-API Examples Before Explaining The Declaration

Show how the public surface behaves before asking the reader to inspect its declaration.

Prefer several small, natural, repository-valid examples:

- one connection or initialization example;
- one input or write example;
- one receive or callback example;
- one shutdown or lifecycle example;
- one state-observation example when useful.

A small example may cover two or three naturally related APIs. Do not force all public methods into one artificial “god example.”

After the individual examples, later provide one complete lifecycle scenario that connects the main APIs.

Usage examples must:

- use real types;
- use plausible concrete values;
- use real construction paths;
- show real outputs or observable state;
- compile or fit the repository's actual test/application environment when practical;
- avoid pseudocode placeholders such as `do_something()` unless that call is explicitly marked as an omitted external boundary.

### Rule 4: Treat Constructors And Destructors As Lifecycle Boundaries

Constructors, factories, initialization methods, destructors, close methods, and cleanup hooks come before ordinary method implementation details.

They answer:

```text
how the object is born
→ what initial invariants exist
→ what events it can accept
→ how it must leave
```

Explain:

- input configuration;
- owned subobjects created;
- initial member state;
- post-construction invariants;
- clean versus unclean destruction behavior;
- externally visible cleanup effects.

Use a decision diagram for nontrivial destruction behavior. Do not draw a diagram for obvious field assignment.

### Rule 5: Explain Public Methods Twice, For Different Purposes

The first pass is natural-language responsibility explanation after the class declaration.

For every public method, answer:

- who calls it;
- when it is called;
- what event it represents;
- what external result it can produce;
- how it affects the object's lifecycle.

Do not merely restate parameter and return types.

The second pass is the implementation walkthrough later in the note.

### Rule 6: Private Helpers Own Their Own Sections

A private helper does not belong to whichever public method happens to be explained first.

In a public-method section:

- describe each called private helper in one or two sentences;
- state its role in the current path;
- link to the helper's dedicated same-note section;
- do not inline the helper's full implementation there.

In the private-helper section:

- group helpers by responsibility domain;
- explain the implementation in detail;
- list and link every meaningful caller;
- provide a route back to the relevant public mainline.

This two-pass structure preserves a readable public mainline without duplicating shared helper explanations.

### Rule 7: Member Variables Are Explained Through Behavior

Do not create long standalone essays for every member variable.

Provide only a compact state ledger that identifies:

- role;
- main readers;
- main writers;
- whether the value is authoritative state, derived state, cache, queue, timer, flag, or owned component.

Then explain actual state changes inside the methods that cause them.

Every important modifying method should show the relevant state difference.

### Rule 8: Large Methods Are Split By Responsibility, Not By Line Number

For a method of roughly tens of lines or more, first identify coherent responsibility blocks.

A block should:

- solve one local purpose;
- have clear input conditions;
- use a small local variable scope;
- produce a describable state or control-flow result;
- establish conditions for the next block.

Blocks often happen to be around 5-12 lines, but fixed length is not the rule.

When discussing local variables:

- introduce them near first use;
- explain their local lifetime;
- do not front-load a list of variables that are used much later;
- if the source itself has poor variable locality, describe the factual source layout and separately mark the readability suggestion.

Do not explain a large method line by line. Explain each responsibility block using state transitions and control guarantees.

### Rule 9: Complete Scenarios Come After Method-Level Understanding

After all important public and private methods have been explained, add a complete scenario that recombines them.

Use:

- one realistic normal mainline;
- several attached mutually exclusive or exceptional branches;
- a coverage table mapping every meaningful state transition to a scenario;
- one final complete state-machine diagram when the subject has a state machine.

Do not force active close, passive close, reset, timeout, success, and every error into one fake execution.

The mainline provides continuity. Branches provide completeness. The final state machine compresses the model.

### Rule 10: Tests Are Executable Behavioral Proof

The test chapter must first explain the language of the test suite, then the individual tests.

Do not begin by pasting a random `TEST`, `TEST_F`, or custom harness invocation.

## Default Note Architecture

Use this order unless the source shape makes a section genuinely inapplicable. If omitted, state why it is not applicable.

```markdown
## 目标

## 阅读边界与导航

## 从应用到当前组件

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

For non-class subjects:

- “Public API” means exported functions, callbacks, handlers, commands, or protocol entrypoints;
- constructor/destructor sections may become initialization/registration/cleanup;
- member state may become module state, context, cache, tables, or owned resources.

## Opening And Navigation Rules

### Goal

Keep the goal short. Do not explain the whole topic before the walkthrough starts.

### Coverage Boundary

State what the note covers and intentionally does not expand.

Example:

```text
本文重点：TCPConnection 的调用链、内部职责、状态变化和测试覆盖。
本文不展开：TCPHeader 编解码、WrappingInt32 原理、TUN 实现。
```

### Intent-Based Navigation

For a long note, add a compact reading-intent index:

```markdown
- 想先知道怎么用：[[#Public API 的真实调用案例]]
- 想看内部设计：[[#类内部责任划分]]
- 想查某个方法：[[#实现走读]]
- 想理解状态变化：[[#完整生命周期与状态分支]]
- 想排查测试：[[#测试覆盖矩阵与失败定位]]
```

Do not duplicate a full table of contents when Obsidian already provides headings.

## Thin Application-To-Component Slice

This section is mandatory when the target is a middle-layer or framework-owned component.

Answer only:

1. what the application or external actor does;
2. what immediate upper-layer owner translates that action;
3. which target public method is invoked;
4. how target output reaches the application or lower layer.

A compact event translation table is often sufficient:

| External event | Immediate owner action | Target API | Output consumer |
|---|---|---|---|
| application write | event loop reads local socket | `write()` | sender / outbound queue |
| network segment | adapter parses datagram | `segment_received()` | receiver / ACK path |

Link to the upper-layer note for implementation details.

## Real Usage Example Rules

### Multiple Small Examples First

Prefer scenario groups over one all-inclusive example.

Each example should answer one concrete question and have an observable result.

Good example groups:

- construct and initiate;
- provide input and collect output;
- receive an external event;
- read produced data;
- close or destroy;
- observe state.

### Main Lifecycle APIs Versus Observation APIs

Main lifecycle APIs should later appear in the complete scenario.

Accessors, diagnostics, metrics, and test-only methods may appear as assertions or observations in small examples. They do not need to be forced into the mainline.

### Dependency Boundaries

When an example needs another complex type:

1. show only the fields or methods necessary for the current call;
2. explain that minimum interface surface;
3. link to the dependency note;
4. continue the current scenario.

Do not derail the main note into the dependency's full implementation.

## Declaration And Responsibility Explanation

### Show The Real Declaration

Present the relevant real declaration with enough context to distinguish:

- construction and destruction;
- public/exported interface;
- private helpers;
- owned state;
- external types.

Omit irrelevant boilerplate only when the omission is clearly marked.

### Public API Natural-Language Pass

For each public method, use concise natural language:

```markdown
### `method()`

- 调用者：...
- 调用时机：...
- 表示的事件：...
- 产生的外部结果：...
- 生命周期作用：...
```

Pure accessors may be grouped in a table.

### Responsibility Map

Do not force the class into a tree when helpers are shared.

Use a directed responsibility graph:

```text
external trigger
→ public entrypoints
→ internal responsibility domains
→ state sources / external dependencies
```

Recommended Mermaid structure:

- first layer: application, network, timer, framework, or test triggers;
- second layer: public methods;
- third layer: private responsibility domains;
- fourth layer: owned state and external components.

Use converging edges for shared helpers instead of duplicating helper nodes under multiple public methods.

Split the graph by responsibility domain when it becomes a spider web.

External dependencies should be visually distinguishable and explained through wikilinks in nearby text.

## Constructor And Destructor Walkthrough

Explain construction before ordinary method internals.

### Constructor Template

```markdown
### 构造输入

### 创建的子对象

### 初始状态

| State | Initial value | Meaning |
|---|---|---|

### 构造后不变量

### 此时可以接受的事件
```

### Destructor Or Cleanup Template

```markdown
### 正常退出条件

### 未正常收尾时的处理

### 外部可观察效果

### 资源和状态最终结果
```

Use a decision diagram only when cleanup has meaningful branches or protocol effects.

## Member State Ledger

Keep this section compact.

Recommended fields:

| Member | Role | Main readers | Main writers | State kind |
|---|---|---|---|---|
| `_active` | connection liveness summary | adapter, state reporting | reset, active update | derived control flag |

Do not fully explain state evolution here. Link readers to the methods that modify it.

## Public Method Implementation Template

Use this template for important public methods:

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

Simple entry methods may use a shorter version. Pure accessors normally belong in a table.

## Private Helper Implementation Template

Group private helpers by responsibility domain, not by declaration order and not by the first public caller.

For every important helper:

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

A reader who does not follow the link must still understand the public mainline. A reader who follows it must be able to return without searching manually.

## Large Method Walkthrough

### Responsibility Blocks

Before explaining code, write a compact block overview:

```text
1. reject events that cannot be processed
2. update send-side acknowledgment state
3. update receive-side stream state
4. generate outbound work
5. update lifecycle state
```

For each block, explain:

1. local purpose;
2. relevant real code excerpt;
3. input or precondition;
4. local variables and their lifetime;
5. state before and after;
6. what later blocks may now assume;
7. what an early return prevents from running.

This should let the reader mentally execute the block without running a debugger.

### Do Not Translate Every Line

Do not write:

```text
line 1 checks X
line 2 assigns Y
line 3 calls Z
```

Instead explain the responsibility and resulting state transition.

### Refactor Signals

If a responsibility block has a clear reusable input/output boundary and significant complexity, note that it may be a private-helper extraction candidate.

Mark this as a design suggestion, not current source fact.

## State Change Presentation

Choose the smallest useful representation.

### Scalar, Boolean, Enum, Counter, Timer

Use a one-line transition or small table:

```text
_time_since_last_segment_received: 120 ms → 0 ms
```

Do not create a diagram for a trivial assignment.

### Sequence, Queue, Array, List

Use one to three snapshots that demonstrate insertion, modification, and removal:

```text
initial: []
after connect(): [SYN]
after adapter pop(): []
```

### Map, Hash Table, Ledger

Use one to three keys to demonstrate the rule:

```text
{}
→ {1000: SYN}
→ {1000: SYN, 1001: DATA("hello")}
→ {}
```

Do not enumerate an unbounded container.

### Owned Subobject State

Expose only the state surface relevant to the current method:

- bytes in flight;
- reassembled bytes;
- pending tasks;
- current state;
- queue contents;
- error or EOF flags.

### Cross-Object Interaction

Use a sequence diagram when call ownership and event handoff matter.

### State Transition Logic

Use a state diagram when multiple events or conditions select different transitions.

### Responsibility Ordering

Use a flowchart when the order cannot be safely rearranged.

## Diagram Admission Rule

A diagram is allowed only when it clarifies a nontrivial relationship that prose or a small table would not show as clearly.

Prefer a diagram when it expresses at least two dimensions, such as:

- caller plus callee plus state effect;
- multiple conditions plus multiple transitions;
- multiple public methods sharing helpers;
- runtime events crossing object boundaries;
- lifecycle branches;
- test setup, stimulus, and oracle.

Do not use diagrams for:

- flat lists;
- direct getters;
- one obvious assignment;
- `1 + 1 = 2`-level logic;
- decorative summaries already expressed by code or a table.

Additional rules:

- one diagram answers one question;
- keep 5-9 nodes by default;
- split large diagrams;
- use stable left-to-right or top-to-bottom orientation across the note;
- keep application, target, and network positions consistent across diagrams;
- add one sentence before the diagram saying what to observe;
- add one sentence after the diagram stating the conclusion;
- do not repeat the exact same information in code, table, and diagram.

## Complete Lifecycle And State-Machine Coverage

### Normal Mainline

Build one realistic, continuous scenario using the real APIs and real data types.

For every important step, show:

- triggering event;
- public method called;
- key private responsibility invoked;
- input segment, request, object, or data;
- member-state difference;
- external output;
- current logical state;
- links back to method details.

### Attached Branches

Attach branches at the exact point where behavior diverges:

- passive versus active close;
- success versus timeout;
- normal acknowledgment versus retransmission;
- valid input versus reset or error;
- ordered versus out-of-order data;
- open versus zero window.

Do not destroy the mainline by repeatedly restarting it from the beginning.

### State Transition Coverage Table

For stateful subjects, include:

| Transition | Trigger | Scenario location | Main method | Test coverage |
|---|---|---|---|---|

Every meaningful state-machine edge should appear in this table or be explicitly marked outside the implementation's scope.

### Final Complete State Machine

Place the complete state-machine diagram after the reader has seen the scenarios and branches.

The diagram compresses prior understanding; it must not be the first explanation of unfamiliar states.

Below the diagram, add a compact reading index for the major paths.

## Reference Placement

### Local References

Insert authoritative references near the exact topic they support.

Default: at most one primary reference per focused subsection.

Prefer, in order:

1. current repository source or test;
2. official specification, RFC, standard, or language documentation;
3. upstream official documentation or source;
4. authoritative industrial implementation;
5. high-quality explanatory material.

Each local reference should state:

- what claim or question it supports;
- the exact relevant section or symbol when possible;
- what the reader should look for.

Example:

```markdown
> [!reference] 协议依据
> RFC xxxx §x.x defines ...
> 阅读重点：...
```

Do not dump many links in the middle of a section.

### Industry Comparison

When the note explains the repository's approach and the reader may reasonably ask whether production systems do the same, add one authoritative comparison entry at that point.

Clearly distinguish the teaching implementation from the industrial implementation.

### End References

Use the final `扩展阅读` section only for broader optional directions. Group them by purpose and add one sentence explaining why each is useful.

Do not make the end of the note the only place where references appear.

## Build Verification

Keep build coverage short.

Include:

- exact working directory or repository root;
- exact build command;
- actual result;
- what the successful build proves;
- what it does not prove.

Do not expand this into an operation manual unless the build itself is the subject.

If build verification cannot be run, write `未验证` and the concrete blocker.

## Test Chapter

### 1. Explain Test Infrastructure First

Before individual tests, identify the test language:

- framework;
- fixture classes;
- harness objects;
- scenario builders;
- custom event types;
- expectation types;
- helper functions;
- time simulation;
- outbound-input inspection helpers;
- setup and teardown behavior.

### 2. Split Nontrivial Test Infrastructure Into A Companion Note

Create or reuse a companion test-infrastructure note when one or more of these is true:

- multiple test files reuse the same fixture or harness;
- two or more nontrivial custom helper classes must be understood first;
- the harness hides a long lifecycle or state machine;
- explaining helpers inline would interrupt every test case;
- the infrastructure itself has enough material for multiple sections.

The target walkthrough should still provide the minimum interface surface needed for the current test, then link to the companion note.

Do not split a trivial two-line helper into a separate note.

### 3. Group Tests By Behavioral Family

Do not default to source-file order.

Possible families:

- construction and connection establishment;
- normal data transfer;
- ordering and buffering;
- windows and flow control;
- close paths;
- timeout and retransmission;
- reset and error handling;
- integration and adapter behavior.

For each family, explain:

- the overall behavior protected;
- state-machine nodes and edges involved;
- methods and invariants involved;
- how individual cases differ.

### 4. Explain Test Intent Before Test Code

For every important test, use this order:

```text
what the test proves
→ initial state
→ injected events
→ expected state transitions
→ oracle / assertions
→ actual test code
→ likely implementation fault when it fails
```

### 5. Test Oracle Rule

Every test explanation must state how correctness is observed.

Possible oracles:

- return value;
- thrown error;
- emitted segment or message;
- queue contents;
- header fields;
- output bytes;
- state transition;
- timer behavior;
- final hash or integration result;
- absence of unexpected work.

### 6. Test Case Template

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

### 7. Test Explanation Depth

Use three levels:

- **index level**: one-line intent, stimulus, and assertion for repetitive cases;
- **standard level**: initial state, events, state-difference table, oracle;
- **deep level**: staged execution, diagrams, fixture expansion, multiple state snapshots, failure localization.

Do not give every test equal space.

### 8. Complex Tests Are Staged Like Large Methods

Split a long test into phases such as:

```text
setup
→ establish initial state
→ inject stimulus
→ advance time or external events
→ assert intermediate state
→ inject recovery or branch event
→ assert final state
```

For each phase, show state changes and the assertion that closes the phase.

### 9. Test Coverage Matrix

End the test chapter with a matrix:

| Behavior or invariant | Implementation method | Test family | Concrete test | Failure signal |
|---|---|---|---|---|

This matrix should reveal:

- which important implementation claims are tested;
- which state transitions are covered;
- which methods lack direct coverage;
- what a failing test most likely implicates.

## Reader Experience Rules

### Support Sequential And Nonlinear Reading

The note must work both from beginning to end and through direct heading links.

### Provide Return Paths

Every deep private-helper or dependency section should identify its callers and provide links back to relevant public mainlines.

### Add Cognitive Checkpoints

After long phases, add a short checkpoint:

```markdown
> [!summary] 读到这里应当明确
> - ...
> - ...
```

Useful locations:

- after public usage;
- after responsibility mapping;
- after method implementation;
- after complete lifecycle;
- after tests.

Do not repeat the entire section.

### Preserve Stable Vocabulary

Choose one stable set of directional terms and use it throughout, for example:

- local / peer;
- application side / network side;
- inbound / outbound;
- sender / receiver;
- source queue / final output queue.

Do not casually switch viewpoints between diagrams.

### Keep Code Context Just Large Enough

A code excerpt should include enough context to identify:

- containing method;
- relevant conditions;
- local variables;
- transition to the next responsibility block.

Do not show a single unexplained call when context is required. Do not paste an entire huge file when ten focused lines are enough.

### Use One Primary Representation Per Fact

- code proves implementation;
- prose explains intent and reason;
- a table shows comparison or state difference;
- a flowchart shows ordered responsibility;
- a sequence diagram shows object interaction;
- a state diagram shows transitions.

Avoid repeating the same fact in all five forms.

### Use Progressive Disclosure

Keep raw logs, full declarations, repetitive tests, and secondary evidence in foldable callouts or appendices when they would interrupt the mainline.

### Make Omission Explicit

If a method, branch, external dependency, state transition, build target, or test family is intentionally not covered, state why.

## Mandatory Validation Checklist

Before finishing, verify all applicable items.

### Source Grounding

- [ ] Repository, branch/tag, and commit are recorded when available.
- [ ] Source and test paths are correct.
- [ ] Important claims are grounded in current source.
- [ ] Build and test outputs are real or explicitly marked unverified.
- [ ] Current behavior is separated from design suggestions.

### Cognitive Order

- [ ] Goal is short.
- [ ] Coverage boundary is explicit.
- [ ] A middle-layer component has a thin application-to-component slice.
- [ ] Real public usage appears before internal implementation.
- [ ] Examples use real types and values rather than pseudocode.
- [ ] Multiple small examples are used instead of one artificial all-API example.

### Declaration And Lifecycle

- [ ] Real declaration or exported surface is shown.
- [ ] Construction and destruction/cleanup are explained before ordinary internals.
- [ ] Every important public API has caller, timing, event meaning, result, and lifecycle role.
- [ ] Private responsibilities are grouped by domain.
- [ ] Shared helpers are not falsely owned by one public method.

### Method Detail

- [ ] Public mainlines explain helper roles without duplicating helper internals.
- [ ] Every important private helper has a dedicated section and caller backlinks.
- [ ] Important methods show read set, write set, state difference, observable result, and invariants.
- [ ] Large methods are divided into cohesive responsibility blocks.
- [ ] Early returns state what later work is skipped.
- [ ] Member-state behavior is explained through modifying methods.
- [ ] Containers use only enough snapshots to explain insertion, update, and removal.

### Diagrams And Links

- [ ] Every diagram answers a nontrivial question.
- [ ] No obvious assignment or flat list receives a decorative diagram.
- [ ] Diagram orientation and terminology are stable.
- [ ] Same-note deep links have return paths.
- [ ] External dependency links resolve or are explicitly reported missing.
- [ ] Code, prose, tables, and diagrams do not redundantly repeat the same fact.

### Lifecycle Completeness

- [ ] One realistic normal lifecycle is complete.
- [ ] Mutually exclusive and exceptional behaviors are attached as branches.
- [ ] Every meaningful state transition appears in the coverage table or is marked out of scope.
- [ ] A final complete state machine is included when applicable.

### References

- [ ] Topic-specific authoritative references appear at the relevant sections.
- [ ] Local sections do not contain link dumps.
- [ ] Teaching implementation, specification, and industrial comparison are distinguished.
- [ ] Broader optional references are grouped at the end.

### Build And Tests

- [ ] Build verification is short and factual.
- [ ] Test infrastructure is explained before individual tests.
- [ ] Nontrivial shared test infrastructure is split or linked appropriately.
- [ ] Tests are grouped by behavioral family.
- [ ] Important tests explain intent before code.
- [ ] Every important test names its oracle.
- [ ] Complex tests are divided into execution phases with state changes.
- [ ] A coverage and failure-localization matrix closes the test chapter.

### Reader Experience

- [ ] Long notes have intent-based navigation.
- [ ] Long phases have concise cognitive checkpoints.
- [ ] Vocabulary and visual orientation remain stable.
- [ ] Secondary evidence uses progressive disclosure.
- [ ] Omitted material is explicitly marked.

## Frontmatter Metadata Check Rule

Before finishing any generated or transformed Obsidian note, use `obsidian-frontmatter-metadata` as a required check.

The YAML frontmatter must preserve valid top-level metadata, especially:

- `summary`;
- `aliases`;
- `tags`;
- existing source metadata such as repository, branch, commit, source files, and test status when present.

Do not let `summary`, `aliases`, `tags`, or status fields become accidentally nested under a YAML list item.

## Output Policy

After creating or editing the note, respond with:

```markdown
## 完成情况

- 类型：代码走读型
- 模式：repository-mode / transform-mode / materialize-mode
- 主笔记：`<path>`
- 伴随笔记：
  - `<path>` or `无`
- 源码版本：`<repo>@<branch-or-tag>:<commit>`
- 验证：
  - 编译：通过 / 失败 / 未运行
  - 测试：通过 / 部分通过 / 失败 / 未运行
- 主要覆盖：
  - 应用到组件调用链
  - Public API 与构造/析构
  - Public/Private 实现和状态变化
  - 完整生命周期与状态机
  - 测试基建、用例和覆盖矩阵
- 未覆盖或不确定点：
  - ...
```

Do not paste the whole note into chat unless the user asks.