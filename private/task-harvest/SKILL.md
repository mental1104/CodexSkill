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

## Goal

Extract only actions the user still needs to personally do.

Review only the current conversation.

Ensure every exported task can be understood and resumed later without reopening the original conversation. Preserve only the minimum context needed to explain why the task exists, what remains unresolved, and what outcome would close it.

Output only a JSON code block. Do not explain.

## Output Format

When there are two or more independently actionable tasks under one theme, use the nested numbered form:

```json
{
  "<主题名>": {
    "1. <任务名>": "任务描述",
    "2. <任务名>": "任务描述"
  }
}
```

When there is exactly one remaining task, always output the task itself as the top-level key with an empty object:

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

Better when the conversation contains multiple independently completable actions:

```json
{
  "NAS 网络安全审计": {
    "1. 检查公网暴露面": "确认 ECS、NAS、FRP 和 Docker 的公网可达入口是否符合预期。",
    "2. 验证真实客户端 IP 日志": "确认代理链能够可靠记录公网来源 IP。",
    "3. 审计近期恶意访问": "分析访问与授权日志，判断近期是否存在扫描、认证攻击或其他可疑来源。"
  }
}
```

Avoid placing all background into the task name. However, for a single task, prefer a slightly richer title over creating a one-item nested object only to preserve context.

## Boundary

This skill only extracts tasks. It does not schedule reminders, create calendar events, send emails, update files, or execute commands.
