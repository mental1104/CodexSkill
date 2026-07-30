---
name: calendar-harvest
description: ChatGPT chat-only skill for converting short natural-language schedule requests into deterministic calendar-event JSON arrays using a fixed five-field schema. Use it when the user explicitly asks to 日程化、转日程、生成日程 JSON, Calendar Harvest, or Schedule Harvest. It does not directly create, modify, or delete events in a connected calendar.
---

# Calendar Harvest

## Scope

This skill is currently for ChatGPT chat use only.

It converts a short natural-language schedule description into a machine-readable JSON array for downstream import.

It does not directly create, update, cancel, or delete events in Google Calendar, Apple Calendar, reminders, or other connected services. Direct calendar write requests should use the relevant calendar capability instead.

## Triggers

Use this skill when the user says one of:

- 日程化
- 转日程
- 生成日程
- 生成日程 JSON
- 创建日程 JSON
- Calendar Harvest
- Schedule Harvest

The trigger phrase itself is not an event.

Do not trigger this skill merely because the conversation mentions a date or meeting. The user must explicitly request this JSON transformation workflow.

## Goal

Turn the user's current schedule request into the smallest useful set of independently understandable calendar events.

The output should be:

- deterministic enough for repeated use;
- compatible with the fixed five-field schema;
- conservative about facts that were not supplied;
- easy to resume later without reopening the conversation;
- atomic at the event level, but not fragmented into artificial micro-steps.

Use the current user message as the primary source. Use only immediately relevant conversation context to resolve pronouns, omitted objects, previously stated locations, or an explicitly referenced date.

## Output Contract

Normally output only one JSON code block and no explanation.

The top-level value must always be an array:

```json
[
  {
    "start_time": "2026-07-31 15:00:00",
    "end_time": "2026-07-31 16:00:00",
    "plan_name": "去海雅吃费大厨",
    "detail": "前往海雅缤纷城门店用餐",
    "position": "海雅缤纷城"
  }
]
```

Each event must contain exactly these five string fields in this order:

1. `start_time`
2. `end_time`
3. `plan_name`
4. `detail`
5. `position`

Do not add IDs, confidence values, recurrence rules, comments, metadata, or extra fields.

If no valid event can be extracted, output:

```json
[]
```

## Field Rules

### `start_time` and `end_time`

- Format must be `YYYY-MM-DD HH:mm:ss`.
- Use four-digit years. The old `YY-MM-DD` wording is not valid for this schema.
- Seconds default to `00` unless the user explicitly provides seconds.
- Minutes default to `00` unless the user explicitly provides minutes.
- `end_time` must be later than `start_time`.

### `plan_name`

- Must not be empty.
- Prefer an action-object phrase that still makes sense when seen alone later.
- Keep it within 15 visible Chinese characters where practical.
- Do not use vague names such as `安排一下`, `处理事情`, or `准备` when the actual object is known.

### `detail`

- Must not be empty.
- Preserve the minimum useful context: purpose, object, constraint, sequence, or completion condition.
- Keep it within 50 visible Chinese characters where practical.
- Do not invent transportation, companions, materials, procedures, or motivations.

### `position`

- Use the location text explicitly supplied by the user or clearly resolved from immediately relevant context.
- Preserve relative locations such as `公司`, `家`, or `楼下` when that is exactly what the user said.
- Do not geocode, expand, normalize, or guess an address.
- If no location is present, use an empty string: `""`.

## Interpretation Workflow

Process the request in this order:

1. Remove the trigger phrase.
2. Identify independent event candidates.
3. Resolve explicit dates, times, durations, date ranges, and sequence words.
4. Apply the deterministic defaults in this skill only where information is omitted.
5. Merge duplicate or inseparable candidates.
6. Split only events that have independent outcomes, times, or locations.
7. Validate the five-field schema, time ordering, length limits, and JSON syntax.
8. Output the JSON array only.

## Event Atomicity

Atomicity means one calendar entry should represent one independently schedulable activity.

Split when at least one of the following is true:

- activities occur in different time windows;
- activities occur at different locations;
- either activity can be completed or cancelled independently;
- the user explicitly describes a sequence such as `先……再……` or `之后……` and separate entries are useful.

Do not split merely because an activity contains natural sub-steps.

Normally keep the following together unless the user gives separate times or explicitly wants separate entries:

- getting ready, travelling, and attending one destination activity;
- opening software, editing, exporting, and uploading one deliverable;
- checking materials and joining one meeting;
- warm-up, exercise, and cooldown in one workout.

Do not turn a broad goal into an invented daily plan. For example, `下周复习计算机网络` should remain one date-range event unless the user supplies sessions or asks for a detailed study schedule.

## Date Resolution

Use the runtime-provided current date, current time, and user timezone. Never copy dates from examples into real output.

Apply this priority:

1. explicit absolute date;
2. explicit relative date;
3. explicit weekday;
4. default date.

Rules:

- `今天`, `明天`, and `后天` are resolved from the runtime date.
- `这周X` or `本周X` means weekday X in the current Monday-to-Sunday calendar week.
- `下周X` means weekday X in the following Monday-to-Sunday calendar week.
- Bare `周X` means the nearest occurrence that is not earlier than today. If it is today and an explicit time has already passed, use the next week's occurrence.
- If no date is given, use today, even if the resolved clock time is earlier than the current time. This preserves the user's literal omission instead of silently moving the event to tomorrow.
- If only a month and day are given, use the nearest matching date that is not earlier than today. If that date has passed in the current year, use the next year.
- If a year is explicitly given, never roll it forward automatically.

## Time Resolution

Explicit user times always override defaults.

### Daypart windows

When a daypart is given without a specific clock time, use the full window:

- `凌晨`: `00:00:00` to `06:00:00`
- `早上` or `上午`: `08:00:00` to `12:00:00`
- `中午`: `12:00:00` to `14:00:00`
- `下午`: `14:00:00` to `18:00:00`
- `晚上`: `18:00:00` to `22:00:00`
- `夜里` or `深夜`: `22:00:00` to the next day `00:00:00`

When a daypart and a specific clock time both appear, use normal 12-hour clock semantics:

- `上午9点` -> `09:00:00`
- `中午1点` -> `13:00:00`
- `下午1点` -> `13:00:00`
- `晚上8点` -> `20:00:00`
- `凌晨1点` -> `01:00:00`

### Bare clock hours

When an hour is given without morning or afternoon context, prefer ordinary waking hours:

- bare `1点` through `7点` -> `13:00` through `19:00`;
- bare `8点` through `12点` -> `08:00` through `12:00`.

Conversation context may override this rule when it clearly indicates overnight work, travel, sleep, or another non-daytime activity.

### Missing boundaries

- If a date is given but no time is given, use `08:00:00` to `22:00:00` on that date.
- If neither date nor time is given, use today `00:00:00` to `23:59:59`.
- If an exact start time is given but no end time or duration is given, default to one hour.
- If an exact end time is given but no start time or duration is given, default to one hour before the end time.
- If a duration is given, calculate the missing boundary from it.
- If both start and end clocks are given and the end clock is not later than the start clock, roll the end into the next day only when the wording clearly indicates an overnight event, such as `晚上11点到凌晨1点`.

### Date ranges

For an inclusive date range without clock times:

- start at `08:00:00` on the first date;
- end at `22:00:00` on the final date.

Do not end at `00:00:00` on the final date because that would exclude almost the entire final day.

## Sequenced Events

When the user supplies a clear sequence but omits individual durations:

- use explicitly supplied times first;
- otherwise assign the standard one-hour duration to each exact-time event;
- place the next event immediately after the previous event only when words such as `之后`, `然后`, or `接着` clearly establish continuity;
- do not invent travel time between locations;
- mention the sequence briefly in `detail` when useful.

## Repeating Events

The fixed schema has no recurrence field.

- If the user provides a finite count or end date, expand the recurrence into individual events.
- Expand at most 31 occurrences in one response.
- If the recurrence is open-ended, ask one concise clarification question for an end date or occurrence count before producing JSON.
- Do not silently output only the first occurrence of an open-ended recurrence.

The clarification question is the only normal exception to the JSON-only output rule.

## Conflict and Ambiguity

Resolve minor omissions with the defaults above instead of asking questions.

Ask at most one concise clarification question only when:

- two supplied dates or times directly conflict;
- an open-ended recurrence cannot be represented;
- the wording supports materially different schedules and no deterministic rule above resolves them;
- resolving the ambiguity would require inventing an important fact.

Do not ask merely because a location, minute, or detail is absent.

## Examples

Assume the runtime time is `2026-07-30 16:00:00`.

Input:

```text
日程化：明天下午三点去海雅缤纷城吃费大厨
```

Output:

```json
[
  {
    "start_time": "2026-07-31 15:00:00",
    "end_time": "2026-07-31 16:00:00",
    "plan_name": "去海雅吃费大厨",
    "detail": "前往海雅缤纷城门店用餐",
    "position": "海雅缤纷城"
  }
]
```

Input:

```text
转日程：这周六上午拍照，下午修片
```

Output:

```json
[
  {
    "start_time": "2026-08-01 08:00:00",
    "end_time": "2026-08-01 12:00:00",
    "plan_name": "外出拍照",
    "detail": "完成当天计划的摄影活动",
    "position": ""
  },
  {
    "start_time": "2026-08-01 14:00:00",
    "end_time": "2026-08-01 18:00:00",
    "plan_name": "整理并修片",
    "detail": "筛选并处理当天拍摄的照片",
    "position": ""
  }
]
```

Input:

```text
生成日程 JSON：8月3日到8月7日复习计算机网络
```

Output:

```json
[
  {
    "start_time": "2026-08-03 08:00:00",
    "end_time": "2026-08-07 22:00:00",
    "plan_name": "复习计算机网络",
    "detail": "在日期范围内完成计算机网络复习",
    "position": ""
  }
]
```

Input:

```text
日程化：每天晚上8点跑步
```

Output one clarification question instead of JSON:

```text
这项重复日程需要持续到哪一天，或一共生成多少次？
```

## Validation Checklist

Before returning the result, verify:

- the top-level value is a JSON array;
- every event contains exactly five required string fields;
- all timestamps use `YYYY-MM-DD HH:mm:ss`;
- every `end_time` is later than its `start_time`;
- no event is duplicated;
- no location or detail was invented;
- event splitting reflects independently schedulable activities rather than implementation micro-steps;
- `plan_name` and `detail` remain understandable without the original conversation;
- the output contains no prose outside the JSON code block, except the single allowed clarification question.

## Boundary

This skill generates an import payload only.

It does not:

- create or modify events in a connected calendar;
- create reminders or automations;
- cancel existing events;
- search for addresses or travel times;
- choose priorities or design a detailed schedule unless the user explicitly asks for schedule planning through another workflow.
