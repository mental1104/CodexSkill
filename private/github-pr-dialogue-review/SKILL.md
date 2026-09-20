---
name: github-pr-dialogue-review
description: ChatGPT-first GitHub pull-request review semantics. Use whenever the user provides or refers to a PR and asks to review, inspect, explain, question, challenge, recheck, or comment on its code. This skill owns review reasoning, anchors, thread reuse, and comment payloads; all GitHub remote reads and writes are delegated to github-operations.
---

# GitHub PR Dialogue Review

## Scope

This skill is for conversational pull-request review inside ChatGPT.

The user should be able to provide one PR URL and then continue asking natural-language questions without leaving the chat. For every question, ChatGPT should:

1. locate the relevant code and surrounding execution path;
2. answer the user directly and quickly;
3. turn the question into one focused reviewer comment;
4. publish it to the exact changed line, changed range, existing thread, or PR-level review area allowed by the evidence;
5. keep enough review state to continue, recheck, and summarize later.

This skill reviews code. It does not modify the PR branch unless the user separately asks to implement fixes.

## GitHub Execution Boundary

This skill must not invoke GitHub API/connector tools, GitHub CLI publication commands, or `git push` directly.

All remote operations go through `github-operations`:

- PR metadata, diff, head SHA, changed files, review threads, author replies, and checks are remote-read requests;
- inline comments, replies, formal review states, thread resolution, and PR updates are remote-write requests;
- this skill determines what evidence is needed, what anchor is correct, and what comment/review payload should be sent;
- `github-operations` verifies the target and authorization, executes the remote operation, and returns the result.

## Mandatory Triggers

Always load this skill before handling requests that include a GitHub pull request and any intent such as:

- 代码 Review
- PR Review
- Review 这个 PR
- 审阅这个 PR
- 逐行看这个 PR
- 看一下这个 PR 的代码
- 检查这个 PR
- 解释这段 PR 改动
- 这个实现为什么这样写
- 这行有没有问题
- 把这个问题提到 PR
- 在对应代码行评论
- 看作者怎么回复
- 继续追问这个 Review
- 重新检查未解决问题
- 作者推了新版本，再看一遍
- summarize / inspect / review / re-review this pull request

A PR URL, repository plus PR number, an already bound PR in the current chat, or an explicit reference such as “当前 PR” is sufficient PR context.

Do not route these requests to `github-pr-harvest`. That skill prepares or submits PR descriptions; this skill reviews an existing PR.

## Core Principle

Use the user's question as the review cursor.

Do not replace the dialogue with a large speculative automated review report. Inspect enough context to answer the current question correctly, record the concern precisely, and let later questions drive deeper inspection.

Prefer one well-grounded thread over many low-confidence findings.

## Operating Model

### Review Session

When a PR is first supplied, bind a review session containing at least:

```text
repository
pull_request_number
pull_request_url
base_ref
head_ref
head_sha
changed_files
publish_mode
last_anchor
review_ledger
```

Default `publish_mode` is:

- `immediate` when the user asks to begin PR review, asks that questions be posted to the PR, or has a standing instruction that conversational PR review should create comments;
- `explain_only` when the user explicitly says not to post comments.

At session start, state the bound repository, PR number, current head SHA abbreviation, and publish mode once. Later questions inherit that scope until the user changes PRs or modes.

### Session Rehydration

A new chat cannot rely on hidden state from an old chat.

When the user reopens a PR in another chat:

1. request current PR metadata and diff through `github-operations`;
2. request existing inline review threads and review submissions through `github-operations`;
3. recover prior skill-created threads using the hidden marker defined below when available;
4. rebuild the open review ledger from GitHub state;
5. continue against the current head SHA.

## Source Of Truth

Repository and GitHub evidence are authoritative. Chat history is only a navigation aid.

Before answering a question, inspect the smallest sufficient evidence set from:

- PR title, description, base, head, and current head SHA;
- changed filenames and relevant per-file patch;
- surrounding file content at the PR head commit;
- callers, callees, interfaces, configuration, and tests when the answer depends on them;
- existing review threads and author replies;
- CI or command output only when actually available.

Never invent code behavior, test results, author intent, thread state, file paths, line numbers, or successful verification.

## Initial PR Binding Workflow

When the user provides a PR:

1. resolve repository and PR number from the URL or explicit identifier;
2. request PR metadata through `github-operations`;
3. request changed filenames and the full patch or relevant per-file patches through `github-operations`;
4. request existing review threads and review submissions through `github-operations`;
5. record the current head SHA;
6. build a lightweight change map:
   - entrypoints and public interfaces;
   - core control flow;
   - state and resource lifecycle;
   - failure and rollback paths;
   - tests and reviewer-operated regression paths;
7. do not publish any finding until the user asks a review question, unless the user explicitly requests an autonomous pass.

## Per-Question Workflow

For every user question in an active review session:

1. **Resolve intent**
   - Determine whether the question asks for explanation, correctness, resource lifecycle, concurrency, performance, compatibility, maintainability, security, testing, or design analysis.
2. **Resolve code context**
   - Start from the last anchor, named symbol, quoted code, file path, existing thread, or wording in the current question.
   - Read enough surrounding implementation and related code to avoid line-isolated reasoning.
3. **Check the PR head**
   - Before any remote write, ask `github-operations` to verify that the PR head SHA still matches the session.
   - If it changed, request refreshed metadata, patches, and threads, then rebuild anchors before preparing the comment payload.
4. **Answer in ChatGPT**
   - Give the conclusion first.
   - Explain the relevant execution path, invariant, failure mode, or tradeoff.
   - Clearly distinguish confirmed behavior from suspicion or suggestion.
5. **Select the review target**
   - Reuse an existing thread when the new question continues the same concern.
   - Otherwise choose one precise changed line, a changed range, or PR-level placement.
6. **Publish when authorized**
   - Convert the discussion into one concise, independently answerable GitHub comment payload.
   - In `immediate` mode, hand the authorized payload to `github-operations` and consume its result.
   - In `explain_only` mode, provide the comment draft without requesting a remote write.
7. **Update the ledger**
   - Record the review ID, file and line or thread, category, evidence level, head SHA, and status.
8. **Report the result**
   - Tell the user where the comment was posted or why no safe line anchor existed.

## Anchor Resolution

### Priority Order

Choose the comment location in this order:

1. the exact changed line whose behavior the question concerns;
2. the smallest changed multi-line range representing the complete branch, loop, lifecycle, or state transition;
3. an existing inline thread discussing the same concern;
4. a PR-level review comment for cross-file or design-level questions;
5. no write when the target remains materially ambiguous.

### Line Rules

- Prefer line-based comments anchored to the current head commit.
- Use `RIGHT` for added or current-head lines.
- Use `LEFT` only when the concern specifically targets a removed line in the base-side diff.
- Use `start_line` and `start_side` for a meaningful multi-line range.
- Do not confuse a file's source line number with the legacy diff `position` value.
- Never attach a concern to an unrelated nearby line merely to satisfy an inline-comment requirement.
- Do not comment on an unchanged line unless GitHub's current diff supports that anchor.

### Ambiguous Anchors

When two or more candidate locations would materially change the review meaning:

- answer the user's technical question immediately when possible;
- do not guess the GitHub write target;
- ask one focused location question, or state the candidate locations and withhold posting until the target is clear.

When the issue is inherently cross-file, use a PR-level review comment instead of asking for a fake line anchor.

## Comment Publication Policy

### One Thread, One Concern

Each review thread should contain one concern that the author can answer or fix independently.

Do not combine unrelated questions about naming, correctness, testing, and architecture into one comment.

### Chat Answer Versus GitHub Comment

The ChatGPT answer may teach and explain in depth. The GitHub comment should be shorter and reviewer-oriented.

Good inline comment shape:

```markdown
这里在错误返回前是否会关闭 `stdin_pipe[0]`？

从当前分支看不到对应回收。如果调用方也不统一关闭，这条路径会泄漏文件描述符。建议补充关闭逻辑或指出统一所有权位置，并增加失败路径断言。

<!-- github-pr-dialogue-review:v1;id=R001;head=abc1234 -->
```

For a simple clarification, omit unnecessary risk and recommendation paragraphs.

### Hidden Recovery Marker

Append a hidden marker to skill-created top-level comments:

```html
<!-- github-pr-dialogue-review:v1;id=<review-id>;head=<short-sha> -->
```

Rules:

- use a stable review ID within the PR, such as `R001`;
- do not expose internal chain-of-thought, confidence calculations, or private chat text in the marker;
- replies in the same thread do not need a new top-level marker;
- use existing markers to avoid duplicate threads and to rehydrate review state in later chats.

### Publish Authorization

Treat the following as explicit authorization for `immediate` mode within the bound PR session:

- the user asks to start conversational PR review and says questions should be posted;
- the user says “把每个问题提到对应行”; 
- the user's standing custom instruction explicitly defines this behavior;
- the user says “发到 PR”“评论到对应行”“继续追问这个 thread”.

This authorization applies only to review comments and replies on the currently bound PR. It does not authorize:

- approving the PR;
- requesting changes as a formal review state;
- resolving threads;
- editing code;
- merging or closing the PR.

Require an explicit user instruction for each of those actions.

The user can override publication for one question with wording such as:

- 这一问只解释，不要评论
- 先别发
- 只给评论草稿

The user can switch the session with:

- 恢复自动评论
- 后续都只解释

## Existing Thread Reuse

Before creating a new inline thread, check whether an existing open thread already covers the same behavior and anchor.

Use the existing thread when:

- the question is a follow-up to the same concern;
- the author has replied and the user wants to challenge or clarify that reply;
- a new commit partially addresses the original issue;
- the user references a ledger ID such as `R003`.

Create a new thread when the concern is independently resolvable, even if it is on the same line.

Do not reply to a reply ID when GitHub requires the top-level inline comment ID. Resolve the top-level thread first, then post the reply against its root comment.

## Evidence Levels

Classify every conclusion internally as one of:

- `confirmed`: directly demonstrated by the current code path, contract, test, or execution evidence;
- `likely`: strongly suggested by current evidence but dependent on an unseen runtime condition or caller;
- `question`: author intent or a missing invariant must be confirmed;
- `suggestion`: optional maintainability, readability, or design improvement rather than a defect.

Reflect the level in wording:

- `confirmed`: state the defect or behavior directly and cite the path;
- `likely`: describe the condition and remaining uncertainty;
- `question`: ask for the invariant or design reason without claiming a bug;
- `suggestion`: make clear that the current implementation may be valid.

Never upgrade a question into a confirmed bug merely to make the review sound decisive.

## Review Ledger

Maintain a compact ledger for the active PR:

```text
R001  kernel/proc.c:142-149  resource       open
R002  tests/qemu_runner.py:87 correctness  answered
R003  PR-level               design         open
```

Suggested statuses:

- `draft`
- `open`
- `answered`
- `fixed`
- `partially_fixed`
- `still_present`
- `outdated`
- `resolved`
- `withdrawn`

The ledger is a navigation structure, not a substitute for GitHub thread state. Reconcile it with GitHub before reporting current status.

## New Commit And Recheck Workflow

When the PR head changes or the user asks to recheck:

1. request the new head SHA and changed patches through `github-operations`;
2. request current review threads, including resolved and outdated state, through `github-operations`;
3. remap every open ledger item to the new diff;
4. classify each item as:
   - fixed;
   - partially fixed;
   - still present;
   - outdated because the relevant code disappeared;
   - unable to verify from repository evidence;
5. reply to the existing thread when the issue remains part of the same discussion;
6. create a new thread on the new diff only when the old anchor is outdated and a fresh anchor is necessary;
7. do not resolve a thread automatically unless the user explicitly requests resolution.

A textual author promise is not equivalent to a code fix. Verify the current implementation and tests.

## Fast Answer Format

Default ChatGPT response for one question:

```markdown
**结论：** <直接回答>

<必要的调用路径、风险条件或设计理由。>

**PR：** 已评论 `path/to/file:line`（R001）。
```

Use fewer sections for a simple question. Add more detail only when the reasoning needs it.

When no safe anchor exists:

```markdown
**结论：** <直接回答>

<必要解释。>

**PR：** 这是跨文件问题，已作为 PR 级评论提交（R003）。
```

When posting is withheld:

```markdown
**结论：** <直接回答>

<必要解释。>

**PR：** 当前有两个可能落点，尚未提交评论：`a.c:42` 与 `b.c:91`。
```

## Supported Natural-Language Operations

The user may use ordinary wording to request:

- `绑定 PR`：开始或切换 review session；
- `这一问只解释`：single-question explain-only override；
- `恢复自动评论`：switch to immediate publication；
- `列出当前问题`：show the reconciled ledger；
- `看 R003`：open and summarize the referenced thread and code；
- `继续问 R003`：reply in that thread；
- `看看作者怎么解释`：read author replies and evaluate them against code；
- `作者推了新版本`：refresh head and recheck open items；
- `重新检查所有未解决问题`：run the recheck workflow；
- `总结这个 PR`：summarize merge blockers, non-blockers, fixed items, tests, and remaining uncertainty；
- `解决 R003`：resolve the thread only after explicit confirmation of that exact thread；
- `提交 COMMENT / REQUEST_CHANGES / APPROVE`：submit the requested formal review state only when explicitly requested.

## Review Summary

When asked to summarize, report:

1. current head SHA;
2. merge blockers;
3. non-blocking concerns;
4. answered but unverified questions;
5. confirmed fixes;
6. relevant test evidence and missing coverage;
7. recommended next review action.

Do not infer that the PR is ready merely because all conversational questions received answers.

## Routing To Other Skills

- If the user asks to write, update, create, or submit the PR description, load `github-pr-harvest`.
- If the user asks to implement fixes for review comments, route to the available PR-comment fixing workflow and load `code-comment-writing` before changing executable code.
- If the user asks to debug failing GitHub Actions checks, route to the CI-fix workflow.
- If the user asks to commit, push, or open a new PR for local changes, route the authorized remote operation to `github-operations`.
- If the user asks only for a repository-grounded code walkthrough note, use the appropriate note skill rather than leaving review comments.

This skill remains responsible for review-state continuity and follow-up after another workflow returns.

## Safety And Failure Handling

- Never post to a repository or PR other than the currently bound target.
- Reconfirm the target when the user supplies another PR URL or the repository changes.
- Never claim a comment was posted unless the GitHub write succeeded.
- Never claim a thread was resolved, reopened, or answered without reading current GitHub state.
- If GitHub access fails, continue with the best available explanation, clearly mark that no comment was posted, and preserve a comment draft.
- If the PR is too large for one fetch, inspect the named or inferred file first and retrieve additional patches only as needed.
- Do not expose unrelated private repository content in the answer or comment.
- Do not include private chat context, hidden reasoning, secrets, tokens, local paths, or irrelevant user information in GitHub comments.

## Acceptance Criteria

A successful conversational review session must satisfy all applicable points:

- the PR is bound to the current repository, number, and head SHA;
- each answer is grounded in the relevant implementation rather than only the visible line;
- every authorized question becomes exactly one focused thread or reply unless no safe target exists;
- inline comments use the correct file, line or range, side, and current commit;
- cross-file concerns are not forced onto arbitrary lines;
- duplicate threads are avoided;
- confirmed defects, open questions, and optional suggestions use different language;
- new commits trigger anchor refresh before further writes;
- the ledger matches current GitHub thread state;
- formal approval, request-changes, resolution, code edits, and merge actions occur only after explicit user instructions;
- the user can complete the review workflow entirely from ChatGPT.
