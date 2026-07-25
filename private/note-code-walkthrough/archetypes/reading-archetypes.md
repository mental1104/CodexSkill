# Reading Archetypes

## Purpose

Choose the cognitive topology that best matches the implementation subject.

The CS144 Reassembler sequence is a strong stateful-component pattern, not a universal chapter template.

Choose exactly one primary archetype.

## 1. Stateful Component

Use for:

- protocol state;
- caches;
- schedulers;
- parsers with retained context;
- senders, receivers, assemblers;
- resource managers;
- controllers.

Primary reading sequence:

```text
problem
→ state roles and invariants
→ golden state-evolution trace
→ responsibility phases
→ boundary and terminal behavior
→ tests as state contracts
```

Required dimensions:

- authoritative and derived state;
- pending and terminal state;
- state transitions;
- early returns;
- invariant preservation;
- public observation path.

## 2. Pure Algorithm Or Data Structure

Use for:

- sorting, graph, indexing, compression, matching, parsing, numerical, and container algorithms;
- a data structure whose central value is its algorithmic invariant rather than repository integration.

Primary reading sequence:

```text
input model
→ invariant
→ one complete iteration trace
→ core operations
→ correctness argument
→ complexity and representation tradeoff
→ adversarial tests
```

Required dimensions:

- input and output model;
- loop or structural invariant;
- representative and adversarial examples;
- termination;
- correctness;
- time and space complexity;
- numeric, overflow, or mutation boundaries.

Do not force lifecycle or application call chains when they add no understanding.

## 3. Cross-Layer Call Chain

Use for:

- system calls;
- RPC;
- request-to-storage paths;
- protocol stack transitions;
- generated stubs;
- CLI-to-kernel or UI-to-service flows.

Primary reading sequence:

```text
user action
→ boundary crossing
→ representation conversion
→ ownership and validation
→ core handling
→ return or response path
→ integration tests
```

Required dimensions:

- each boundary and data representation;
- caller/callee contract;
- ownership transfer;
- error translation;
- privilege or trust changes;
- return path.

Avoid expanding every layer internally. Explain only what the current behavior needs.

## 4. Concurrent Or Asynchronous Mechanism

Use for:

- workers;
- event loops;
- callbacks;
- queues;
- futures;
- thread pools;
- cancellation and timeout flows;
- distributed task orchestration.

Primary reading sequence:

```text
execution entities
→ scheduling and ownership
→ one timeline trace
→ shared state and synchronization
→ completion, cancellation, timeout
→ races and failure propagation
→ deterministic tests or probes
```

Required dimensions:

- execution context;
- happens-before or ordering;
- shared and thread-local state;
- lock or queue ownership;
- callback cardinality;
- cancellation and shutdown;
- timeout and retry interaction;
- nondeterminism in tests.

A normal flowchart is insufficient when time ordering is the hard part; prefer a sequence or timeline.

## 5. PR Or Feature Change

Use when the durable asset is understanding one behavior change between revisions.

Primary reading sequence:

```text
original requirement or gap
→ behavior before
→ changed contract
→ implementation delta by responsibility
→ compatibility and migration
→ regression tests
→ resulting behavior
```

Required dimensions:

- base and head;
- pre-existing behavior;
- changed behavior;
- unchanged dependencies that explain the diff;
- added, changed, and missing tests;
- compatibility and rollout boundary.

Do not present all changed files as equally important.

## 6. Failure-Driven Execution Path

Use when a concrete incident, exception, failed test, or wrong output is the entrypoint and the durable asset is the source-level mechanism behind it.

Primary reading sequence:

```text
observable symptom
→ triggering input
→ actual execution path
→ divergence from intended invariant
→ root cause
→ corrected or guarded path
→ regression test
```

Required dimensions:

- observed evidence;
- failing frame or branch;
- intended invariant;
- causal state transition;
- why adjacent hypotheses are rejected;
- fix boundary;
- regression oracle.

Do not turn this into a chronological debugging diary unless chronology itself is the desired artifact.

## Tie-Breaking Rules

1. Choose stateful component when retained state and transitions are the main difficulty.
2. Choose pure algorithm when correctness and complexity dominate.
3. Choose cross-layer when representation and ownership change across boundaries.
4. Choose concurrent/async when scheduling and ordering dominate.
5. Choose PR/feature change when before-versus-after behavior is the durable question.
6. Choose failure-driven when the symptom-to-root-cause path is the durable question.
7. When two archetypes are close, select the one that determines the chapter order; borrow only the necessary secondary section.

## Archetype Failure Signs

The chosen archetype is wrong when:

- major sections feel inapplicable;
- the note spends more time explaining dependencies than the subject;
- the golden trace cannot follow the archetype's mainline;
- tests cannot be grouped by the claimed responsibility;
- the hardest reader question is postponed until late in the note.
