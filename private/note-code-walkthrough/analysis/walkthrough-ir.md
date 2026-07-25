# Walkthrough Intermediate Representation

## Purpose

Build a stable semantic model before writing prose.

The IR prevents the final note from becoming a direct transformation of file order, diff order, or chat order.

## Core Schema

```yaml
subject:
  title:
  thesis:
  problem:
  responsibility:
  exclusions:
  archetype:

evidence:
  input_kind:
  level:
  repository:
  revision:
  source_paths:
  test_paths:
  build_entrypoints:
  runtime_commands:
  uncertainties:

end_to_end_slice:
  external_action:
  immediate_owner:
  target_entrypoint:
  core_helpers:
  output_consumer:
  public_observation:

interfaces:
  inputs:
  outputs:
  errors:
  callbacks:
  queries:

state:
  authoritative:
  derived:
  pending:
  terminal:
  external:
  ownership:
  lifecycle:

behavior:
  responsibility_phases:
  branches:
  early_returns:
  skipped_work:
  side_effects:
  cleanup:
  error_paths:
  ordering:
  concurrency:
  arithmetic_and_ranges:

invariants:
  source_defined:
  derived:
  lifecycle:
  test_enforced:

golden_trace:
  initial_state:
  events:
  branch_choices:
  state_transitions:
  interactions:
  observable_result:
  representative_test:

hotspots:
  - location:
    reason:
    score:
    depth:
    boundary_case:
    counterexample:
    test_mapping:

tests:
  selection_path:
  classifications:
  behavioral_families:
  oracles:
  negative_oracles:
  fault_mapping:

alternatives:
  historical:
  current_tradeoffs:
  suggestions:
```

## Field Rules

### Subject

The thesis must be one sentence that includes:

- what problem exists;
- what the subject owns;
- the central strategy;
- the most important boundary.

Bad:

> This note explains `FooManager`.

Good:

> `FooManager` turns unordered completion callbacks into one ordered result stream, while leaving retry and task execution to its callers.

### End-To-End Slice

Keep this thin. It exists to orient the reader, not to document the whole repository.

Every node must be verified or marked uncertain.

### State

Classify state by behavioral role, not by declaration order.

- **authoritative**: source of truth;
- **derived**: cached or counted from authoritative state;
- **pending**: waiting for a condition;
- **terminal**: completion, error, EOF, shutdown, or cancellation;
- **external**: owned by another component but read or affected here.

For every important field, record:

- who writes it;
- who reads it;
- what invariant relates it to other state;
- how tests can observe it.

### Responsibility Phases

Split long methods by semantic phase.

Each phase should answer:

```text
input and precondition
→ state read
→ decision
→ state written
→ side effect
→ skipped later work
→ invariant established
```

### Branches And Early Returns

Record not only the condition but also:

- why the branch exists;
- what later work is skipped;
- what state has already changed;
- what would break if it were removed or moved.

### Arithmetic And Ranges

Use exact notation for:

- indexes;
- sequence numbers;
- memory ranges;
- capacity windows;
- one-past-end boundaries;
- time windows;
- retry budgets;
- cursor positions.

Prefer half-open intervals unless the source explicitly uses another convention.

### Invariants

An invariant must be phrased as a checkable statement.

Weak:

> The queue stays valid.

Strong:

> Every pending interval starts after `first_missing`, and no two stored intervals overlap or touch.

Label whether an invariant is:

- explicit in source;
- derived from control flow;
- enforced by tests;
- assumed but unverified.

### Tests

A test family is not complete until the IR records:

- initial state;
- stimulus;
- intermediate expectation when relevant;
- oracle;
- negative oracle;
- responsibility phase;
- likely fault location.

## Completion Gate

The IR is ready for writing only when:

- the thesis and scope are stable;
- one end-to-end slice is known;
- important state has behavioral roles;
- central methods have responsibility phases;
- at least one golden trace is complete;
- hotspots are ranked;
- target-owned test families are mapped;
- uncertainties are explicit.

If the subject is stateless or a field is genuinely inapplicable, mark it not applicable rather than inventing state.
