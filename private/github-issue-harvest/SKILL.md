---
name: github-issue-harvest
description: Turn the current conversation, repository context, experiment result, or problem description into a focused and executable GitHub Issue payload. Use when the user asks to 提 Issue、转 Issue、生成 Issue、整理成 Issue or Issue 化. This skill owns Issue semantics and drafting; all GitHub reads and writes are delegated to github-operations.
---

# GitHub Issue Harvest

## Scope

Use this skill to turn the current coherent topic into one focused GitHub Issue.

The Issue should be suitable for:

- the user reviewing it later;
- Codex or another developer implementing it;
- verifying whether the work is actually complete;
- preventing accidental scope expansion.

This skill may inspect repository context when available, but it must not invent files, symbols, commands, test results, existing behavior, or repository labels.

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

Generate one classified Issue that answers:

1. What is the primary Issue type?
2. What final state should be achieved?
3. What is the current state or problem?
4. What work is included?
5. What work is explicitly excluded?
6. What constraints must remain true?
7. How will completion be accepted?
8. How will the result be verified?

Issue classification is part of Issue creation, not an optional cleanup step after the Issue has been written.

Prefer one focused Issue over a broad project plan.

Split the content only when several parts:

- can be implemented independently;
- have different primary types;
- have different acceptance criteria;
- require different verification paths;
- would make one Issue too broad to complete safely.

## Language

- Issue 标题和正文必须主要使用中文。
- 技术专有名词、代码标识符、文件路径、命令、日志、协议名和无法自然翻译的术语可以保留英文。
- 不要为了中文化而翻译函数名、类名、配置项、错误信息或命令输出。
- 只有用户明确要求其他语言时，才允许改变主要语言。

## Issue Classification

Infer exactly one primary type before drafting the title and body:

- `bug`: existing promised or expected behavior is incorrect, broken, or regressed;
- `feature`: a new user-visible or system capability is required;
- `refactor`: internal structure changes without intended behavior changes;
- `experiment`: a hypothesis must be tested and concluded with recorded evidence;
- `performance`: latency, throughput, memory, CPU, I/O, or scalability is the primary outcome;
- `docs`: documentation or durable explanation is the primary deliverable;
- `chore`: maintenance, configuration, dependency, CI, tooling, or repository housekeeping.

Classification rules:

1. Classify by the primary acceptance outcome, not by incidental implementation work.
2. Do not force the user to choose when the type is clear from context.
3. Use only one primary type. Secondary concerns belong in area or concern labels.
4. A missing capability is usually `feature`; behavior that previously should have worked is usually `bug`.
5. A performance problem is `performance` when measurable performance is the main acceptance target, even if code changes also refactor internals.
6. An investigation is `experiment` only when the deliverable is evidence and a conclusion. If the expected deliverable is a fix, classify the resulting Issue by that fix instead.
7. When the type is materially ambiguous, state the chosen type and the deciding reason in one concise sentence rather than leaving the Issue unclassified.

## Draft Output Format

Return classification metadata separately from the Issue body so it can be used when creating the Issue:

```text
Issue type: feature
Labels: type/feature, area/shell, priority/medium
```

Then return the Issue title and body:

```markdown
# feat: <concise outcome-oriented title>

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

Add only the sections required by the selected primary type.

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

Use an outcome-oriented title and align its conventional prefix with the primary Issue type:

| Issue type | Preferred title prefix |
| --- | --- |
| `bug` | `fix:` |
| `feature` | `feat:` |
| `refactor` | `refactor:` |
| `experiment` | `experiment:` |
| `performance` | `perf:` |
| `docs` | `docs:` |
| `chore` | `chore:` |

Prefer:

```text
perf: 批量拉取 MinIO artifacts 后写入 ClickHouse
fix: 避免 Redis 副本不可用时读取过期结果
feat: 为 xv6 shell 增加命令历史导航
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

## Label Strategy

Use labels as part of Issue classification and routing. Do not treat them as optional decoration.

Apply labels in layers:

1. **Type label — required:** exactly one label representing the primary Issue type.
2. **Area labels — normally required:** one or two labels identifying the affected subsystem, module, or domain.
3. **Priority label — conditional:** add only when priority is known from user intent, project policy, severity, deadline, or blocking impact.
4. **Status or concern labels — conditional:** add only when they change routing or handling, such as `needs-design`, `breaking-change`, `good-first-issue`, or `blocked`.

Preferred semantic mappings are:

| Primary type | Canonical label | Common repository equivalent |
| --- | --- | --- |
| `bug` | `type/bug` | `bug` |
| `feature` | `type/feature` | `enhancement`, `feature` |
| `refactor` | `type/refactor` | `refactor` |
| `experiment` | `type/experiment` | `research`, `experiment` |
| `performance` | `type/performance` | `performance`, `perf` |
| `docs` | `type/docs` | `documentation`, `docs` |
| `chore` | `type/chore` | `maintenance`, `chore` |

Rules:

- Always output the selected primary type and proposed labels during the draft stage.
- When a repository is known, inspect its existing labels before selecting or applying labels.
- Prefer the repository's existing naming convention over the canonical names above.
- Do not assume a canonical label exists merely because it appears in this skill.
- Do not invent, silently create, or rename repository labels unless the user explicitly requests label management.
- When no equivalent type label exists, keep the Issue explicitly classified in the draft output and report that the repository lacks a matching type label.
- Avoid redundant labels such as applying both `type/bug` and `bug` for the same meaning.
- Avoid speculative priority. Do not label every Issue `priority/high`.
- Keep the normal label set small: one type, one or two areas, and only justified routing labels.

Example draft metadata:

```text
Issue type: performance
Labels: type/performance, area/storage, priority/medium
Label status: unverified until repository labels are inspected
```

Example metadata after repository inspection:

```text
Issue type: feature
Labels to apply: enhancement, area/shell
Label status: verified against existing repository labels
```

## Execution Policy

Default draft behavior:

1. infer exactly one primary Issue type;
2. resolve the title prefix from that type;
3. inspect repository context and existing labels when a repository is available;
4. generate the proposed title;
5. generate the complete Issue body;
6. output the primary type and proposed labels;
7. do not create the Issue.

If repository metadata or existing labels must be read from GitHub, request only that evidence through `github-operations`.

When the user explicitly asks to submit, publish, or create the Issue, return an authorized Issue mutation payload to `github-operations`. The gateway verifies the target repository and performs the remote write.

Before handing off the mutation, confirm from available evidence:

- repository;
- primary Issue type;
- final title;
- Issue body;
- existing repository labels when available;
- exact labels to apply.

The payload should request:

1. exactly one existing type label when an equivalent exists;
2. relevant existing area labels;
3. priority, status, or concern labels only when justified;
4. no substitution of title prefixes for labels or labels for a clear title;
5. reporting of any requested classification that cannot be represented by existing repository labels.

Do not request milestones, assignees, project links, label creation, or repository-taxonomy changes unless explicitly requested.

## Boundary

This skill drafts GitHub Issue content and mutation payloads. It never invokes GitHub tools directly and never performs the remote write.

It does not:

- implement the Issue;
- modify repository files unrelated to this Skill;
- create branches or commits beyond the direct Skill update requested by the user;
- open pull requests;
- claim tests have passed without evidence;
- turn an Issue into a multi-week project plan unless explicitly requested.