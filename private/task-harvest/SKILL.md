---
name: task-harvest
description: ChatGPT chat-only skill for turning the current conversation into a small, restartable JSON todo list when the user uses Task Harvest trigger phrases. Not a Codex coding or execution skill.
---

# Task Harvest

## Scope

This skill is currently for ChatGPT chat use only.

It is not a Codex coding, repository-editing, or shell-execution skill.

Use it only to transform the current conversation into user-side tasks.

## Triggers

Use this skill when the user says one of:

- 转待办
- 转代办
- 转代版
- 提取待办
- 生成待办
- 整理待办
- 任务化
- 待办化
- 转提醒事项
- Reminder Harvest
- Task Harvest

The trigger phrase itself is not a task.

## Confirmation Gate

Every time a Task Harvest trigger is first invoked in a conversation, run a confirmation round before exporting tasks. Do not output task JSON in that first response, even if the user appears to request that everything be converted immediately.

Review only the current conversation and list all discussed plans, approaches, alternatives, and potential follow-up actions that the user may want to turn into tasks. Include alternatives that were discussed but not chosen; label their status inline when needed. Do not invent new options or silently choose a preferred approach.

Present the candidates as a plain-text outline with at most two levels, using this shape:

```text
1. <major topic>
   a. <candidate plan or action>
   b. <candidate plan or action>
2. <major topic>
   a. <candidate plan or action>
   b. <candidate plan or action>
```

Keep each candidate on one line with enough context to distinguish it. Do not use a third level, nested descriptions, tables, checklists, or JSON in this confirmation round. Keep independent major topics as separate numbered groups.

Ask the user to confirm exactly which items to include, exclude, or revise, then wait. If no concrete candidate can be identified, say so and ask what they want included; do not export an empty or guessed task list.

While a candidate list is awaiting confirmation, interpret the next user reply as part of that confirmation flow even if it repeats a Task Harvest trigger phrase. If the user clearly confirms a selection, run the existing Task Harvest rules and output format on only the confirmed items. If they add or change candidates, show the revised two-level list and request confirmation again. If their selection is ambiguous, clarify before exporting. A clear confirmation such as "全部" selects all listed candidates, but the existing Task Harvest rules still determine which user-side actions belong in the final export. If the user cancels, stop without exporting tasks.

The confirmation round is separate from the final Task Harvest output; do not include its discussion or unselected alternatives in the exported JSON.

## Goal

Extract only actions the user still needs to personally do.

Review only the current conversation.

Ensure every exported task can be understood and resumed later without reopening the original conversation. Preserve only the minimum context needed to explain why the task exists, what remains unresolved, and what outcome would close it.

After the user explicitly confirms the final candidate set, output only a JSON code block. Do not explain.

## Output Format

Top-level keys represent independent major topics or problem domains.

If the conversation contains multiple peer-level major topics, output multiple top-level key-value pairs. Do not force unrelated or semantically independent topics into one generalized parent theme.

When there are two or more independently actionable tasks under one theme, use the nested numbered form:

```json
{
  "<主题名>": {
    "1. <任务名>": "任务描述",
    "2. <任务名>": "任务描述"
  }
}
```

When there is exactly one remaining task for a topic, output the task itself as a top-level key with an empty object:

```json
{
  "具体任务名": {}
}
```

Do not output a nested object containing only one numbered subtask.

If a single task needs conversational context to remain restartable, enrich the task title with the minimum necessary context instead of creating a numbered child merely to hold a description.

## Rules

- Keep only user actions: save, run, verify, schedule, buy, go, contact, confirm, decide, update, review.
- Do not invent steps.
- Do not include AI-completed work.
- Do not convert AI analysis, summaries, code, prompts, or drafts into tasks unless the user still has to apply, save, run, or verify them.
- Do not output rest, buffer time, mindset adjustment, or vague preparation.
- Keep only key actions, but do not over-merge independent work merely to reduce task count.
- Keep peer-level major topics as separate top-level keys.
- Do not invent a broad umbrella parent solely to make multiple independent topics fit under one theme.
- Treat actions as separate tasks when they have distinct execution steps, distinct verification results, or can be completed independently.
- Merge items only when they are genuinely one action or share the same completion state and splitting them would create artificial bookkeeping.
- Task names should include the action, object, and key context.
- Avoid turning one goal into many tiny implementation details.
- Apply a restartability check to every task: assume the user sees it days or weeks later without access to the current conversation.
- For exactly one task, use the empty-object form and make the title independently understandable and actionable.
- For two or more tasks, use task descriptions only when needed to preserve restart context:
  - what triggered the task;
  - what unresolved question, decision, or problem remains;
  - what result or decision would count as completion;
  - any constraint that materially changes how the task should be handled.
- Do not copy the whole conversation or preserve general analysis. Keep only context needed to restart execution.
- Do not invent motivations, constraints, next steps, or completion criteria that were not present in the conversation.
- A thought, observation, or interesting topic is not automatically a task. Include it only when the conversation shows that the user intends to revisit, evaluate, apply, verify, decide, or otherwise act on it.
- For exploratory tasks, prefer decision-oriented actions such as `判断`, `验证`, `评估`, or `形成结论` instead of vague actions such as `研究一下` or `了解一下`.
- If multiple actions have different completion criteria, keep them as multiple tasks even when they contribute to the same broader goal.
- If there are no remaining user-side actions, output an empty JSON object.

## Task Naming

Prefer compact but context-rich names.

Task names should identify:

- the user action;
- the object being handled;
- the goal, project, or key situation when it materially affects meaning.

Prefer names that express the intended closure.

Bad:

```json
{
  "NAS 网络安全审计": {
    "1. 完成 NAS 安全检查": "检查暴露面、日志和攻击情况。"
  }
}
```

Better when the work is genuinely one task:

```json
{
  "完成 NAS 网络安全审计并形成加固结论": {}
}
```

Better when the conversation contains multiple independently completable actions under one topic:

```json
{
  "NAS 网络安全审计": {
    "1. 检查公网暴露面": "确认 ECS、NAS、FRP 和 Docker 的公网可达入口是否符合预期。",
    "2. 验证真实客户端 IP 日志": "确认代理链能够可靠记录公网来源 IP。",
    "3. 审计近期恶意访问": "分析访问与授权日志，判断近期是否存在扫描、认证攻击或其他可疑来源。"
  }
}
```

Bad when the conversation actually contains multiple peer-level major topics:

```json
{
  "NAS 运维": {
    "1. 完成网络安全审计": "...",
    "2. 完成备份策略检查": "..."
  }
}
```

Better:

```json
{
  "NAS 网络安全审计": {
    "1. 检查公网暴露面": "...",
    "2. 审计近期恶意访问": "..."
  },
  "NAS 备份策略": {
    "1. 检查现有备份覆盖": "...",
    "2. 验证恢复流程": "..."
  }
}
```

If one peer-level topic has only one task, keep it as its own top-level empty-object task instead of nesting a single numbered child:

```json
{
  "NAS 网络安全审计": {
    "1. 检查公网暴露面": "...",
    "2. 审计近期恶意访问": "..."
  },
  "检查 NAS 证书自动续期": {}
}
```

Avoid placing all background into the task name. However, for a single task, prefer a slightly richer title over creating a one-item nested object only to preserve context.

## Boundary

This skill only extracts tasks. It does not schedule reminders, create calendar events, send emails, update files, or execute commands.
