# New C++ project GoogleTest regression

## Purpose

验证自然语言“从零创建 C++ 项目并补单元测试”的请求能否自动执行 `cpp-code-style` 的测试框架默认规则，避免再次出现测试源码已经生成，但 `CMakeLists.txt` 没有接入 GoogleTest、导致测试无法由项目构建系统执行的回归。

测试 prompt 不应显式提及 Skill 名称，也不应直接告诉模型使用 GoogleTest。

## Natural-language prompt

请从零创建一个 C++20 的小型矩阵库。

要求：

- 实现一个 `Matrix` 类型，元素使用 `double`；
- 支持矩阵加法、减法、乘法和转置；
- 输入矩阵在运算过程中保持只读；
- 不引入与需求无关的复杂抽象；
- 使用 CMake 构建；
- 为正常运算、维度不匹配和非方阵场景补充必要的单元测试；
- 给出可以直接配置、编译和运行测试的完整项目结构。

## Required observations

在这是一个全新 C++ / CMake 项目、仓库没有既有测试框架且用户没有指定其他测试框架的前提下，生成结果应体现：

- 默认使用 GoogleTest 编写单元测试；
- `CMakeLists.txt` 或拆分的 CMake 配置真实声明 / 获取 GoogleTest 依赖；
- 测试 target 正确链接 GoogleTest，例如使用项目实际可用的 `GTest::gtest` / `GTest::gtest_main` 或等价 target；
- CMake 启用测试能力；
- GoogleTest 测试被注册到 CTest，例如通过 `gtest_discover_tests()`、`add_test()` 或仓库约定的等价方式；
- 用户可以通过项目正常构建流程生成测试可执行文件，并通过 `ctest` 或仓库标准测试入口运行；
- 不只是创建 `tests/*.cpp`，而是让测试成为构建系统的一部分。

GoogleTest 的获取方式不做机械限定。可以使用仓库既有依赖管理方式、`find_package`、`FetchContent`、submodule 或其他明确构建依赖，只要不存在隐藏的机器环境依赖。

## Regression failures

下列现象视为失败：

- 生成了 GoogleTest 测试源码，但 `CMakeLists.txt` 完全没有 GoogleTest 依赖配置；
- 测试 target 没有链接 GoogleTest；
- 测试源码存在，但没有 CTest 注册或其他项目标准测试入口；
- 从零项目在没有任何理由的情况下选择另一套测试框架；
- 假设开发机已经全局安装 GoogleTest，却没有在构建契约中体现该依赖；
- 已经能够配置 / 编译业务库，但测试 target 实际无法构建或无法被测试入口发现。

如果目标仓库已经存在其他测试框架，继续沿用现有框架不视为失败；本 regression 专门覆盖“从零创建且无既有约束”的场景。

## Pass condition

同一个自然语言 prompt 在不显式要求测试框架的情况下，能够稳定生成以 GoogleTest 为默认单元测试框架、且 CMake / CTest 接入完整的可执行测试工程。
