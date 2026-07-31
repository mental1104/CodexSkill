# Maintainability Gates

Read this reference when `code-walkthrough-review` is asked to scan, assess, prioritize, or discuss maintainability and design concerns.

Do not load or apply the full gate set for a simple syntax or single-point explanation unless the answer reveals a concrete concern that should enter the queue.

# Gate Evaluation Contract

Evaluate every gate with:

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

A concern must not enter the queue merely because a rule name sounds relevant. It must have repository evidence and survive the stated exceptions.

# G01: Mainline Readability

## Review Question

Can a reader follow the business stages from top to bottom without reconstructing intent from low-level operations and temporary variables?

## Trigger Evidence

- the mainline is buried under protocol, parsing, collection, resource, or serialization details;
- several adjacent statements can be summarized by one meaningful business action but the code provides no semantic boundary;
- understanding the mainline requires repeatedly tracking temporary variables across a large scope;
- success, failure, retry, and cleanup stages are interleaved without a visible structure.

## Required Evidence

Show the relevant function and identify the business stages that are hard to see.

## Exceptions

- a short local sequence whose extraction would only add navigation;
- code where the proposed helper name merely repeats the implementation;
- performance-sensitive code where indirection has a demonstrated cost;
- generated or protocol-mandated code.

## Severity Guidance

- `high` only when the hidden mainline creates correctness, lifecycle, or operational risk;
- normally `medium` when important business stages are difficult to distinguish;
- `low` for a small local readability cost.

## Suggestion Boundary

Suggest extraction only when a clear verb phrase expresses independent intent, isolates a change point, or makes the caller read like the business journey. Do not suggest one helper per few lines by default.

# G02: Single Responsibility

## Review Question

Does this unit have more than one independent reason to change?

## Trigger Evidence

- one function combines protocol adaptation, domain decisions, persistence, event publication, and response rendering;
- one object owns unrelated state with different lifecycles;
- changes from separate business policies repeatedly modify the same unit;
- a function both creates resources and performs unrelated business work while obscuring cleanup ownership.

## Required Evidence

List the distinct responsibilities and explain why they may change independently.

Do not use line count alone as evidence.

## Exceptions

- `main`, bootstrap, application runner, or composition-root functions that express one application lifecycle;
- a clear orchestration function whose responsibility is coordinating named stages;
- a small cohesive transaction script.

For example, a function that loads runtime configuration, creates an application, starts a server, waits for cancellation, and coordinates shutdown may still have one responsibility: running the application lifecycle.

## Severity Guidance

- `high` when mixed responsibility hides unsafe cleanup, transactions, concurrency, or failure behavior;
- normally `medium` for meaningful independent change pressure;
- `low` when the split is mostly a readability preference.

## Suggestion Boundary

Recommend responsibility boundaries first. Do not automatically require interfaces, services, repositories, factories, or additional layers.

# G03: Naming and Semantic Compression

## Review Question

Do names remove reasoning work by expressing the business object, action, and important side effect or result?

## Trigger Evidence

- context-free names such as `data`, `info`, `result`, `item`, `obj`, `manager`, `common`, or `util` hide meaning;
- verbs such as `do`, `process`, or `handle` conceal the actual operation;
- a mutating, persistent, publishing, or destructive side effect is absent from the name and contract;
- identifiers are so long that they restate the implementation rather than naming the concept;
- the same concept has inconsistent names across one journey.

## Required Evidence

Explain what the reader must infer and propose the shortest name that carries the missing meaning.

## Exceptions

- very small scopes where a conventional short name is unambiguous;
- language conventions such as `i`, `err`, `ctx`, `r`, `w`, and receiver names;
- external protocol or generated names that must remain stable.

## Severity Guidance

Naming is normally `low`. Raise it only when a misleading name hides mutation, destruction, security-sensitive behavior, ownership, or a broken contract.

## Suggestion Boundary

Do not turn personal naming taste into a defect. Classify uncertain cases as `style_preference` or `suggestion`.

# G04: Mutation, Scope, Ownership, and Lifecycle

## Review Question

Can the reader tell who owns data and resources, who may mutate them, how long they live, and who closes or releases them?

## Trigger Evidence

- a function mutates a pointer, slice, map, referenced object, or shared state without a name or contract indicating mutation;
- a variable is visible for much longer than its useful lifetime;
- resources are created in one layer and implicitly released in another;
- channel close ownership, goroutine lifetime, lock ownership, or cancellation ownership is unclear;
- an object is assembled through scattered mutations with no visible invariant or terminal state;
- C or C++ pointer/reference constness, ownership, lifetime, or nullability is not expressed when the language can express it.

## Required Evidence

Identify the created or mutated state, its owner, and the visible or missing cleanup path.

## Exceptions

- builders, accumulators, decoders, scanners, state machines, and explicit mutation APIs;
- local mutation contained within a small and obvious scope;
- established language or repository conventions that make ownership unambiguous.

## Severity Guidance

- `high` for leaks, races, use-after-free, double close, orphaned goroutines, unsafe shared mutation, or broken cancellation;
- `medium` for lifecycle ambiguity that makes safe modification difficult;
- `low` for local scope reduction or a clearer mutation name.

## Suggestion Boundary

Prefer clearer contracts, narrower scope, explicit mutation names, RAII, `defer`, or resource-owner objects before proposing a large abstraction.

# G05: Errors, Cancellation, Retry, and Cleanup

## Review Question

Can the reader determine what happens on every important failure, cancellation, retry, partial-initialization, and shutdown path?

## Trigger Evidence

- errors are swallowed, logged and ignored without a defined recovery contract, or returned without useful context;
- partial construction leaks a resource;
- cleanup errors overwrite or disappear behind the main error;
- cancellation does not propagate to blocking work;
- retry ownership or idempotency is unclear;
- shutdown stops one component while leaving dependent goroutines, requests, messages, or resources active;
- ACK, NACK, retry, and DLQ behavior cannot be determined.

## Required Evidence

Trace the specific failure path from trigger to final state.

## Exceptions

- explicitly best-effort telemetry or cleanup where failure is intentionally non-fatal and documented;
- top-level logging immediately before process exit;
- errors whose context is already stable and sufficient.

## Severity Guidance

- normally `high` for demonstrated data loss, leaks, retry storms, cancellation failure, or shutdown failure;
- `medium` for missing operational context or incomplete but non-destructive handling;
- `low` for optional error-message improvement.

## Suggestion Boundary

Do not demand wrapping every error or handling impossible theoretical failures. Focus on behavior the caller or operator must understand.

# G06: Dependency and Side-Effect Boundaries

## Review Question

Are network, database, filesystem, message, time, randomness, global-state, and concurrency side effects visible at a useful boundary?

## Trigger Evidence

- a seemingly pure helper performs I/O or mutates global state;
- domain decisions are tightly coupled to a concrete external client;
- a function starts goroutines or publishes messages without exposing that lifecycle;
- testing the domain path requires unrelated infrastructure because side effects cannot be isolated;
- transaction and consistency boundaries are hidden across calls.

## Required Evidence

Identify the side effect, where it begins, and why the caller cannot currently see or control it.

## Exceptions

- small adapters whose entire role is the side effect;
- framework handlers where the protocol boundary is already explicit;
- direct code that remains clearer than an interface with no realistic replacement or test seam.

## Severity Guidance

- `high` when a hidden side effect violates correctness, consistency, safety, or lifecycle ownership;
- `medium` when it materially blocks testing or safe changes;
- `low` when the issue is only naming or local organization.

## Suggestion Boundary

Do not require every dependency to have an interface. Introduce a boundary only when it clarifies ownership, isolates domain logic, supports a real alternative, or enables valuable verification.

# G07: Change Axes and Extension Boundaries

## Review Question

What is expected to vary, why will it vary, and does the current structure force stable code to change for each variation?

## Required Questions

Before recommending any pattern, answer:

1. What exactly changes?
2. What should remain stable?
3. Is there already more than one implementation or credible near-term variation?
4. Which stable files or functions must currently be edited for each new variation?
5. What contract can remain smaller than the implementations?

## Trigger Evidence

- each new implementation requires editing a central conditional, switch, registry, or constructor chain;
- protocol, storage, algorithm, provider, or policy changes repeatedly modify stable business code;
- several dimensions vary independently and produce combinatorial branching;
- lifecycle assembly is duplicated and diverging;
- adding a supported type requires invasive edits across unrelated files.

## Exceptions

- speculative future requirements without evidence;
- one implementation and a stable direct constructor;
- a variation that can be handled clearly by a small conditional;
- abstractions that move complexity rather than containing it.

## Severity Guidance

- `high` only when the current extension path already causes correctness, compatibility, or high-risk modification pressure;
- normally `medium` for demonstrated repeated extension cost;
- `low` for a credible but not yet costly change axis.

## Suggestion Boundary

Name the change axis before the pattern. Present the pattern as one possible response, not as proof of good design.

# G08: Abstraction Cost and Over-Design

## Review Question

Does the proposed or existing abstraction solve a demonstrated problem that justifies its extra navigation, types, indirection, and lifecycle complexity?

## Trigger Evidence

- an interface has one implementation and no valuable test or ownership boundary;
- a factory only wraps a single constructor without selection or policy;
- a builder has no optionality, ordering, validation, or invariant to protect;
- simple control flow is fragmented into many one-use functions whose names add no meaning;
- plugin, bridge, registry, middleware, or event systems exist for hypothetical variation only;
- readers must jump across many files to understand one straightforward operation.

## Required Evidence

State the concrete problem being solved, the cost of the abstraction, and the simpler alternative.

## Exceptions

- public API stability requirements;
- dependency inversion across a real architectural boundary;
- generated mocks or platform constraints;
- repository-wide conventions that materially reduce rather than increase cognitive load.

## Severity Guidance

Over-design is normally `low` or `medium`. It is `high` only when abstraction directly creates unsafe lifecycle behavior, correctness risk, or blocks urgent changes.

## Suggestion Boundary

Prefer the smallest complete design. Do not equate fewer types with better design or more patterns with better extensibility.

# Function Extraction Decision

Recommend extracting a block into a function when at least one applies:

1. it has a clear verb-phrase intent that is more informative than the operations;
2. it represents one business stage in the caller's journey;
3. it isolates a failure, cleanup, ownership, transaction, or concurrency boundary;
4. it contains an independently testable rule;
5. it is duplicated or expected to vary independently;
6. extraction meaningfully narrows local variable scope.

Treat extraction as likely over-fragmentation when most apply:

- the helper has one use and adds no semantic meaning;
- the reader must immediately jump into the helper to understand the caller;
- parameters expose nearly every local variable;
- the helper exists only to reduce line count;
- it separates operations that must be understood atomically;
- it obscures a performance-sensitive or stateful sequence.

Do not use fixed line thresholds as a rule.

# Design-Pattern Recommendation Protocol

A design-pattern recommendation is permitted only when all are present:

1. a concrete current or credible near-term change axis;
2. a stable responsibility that should not change with that axis;
3. evidence that the current structure causes repeated modification, coupling, lifecycle confusion, or unsafe extension;
4. a comparison with a simpler alternative;
5. an explanation of the new abstraction cost.

Use this analysis shape:

```text
change axis:
stable responsibility:
current extension cost:
simpler option:
pattern option:
new abstraction cost:
why justified now:
```

## Pattern Guidance

### Strategy

Use when several algorithms or business policies vary behind the same operation and callers should remain stable.

Do not use merely to replace one short conditional.

### Factory

Use when concrete-type selection and creation policy vary and callers should not know individual constructors.

Do not wrap one stable `NewXxx` only to call it a factory.

### Abstract Factory

Use when callers need compatible families of related objects and the family varies as one unit.

Do not use for a single product type or unrelated constructors.

### Builder or Go Functional Options

Use when construction has meaningful optional parameters, validation, ordering, invariants, staged resource assembly, or a finalization step.

For Go, prefer a configuration struct or functional options when mutable staged construction adds no value.

### Adapter

Use when an external or legacy contract must be translated into the internal contract.

### Bridge

Use only when an abstraction dimension and implementation dimension genuinely vary independently and need free composition.

A generic interface with several implementations is not automatically Bridge.

### Pipeline or Chain

Use when independently understandable stages need composition, ordering, optional enablement, replacement, or isolated tests.

Do not hide one fixed linear function behind a generic framework without a demonstrated need.

### Application or Resource Owner

Use when several dependencies share one explicit startup, runtime, cancellation, and shutdown lifecycle.

This often provides more value than applying a creation pattern to each resource independently.

# Go Profile

Apply the universal gates with these Go-specific checks:

- interfaces should normally be defined near the consumer and remain minimal;
- `context.Context` should normally be the first parameter and propagate cancellation or deadlines to blocking work;
- every goroutine should have a visible owner and exit condition;
- channel producer, consumer, buffering, and closing ownership should be clear;
- `defer` should execute in the intended scope and not accumulate unexpectedly in long loops;
- errors should retain useful operation context without noisy repeated wrapping;
- `errors.Join`, `errors.Is`, and `errors.As` behavior should remain meaningful to callers;
- zero values and defaults should be intentionally usable or explicitly rejected;
- constructors should protect a real invariant rather than merely allocate a struct;
- use functional options or configuration structs more readily than a classic mutable Builder when that better matches Go conventions;
- composition roots may assemble configuration, dependencies, servers, workers, and shutdown without being treated as domain objects;
- pointer, slice, and map mutation should be visible from names, comments, scope, or API shape;
- HTTP and message handlers should separate protocol adaptation from domain behavior when the boundary has practical value;
- shutdown should define whether in-flight HTTP requests, goroutines, queued messages, and external clients are drained, cancelled, or abandoned;
- ownership of closing `io.Closer`, channels, and clients should be explicit;
- avoid package names such as `util`, `common`, and `manager` when a narrower domain role exists;
- avoid rejecting idiomatic direct Go merely because it does not resemble object-oriented design-pattern examples.

# Concern Output Contract

Every gate-based concern should contain:

```text
location
primary category
priority
evidence level
gate IDs
current behavior
impact
exception check
uncertainty
smallest suggestion direction
```

Do not provide a patch during the read-only walkthrough.

# False-Positive Control

Before queuing a concern, check:

1. Is the behavior already explicit through a nearby contract, test, type, or repository convention?
2. Is the reviewed function a composition root or intentional orchestration layer?
3. Would the suggestion only move code without reducing reasoning or change cost?
4. Is the proposed variation real, or merely imagined?
5. Does the pattern add more concepts than the current problem warrants?
6. Is the issue actually a learning question or style preference?
7. Does runtime evidence or an unseen caller remain necessary?

When uncertain, downgrade to `question`, `suggestion`, `learning_question`, or `style_preference` rather than claiming a defect.
