# Golden Trace And Test Contract Map

## Purpose

Create one continuous cognitive spine from real input through source state to observable test evidence.

## Golden Trace Selection

Choose a scenario that:

- reaches the real target entrypoint;
- crosses several central responsibility phases;
- changes important state;
- includes at least one nontrivial branch;
- produces a caller-visible result;
- has a representative test or executable observation;
- uses real API names and values when available.

Prefer a trace that recombines the subject's main ideas.

Avoid:

- a trivial constructor-only example;
- pseudocode when real calls exist;
- an extreme edge case that obscures normal behavior;
- a scenario unsupported by tests or source.

## Trace Record

```yaml
initial_state:
events:
  - input:
    entrypoint:
    precondition:
    selected_branch:
    state_read:
    state_written:
    interaction:
    observable_effect:
final_state:
representative_test:
oracle:
negative_oracle:
```

## Trace Presentation

Present the trace early, before deep implementation.

Use the representation that matches the archetype:

- stateful component: state table or stepwise calls;
- algorithm: iteration table;
- cross-layer: call tree or sequence diagram;
- concurrent/async: timeline;
- PR change: before/after trace;
- failure-driven: symptom-to-divergence trace.

Every later major implementation section should identify which trace step it explains.

## Test Selection Path

Verify:

```text
test source
→ fixture or harness
→ built artifact
→ registered test name
→ aggregate target or runner
→ exact command or filter
```

Do not infer test membership from names alone.

## Test Classification

| Classification | Meaning |
|---|---|
| target-owned direct | directly drives the subject and asserts its behavior |
| integration/end-to-end | crosses ownership or runtime boundaries |
| inherited regression | verifies a dependency or prior stage |
| optional/strict/extra | outside the default required target |
| built but unselected | compiled but absent from the requested command |
| disabled/skipped | present but inactive |

## Behavioral Test Families

Group tests by contract, not by filename order.

For each important family record:

```markdown
### `<case>`：<behavioral contract>

**Initial state**

**Stimulus**

**Expected intermediate transition**

**Oracle**

**Negative oracle**

**Implementation responsibility**

**Failure usually points to**
```

A negative oracle prevents premature or excessive behavior, for example:

- no output yet;
- EOF is not visible;
- state remains unchanged;
- callback is invoked exactly once;
- no retry after terminal failure;
- no duplicate row;
- no lock held while invoking external code.

## Source-State-Test Matrix

Build this internally before drafting:

| Behavioral contract | Responsibility phase | State read/write | Observable path | Representative test | Likely fault |
|---|---|---|---|---|---|

Every central responsibility phase should have at least one observation or an explicit statement that it is currently untested.

Every central test family should map back to a responsibility phase.

## Mutation Question

For each L3+ hotspot, ask:

> If this branch, update, or ordering constraint were removed, which concrete test should fail and how?

This is a reasoning check, not a requirement to mutate the repository.

If no test would fail:

- mark the gap;
- do not claim the behavior is protected;
- recommend the smallest missing assertion when suggestions are in scope.

## Closure Conditions

The trace and test map are complete when:

- the trace starts at a real external or test stimulus;
- every event names the selected branch and state consequence;
- the final effect is publicly observable;
- the representative test's fixture and oracle are understood;
- the negative oracle rules out premature success;
- failures can be mapped back to source responsibility phases.
