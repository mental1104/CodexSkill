---
name: technical-document-optimization
description: Optimize Obsidian technical notes and old engineering documents from an article-lifecycle perspective, especially notes that include code paths, implementation analysis, tests, screenshots, Mermaid diagrams, project-structure maps, YAML frontmatter, wikilinks, curated extension-reading links, and code archive/explanation. Use when the user asks to improve a technical note, code explanation note, algorithm/data-structure note, implementation archive, test explanation, screenshot-heavy code note, or technical document readability while preserving the original body.
---

# Technical Document Optimization

Use this skill to review and transform technical Obsidian notes into readable, maintainable technical documentation. It combines old-note lifecycle review, Obsidian Markdown conventions, code explanation, implementation archiving, and test-case explanation.

## Core Rules

- Diagnose before editing unless the user explicitly confirms direct changes.
- Preserve the original body and intent. Do not rewrite into marketing, textbook, or blog style.
- Add new explanatory prose directly in normal Obsidian Markdown. Do not visually mark additions unless the user explicitly asks.
- Code blocks copied from source should stay in fenced code blocks; explanatory prose around them should also use normal Markdown.
- Prefer direct, searchable, reusable wording.
- Do not introduce external facts into explanatory prose unless the user provided them or they are verified from local source files. Curated external reading links are allowed only after web verification and must stay clearly separated from the note's own explanation.
- If images exist, explain what each image means and how it connects the previous and next paragraphs.
- Use wikilinks only for truly relevant prerequisites or related notes.
- If a section is only a broad concept and no local detailed note, wikilink, source file, or test can support it, add concise verified extension-reading resources instead of inventing details.
- Prefer non-linear, total-to-detail organization for archive-style technical notes: conclusions first, verification paths next, source/output archives near the end.
- Keep implementation analysis at the end after conceptual and business intuition is established.

## Diagnosis Stage

When the user provides a note path or content, first inspect the note and any referenced local source/test files. Then output:

````markdown
# 旧笔记改造建议

## 总体判断

这篇笔记目前的问题是：

## 需要修改的地方

### 1. xxx

- 问题：
- 为什么需要改：
- 建议怎么改：

## 可能缺失的前置知识

- [[xxx]]
  - 缺失原因：
  - 建议补充位置：

## 可能需要扩展阅读的宽泛小节

| 小节 | 缺少的细节 | 本地笔记/源码是否足够 | 建议资料方向 |
|---|---|---|---|
| xxx | 只解释概念名，没有机制、例子、边界或实现细节 | 不足 | 官方文档 / 经典论文 / 高质量工程文章 |

## 建议更新的 YAML Front Matter

```yaml
---
title:
summary:
tags:
  -
aliases:
  -
related:
  - "[[]]"
created:
updated:
---
```
## 建议新增 Mermaid 图

| 插入位置 | 图类型 | 解释目标 | 数据来源 | 是否必要 |
|---|---|---|---|---|
| xxx 段落之后 | sequenceDiagram | 解释线程竞争顺序 | 代码 / 笔记内容 | 必要 |

## 等待确认

请确认是否按以上方案改造。
````

If the user has already confirmed, proceed to edit.

## Required Note Structure

For technical notes, prefer this order:

1. YAML frontmatter.
2. Title.
3. Summary callout.
4. Prerequisite callout if needed.
5. Plain-language concept explanation.
6. What problem this concept solves.
7. Suitable business or engineering scenarios.
8. Diagrams, images, and examples with bridging explanations.
9. Complexity, tradeoffs, advantages, and disadvantages.
10. Implementation and test analysis at the end.
11. Curated extension reading when broad sections lack local detailed notes.
12. Related links.

## Non-Linear Total-To-Detail Structure

Use this pattern for experiment notes, debugging notes, benchmark notes, code archive notes, and other documents where the reader should not need to scan every command or output linearly.

Preferred order:

1. Core conclusions.
2. Engineering/interview/decision wording when the note contains it.
3. Experiment environment or scope.
4. Conclusion verification process.
5. File structure or project map.
6. Archive section for dependencies, source code, commands, and raw outputs.
7. Related links.

Rules:

- Make the first conclusion section a navigation surface. Each conclusion must link to a concrete verification subsection in the same note.
- In Obsidian tables, never use wikilink alias syntax such as `[[#heading|alias]]`; the `|` breaks Markdown table parsing. Use `[[#heading]]: explanation` or put the wikilink outside the table.
- Place the verification process after environment/scope and before file structure/source archives. Each verification subsection should include the command or setup, key observed data, why the data supports the conclusion, and boundaries.
- Move source code, initialization commands, dependency installation commands, and raw terminal outputs into one archive section near the end. The body explains; the archive preserves evidence and reproduction material.
- Move engineering conclusions, interview wording, or decision summaries near the core conclusions, not after raw execution details.
- Remove empty future-work, TODO, or "next plan" sections from archive notes unless the user explicitly asks to keep them.
- Preserve original data, code, and outputs. Do not invent new measurements to complete the structure.

Suggested skeleton:

```markdown
### 1. 核心结论

|结论|关键证据|边界|
|---|---|---|
|[[#4.2 具体验证小节]]：结论文字|关键指标或输出|适用范围和限制|

### 2. 工程结论 / 面试表达

### 3. 实验环境

### 4. 结论验证过程

#### 4.1 验证基线

#### 4.2 具体验证小节

### 5. 文件结构

### 6. 归档：依赖、源码与原始输出
```

## YAML Frontmatter

Create or update:

```yaml
---
title: 笔记标题
summary: 用一到三句话说明这篇笔记解决什么问题、核心结论是什么
tags:
  - 标签1
  - 标签2
aliases:
  - 可能会搜索到的别名1
related:
  - "[[相关笔记1]]"
created:
updated: YYYY-MM-DD
---
```

Rules:

- `title`: clear and searchable.
- `summary`: explain what the note solves, what it covers, and the core conclusion.
- `tags`: only theme/use tags, no status/source tags.
- `aliases`: search anchors, old titles, common Chinese/English names.
- `related`: only strongly related notes.
- `created`: preserve existing value if present, otherwise leave blank.
- `updated`: current date.

## Concept And Intuition

Before formulas, interfaces, or implementation:

- Explain the concept in plain language a beginner can understand.
- Add a section such as `## 先用白话理解 xxx`.
- Add a section such as `## xxx 解决了什么问题`.
- If useful, add real-world/business cases under `## 什么业务适合建模成 xxx`.
- Include a warning section for unsuitable cases if misuse is likely.

## Curated External Reading

Use this only when the original note names a broad concept but lacks local detailed notes, code, tests, diagrams, or concrete examples that can support a real explanation.

Procedure:

1. Search the vault and referenced source/test files first. Prefer local wikilinks and local implementation evidence when they are specific enough.
2. If local materials are missing or only repeat the same broad concept, browse the web and verify current, high-quality resources before adding links.
3. Prefer official documentation, standards or specifications, canonical papers, mature project docs, university course material, or well-known engineering writeups. Avoid SEO summaries, low-context snippets, unmaintained tutorials, and generic AI-generated pages.
4. Add 2-5 links maximum for one topic. Each item should include the resource title, source/site, URL, and one short sentence explaining which gap it fills.
5. Place resources directly after the weak section when only one section needs help, or in a final `## 扩展阅读` section before related links when several sections need help.
6. Do not fold claims from these sources into the note body unless the claim is separately verified and necessary for the note's core explanation.

Example format:

```markdown
## 扩展阅读

原笔记对 xxx 只停留在概念层，本地 vault 中暂时没有足够细的配套笔记；以下资料用于补足机制、边界和实现视角。

- [Resource title](https://example.com) - 说明这份资料补的是机制、例子、实现、边界条件或对比中的哪一块。
```

## Images, Callouts, And Mermaid

Use images, callouts, and Mermaid as inline explanation tools, not decorative blocks.

### Image Rules

* Every existing image should have surrounding prose:

  * before the image: explain what the reader should look at;
  * after the image if needed: explain what conclusion follows.
* For screenshots of code, terminals, diffs, or IDE snippets, infer and explain the underlying code path from nearby text and local source files. Do not leave screenshot-only explanations.
* When several screenshots show fragments of one implementation, add a short `read-the-images` section that groups them into one coherent implementation map.

### Callout Rules

Use callouts sparingly for memory hooks, prerequisites, warnings, and summaries:

* `[!summary]`
* `[!note]`
* `[!tip]`
* `[!warning]`

Do not use callouts as decoration. A callout must reduce cognitive load.

### Mermaid As Technical Narrative

Use Mermaid when it clarifies one of these:

* structure: what objects, modules, files, states, or resources exist;
* flow: how control, data, requests, syscalls, or events move;
* transition: how state changes before and after an operation;
* contention: who owns, waits for, blocks, wakes, or retries;
* mapping: how business objects map to technical structures;
* validation: which tests verify which contracts.

A Mermaid diagram should answer one concrete reader question. Do not create broad encyclopedia-style diagrams.

### Placement Rules

* Put Mermaid directly next to the paragraph it explains.
* Add one short paragraph before the diagram explaining what to observe.
* Add one short paragraph after the diagram explaining the key conclusion.
* Prefer several small diagrams over one large diagram.
* If a diagram exceeds about 12 nodes or 20 edges, split it.
* Do not place all Mermaid diagrams at the end unless they are summary maps.

### Diagram Type Selection

Prefer the Mermaid diagram type that matches the explanation:

* `flowchart`: project structure, dependency maps, build/test pipelines, call graphs, scheduler flow, data processing pipelines;
* `sequenceDiagram`: runtime request flow, API calls, syscalls, lock acquisition order, race-condition interleavings;
* `stateDiagram-v2`: lifecycle, process/thread states, object modes, connection states, cache entry states;
* `classDiagram`: structs/classes, interfaces, ownership, composition, data-source relationships;
* `graph`: resource ownership, wait-for graphs, trees, data-structure snapshots, topology maps;
* `mindmap`: concept grouping, feature scope, note outline, newly added content map.

Do not default everything to `flowchart`.

### Snapshot Narrative For Data Structures And Algorithms

For algorithms or data structures, prefer snapshot diagrams.

Common snapshot order:

1. operation starts;
2. temporary intermediate state;
3. invariant violation or key decision point;
4. repair/rebalance/cleanup;
5. final valid state.

Examples:

* AVL / red-black tree:

  * before insert/delete;
  * after normal BST operation;
  * first unbalanced node;
  * rotation or recoloring;
  * final balanced tree.
* Hash table:

  * before collision;
  * after collision handling;
  * resize or rehash;
  * final bucket layout.
* Queue / stack / heap:

  * before mutation;
  * mutation point;
  * invariant restoration;
  * final state.

Each snapshot should focus on one invariant, such as height, balance factor, color, heap order, reference count, ownership, or visibility.

### Snapshot Narrative For Operating System Concepts

For OS and concurrency notes, prefer diagrams that show ownership, waiting, and state transitions.

Use:

* `stateDiagram-v2` for process/thread lifecycle:

  * ready;
  * running;
  * blocked;
  * terminated.
* `sequenceDiagram` for lock competition and race conditions:

  * thread A reads;
  * thread B reads;
  * thread A writes;
  * thread B overwrites.
* `graph` for deadlock and wait-for relationships:

  * thread owns lock A;
  * thread waits for lock B;
  * cycle means deadlock.
* `flowchart` for scheduler, syscall, interrupt, page fault, or I/O flow.
* paired diagrams for wrong path vs correct synchronized path.

For concurrency explanations, do not try to enumerate every possible interleaving. Show the representative bad interleaving and the corrected synchronization path.

### Mermaid For Code And Tests

For implementation-heavy notes:

* Add a project-structure map when several files are involved.
* Add a call graph when functions delegate across files or classes.
* Add a data-flow graph when input is transformed through multiple stages.
* Add a state diagram when the implementation is controlled by mode, lifecycle, retry, timeout, or cache state.
* Add a sequence diagram when the implementation depends on call order, async behavior, lock order, RPC order, or callback order.
* Add a test coverage graph when tests are central to understanding correctness.

For code-diff notes, include at least one project-structure or content-map Mermaid diagram when several files are involved.

For test-driven notes, include a Mermaid coverage graph that maps tests to implementation contracts when it would help locate failures.

### Mermaid Style Rules For Obsidian

* Quote node labels when they include brackets, symbols, spaces, or code-like text.

  * Good: `A["A[i][j]"]`
  * Bad: `A[A[i][j]]`
* Avoid raw `&`, `<`, `>`, `*`, pointer syntax, and generic angle-bracket types inside labels when plain words are enough.
* Prefer short labels.
* Put detailed explanation in prose, not inside nodes.
* Use stable semantic node IDs such as `Parser`, `Cache`, `ThreadA`, `LockA`, not random letters when the diagram is large.
* Keep Mermaid fenced blocks balanced.
* Do not put prose-only markers inside Mermaid code blocks.
* Keep explanatory prose before and after Mermaid diagrams outside the Mermaid code block.

### Mermaid Quality Bar

A Mermaid diagram is useful only if it satisfies all of these:

* it explains a relationship that is hard to understand from prose alone;
* it is placed near the relevant explanation;
* it has a clear before/after or cause/effect meaning;
* it uses the right diagram type;
* it avoids excessive nodes and noisy labels;
* the surrounding prose explains how to read it.

If a diagram does not satisfy these, remove it and use prose instead.

## Implementation Analysis

Only use this section when code paths or implementation are part of the task.

Read the implementation file and relevant parent/abstract classes before writing. If a test path is provided, read it too.

When the existing note explains implementation mainly through screenshots, reconstruct the code narrative from the actual source tree before adding diagrams. Tie each diagram back to concrete files, functions, structs, or test names.

If the user asks to archive source code, integrate a small code repository into a note, or says the code is a single-file compilable unit rather than a project, use **Source Code Archive** for the final preservation section. This does not replace implementation analysis when the note also needs code understanding: add function/class-level implementation analysis in the relevant body sections, then keep the complete source files, paths, build commands, and run output together in the archive near the end.

Implementation section must be near the end and follow this pattern:

1. Source and test paths.
2. Interface/class declaration first.
3. Then each class member or function under its own third-level heading.
4. Under each heading:
   - paste the relevant function/class snippet;
   - explain what the function does;
   - connect it to the concept and complexity discussion;
   - mention which tests verify it when applicable.

Do:

- Include the complete public interface/class declaration if it helps orientation.
- Paste individual functions or small related snippets independently.
- Explain OOP relationships, inheritance, abstract methods, and interface contracts.
- Highlight why implementation choices match the note’s conceptual model.

Do not:

- Paste the entire source file as one block.
- Add line-by-line comments for every trivial expression.
- Put implementation analysis before the reader has conceptual intuition.
- Explain unrelated source code just because it is nearby.

## Source Code Archive

Use this mode when the user wants source code preserved inside an Obsidian note as an archive or runnable operation set, especially for small algorithm implementations, single-file compilable units, or code repositories that are not worth presenting as standalone projects.

The archive section itself is not implementation analysis. Do not split functions into explanatory subsections inside the archive, do not provide line-by-line commentary there, and do not replace the archive with selected snippets. Preserve the file contents as source artifacts and give only enough surrounding prose for navigation and reproduction.

When the user asks for both code archiving and explanation, or when the existing note needs code understanding to read linearly, use this combined structure:

1. In the main body, add implementation analysis next to the concept it explains. Break down important functions/classes, call order, data ownership, invariants, edge cases, and tests. Keep snippets focused or omit snippets if the full source will be archived later.
2. Near the end, add one Source Code Archive section that centralizes exact file paths, directory organization, complete source blocks, build/run commands, and actual outputs.
3. Do not scatter complete source files throughout the body. The body explains; the archive preserves and reproduces.

Place the archive near the end of the note, after the concept/algorithm explanation and close to the note's existing code section, but before related links.

Use this structure:

````markdown
## 源码归档：文件与最小运行集

这一节只做源码归档和最小运行说明，不做实现解析；上文已经解释了算法含义。

### 目录组织

说明这些文件在代码仓库中的相对角色。

```text
/absolute/or/repo/path/
├── file_a.ext   # role
└── file_b.ext   # role
```

### 文件：relative/or/base/file_a.ext

```language
<paste the source file content>
```

### 文件：relative/or/base/file_b.ext

```language
<paste the source file content>
```

### 实际编译、运行与输出记录

```bash
cd /repo/path
<build command>
```

```text
<actual build stdout/stderr, or "无输出，退出码 0">
```

```bash
<run command>
```

```text
<actual run stdout/stderr>
```

用一句话说明这组真实输出验证了什么；如果命令失败，记录失败输出、退出码和未完成原因。
````

Rules:

- Archive only the minimal file set needed to understand and reproduce the note's code. Do not paste unrelated repository scaffolding.
- Each pasted code block must be preceded by a heading that identifies the exact file it belongs to.
- Include a directory tree before the file blocks so the reader knows how files are organized.
- Compile and run the archived code yourself before finalizing the note. Record the actual command output immediately after each build/run command block.
- If a build command succeeds with no output, write `无输出，退出码 0` in the output block. Do not omit the output block.
- If compilation or execution fails, do not fabricate expected output; record the real failure output, exit code when available, and the blocker in a short prose note.
- Include the minimal compile/build command and minimal run command at the end as executable operations, followed by their recorded outputs.
- If a required dependency file is large or not part of the note's concept, list it in the directory tree and compile command; paste it only when needed for reproducibility or when the user explicitly asks for all files.
- Preserve source file contents faithfully. Do not silently fix code while archiving it; if there is a risk, add a short note after the commands.
- New prose uses normal Markdown; copied source code blocks remain faithful.

## Test Analysis

When tests are relevant, create a dedicated section. For each important test case include:

- test case name;
- test method;
- key code snippet;
- test idea;
- implementation contract being verified.

Prefer grouped test coverage:

- basic data-structure semantics;
- accessor and mutation invariants;
- algorithm/interface contract;
- special graph behavior or edge cases;
- file parsing or constructor variants;
- smoke tests.

Do not paste the entire test file. Only quote focused snippets.

When tests cover multiple implementation points, add a Mermaid coverage graph that maps each test or test group to the exact contract it verifies. Include failure-localization notes such as "if this test fails, inspect this function or state transition first."

## Validation Checklist

Before finishing:

- Frontmatter exists and fields are coherent.
- Added prose reads naturally in the note and is not visually marked unless requested.
- Title, summary, body, conclusion, and related links are consistent.
- A reader can read linearly without sudden unexplained concepts, and archive-style notes can also be read non-linearly from conclusions to verification details through wikilinks.
- Core conclusion tables link each conclusion to a concrete verification subsection and do not use `[[#heading|alias]]` inside Markdown tables.
- Verification sections sit before file/source/output archives, while raw commands, complete source blocks, and terminal outputs are centralized near the end.
- Empty future-work, TODO, or next-plan sections are removed unless the user explicitly requested them.
- Prerequisites are linked instead of over-explained.
- Broad concept sections without local detailed notes either link to specific local prerequisites or include a short verified extension-reading list with source quality checked.
- Images have bridging explanation.
- Screenshot-heavy code explanations have been converted into searchable prose and diagrams, not left as image-only notes.
- Mermaid diagrams use more than one diagram type when useful and include project-structure/new-content maps for multi-file changes.
- Mermaid syntax avoids fragile labels and has balanced fenced code blocks.
- Implementation is at the end.
- Code snippets are focused, not whole-file dumps.
- Source archives, when requested, include directory organization, file-labeled source blocks, minimal build/run commands, actual recorded output after each command, and a short output summary.
- Test explanation names concrete test cases and their purpose.
- Test coverage diagrams map tests to implementation contracts when tests are central to the note.
