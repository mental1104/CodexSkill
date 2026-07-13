---
name: note-operation-manual
description: "Create or transform Obsidian operation manuals around one minimum complete operational loop: a clear trigger, applicable starting state, verified happy path, decisive checkpoints, symptom-indexed recovery branches, final acceptance state, and rollback or cleanup. Use for repeatable setup, configuration, maintenance, recovery, CLI, software, infrastructure, and practical ChatGPT-derived procedures where the future reader wants to complete the task rather than replay the exploration history."
---

# Note Operation Manual

## Role

Create or transform an operation manual that helps the user's future self complete one repeatable task with minimal rediscovery.

The atomic unit is not one command, tool, technology, or heading. It is one minimum complete operational loop:

```text
one trigger scenario
+ one applicable starting state
+ one verified happy path
+ one acceptance state
= one operation manual
```

The successful path is the only mainline. Failed attempts may be retained only after they are converted into reusable troubleshooting knowledge.

Default reading and execution model:

```text
identify the current situation
→ follow the happy path
→ stop at decisive checkpoints
→ enter a symptom branch only when needed
→ recover and return to the mainline
→ verify the final state
→ roll back or clean up when necessary
```

The reader should not need to replay the original chat, debugging session, or experiment chronology.

## Modes

### `transform-mode`

Use when an existing Markdown note is being converted into or improved as an operation manual.

Required actions:

1. identify the single operational goal;
2. recover the final successful procedure;
3. move exploration history out of the mainline;
4. merge repeated or superseded commands;
5. convert reusable failures into symptom-indexed branches;
6. remove failed attempts with no future operational value;
7. add only decisive checkpoints;
8. verify that the note has one trigger and one completion state;
9. check both over-splitting and oversized scope.

Do not force a process-history note into this shape. If the lasting value is how the result was discovered, route to `note-linear-achievement`.

### `materialize-mode`

Use when the source is current chat context, terminal output, screenshots, commands, configuration fragments, a solved support conversation, or a known working procedure.

Extract in this order:

```text
operational goal
→ applicable environment and starting state
→ final working solution
→ shortest reliable action sequence
→ decisive checkpoints
→ reusable local failure branches
→ final acceptance
→ rollback, cleanup, or recovery
```

Do not preserve the conversation order by default. Reconstruct the note for future execution.

For a long troubleshooting conversation:

- treat the final working path as the only mainline;
- retain a failure only when its symptom, cause, and recovery are useful later;
- never claim an unverified reconstruction is confirmed working;
- mark inferred environmental assumptions;
- remove repeated probes, typing mistakes, dead ends, and abandoned alternatives.

## Use When

Use this skill when the future reader wants to:

- install, configure, enable, disable, upgrade, migrate, recover, or remove something;
- run a known command or setting sequence;
- repeat a solved ChatGPT operation question without asking again;
- restore a system after a known state change;
- execute a small practical task such as sorting a Go slice, triggering a scheduled task, or checking a listening port;
- diagnose a known symptom through a bounded recovery path;
- complete a task whose success has a recognizable final state.

The source should normally provide or support:

- a clear goal;
- executable actions;
- a trustworthy or verified happy path;
- a recognizable success state;
- a reasonable chance of future reuse.

## Avoid

Use another primary skill when the future-reading intention is different:

- use `note-linear-achievement` when attempts, failures, observations, and turning points are the main asset;
- use `note-conclusion-evidence` when the main value is a claim and its proof;
- use `note-cognitive-convergence` when the reader mainly needs a correct conceptual model;
- use `note-code-walkthrough` when the reader wants one concrete implementation from callers through internals and tests.

An operation manual may contain short explanation, evidence, or implementation context, but it must remain subordinate to execution.

## Required Companion Skills

When writing into the Blue Espeon Obsidian vault:

- use `blue-espeon-note-style` for placement, naming, backlinks, Mermaid conventions, and single-thesis boundaries;
- use `obsidian-frontmatter-metadata` as a required final metadata check;
- use `latex-math-writing` when mathematical notation appears;
- use `book-operation-manual-extract` first when the source is a book or reading note and extraction, deduplication, or merge decisions are needed.

Do not create dead wikilinks. Inline small one-off procedures instead of inventing empty shared notes.

# Core Operational Model

## Happy Path Is The Only Mainline

Good:

```text
prepare
→ configure
→ start
→ verify
```

Bad:

```text
attempt A
→ failed
→ attempt B
→ failed
→ attempt C
→ worked
```

A failed historical path may appear only after it has been converted into future-facing troubleshooting knowledge.

## Checkpoints Are Decision Gates

A checkpoint exists only when it answers:

> Can the reader safely continue, or must the next action change?

Use a checkpoint when:

- output determines the next branch;
- a value is copied into a later step;
- an action is destructive, dangerous, or hard to undo;
- the command commonly fails in a confusing way;
- the result is the only practical evidence of success;
- continuing from the wrong state would make later diagnosis harder.

Do not add `Expected output` or `State after` after every quiet command.

## Troubleshooting Is Symptom-Indexed

Headings should normally use what the reader can observe:

```markdown
### `Connection refused`

### `Destination host unreachable`

### 服务启动后没有监听端口
```

Do not organize troubleshooting as “attempt 1 / attempt 2 / attempt 3”.

Each meaningful branch should answer:

1. What symptom enters this branch?
2. What should be checked first?
3. What known causes are supported by evidence?
4. What actions recover the system?
5. How is recovery verified?
6. Where does the reader return to the happy path?

Preferred local shape:

````markdown
### `<observable symptom>`

优先检查：

```bash
<minimal diagnostic command>
```

已知原因：

- ...

处理：

```bash
<recovery command>
```

验证：

```bash
<verification command>
```

修复后返回：[[#最终验证]]
````

Do not invent a cause when only a symptom is known. Mark unresolved uncertainty explicitly.

## Local Branches Stay Local

Keep a failure branch inside the current manual when:

- it belongs specifically to the current operation;
- recovery returns to the current happy path;
- the diagnostic path is short;
- it has no independent trigger outside this manual.

Create or reuse a separate troubleshooting manual only when the failure domain:

- can be triggered by several different operations;
- has its own substantial decision tree;
- crosses several system layers;
- has an independent entry condition and recovery acceptance state;
- is already reused by multiple manuals.

The parent manual must retain enough context to explain when to follow the link and where to return afterward.

# Failure Preservation Rules

Retain a failed path only when at least one is true:

- it is likely to recur;
- the symptom is misleading;
- the wrong action could damage the environment;
- the visible symptom differs from the real cause;
- recovery requires a special command or rollback;
- environment or version differences create a meaningful branch;
- the failure identifies the current system state;
- different output changes the next action.

Normally omit:

- typing mistakes;
- repeated probes with no new information;
- tiny variations of the same failed command;
- alternatives fully superseded by the final procedure;
- one-off anomalies with no confirmed explanation or recovery;
- chat narration and conversational transitions;
- failures useful only for preserving history.

If exact failed output is needed to recognize a symptom, preserve only the decisive lines. Keep full chronology in a linear achievement note when needed.

# Atomicity And Split Rules

## Minimum Complete Operational Loop

One manual may contain several tools, phases, commands, checkpoints, and local failure branches when all serve the same completion state.

Do not split merely because the procedure contains:

- installation and configuration;
- Windows and Linux commands;
- a service and a firewall;
- several technical concepts;
- multiple phases required to complete one goal.

## Split Admission Rule

A candidate section should normally become a separate manual only when both are true:

1. it has an independent trigger scenario;
2. it has an independent completion state.

Additional valid reasons:

- it is a complete shared subprocedure reused by multiple manuals;
- its troubleshooting is an independent diagnostic loop;
- it belongs to a different lifecycle such as initial setup versus recurring recovery, upgrade, migration, or removal.

## Anti-Fragmentation Rule

If splitting forces the reader to open several notes consecutively to complete one goal, do not split by default.

The parent manual must remain executable. Do not evacuate every command into linked micro-notes.

## Reuse-Before-Extraction Rule

When a small procedure appears for the first time, prefer inline explanation.

When it appears again, check whether reuse is real and whether it has its own complete operational loop.

Extract only when doing so reduces meaningful duplication without damaging parent-manual executability.

## Oversized Manual Warning Signs

Reconsider the boundary when a note contains:

- several independent entry scenarios;
- several unrelated success states;
- initial setup, daily use, upgrade, migration, incident recovery, and removal as peer workflows;
- multiple sections with their own prerequisites, steps, verification, and rollback;
- a troubleshooting tree larger than the happy path;
- a title equivalent to “complete guide,” “everything,” or unrelated operations joined by “and.”

Length alone is not a split rule. A long complete loop is better than several unusable fragments.

# Investigation And Writing Workflow

## 1. Define The Operational Contract

Before writing, state internally:

```text
Trigger: when is this manual opened?
Start state: what must already be true?
Goal state: what must be true when finished?
Acceptance: how is success recognized?
```

If these cannot be stated coherently, the scope is not ready.

## 2. Recover The Final Working Path

Identify:

- commands and settings that actually contributed to success;
- their required order;
- environment-specific values;
- required privileges and execution locations;
- obsolete earlier steps;
- whether the final state was actually verified.

Do not generalize commands beyond evidence without labeling the change.

## 3. Build The Mainline

Prefer phases based on meaningful system state changes, not one heading per command.

Each phase should contain:

- a concise action label;
- directly copyable commands or exact UI actions;
- a short note only when it prevents misuse;
- a checkpoint only when the next action depends on it.

## 4. Convert Failures Into Branches

For each candidate failure, choose one:

- retain as a local branch;
- link to an existing reusable troubleshooting manual;
- create a separate troubleshooting manual when justified and in scope;
- omit because it has no future value;
- preserve only in a separate linear process record.

Never leave failed attempts mixed into the happy path.

## 5. Validate Atomicity

Ask:

1. Does the note have one main trigger?
2. Does it have one final completion state?
3. Can the happy path be followed without opening several other notes?
4. Do local failures return to the mainline?
5. Does any section have its own independent trigger and completion state?
6. Would splitting improve reuse, or merely satisfy a superficial single-responsibility rule?

## 6. Validate Execution Quality

Before finishing:

- check command copyability;
- distinguish shells and execution hosts;
- preserve placeholders clearly;
- mark destructive actions;
- include rollback when realistic and useful;
- ensure checkpoints are decisive;
- ensure acceptance matches the procedure;
- never claim successful verification without evidence.

# Default Note Shapes

## Compact Shape

Use for small operational questions and short repeatable tasks:

````markdown
## 正文

### 适用场景

<when to use this>

### 操作

```bash
<copyable command or short sequence>
```

### 验证或注意事项

<only decisive verification or important caveat>
````

Do not inflate a small manual with empty sections.

## Full Shape

Use when the procedure has several phases or meaningful recovery branches:

````markdown
## AI摘要

<goal, environment, happy path, and decisive warning>

## 正文

### 快速使用

- 目标：
- 触发场景：
- 适用环境：
- 最终状态：
- 主要风险：

### 前置条件

...

### 成功路径

#### 1. ...

```bash
...
```

#### 2. ...

```bash
...
```

### 关键检查点

| 检查点 | 正常状态 | 异常时 |
|---|---|---|
| ... | ... | [[#...]] |

### 故障处理

#### `<observable symptom>`

- 优先检查：
- 已知原因：
- 处理：
- 验证：
- 返回主线：

### 回滚、清理与恢复

...

### 环境或版本差异

...

### 相关原理与来源

<optional; links or minimum explanation only>
````

Omit sections that do not add operational value.

# Quiet Command Rule

Operation manuals should follow command-line ergonomics:

```text
No response is often the best response.
```

For ordinary setup, prefer a coherent command block followed by one verification.

Good:

```bash
git config --global user.name "mental1104"
git config --global user.email "mental1104@gmail.com"
git config --global init.defaultBranch main
```

Then:

```bash
git config --global --list
```

Bad:

```markdown
Expected output: no output means success
State after: user.name is configured
```

Do not repeat such prose after every quiet command.

# Command And UI Style

Commands must be directly copyable.

- identify the shell when ambiguity matters;
- identify the execution host when a procedure crosses devices;
- prefer one coherent command block per phase;
- use placeholders such as `<WSL_IP>` consistently;
- add comments only when they prevent misuse;
- do not wrap every command in repetitive prose;
- for UI procedures, use exact menu labels and action-oriented steps;
- keep alternatives outside the mainline in clearly labeled branches.

# Evidence And Honesty Rules

Distinguish:

- **verified working step**: directly demonstrated in source context;
- **trusted reference step**: grounded in authoritative documentation but not executed here;
- **inferred reconstruction**: assembled from partial evidence;
- **optional alternative**: not part of the recommended happy path;
- **historical failed attempt**: retained only for troubleshooting recognition.

Never claim an inferred or reference-only sequence was locally verified.

# Math Formatting Rule

If the note contains LaTeX math, also use `latex-math-writing`.

# Frontmatter Metadata Check Rule

Before finishing, use `obsidian-frontmatter-metadata` and follow the target vault template, especially valid top-level `source`, `tags`, `summary`, and `read_status` fields.

# Output Policy

After creating or editing the note, respond with:

```markdown
## 完成情况

- 类型：操作手册型
- 模式：transform-mode / materialize-mode
- 文件：`<path>`
- 操作闭环：`<trigger> → <goal state>`
- 成功主线：
  - ...
- 故障分支：
  - 内联：...
  - 复用或新建：...
- 拆分判断：未拆分 / 已拆分 + 理由
- 验证状态：已验证 / 引用验证 / 未完全验证
- 不确定点：
  - ...
```
