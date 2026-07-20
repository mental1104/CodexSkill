---
name: github-pr-harvest
description: Build or submit a repository-grounded GitHub Pull Request with a focused Chinese title and body. Use whenever the user asks to 写 PR、整理 PR、提 PR、提交 PR、创建 PR、开 PR、完成 PR or equivalent wording. Repository evidence is mandatory even when chat context is missing.
---

# GitHub PR Harvest

## Scope

Use this skill whenever the user wants to draft, update, create, or submit a GitHub Pull Request.

The PR must explain:

1. 实现了什么；
2. 为什么采用当前实现；
3. 做了什么测试以及测试结果；
4. 对行为、接口、数据、配置、性能或部署有什么影响；
5. 关联了哪些 Issue、PR 或后续工作；
6. 审阅者最需要关注什么。

The PR must be understandable without relying on the original chat.

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
- tests added or changed;
- commands actually executed and their results;
- CI status when already available;
- Issue or PR references found in the request, branch, commits, repository metadata, or implementation context.

If local repository access is unavailable, use GitHub branch, commit, diff, and PR evidence where available.

Do not invent implementation details, test commands, passing results, impact, Issue numbers, PR numbers, or review conclusions.

## Contextless Submission Workflow

When the user only says something like “提交完成 PR”:

1. resolve the current repository and branch;
2. determine the target base branch;
3. inspect `base...HEAD` instead of relying on chat memory;
4. summarize the actual implementation from the diff;
5. inspect test files, executed checks, and CI evidence;
6. run the most relevant feasible checks if they have not been run;
7. identify observable impact and compatibility concerns;
8. identify valid related Issue and PR references;
9. generate the title and body using this skill;
10. only then create or update the PR.

If evidence for a section does not exist, omit the section or state the limitation explicitly. Never fill gaps with plausible-sounding claims.

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

```markdown
## 实现内容

- <已经完成的主要改动>
- <关键行为或结构变化>

## 实现说明

- <关键设计选择及其原因>
- <重要取舍；只记录有审阅价值的内容>

## 测试与验证

| 检查项 | 结果 |
|---|---|
| `<command or scenario>` | 通过：<关键观察> |
| `<command or scenario>` | 未运行：<明确原因> |

## 影响范围

- <受影响的模块、行为、接口、数据、配置、性能或部署>
- <兼容性结论或迁移要求>

## 风险与注意事项

- <仍存在的风险、边界条件、回滚或发布注意事项>

## 审阅重点

- <最希望 reviewer 检查的逻辑、文件或边界>

## 关联项

- Closes #<issue>
- Related to #<issue-or-pr>
- Depends on #<issue-or-pr>
- Follow-up: #<issue>
```

Omit empty optional sections instead of writing “无”.

`实现内容` and `测试与验证` are mandatory unless the available evidence is genuinely insufficient; in that case, stop before submission and report the evidence gap.

## Implementation Content Rules

- Describe completed behavior, not the intended plan.
- Group changes by capability or behavior, not by commit chronology.
- Do not produce a file-by-file changelog unless the PR is tiny and that is clearer.
- Mention important internal structure only when it explains behavior, ownership, lifecycle, or review risk.
- Separate actual implementation from future work.
- Do not claim that an Issue requirement was completed unless the diff and verification support it.

## Design Rationale

Record only decisions that help review or future maintenance:

- why the chosen design fits the requirement;
- why a simpler-looking alternative was not used;
- ownership, lifecycle, concurrency, compatibility, or failure-handling choices;
- material deviations from the linked Issue or original plan.

Do not explain obvious syntax or restate the entire implementation.

## Tests And Verification

Distinguish between:

- what was tested;
- how it was tested;
- whether it passed;
- what was observed.

Good:

```markdown
| 检查项 | 结果 |
|---|---|
| `go test ./...` | 通过：全部包测试完成，无失败用例 |
| MinIO 批量拉取集成场景 | 通过：100 条消息合并为一次批量查询 |
| ClickHouse 不可用场景 | 未运行：本地缺少可用测试实例 |
```

Bad:

```markdown
- 已测试
- 单元测试正常
- 应该没有问题
```

Rules:

- Never mark a test as passed without direct command, output, CI, or trusted repository evidence.
- If tests fail, record the failure and do not present the PR as fully validated.
- If a relevant test was not run, state why.
- Mention tests added or changed when they materially improve coverage.
- Do not confuse compilation with behavioral verification.
- Do not list planned tests as completed tests.

## Impact Analysis

Check only applicable dimensions:

- user-visible or developer-visible behavior;
- public API or ABI;
- message or data format;
- database schema or migration;
- configuration and environment variables;
- dependency changes;
- deployment or rollout process;
- backward compatibility;
- latency, throughput, CPU, memory, storage, or network I/O;
- security and permission boundaries;
- observability, logs, metrics, and alerts.

State “无预期影响” only when supported by the nature of the change. Prefer omitting irrelevant dimensions.

## Scope And Non-Goals

Add `非目标` when the diff sits next to tempting adjacent work or when the linked Issue had a broader scope.

```markdown
## 非目标

- 本 PR 不调整消息重试策略。
- 本 PR 不迁移历史 ClickHouse 数据。
```

Do not silently expand the PR to unrelated cleanup, dependency upgrades, broad renaming, or architectural redesign.

## Risks And Review Focus

Use `风险与注意事项` for remaining engineering concerns, not generic warnings.

Examples:

- concurrency or ordering assumptions;
- rollback or migration limitations;
- compatibility boundaries;
- partial failure handling;
- performance-sensitive paths;
- configuration defaults;
- behavior not covered by automated tests.

Use `审阅重点` to direct attention to the highest-risk or highest-value parts of the diff.

## Related Issues And PRs

Use relation keywords intentionally:

- `Closes #123`: merge should close the Issue;
- `Fixes #123`: merge fixes and closes the bug Issue;
- `Related to #123`: related context without automatic closure;
- `Depends on #123`: this PR requires another item;
- `Follow-up: #123`: intentionally deferred work.

Rules:

- Validate references when repository access permits.
- Do not use `Closes` merely because an Issue is mentioned.
- Include cross-repository references as `owner/repo#123`.
- Include related PRs when they provide dependency, alternative, predecessor, or follow-up context.
- Do not invent relationships based only on similar titles.

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
- preserve still-correct useful context from the existing body;
- update implementation and verification sections to reflect the current branch state;
- remove claims invalidated by later commits;
- do not create a duplicate PR.

## Boundary

This skill does not:

- invent missing repository context;
- mark unexecuted tests as passed;
- automatically make a PR ready for review;
- merge the PR;
- close unrelated Issues;
- hide failed checks;
- stage unrelated local changes;
- replace code review with a prose summary.
