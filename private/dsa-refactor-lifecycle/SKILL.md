---
name: dsa-refactor-lifecycle
description: Repository-grounded lifecycle for refactoring educational data structures and algorithms into reusable generic algorithm layers plus readable industrial implementations. Use whenever the user asks to refactor a container, tree, graph, search/sort algorithm, extract shared algorithms, preserve teaching APIs, add STL-style or allocator-aware implementations, adapt repository algorithms, expand tests, or continue the DataStructure industrialization series.
---

# DSA Refactor Lifecycle

## Role

Guide one data structure or algorithm through a complete, reviewable refactor lifecycle:

```text
现状审计
→ 兼容边界冻结
→ 逻辑分层
→ 通用算法抽离
→ 教学版适配
→ 工业版实现
→ 算法生态接入
→ 测试证明
→ 可读性与 PR 收口
```

The goal is not merely to produce a second implementation. The result must establish a reusable architecture in which:

1. stable algorithmic ideas are implemented once;
2. the teaching implementation keeps its learning-oriented API and behavior;
3. the industrial implementation follows standard ownership, lifetime, iterator, exception, and complexity semantics;
4. both implementations reuse the same logic whenever that reuse is correct;
5. repository evidence and tests prove the final behavior.

## Mandatory Triggers

Use this skill for requests such as:

- “重构这个数据结构”;
- “把教学版和工业版拆开”;
- “实现一个仿 STL 的容器”;
- “抽离通用算法层”;
- “让教学版和工业版复用同一套算法”;
- “继续按照 Vector 的流程重构 List / Stack / Queue / Tree / Graph”;
- “把这个算法改成 iterator-first”;
- “增加 allocator-aware 实现”;
- “保持旧 API 不变，同时新增工业实现”;
- “完成这一轮数据结构工业化”;
- equivalent repository-grounded DSA refactor requests.

Do not treat these requests as ordinary local cleanup. Apply the full lifecycle unless the user explicitly narrows the scope to one phase.

# Repository Defaults

## DataStructure Project Defaults

When the target repository is `mental1104/DataStructure`:

- long-term base branch: `refactor-container`;
- never merge changes into `main` automatically;
- never merge a PR automatically;
- the user performs the final merge;
- preserve existing commits unless the user explicitly authorizes rewriting history;
- prefer draft PRs for unfinished or review-oriented work;
- use the repository's established test and build system rather than inventing a parallel harness.

If the user provides a different base branch or repository rule, the explicit request overrides these defaults.

## Source Of Truth

Repository evidence is primary. Chat history explains intent but does not prove current behavior.

Before designing or modifying code, resolve as available:

- repository and remote;
- base branch and current head;
- current PR and stacked-PR relationships;
- target teaching implementation;
- public and protected API;
- current tests and test registration;
- downstream inheritance and callers;
- generic algorithm headers already present;
- compiler standard and build constraints;
- current commit history and whether it may be rewritten.

Never claim an API, behavior, complexity, test result, or compatibility property without inspecting the relevant code or executing a valid check.

# Architectural Model

Every refactor must classify code into the following layers.

## Layer 1: Cross-Component Generic Algorithms

Algorithms that depend only on iterator or minimal callable contracts belong in shared algorithm headers.

Examples:

```text
find / upper_bound / traversal
shuffle / deduplicate / unique
comparison-based sorting
range aggregation
iterator-based searching
```

Preferred shape:

```cpp
template<typename Iterator, typename Compare>
Result algorithm(Iterator first, Iterator last, Compare compare);
```

Rules:

- do not include a concrete container header;
- use iterator traits and minimal concepts available in the repository's C++ standard;
- do not mutate container size or capacity directly;
- return iterators, counts, or values that the owning container can apply;
- document iterator-category and complexity requirements.

## Layer 2: Component-Specific Shared Workflow

Stable workflows specific to one data structure belong in one component algorithm file:

```text
<Component>Algorithm.h
```

Examples:

- Vector gap opening, insertion commit, erase closing, capacity recommendation;
- tree insertion/linking/height-update sequence;
- hash-table probing workflow;
- graph traversal state machine;
- heap sift-up/sift-down workflow.

This layer may know the abstract operations required by the component, but must not know one concrete storage implementation.

Preferred shape:

```cpp
template<typename StorageOrOwner>
class ComponentAlgorithm;
```

or iterator-first free functions when no owner state is required.

A component should normally have at most one main `<Component>Algorithm.h`. Do not create many tiny `Component*.h` files unless their responsibilities are genuinely independent and reusable.

## Layer 3: Teaching Adapter

The teaching implementation keeps:

- existing class name and include path;
- existing public API;
- protected members required by derived classes;
- learning-oriented representation and behavior;
- existing test expectations unless the old behavior is demonstrably incorrect and the user approves a change.

It adapts its storage or node operations to Layer 2 rather than duplicating the shared workflow.

## Layer 4: Industrial Implementation

The industrial implementation owns concrete production semantics:

- allocator or ownership model;
- construction and destruction of objects;
- copy and move semantics;
- iterator validity rules;
- exception guarantees;
- capacity and complexity behavior;
- standard-style APIs where applicable;
- explicit handling of move-only, non-default-constructible, and throwing types.

It reuses Layer 1 and Layer 2, but must not pretend teaching storage semantics are industrial semantics.

## Required Dependency Direction

```text
通用算法层
      ↑
组件共享流程层
      ↑            ↑
教学实现        工业实现
```

Reject designs with reverse dependencies such as:

```text
共享算法层 → include 具体工业容器
共享算法层 → 访问教学版 _elem / _root / _size
工业实现   → 复制一份教学版完整算法流程
教学实现   → 依赖工业 allocator 细节
```

# Non-Negotiable Rules

## 1. Preserve Existing History And Code

Unless the user explicitly authorizes otherwise:

- do not force-push;
- do not squash or delete existing commits;
- do not remove existing implementation code merely because a new industrial implementation is added;
- do not silently change the target base branch;
- do not merge the PR.

When a later change supersedes an earlier attempt, append a corrective commit.

## 2. Freeze Compatibility Before Refactoring

Before modifying the teaching implementation, record:

- public constructors and methods;
- protected fields and helpers;
- inherited users;
- observable behavior;
- complexity assumptions;
- iterator and return-value behavior;
- automatic resize/shrink behavior;
- exception and invalid-input behavior;
- tests that encode the current contract.

Treat this as a compatibility checklist. Any intentional deviation must be called out and approved.

## 3. Reuse Correctly, Not Maximally

Use the following decision order.

### Directly share the implementation when

- the logic depends only on iterators, values, comparisons, or generic state;
- object lifetime is not controlled by the algorithm;
- both teaching and industrial versions require the same state transitions and guarantees.

### Share the workflow through a policy/adapter when

- the high-level steps are identical;
- storage, allocation, construction, destruction, rollback, or metadata maintenance differs;
- the algorithm can express required operations as a small stable contract.

### Keep separate implementations only when

- the observable semantics are intentionally different;
- the required exception or lifetime guarantees fundamentally conflict;
- a generic abstraction would expose more implementation detail than it removes;
- the teaching version is intentionally simplified and cannot satisfy the industrial contract.

When keeping logic separate, document the exact reason. “更方便” is not sufficient.

## 4. Do Not Leak Storage Details Into Shared Algorithms

Shared algorithm code must not directly depend on:

- `new[]` / `delete[]`;
- one concrete allocator;
- one node type's ownership convention;
- teaching-only fields such as `_elem`, `_root`, `_size`;
- default construction of unused capacity;
- concrete container indexes when iterators are sufficient.

## 5. Template Layout Must Optimize Reading

For large template classes, default to:

```text
class definition: declarations only
→ class definition ends
→ member implementations in logical order
→ non-member implementations
```

Keep the implementation in the same primary `.h` file unless the user explicitly prefers `.inl`, `.tpp`, or another repository convention.

Do not place substantial method bodies inside the class definition.

Recommended implementation order:

1. adapter/storage policy;
2. constructors, destructor, copy/move assignment;
3. element access and iterators;
4. capacity and modifiers;
5. private helpers;
6. non-member operators.

## 6. Chinese Documentation Is Mandatory

For all classes and functions added or materially changed by the refactor:

- add a concise Chinese responsibility comment;
- explain non-obvious complexity, ownership, exception, or iterator behavior;
- preserve code identifiers and standard terms in English;
- avoid comments that merely translate syntax;
- keep declaration comments and implementation-phase comments consistent.

Tests must also document helper types and the behavioral purpose of each test family.

## 7. Tests Are Contracts

Existing tests establish regression expectations. New tests establish industrial guarantees.

Never modify old tests merely to make a broken refactor pass unless the old assertion is incorrect and the change is explicitly justified.

Never report a test as passing without direct evidence.

# Complete Refactor Lifecycle

## Phase 0: Resolve Scope And Version

### Actions

1. identify the target structure or algorithm;
2. resolve repository, base branch, head branch, and PR;
3. inspect commit ancestry and stacked dependencies;
4. determine whether this is:
   - algorithm extraction only;
   - teaching adaptation only;
   - industrial implementation only;
   - or the full lifecycle;
5. identify user constraints on history, CI, comments, file layout, and merge behavior.

### Exit Gate

Do not modify code until the exact target and compatibility baseline are known.

## Phase 1: Audit The Current Teaching Implementation

### Inspect

- declaration and full implementation;
- representation and invariants;
- constructor/destructor behavior;
- copy/move support or absence;
- all basic CRUD operations;
- resizing, balancing, rehashing, or metadata updates;
- iterators and traversal;
- downstream derived classes;
- callers and algorithm adapters;
- current tests and missing tests.

### Produce An Internal Audit Table

| Concern | Current behavior | Must preserve? | Industrial target |
|---|---|---|---|
| API | current signatures | yes/no | standard-style surface |
| storage | teaching representation | usually yes | allocator/RAII ownership |
| lifetime | current object model | teaching only | explicit construct/destroy |
| mutation | current workflow | share candidate | shared workflow |
| algorithms | concrete-container calls | refactor candidate | iterator-first |
| complexity | observed/expected | preserve or improve | stated guarantee |
| tests | current coverage | regression contract | expanded matrix |

### Exit Gate

The refactor plan must identify what is teaching-specific, what is reusable, and what is missing.

## Phase 2: Freeze Contracts And Invariants

Write down the invariants before implementation.

### Container Examples

- valid elements occupy `[0, size)`;
- capacity and size relationship;
- node parent/child ownership;
- bucket occupancy and tombstone rules;
- iterator order and invalidation;
- empty-state representation;
- moved-from state;
- metadata consistency.

### Algorithm Examples

- input range category;
- stable or unstable behavior;
- comparison requirements;
- mutation boundaries;
- expected time and auxiliary-space complexity;
- return iterator/value semantics.

### Exit Gate

Every core operation must have a stated precondition, state transition, result, and complexity target.

## Phase 3: Classify Every Important Function

Place each function into exactly one primary category.

| Category | Destination |
|---|---|
| iterator/value-only algorithm | shared `dsa/algorithm/*` |
| structure-specific mutation workflow | one `<Component>Algorithm.h` |
| teaching storage/lifetime operation | teaching adapter/container |
| industrial storage/lifetime operation | industrial container |
| API forwarding | teaching or industrial facade |
| test-only instrumentation | target test file |

### Reuse Review Questions

For every duplicated teaching/industrial operation, ask:

1. Are the steps logically identical?
2. Are only the storage primitives different?
3. Can a small policy contract express the difference?
4. Does the shared layer remain independent of both concrete implementations?
5. Does sharing preserve exception and lifetime guarantees?

If answers 1–4 are yes and 5 is safe, duplication is not acceptable.

## Phase 4: Extract The Shared Algorithm Layer

### Generic Algorithms

Prefer iterator-first functions. Test them against:

- raw pointers;
- standard containers;
- teaching iterators where valid;
- industrial iterators.

### Component Workflow

Define the smallest policy/owner contract needed by the workflow.

Example mutation contract:

```text
size
maxSize
ensureCapacity
openGap
writeGap
rollbackGap
closeGap
commitSize
afterErase
```

Do not expose arbitrary references such as `sizeRef()` or raw internal pointers merely to make abstraction easy. Prefer semantic operations.

### Error And Rollback Contract

For every multi-step mutation, identify:

- what has been allocated;
- what has been constructed;
- what ownership has changed;
- what can throw;
- what cleanup runs before commit;
- what state is guaranteed after failure.

### Exit Gate

The shared algorithm must compile with at least two meaningfully different mock/adapters before being treated as reusable.

## Phase 5: Adapt The Teaching Implementation

### Requirements

- preserve existing class and include path;
- preserve public/protected API;
- keep teaching representation unless a change is necessary;
- replace duplicated workflow with an adapter call;
- retain teaching-specific behavior such as automatic shrink only in the teaching adapter;
- keep downstream subclasses compiling;
- run existing tests unchanged first.

### Exit Gate

The teaching implementation must pass its regression suite and expose no industrial storage details.

## Phase 6: Implement The Industrial Version

## Standard Alignment

When a corresponding standard container exists, use `std::*` semantics as the reference unless the user explicitly chooses a deviation.

Cover as applicable:

- default, value/count, range, initializer-list constructors;
- destructor;
- deep copy construction and assignment;
- move construction and assignment;
- allocator-aware construction and propagation;
- `begin/end`, const and reverse iterators;
- element access;
- capacity management;
- basic insertion and removal;
- comparison and `swap`;
- documented non-standard extensions.

## Ownership And Lifetime

Industrial containers must correctly support relevant combinations of:

- non-default-constructible values;
- move-only values;
- throwing copy/move construction;
- throwing assignment;
- stateful allocators;
- fancy allocator pointers when feasible;
- immediate destruction on erase/clear;
- moved-from valid empty state.

## Complexity

State and test material complexity properties:

- geometric growth for amortized O(1) append where applicable;
- O(n) front insertion in contiguous storage;
- logarithmic tree operations when balancing applies;
- expected/average hash-table behavior;
- traversal complexity and auxiliary space.

Do not implement automatic shrinking merely because the teaching version does so when the standard industrial behavior differs. Prefer explicit shrink APIs where appropriate.

## Exception Guarantees

Classify operations as:

- no-throw;
- strong guarantee;
- basic guarantee;
- behavior constrained by value type or allocator traits.

Use RAII or transaction-like temporary state for allocate/construct/commit sequences.

### Exit Gate

The industrial implementation must use the shared algorithm layer and must not copy the complete teaching workflow.

## Phase 7: Integrate With The Algorithm Ecosystem

Inspect existing repository algorithms rather than testing the new structure in isolation.

### Required Questions

- Can shared search/sequence algorithms consume its iterators?
- Can sort algorithms operate through random-access iterators?
- Do traversal algorithms accept const and non-const forms?
- Are old facades preserved?
- Does a generic algorithm accidentally require default construction or copying?
- Do return iterators compose with `erase`, `insert`, or range APIs?

### Integration Rule

Prefer adding a generic iterator-based overload or adapter rather than creating a second algorithm implementation for the industrial container.

### Exit Gate

At least one real repository algorithm family must be exercised against the new industrial implementation when applicable.

## Phase 8: Verification Matrix

Run the strongest feasible subset and report exactly what was executed.

### A. Regression

- unchanged teaching tests;
- downstream derived structures;
- existing demos or compile targets.

### B. Core Industrial Behavior

- construction and destruction;
- copy independence;
- move ownership transfer;
- element access and bounds checking;
- insertion, deletion, clear, resize, swap;
- iterator traversal;
- empty and single-element boundaries.

### C. Type Matrix

- primitive value;
- copyable class;
- move-only, non-default-constructible class;
- lifetime-counted class;
- throwing construction/assignment class;
- stateful allocator or ownership policy.

### D. Algorithm Integration

- search;
- sequence transformation;
- sorting/traversal;
- returned iterator followed by container mutation.

### E. Complexity And Allocation

- growth allocation count;
- no automatic shrink when not specified;
- no unexpected per-operation allocation;
- large or randomized operation sequence.

### F. Differential Testing

When a standard analogue exists, compare randomized operations and observable results against `std::vector`, `std::list`, `std::map`, or another suitable reference.

Do not compare repository-specific extensions as though they were standard APIs.

### G. Tooling

As available:

- repository CMake/CTest/GTest targets;
- multiple supported C++ standards;
- GCC and Clang;
- strict warnings with `-Werror`;
- AddressSanitizer;
- UndefinedBehaviorSanitizer;
- leak detection;
- CI when its trigger policy allows execution.

### Exit Gate

No final-success claim is allowed while material tests are failing or unexecuted without an explicit limitation.

## Phase 9: Readability And Delivery Pass

This phase is mandatory. Functional correctness is not the end of the lifecycle.

### File Layout

- class body contains declarations, types, and data members only;
- template implementations appear after the class definition in the same primary header by default;
- implementation sections follow responsibility order;
- avoid unnecessary `.inl` or many `Component*.h` files;
- keep shared algorithms and concrete container implementation in separate files;
- maintain one-way dependency direction.

### Comments

Verify every added or materially changed class/function has a useful Chinese comment.

### Naming

- use stable semantic names rather than teaching-storage names in shared contracts;
- keep public standard-style names when mirroring STL;
- preserve teaching names where compatibility requires them;
- do not introduce vague helpers such as `handle`, `process`, or `doWork`.

### PR And Commit Delivery

When publishing:

1. inspect the full base-to-head diff;
2. confirm commit ancestry and stacked PR dependencies;
3. preserve existing commits unless authorized otherwise;
4. use `github-pr-harvest` for the final PR title/body;
5. default to a draft PR;
6. report branch, base, commits, changed files, tests, and remaining boundaries;
7. never merge automatically.

If the branch contains an earlier algorithm-extraction PR plus a later industrial implementation commit, clearly state whether the later PR contains the earlier one and the correct merge/close order.

# Structure-Specific Extensions

## Contiguous Sequence Containers

Audit:

- raw storage versus constructed object range;
- geometric growth;
- gap opening/closing;
- iterator invalidation;
- aliasing when inserting an existing element;
- explicit versus automatic shrinking.

## Linked Containers

Audit:

- sentinel design;
- node allocator rebinding;
- link updates as atomic workflow;
- iterator stability;
- splice/merge ownership boundaries;
- exception cleanup before linking a node.

## Trees

Audit:

- node ownership and allocator rebinding;
- parent/child consistency;
- metadata updates;
- traversal and iterator correctness;
- clone rollback;
- subtree destruction;
- shared structural workflow versus balancing-specific policy;
- CRTP only when static extension is genuinely required.

## Hash Tables

Audit:

- bucket state model;
- probing or chaining workflow;
- rehash transaction and rollback;
- load-factor semantics;
- key/value construction;
- transparent lookup where in scope;
- iterator behavior during rehash.

## Graphs

Audit:

- vertex/edge ownership;
- adjacency representation;
- stable identifiers;
- traversal state kept outside the graph when possible;
- algorithm result ownership;
- directed/undirected invariants;
- duplicate-edge and removal semantics.

## Pure Algorithms

When no industrial container is needed:

- extract iterator-first or range-first implementation;
- preserve teaching facade overloads;
- state iterator-category requirements;
- test against multiple container/iterator types;
- verify complexity, stability, comparator behavior, and empty boundaries;
- avoid coupling the algorithm to one repository container.

# Anti-Patterns

Reject or revise the following designs.

## Duplicate Teaching And Industrial Algorithms

```text
TeachingVector::insert contains full shift workflow
IndustrialVector::insert contains another full shift workflow
```

Replace with one shared mutation workflow and two storage adapters when guarantees permit.

## Fake Generic Storage Layer

```text
algorithm requires dataPtr(), sizeRef(), capacityRef()
```

This merely exports private representation. Replace with semantic operations.

## Shared Layer Owns Allocator Semantics

A shared algorithm should sequence construction/destruction operations through a policy; it should not hard-code one allocator or memory model.

## Industrial Container Inherits Teaching Container

Avoid inheriting production storage and semantics from a teaching container merely to reuse code. Share algorithms, not incompatible representation.

## Over-Fragmented Headers

Do not create many implementation files just because methods are long. First use declaration-only class bodies plus ordered class-external implementations in one primary header.

## Tests Added Without Registration

A test file is not evidence if the build system does not compile or execute it. Inspect registration and run the exact target.

## Compatibility Claims Without Downstream Compilation

When protected fields or inheritance are involved, compile downstream structures before claiming compatibility.

## Standard-Like Naming Without Standard-Like Semantics

Do not name an API like `std::vector` while ignoring lifetime, iterator, allocator, exception, or complexity expectations. Document every intentional deviation.

# Progress Update Contract

For multi-step work, keep the user informed at meaningful gates:

1. after the current implementation and compatibility surface are understood;
2. after the shared-layer boundary is decided;
3. after teaching and industrial versions compile together;
4. after tests expose a defect or prove a major guarantee;
5. before publishing the final PR.

Updates should report concrete findings or decisions, not low-level tool activity.

# Final Report Contract

The final response must state:

- target repository and PR;
- base and head branch;
- whether commit history was preserved;
- final file/layer structure;
- what logic is shared;
- what remains teaching-specific;
- what remains industrial-specific;
- supported API and explicit non-goals;
- exact tests executed and results;
- CI status;
- merge order when PRs are stacked;
- remaining risks or unverified boundaries.

# Completion Checklist

A refactor is complete only when all applicable items are true:

- [ ] exact repository version and base branch resolved;
- [ ] teaching API and downstream dependencies audited;
- [ ] compatibility boundary documented;
- [ ] invariants and complexity targets recorded;
- [ ] generic algorithms are iterator/value based where possible;
- [ ] one component-specific shared workflow exists where needed;
- [ ] teaching implementation adapts to shared workflow;
- [ ] industrial implementation adapts to shared workflow;
- [ ] storage and object lifetime remain implementation-specific;
- [ ] industrial copy/move/destructor semantics are tested;
- [ ] move-only and non-default-constructible values are tested where relevant;
- [ ] throwing paths and rollback are tested where relevant;
- [ ] repository algorithms operate on the new implementation;
- [ ] existing teaching tests remain valid;
- [ ] downstream derived types compile;
- [ ] class declarations and implementations follow the repository readability rule;
- [ ] all changed classes/functions have Chinese comments;
- [ ] final full diff has been reviewed;
- [ ] test claims are evidence-backed;
- [ ] PR is draft unless the user requested otherwise;
- [ ] no automatic merge occurred.

If a checklist item is not applicable, explain why rather than silently skipping it.