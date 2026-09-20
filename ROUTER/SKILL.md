---
name: ROUTER
description: Mandatory routing layer for Blue Espeon Obsidian archive requests. Use whenever the user asks to archive, materialize, rewrite, or turn current context into a durable note. Infer the input source, future reading intention, one primary note type, execution mode, companion skills, and whether clarification is materially necessary, then hand off directly to the selected skill instead of writing a generic document or asking the user to choose a template.
---

# Codex Skill Router

## Role

ROUTER selects the durable note shape before any Obsidian archive note is created or transformed.

It decides:

1. whether the request is an archive-note workflow;
2. the input source;
3. the future reading intention;
4. one primary note type;
5. the execution mode;
6. required front-end or companion skills;
7. whether clarification is materially necessary.

ROUTER does not write the final note. After deciding, hand off to the selected primary skill and let that skill own the document structure and output policy.

Choose by what the user's future self needs when reopening the note, not by superficial features such as whether the conversation contains steps, code, failures, tables, or commands.

# Mandatory Archive Entry

## Strong Trigger

The following signals must enter this router before writing:

- “归档”;
- “归档笔记”;
- “把这轮归档”;
- “把刚才的内容归档”;
- “输出归档文档”;
- “生成 Obsidian 笔记”;
- “沉淀成文档”;
- “整理成以后能查的笔记”;
- “实验结果归档”;
- “把这个操作记下来”;
- “重写这篇归档笔记”;
- equivalent requests to turn chat, notes, terminal output, repository evidence, or experiments into durable vault content.

When the user says only “归档” or another short trigger:

1. inspect the current relevant conversation context;
2. infer the intended archive scope from the active topic;
3. identify the future reading intention;
4. choose one primary skill;
5. proceed directly when the route and target are sufficiently clear.

Do not bypass the router and produce a generic Markdown summary.

## Archive Scope

Default scope is the current coherent topic, not the entire conversation history and not every adjacent tangent.

Include only material necessary for the selected note's central responsibility.

When several distinct topics appear in the recent context:

- prefer the topic most directly referenced by the archive request;
- use the latest coherent problem-solving thread when the user says only “归档”;
- do not silently combine unrelated topics into one note;
- ask only when two scopes are equally plausible and would produce materially different notes.

# Execution Default

## Proceed Without Route Confirmation

When the route is clear, do not stop to output a template choice or ask:

> 是否按这个路线执行？

Proceed directly when the current context provides enough information to infer:

- the source material;
- the archive scope;
- the future reading intention;
- the primary note type;
- the target note or a defensible new-note placement.

This applies to both new notes and explicit rewrites of a clearly identified existing note.

## Clarify Only When Materially Necessary

Ask one focused question only when proceeding would risk writing the wrong artifact, such as:

- several existing notes could be overwritten and the target cannot be resolved;
- “archive this conversation” could reasonably refer to two unrelated threads;
- two future reading intentions are equally strong and would create substantially different structures;
- the requested scope violates the single-thesis boundary and the user has not indicated which part matters;
- the target directory or file cannot be determined from vault rules or nearby established patterns;
- the operation would replace, delete, or substantially reorganize important existing content without clear authorization.

Do not ask merely because more detail would be nice. Make a best-effort route from available context.

# Helper Skills

The selected primary skill owns the final note. Apply helper skills as required:

- `blue-espeon-note-style`: vault placement, naming, backlinks, wikilinks, Mermaid conventions, and single-thesis boundaries;
- `obsidian-frontmatter-metadata`: valid `source`, `tags`, `summary`, and `read_status` metadata;
- `latex-math-writing`: required when LaTeX mathematics appears;
- `source-walk`: temporary repository evidence packet under `/tmp` when direct repository inspection is unavailable or a separate snapshot is explicitly useful;
- `github-operations`: single gateway for any GitHub-specific remote read or write. Downstream generic skills must not invoke GitHub tools, create/update Issues or PRs, publish review comments, or run `git push` directly.

Do not treat helper skills as competing note types.

# Specialized Front-End Skills

## `book-operation-manual-extract`

Use before `note-operation-manual` when the source is a book chapter, reading note, tutorial note, or book-specific project context and the user wants durable executable procedures.

This front-end decides:

- what is truly operational;
- what should remain in the source note;
- whether an existing manual should be updated;
- what can be deduplicated, merged, skipped, or linked.

Then use `note-operation-manual` for the final note structure.

Typical signals:

- “从书籍笔记里提取操作手册”;
- “从阅读笔记里抽取可复用步骤”;
- “只提取未来能直接执行的命令和代码块”;
- “先查已有笔记去重”;
- “如果已有同主题手册，就更新已有笔记”.

## `source-walk` Before `note-code-walkthrough`

Use `source-walk` first only when:

- the user explicitly wants a separate source snapshot;
- the final note writer cannot inspect the repository directly;
- repository evidence must be reconstructed into a temporary packet before materialization.

Default route:

```text
source-walk snapshot
→ note-code-walkthrough materialize-mode
```

Do not require `source-walk` when `note-code-walkthrough` can inspect the repository directly in `repository-mode`.

# Input Source And Mode

## `transform-mode`

Use when the user provides or points to an existing Markdown note that should be rewritten, reorganized, or converted.

Signals:

- “改造这篇旧笔记”;
- “优化这个 md”;
- “把这篇笔记转成……”;
- “基于这个已有笔记整理”;
- “重写这篇归档文档”.

Inspect the current note and nearby vault conventions, select the primary shape, and proceed when the target file is clear.

## `materialize-mode`

Use when the source is:

- current chat context;
- terminal output;
- experiment output;
- screenshots or pasted configuration;
- a solved support conversation;
- current analysis or review notes;
- a temporary source snapshot;
- several scattered explanations that should become a new durable note.

Signals:

- “把刚才这轮归档成笔记”;
- “生成一篇笔记”;
- “沉淀成文档”;
- “把这个实验结果归档”;
- “把刚才讲的概念整理成笔记”;
- “把这个操作记下来”.

Default: infer and proceed.

## `repository-mode`

Use when the primary source of truth is a local checkout, repository evidence packet, branch, tag, commit, or remote repository and the requested durable artifact is a repository-grounded code walkthrough.

When the source exists only on GitHub, route remote retrieval through `github-operations` first. The selected note skill consumes returned repository evidence and must not invoke GitHub tools directly.

Resolve when available:

- repository root;
- branch, tag, or commit;
- target symbol or module;
- callers and owners;
- dependencies;
- tests;
- build or verification status.

Then use `note-code-walkthrough` directly.

# Primary Note Types

Choose exactly one primary type unless the user explicitly asks for multiple artifacts.

Supporting material from other shapes may appear inside the selected note when it serves the main reading intention.

## 1. `note-cognitive-convergence`

Future reading question:

> 这个概念到底应该怎样理解？

Use when the main asset is a stable mental model of a protocol, mechanism, abstraction, theory, engineering concept, conceptual comparison, boundary, or common misconception.

Signals:

- definition plus mechanism;
- entities, responsibilities, and state change;
- “A 和 B 有什么区别”;
- assumptions, invariants, boundaries, and counterexamples;
- a need to reorganize fragmented explanations around reader cognition;
- pure or primarily conceptual discussion without one concrete repository implementation as the center.

Typical cognitive path:

```text
reader confusion
→ core model
→ whole-picture relationship
→ objects and responsibilities
→ mechanism and state change
→ boundaries and misconceptions
→ neighboring concepts
→ complete recombination
```

Do not route a concept discussion to `note-linear-achievement` merely because the concept was learned through several questions.

## 2. `note-linear-achievement`

Future reading question:

> 当时是怎样一步步达到结果的？

Use when the exploration journey itself is the durable asset:

- attempts;
- failed concrete attempts;
- observations;
- turning points;
- changes in hypothesis;
- the final achieved path;
- a post-hoc reconstruction of how a difficult result was reached.

Do not use it as a default for every long chat or every sequence of commands.

The existence of chronology is not enough. Choose it only when preserving chronology helps future review.

## 3. `note-conclusion-evidence`

Future reading question:

> 结论是什么，依据是否可靠？

Use when the main value is:

- benchmark conclusions;
- factual claims and verification;
- system-state diagnosis with decisive evidence;
- comparisons backed by metrics;
- experiment results;
- proof, source snippets, raw commands, outputs, or screenshots supporting a conclusion.

The opening should prioritize conclusions and allow later drill-down into evidence.

## 4. `note-operation-manual`

Future reading question:

> 现在怎样把这件事做成；偏离成功路径后怎样回来？

Use when the source provides or supports one minimum complete operational loop:

```text
trigger scenario
+ applicable starting state
+ verified happy path
+ acceptance state
```

Signals:

- setup, configuration, maintenance, recovery, migration, upgrade, removal, or fixed execution;
- copyable commands or exact UI actions;
- a solved ChatGPT operation question worth repeating later;
- a known success state;
- local troubleshooting that returns to the happy path;
- rollback, cleanup, or recovery.

For a solved troubleshooting conversation, default to `note-operation-manual` when the future value is repeating the successful procedure. Convert useful failures into symptom-indexed branches rather than preserving them as the mainline.

## 5. `note-code-walkthrough`

Future reading question:

> 这个具体实现从应用调用到内部状态和测试到底怎样运行？

Use when the main subject is one concrete class, module, component, or tightly scoped implementation mechanism grounded in repository evidence.

Signals:

- repository, branch, tag, commit, class, module, or component;
- callers and application call chain;
- real public usage;
- constructor and destructor;
- public and private methods;
- member-state changes;
- ownership and lifecycle;
- state-machine branches;
- fixtures, harnesses, tests, and coverage.

Do not route a repository-backed implementation walkthrough to a generic concept note merely because it teaches a concept.

# Direct Routing Order

Use this order to resolve common ambiguities. The first matching condition must still reflect the user's future reading intention.

## A. Concrete Implementation Model

If one concrete repository implementation, its callers, lifecycle, state, and tests are central:

```text
→ note-code-walkthrough
```

## B. Repeatable Successful Operation

If the reader mainly needs to perform one known task again:

```text
→ note-operation-manual
```

This takes priority over process history when the original conversation was long but the reusable asset is the final procedure.

## C. Conclusion And Proof

If the main asset is a claim, result, diagnosis, comparison, metric, or experiment conclusion and its evidence:

```text
→ note-conclusion-evidence
```

## D. Stable Mental Model

If the main asset is understanding a concept, mechanism, distinction, boundary, or misconception:

```text
→ note-cognitive-convergence
```

## E. Exploration Journey

If the process itself must be preserved for later review:

```text
→ note-linear-achievement
```

Linear achievement is not a generic fallback for every archive. Use it only when chronology has durable value.

# Solved Troubleshooting Routing

Long troubleshooting chats often contain all five kinds of material. Route by the future use.

## Default To Operation Manual

Choose `note-operation-manual` when:

- the problem is solved;
- a repeatable happy path can be reconstructed;
- future use is “do this again” or “recover this state again”;
- failed attempts can be compressed into local symptom branches.

## Choose Linear Achievement

Choose `note-linear-achievement` when:

- the user explicitly wants the full debugging journey;
- changing hypotheses and observations are important for future reasoning;
- the final procedure alone would lose the main lesson.

## Choose Conclusion Evidence

Choose `note-conclusion-evidence` when:

- the main asset is the root cause;
- specific evidence rules alternatives in or out;
- the operational fix is secondary to the diagnosis.

## Choose Cognitive Convergence

Choose `note-cognitive-convergence` when:

- the troubleshooting discussion primarily clarified a reusable mechanism;
- the commands were only examples supporting conceptual understanding.

## Choose Code Walkthrough

Choose `note-code-walkthrough` when:

- the diagnosis required tracing one implementation through source and tests;
- the durable artifact should explain current code behavior rather than the incident chronology.

# Atomicity And Number Of Outputs

## One Primary Responsibility

Each note should have one central future-reading responsibility.

Do not create several notes merely because the source contains several headings, tools, concepts, or failed attempts.

Do not combine several unrelated future uses into one supernote.

Apply the selected skill's own split rules, especially:

- minimum complete operational loop for operation manuals;
- one cognitive thesis for cognitive convergence;
- one implementation subject for code walkthroughs;
- one conclusion family for conclusion-evidence notes;
- one coherent achievement journey for linear notes.

## Default To One Artifact

When several shapes could support the same topic:

- choose one primary note;
- include supporting explanation, evidence, commands, or history only as subordinate sections;
- do not create companion notes preemptively;
- create additional notes only when they have independent future reading intentions and meet the selected skill's split admission rules.

# Tie-Breaking Rules

1. The user's explicit future-use statement overrides all heuristics.
2. A concrete repository implementation model routes to `note-code-walkthrough` rather than a generic concept note.
3. A repeatable happy path routes to `note-operation-manual` rather than `note-linear-achievement`, unless the user explicitly wants the full journey.
4. A conclusion whose credibility depends on metrics or raw evidence routes to `note-conclusion-evidence`.
5. A protocol, mechanism, abstraction, or conceptual comparison routes to `note-cognitive-convergence`, not linear achievement.
6. Preserve chronology only when chronology itself teaches something durable.
7. The presence of commands does not automatically imply an operation manual.
8. The presence of failures does not automatically imply a linear achievement note.
9. The presence of code does not automatically imply a code walkthrough.
10. The presence of a conclusion does not automatically imply conclusion-evidence; every useful note has conclusions.
11. Choose one primary shape and treat other material as supporting content.
12. If uncertainty remains but one route is clearly more useful for future rereading, proceed with that route and report the assumption afterward.

# Routing Table

| Input source | Future reading intention | Target skill | Mode |
|---|---|---|---|
| Existing note | Understand a concept or mechanism | `note-cognitive-convergence` | `transform-mode` |
| Existing note | Preserve the achievement journey | `note-linear-achievement` | `transform-mode` |
| Existing note | Preserve conclusions and proof | `note-conclusion-evidence` | `transform-mode` |
| Existing note | Repeat one operational loop | `note-operation-manual` | `transform-mode` |
| Existing code note | Understand current implementation | `note-code-walkthrough` | `transform-mode` |
| Book or reading note | Extract reusable procedures | `book-operation-manual-extract` → `note-operation-manual` | `transform-mode` |
| Current context | Understand a concept or mechanism | `note-cognitive-convergence` | `materialize-mode` |
| Current context | Preserve the achievement journey | `note-linear-achievement` | `materialize-mode` |
| Current context | Preserve conclusions and proof | `note-conclusion-evidence` | `materialize-mode` |
| Current context | Repeat one operational loop | `note-operation-manual` | `materialize-mode` |
| Current context or source snapshot | Understand current implementation | `note-code-walkthrough` | `materialize-mode` |
| Repository / branch / tag / commit | Understand current implementation | `note-code-walkthrough` | `repository-mode` |
| Repository evidence packet required first | Understand current implementation | `source-walk` → `note-code-walkthrough` | snapshot → `materialize-mode` |

# Short Archive Request Examples

When the user says only “归档”, infer from the active topic:

| Active context | Default route |
|---|---|
| Solved OpenClash, WSL2, NAS, CLI, or configuration procedure | `note-operation-manual` |
| Redis benchmark, latency experiment, system-state evidence, or comparison result | `note-conclusion-evidence` |
| Token bucket, semaphore, ABI, multiplexing, backpressure, or other concept discussion | `note-cognitive-convergence` |
| Concrete class/module source analysis with callers, state, and tests | `note-code-walkthrough` |
| A debugging or implementation journey whose attempts and turning points must be preserved | `note-linear-achievement` |

# Route Decision Output

## Normal Archive Execution

Do not output a separate route-selection questionnaire.

Select the route, invoke the target skill, write or transform the note, and return the target skill's completion report.

## When Clarification Is Required

Use a compact decision packet:

```markdown
## 路线判断

- 输入来源：已有笔记 / 当前上下文 / 代码仓库
- 当前归档范围：...
- 推荐类型：认知收敛型 / 线性达成型 / 结论证据型 / 操作手册型 / 代码走读型
- 执行模式：transform-mode / materialize-mode / repository-mode
- 目标 Skill：`<skill-name>`
- 无法直接执行的冲突：...
- 需要确认：<one focused question>
```

Do not present several template choices when one can be inferred.

## When The User Asks Only For Route Analysis

If the user explicitly asks what type a future note should use but does not ask to write it, return:

```markdown
## 路线判断

- 输入来源：...
- 推荐类型：...
- 执行模式：...
- 目标 Skill：...
- 理由：
  - ...
- 前置或辅助 Skill：...
- 主要边界：...
```

Do not modify files unless requested.

# Static Acceptance Examples

The following requests should route consistently:

| Request | Expected route |
|---|---|
| “归档刚才 OpenClash 的成功配置，以后照着做” | `note-operation-manual` |
| “完整归档这次路由器断网排查过程，包括每次转折” | `note-linear-achievement` |
| “归档 Redis 网络延迟实验结论和原始数据” | `note-conclusion-evidence` |
| “归档令牌桶和信号量限流的区别，重点让我以后别混淆” | `note-cognitive-convergence` |
| “归档 TCPConnection 的调用链、成员状态和测试” | `note-code-walkthrough` |
| “归档” after a solved WSL2 configuration thread | `note-operation-manual` |
| “归档” after a pure concept discussion | `note-cognitive-convergence` |
| “归档” after a benchmark interpretation | `note-conclusion-evidence` |

# Final Router Check

Before handing off, verify:

1. Did an archive trigger enter this router?
2. Is the input source correctly classified?
3. What will the future reader want to do first?
4. Is exactly one primary note type selected?
5. Is the mode correct?
6. Are required helper or front-end skills included?
7. Is clarification truly necessary, or can the route be inferred?
8. Will the selected note preserve one coherent responsibility without over-splitting?
9. Does every referenced target skill exist?
10. Has generic summarization been avoided?
