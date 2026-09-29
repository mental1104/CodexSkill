---
name: tdd-workflow
description: Mandatory cross-language TDD workflow and phase gate. Use whenever the user explicitly asks for TDD/test-driven development, requires integration tests before production implementation, or asks to advance implementation through reviewed test stages. This skill owns requirement-to-integration-scenario traceability, explicit user approval gates, phase sequencing, and integration-vs-unit test responsibilities. When active, its current phase gate has the highest priority among coding skills for deciding what artifacts may be produced; language-specific code-style and code-comment-writing still apply inside the currently approved phase.
---

# TDD Workflow

## 定位

这是跨语言的 TDD 工作流 Skill。

它不负责：

- Python / C++ / Go 等语言的具体编码风格；
- 某个测试框架的 API；
- CMake、pytest、go test 等工具的全部细节；
- 注释格式。

它只负责：

- 从业务目标建立可追踪的 Integration Scenario；
- 区分 Integration Test 与 Unit Test 的责任；
- 控制 TDD 阶段顺序；
- 在阶段之间建立强制的用户确认 gate；
- 防止模型把“先测试后实现”误解成“一次回复里先输出测试、随后马上输出实现”。

核心原则：

> TDD Skill 决定当前阶段“允许产出什么”；语言 Skill 和注释 Skill 决定这些产物“应该怎样写”。

# 一、触发边界

以下情况应自动应用本 Skill：

- 用户明确说使用 TDD / test-driven development；
- 用户要求“先写测试再实现”，并且语义明确要求按阶段推进；
- 用户要求先设计或评审 Integration Test，再开始实现；
- 用户明确要求 Integration Test → 实现 → Unit Test 分阶段完成；
- 用户要求每一阶段经过确认后再继续。

以下请求默认不自动进入本工作流：

- “给这个函数补几个单元测试”；
- “修这个 bug，顺便加测试”；
- “把现有测试修好”；
- “跑一下测试”；
- 普通代码生成任务中附带“需要测试”，但没有 TDD 或阶段确认语义。

不要因为看见“测试”两个字就强制用户进入多轮 TDD。

# 二、优先级与 Skill 组合

当本 Skill 激活时，编码 Skill 的执行优先级为：

1. 用户当前任务中的明确要求；
2. 仓库必须遵守的 API / ABI / 协议 / AGENTS.md / CONTRIBUTING.md 等硬约束；
3. **本 Skill 的当前 TDD phase gate；**
4. 语言级 code-style Skill；
5. `code-comment-writing` 等代码质量 companion Skill；
6. 项目未明确规定的历史习惯。

其中第 3 项只控制：

- 当前能否生成测试代码；
- 当前能否生成 production implementation；
- 当前能否生成 unit test；
- 当前是否必须停止等待用户确认。

它不覆盖语言 Skill 对类型、ownership、错误模型、测试组织、构建系统等具体约束。

如果本 Skill 当前阶段禁止生成 production code，那么即使语言 Skill 已经知道怎样实现，也必须停止。

# 三、四阶段状态机

TDD 流程固定为：

```text
业务需求
  ↓
Phase 1: Integration Scenario Review
  ↓ 用户显式确认
Phase 2: Integration Test Implementation
  ↓ 用户显式确认
Phase 3: Production Implementation
  ↓ 用户显式确认
Phase 4: Unit Test
```

不得在同一轮中自动跨越两个 phase。

每次用户确认只能确认**已经看到的当前阶段产物**，不能预先批准尚未生成的后续阶段。

例如：

- “这版场景可以，写测试”可以从 Phase 1 进入 Phase 2；
- “测试这版确认，开始实现”可以从 Phase 2 进入 Phase 3；
- “实现没问题，补单测”可以从 Phase 3 进入 Phase 4。

初始请求中的：

- “直接全部做完”；
- “后面都默认确认”；
- “不用停，继续到底”；

不应被解释为对尚未出现的 phase artifact 的提前评审。

如果用户明确表示本次**退出 TDD 阶段 gate**、取消逐阶段确认或改用其他流程，则遵循用户当前明确要求。

# 四、Phase 1：Integration Scenario Review

## 1. 从业务目标直接转译

在写 production code 之前，先把用户给出的业务目标转换成 Integration Scenario。

原则上，每一条独立业务目标都应能追踪到至少一个 Integration Scenario。

如果多个目标天然属于同一个不可分割的业务 journey，可以由一个较粗粒度场景共同覆盖，但必须显式标明每条需求被哪个场景覆盖。

不要为了“测试粒度更细”把一个完整业务目标机械拆成大量实现细节测试。

## 2. 每个场景必须先评审目的

Phase 1 只输出测试设计，不输出测试代码，也不输出 production implementation。

每个 Integration Scenario 至少说明：

- 场景名称；
- 场景目的；
- 对应的业务目标；
- 前置 fixture / 环境边界；
- 关键 Action 顺序；
- 可观察的 Expectation；
- 为什么这个场景能够证明对应需求已经满足。

测试目的没有经过用户确认前，不得进入 Phase 2。

## 3. Integration Test 验证用户可观察行为

Integration Test 优先观察：

- 公共接口；
- 协议行为；
- 组件之间的真实交互；
- 最终状态；
- 对外输出；
- 可观察副作用。

不要默认通过大量内部字段、private state 或实现细节证明业务成立。

Integration Test 是业务需求的 executable specification，不是内部实现快照。

# 五、Phase 2：Integration Test Implementation

只有 Phase 1 得到用户明确确认后，才能编写 Integration Test。

本阶段允许：

- Integration Test 代码；
- 测试 fixture / harness；
- fake / stub / protocol-level test peer；
- 测试数据 builder；
- 让 Integration Test 能被构建、发现、运行所必须的测试配置；
- 仅为表达已评审公共 contract 所必需的最小接口声明或测试接缝。

本阶段禁止：

- 实现真实业务逻辑；
- 顺手补 production implementation；
- 提前补 Unit Test；
- 因为测试“不方便写”而擅自改变已评审业务目标。

如果实现测试时发现：

- 场景目的不成立；
- requirement mapping 需要改变；
- 可观察结果必须改；
- fixture 边界会实质改变场景含义；

必须回到 Phase 1 重新评审，而不是静默修改测试目的。

# 六、Integration Test 的可读性

Integration Test 应优先读起来像一段业务或协议行为，而不是一串零散断言。

推荐表达：

```text
Scenario
→ Action
→ Expectation
→ Action
→ Expectation
→ Final Expectation
```

对于复杂状态机、协议和组件协作，可建立职责明确的 fixture / harness，把：

- socket；
- transport；
- clock；
- mock server；
- 消息封装；
- 低层字段构造；

等机制噪声隐藏起来，让测试正文保留领域动作和领域期望。

可参考 CS144 一类测试的阅读方式：

```text
Connect
→ Expect SYN
→ Receive SYN/ACK
→ Expect ESTABLISHED
```

这里参考的是“场景步骤可读性”和“Action / Expectation”结构，不要求复制任何特定 harness API、类名或框架实现。

不要为了追求 DSL 感而提前设计一套庞大的测试框架。只有重复机制已经妨碍场景阅读时才抽 fixture / harness。

# 七、Integration Test 必须与默认快速测试路径隔离

Integration Test 默认应拥有显式的 opt-in 入口。

目标是：

- 普通 build / unit-test 流程保持快速；
- Integration Test 需要用户或 CI 明确选择时才进入；
- 不因为新增 Integration Test 就让所有开发者默认承担外部依赖、长耗时或复杂 fixture。

具体机制由语言 / 构建系统 Skill 和仓库约定决定，例如：

- CMake option；
- pytest marker / command-line selector；
- Go build tag / test flag；
- Gradle source set / task；
- 其他项目已有 test profile。

本 Skill 不规定具体参数名。

# 八、Phase 3：Production Implementation

只有 Phase 2 的 Integration Test 已经由用户明确确认后，才能进入 production implementation。

本阶段目标：

> 用最小、清晰、符合语言 Skill 的实现满足已经评审的业务 contract。

本阶段应：

- 以已确认 Integration Scenario 为实现边界；
- 让 Integration Test 从 red 走向 green；
- 遵守语言级 code-style；
- 遵守 `code-comment-writing`；
- 不擅自扩展 Integration Scenario 未要求的新行为；
- 不提前创建新的 Unit Test。

如果实现过程中发现业务 contract 本身需要调整，应停止并回到 Integration Scenario Review，而不是让实现反过来偷偷改变测试。

# 九、Phase 4：Unit Test

只有 Phase 3 production implementation 已由用户明确确认后，才能新增 Unit Test。

Unit Test 主要验证：

- 单个 class / function / module 的局部行为；
- invariant；
- 算法边界；
- 错误路径；
- 细粒度状态转换；
- 难以通过粗粒度 Integration Test 定位的局部逻辑。

Unit Test 不承担业务需求完整覆盖的主要责任。

不要用几十个 Unit Test 替代一个本应存在的业务 Integration Scenario。

Unit Test 的框架、目录组织、fixture 风格和命名由语言 Skill / 仓库约定决定。

# 十、显式确认判定

可以视为当前 phase 已确认的自然语言包括：

- “确认”；
- “可以”；
- “按这版”；
- “这版没问题”；
- “继续写集成测试”；
- “开始实现”；
- “补单测”；
- 其他清楚表达“当前已经展示的产物可以进入下一阶段”的语句。

以下情况不能视为确认：

- 用户没有回复；
- 测试通过；
- 编译通过；
- CI 通过；
- 模型认为“应该没问题”；
- 用户在看到当前阶段产物之前提前说“后面都默认同意”。

不得根据沉默或自动化结果推断用户批准。

# 十一、与其他 Skill 的职责边界

## Router

Router 负责：

- 判断是否进入 TDD workflow；
- 加载本 Skill；
- 加载对应语言 code-style；
- 在当前 phase 真正需要输出代码时加载 `code-comment-writing`；
- 保证本 Skill 的 phase gate 在编码 Skill 之间优先。

## 语言 code-style

语言 Skill 负责：

- 具体类型和 API 设计；
- 测试框架默认值；
- 测试文件结构；
- 构建系统接入；
- formatter / linter / static analysis；
- 语言特有可读性和工程约束。

语言 Skill 不得改变 TDD phase 顺序。

## code-comment-writing

`code-comment-writing` 只在当前 phase 允许生成代码时约束代码注释。

它不能因为“所有代码都必须有注释”而推动 workflow 提前生成代码。

# 十二、交付前 Gate

当本 Skill 激活时，每轮回复或代码修改前检查：

- [ ] 当前处于哪个 phase；
- [ ] 上一个 phase 是否已由用户明确确认；
- [ ] 当前输出是否只包含该 phase 允许的 artifact；
- [ ] 是否错误地把后续 phase 一起做掉；
- [ ] 每条业务目标是否能追踪到 Integration Scenario；
- [ ] Integration Scenario 的 purpose 是否先于测试代码得到评审；
- [ ] Integration Test 是否主要验证用户可观察行为；
- [ ] Integration Test 是否读起来像清晰的 Action / Expectation 场景；
- [ ] Integration Test 是否与默认快速测试路径隔离；
- [ ] Production Implementation 是否只实现已评审 contract；
- [ ] Unit Test 是否没有提前出现在 implementation 之前；
- [ ] 当前 phase 中的代码是否同时满足语言 Skill 和 `code-comment-writing`；
- [ ] 是否错误地把 compile / test / CI success 当成用户确认。

只要当前 phase 尚未得到用户确认，就必须停在该 gate，不得继续。

# 核心判断

> 先确认“要证明什么”，再写 Integration Test；先确认 Integration Test，再写实现；先确认实现，再写 Unit Test。

TDD 的关键不是把测试文本排在实现文本前面，而是让业务 contract 在实现之前被显式、可执行、可评审地固定下来。
