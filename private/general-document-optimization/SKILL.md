---
name: general-document-optimization
description: Non-technical Obsidian note execution layer. Use to diagnose or improve old general notes, reading notes, personal planning notes, meeting notes, research notes, travel notes, reflection notes, and other non-code documents. For vault style and placement, follow blue-espeon-note-style. For metadata-only edits, use obsidian-frontmatter-metadata. Do not use for technical implementation, experiments, benchmarks, tests, or source-code notes.
---

# General Document Optimization

## Role

This skill is the **general note execution layer**.

It improves existing non-technical Obsidian notes into coherent, searchable, maintainable documents while preserving the original intent and useful raw material.

It should not own vault-wide conventions.

Delegate:

- Vault style, directory placement, naming, backlinks, Mermaid conventions, and single-thesis boundaries: `blue-espeon-note-style`.
- Metadata-only edits: `obsidian-frontmatter-metadata`.
- Technical note rewriting: `technical-document-optimization`.
- Source-code scene reconstruction: `source-walk`.

## Use When

Use for:

- reading notes;
- life planning notes;
- meeting notes;
- research notes;
- travel notes;
- reflection notes;
- idea fragments;
- general non-technical archive notes.

Main effect:

- conclusion or topic becomes clear;
- scattered fragments become readable;
- raw material is preserved near the end when useful;
- prerequisites and related links become useful instead of decorative;
- the note becomes easier to search and revisit.

## Do Not Use When

Do not use for:

- code implementation notes;
- experiment reports;
- benchmark notes;
- debugging records;
- pprof/trace notes;
- API/framework/library tutorials;
- algorithm/data-structure notes;
- source-code analysis;
- metadata-only edits.

## Core Rules

1. Diagnose before editing unless the user explicitly confirms direct changes.
2. Preserve original body, intent, and useful raw material.
3. Do not rewrite into marketing, textbook, public-account, or motivational-poster style.
4. Prefer concise, direct, searchable, reusable wording.
5. Do not add unsupported facts.
6. Use wikilinks only for real prerequisites or related notes.
7. Prefer total-to-detail organization when the note is an overview, introduction, archive, reading note, meeting note, research note, or concept map.
8. Keep raw fragments, excerpts, meeting records, and old chronological material near the end unless chronology is the point.
9. Do not over-format with decorative callouts or diagrams.

## Diagnosis Output

When asked to diagnose first, output:

```markdown
# 旧笔记改造建议

## 1. 选择理由

- Type: general note
- Reason: <why this is not a technical note>

## 2. 总体判断

这篇笔记目前的主要问题是：

## 3. 需要修改的地方

### 1. <issue>

- 问题：
- 为什么需要改：
- 建议怎么改：

## 4. 需要保留的原始材料

- <fragments / excerpts / images / observations / meeting records>

## 5. 不确定点

- <max 3 bullets>

## 6. 等待确认

请确认是否按以上方案改造。
```

If the user already asked to write directly, edit directly.

## Preferred Structure

Use this structure when appropriate:

1. YAML frontmatter.
2. Title.
3. Summary or AI摘要.
4. Core conclusion, topic, or decision.
5. Navigation surface when the note has several themes.
6. Plain-language context.
7. Supporting process, reasoning, examples, observations, or evidence.
8. Images/diagrams with bridging explanations when useful.
9. Original/raw information archive when the source note contains scattered material.
10. Takeaways or conclusion.
11. Related links.

## Total-To-Detail Rule

Use this mode when the reader should first know what the note is saying before inspecting old fragments.

Structure:

1. Put the core conclusion, topic, or decision near the top.
2. Make the first substantial section a navigation surface when the note has multiple themes.
3. Explain the supporting process in the middle.
4. Preserve raw material near the end.
5. Add related links only when they help future navigation.

Do not scatter raw material before the conclusion unless the note is intentionally a diary, timeline, or chronological log.

## Validation Checklist

Before finishing, check:

- the note is genuinely non-technical;
- original intent is preserved;
- no unsupported facts were added;
- metadata rules did not drift from `obsidian-frontmatter-metadata`;
- vault style did not drift from `blue-espeon-note-style`;
- raw material was preserved when useful;
- links are useful, not decorative;
- the opening answers what the note is about.

## Chat Output Policy

After editing, do not paste the full note unless the user asks.

Return:

```markdown
## 完成情况

- Edited: `<path>`
- Main changes:
  - ...
  - ...
- Preserved:
  - ...
- Uncertainty:
  - ...
```
