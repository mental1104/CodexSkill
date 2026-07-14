---
name: note-code-walkthrough
description: Create or transform Obsidian source-code walkthrough notes that teach a concrete class, module, component, or tightly scoped mechanism from the reader's cognitive perspective: repository context, shared prerequisite infrastructure, application call chain, real public usage, construction and destruction, public/private implementation paths, member-state changes, complete scenarios, state machines, and repository-grounded behavioral tests. Use for repository-backed code reading, open-source walkthroughs, archived implementation notes, and existing code-note rewrites.
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
→ how repository tests prove the model
```

The main reader is the user's future self. Do not write a broad textbook chapter, a repository-wide tour, or a line-by-line source translation.

# Modes

## `repository-mode`

Use when the source of truth is a local checkout, GitHub repository, open-source repository, branch, tag, or commit.

Required actions:

1. resolve the repository root;
2. record branch, tag, commit, and working-tree status when available;
3. inspect the target implementation, declarations, callers, dependencies, ownership, tests, and build entrypoints;
4. inspect the thin application-to-target path and every non-obvious type on that path;
5. search existing notes before creating dependency or prerequisite notes;
6. use exact source paths and real code;
7. inspect the repository's build and test registration before defining the test scope;
8. read the actual test bodies and shared fixtures/harnesses for every target-owned behavioral family;
9. run focused build or tests when the environment permits and verification is in scope;
10. never invent source behavior, resolved links, selected tests, or successful output.

The test scope is not inferred from filenames. Resolve it through the repository's actual build graph and test runner configuration, such as:

- `Makefile` targets;
- CMake executable declarations and `add_test` registrations;
- CTest regexes or labels;
- Bazel targets;
- Meson test definitions;
- Gradle/Maven suites;
- package scripts;
- CI workflow commands;
- custom shell runners.

When a target selects tests indirectly, expand the selection and distinguish:

- tests newly owned by the target component or lab;
- inherited regression tests from dependencies or earlier stages;
- integration/end-to-end tests that cross runtime or adapter boundaries;
- optional, strict, extra-credit, disabled, skipped, or commented-out tests;
- tests built but not selected;
- tests selected by name regex, labels, dependencies, or aggregate targets.

## `transform-mode`

Use when an existing Markdown code note is being rewritten.

Preserve useful evidence, working examples, test records, images, and valid links, but reorganize the note into the cognitive order defined here. Re-audit dependencies and tests instead of assuming the old note explained them adequately.

An existing generic test chapter is not evidence. Re-open the repository, resolve the current build/test boundary, read concrete cases, and replace vague statements with source-grounded test families and representative cases.

## `materialize-mode`

Use when current chat context, source snapshots, review notes, terminal output, or previous analysis is being archived into a new walkthrough.

Verify important claims against the repository whenever it is available. Chat summaries are not a substitute for current source evidence.

If repository access is unavailable, mark the implementation and test chapter as unverified or historical. Never synthesize test names, target membership, or case behavior from memory.

# Use When

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
- which tests actually belong to the component's responsibility boundary;
- how concrete test cases construct scenarios and decide correctness.

Typical signals:

- “代码走读”;
- “源码走读笔记”;
- “把这个类 / 模块 / 组件梳理成笔记”;
- “从应用调用到内部实现讲清楚”;
- “分析 public / private 方法和成员状态”;
- “把这个开源仓库的实现归档”;
- “把测试用例也一起讲明白”;
- “按用例性质划分测试群”;
- “确认哪些测试属于这个 Lab / 模块的责任田”;
- “把仓库里的 socket / adapter / runtime 前置讲清楚”;
- “重写这篇源码分析笔记”;
- “按人的认知顺序读代码”.

# Avoid

Use another skill when the primary future-reading intention is different:

- use `note-linear-achievement` to preserve an exploration, debugging, or implementation journey;
- use `note-conclusion-evidence` when the main value is a conclusion and its proof;
- use `note-operation-manual` when the reader only needs repeatable commands;
- use `source-walk` when the only requested output is a temporary source snapshot under `/tmp`;
- use a concept note when the subject is protocol or theory rather than one concrete implementation.

A walkthrough may contain history, conclusions, references, or commands, but those are supporting material. Its center thesis is the implementation model of one concrete code subject.

# Required Companion Skills

When writing into the Blue Espeon Obsidian vault:

- use `blue-espeon-note-style` for placement, naming, backlinks, wikilinks, diagram conventions, and single-thesis boundaries;
- use `obsidian-frontmatter-metadata` as a required final metadata check;
- use `latex-math-writing` when mathematical notation appears;
- use `source-walk` first only when a separate snapshot is useful or direct repository inspection is unavailable.

Do not create dead wikilinks silently. If a required note does not exist:

1. create it when the approved scope permits;
2. otherwise keep the minimum explanation inline and explicitly report the missing note.

# Evidence And Honesty Rules

Every important implementation and test claim must be grounded in current source evidence.

Record when available:

- repository;
- branch or tag;
- commit;
- working-tree status;
- relevant source files;
- relevant test files;
- build entrypoints;
- exact test command or target;
- test selection rule;
- build and test status.

Distinguish clearly between:

- **source fact**: what the current code does;
- **test fact**: what a concrete test sets up, stimulates, and asserts;
- **build-selection fact**: which tests a target actually builds or runs;
- **walkthrough interpretation**: the cognitive model derived from the code;
- **design suggestion**: a possible refactor or alternative;
- **external standard**: what a specification or upstream reference requires;
- **historical evidence**: results from an older commit that have not been revalidated.

Never present a suggested refactor as current behavior. Never claim compilation or test success without actual evidence. Never replace a real usage or test case with pseudocode when repository-valid code is available.

A test filename, suite name, comment, or README list is not enough to claim coverage. The claim must be supported by the actual test body and its oracle.

# Note Ecosystem And Companion Note Types

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

## 3. Shared Repository Prerequisite Note

Use for repository-specific infrastructure that appears across multiple walkthroughs, is necessary for understanding ownership or data flow, but does not deserve a full walkthrough for every type.

Typical subjects:

- socket wrappers;
- adapter stacks;
- event-loop ownership;
- file-descriptor wrappers;
- framework containers;
- scheduler or callback glue;
- repository-specific runtime abstractions;
- template aliases or layered wrapper types whose names do not reveal their role.

Its center thesis must be a coherent shared mechanism, not “miscellaneous classes.”

## 4. Test Infrastructure Note

Use when fixtures, harnesses, custom actions, expectations, builders, state factories, fake clocks, transport mocks, or output collectors must be understood before individual tests can be read comfortably.

Example:

- `CS144 TCPConnection 测试基建与夹具`.

A test-infrastructure note explains the testing language. It does not replace the primary note's responsibility boundary, family map, representative concrete cases, or coverage matrix.

## Companion Note Output Categories

```text
primary walkthrough
├── shared repository prerequisites
├── dedicated dependency walkthroughs
└── test infrastructure notes
```

Do not report them as an undifferentiated companion-note list.

# Scope Boundary

Prefer one primary subject per main note:

- one class;
- one module;
- one component;
- one tightly coupled mechanism.

Do not turn a class note into a complete repository tour.

External material must use progressive depth:

1. give the minimum current-context explanation inline;
2. deep-link to an exact heading when optional detail exists elsewhere;
3. use a shared prerequisite note for reusable repository glue;
4. use a dedicated walkthrough when the dependency itself is complex;
5. return to the current mainline after establishing the boundary.

For tests, keep the same boundary discipline:

- explain component-owned tests deeply in the primary note;
- summarize inherited dependency regressions and link to their own walkthroughs;
- explain cross-layer integration tests at the boundary relevant to the component;
- do not absorb every repository test into one note merely because an aggregate target runs it.

# Investigation Workflow

Before writing, inspect enough source and existing notes to build a reliable cognitive model.

## 1. Resolve The Exact Source Version

Capture:

- repository root or GitHub repository;
- branch, tag, or commit;
- whether the worktree is dirty;
- the exact target symbol or module.

If an existing note names a source commit, compare it with the requested source before rewriting. Keep historical implementation evidence separate from newly audited test evidence when they come from different revisions.

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

Classify each type as:

| Type condition | Required treatment |
|---|---|
| Standard or obvious, one sentence is enough | explain inline only |
| Complex domain object with its own behavior/state | dedicated dependency walkthrough |
| Reused repository glue between application and core components | shared repository prerequisite note |
| Complex test-only support | test infrastructure note |
| Role cannot be verified | mark uncertainty; do not pretend it is understood |

Search existing notes before creating new prerequisite or dependency notes.

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

## 7. Establish The Test Responsibility Boundary

This step is mandatory before writing the test chapter.

### 7.1 Read Build And Test Registration

Inspect the repository's actual build and test entrypoints. Resolve:

```text
source test file
→ built executable or test artifact
→ registered test name
→ aggregate target / runner selection
→ exact command, regex, label, or dependency that includes it
```

Do not assume that:

- a file in `tests/` is executed;
- a test executable is registered;
- a registered test belongs to the requested component;
- a target named after a lab runs only that lab;
- every strict or extra-credit test is part of the default target;
- every test selected by an aggregate target is newly owned by the current component.

### 7.2 Classify Selected Tests

Create an internal inventory with at least these classes:

| Classification | Meaning |
|---|---|
| target-owned direct tests | directly instantiate or drive the target and assert its behavior |
| integration/end-to-end tests | cross owners, adapters, processes, storage, network, UI, or runtime layers |
| inherited regression tests | verify dependencies or earlier stages were not broken |
| optional/strict/extra tests | not in the default required target, or selected only by another mode |
| built but unselected | compiled but absent from the requested test command |
| disabled/skipped/commented | present as source or registration but not active |

The final note must make this distinction explicit whenever aggregate targets blur responsibility.

### 7.3 Read Actual Test Code

For every important target-owned family, read:

- actual test bodies;
- fixtures and shared setup;
- harness/action/expectation implementations;
- state factories;
- fake clocks or time advancement;
- input builders;
- output collectors;
- helper assertions;
- teardown and cleanup where behaviorally relevant.

Do not classify a family solely from filenames or comments. Verify the stimuli and assertions in code.

### 7.4 Group By Behavioral Semantics

Group tests by what they prove, not by directory order or filename order.

Possible families:

- construction/connection;
- data transfer;
- ordering/buffering;
- windows/flow control;
- close paths;
- timeout/retransmission;
- reset/error;
- persistence/recovery;
- concurrency/ownership;
- integration/adapter/runtime behavior.

A family may include cases from several files. A single file may contain several behavioral families.

### 7.5 Select Representative Concrete Cases

Every important family must have at least one concrete source-backed case in the note. High-risk state, time, window, retry, ownership, or error behavior normally requires a deep case.

For each representative case extract:

```text
test intent
→ exact initial state/setup
→ injected event or input
→ intermediate state changes
→ oracle(s)
→ absence-of-work assertions
→ covered methods/invariants
→ likely fault location
```

Generic statements such as “the connect tests verify the handshake” or “the close tests verify linger” are insufficient without concrete cases.

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

## Rule 2: Explain Repository Prerequisites Before They Become Obstacles

Before the first real usage example, identify only the non-obvious repository-specific types required to understand that example and the application call chain.

For each type, provide:

- one sentence explaining its current role;
- its position in the chain;
- an exact deep link when available.

The main note must remain understandable without opening the link.

## Rule 3: Explain The Application Connection Before Internal APIs

For a middle-layer or framework-owned target, show:

```text
application action
→ repository-specific wrapper / owner
→ target public method
→ target output
→ adapter / lower layer / application-visible result
```

## Rule 4: Use Real Public-API Examples Before The Declaration

Prefer several small, natural, repository-valid examples. They must use real types, plausible values, real construction paths, and observable results.

## Rule 5: Treat Construction And Destruction As Lifecycle Boundaries

Explain:

```text
how the object is born
→ what owned objects are created
→ what initial invariants exist
→ what events it can accept
→ how it must leave
```

Cover clean versus unclean destruction and externally visible cleanup effects.

## Rule 6: Explain Public Methods Twice

First pass: natural-language responsibility, caller, timing, event, result, lifecycle role.

Second pass: implementation walkthrough with read set, write set, state difference, observable result, branches, and invariants.

## Rule 7: Private Helpers Own Their Own Sections

Group helpers by responsibility domain, list meaningful callers, explain implementation once, and provide return paths to public mainlines.

## Rule 8: Member Variables Are Explained Through Behavior

Provide a compact ledger, then explain state evolution inside modifying methods.

## Rule 9: Large Methods Are Split By Responsibility

Identify cohesive blocks by purpose, precondition, local variables, state effect, control guarantee, and skipped work after early returns. Do not translate every line.

## Rule 10: Complete Scenarios Follow Method-Level Understanding

After methods, add one realistic mainline, attached branches, a transition coverage table, and a final state-machine diagram when applicable.

## Rule 11: Tests Are Executable Behavioral Proof

Explain the test language before cases, but do not stop at the harness.

A complete test chapter must contain:

```text
build/test selection boundary
→ responsibility classification
→ test infrastructure language
→ behavioral family map
→ representative concrete cases
→ coverage and failure-localization matrix
```

The following is not acceptable:

```text
connect tests verify connection
close tests verify close
retransmission tests verify retransmission
```

The note must show what a real case starts with, what it injects, what changes, how correctness is observed, what must not happen, and which implementation fault would explain failure.

## Rule 12: References Follow The Topic

Place authoritative references near the exact topic they support. Use the final reference section only for broader optional reading.

# Default Primary Note Architecture

Use this order unless a section is genuinely inapplicable:

```markdown
## 目标

## 阅读边界与证据版本

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

## 测试责任边界：构建目标与实际选择

## 测试基建与前置依赖

## 测试族与覆盖地图

## 重点测试用例走读

## 测试覆盖矩阵与失败定位

## 扩展阅读
```

For non-class subjects:

- “Public API” means exported functions, callbacks, handlers, commands, or protocol entrypoints;
- constructor/destructor may become initialization/registration/cleanup;
- member state may become module context, caches, tables, queues, or owned resources.

# Thin Application-To-Component Slice

This section is mandatory for a middle-layer or framework-owned target.

A compact table is often sufficient:

| External event | Immediate owner | Target API | Output consumer | Prerequisite context |
|---|---|---|---|---|

Do not expand the full owner or adapter implementation here.

# Constructor And Destructor Walkthrough

## Constructor Template

```markdown
### 构造输入
### 创建的子对象
### 初始状态
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

Use a compact table:

| Member | Role | Main readers | Main writers | State kind |
|---|---|---|---|---|

State kind may be authoritative, derived, cache, queue, timer, flag, or owned component.

# Public Method Implementation Template

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
### 关键分支与早返回
### 维护的不变量
```

# Private Helper Implementation Template

```markdown
### `<private helper>`

**职责**

**调用者**

**读取状态**

**修改状态**

**实现与职责块**

**为什么独立存在**

**维护的不变量**

**返回主线**
```

# State Change Presentation

Choose the smallest useful representation.

- scalar/boolean/enum/counter/timer: one-line transition or small table;
- queue/list: one to three snapshots;
- map/ledger: one to three representative keys;
- owned subobject: expose only the relevant surface;
- cross-object interaction: sequence diagram;
- transition logic: state diagram;
- responsibility order: flowchart.

Do not enumerate unbounded containers.

# Diagram Admission Rule

Use a diagram only when it clarifies a nontrivial relationship better than prose or a small table.

Prefer diagrams for:

- caller + callee + state effect;
- multiple conditions + transitions;
- public methods sharing helpers;
- runtime events crossing objects;
- layered wrapper/adapter ownership;
- lifecycle branches;
- test setup + stimulus + oracle.

Do not use diagrams for flat lists, direct getters, obvious assignments, or decorative summaries.

Additional rules:

- one diagram answers one question;
- keep 5–9 nodes by default;
- split large diagrams;
- keep orientation and terminology stable;
- explain what to observe before it;
- state the conclusion after it;
- do not repeat the same fact in code, table, and diagram.

# Complete Lifecycle And State-Machine Coverage

Build one realistic normal scenario using real APIs and types. Attach meaningful branches such as:

- passive versus active close;
- success versus timeout;
- acknowledgment versus retransmission;
- valid input versus reset/error;
- ordered versus out-of-order data;
- open versus zero window.

Use a transition coverage table:

| Transition | Trigger | Scenario location | Main method | Test coverage |
|---|---|---|---|---|

Every meaningful edge must appear or be explicitly out of scope.

# Build Verification

Keep build coverage short and factual:

- exact directory;
- exact command;
- actual result;
- what success proves;
- what it does not prove.

If unavailable, write `未验证` and the blocker.

# Test Chapter

## 0. Establish Test Responsibility Boundary

Begin with the actual build/test selection, not a semantic guess.

Required output:

| Test layer | Exact target/files | Selected by | Ownership | Treatment in note |
|---|---|---|---|---|
| direct target tests | ... | ... | component-owned | deep |
| integration tests | ... | ... | shared boundary | representative deep/standard |
| regression tests | ... | ... | dependencies/earlier stages | index/link |
| optional/strict tests | ... | ... | outside default target | explicit comparison |
| unselected/disabled | ... | ... | not executed | note only if relevant |

State the exact runner command or target and any regex/label/dependency expansion.

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

Explain how output from the target reaches the oracle. A test harness that silently drains queues, advances clocks, retries work, or transforms outputs must be made explicit.

## 2. Split Nontrivial Test Infrastructure

Create or reuse a test-infrastructure note when multiple files reuse a nontrivial harness or when inline explanation would interrupt every case.

Keep the minimum current interface inline, then deep-link. The primary note must still explain responsibility boundary, test families, representative cases, and coverage.

## 3. Group Tests By Behavioral Family

Do not default to file order.

For each family explain:

- overall behavior;
- state edges;
- implementation methods/invariants;
- differences among cases;
- exact member tests;
- why the family belongs to the target rather than only a dependency.

## 4. Explain Intent Before Code

Use this order:

```text
what the test proves
→ initial state
→ injected events
→ expected transitions
→ oracle
→ relevant actual code
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

Negative assertions such as “no extra output,” “not yet retransmitted,” or “state unchanged” are first-class oracles and must not be omitted.

## 6. Concrete Test Case Template

```markdown
### `<file / test name / case number>`：<intent>

**测试意图**

**为什么属于当前组件的责任**

**初始状态**

**注入事件**

**阶段与状态变化**

**测试预言机**

**实际测试代码**

**覆盖的方法与不变量**

**失败通常意味着什么**
```

## 7. Explanation Depth

- **index**: one-line intent, stimulus, assertion;
- **standard**: initial state, events, state difference, oracle, fault area;
- **deep**: staged execution, fixture expansion, snapshots, timing/window boundaries, negative assertions, failure localization.

Do not give every test equal space.

At minimum:

- every important behavioral family gets one concrete case;
- every high-risk state/time/window/retry/error family gets a deep case;
- integration suites get at least one decoded command or parameterized scenario and its final oracle;
- inherited regression suites are classified rather than falsely attributed to the target.

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

Close the chapter with:

| Behavior or invariant | Implementation method | Test family | Concrete test | Oracle | Failure signal |
|---|---|---|---|---|---|

Reveal:

- tested claims;
- covered state transitions;
- target-owned versus dependency-owned coverage;
- methods or branches lacking direct coverage;
- likely fault locations;
- integration failures that cannot be localized by the test alone.

# Reader Experience Rules

## Support Sequential And Nonlinear Reading

The note must work from beginning to end and through direct heading links.

## Provide Return Paths

Deep helper, dependency, prerequisite, and test-infrastructure sections should provide paths back to the mainline when useful.

## Link Does Not Replace Explanation

Every non-obvious external type or harness must have a minimum local explanation before a link.

## Prefer Precise Heading Links

Use exact relevant headings and verify they exist.

## Add Cognitive Checkpoints

After long phases, use concise summaries when helpful:

```markdown
> [!summary] 读到这里应当明确
> - ...
```

## Preserve Stable Vocabulary

Choose one set of directional terms and keep it throughout.

## Keep Code Context Just Large Enough

Include the containing method/test, relevant conditions, local variables, and transition to the next block. Avoid isolated calls and huge raw files.

## Use One Primary Representation Per Fact

- code proves implementation/test behavior;
- prose explains intent/reason;
- table compares state or coverage;
- flowchart shows ordered responsibility;
- sequence diagram shows interaction;
- state diagram shows transitions.

## Use Progressive Disclosure

Keep raw logs, full declarations, repetitive tests, and secondary evidence in foldable callouts or appendices when they interrupt the mainline.

## Make Omission Explicit

If a method, branch, dependency, build target, test family, or concrete case is omitted, state why and where the reader should go instead.

# Mandatory Validation Checklist

Before finishing, verify all applicable items.

## Source Grounding

- [ ] Repository, branch/tag, and commit are recorded when available.
- [ ] Source and test paths are correct.
- [ ] Important claims are grounded in current source.
- [ ] Build/test outputs are real or explicitly unverified/historical.
- [ ] Current behavior is separated from suggestions and standards.

## Dependency Readiness

- [ ] Every non-obvious type in the application slice, signatures, ownership, lifecycle, and tests was audited.
- [ ] Every such type has a minimum local explanation.
- [ ] Existing repository-level prerequisite notes were searched before creating new ones.
- [ ] Exact deep-link headings exist.
- [ ] Links supplement rather than replace local context.

## Cognitive Order

- [ ] Goal is short.
- [ ] Coverage boundary is explicit.
- [ ] A middle-layer target has a thin application-to-component slice.
- [ ] Real public usage appears before internal implementation.
- [ ] Examples use real types and values.

## Declaration And Lifecycle

- [ ] Real declaration/exported surface is shown.
- [ ] Construction and destruction/cleanup precede ordinary internals.
- [ ] Every important public API has caller, timing, event, result, and lifecycle role.
- [ ] Private responsibilities are grouped by domain.

## Method Detail

- [ ] Important methods show read set, write set, state difference, observable result, and invariants.
- [ ] Large methods are divided into cohesive responsibility blocks.
- [ ] Early returns state skipped later work.
- [ ] Member state is explained through modifying methods.

## Diagrams And Links

- [ ] Every diagram answers a nontrivial question.
- [ ] Orientation and terminology are stable.
- [ ] Code, prose, tables, and diagrams do not redundantly repeat facts.

## Lifecycle Completeness

- [ ] One realistic normal lifecycle is complete.
- [ ] Mutually exclusive and exceptional behavior is attached as branches.
- [ ] Every meaningful transition appears in the coverage table or is out of scope.
- [ ] A final complete state machine exists when applicable.

## Build And Test Responsibility

- [ ] The exact build/test target or command was inspected.
- [ ] Test registration and selection rules were read, including regexes, labels, or aggregate dependencies.
- [ ] The selected test set was expanded rather than guessed from filenames.
- [ ] Target-owned direct tests are separated from integration tests, inherited regressions, optional/strict tests, built-but-unselected tests, and disabled tests.
- [ ] Actual test bodies were read for every important target-owned family.
- [ ] Shared fixtures, harnesses, state factories, fake clocks, and oracle paths were inspected where relevant.
- [ ] Tests are grouped by behavioral semantics rather than file order.
- [ ] Every important family has at least one concrete source-backed case.
- [ ] High-risk state/time/window/retry/error behavior has a deep case.
- [ ] Every important case names its positive and negative oracles.
- [ ] Generic coverage claims are backed by specific test steps and assertions.
- [ ] Integration tests state what they prove and why they cannot localize all failures.
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
  - 测试构建边界与责任分类
  - 测试基建、行为族、具体用例和覆盖矩阵
- 未覆盖或不确定点：
  - ...
```

Do not paste the whole note into chat unless the user asks.
