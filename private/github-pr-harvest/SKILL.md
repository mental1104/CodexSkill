---
name: github-pr-harvest
description: Build or submit a repository-grounded GitHub Pull Request with a focused Chinese title and a high-signal body. Use whenever the user asks to 写 PR、整理 PR、提 PR、提交 PR、创建 PR、开 PR、完成 PR or equivalent wording. Repository evidence is mandatory even when chat context is missing.
---

# GitHub PR Harvest

## Scope

Use this skill whenever the user wants to draft, update, create, or submit a GitHub Pull Request.

The PR should let a reviewer quickly answer only these questions:

1. PR 的基本提交信息是什么；
2. 实现了什么；
3. 添加或修改了哪些带明确断言的单元测试；
4. 如何通过 CLI 回归并观察该 PR 引入的现象；
5. 实际执行了哪些自动化测试，结果如何；
6. 应当按照什么主线审阅代码。

The PR must be understandable without relying on the original chat.

## Core Principle: 宁缺毋滥

- The six information areas above are the only default PR body sections.
- Do not add standalone sections such as `实现说明`、`影响范围`、`风险与注意事项`、`非目标`、`关联项` or generic summaries unless the user explicitly requests them.
- Omit an optional section when there is no meaningful repository evidence for it.
- Never keep a section merely to write `无`、`不涉及`、`符合预期`、`已测试` or similar filler.
- Keep relevant design choices, compatibility concerns, risks, and deferred boundaries next to the exact implementation or review step they affect instead of expanding the body horizontally.
- Prefer a short PR that guides verification and review over a complete-looking PR that repeats obvious facts.

## Mandatory Triggers

Always load this skill for requests including:

- 写 PR
- 整理 PR
- 生成 PR 描述
- 提 PR
- 提交 PR
- 创建 PR
- 开 PR
- 完成 PR
- 把改动提交成 PR
- push 并提 PR
- Create a pull request
- Open a PR
- Submit the completed PR

This routing is mandatory even when the request contains no implementation context beyond a phrase such as “提交完成 PR”.

## Source Of Truth

Repository evidence is the primary source of truth.

Chat context is supplementary only. Never infer completed work solely from earlier discussion or intended design.

Before writing the PR, inspect as available:

- repository and remote;
- current branch and target base branch;
- `git status`;
- commits included in the PR;
- full diff between base and head;
- changed files and important symbols;
- unit tests added or modified, including their concrete assertions;
- CLI entrypoints and commands that can reproduce observable behavior;
- commands actually executed and their results;
- CI status when already available;
- Issue or PR references found in the request, branch, commits, repository metadata, or implementation context.

If local repository access is unavailable, use GitHub branch, commit, diff, and PR evidence where available.

Do not invent implementation details, test commands, assertions, passing results, observable phenomena, Issue numbers, PR numbers, or review conclusions.

## Markdown File Protection

Treat repository Markdown documents as protected files by default so PR work does not silently expand into documentation work.

- Unless the user explicitly authorizes it in the current request, do not create, modify, delete, rename, move, format, stage, commit, or otherwise include any Markdown document in the PR.
- This protection applies case-insensitively to every path ending in `.md` or `.markdown`, regardless of directory or filename. It includes `README.md` and model-invented files such as `SUMMARY.md`, `PLAN.md`, `NOTES.md`, `IMPLEMENTATION.md`, and `TESTING.md`.
- Requests to implement code, fix tests, handle CI, address review feedback, complete an Issue, draft a PR, or submit a PR do not implicitly authorize Markdown changes.
- A vague request such as “更新文档” does not authorize inventing a new filename. Modify only a document explicitly named by the user or uniquely identified by the request.
- Authorization is local to the named file or clearly bounded set of files. Permission to modify one Markdown file does not extend to any other Markdown file.
- Do not infer authorization from repository conventions, best practices, stale documentation, code changes that appear to need documentation, or an Issue requirement that the user did not explicitly ask to implement as documentation.
- Put explanations, plans, verification steps, migration notes, and summaries in the Issue, PR body, PR comments, or final response instead of creating a repository Markdown file.
- If a repository policy appears to require a Markdown update that the user did not authorize, report the conflict instead of changing the file.
- Pre-existing Markdown worktree changes must not be staged into the current PR and must not be reverted, overwritten, or deleted without explicit user authorization.
- Before publishing or updating the PR, inspect the complete diff and verify that every Markdown change has explicit user authorization. Remove unauthorized Markdown changes from the PR scope and report them.

## Contextless Submission Workflow

When the user only says something like “提交完成 PR”:

1. resolve the current repository and branch;
2. determine the target base branch;
3. inspect `base...HEAD` instead of relying on chat memory;
4. verify that every Markdown change in the full diff is explicitly authorized by the user;
5. summarize the actual implementation from the diff;
6. inspect unit-test changes and extract their core assertions;
7. identify a precise CLI regression path when the behavior is directly observable;
8. inspect executed checks and CI evidence;
9. run the most relevant feasible checks if they have not been run;
10. build a reviewer-oriented reading order from interfaces to implementation and tests;
11. validate related Issue or PR references;
12. generate the title and body using this skill;
13. only then create or update the PR.

If evidence for a mandatory section is genuinely insufficient, stop before submission and report the evidence gap. If an optional section has no useful content, omit it.

## Language

- PR 标题和正文必须主要使用中文。
- Conventional Commit 类型、代码标识符、文件路径、命令、日志、协议名和技术专有名词可以保留英文。
- 不要翻译函数名、类名、配置项、错误信息或命令输出。
- 只有用户明确要求其他语言时，才改变主要语言。

## Title

Use a concise, outcome-oriented title:

```text
<type>: <中文结果描述>
```

Common types:

- `feat`
- `fix`
- `refactor`
- `perf`
- `test`
- `docs`
- `chore`
- `ci`

Prefer:

```text
feat: 增加 ClickHouse 写入前的 artifacts 批量拉取
fix: 避免 Redis 副本不可用时返回过期结果
refactor: 将文件识别能力收敛到稳定的 C ABI
```

Avoid vague titles such as:

```text
更新代码
修复问题
完成开发
若干优化
```

The title must summarize the full PR diff rather than one incidental commit.

## Default PR Body

Use only the sections that carry meaningful evidence:

````markdown
## PR 提交信息

- 关联 Issue：Closes #<issue>
- 变更类型：<功能 / 修复 / 重构 / 测试 / 文档 / CI>
- 影响范围：<直接受影响的模块、接口或行为>
- 一句话摘要：<该 PR 最终带来的结果>

## 实现了什么

- <已经完成的主要能力或行为变化>
- <必要的关键结构变化；仅在它有助于理解或审阅时保留>

## 添加/修改了什么单元测试

| 测试用例 | 覆盖场景 | 核心断言 |
|---|---|---|
| `<test_name>` | <输入、状态或边界> | `<关键 assertion>` 验证 <预期结果或不变量> |

## 如何通过 CLI 回归观察此 PR 现象

### 前置条件

```bash
<必要的依赖、构建或环境准备命令>
```

### 操作步骤

```bash
<从启动到触发现象的完整命令序列>
```

### 预期现象

```text
<reviewer 应观察到的关键输出、状态变化或交互结果>
```

## 自动化测试结果

| 命令或检查项 | 结果 | 关键证据 |
|---|---|---|
| `<command>` | 通过 / 失败 / 未运行 | <摘要、失败点或未运行原因> |

## Review 主线

1. `<path/to/interface-or-entry>`
   - 先确认 <接口、数据结构、入口或行为契约>。
2. `<path/to/core-implementation>`
   - 再检查 <核心控制流、状态变化或关键算法>。
3. `<path/to/boundary-or-test>`
   - 最后结合 <边界处理、回归测试或调用方> 验证实现闭环。
````

### Required And Optional Sections

- `PR 提交信息`、`实现了什么`、`自动化测试结果` and `Review 主线` are mandatory for a normal code PR.
- `添加/修改了什么单元测试` is included only when the diff actually adds or materially changes assertion-based unit tests.
- `如何通过 CLI 回归观察此 PR 现象` is included only when the PR exposes a meaningful command-line, interactive, service, system, or runtime phenomenon that a reviewer can reproduce.
- Documentation-only or metadata-only PRs may omit sections that are structurally inapplicable, but must still preserve a useful implementation summary, validation result, and review order.
- Within `PR 提交信息`, omit individual lines that have no useful evidence. Do not write placeholder values such as `无`.

## PR 提交信息 Rules

This section is an index, not a second summary.

- `关联 Issue` must use a validated relationship when repository access permits.
- `变更类型` should match the full diff rather than the latest commit.
- `影响范围` should name only directly affected modules, interfaces, data, configuration, deployment paths, or observable behaviors.
- `一句话摘要` should describe the outcome in one sentence and must not repeat the PR title word for word.

Use relation keywords intentionally:

- `Closes #123`: merging should close the Issue;
- `Fixes #123`: merging fixes and closes the bug Issue;
- `Related to #123`: related context without automatic closure;
- `Depends on #123`: this PR depends on another item;
- `Follow-up: #123`: intentionally deferred work.

Do not invent references or use `Closes` merely because an Issue is mentioned. Use `owner/repo#123` for cross-repository references.

## 实现了什么 Rules

- Describe completed behavior, not the intended plan.
- Group changes by capability or behavior, not by commit chronology.
- Do not turn this section into a file-by-file changelog.
- Mention important internal structure only when it explains behavior, ownership, lifecycle, compatibility, or review risk.
- Keep each bullet independently verifiable from the diff.
- Separate completed work from deferred work. Mention a non-goal only when omitting it would materially mislead the reviewer.
- Do not claim that an Issue requirement was completed unless the diff and verification support it.

Good:

```markdown
## 实现了什么

- 新增 `vmspace` 系统调用，输出当前进程虚拟地址空间中的关键区间。
- shell 初始化完成后调用一次该能力，并保持子 shell 不重复打印。
```

Bad:

```markdown
- 修改了 `proc.c`。
- 新增了 `vmspace.c`。
- 做了一些优化。
```

## Assertion-Based Unit Test Rules

This section answers what behavior is protected by executable assertions. It does not report whether the whole test suite passed.

Include only tests that were added or materially modified in the PR and contain concrete expected outcomes.

For every listed test, identify:

- the test name or parameterized test group;
- the input, state, failure mode, or boundary it covers;
- the core assertion or invariant it verifies.

Rules:

- Prefer one row per meaningful scenario; group mechanically repeated parameterized cases when clearer.
- Quote only the core assertion expression or summarize it precisely. Do not paste the full test body.
- Do not list compilation, lint, CI workflows, manual CLI steps, snapshots without checks, or test files that only changed formatting.
- Do not claim coverage merely because a test file exists.
- If no assertion-based unit test was added or modified, omit the entire section instead of explaining why it is absent.

Good:

```markdown
| 测试用例 | 覆盖场景 | 核心断言 |
|---|---|---|
| `test_vmspace_after_sbrk` | heap 扩容一页 | `used_after == used_before + PGSIZE` 验证已用空间同步增长 |
| `test_vmspace_width` | 不同 `p->sz` 映射到固定宽度 | `len(bar) <= 80` 验证输出宽度上限 |
```

Bad:

```markdown
- 增加了相关单元测试。
- 测试正常。
```

## CLI Regression Observation Rules

This section is a reviewer-operated acceptance path. It is not a duplicate of automated test commands.

A useful CLI regression path must include:

1. exact prerequisites when they are not obvious;
2. copyable commands from build or startup through the behavior trigger;
3. required interactive input and exit method when applicable;
4. concrete expected output, state transition, metric, file, database row, network response, or runtime behavior.

Rules:

- Start from a realistic reviewer state, normally a fresh checkout of the PR branch.
- Use exact commands and input. Avoid phrases such as `正常启动`、`按常规流程操作` or `即可观察`.
- Separate commands from expected observations.
- Include repeated before/after operations when the PR changes state over time.
- Do not mark the CLI procedure as passed unless it was actually executed; execution evidence belongs in `自动化测试结果` or an explicit observed-result row there.
- Omit the section for pure internal refactors, formatting, documentation, or changes with no honest CLI-observable phenomenon.

## Automated Test Result Rules

This section records what was actually executed and what happened.

Distinguish between:

- the exact command or CI check;
- whether it passed, failed, or was not run;
- the smallest useful evidence explaining the result.

Rules:

- Never mark a check as passed without direct command output, CI evidence, or another trusted repository record.
- If a check fails, record the failure and do not present the PR as fully validated.
- If a relevant check was not run, state the concrete reason.
- Do not confuse successful compilation with behavioral verification.
- Do not list planned checks as completed checks.
- Avoid pasting long logs; retain the decisive summary, count, failing target, or error line.
- Keep unit-test definitions in the assertion section and suite execution results here.

Good:

```markdown
| 命令或检查项 | 结果 | 关键证据 |
|---|---|---|
| `go test ./...` | 通过 | 全部 package 完成，无失败用例 |
| `make grade` | 通过 | `12/12` tests passed |
| ClickHouse 集成测试 | 未运行 | 当前环境缺少可用测试实例 |
```

Bad:

```markdown
- 已测试。
- 单元测试正常。
- 应该没有问题。
```

## Review Mainline Rules

This section tells the reviewer how to build the correct mental model with the least context switching.

Prefer this order when applicable:

1. public contract, data structure, configuration, schema, or entrypoint;
2. core implementation and main control flow;
3. failure handling, compatibility, concurrency, performance-sensitive, or boundary logic;
4. caller integration and assertion-based tests.

Each step should contain:

- an exact file path and, when useful, a symbol;
- what the reviewer should understand or verify there;
- any design choice, invariant, risk, or compatibility boundary that materially affects that step.

Rules:

- Use an intentional reading sequence, not an alphabetical changed-file list.
- Skip generated files, lockfiles, vendored code, formatting-only files, and repetitive declarations unless they are essential.
- Usually keep the mainline to 3–7 steps.
- Put high-value rationale and risk next to the affected step instead of creating generic standalone sections.
- End at tests or the user-visible entrypoint so the reviewer can close the loop between implementation and evidence.

Good:

```markdown
## Review 主线

1. `kernel/syscall.h` 与 `kernel/sysproc.c`
   - 先确认系统调用编号、入口和参数边界。
2. `kernel/vmspace.c::print_vmspace`
   - 再检查地址区间计算、页对齐和字符宽度映射；重点确认 `p->sz` 不是页对齐时的处理。
3. `user/sh.c`
   - 确认只在首个 shell 初始化后打印一次，不影响子 shell。
4. `tests/vmspace_test.py`
   - 最后对照 `sbrk` 前后断言和宽度边界完成行为闭环。
```

Bad:

```markdown
1. 看代码。
2. 看测试。
3. 整体 Review。
```

## Draft Versus Submission

Draft-only requests include:

- 写 PR 描述
- 整理 PR 文案
- 生成 PR 模板
- 预览 PR

For these, output the proposed title and body without creating or updating a PR.

Submission requests include:

- 提 PR
- 提交 PR
- 创建 PR
- 开 PR
- 完成 PR
- push 并提 PR

For these, generate the title and body with this skill, then perform the repository publish workflow.

Default to a draft PR unless the user explicitly asks for ready for review.

## Publish Integration

When local changes still need branch creation, staging, commit, push, or PR creation:

1. load and apply this skill first for PR evidence and content requirements;
2. use the GitHub publish workflow for branch, commit, push, and PR creation;
3. replace generic auto-filled PR text with the title and body generated by this skill;
4. report branch, commit, target branch, tests, PR link, and any remaining limitations.

This skill owns PR content quality. The publish workflow owns repository mutations.

## Updating An Existing PR

When a PR already exists for the branch:

- inspect the current full diff, not only the newest commit;
- verify that every Markdown change in the full diff is explicitly authorized by the user;
- normalize the body to the six high-signal information areas in this skill;
- preserve still-correct evidence, exact commands, useful observations, and review guidance;
- remove filler, stale claims, invalidated results, and duplicate standalone sections;
- do not create a duplicate PR.

## Boundary

This skill does not:

- invent missing repository context;
- mark unexecuted tests as passed;
- describe planned tests as completed assertions;
- claim an unexecuted CLI path was observed;
- automatically make a PR ready for review;
- merge the PR;
- close unrelated Issues;
- hide failed checks;
- create, modify, delete, rename, move, format, stage, or commit Markdown files without explicit user authorization;
- stage unrelated local changes;
- replace code review with a prose summary.