---
name: english-harvest
description: ChatGPT chat-only skill for extracting reusable English expressions from the current conversation. Not a Codex coding or execution skill.
---

# English Harvest

## Scope

This skill is currently for ChatGPT chat use only.

It is not a Codex coding, repository-editing, or shell-execution skill.

## Triggers

Use this skill when the user says one of:

- Harvest
- English Harvest
- Reusable English Assets
- REA
- 英语收割
- 英文收割

## Goal

Extract reusable English expression assets from the current conversation.

Do not use the normal correction format.

Focus on high-frequency expressions, collocations, fixed phrases, chat patterns, transitions, idioms, metaphors, and native-like wording.

Prioritize expressions the user can already say but could make more natural.

Avoid literary, low-frequency, one-off, or hard-to-transfer expressions.

Default to 10-20 items. Prefer fewer high-quality items.

## Output Format

Each item includes:

```markdown
## <expression>

- Original expression:
- Why worth learning:
- Typical scenarios:
- Simpler expression it replaces:
- Add to Anki: Yes / No
```

End with:

```markdown
## Today’s Themes

- Reusable expression habits:
- Thinking patterns:
- Chat patterns:
- Sentence structures:
```

## Rules

- Review only the current conversation.
- Do not explain the trigger phrase itself.
- Do not use `Correction / Better version / Answer`.
- Keep explanations concise.
- Prefer practical, spoken, reusable English.
- If the conversation contains little English, extract only what is genuinely useful and keep the output short.
- If there are no reusable English assets, say so briefly.

## Anki Decision

Use `Add to Anki: Yes` for compact, reusable, natural expressions worth reviewing.

Use `Add to Anki: No` for expressions that are too obvious, too context-specific, or not worth memorizing.