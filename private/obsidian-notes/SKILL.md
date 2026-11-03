---
name: obsidian-notes
description: Create and edit notes in an Obsidian vault, including note organization, indexes, internal links, and Tandem Comments review threads.
---

# Obsidian Notes

Use this skill when creating, editing, or organizing Markdown notes in an Obsidian vault.

## Link format preference

- For links between notes, use standard Markdown links in `[label](relative/path/to/note.md)` form. Do not use Obsidian wiki links such as `[[note]]` unless the user asks for them.
- Resolve relative paths from the note containing the link. Include the `.md` extension; percent-encode spaces in link destinations when needed.
- After editing, verify that each local Markdown link points to an existing vault file. Keep external web links in normal `[label](https://...)` form.

## Note maintenance

- Preserve the vault's existing folder structure, frontmatter conventions, and note style where practical.
- When adding a frequently used note, update the relevant index or home note with a Markdown link so it is discoverable.
- Keep information in a dedicated linked note when it has distinct details that will be maintained independently.

## Tandem Comments

Apply these rules whenever the user asks to review, address, resolve, or process comments or review tasks in an Obsidian vault.

### Repository-wide inventory

- Recursively scan every Markdown file in the vault for a fenced block whose opening line is exactly ` ```tandem-comments ` (with no surrounding spaces) and whose closing line is exactly ` ``` `.
- Remove lines beginning with `//` from inside the block before parsing its JSON; these are schema instructions, not JSON.
- Inspect every entry and select `status: "open"`. Count by comment ID and record the file path and `anchor.exact` for each entry.
- Do not rely only on Obsidian search results or truncated file previews. Read complete files and blocks, or parse them with a script when necessary.
- Report malformed blocks separately; do not silently omit them from the inventory.

### Addressing comments

- Read the complete source note and comment block before acting. Find `anchor.exact` in the original prose; use `anchor.prefix` and `anchor.suffix` to disambiguate repeated matches. Use `pos` only as a fallback character offset. Do not guess when an anchor is missing or ambiguous.
- Process every open comment ID. Make requested changes only to the anchored passage and anything the comment explicitly asks to change; for questions or requests for an opinion, reply in the thread without changing prose. Do not invent missing facts.
- After editing prose, update the anchors (`exact`, `prefix`, `suffix`, and `pos`) for every affected comment so they continue to identify the intended text.
- Append a reply to the corresponding `thread` for each addressed comment, using the assistant's name and an ISO-8601 UTC timestamp. Leave a thread open after replying unless the user asked to resolve it.
- When the user asks to resolve and clean up a comment, remove its entry from the JSON. Use `status: "resolved"` only when comment history is explicitly requested.
- Preserve valid content after the block, including footnote definitions. If no comments remain, remove the whole block and its separating newline while retaining any following content.

### Verification

- Re-read the updated note and verify the block fences, JSON syntax, all expected comment IDs, replies, and anchors against the final prose.
- Ensure no open comment was skipped silently. Summarize per ID what changed, what was answered, or why it could not be addressed.
