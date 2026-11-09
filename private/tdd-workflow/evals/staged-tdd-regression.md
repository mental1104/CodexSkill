# Staged TDD workflow regression

## Purpose

验证自然语言 TDD 请求能否自动触发跨语言 `tdd-workflow`，并与语言级 code-style / comment Skill 组合，而不是一次性把 Integration Test、production implementation 和 Unit Test 全部生成。

该 regression 覆盖正文的五阶段 gate，而不是某个具体测试框架语法。本文是任务定义，不记录已经通过的独立会话实测。执行时记录 skill revision、实际产物、diff 和运行证据，区分场景推演、静态检查及真实调用。

## Initial natural-language prompt

请按 TDD 帮我实现一个文件传输任务调度器。

业务要求：

- 提交任务后进入 pending；
- 有执行资源时进入 running；
- 成功后进入 completed；
- 失败后进入 failed，并保留失败原因；
- 同一个任务不能同时被两个 worker 执行；
- 我希望先把测试设计好再开始写实现。

先把这些约定整理成黑盒 Contract，未明确的输入输出请标出来，供我评审。

## Turn 1 required observations

第一次响应只能形成 Phase 0 的 Black-box Contract 产物。

应看到：

- 区分用户已明确的输入、输出、状态与仍待决定项；
- 不自行补完重试、取消、持久化等未定语义；
- 不提前设计内部实现或集成场景；
- 不输出 production code；
- 不输出 Unit Test；
- 不直接开始写 Integration Test 代码；
- 结尾明确停在当前 gate，等待用户评审 Contract。

## Turn 1 regression failures

以下任一情况失败：

- 同一轮直接给出完整实现；
- 同一轮给出 Integration Test 源码；
- 同一轮给出 Unit Test；
- 未经确认就跳过 Contract，直接生成 Integration Scenario；
- 用大量内部字段断言替代用户可观察业务状态；
- 说“我先继续实现，之后你再看”。

## Turn 2 user message

这版 Contract 可以，开始设计集成场景。

## Turn 2 required observations

第二轮只进入 Phase 1：Integration Scenario Review。

应看到每条业务目标与场景目的、公开动作、外部期望及 fixture 边界的映射；不写测试或生产代码，完成后等待用户评审场景。

## Turn 3 user message

这版场景可以，开始写集成测试。

## Turn 3 required observations

第三轮只能进入 Phase 2：Integration Test Implementation。

应看到：

- Integration Test 与必要 fixture / harness；
- 测试仍保持业务场景可读性；
- 测试存在显式 opt-in 的运行 / 构建入口；
- 可以增加测试构建配置；
- 不实现真实 production behavior；
- 不新增 Unit Test；
- 写出完整最终断言，不用无条件失败标记代替；
- 说明当前 RED 的原因及尚未执行到的断言，不把缺依赖或启动错误当作业务失败；
- 完成后再次停住，等待用户确认测试本身。

如果目标语言是 C++ / CMake，还应同时应用 `cpp-code-style`：

- 新项目无既有测试框架时默认 GoogleTest；
- Integration Test 通过仓库既有 CMake option，或无约定时通过专用且默认关闭的 integration-test option 选择性编译；
- 不把 Integration Test 无条件加入默认 build。

## Turn 4 user message

集成测试这版确认，开始实现。

## Turn 4 required observations

第四轮只能进入 Phase 3：Production Implementation。

应看到：

- 实现只覆盖已确认的 Integration Scenario；
- 应用对应语言 code-style；
- 应用 `code-comment-writing`；
- 可以运行 Integration Test 让它从 red 到 green；
- 不新增 Unit Test；
- 实现完成后再次停住等待用户确认。

## Turn 5 user message

实现确认，补单元测试。

## Turn 5 required observations

第五轮进入 Phase 4，才允许新增 Unit Test。

Unit Test 应聚焦：

- 局部 component / function；
- invariant；
- 边界条件；
- error path；
- 细粒度状态转换。

不应重新用大量 Unit Test 取代已经存在的 Integration Scenario coverage。

## Focused regression: incomplete RED test

已处于 Phase 2，场景承诺通过公开任务入口接收并发布文件，但测试只调用传输组件、核对 staging，最后无条件失败。用户说：“用例还不完整，把最终文件和上层结果也写出来。”

应观察：补齐已确认的公开入口与最终断言，修正测试规格；既不声称人工断点已经证明业务 RED，也不把这条纠正当作 Phase 3 授权。未改变契约时不重复要求批准原场景。

## Focused regression: real service boundaries

用户已确认两端独立服务通过真实发现机制取得地址，调用方只传设备身份；服务接收任务后自行发现、建连并返回进度和最终发布结果。测试采用本机回环，两端身份和上层服务名可注入；只要求测试限速以便看到进度。

应观察：以公开客户端触发业务，各端独立管理资源并发布本端信息；fixture 只负责环境、输入和外部观察，不把远端端口从测试对象里读出后注入调用方，不用传输后端调用代替被测业务，不新增生产带宽预算或公平性契约。

反向输入：这次只测发现客户端解析独立协议 peer 发布的地址，允许替身，不要求运行真实对端服务。

应观察：允许按约定用协议 peer 发布记录，不机械要求所有集成测试双进程，也不禁止发布端读取自己的实际端口。缓存命中是否足够由契约决定，不强制每次重新发包。

## Adjacent non-triggers

- 用户仍在说“我先讲需求，先别整理”时，保持 DISCUSSION，不因材料变多自动形成 Contract。
- 普通修复附带“补几个测试”时，不触发 TDD 阶段审批。
- 环境缺少依赖导致测试未启动时，报告环境问题，不称为已运行的业务断言失败。
- 真实网络但 fixture 代做发布、无条件失败但缺最终断言、只跑组件却声称上层端到端通过，均判失败。

## Pass condition

自然语言请求不显式点名 Skill 时，Router 能稳定组合：

```text
tdd-workflow phase gate
+ language code-style
+ code-comment-writing
```

并且任一语言级 Skill 都不能推动任务越过当前尚未确认的 TDD phase。
