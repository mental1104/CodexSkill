---
name: leetcode-archive
description: Archive a completed LeetCode problem-solving conversation into the user's Obsidian GitHub repository. Use when the active topic is one LeetCode problem, the user has reached an accepted solution, and then says “归档”. Reconstruct the concise solving journey from the first problem link through every user code snapshot, question, failed case, diagnosis, next step, and final AC version, then create or update the corresponding Markdown note in mental1104/Obsidian.
---

# LeetCode Archive

## Role

Turn one completed LeetCode conversation into a concise personal review note.

The durable asset is the user's actual solving journey:

- what the user tried;
- the exact code at each round;
- what the user asked, doubted, noticed, or felt during that round;
- which case or submission failed;
- what the core problem was;
- what the user decided to change next;
- how the final accepted version was reached.

Write for the user's future self. Be direct, compact, and concrete. Do not turn the note into a public tutorial or expand it into a generic algorithm article.

## Trigger

Use this skill when all of the following are true:

1. the active coherent topic is one LeetCode problem;
2. the conversation contains the original LeetCode link or an unambiguous problem identity;
3. the user has explicitly said that the solution passed, was accepted, or reached AC, or the recent context provides equally clear acceptance evidence;
4. the user says “归档”, “归档这题”, “把这题归档” or an equivalent request.

When the user says only “归档” inside an active completed LeetCode thread, route directly here.

Do not archive an unfinished solution as AC. If acceptance is not supported by the conversation, do not invent it.

## Repositories And Destination

Skill repository:

```text
mental1104/CodexSkill
branch: main
```

Archive repository:

```text
mental1104/Obsidian
branch: main
```

Default directory:

```text
Atlas/100-Computer Science/110-Algorithms/Leetcode/
```

Default filename:

```text
<problem number>. <Chinese problem title>.md
```

Example:

```text
Atlas/100-Computer Science/110-Algorithms/Leetcode/274. H 指数.md
```

Use the official problem number and Chinese title when they can be resolved from the initial link, supplied题面, or conversation. Remove filename-invalid characters without otherwise rewriting the title.

If the target file already exists, fetch it first and update it in place. Merge useful existing content when practical; do not blindly discard an earlier independent solving history.

The archive request itself authorizes writing the note to the archive repository. Do not stop for a dry run when the problem identity, target path, and AC status are clear.

## Source Scope

Use only the coherent conversation for the current problem, beginning with the earliest relevant LeetCode link or题面 and ending at the archive request.

Collect:

- the original LeetCode URL;
- problem number and title;
- the problem statement, examples, and constraints available from the link or conversation;
- every distinct user-written solution snapshot in chronological order;
- partial user snapshots when that is all that exists;
- every relevant user message that exposes the user's reasoning, question, uncertainty, correction, reaction, or solving feeling;
- submission results, compiler errors, runtime errors, wrong-answer cases, and failed test inputs explicitly shown or described;
- the diagnosed issue for each non-final round;
- the next intended adjustment after each non-final round;
- accepted intermediate versions that the user later optimized further;
- the final accepted code;
- concise complexity and key observations when supported by the final solution.

Exclude:

- unrelated tangents from the same chat;
- routine acknowledgements with no review value;
- generic encouragement;
- repeated explanations that add no new information;
- language syntax snippets that were never part of a solution attempt;
- assistant-written replacement solutions that the user never adopted or submitted;
- external interview trivia, company tags, or broad algorithm history unless the user explicitly made them part of the review goal.

Do not copy assistant replies wholesale. Distill only the conclusion or correction that materially changed the user's next attempt.

## Round Boundary Rules

A round is anchored by a user-submitted solution code snapshot.

Apply these boundaries strictly:

1. The first user solution snapshot starts `第一轮尝试`.
2. The next distinct user solution snapshot ends the current round and starts the next round.
3. Every relevant user message after one solution snapshot and before the next solution snapshot belongs to the earlier round.
4. Therefore, questions asked between the first and second code snapshots belong under `第一轮尝试`; questions between the second and third snapshots belong under `第二轮尝试`, and so on.
5. Messages after the final solution snapshot and before the archive request belong to the final round.
6. Relevant questions or reasoning before the first solution snapshot may be placed in an optional `## 解题前的提问与判断` section. Do not call them a numbered attempt because no solution snapshot has been submitted yet.
7. A small language-usage snippet is not a new round unless the user incorporates it into an actual solution attempt.
8. Formatting-only reposts or accidental duplicate code do not create a new round. A snapshot must represent a meaningful submitted or proposed solution state.

## Code Snapshot Rules

Every distinct user-written solution snapshot for the problem must appear in the note.

Preserve each snapshot verbatim whenever the exact text is available:

- do not silently fix formatting;
- do not rename variables;
- do not repair syntax;
- do not reconstruct a complete program from scattered fragments;
- do not replace an earlier version with the final version.

If a snapshot is incomplete, label it as a partial snapshot. Preserve the available fragment instead of inventing the missing code.

A small language-usage example, such as how to create a slice, use a container, or generate a random number, is not a solution round unless the user incorporated it into an actual attempt.

## User Question And Solving-Feeling Rules

Each attempt should preserve the user's own voice where it helps reconstruct the experience of solving the problem.

When relevant content exists, add a compact subsection:

```markdown
### 用户提问

- <question or doubt>
- <question or doubt>
```

Rules:

- Assign each question according to the round boundary rules above.
- Preserve the user's original wording when it is concise and expressive.
- Lightly clean obvious speech-to-text repetition or broken punctuation outside code blocks, without changing the meaning or emotional tone.
- Combine repeated versions of the same question into one concise item.
- Keep concrete questions such as complexity doubts, boundary confusion, language usage, and “why did this case fail”.
- Do not include the assistant's full answer under this subsection.
- If a question led to a decisive conclusion, place that conclusion under `### 讨论结论` or fold it into `问题` / `下一步`, whichever is more compact.

The user's non-question observations, reactions, and solving feelings may be kept under an optional subsection:

```markdown
### 当时想法

<one or several compact sentences>
```

Examples include surprise that the first attempt passed, uncertainty about a complexity claim, frustration with one case, or the reason the user decided to continue optimizing.

Do not create `用户提问`, `讨论结论`, or `当时想法` headings when there is no meaningful content. Readability is more important than rigid visual symmetry.

## Failure And Transition Rules

For every round before the final accepted version, record the following when available:

```markdown
结果：AC / 编译失败 / 运行失败 / Wrong Answer / 超时 / 未提交 / 仅完成局部实现

失败用例：<exact input and observed result>

问题：<the shortest accurate diagnosis>

下一步：<the user's next adjustment or the next direction established in the conversation>
```

Apply these rules:

- If an exact failed test case appears in the conversation, preserve it.
- If failure is known but the exact input was not recorded, write `失败用例：聊天中未记录具体输入`.
- Never fabricate a test case, error message, submission result, or cause.
- If a round already passed but the user continued to optimize, write `结果：AC（继续优化）` and state why the user continued.
- If the assistant proposed several possibilities but the conversation did not establish the actual cause, keep the uncertainty explicit.
- Keep each diagnosis and next step to the minimum needed to explain the transition.
- Omit `失败用例` when the round did not fail and no failed case is relevant.

## Note Template

Use this frontmatter shape and field order:

```yaml
---
read_status: unread
source: <original LeetCode URL>
summary: <one concise sentence describing the attempt progression and final accepted approach>
---
```

Do not add extra frontmatter fields unless the user later changes this template.

Preferred body structure:

```markdown
## 题目描述

<faithful problem statement>

<examples and constraints when available>

## 解题前的提问与判断

<optional; only when meaningful pre-snapshot content exists>

## 第一轮尝试

```<language>
<exact user code snapshot>
```

### 用户提问

- ...

### 当时想法

...

### 结果与问题

结果：...

失败用例：...

问题：...

下一步：...

## 第二轮尝试

...

## 第 N 轮尝试（最终 AC）

```<language>
<exact final accepted code>
```

结果：AC

复杂度：...

关键点：

- ...
```

Adapt the number and names of subsections to the actual conversation. Do not create empty headings or force every round into an identical visual shape.

If the first submitted version is already AC and no later code snapshot exists, name it `## 第一轮尝试（最终 AC）`.

If an earlier version is AC but the user later optimizes it, keep the earlier round as `结果：AC（继续优化）` and mark only the final code snapshot as `（最终 AC）`.

Never duplicate the same code block merely to create a separate final section.

## Writing Style

- Prefer short paragraphs and compact labels.
- Preserve the user's direct observations when they are useful, lightly cleaning only obvious speech-to-text noise outside code blocks.
- State the problem with enough detail to review it later, but do not pad it with background.
- Explain only the actual card points and transitions from this solving session.
- Use multiple small subsections when they improve reading, but do not create headings only for visual symmetry.
- Do not add Mermaid diagrams by default.
- Do not add a generic “why this matters”, “learning objectives”, interview-company discussion, or algorithm encyclopedia section.
- Avoid repeating the same conclusion in the summary, every round, and the final section.
- Language is determined by the submitted solution; the skill is not tied to Go and must work equally for C++, Python, or another language.

## Accuracy Rules

Distinguish clearly between:

- facts present in the conversation;
- conclusions directly inferable from the code;
- uncertainty caused by missing submission output or missing test cases.

Complexity may be derived from the final code when it is clear. Do not claim a standard-library implementation detail, platform behavior, or exact runtime characteristic unless it was established and materially matters to this note.

The final code may be labeled AC only when acceptance is supported by the conversation.

## GitHub Write Workflow

1. Resolve the earliest relevant LeetCode URL from the active conversation.
2. Resolve the official problem number and Chinese title.
3. Reconstruct all user code snapshots in chronological order.
4. Assign every relevant user question, observation, and feeling to its correct round using the code-snapshot boundaries.
5. Record submission outcomes, failed cases, diagnoses, and next steps without invention.
6. Build the complete Markdown note using this skill's template.
7. Check whether the target path already exists in `mental1104/Obsidian` on `main`.
8. Create the file when absent; otherwise update the existing file after inspecting it.
9. Use a concise commit message:

```text
Archive LeetCode <number> <title>
```

10. Verify that the committed note contains the source URL, every available user code snapshot, round-scoped user questions, and a supported final AC version.

## Completion Report

After writing, respond only with a compact report:

```markdown
## 完成情况

- Skill：`leetcode-archive`
- 题目：`<number>. <title>`
- 文件：`<repository path>`
- 代码快照：<count>
- 归档提问：<count or concise status>
- 最终状态：AC
- 写入方式：新建 / 更新
- 不确定点：无 / <missing evidence stated briefly>
```

Do not paste the full note back into chat unless the user asks to review it.
