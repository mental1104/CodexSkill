---
name: note-cognitive-convergence
description: Create or transform Obsidian concept notes that reorganize fragmented explanations into one stable reader-centered mental model. Use for protocols, mechanisms, theories, abstractions, engineering concepts, conceptual comparisons, and learning notes where the future reader wants to understand what something is, how it works, why neighboring concepts differ, where the model stops applying, and how to restate it without replaying the original conversation or learning order.
---

# Note Cognitive Convergence

## Role

Create or transform a concept note that helps the user's future self converge from fragmented facts, partial analogies, and likely misunderstandings into one stable and transferable mental model.

The document follows cognitive dependency, not:

- chat chronology;
- textbook chapter order;
- source-file order;
- historical discovery order;
- the order in which facts happened to be collected.

The central question is:

> What sequence of explanations gives the reader the least confusing path to a correct model?

Default cognitive direction:

```text
current ambiguity or likely misconception
→ one-sentence core model
→ whole-picture scenario or relationship map
→ essential objects and responsibilities
→ mechanism and state change
→ boundaries and invariants
→ contrast with neighboring concepts
→ positive and negative examples
→ recombine the complete scenario
→ final restatable model
```

This is not a mandatory heading list. Reorder or omit sections when another sequence reduces cognitive load better.

## Modes

### `transform-mode`

Use when an existing Markdown note is being rewritten as a concept note.

Required actions:

1. identify the note's single conceptual thesis;
2. identify assumptions the reader must understand first;
3. locate contradictions, duplicated explanations, and mixed abstraction levels;
4. move the highest-value mental model near the beginning;
5. replace chronology with cognitive dependency;
6. preserve useful examples, diagrams, equations, evidence, and source links;
7. add boundaries, counterexamples, or comparisons where they prevent predictable misunderstanding;
8. check whether the note is too broad or has been split into unusable fragments;
9. end with a compact model the future reader can restate.

Do not preserve a weak structure merely because the existing note already uses it.

### `materialize-mode`

Use when the source is current chat context, reading notes, scattered explanations, examples, experiment observations, or several related questions about one concept.

Required extraction order:

```text
reader's actual confusion
→ stable claims supported by the source
→ minimum prerequisite model
→ central mechanism
→ boundaries and contrasts
→ examples that test the model
→ unresolved uncertainty
```

Do not archive the question-and-answer sequence as the document structure. Convert it into a coherent model.

## Use When

Use this skill when the future reader wants to understand:

- what a protocol, mechanism, abstraction, algorithmic idea, or engineering concept actually means;
- which entities participate and what responsibilities they have;
- how information, control, state, ownership, or resources move;
- why an intuitive but incomplete explanation fails;
- how two neighboring concepts differ;
- which properties are essential and which are implementation details;
- what assumptions, invariants, limits, and failure boundaries define the concept;
- how to apply the concept to a new scenario;
- how to explain the idea again without reopening the original sources.

Typical subjects:

- token bucket versus semaphore concurrency limiting;
- TCP flow control versus congestion control;
- HTTP/2 multiplexing;
- C ABI and C++ ABI stability;
- Redis SDS or compact encodings as concepts rather than one repository implementation;
- acknowledgement, retry, dead-letter queues, idempotency, backpressure, consistency, or ownership;
- language and runtime mechanisms explained above any one codebase.

Typical signals:

- “这个概念到底是什么”;
- “讲清楚它的运行机制”;
- “它和另一个概念有什么区别”;
- “我总是容易把这两个东西混淆”;
- “把刚才的概念讨论归档”;
- “按读者最好理解的顺序整理”;
- “形成一个稳定心智模型”;
- “不要按聊天顺序写”.

## Avoid

Use another primary skill when the future-reading intention is different:

- use `note-operation-manual` when the reader mainly wants to perform a repeatable operation;
- use `note-linear-achievement` when the exploration path and turning points are themselves the durable asset;
- use `note-conclusion-evidence` when the main value is a conclusion and its verification;
- use `note-code-walkthrough` when the subject is how one concrete repository implementation works through callers, lifecycle, state, and tests.

A concept note may use code, experiments, commands, implementation snippets, or operational examples, but they are evidence or illustrations. Its center thesis is the conceptual model.

## Required Companion Skills

When writing into the Blue Espeon Obsidian vault:

- use `blue-espeon-note-style` for placement, naming, backlinks, Mermaid conventions, and single-thesis boundaries;
- use `obsidian-frontmatter-metadata` as a required final metadata check;
- use `latex-math-writing` when mathematical notation appears.

Do not create dead wikilinks. Explain a small prerequisite inline unless it already has a useful durable note or clearly deserves one.

# Reader-Centered Principles

## 1. Start From The Reader's Confusion

Before writing, identify what is likely unclear:

- an overloaded term;
- two concepts being conflated;
- a missing prerequisite relationship;
- an analogy being taken too literally;
- a mechanism being memorized without understanding its state changes;
- implementation details being mistaken for the concept itself.

The note should resolve that ambiguity early rather than hide it behind broad background.

## 2. Give A Core Model Before Exhaustive Detail

The opening should normally provide:

1. a one-sentence definition or central model;
2. one whole-picture scenario, relationship map, table, or minimal example;
3. the main distinction the reader must not miss.

Do not open with a long history, generic motivation, or a dictionary definition that does not support later reasoning.

## 3. Follow Cognitive Dependency

Explain an item before it is required by the next important explanation.

Good:

```text
what the resource is
→ who owns or limits it
→ what state is tracked
→ how one event changes the state
→ what happens at the boundary
```

Bad:

```text
advanced exception
→ implementation detail
→ historical origin
→ basic definition
→ unrelated comparison
```

## 4. Preserve Abstraction Levels

Keep distinct:

- concept;
- mechanism;
- policy;
- implementation;
- operational configuration;
- observed behavior in one experiment.

When crossing levels, state the relationship explicitly.

Example:

```text
Concept: backpressure prevents producers from overwhelming downstream capacity.
Mechanism: a bounded queue blocks, rejects, or slows admission.
Implementation: this library returns a specific error when the queue is full.
Configuration: the queue capacity is set to 1,000.
```

Do not present one implementation choice as the universal definition.

## 5. Use Comparisons To Sharpen Boundaries

A comparison is useful only when it answers a real confusion.

Prefer comparison dimensions such as:

- controlled resource;
- state being tracked;
- admission condition;
- time behavior;
- ownership;
- feedback signal;
- failure mode;
- appropriate use case.

Do not create a decorative “A versus B” table when the concepts are not genuinely confusable.

## 6. Use Counterexamples Deliberately

A counterexample should expose where an incomplete model fails.

Preferred pattern:

```text
naive model
→ scenario where it predicts the wrong result
→ missing condition
→ corrected model
```

Do not collect edge cases without explaining which part of the model they refine.

## 7. Recombine The Model

After explaining parts, return to one complete scenario and walk through it using the final vocabulary.

The reader should be able to answer:

- what enters the system;
- what state exists before the event;
- which rule applies;
- what changes;
- what output or next state results;
- which boundary or invariant was preserved.

A note that explains every term separately but never recombines them has not converged.

# Evidence And Honesty Rules

Distinguish clearly between:

- **definition or standard fact**: grounded in a specification, authoritative source, or stable domain definition;
- **mechanistic explanation**: a causal model supported by the source;
- **teaching analogy**: useful but intentionally incomplete;
- **implementation example**: true for one system, library, version, or repository;
- **experiment observation**: observed under a specific setup;
- **assistant inference**: a synthesis that should be labeled when not directly stated by the evidence;
- **open uncertainty**: unresolved or conflicting information.

Never turn an analogy into a definition. Never generalize one implementation without evidence. Never invent a clean boundary where the domain genuinely has competing terminology.

# Atomicity And Split Rules

## One Cognitive Thesis

A concept note should answer one central question or establish one coherent mental model.

Good thesis examples:

- how a token bucket represents rate and burst capacity;
- why a semaphore limits concurrent occupancy rather than request rate;
- how HTTP/2 multiplexes streams over one connection;
- why C ABI is easier to stabilize than C++ ABI.

A note may include prerequisites, comparisons, examples, boundaries, and implementation evidence when they all support that thesis.

## Do Not Split By Vocabulary Alone

Do not create separate notes merely because the explanation contains several related terms.

Keep terms together when separating them would prevent the reader from understanding the relationship that gives them meaning.

For example, acknowledgement, retry, idempotency, and dead-letter queues may belong in one note when the thesis is a complete message-failure handling model. They may deserve separate notes later only when each develops an independent reusable thesis.

## Split Admission Rule

Split a candidate section when at least one strong condition applies:

- it answers a different central question;
- it has a different abstraction level and substantial independent depth;
- it is reusable across several concept notes without relying on the current context;
- keeping it inline causes the original thesis to disappear;
- it requires its own complete set of model, mechanism, boundaries, and examples.

Do not split when the reader would have to open several tiny notes to reconstruct one inseparable model.

## Anti-Supernote Rule

Reconsider scope when:

- the title joins unrelated concepts with “and”;
- several sections each have their own one-sentence core model;
- the note mixes protocol theory, repository implementation, operational commands, experiment history, and product decisions as peer topics;
- different readers would open different sections for unrelated reasons;
- no single final scenario can recombine the whole note.

Length is only a warning signal. Cognitive unity is the deciding factor.

# Investigation Workflow

## 1. State The Intended Mental Model

Before writing, formulate:

```text
After reading, the reader should be able to explain:
<one compact concept or relationship>
```

If the sentence requires unrelated clauses, narrow the scope.

## 2. Identify The Reader's Starting Point

From the source material, determine:

- what the user already understands;
- which terminology is familiar;
- which mistaken assumption triggered the discussion;
- which prerequisite must be established inline;
- which detail can remain optional.

Do not write a generic textbook chapter for an already technical reader.

## 3. Build A Concept Map

Collect only the elements necessary to explain the thesis:

- entities;
- responsibilities;
- state;
- inputs and outputs;
- causal transitions;
- invariants;
- boundaries;
- neighboring concepts;
- representative examples;
- counterexamples.

Then order them by dependency.

## 4. Choose The Whole-Picture Artifact

Near the beginning, prefer one artifact that carries the model:

- a small Mermaid relationship or state diagram;
- a lifecycle or data-flow diagram;
- a comparison table;
- one complete scenario;
- a minimal code example;
- an equation with variable meaning;
- a before-and-after state table.

Use diagrams to reduce cognitive load, not decorate the note.

## 5. Explain The Mechanism

For each important transition, answer:

- what triggers it;
- what state is read;
- which rule is applied;
- what state changes;
- what output or side effect follows;
- what invariant remains true.

Prefer causal language over vague phrases such as “the system handles it.”

## 6. Audit Boundaries And Misconceptions

Before finishing, ask:

- Which nearby concept is most likely to be confused with this one?
- Which teaching analogy could mislead the reader?
- Which implementation detail is being mistaken for a definition?
- Which case does the simple model fail to predict?
- Which assumptions must be stated explicitly?

## 7. Recombine And Compress

End the main explanation by applying the final model to a complete scenario.

Then provide a compact restatement, checklist, or comparison that makes later review fast.

# Default Note Shape

Use the following as a flexible default, not a mandatory fixed outline:

```markdown
## AI摘要

<one-sentence model, main distinction, and practical meaning>

## 正文

### 核心模型

<one-sentence definition or causal model>

<whole-picture diagram / scenario / comparison>

### 先建立哪些对象与关系

<minimum prerequisites and responsibilities>

### 机制如何运转

<trigger → state read → rule → state change → result>

### 最容易误解的地方

<naive model → failing case → corrected model>

### 与相邻概念的边界

| 维度 | 概念 A | 概念 B |
|---|---|---|
| ... | ... | ... |

### 完整场景重组

<walk through one end-to-end scenario using the final model>

### 最终可复述模型

- ...
- ...
- ...

### 证据、实现示例与来源

<optional supporting material>
```

Omit or rename sections when another structure improves the reading path.

# Diagram Rules

Use Mermaid when it clarifies:

- relationships;
- state transitions;
- control or data flow;
- lifecycle;
- decision boundaries.

Prefer 5-9 nodes. Split large diagrams. Explain what to observe before or after the diagram.

Do not use Mermaid for flat definitions, decorative summaries, or content that is clearer as a two-column table.

# Example Rules

Examples should test the model rather than merely repeat prose.

Prefer:

- one minimal positive example;
- one boundary or counterexample;
- one complete recombination scenario.

For code examples:

- use complete minimal examples when execution matters;
- mark implementation-specific behavior;
- do not let boilerplate obscure the concept;
- distinguish illustrative pseudocode from verified real code.

# Math Formatting Rule

If the generated or transformed note contains LaTeX math, also use `latex-math-writing`.

The note shape still follows `note-cognitive-convergence`, while all inline and block math must satisfy the math-writing rules.

# Frontmatter Metadata Check Rule

Before finishing any generated or transformed Obsidian note, also use `obsidian-frontmatter-metadata` as a required check.

The YAML frontmatter must use valid top-level `summary`, `aliases`, and `tags` fields and follow the target vault's established template.

# Output Policy

After creating or editing the note, respond with:

```markdown
## 完成情况

- 类型：认知收敛型
- 模式：transform-mode / materialize-mode
- 文件：`<path>`
- 中心认知：
  - ...
- 主要认知路径：
  - ...
- 重点边界或误区：
  - ...
- 拆分判断：未拆分 / 已拆分 + 理由
- 证据状态：已验证 / 来源支持 / 部分推断
- 不确定点：
  - ...
```
