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

```json
{
  "<主题名>": {
    "1. <任务名>": "任务描述",
    "2. <任务名>": "任务描述"
  }
}
```

For a simple single task whose title remains independently understandable and actionable without the original conversation, output:

```json
{
  "具体任务名": {}
}
```

Do not use the empty-object form merely because there is only one task.

If a single task depends on conversational context, use the normal nested format with one numbered task so the description can preserve a restart checkpoint:

```json
{
  "<主题名>": {
    "1. <任务名>": "触发背景、待解决问题和完成标志"
  }
}
```

## Rules

- Keep only user actions: save, run, verify, schedule, buy, go, contact, confirm, decide, update, review.
- Do not invent steps.
- Do not include AI-completed work.
- Do not convert AI analysis, summaries, code, prompts, or drafts into tasks unless the user still has to apply, save, run, or verify them.
- Do not output rest, buffer time, mindset adjustment, or vague preparation.
- Keep only key actions. Merge related items when possible.
- Task names should include the action, object, and key context.
- Avoid turning one goal into many tiny implementation details.
- Apply a restartability check to every task: assume the user sees it days or weeks later without access to the current conversation.
- Use the empty-object form only when the task title alone clearly communicates the action, object, relevant context, and expected completion.
- When context is required, preserve only the minimum useful checkpoint in the task description:
  - what triggered the task;
  - what unresolved question, decision, or problem remains;
  - what result or decision would count as completion;
  - any constraint that materially changes how the task should be handled.
- Do not copy the whole conversation or preserve general analysis. Keep only context needed to restart execution.
- Do not invent motivations, constraints, next steps, or completion criteria that were not present in the conversation.
- A thought, observation, or interesting topic is not automatically a task. Include it only when the conversation shows that the user intends to revisit, evaluate, apply, verify, decide, or otherwise act on it.
- For exploratory tasks, prefer decision-oriented actions such as `判断`, `验证`, `评估`, or `形成结论` instead of vague actions such as `研究一下` or `了解一下`.
- Keep related background inside one task description instead of expanding it into artificial subtasks.
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
  "研究 AI 灵感": {}
}
```

Better:

```json
{
  "优化横向灵感的延迟兑现流程": {
    "1. 修正 Task Harvest Skill 的上下文保留规则": "触发背景：横向灵感导入提醒事项后，后续处理时会丢失原始语境。待解决问题：在不改变固定 JSON 格式的前提下保存足够的重启上下文。完成标志：Skill 能区分标题即可恢复的普通任务与需要描述保存 checkpoint 的上下文型任务。"
  }
}
```

Avoid placing all background into the task name. Use the description as the restart checkpoint when the title would otherwise become too long.

## Boundary

This skill only extracts tasks. It does not schedule reminders, create calendar events, send emails, update files, or execute commands.
