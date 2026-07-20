---
name: github-issue-harvest
description: Turn the current conversation, repository context, experiment result, or problem description into a focused and executable GitHub Issue. Use when the user asks to 提 Issue、转 Issue、生成 Issue、整理成 Issue or Issue 化. Draft by default; create the GitHub Issue only when explicitly requested.
---

# GitHub Issue Harvest

## Scope

Use this skill to turn the current coherent topic into one focused GitHub Issue.

The Issue should be suitable for:

- the user reviewing it later;
- Codex or another developer implementing it;
- verifying whether the work is actually complete;
- preventing accidental scope expansion.

This skill may inspect repository context when available, but it must not invent files, symbols, commands, test results, or existing behavior.

## Triggers

Use this skill when the user says:

- 提 Issue
- 转 Issue
- 生成 Issue
- 整理成 Issue
- Issue 化
- 把这个问题记成 Issue
- 把刚才的方案转成 Issue
- Create a GitHub Issue
- Draft an Issue

The trigger phrase itself is not part of the Issue content.

## Goal

Generate one Issue that answers:

1. What final state should be achieved?
2. What is the current state or problem?
3. What work is included?
4. What work is explicitly excluded?
5. What constraints must remain true?
6. How will completion be accepted?
7. How will the result be verified?

Prefer one focused Issue over a broad project plan.

Split the content only when several parts:

- can be implemented independently;
- have different acceptance criteria;
- require different verification paths;
- would make one Issue too broad to complete safely.

## Language

- Issue 标题和正文必须主要使用中文。
- 技术专有名词、代码标识符、文件路径、命令、日志、协议名和无法自然翻译的术语可以保留英文。
- 不要为了中文化而翻译函数名、类名、配置项、错误信息或命令输出。
- 只有用户明确要求其他语言时，才允许改变主要语言。

## Issue Type

Infer one primary type:

- `bug`: existing behavior is incorrect;
- `feature`: a new user-visible or system capability;
- `refactor`: internal structure changes without intended behavior changes;
- `experiment`: a hypothesis must be tested with evidence;
- `performance`: latency, throughput, memory, CPU, I/O, or scalability work;
- `docs`: documentation or durable explanation;
- `chore`: maintenance, configuration, dependency, CI, or repository housekeeping.

Do not force the user to choose when the type is clear from context.

## Output Format

```markdown
# <type>: <concise outcome-oriented title>

## 目标

<Describe the observable final state in one or two paragraphs.>

## 背景与现状

<Explain the current behavior, problem, motivation, and relevant evidence.>

## 工作范围

- <Required change>
- <Required change>

## 非目标

- <Related work that must not be included>
- <Behavior or component that should remain unchanged>

## 约束与不变量

- <Compatibility, architecture, dependency, performance, or behavior constraint>

## 验收标准

- [ ] <Observable and testable completion condition>
- [ ] <Observable and testable completion condition>

## 验证方式

```bash
<Command when known>
```

Expected observations:

- <Expected output, metric, behavior, test result, or generated artifact>

## 相关上下文

- Relevant files or symbols: `<path or symbol>`
- Related Issue / PR / document: <reference>

## 实现提示

- <Optional implementation direction, clearly separated from requirements>
```

Omit empty optional sections instead of filling them with “无”.

## Type-Specific Sections

Add only the sections required by the selected Issue type.

### Bug

```markdown
## 复现步骤

1. ...
2. ...

## 实际行为

...

## 预期行为

...
```

Include environment information only when it can affect reproduction.

### Experiment

```markdown
## 假设

...

## 实验变量

- Controlled variables:
- Independent variable:
- Observed metrics:

## 判定规则

- The hypothesis is supported when ...
- The hypothesis is rejected when ...
```

Do not describe an experiment as complete without recorded evidence.

### Performance

```markdown
## 基线

- Workload:
- Dataset:
- Concurrency:
- Current metrics:

## 性能目标

- Target metric:
- Regression limit:
```

Do not use vague acceptance criteria such as “性能有所提升”.

### Migration or Risky Change

```markdown
## 风险与回滚

- Main risk:
- Compatibility concern:
- Rollback or recovery path:
```

## Title Rules

Use an outcome-oriented title.

Prefer:

```text
perf: 批量拉取 MinIO artifacts 后写入 ClickHouse
fix: 避免 Redis 副本不可用时读取过期结果
refactor: 将文件识别能力收敛到稳定的 C ABI
```

Avoid:

```text
优化代码
修复问题
研究一下
完善功能
```

The title should identify:

- the main object;
- the intended change;
- the important context when necessary.

## Content Rules

- Focus on one coherent problem.
- Preserve facts supplied by the user.
- Separate requirements from implementation suggestions.
- Do not convert uncertain implementation ideas into mandatory requirements.
- Do not invent repository evidence.
- Do not copy the entire conversation into the Issue.
- Compress discussion history into current conclusions.
- Preserve decisive logs, commands, measurements, or error messages when they support the Issue.
- Acceptance criteria must describe observable outcomes.
- Verification must say how the outcome will be checked.
- Use checkboxes only for completion conditions, not for every implementation detail.
- Avoid unnecessary task fragmentation.
- Avoid prescribing a large redesign when a smaller complete change can solve the Issue.
- Keep the Issue understandable without requiring the original conversation.

## Scope Control

The Issue must explicitly identify non-goals when adjacent work could easily expand the scope.

Common non-goals include:

- unrelated cleanup;
- broad naming changes;
- dependency upgrades;
- architecture redesign;
- performance optimization without a target;
- documentation beyond the changed behavior;
- modifications to unrelated services or modules.

When implementation reveals additional work, prefer creating a follow-up Issue instead of silently expanding the current one.

## Labels

Suggest labels only when useful.

Output labels separately from the Issue body:

```text
Suggested labels: type/performance, area/storage, priority/medium
```

Do not assume these labels exist in the repository.

Inspect existing labels before applying them.

## Execution Policy

Default behavior:

1. generate the proposed title;
2. generate the complete Issue body;
3. suggest labels when useful;
4. do not create the Issue.

Create the GitHub Issue only when the user explicitly asks to submit, publish, or create it in a specified repository.

Before creating it, confirm from available context:

- repository;
- final title;
- Issue body;
- labels to apply, if any.

Do not create milestones, assign users, or link projects unless explicitly requested.

## Boundary

This skill drafts or creates GitHub Issues.

It does not:

- implement the Issue;
- modify repository files;
- create branches or commits;
- open pull requests;
- claim tests have passed without evidence;
- turn an Issue into a multi-week project plan unless explicitly requested.
