# Input Normalization

## Purpose

Normalize irregular source-code walkthrough inputs into an explicit evidence contract before analysis or writing.

The adapter answers:

1. What material was actually supplied?
2. What can be verified from it?
3. What claims are prohibited?
4. What additional evidence is necessary for a stronger document?
5. What is the highest honest verification level?

## Required Input Contract

Create this internal record:

```yaml
input_kind:
evidence_level:
repository:
revision:
target:
available_sources:
missing_sources:
allowed_claims:
forbidden_claims:
verification_ceiling:
```

Do not place the full record in the final note unless its limitations materially affect interpretation.

## Evidence Levels

| Level | Evidence available | Typical claim ceiling |
|---|---|---|
| E0 | prose description, memory, or unsupported assertion | user intent and hypotheses only |
| E1 | screenshot, snippet, log fragment, stack trace, or partial file | local behavior visible in the fragment |
| E2 | complete target files or source snapshot | target-local control flow and explicit state |
| E3 | repository revision with callers, tests, and build registration | end-to-end static implementation model |
| E4 | E3 plus executed focused or aggregate verification | observed build and runtime/test behavior |

Never silently upgrade evidence.

## Input Adapters

### Repository Or Revision

Signals:

- repository URL or local checkout;
- branch, tag, commit, or PR head;
- named class, module, feature, or mechanism.

Required actions:

- resolve repository and revision;
- inspect repository rules and relevant build entrypoints;
- find declarations, implementations, callers, dependencies, tests, and fixtures;
- record dirty working-tree state when local;
- distinguish implementation commit from current compatibility commits.

Allowed claims normally reach E3 or E4.

### Pull Request Or Diff

Primary question:

> What behavior changes between base and head, and how does the change close the original gap?

Required actions:

- inspect base and head revisions;
- identify changed behavior rather than only changed files;
- inspect unchanged callers and tests when necessary to interpret the diff;
- separate newly introduced behavior from pre-existing architecture;
- inspect assertions added, changed, or invalidated.

Forbidden shortcut:

- treating the diff alone as the entire runtime system.

### Complete Source File Or Small File Set

Allowed:

- explicit declarations;
- file-local control flow;
- state read and written inside the supplied files;
- directly visible dependencies.

Do not claim without further evidence:

- real production callers;
- lifecycle ownership;
- full repository responsibility;
- test selection;
- successful integration.

Try to resolve the repository from paths, includes, module names, or user context before accepting the lower ceiling.

### Code Snippet

Treat the snippet as an excerpt, not a complete implementation.

Required behavior:

- identify visible inputs, branches, state changes, and side effects;
- label missing declarations and surrounding invariants;
- avoid inventing caller intent;
- use placeholders such as “在给定片段中” rather than “系统会”.

A snippet-only walkthrough may be valuable, but it cannot honestly claim full lifecycle or coverage.

### Logs, Stack Trace, Or Runtime Output

Primary use:

- reconstruct one observed execution or failure path.

Required behavior:

- separate observed frames from inferred source behavior;
- map frames to source when repository access exists;
- distinguish the failing path from normal behavior;
- record whether logs are complete, sampled, or truncated.

Do not derive a complete architecture solely from runtime output.

### Existing Markdown Note

Use transform-mode.

Required behavior:

- preserve useful original learning material;
- verify source freshness;
- classify commands and results as current or historical;
- identify claims that no longer match current code;
- preserve questions even when their answers move.

The old note is evidence of the author's cognition, not automatically evidence of current source behavior.

### Chat, Review Notes, Or Source Snapshot

Use materialize-mode.

Required behavior:

- extract concrete repository identifiers, paths, symbols, commands, outputs, and questions;
- verify them when possible;
- separate settled conclusions from proposals and unresolved discussion;
- reconstruct missing context only from repository evidence.

A `source-walk` report normally supports E2 or E3 depending on whether callers, tests, and build registration were included.

### Screenshots

Prefer source text when the repository is accessible.

When screenshots are the only source:

- record visible path, symbol, line range, and truncation;
- do not infer hidden branches;
- preserve the image only when it contains unique annotations or visual state;
- mark OCR or transcription uncertainty.

## Evidence Escalation

Escalate evidence only when it changes the document materially.

Examples:

- caller inspection changes the responsibility boundary;
- fixture inspection reveals what the oracle actually observes;
- build registration shows that a named test is not selected;
- runtime execution distinguishes environment failure from target failure;
- base revision shows that a behavior predates the PR.

Do not expand into unrelated repository archaeology.

## Missing Evidence Policy

When important evidence is unavailable:

1. state what is known;
2. state exactly what is unknown;
3. explain which claim cannot be made;
4. continue with the strongest supported walkthrough;
5. record the smallest next inspection that would raise the ceiling.

Do not replace missing evidence with generic programming knowledge.
