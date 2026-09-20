---
name: github-operations
description: Single gateway for GitHub-specific access and mutations. Use whenever any workflow needs to read remote GitHub repository state, pull requests, issues, review threads, or checks, or needs to create/update issues, pull requests, comments, branches, commits, refs, or push local changes. Generic skills must delegate GitHub-specific operations here instead of invoking GitHub tools or git push directly.
---

# GitHub Operations Gateway

## Role

This skill is the only GitHub-specific execution boundary in this repository.

Generic skills may describe that they need repository, pull-request, issue, review-thread, or remote-source evidence, but they must not directly:

- invoke GitHub API or connector tools;
- run GitHub-specific CLI operations;
- create or update Issues or Pull Requests;
- publish review comments or replies;
- resolve or reopen review threads;
- create remote branches, commits, refs, or tags;
- run `git push`;
- assume a personal GitHub account, repository, organization, token, SSH identity, or remote.

When GitHub-specific work is required, route it through this skill.

## Security Boundary

1. Never use a hard-coded personal repository or account as a fallback.
2. Resolve the target repository only from the user's explicit request, the current repository remote, or repository context supplied by the calling skill.
3. Read operations and write operations are separate authorization classes.
4. A request to inspect code or a PR does not authorize any write.
5. A request to draft Issue/PR/comment text does not authorize publication.
6. Branch creation, commit creation, ref updates, merge, formal review states, and `git push` require explicit user intent for that operation.
7. Never copy unrelated repository content, credentials, tokens, local paths, or private chat context into GitHub.
8. If this skill is unavailable, the calling workflow must continue from local or user-provided evidence where possible and must not silently substitute another GitHub access path.

## Operation Contract

Calling skills should hand off a compact request:

```text
intent: <read_repository | read_pr | read_issue | create_issue | update_issue | create_pr | update_pr | review_comment | review_reply | review_state | branch_commit_push | other>
repository: <owner/repo or unresolved>
ref: <branch/tag/commit/PR head when applicable>
authorization: <read-only | explicit-write>
evidence_needed: <smallest required remote evidence>
payload: <draft content or requested mutation when applicable>
return_to: <calling skill>
```

Do not require every field when it is irrelevant.

## Read Operations

For remote reads:

1. resolve the exact repository and ref;
2. fetch only the smallest evidence requested by the caller;
3. return repository-relative paths, immutable revision identifiers, PR/Issue numbers, thread identifiers, and remote URLs only when useful;
4. do not broaden into unrelated private repositories;
5. do not mutate remote state.

Typical read operations include:

- repository file content at a known ref;
- branch, tag, or commit metadata;
- Pull Request metadata, changed files, patches, head SHA, review threads, and checks;
- Issue metadata and comments;
- repository metadata needed to construct stable permalinks.

## Write Operations

Before every remote write:

1. verify the repository target;
2. verify the exact requested mutation;
3. confirm that the caller has explicit write authorization from the user;
4. refresh stale target state when the write depends on a current SHA, thread, branch, or PR head;
5. execute only the requested write;
6. return the resulting identifier, URL, commit SHA, or failure.

Never claim success when the write did not complete.

## Specialist Routing

This gateway owns GitHub execution. Specialist skills own content and workflow semantics.

- `github-issue-harvest`: shape a focused Issue draft and acceptance criteria.
- `github-pr-harvest`: shape PR title/body and repository-grounded PR content.
- `github-pr-dialogue-review`: decide review semantics, anchors, thread reuse, and comment wording.
- `github-actions-ci-policy`: provide CI policy constraints; it performs no GitHub operation itself.
- `code-comment-writing`: mandatory when executable code is modified.

When a specialist needs remote state, this gateway retrieves it and returns the evidence. When a specialist produces an authorized mutation request, this gateway executes it.

## Branch, Commit, And Push

All workflows that would publish local changes through Git must cross this boundary.

Before `git push`:

1. inspect the current repository remote and branch;
2. ensure the remote belongs to the repository the user intends to update;
3. do not rewrite remotes to a personal account;
4. do not add a new remote unless explicitly requested;
5. do not force-push unless explicitly requested;
6. report the remote, branch, and resulting commit/PR state.

Enterprise-safe skills must never call `git push` directly.

## Failure Handling

If GitHub access is unavailable:

- return the missing evidence or failed operation to the caller;
- preserve any Issue/PR/comment draft locally in the conversation;
- do not fall back to a different account or repository;
- do not convert a read failure into a write attempt;
- let the calling generic skill continue from local or user-provided evidence when possible.

## Completion Contract

Return only the operation result needed by the caller:

```text
repository: owner/repo
operation: <intent>
status: success | unavailable | failed | withheld
revision_or_target: <sha / PR / Issue / thread / branch>
result: <minimal useful result>
write_performed: yes | no
```

Do not add unrelated GitHub advice.
