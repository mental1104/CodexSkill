# Archive Outline Approval Regression

## Purpose

Verify that natural-language requests to archive new knowledge into Obsidian stop at a reviewable heading outline before any note is written, while preserving the existing conclusion-evidence workflow.

## Case 1: Cognitive-convergence note

### Natural-language prompt

把刚才关于 TCP 流量控制和拥塞控制的讨论归档成知识库笔记，重点讲清楚接收端窗口、发送端拥塞窗口、两者如何共同限制发送量，以及各自解决的问题和常见混淆。

### Required observations

- The request is routed to `note-cognitive-convergence`.
- The first response shows both a Mermaid `mindmap` and the exact Markdown heading tree beginning at `##`.
- Headings are specific, top-down, and include the important concepts and relationships from the prompt; child headings narrow their parent.
- The assistant stops and waits for explicit confirmation of the currently shown outline.
- No vault file is created or updated, no commit is made, and the full note is not generated before confirmation.

### Regression failures

- The assistant writes or commits the note immediately because the user already said “归档”.
- The assistant asks only which note type to use, without presenting a heading tree.
- The assistant presents only a generic list such as “背景 / 原理 / 总结”, omits the mind map, or starts headings at `#` rather than `##`.
- The assistant silently replaces the confirmed hierarchy with its default template.

## Case 2: Operational archive

### Natural-language prompt

请把这次 NAS 出站故障归档成以后能照着恢复的操作笔记：默认路由是 `default via 192.168.31.1 dev eth1 dead link`，实际在线 LAN 网卡是 `eth2=192.168.31.238`；临时把默认路由切到 eth2 后出站恢复。笔记要保留 `ip route`、`nslookup auth.openai.com` 和 `curl -4 -v https://auth.openai.com/` 的检查顺序，以及恢复后的验证。

### Required observations

- The assistant selects the operational note shape based on the future use.
- It presents a detailed mind map and matching H2-H6 heading tree before writing.
- It waits for explicit confirmation and uses the approved hierarchy as the final note structure.

## Case 3: Conclusion-evidence exception

### Natural-language prompt

请把这次 NAS 故障的结论和证据归档成一篇结论优先的笔记：根因是默认路由仍指向已断开的 eth1；`ip route` 输出显示 `default via 192.168.31.1 dev eth1 dead link`，而 eth2 是实际在线 LAN 网卡；切换默认路由后 `nslookup` 和 `curl` 恢复正常。

### Required observations

- The assistant selects `note-conclusion-evidence`.
- It preserves the existing conclusion-first workflow and does not add the new outline-approval gate.

## Pass condition

Natural-language archive requests trigger the outline gate without the user naming a Skill or Router. The approved outline is the actual heading hierarchy used for the note, and `note-conclusion-evidence` remains unchanged.
