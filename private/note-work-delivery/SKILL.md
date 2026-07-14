---
name: note-work-delivery
description: Advance unchecked work from one specific Obsidian note. Use when the user asks to implement, execute, issue-ize, continue, or finish TODOs from that note. Select GitHub mode only when frontmatter `source` resolves to a GitHub repository or the user explicitly overrides the repository; otherwise preserve the source checkboxes and advance the work directly in the current ChatGPT conversation.
---

# Note Work Delivery

## Role

Turn unresolved work embedded in one Obsidian note into a controlled delivery loop:

```text
source note
→ work package
→ atomic work items
→ execution
→ validation
→ user acceptance
→ source-note refresh
```

This skill owns orchestration, persistent state, approval gates, and handoffs. It does not replace:

- the GitHub skill for repository, issue, and PR operations;
- `yeet` for branch, commit, push, and draft PR publication;
- `gh-fix-ci` for failing GitHub Actions;
- `gh-address-comments` for actionable review feedback;
- `ROUTER` and the selected note skill for final knowledge writeback.

Do not use `task-harvest`; that skill extracts user-side tasks from chat and does not execute note-grounded work.

# Triggers

Use this skill for requests equivalent to:

- “推进这篇笔记里的待办”;
- “实现这篇笔记中的 TODO”;
- “把笔记待办转成 issue”;
- “根据这篇笔记建 issue 和 PR”;
- “继续推进这个 Tracking Issue”;
- “确认回写这个交付”;
- “Note Work Delivery”.

Do not use it for ordinary issue creation, generic note rewriting, whole-vault task scans, or chat reminder extraction.

# Mode Selection

Choose exactly one mode:

```text
frontmatter source resolves to GitHub
or user explicitly supplies a repository
→ github-mode

otherwise
→ chat-mode
```

GitHub mode migrates work into a persistent Tracking Issue and child issues.

Chat mode keeps the original checkboxes as the recovery source and advances the work in the current conversation.

# Resolve The Source Note

Identify one exact note and capture when available:

- vault or note repository;
- Markdown path;
- current blob SHA, commit, or local file state;
- full frontmatter;
- every unchecked task with heading and nearby context.

Read the full note. A checkbox line alone is insufficient because nearby prose may contain scope, dependencies, files, symbols, tests, or evidence.

Ask one focused question only when the target note cannot be resolved safely.

# Resolve The Target Repository

## Authoritative Association

Enter GitHub mode only from:

1. frontmatter `source` containing a GitHub URL that normalizes to one `owner/repo`; or
2. an explicit repository override from the user.

Canonical form:

```yaml
---
source: "https://github.com/mental1104/dlp_demo"
tags:
  - cpp
summary: "..."
read_status: unread
---
```

Repository-root, file, branch, commit, issue, and PR URLs are acceptable if they identify one repository.

## Conservative Boundary

Do not infer the repository from:

- the note directory;
- a project nickname;
- code language or symbols;
- repository-like text elsewhere in the body;
- prior conversation memory;
- the fact that the Obsidian vault itself is GitHub-hosted.

If `source` is empty, non-GitHub, malformed, or ambiguous and there is no override, use chat mode.

Before creating issues, verify the target repository exists, is accessible, and is not merely the vault repository accidentally mistaken for the delivery target.

# Extract And Cluster Work

## Raw Tasks

Extract unresolved Markdown tasks:

```markdown
- [ ] unresolved task
```

Ignore:

- completed tasks;
- examples inside fenced code;
- quoted or historical task lists;
- generated issue-link checklists;
- the trigger phrase itself.

For each raw task retain:

- exact text;
- heading path;
- nearby rationale;
- referenced files, symbols, tests, commands, or standards;
- dependencies;
- expected artifact: code, refactor, investigation, test, documentation, or user verification.

## Semantic Clustering

Checkbox count does not equal work-item count.

Merge tasks sharing one implementation boundary, acceptance criterion, code path, test family, or inseparable design decision.

Split tasks only when they can be completed and accepted independently.

Do not create an item for a duplicate, rhetorical question, minor implementation hint, or consequence already covered elsewhere.

Each atomic work item needs:

- action-oriented title;
- problem and scope;
- acceptance criteria;
- dependencies;
- expected validation;
- original checkbox provenance.

Before irreversible writes, form an internal work package:

```yaml
source_note:
  path: ...
  revision: ...
mode: github | chat
target_repository: owner/repo | null
topic: ...
work_items:
  - id: W1
    title: ...
    raw_task_refs: [...]
    acceptance: [...]
```

Proceed without a route-confirmation questionnaire when note, repository, and scope are explicit. Ask only when clustering would materially change user intent.

# GitHub Mode

## State Flow

```text
DISCOVERED
→ TRACKING_CREATED
→ CHILDREN_CREATED
→ SOURCE_TASKS_REMOVED
→ IMPLEMENTING
→ VALIDATING
→ REVIEW_PENDING
→ MERGED
→ SOURCE_REFRESH_PENDING
→ SOURCE_REFRESHED
→ CLOSED
```

Recoverable exceptional states include:

```text
ISSUE_CREATION_PARTIAL
SOURCE_CLEANUP_CONFLICT
VALIDATION_FAILED
REVIEW_CHANGES_REQUESTED
PR_CLOSED_UNMERGED
WRITEBACK_CONFLICT
```

## Create The Tracking Issue First

Create one parent issue before any child issue:

```text
[Tracking] <one coherent delivery topic>
```

It is a transaction ledger, not an implementation ticket. Its completion means:

```text
implementation merged
+ accepted result
+ source note refreshed
```

The body should include:

```markdown
## Goal

<delivery objective>

## Source note

- Vault or note repository: `<repo or local context>`
- Path: `<exact path>`
- Source revision: `<SHA, commit, or local state>`
- Target repository: `<owner/repo>`

## Raw note tasks

- `<original checkbox text>`

## Child work items

<!-- populated after child creation -->

## Delivery

- Source cleanup: pending
- Implementation PR: pending
- Merge commit: pending
- Source refresh: pending

## Completion criteria

- [ ] Child work is resolved
- [ ] Implementation is validated
- [ ] User has reviewed and merged
- [ ] User explicitly confirmed source-note writeback
- [ ] Source note reflects the accepted result
```

Append a hidden machine block:

```html
<!-- note-work-delivery:v1
mode: github
source_note_repo: <owner/repo or local>
source_note_path: <path>
source_note_revision: <revision>
target_repo: <owner/repo>
phase: TRACKING_CREATED
relationship_mode: pending
cleanup_pr:
implementation_prs:
merge_commits:
writeback_revision:
-->
```

Never put credentials or secrets in it.

Never close the Tracking Issue from an implementation PR. Close it only after source refresh.

## Create Child Issues

Creation order:

```text
Tracking Issue
→ child issues
→ hierarchy links
→ update Tracking Issue
```

Each child issue should contain:

```markdown
## Problem

<why this work exists>

## Scope

- ...

## Acceptance criteria

- [ ] ...

## Validation

- `<test, command, inspection, or evidence>`

## Source

- Tracking: #<parent>
- Obsidian note: `<path>`
- Original tasks:
  - `<checkbox text>`
```

Prefer native GitHub sub-issues when the available connector or authenticated `gh api` supports them.

If native mutation is unavailable, maintain a recoverable parent checklist:

```markdown
## Child work items

- [ ] #123 <title>
- [ ] #124 <title>
```

Record either:

```text
relationship_mode: native_sub_issue
```

or:

```text
relationship_mode: tracked_tasklist
```

Do not fail the workflow solely because native sub-issues are unavailable.

Use existing labels when clearly applicable. Do not invent a label taxonomy without user authorization.

## Migrate Source Checkboxes

Remove source checkboxes only after:

- the parent exists;
- every intended child exists;
- every child is linked from the parent;
- the parent preserves raw task text;
- issue numbers are known.

Allowed cleanup diff:

- remove successfully migrated unchecked task lines;
- remove blank lines made redundant by removal;
- optionally add one concise Tracking Issue link when vault convention supports it.

Do not simultaneously rewrite conclusions, reorganize headings, normalize unrelated Markdown, modify frontmatter, or remove other tasks.

If the note changed after capture:

1. reread it;
2. locate each task by exact text and section context;
3. remove only unique, still-unresolved matches;
4. stop on ambiguity.

Treat cleanup as independent from target-repository implementation. In a Git-backed vault, use a dedicated branch and PR containing only the guarded note diff.

## Implement Against Child Issues

Default topology:

```text
one Tracking Issue
→ several child issues
→ one cohesive implementation PR
```

Split into multiple PRs only for independent modules, staged landing, different review ownership, or material safety reasons.

PR bodies should:

- use `Closes #<child>` for fully completed child issues;
- use `Refs #<tracking>` for the parent;
- never use `Closes #<tracking>`;
- state validation and partial completion honestly.

Delegate specialist work:

- repository and issue/PR metadata → GitHub skill;
- branch, commit, push, draft PR → `yeet`;
- failing Actions → `gh-fix-ci`;
- review feedback → `gh-address-comments`.

Keep the Tracking Issue state synchronized.

## Validate

Derive validation from the real repository:

- repository instructions;
- build and test registration;
- CI commands;
- affected test families;
- formatting, lint, or documentation checks.

Run focused checks first, then required broader checks when feasible.

Record command or workflow, tested revision, result, and gaps. Never claim success without evidence.

## Review And Merge Gate

When validation passes:

- update PR description and issue references;
- mark ready for review when appropriate;
- set Tracking phase to `REVIEW_PENDING`;
- stop for user review.

Do not merge unless the user explicitly instructs this workflow to merge. A broad initial request to “finish the work” is not merge authorization.

If the user merges in GitHub, verify merged status and merge commit.

## Post-Merge Writeback Gate

Merge does not authorize note rewriting.

After merge:

- record merge commit;
- set phase to `SOURCE_REFRESH_PENDING`;
- state that code is merged but the note is not refreshed;
- wait for explicit confirmation such as “确认回写”.

Do not infer confirmation from CI success, PR approval, merge, or child-issue closure.

## Refresh The Source Note

After explicit confirmation:

1. load `ROUTER`;
2. classify the existing note’s future-reading intention;
3. select one primary note skill;
4. use `transform-mode`;
5. ground claims in merged repository truth.

Typical routes:

- current implementation → `note-code-walkthrough`;
- conclusion and proof → `note-conclusion-evidence`;
- repeatable procedure → `note-operation-manual`;
- stable mechanism → `note-cognitive-convergence`;
- valuable exploration history → `note-linear-achievement`.

`note-work-delivery` owns completion state. The selected note skill owns structure and prose.

Audit for stale:

- summary and conclusions;
- source revision;
- file and symbol paths;
- call chains and lifecycle;
- diagrams and Mermaid;
- implementation-versus-suggestion boundaries;
- test families and commands;
- references to deleted configuration or mechanisms.

Do not merely append “completed”.

Once accepted results are durably represented, remove stale migrated checkboxes by default. Preserve checked history only when the note convention explicitly requires it.

Finally record the note revision, mark `SOURCE_REFRESHED`, verify completion criteria, and close the Tracking Issue.

# Chat Mode

## State Flow

```text
DISCOVERED
→ WORK_ITEMS_EXTRACTED
→ EXECUTING_IN_CHAT
→ RESULT_VALIDATED
→ USER_ACCEPTED
→ SOURCE_REFRESHED
→ COMPLETED
```

Use chat mode when frontmatter `source` does not resolve to GitHub and no override exists.

Do not create issues merely because the note contains code or a software name.

## Persistence Rule

Do not delete or check off source tasks merely because they were copied into chat.

The original note remains the recovery entry because chat mode has no external task ledger.

If interrupted:

- reread the note;
- re-extract remaining unchecked tasks;
- reuse only recoverable evidence from the current conversation;
- do not claim undocumented work is complete.

## Execute Directly

Present one coherent work package, then advance it in the conversation without manufacturing issue ceremony.

Respect the user’s established cadence. When they prefer one action and one observation at a time, advance only the highest-leverage current step and inspect its evidence before continuing.

Distinguish:

- actions available to the assistant;
- commands or checks the user must run;
- user-only decisions;
- missing evidence.

Do not complete user-side actions without confirmation.

## Acceptance And Writeback

Before refreshing the note require:

- every work item has a result or explicit disposition;
- important claims are validated;
- uncertainty is stated;
- the user accepts the result.

Then:

1. load `ROUTER`;
2. select the appropriate transform-mode note skill;
3. write accepted results into the note;
4. remove only tasks now represented by durable content;
5. leave unresolved tasks untouched.

# Resume And Idempotency

## Resume By Tracking Issue

When the user says “继续推进 `<repo>#<tracking>`”:

1. fetch the parent;
2. parse its state block;
3. inspect child issues, PRs, and CI;
4. reread the source note when accessible;
5. continue from the first incomplete state;
6. do not recreate existing children.

## Resume By Source Note

Search for an open Tracking Issue matching:

```text
source note identity
+ note path
+ target repository
+ normalized topic
```

Resume the unique match. Ask one focused question only when several trackers are plausible.

## Partial Failure Rules

- Child creation partially fails: record created children, set `ISSUE_CREATION_PARTIAL`, keep source tasks.
- Source cleanup fails: issues remain valid; set cleanup pending and keep parent open.
- Validation fails: keep affected children open and do not mark review-ready.
- PR closes unmerged: retain or reopen affected work and update parent.
- Writeback fails: keep parent open and record merge, attempted note revision, and conflict.
- Concurrent note edits: preserve new user material and replace only stale claims.

# Checkpoint Output

At meaningful checkpoints report concisely:

- source note;
- selected mode and reason;
- task grouping;
- Tracking and child issues in GitHub mode;
- source cleanup;
- implementation PR and validation;
- current user gate;
- source refresh status.

Persistent detail belongs in the Tracking Issue or note, not repeated in every message.

# Static Acceptance Examples

| Note state and request | Expected behavior |
|---|---|
| `source: "https://github.com/mental1104/dlp_demo"` and “推进待办” | GitHub mode; parent, clustered children, cleanup, PR, merge gate, explicit writeback gate |
| `source: ""` | Chat mode; preserve tasks and advance in conversation |
| `source: "https://redis.io/docs/..."` | Chat mode; non-GitHub source |
| Vault is on GitHub but note `source` is empty | Chat mode; vault hosting is not target association |
| `source` points to a GitHub file | Normalize to its repository and retain ref as provenance |
| Nine overlapping tasks describe six deliverables | Create six children |
| Native sub-issue API unavailable | Parent task-list fallback with `tracked_tasklist` |
| PR merged without “确认回写” | Stop at `SOURCE_REFRESH_PENDING` |
| User says “确认回写” | Verify merge, route through `ROUTER`, refresh note, close parent |
| Chat result not accepted | Leave source tasks unchanged |

# Final Check

Before completion verify:

1. one exact source note was resolved and read fully;
2. GitHub mode came only from frontmatter `source` or explicit override;
3. work was clustered semantically;
4. parent existed before children;
5. children were recoverably linked;
6. source tasks were removed only after successful migration;
7. implementation was validated against the repository;
8. merge required explicit authorization;
9. writeback required explicit post-merge confirmation;
10. final note structure was delegated through `ROUTER`;
11. Tracking closed only after source refresh;
12. chat mode preserved unresolved source tasks.
