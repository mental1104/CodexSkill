# Staged TDD workflow regression

## Purpose

验证自然语言 TDD 请求能否自动触发跨语言 `tdd-workflow`，并与语言级 code-style / comment Skill 组合，而不是一次性把 Integration Test、production implementation 和 Unit Test 全部生成。

该 regression 重点覆盖多轮阶段 gate，而不是某个具体测试框架语法。

## Initial natural-language prompt

请按 TDD 帮我实现一个文件传输任务调度器。

业务要求：

- 提交任务后进入 pending；
- 有执行资源时进入 running；
- 成功后进入 completed；
- 失败后进入 failed，并保留失败原因；
- 同一个任务不能同时被两个 worker 执行；
- 我希望先把测试设计好再开始写实现。

## Turn 1 required observations

第一次响应只能停留在 Integration Scenario Review。

应看到：

- 每条业务目标与 Integration Scenario 的明确映射；
- 每个场景写清 purpose；
- 场景由清晰 Action / Expectation 步骤构成；
- 说明必要 fixture / worker 边界；
- 不输出 production code；
- 不输出 Unit Test；
- 不直接开始写 Integration Test 代码；
- 结尾明确停在当前 gate，等待用户评审当前场景。

## Turn 1 regression failures

以下任一情况失败：

- 同一轮直接给出完整实现；
- 同一轮给出 Integration Test 源码；
- 同一轮给出 Unit Test；
- 只列“应该测什么”但没有 requirement traceability；
- 用大量内部字段断言替代用户可观察业务状态；
- 说“我先继续实现，之后你再看”。

## Turn 2 user message

这版场景可以，开始写集成测试。

## Turn 2 required observations

第二轮只能进入 Integration Test Implementation。

应看到：

- Integration Test 与必要 fixture / harness；
- 测试仍保持业务场景可读性；
- 测试存在显式 opt-in 的运行 / 构建入口；
- 可以增加测试构建配置；
- 不实现真实 production behavior；
- 不新增 Unit Test；
- 完成后再次停住，等待用户确认测试本身。

如果目标语言是 C++ / CMake，还应同时应用 `cpp-code-style`：

- 新项目无既有测试框架时默认 GoogleTest；
- Integration Test 通过仓库既有 CMake option，或无约定时通过专用且默认关闭的 integration-test option 选择性编译；
- 不把 Integration Test 无条件加入默认 build。

## Turn 3 user message

集成测试这版确认，开始实现。

## Turn 3 required observations

第三轮只能进入 Production Implementation。

应看到：

- 实现只覆盖已确认的 Integration Scenario；
- 应用对应语言 code-style；
- 应用 `code-comment-writing`；
- 可以运行 Integration Test 让它从 red 到 green；
- 不新增 Unit Test；
- 实现完成后再次停住等待用户确认。

## Turn 4 user message

实现确认，补单元测试。

## Turn 4 required observations

第四轮才允许新增 Unit Test。

Unit Test 应聚焦：

- 局部 component / function；
- invariant；
- 边界条件；
- error path；
- 细粒度状态转换。

不应重新用大量 Unit Test 取代已经存在的 Integration Scenario coverage。

## Pass condition

自然语言请求不显式点名 Skill 时，Router 能稳定组合：

```text
tdd-workflow phase gate
+ language code-style
+ code-comment-writing
```

并且任一语言级 Skill 都不能推动任务越过当前尚未确认的 TDD phase。
