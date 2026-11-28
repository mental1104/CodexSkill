---
name: document-quality-gate
description: Mandatory final companion for standalone human-readable document deliverables, including technical documents, READMEs, design and test reports, work reports, GitHub Issue/PR drafts or bodies, and Obsidian archive notes. Review the final draft immediately before delivery, authorized file write or publication. Apply vendored qu-ai-wei to Simplified Chinese prose in embedded mode; preserve facts, scope, author voice, approved structure and machine-readable content. Do not trigger for ordinary chat, executable code alone, raw data, translation-only or proofreading-only tasks.
---

# 文档交付质量门禁

## 定位与触发

本 Skill 是最终文档正文的强制伴随门禁，不负责生成初稿、选定文档类型、事实采集、技术验收、审批或写入。由业务 Skill 完成初稿后，在交付可复制正文、写入获授权文件或提交获授权发布载荷之前执行。仅检查本轮授权编辑的部分；新增完整文档则检查全文。普通聊天、代码与注释、原始证据快照、JSON/配置、纯翻译或校对不触发；文档中的代码及数据仍受保护。

## 优先级与读取

用户明确要求、目标仓库强制规范、业务 Skill 的事实与模板约束、已批准大纲及阶段审批优先于风格优化。保留作者声口、正式程度和文体，不改变业务 Skill 的交付或远端写入权限。

对简体中文正文，先读取本地 [qu-ai-wei 执行规则](references/qu-ai-wei/upstream-workflow.md)、[模式目录](references/qu-ai-wei/references/pattern-catalog.md) 和 [编辑边界](references/qu-ai-wei/references/editing-boundaries.md)；按其路由需要再读案例、术语、平台或品牌参考。上游仅提供编辑方法，不作为独立任务触发器；固定使用内嵌模式，已有文档生成或编辑授权覆盖本轮门禁审查，但不扩大写入、发布、重构或改动原文的授权。疑似真实凭证时遵循上游门检，不复述凭证或发布相关正文，说明阻塞并请求脱敏。对非简体中文文档仅执行下述保真和结构核对，不套用中文表达规则。

## 执行

1. 锁定初稿与来源的事实、数值、单位、时间、条件、否定、归因、引用绑定、因果、优先级、完成状态及不确定性；长文按需建立信息账本和论证关系，短文直接逐项核对，不输出中间记录。
2. 扫描上游八个模式族；重点检查空话、重复、翻译腔、假对比、无证据拔高、机械排比、格式噪声。只改实际影响阅读的表达，术语、有效排比和逻辑连接词不是禁词。已合格则原样通过。
3. 最小有效修订：默认保留标题文字、层级、顺序、锚点、模板、表格数据、清单独立项和顺序、代码块及行内代码、命令、路径、链接目标、引用、YAML、公式、Mermaid/图表及机器可读字段。只在本轮明确授权且不突破已批准结构时调整篇章；不擅自摘要、扩写或引入新事实。
4. 对照初稿和证据复扫。改动导致语义、结构或范围漂移则撤回该改动；有真实事实缺口时保留原有限定或占位，无法满足硬性约束时停止交付受影响部分并向调用方报告。默认一次修订和一次复查即可，不循环追求风格分数。

## 交付契约

通过后只把最终正文交回原业务流程，静默放行，无门检标签、打磨报告、评分或额外审批。不得因门禁通过而宣称事实已外部核验、测试已执行、获发布授权或文件已保存；有实质阻塞则在正文之外简短告知。写入和发布仍由原流程按授权执行。

## 场景检查

- 周报中“计划上线”不得改为“已上线”；删掉空泛升华，保留真实交付状态。
- 技术文档只授权回填数据时，只核对回填片段，不润色其他段落；保留用户要求的修改标记。
- 已批准大纲的 Obsidian 归档只在该结构内润色，保留 Mermaid 和锚点；不再次要求审批，也不绕过原有审批。
- PR 草稿保持真实测试结果、标题前缀、模板与证据；门禁不是发布授权。
- 普通代码修复及其聊天总结不触发；同一任务明确要求另外交付 README 时，只对 README 执行门禁。
