---
name: github-actions-ci-policy
description: Guardrail for creating or modifying GitHub Actions CI. Use whenever work may add or change `.github/workflows/*`, CI configuration, or repository automation. Never introduce GitHub Actions CI without explicit user authorization; newly authorized CI must default to pull-request-only execution after the PR is ready for review and must not run for draft PRs.
---

# GitHub Actions CI Policy

## Mandatory Rules

1. Never create, enable, copy, or roll out GitHub Actions CI unless the user explicitly requests GitHub Actions or CI for the target repository.
2. Generic requests such as adding tests, fixing code, improving a repository, opening a PR, or making a project complete do not authorize adding CI.
3. Newly authorized CI defaults to `pull_request` only. Do not add `push`, `schedule`, repository-wide rollout, or other triggers unless explicitly requested.
4. Draft pull requests must not execute CI jobs. PR CI must include the ready-for-review transition and guard every job with the equivalent of `github.event.pull_request.draft == false` so later updates run only while the PR remains ready for review.
5. Do not weaken existing draft protection. Any exception that allows CI during Draft or adds broader triggers requires explicit user approval.

## Default PR Trigger

```yaml
on:
  pull_request:
    types: [opened, ready_for_review, reopened, synchronize]

jobs:
  ci:
    if: ${{ github.event.pull_request.draft == false }}
```

A pull request opened directly as ready for review may run CI. A Draft PR and its updates must remain skipped until it becomes ready for review.

## Delivery Check

Before committing a workflow, confirm:

- the user explicitly authorized CI for this repository;
- no unrequested repository or trigger was included;
- Draft PR jobs are skipped;
- `ready_for_review` and later non-Draft updates are covered.
