# Cognitive Hotspot And Depth Allocation

## Purpose

Prevent both shallow uniform explanation and unbounded expansion.

A high-quality walkthrough spends explanation effort where misunderstanding is most likely or most costly.

## Hotspot Signals

Add one point for each applicable signal:

- modifies two or more related state variables;
- protects an invariant through a branch or early return;
- contains index, range, capacity, sequence, memory, time, or retry arithmetic;
- relies on ordering across calls;
- synchronizes a derived counter with another structure;
- changes ownership or lifecycle;
- crosses a trust, process, thread, coroutine, or protocol boundary;
- performs cleanup, rollback, cancellation, or terminal transition;
- has a misleading or overloaded name;
- contains compatibility or platform-specific logic;
- is targeted by several behavioral test families;
- appears in user questions, review comments, or historical confusion;
- failure can silently corrupt state rather than fail immediately;
- a simpler implementation passes happy-path tests but fails boundaries.

Add two additional points when failure consequences are severe:

- data loss or duplication;
- deadlock or race;
- security or privilege error;
- irreversible side effect;
- premature completion;
- resource leak;
- incorrect protocol state.

## Depth Levels

### L0: Orientation

Use for obvious declarations or trivial forwarding.

Include:

- one-sentence responsibility;
- important ownership or side effect only.

### L1: Local Behavior

Use for straightforward methods.

Include:

- focused code;
- input;
- output or side effect;
- one relevant state change.

### L2: State Transition

Use for meaningful branches or helpers.

Include:

- state before and after;
- branch meaning;
- invariant established;
- one concrete example;
- test family mapping.

### L3: Boundary And Counterexample

Use for central correctness logic.

Include:

- responsibility phases;
- exact ranges or timeline;
- multiple representative cases when branches differ materially;
- one counterexample showing why a simpler reading fails;
- oracle and negative oracle;
- likely fault location.

### L4: Independent Cognitive Unit

Use when the hotspot has substantial reusable behavior.

Either:

- give it a dedicated major section; or
- create/reuse a separate dependency walkthrough and retain a complete inline summary.

Examples:

- lock-free queue memory ordering;
- page-table walk;
- complex parser state machine;
- distributed retry and idempotency protocol.

## Default Thresholds

| Score | Depth |
|---:|---|
| 0–1 | L0 |
| 2–3 | L1 |
| 4–5 | L2 |
| 6–8 | L3 |
| 9+ | L4 consideration |

Use judgment when one severe correctness signal dominates.

## Mandatory Hotspot Questions

Every L2+ hotspot must answer:

1. What problem does this code solve?
2. What input or state reaches it?
3. What does it read?
4. What does it write?
5. What work is skipped by its branches?
6. What invariant is true afterward?
7. How can a caller or test observe the effect?

Every L3+ hotspot must additionally answer:

8. Why can the obvious simpler implementation fail?
9. What is the smallest counterexample?
10. Which test proves the behavior and which negative assertion prevents premature success?

## Case Selection

Use cases that partition behavior, not arbitrary examples.

Good partitions:

- left, inside, and right of a window;
- ordered, duplicate, gap, overlap, and completion;
- success, retryable failure, terminal failure, and cancellation;
- empty, singleton, typical, maximum, overflow, and invalid;
- lock acquired, contention, timeout, shutdown;
- base behavior, changed behavior, and compatibility path.

Do not produce many examples that exercise the same branch.

## Depth Stop Conditions

Stop expanding when:

- all distinct responsibility branches are represented;
- the invariant can be stated and checked;
- the golden trace and tests close the loop;
- additional examples only vary values;
- the detail belongs to an independent dependency;
- the evidence ceiling cannot support deeper claims.

## Anti-Patterns

- giving every method the same subsection length;
- explaining syntax instead of behavior;
- using a metaphor without mapping it to real state;
- adding diagrams because the template contains a diagram section;
- listing every edge case without grouping them by contract;
- treating performance folklore as evidence;
- hiding uncertainty under generic prose.
