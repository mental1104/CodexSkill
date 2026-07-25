# Quality Gate

## Purpose

Reject drafts that contain all expected sections but still fail to teach the implementation.

A checklist prevents omissions. This gate evaluates quality.

## Fatal Defects

Any fatal defect makes the note incomplete regardless of score:

- invented source behavior, caller, test membership, command result, or revision;
- no explicit source or evidence boundary;
- no concrete input or execution example;
- central state change cannot be traced;
- tests are only names or pass counts without oracle;
- current behavior is mixed with historical evidence or suggestions;
- the note is primarily a file inventory or line-by-line translation;
- the hardest correctness logic receives only L0/L1 treatment;
- the main explanation depends on opening optional links;
- a diagram or code excerpt contradicts the inspected source.

Fatal defects must be repaired before delivery.

## Scored Rubric

### 1. Evidence And Version Boundary — 15

- exact repository and revision;
- source, test, build, runtime, historical, and suggestion claims separated;
- uncertainties explicit;
- no unsupported upgrade of evidence.

### 2. Subject Thesis And Scope — 10

- one concrete subject;
- problem, responsibility, strategy, and boundary stated;
- exclusions prevent repository-tour drift.

### 3. Mental Model Accuracy — 10

- plain-language model is compact;
- maps to real state, ownership, or invariant;
- avoids misleading simplification.

### 4. Golden Trace Coherence — 15

- starts from a real stimulus;
- uses concrete names and values;
- crosses central phases;
- records state transitions;
- ends at a public observation;
- later sections reconnect to it.

### 5. Hotspot Explanation Depth — 20

- hotspots identified rather than all symbols treated equally;
- exact boundaries or timelines shown;
- counterexamples explain necessity;
- invariants are checkable;
- depth matches consequence.

### 6. Source-State-Test Closure — 15

- responsibility phases identify state read/write;
- tests use setup, stimulus, oracle, and negative oracle;
- test failures map to implementation;
- untested central behavior is marked.

### 7. Narrative And Representation — 10

- problem-first order;
- correct archetype;
- one representation per fact;
- code near explanation;
- no decorative diagrams or repeated prose.

### 8. Durability And Vault Integration — 5

- repository-relative paths or immutable links;
- valid headings and deep links;
- frontmatter checked;
- original learning value preserved in transform-mode.

## Passing Threshold

- minimum score: 85/100;
- fatal defects: 0;
- Golden Trace Coherence: at least 12/15;
- Hotspot Explanation Depth: at least 16/20;
- Source-State-Test Closure: at least 12/15.

A high total cannot compensate for a broken central loop.

## Repair Loop

After the first draft:

1. score every dimension;
2. list the three weakest dimensions;
3. identify the exact section causing each weakness;
4. repair only those sections;
5. rescore;
6. repeat until the threshold and sub-thresholds pass.

Do not rewrite the entire note merely to change style.

## Adversarial Review Questions

Before delivery ask:

- Could the same prose describe a different implementation?
- Which statement would become false if one key branch were removed?
- Can the reader simulate the golden trace without reopening the repository?
- Does each central test prove a distinct contract?
- Is there a negative assertion preventing premature success?
- Did the note explain the hardest code more deeply than trivial accessors?
- Are performance claims measured, historical, inferred, or suggested?
- Would a reader know where to inspect when one representative test fails?
- Does any optional link carry information required for the mainline?
- Did transform-mode preserve the author's actual learning questions?

## Delivery Record

Record internally:

```yaml
score:
fatal_defects:
weakest_dimensions:
repairs_made:
remaining_uncertainties:
```

The final completion response reports the score and unresolved uncertainty, not the full internal review.
