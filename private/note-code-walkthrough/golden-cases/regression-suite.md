# Regression Suite

## Purpose

Prevent the skill from overfitting to one document shape.

`CS144 Lab1 Reassembler` is the primary benchmark for a stateful algorithmic component, but it is not the universal template.

## Golden Case 1: CS144 Reassembler

Expected strengths:

- starts from unordered, duplicate, overlapping, and missing byte ranges;
- models the component as a hole filler;
- maps the metaphor to `first_unassembled`, pending intervals, capacity, and EOF;
- uses one concrete out-of-order trace throughout;
- explains trimming with exact half-open ranges;
- expands bidirectional merging through behavior partitions;
- proves EOF conditions with counterexamples;
- maps fixtures, oracles, negative oracles, and failing test families to source phases;
- separates current verification from historical benchmark data.

Do not blindly copy:

- CS144-specific section labels;
- state-machine framing for stateless code;
- machine-specific absolute paths;
- every historical image;
- all performance material when evidence is weak;
- duplicate introductions to the same concept.

Regression question:

> Does a newly generated stateful-component note achieve the same source-state-test closure without merely imitating headings?

## Golden Case 2: xv6 Cross-Layer System Call

Expected archetype: cross-layer call chain.

The note should prioritize:

```text
user call
→ generated or declared stub
→ trap/syscall dispatch
→ kernel implementation
→ process or memory state
→ return value or console observation
```

Required checks:

- privilege and representation boundary;
- argument validation;
- ownership and process context;
- return path;
- user program or test observation.

Failure sign:

- the note starts with the kernel implementation and never explains how users reach it.

## Golden Case 3: Pure Algorithm

Expected archetype: pure algorithm or data structure.

Required checks:

- input model;
- loop or structural invariant;
- one full iteration trace;
- correctness and termination;
- complexity;
- adversarial boundaries.

Failure sign:

- artificial constructor, lifecycle, and repository-call-chain sections dominate the note.

## Golden Case 4: Asynchronous Worker

Expected archetype: concurrent or asynchronous mechanism.

Required checks:

- execution entities;
- queue ownership;
- scheduling and callback context;
- shared state;
- cancellation, timeout, retry, and shutdown;
- timeline-based golden trace;
- deterministic observation or test probes.

Failure sign:

- a simple flowchart hides time ordering or concurrent ownership.

## Golden Case 5: PR Behavior Change

Expected archetype: PR or feature change.

Required checks:

- base and head;
- behavior before;
- requirement gap;
- changed contract;
- implementation delta grouped by responsibility;
- compatibility;
- added or changed assertions;
- review path.

Failure sign:

- the note becomes a changed-file changelog.

## Golden Case 6: Failure-Driven Path

Expected archetype: failure-driven execution.

Required checks:

- concrete symptom;
- trigger;
- actual path;
- invariant divergence;
- rejected alternatives;
- root cause;
- fix boundary;
- regression oracle.

Failure sign:

- the document preserves every debugging attempt instead of teaching the final mechanism.

## General Regression Gate

Before accepting a change to this skill, mentally test whether it improves or preserves all six cases.

Reject a rule when:

- it only helps the Reassembler case;
- it forces irrelevant sections into another archetype;
- it encourages unsupported claims from partial inputs;
- it rewards section count over cognitive closure;
- it makes the main skill duplicate every companion file.
