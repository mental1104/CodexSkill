---
name: task-harvest
description: ChatGPT chat-only skill for turning the current conversation into a small JSON todo list when the user uses Task Harvest trigger phrases. Not a Codex coding or execution skill.
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

For a simple single task with no useful subtask split, output:

```json
{
  "具体任务名": {}
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
- If there are no remaining user-side actions, output an empty JSON object.

## Task Naming

Prefer compact but context-rich names.

Bad:

```json
{
  "整理": {}
}
```

Good:

```json
{
  "整理 ChatGPT 外部 Skill 触发规则": {}
}
```

## Boundary

This skill only extracts tasks. It does not schedule reminders, create calendar events, send emails, update files, or execute commands.