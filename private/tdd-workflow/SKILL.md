---
name: tdd-workflow
description: Mandatory cross-language TDD workflow and phase gate. Use whenever the user explicitly asks for TDD/test-driven development, requires integration tests before production implementation, or asks to advance implementation through reviewed test stages. This skill owns black-box contract review, requirement-to-integration-scenario traceability, explicit user approval gates, phase sequencing, and integration-vs-unit test responsibilities.
---

# TDD Workflow

## 定位

这是跨语言的 TDD 工作流 Skill。

它负责：

- 先建立并评审黑盒 Contract；
- 从 Contract 建立可追踪的 Integration Scenario；
- 区分 Integration Test 与 Unit Test 的责任；
- 控制阶段顺序；
- 控制每个阶段内部的讨论、产出、评审和通过；
- 防止自动跨阶段推进。

它不负责：

- 语言具体编码风格；
- 测试框架 API；
- 构建系统全部细节；
- 注释格式。

核心原则：

> 用户定义问题和阶段边界；TDD Skill 决定当前阶段允许产出什么；语言 Skill 决定产物怎样写。

# 一、触发边界

以下情况自动应用本 Skill：

- 用户明确要求 TDD / test-driven development；
- 用户要求先测试、后实现，并要求分阶段推进；
- 用户要求先设计或评审 Integration Test，再开始实现；
- 用户要求 Integration Test → 实现 → Unit Test；
- 用户要求每一阶段经过确认后再继续。

以下情况默认不自动进入本工作流：

- 单纯补几个单元测试；
- 修 bug 顺便加测试；
- 修现有测试；
- 跑测试；
- 普通代码任务里仅附带“需要测试”。

# 二、优先级

当本 Skill 激活时：

1. 用户当前明确要求；
2. 仓库硬约束；
3. 本 Skill 当前 phase gate；
4. 语言级 code-style Skill；
5. code-comment-writing；
6. 项目历史习惯。

如果当前 phase 禁止 production code，即使已经知道怎样实现，也不能提前实现。

# 三、默认协作模式：DISCUSSION

每个新阶段默认进入 DISCUSSION。

DISCUSSION 的默认行为是倾听，而不是主动收敛。

当用户只是持续描述、头脑风暴、补充上下文、修正想法或推演时：

- 保持上下文；
- 回复应尽量短，只表示正在跟随，例如“继续，我在听”；
- 不主动总结；
- 不主动生成候选方案；
- 不主动补全未定义需求；
- 不主动宣布讨论完成；
- 不主动生成 Contract、Scenario、接口、测试或实现。

如果用户明确提出一个局部问题：

- 回答这个问题；
- 只扩展到回答该问题所必需的范围；
- 不借机完成整个阶段；
- 不把局部回答自动升级为正式 artifact。

核心规则：

> 信息充分不等于阶段完成。

> 用户没有要求收敛时，不替用户收敛。

# 四、冻结信号与内部状态

只有用户明确表现出“准备冻结当前讨论”的意图时，才开始形成当前阶段 artifact。

典型冻结信号：

- “整理一下”；
- “差不多了”；
- “按这个定”；
- “可以冻结了”；
- “把 contract 写出来”；
- “生成场景”；
- “按刚才讨论的实现出来”。

每个 Phase 使用同一套内部状态：

```text
DISCUSSION
    ↓ 用户要求收敛 / 形成当前阶段产物
ARTIFACT REVIEW
    ↓ 用户显式确认当前产物
APPROVED
    ↓ 用户显式要求进入下一 Phase
NEXT PHASE
```

规则：

1. DISCUSSION 可以持续任意多轮；
2. 讨论时间长、信息完整、已有明显方案，都不等于自动结束 DISCUSSION；
3. “整理 / 冻结 / 生成”只允许生成当前 artifact，不等于批准 artifact；
4. artifact 必须经过用户 Review；
5. 用户显式确认后才进入 APPROVED；
6. APPROVED 后也不自动进入下一 Phase。

# 五、五阶段状态机

```text
业务目标 / 初始想法
  ↓
Phase 0: Black-box Contract
  ↓ 用户显式确认
Phase 1: Integration Scenario Review
  ↓ 用户显式确认
Phase 2: Integration Test Implementation
  ↓ 用户显式确认
Phase 3: Production Implementation
  ↓ 用户显式确认
Phase 4: Unit Test
```

不得在同一轮中自动跨越两个 Phase。

每次确认只能确认已经展示的当前阶段产物，不能预先批准尚未出现的后续产物。

例如：

- “把刚才讨论的输入输出整理成 contract”只允许生成 Phase 0 artifact；
- “这版 contract 可以，开始设计场景”允许进入 Phase 1；
- “这版场景可以，写测试”允许进入 Phase 2；
- “测试这版确认，开始实现”允许进入 Phase 3；
- “实现没问题，补单测”允许进入 Phase 4。

# 六、Phase 0：Black-box Contract

目标是先明确“这个黑盒承诺什么”，不提前设计内部实现。

DISCUSSION 中不主动生成完整 Contract。

用户开始冻结后，Contract 根据任务实际需要明确：

- 被测对象；
- 外部输入；
- 外部输出；
- 可观察状态或副作用；
- 成功语义；
- failure / timeout / cancel / retry 等稳定语义；
- 当前需求明确包含和不包含的行为。

对于服务或协议，Contract 可以表现为：

- API / ABI；
- ROS Action / Service / Topic；
- RPC / HTTP / MQTT / DDS 消息；
- request / response schema；
- error code；
- 状态机；
- 文件系统或网络副作用。

Contract 不等于内部函数签名，不要求提前设计 private helper 或内部 class。

在 Phase 0 中：

- 用户只是描述时继续倾听；
- 用户问局部问题时只回答局部问题；
- 用户明确要求候选时才提供候选；
- 不擅自决定 timeout、覆盖、重试、回退、幂等、错误码等产品语义；
- 不把合理猜测写成确定需求。

冻结后可以：

- 整理候选 Contract；
- 标出未决定项；
- 对冲突项给少量候选；
- 区分“用户已明确”“基于讨论推断”“仍待确认”。

Contract 未经用户显式确认，不得进入 Phase 1。

黑盒测试优先描述：

```text
Input
→ Observable Behavior
→ Output / Side Effect
```

不得先看内部实现，再反推一个方便实现的 Contract。

# 七、Phase 1：Integration Scenario Review

从已确认 Contract 和业务目标转换成 Integration Scenario。

DISCUSSION 中默认不输出完整测试设计。

用户要求冻结后，每个 Scenario 至少说明：

- 场景名称；
- 场景目的；
- 对应业务目标 / Contract；
- fixture / 环境边界；
- 关键 Action；
- 可观察 Expectation；
- 为什么这个场景能证明对应需求。

每条独立业务目标原则上都应能追踪到至少一个 Scenario。

Integration Test 优先观察：

- 公共接口；
- 协议行为；
- 组件真实交互；
- 最终状态；
- 对外输出；
- 可观察副作用。

不要默认通过 private state 或实现细节证明业务成立。

Scenario 未经用户确认，不得进入 Phase 2。

# 八、Phase 2：Integration Test Implementation

只有 Phase 1 得到用户明确确认后，才能编写 Integration Test。

允许：

- Integration Test 代码；
- fixture / harness；
- fake / stub / protocol-level test peer；
- 测试数据 builder；
- 必要的测试构建配置；
- 表达已评审公共 Contract 所需的最小接口声明或测试接缝。

禁止：

- 实现真实业务逻辑；
- 顺手补 production implementation；
- 提前补 Unit Test；
- 因为测试不好写而改变已评审需求。

如果测试实现暴露出 Contract 或 Scenario 需要改变，退回对应前置 Phase 重新讨论，不静默修改。

# 九、Integration Test 可读性

测试正文优先读起来像业务或协议行为：

```text
Scenario
→ Action
→ Expectation
→ Action
→ Expectation
→ Final Expectation
```

复杂机制可以放入职责明确的 fixture / harness，让测试正文保留领域动作和领域期望。

不要为了 DSL 感提前设计庞大的测试框架。重复机制真正妨碍场景阅读时再抽象。

Integration Test 默认应与快速测试路径隔离，通过 CMake option、pytest marker、build tag 或项目已有机制显式 opt-in。具体机制由语言和仓库约定决定。

# 十、Phase 3：Production Implementation

只有 Phase 2 Integration Test 得到用户明确确认后，才能进入实现。

目标：

> 用最小、清晰的实现满足已经评审的 Contract 和 Integration Scenario。

要求：

- 让已确认 Integration Test 从 red 走向 green；
- 遵守语言 code-style；
- 遵守 code-comment-writing；
- 不扩展未确认的新行为；
- 不提前创建 Unit Test。

如果实现过程中发现 Contract 需要改变，回到 Phase 0；Scenario 需要改变，回到 Phase 1。

# 十一、Phase 4：Unit Test

只有 Phase 3 production implementation 得到用户明确确认后，才能新增 Unit Test。

Unit Test 主要验证：

- 单个 class / function / module；
- invariant；
- 算法边界；
- 错误路径；
- 细粒度状态转换；
- Integration Test 难以定位的局部逻辑。

Unit Test 不承担业务需求完整覆盖的主要责任。

# 十二、确认判定

“要求形成 artifact”和“确认 artifact”不是一回事。

形成 artifact 的信号包括：

- “整理一下”；
- “差不多了，收一下”；
- “把 contract 写出来”；
- “生成场景”。

确认当前 artifact 的信号包括：

- “确认”；
- “可以”；
- “按这版”；
- “这版没问题”；
- “继续写集成测试”；
- “开始实现”；
- “补单测”。

以下情况不能视为确认：

- 用户没有回复；
- 用户仍在追加或修改需求；
- 测试通过；
- 编译通过；
- CI 通过；
- 模型认为已经足够；
- 用户提前批准尚未看到的后续产物。

# 十三、与其他 Skill 的边界

Router 负责判断是否进入 TDD workflow，并加载对应语言 Skill。

语言 Skill 负责：

- 类型和 API 设计；
- 测试框架默认值；
- 测试文件结构；
- 构建系统；
- formatter / linter / static analysis。

语言 Skill 不得改变本 Skill 的 Phase 顺序，也不得绕过 DISCUSSION / ARTIFACT REVIEW / APPROVED。

code-comment-writing 只在当前 Phase 允许生成代码时约束注释，不能推动 workflow 提前生成代码。

# 十四、交付前 Gate

每轮回复或代码修改前检查：

- [ ] 当前处于哪个 Phase；
- [ ] 当前是 DISCUSSION / ARTIFACT REVIEW / APPROVED 中哪个状态；
- [ ] 如果仍在 DISCUSSION，是否保持最小必要回应；
- [ ] 如果只是局部问题，是否只回答当前问题；
- [ ] 是否真的出现了用户冻结信号；
- [ ] Phase 0 Contract 是否已确认；
- [ ] 上一个 Phase 是否已确认；
- [ ] 当前只产出本 Phase 允许的 artifact；
- [ ] 是否错误跨到后续 Phase；
- [ ] 业务目标是否能追踪到 Integration Scenario；
- [ ] Scenario purpose 是否先于测试代码评审；
- [ ] Integration Test 是否验证可观察行为；
- [ ] Production Implementation 是否只实现已评审 Contract；
- [ ] Unit Test 是否没有提前出现；
- [ ] 是否错误把 compile / test / CI success 当成用户确认。

# 核心判断

> 用户先定义问题，AI 默认跟随讨论；用户准备冻结时再形成 Contract。先确认 Contract，再确认要证明什么；先确认 Integration Test，再写实现；先确认实现，再写 Unit Test。

TDD 的关键不是让 AI 尽快收敛，而是让业务 Contract 在实现之前由用户主导、显式冻结、可执行、可评审地固定下来。
