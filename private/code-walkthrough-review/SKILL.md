---
name: code-walkthrough-review
description: Read-only, evidence-grounded code walkthrough and maintainability review workflow. Use when the user wants to understand a repository, branch, pull request, directory, microservice, feature path, request lifecycle, or pasted code fragment while discovering maintainability concerns one at a time instead of receiving a large review report.
---

# Code Walkthrough Review

## Scope

Use this skill to help a human understand code through a concrete business journey while maintaining an interactive queue of review concerns.

The workflow is designed for cases where:

- AI may have generated or modified more code than the user can immediately absorb;
- the user is unfamiliar with part of the language, standard library, framework, or repository;
- the user wants to read from an entrypoint through one complete business cycle;
- the user wants maintainability and design concerns identified without immediately changing code;
- the user prefers fast, single-point answers and does not want the assistant to lead the conversation into unrelated topics.

Default to read-only analysis. Do not modify product code, publish review comments, create Issues, resolve threads, or run builds and tests unless the user explicitly requests the corresponding action.

## Mandatory Triggers

Use this skill when the user asks to:

- 代码走读、源码走读、链路走读、业务走读；
- 从入口读到业务闭环；
- 走读某个微服务、目录、分支或功能；
- 先建立代码上下文，再边读边问；
- 根据可维护性规则扫描问题；
- 一次一个问题地审阅代码；
- 对粘贴的代码片段自动定位并解释其在当前链路中的作用；
- review a repository, branch, directory, service, feature path, lifecycle, or code fragment conversationally.

A repository URL, repository name, branch, PR URL, directory, symbol, entrypoint, user journey, or active walkthrough session may provide the target context.

## Goal

A successful walkthrough should let the user answer:

1. 这个模块为哪个业务目标服务；
2. 输入从哪里进入；
3. 主流程经过哪些阶段；
4. 核心状态和资源在哪里创建、修改和释放；
5. 对外副作用发生在哪里；
6. 失败、取消、重试和关闭如何传播；
7. 当前代码有哪些值得讨论的可维护性候选问题；
8. 哪些内容是确认问题、设计债务、学习问题或个人风格偏好。

The skill serves human comprehension first. It must not replace the walkthrough with a broad automated review report.

## Core Principles

1. **Use the user journey as the scope.** Start from a business event, request, message, command, scheduled task, or lifecycle entrypoint instead of scanning the repository without a purpose.
2. **Build a map, not an encyclopedia.** Read only enough code to reconstruct the current execution scene and its boundaries.
3. **Use the user's question as the cursor.** Answer the exact current question before considering anything adjacent.
4. **One concern at a time.** Report the number and severity distribution of candidate concerns, but expand only the current concern.
5. **Evidence before judgment.** Every finding requires a real path, symbol, code path, diff, or contract.
6. **Separate certainty levels.** Do not present a question, preference, or speculative design improvement as a confirmed defect.
7. **Identify change axes before patterns.** Never recommend a design pattern merely because one exists.
8. **Prefer understandable orchestration.** A composition root may coordinate several lifecycle stages without violating single responsibility when it clearly expresses one application lifecycle.
9. **Default to read-only.** Discussion, issue creation, PR comments, implementation, verification, and merging are separate actions.
10. **Do not proactively teach everything.** Explain language or library details when the user asks or when they are required to understand the current answer.

## Related Skill Routing

Reuse existing specialist skills instead of duplicating them.

- For a local repository or Codex environment that needs a durable source snapshot, use `../source-walk/SKILL.md` as the context reconstruction layer.
- For an existing GitHub pull request, use `../github-pr-dialogue-review/SKILL.md` for PR binding, head-SHA refresh, diff anchors, review threads, and publication rules. This skill remains responsible for walkthrough scope and maintainability gates.
- When the user accepts a concern and asks to turn it into an Issue, use `../github-issue-harvest/SKILL.md`.
- When the user asks to modify executable code, load `../code-comment-writing/SKILL.md` together with the applicable coding or repository workflow.
- When the user asks to archive the completed walkthrough into Obsidian, route through `../../ROUTER/SKILL.md` rather than generating a generic note directly.

Do not invoke implementation or publication workflows merely because a possible improvement was found.

# Operating Model

## Walkthrough Session

Bind one active session with at least:

```text
repository
mode
ref_type
ref
commit_or_head_sha
scope
entrypoint
user_journey
language_profile
current_anchor
context_status
candidate_count
current_issue_id
issue_ledger
read_only
```

Where:

- `mode` is normally `repository`, `branch`, `directory`, `microservice`, `pull_request`, or `fragment`;
- `scope` is the smallest module or path that can contain the requested journey;
- `entrypoint` may initially be unknown and discovered from repository evidence;
- `current_anchor` is the latest file, symbol, diff line, thread, or uniquely located pasted fragment;
- `context_status` is `unbound`, `building`, `ready`, or `stale`;
- `read_only` defaults to `true`.

A new chat cannot depend on hidden state from an old chat. Rebuild the session from repository evidence, the project instructions, an existing PR, or a previously exported context packet.

## State Machine

```text
bind target
  -> build context
  -> freeze current scope
  -> scan maintainability gates
  -> create candidate queue
  -> discuss one concern
  -> accept / reject / defer / request evidence / convert
  -> next concern or finish
```

If the branch, commit, PR head SHA, target directory, entrypoint, or user journey changes materially, mark the context as stale and refresh the affected map and queue before continuing.

# Input Resolution

## Supported Input Forms

### Pull Request

Minimum useful input:

```text
PR URL or repository + PR number
review goal or user journey
read-only or publication preference
```

Bind the PR and current head SHA, inspect the changed files, and fetch only the required surrounding callers, callees, interfaces, configuration, and tests.

### Repository, Branch, Directory, or Microservice

Minimum useful input:

```text
repository
ref when not default
scope or directory
entrypoint or user journey
```

If the user provides a clear business journey but not the entrypoint, locate the entrypoint from routing, command registration, server bootstrap, consumer registration, scheduled-job registration, or symbol search. Do not force the user to provide a path that repository inspection can resolve.

### Pasted Code Fragment

A pasted fragment should inherit the active session. The user should not need to manually supply path, line number, function name, and every referenced function.

Use this auto-anchor procedure:

1. Extract rare identifiers, function signatures, string literals, error messages, type names, and distinctive call sequences.
2. Search only the active repository, ref, and scope first.
3. Compare candidate matches against the current anchor and reconstructed flow.
4. Bind automatically when one match is sufficiently unique.
5. State the resolved location briefly, then answer the question.
6. If several locations remain and choosing one would materially change the answer, name the candidates and ask one focused location question.
7. Do not fabricate a location when the fragment cannot be resolved.

Do not require line numbers unless the user needs a durable citation or a precise PR comment target.

# Context Establishment Protocol

## Context Objective

Context building is complete when the assistant can answer the following from evidence:

1. What event starts the journey?
2. Where does the input enter?
3. What are the major processing stages?
4. Where are important state and resources created, mutated, transferred, and released?
5. What external side effects occur?
6. How do errors, cancellation, retries, and shutdown propagate?
7. What remains uncertain or outside the inspected scope?

Do not wait until every helper function is read. Do not claim to understand the whole repository when only one journey was inspected.

## Inspection Order

Prefer this order:

1. User journey or requirement.
2. Process entrypoint or framework registration.
3. Composition root and dependency construction.
4. Runtime loop, request handler, consumer callback, command handler, or scheduled task.
5. Domain processing stages.
6. External side effects and persistence.
7. Failure, cancellation, retry, cleanup, and shutdown paths.
8. Tests or contracts needed to confirm important behavior.

Inspect adjacent code only when it changes the interpretation of the current journey.

## Long-Running Services

Do not require a long-running server or consumer to have a normal business endpoint. Reconstruct at least two cycles when applicable.

### Process Lifecycle

```text
load configuration
-> create dependencies
-> start server or consumer
-> wait for cancellation or fatal error
-> stop accepting new work
-> drain or cancel in-flight work
-> release resources
-> exit
```

### Repeating Business Cycle

HTTP example:

```text
receive request
-> decode
-> validate
-> process domain behavior
-> perform external side effects
-> produce response
```

Message-consumer example:

```text
receive message
-> decode
-> validate
-> process
-> ACK / NACK / retry / DLQ
-> receive next message
```

The business cycle and the process lifecycle are separate review objects and must not be mixed into one vague flow.

## Context Output

When the context is first established, output a compact map and stop before scanning concerns unless the user explicitly asked to do both in one operation.

```markdown
## Walkthrough Context

- Repository: `<owner/repo>`
- Ref: `<branch, tag, commit, or PR head>`
- Commit: `<SHA or unknown>`
- Scope: `<module, directory, microservice, or changed files>`
- User journey: `<business cycle>`
- Mode: `read-only`

### Module Responsibility

<one concise statement>

### Process Lifecycle

`entry` -> `composition root` -> `runtime` -> `shutdown`

### Business Cycle

`input` -> `decode` -> `validate` -> `process` -> `side effect` -> `output`

### Key Boundaries

- <protocol boundary>
- <domain boundary>
- <storage or integration boundary>
- <lifecycle boundary>

### Key Files

| File | Symbol or role | Why it matters |
|---|---|---|
| `path` | `symbol` | ... |

### Uncertainties

- <unverified behavior>
- <runtime evidence still needed>
```

Finish with:

```text
上下文已建立，可以开始问题扫描。
```

Do not add unrelated design advice to the context map.

## Scope Freeze

After context establishment, freeze:

```text
repository + ref + commit/head SHA + scope + user journey
```

All candidate counts and conclusions apply only to this frozen scope. Say:

```text
在当前已确认范围内，初次扫描发现 N 个候选问题。
```

Never say that the entire repository has exactly `N` problems unless the entire repository was explicitly and adequately inspected.

# Maintainability Gates

## Gate Schema

Each gate is evaluated using:

```text
id
name
review question
trigger evidence
required evidence
exceptions
severity guidance
suggestion boundary
```

A concern must not enter the queue merely because a rule name sounds relevant. It must have evidence and survive the stated exceptions.

## G01: Mainline Readability

### Review Question

Can a reader follow the business stages from top to bottom without reconstructing the intent from low-level operations and temporary variables?

### Trigger Evidence

- the mainline is buried under protocol, parsing, collection, resource, or serialization details;
- several adjacent statements can be summarized by one meaningful business action but the current code provides no semantic boundary;
- understanding the mainline requires repeatedly tracking temporary variables across a large scope;
- success, failure, retry, and cleanup stages are interleaved without a visible structure.

### Required Evidence

Show the relevant function and identify the business stages that are hard to see.

### Exceptions

- a short local sequence whose extraction would only add navigation;
- code where the proposed helper name merely repeats the implementation;
- performance-sensitive code where indirection has a demonstrated cost;
- generated or protocol-mandated code.

### Suggestion Boundary

Suggest extraction only when a clear verb phrase expresses independent intent, isolates a change point, or makes the caller read like the business journey. Do not suggest one helper per few lines by default.

## G02: Single Responsibility

### Review Question

Does this unit have more than one independent reason to change?

### Trigger Evidence

- one function combines protocol adaptation, domain decisions, persistence, event publication, and response rendering;
- one object owns unrelated state with different lifecycles;
- changes from separate business policies repeatedly modify the same unit;
- a function both creates resources and performs unrelated business work while obscuring cleanup ownership.

### Required Evidence

List the distinct responsibilities and explain why they may change independently.

### Exceptions

- `main`, bootstrap, application runner, or composition-root functions that express one application lifecycle;
- a clear orchestration function whose responsibility is coordinating named stages;
- a transaction script that is intentionally small and cohesive.

### Suggestion Boundary

Recommend responsibility boundaries first. Do not automatically require interfaces, services, repositories, factories, or additional layers.

## G03: Naming and Semantic Compression

### Review Question

Do names remove reasoning work by expressing the business object, action, and important side effect or result?

### Trigger Evidence

- context-free names such as `data`, `info`, `result`, `item`, `obj`, `manager`, `common`, or `util` hide meaning;
- verbs such as `do`, `process`, or `handle` conceal the actual operation;
- a mutating, persistent, publishing, or destructive side effect is absent from the name and contract;
- identifiers are so long that they restate the implementation rather than naming the concept;
- the same concept has inconsistent names across one journey.

### Required Evidence

Explain what the reader must infer and propose the shortest name that carries the missing meaning.

### Exceptions

- very small scopes where a conventional short name is unambiguous;
- language conventions such as `i`, `err`, `ctx`, `r`, `w`, and receiver names;
- external protocol or generated names that must remain stable.

### Suggestion Boundary

Do not turn personal naming taste into a defect. Classify uncertain cases as `style_preference` or `suggestion`.

## G04: Mutation, Scope, Ownership, and Lifecycle

### Review Question

Can the reader tell who owns data and resources, who may mutate them, how long they live, and who closes or releases them?

### Trigger Evidence

- a function mutates a pointer, slice, map, referenced object, or shared state without a name or contract indicating mutation;
- a variable is visible for much longer than its useful lifetime;
- resources are created in one layer and implicitly released in another;
- channel close ownership, goroutine lifetime, lock ownership, or cancellation ownership is unclear;
- an object is assembled through scattered mutations with no visible invariant or terminal state;
- C or C++ pointer/reference constness, ownership, lifetime, or nullability is not expressed when the language can express it.

### Required Evidence

Identify the created or mutated state, its owner, and the visible or missing cleanup path.

### Exceptions

- builders, accumulators, decoders, scanners, state machines, and explicit mutation APIs;
- local mutation contained within a small and obvious scope;
- established language or repository conventions that make ownership unambiguous.

### Suggestion Boundary

Prefer clearer contracts, narrower scope, explicit mutation names, RAII, `defer`, or resource-owner objects before proposing a large abstraction.

## G05: Errors, Cancellation, Retry, and Cleanup

### Review Question

Can the reader determine what happens on every important failure, cancellation, retry, partial-initialization, and shutdown path?

### Trigger Evidence

- errors are swallowed, logged and ignored without a defined recovery contract, or returned without useful context;
- partial construction leaks a resource;
- cleanup errors overwrite or disappear behind the main error;
- cancellation does not propagate to blocking work;
- retry ownership or idempotency is unclear;
- shutdown stops one component while leaving dependent goroutines, requests, messages, or resources active;
- ACK, NACK, retry, and DLQ behavior cannot be determined.

### Required Evidence

Trace the specific failure path from trigger to final state.

### Exceptions

- explicitly best-effort telemetry or cleanup where failure is intentionally non-fatal and documented;
- top-level logging immediately before process exit;
- errors whose context is already stable and sufficient.

### Suggestion Boundary

Do not demand wrapping every error or handling impossible theoretical failures. Focus on behavior the caller or operator must understand.

## G06: Dependency and Side-Effect Boundaries

### Review Question

Are network, database, filesystem, message, time, randomness, global-state, and concurrency side effects visible at a useful boundary?

### Trigger Evidence

- a seemingly pure helper performs I/O or mutates global state;
- domain decisions are tightly coupled to a concrete external client;
- a function starts goroutines or publishes messages without exposing that lifecycle;
- testing the domain path requires unrelated infrastructure because side effects cannot be isolated;
- transaction and consistency boundaries are hidden across calls.

### Required Evidence

Identify the side effect, where it begins, and why the caller cannot currently see or control it.

### Exceptions

- small adapters whose entire role is the side effect;
- framework handlers where the protocol boundary is already explicit;
- direct code that remains clearer than an interface with no realistic replacement or test seam.

### Suggestion Boundary

Do not require every dependency to have an interface. Introduce a boundary only when it clarifies ownership, isolates domain logic, supports a real alternative, or enables valuable verification.

## G07: Change Axes and Extension Boundaries

### Review Question

What is expected to vary, why will it vary, and does the current structure force stable code to change for each variation?

### Required Questions

Before recommending any pattern, answer:

1. What exactly changes?
2. What should remain stable?
3. Is there already more than one implementation or credible near-term variation?
4. Which stable files or functions must currently be edited for each new variation?
5. What contract can remain smaller than the implementations?

### Pattern Guidance

- Use Strategy when several algorithms or policies vary behind the same business operation.
- Use Factory when selection and creation of concrete implementations vary and callers should not know constructors.
- Use Builder or Go functional options when construction has meaningful optional parameters, validation, ordering, invariants, or lifecycle assembly.
- Use Adapter when an external or legacy contract must be translated into the internal contract.
- Use Bridge only when the abstraction dimension and implementation dimension genuinely vary independently.
- Use Pipeline or Chain when independently understandable stages must be composed, reordered, enabled, or tested separately.
- Use an application or resource owner when several dependencies share one explicit startup and shutdown lifecycle.

### Exceptions

- speculative future requirements without evidence;
- one implementation and a stable direct constructor;
- a variation that can be handled clearly by a small conditional;
- abstractions that move complexity rather than containing it.

### Suggestion Boundary

Name the change axis before the pattern. Present the pattern as one possible response, not as proof of good design.

## G08: Abstraction Cost and Over-Design

### Review Question

Does the proposed or existing abstraction solve a demonstrated problem that justifies its extra navigation, types, indirection, and lifecycle complexity?

### Trigger Evidence

- an interface has one implementation and no valuable test or ownership boundary;
- a factory only wraps a single constructor without selection or policy;
- a builder has no optionality, ordering, validation, or invariant to protect;
- simple control flow is fragmented into many one-use functions whose names add no meaning;
- plugin, bridge, registry, middleware, or event systems exist for hypothetical variation only;
- readers must jump across many files to understand one straightforward operation.

### Required Evidence

State the concrete problem being solved, the cost of the abstraction, and the simpler alternative.

### Exceptions

- public API stability requirements;
- dependency inversion across a real architectural boundary;
- generated mocks or platform constraints;
- repository-wide conventions that materially reduce rather than increase cognitive load.

### Suggestion Boundary

Prefer the smallest complete design. Do not equate fewer types with better design or more patterns with better extensibility.

# Language Profiles

## Go Profile

Apply the universal gates together with these Go-specific checks:

- interfaces should normally be defined near the consumer and remain minimal;
- `context.Context` should normally be the first parameter and propagate cancellation or deadlines to blocking work;
- every goroutine should have a visible owner and exit condition;
- channel producer, consumer, buffering, and closing ownership should be clear;
- `defer` should execute in the intended scope and not accumulate unexpectedly in long loops;
- errors should retain useful operation context without noisy repeated wrapping;
- zero values and defaults should be intentionally usable or explicitly rejected;
- constructors should protect a real invariant rather than merely allocate a struct;
- use functional options or configuration structs more readily than a classic mutable Builder when that better matches Go conventions;
- composition roots may assemble configuration, dependencies, servers, workers, and shutdown without being treated as domain objects;
- `errors.Join`, `errors.Is`, and `errors.As` behavior should remain meaningful to callers;
- pointer, slice, and map mutation should be visible from names, comments, scope, or API shape;
- HTTP and message handlers should separate protocol adaptation from domain behavior when the boundary has practical value;
- shutdown should define whether in-flight HTTP requests, goroutines, queued messages, and external clients are drained, cancelled, or abandoned.

Do not reject idiomatic direct Go merely because it does not resemble object-oriented design-pattern examples.

## Other Languages

Use the universal gates first. Add language-specific checks only when supported by the repository, the language contract, or a dedicated profile. Do not mechanically apply Go, C++, Java, or Python conventions to another language.

# Candidate Queue Protocol

## Candidate Categories

Classify each candidate as exactly one primary category:

- `defect`: behavior, safety, correctness, leak, race, cancellation, or error-path problem;
- `maintainability`: current structure makes understanding or safe modification unnecessarily difficult;
- `design_debt`: a demonstrated change axis is constrained by the current design;
- `learning_question`: the user needs a language, library, framework, or repository mechanism explained;
- `style_preference`: a reasonable preference without sufficient objective impact.

Do not automatically put `learning_question` or `style_preference` into an implementation backlog.

## Evidence Levels

Classify each conclusion as:

- `confirmed`: directly shown by current code, contract, test, or runtime evidence;
- `likely`: strongly supported but dependent on an unseen caller, runtime condition, or requirement;
- `question`: an invariant, ownership rule, or design intent must be confirmed;
- `suggestion`: optional improvement rather than a defect.

The wording must reflect the evidence level.

## Priority

Use priority only for handling order:

- `high`: correctness, leak, race, shutdown, data loss, security, broken contract, or a blocker to understanding the current journey;
- `medium`: meaningful maintainability or extension cost on the inspected journey;
- `low`: local readability, naming, optional simplification, or a weakly evidenced future concern.

Do not inflate style preferences into high-priority findings.

## Initial Queue Output

After scanning the frozen scope, output only the count distribution and the first concern. Do not list every title unless the user asks to view the queue.

```markdown
本轮范围：<scope and journey>
代码版本：<ref and short SHA>

在当前已确认范围内，初次扫描发现 <N> 个候选问题：
- 高优先级：<n>
- 中优先级：<n>
- 低优先级：<n>

当前问题：W001
剩余问题：<n>
```

The initial count is not immutable. Deeper inspection may add, merge, downgrade, or remove candidates. Report material changes honestly.

## Concern ID and Ledger

Use stable IDs within one session:

```text
W001
W002
W003
```

Maintain a compact ledger:

```text
W001  path:line-line  G05  defect          high    accepted
W002  path:line-line  G02  maintainability medium  current
W003  PR-level        G07  design_debt     low     deferred
```

Supported statuses:

- `candidate`
- `current`
- `needs_evidence`
- `accepted`
- `rejected`
- `deferred`
- `converted`
- `fixed`
- `partially_fixed`
- `still_present`
- `outdated`
- `withdrawn`

Bind the ledger to the repository, ref, commit or PR head SHA, frozen scope, user journey, and scan version.

## Single Concern Output

Expand only the current concern:

```markdown
### W001：<concise concern title>

**位置**

`path/to/file.go:42-96`  
`SymbolName`

**分类**

`maintainability` · `medium` · `likely`

**触发门禁**

`G02 单一职责`  
`G06 副作用边界`

**现状**

<short execution evidence>

**为什么值得关注**

<impact on understanding, correctness, maintenance, or extension>

**例外检查**

<why a gate exception does or does not apply>

**当前不确定性**

<unknown invariant, caller, requirement, or runtime behavior; omit when none>

**建议方向**

<smallest design direction; do not produce a patch>

当前操作：`接受 / 驳回 / 延后 / 深挖 / 调整优先级 / 转 Issue / 下一条`
```

For a simple learning question, answer directly without forcing the full concern template unless it has entered the review queue.

## User Operations

Support natural-language commands:

- `接受`：record the concern as valid within the current evidence;
- `驳回`：record the user's reason when provided and do not silently re-add the same concern;
- `延后`：keep it in the ledger without continuing now;
- `深挖`：inspect the smallest additional evidence needed for the current concern;
- `需要证据`：mark `needs_evidence` and state what evidence is missing;
- `提高优先级` or `降低优先级`：change ordering without changing evidence level;
- `转 Issue`：route only the accepted concern to `github-issue-harvest`;
- `下一条`：advance to the next candidate without expanding other items;
- `查看队列`：show the compact ledger, not full details;
- `只解释`：answer without changing the ledger;
- `结束走读`：summarize accepted, rejected, deferred, unresolved, and learning items.

Do not demand a formal command. Infer these operations from ordinary language when clear.

# Per-Question Answer Policy

For every normal walkthrough question:

1. Resolve the current anchor from the active session, pasted fragment, symbol, or wording.
2. Inspect only the smallest sufficient repository evidence.
3. Give the conclusion first.
4. Explain the relevant control flow, data flow, ownership, or language mechanism.
5. Stop after answering the asked point.
6. Do not append unsolicited adjacent concerns, learning routes, refactor suggestions, or follow-up questions.
7. Add or update a queue concern only when the user's question exposes evidence relevant to a gate.

Default response shape:

```markdown
**结论：** <direct answer>

<only the explanation required for this question>
```

When a fragment was auto-located, optionally prefix:

```text
已定位：`path/to/file.go` · `FunctionName`
```

When the user is unfamiliar with the technology, explain business meaning before syntax or library detail. Do not turn one syntax question into a general language lesson.

# Design-Pattern Recommendation Protocol

A design-pattern recommendation is permitted only when all of the following are present:

1. a concrete current or credible near-term change axis;
2. a stable responsibility that should not change with that axis;
3. evidence that the current structure causes repeated modification, coupling, lifecycle confusion, or unsafe extension;
4. a comparison with a simpler alternative;
5. an explanation of the new abstraction cost.

Use this template internally:

```text
change axis:
stable responsibility:
current extension cost:
simpler option:
pattern option:
new abstraction cost:
why justified now:
```

Do not recommend Abstract Factory, Builder, Bridge, Strategy, Adapter, Pipeline, or another pattern solely from object count or theoretical openness.

# Read-Only and Write Boundaries

## Default Read-Only Behavior

Without explicit authorization, do not:

- modify source code;
- create branches or commits in the target repository;
- publish PR review comments;
- resolve or reopen threads;
- create Issues;
- run builds, tests, migrations, formatters, benchmarks, or deployment commands;
- claim a concern is fixed from an author explanation alone.

## Transition to Implementation

When the user explicitly asks to fix accepted concerns:

1. freeze the selected concern IDs and scope;
2. load the applicable coding workflow and `code-comment-writing`;
3. inspect target-repository `AGENTS.md`, `CONTRIBUTING.md`, and existing style before coding;
4. preserve current behavior unless the accepted concern requires behavior change;
5. verify using repository-supported commands;
6. report which concern IDs were addressed and which remain.

Do not silently implement every queued candidate.

# Refresh and Recheck

When the branch or PR changes:

1. fetch the new commit or head SHA;
2. refresh only the affected context paths;
3. remap ledger items to current code;
4. classify each as `fixed`, `partially_fixed`, `still_present`, `outdated`, or `unable to verify`;
5. do not treat textual promises as code changes;
6. preserve rejected and withdrawn items unless new evidence materially changes them.

If a pasted fragment no longer matches the bound ref, state that the session may be stale.

# Failure Handling

- If repository access fails, answer only from user-provided code and clearly mark missing repository evidence.
- If the entrypoint cannot be uniquely identified, show the smallest set of plausible entrypoints and explain the distinguishing event.
- If a lifecycle crosses repositories or external systems, stop at the verified boundary and name the missing system.
- If runtime behavior is required, mark the concern `needs_evidence`; do not invent test or production observations.
- If the scope is too broad, choose the smallest business cycle implied by the user's request rather than scanning everything.
- If no maintainability concern survives evidence and exceptions, say so. Do not manufacture queue items.

# Completion Output

When the user ends the walkthrough, summarize compactly:

```markdown
## Walkthrough Summary

- Repository / ref / SHA:
- Scope and user journey:
- Context status:
- Accepted concerns:
- Rejected concerns:
- Deferred or evidence-needed concerns:
- Learning questions answered:
- Converted Issues or review threads:
- Remaining uncertainty:
```

Do not turn the summary into an implementation plan unless requested.

# Minimal Success Criteria

A successful first pass must:

1. bind a real repository target or explicitly state that only pasted code is available;
2. establish a scoped process lifecycle and business cycle when applicable;
3. cite real files, symbols, lines, or PR evidence for important claims;
4. identify ownership, side effects, failure, and shutdown boundaries relevant to the journey;
5. freeze scope before reporting candidate counts;
6. evaluate candidates against gate evidence and exceptions;
7. expand only one concern at a time;
8. answer user questions directly without unsolicited expansion;
9. auto-locate pasted fragments when repository evidence allows it;
10. remain read-only unless the user explicitly changes the mode;
11. distinguish defects, maintainability, design debt, learning questions, and style preferences;
12. avoid design-pattern recommendations without a demonstrated change axis.

# Example Sessions

## Microservice Walkthrough

User:

```text
走读 xdlp-platform 的 Audit Receiver。先从入口建立上下文，目标是理解一条 HTTP 审计事件从接收到落库的闭环。只读不改，然后按门禁一个问题一个问题地看。
```

Expected behavior:

- bind repository and ref;
- locate process and HTTP entrypoints;
- reconstruct process lifecycle and one request cycle;
- output the compact context map and stop;
- after the user starts scanning, report candidate counts and expand only `W001`.

## Pull Request Walkthrough

User:

```text
走读这个 PR 的新增 Receiver 链路。先只解释，不发评论。
```

Expected behavior:

- route PR binding and diff state through `github-pr-dialogue-review`;
- retain `read_only` and explain-only publication mode;
- use this skill's context and gate protocols;
- never post comments unless the user later authorizes publication.

## Pasted Fragment

User pastes `runAuthenticated` without a path and asks where it sits in the lifecycle.

Expected behavior:

- search the active repository and scope using the function name and distinctive calls;
- bind the matching file and symbol;
- explain that it is the process-level orchestration path rather than the per-request business handler;
- do not require the user to copy the path, lines, and every callee.

## Design Pattern Question

User asks whether message-queue construction should use Abstract Factory, Builder, or Bridge.

Expected behavior:

- identify whether creation policy, staged construction, external API adaptation, or independently varying abstraction and implementation is the real change axis;
- compare the smallest direct design with the relevant pattern;
- avoid selecting a pattern before repository evidence and requirements establish the variation.

# Boundary

This skill establishes code context, explains the current journey, evaluates maintainability gates, and manages an interactive concern queue.

It does not itself:

- edit product code;
- produce a giant autonomous repository review by default;
- publish PR comments without authorization;
- create Issues without an explicit request;
- archive Obsidian notes directly;
- invent code, paths, lines, runtime observations, or design requirements;
- guarantee that an uninspected repository has no other problems.
