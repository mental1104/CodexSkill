# Transfer config regression

## Purpose

验证自然语言 Python 编码请求能否自动触发并完整执行 `python-code-style`，尤其覆盖已经真实发生过的 schema、mode、错误模型和 public API 回归。

测试 prompt 不应显式提及 Skill 名称，也不应直接告诉模型必须使用 Pydantic、Enum 或策略模式。

## Natural-language prompt

请实现一个文件传输配置解析模块。

配置来自 JSON 文本，支持两种模式：

- local：包含 mode、source_path、destination_path；
- remote：包含 mode、source_path、target_url、timeout_seconds。

要求：

- 校验输入配置；
- 拒绝未知字段；
- 所有必需字段缺失时应报错；
- remote 的 timeout_seconds 必须为有限正数；
- target_url 必须是带协议和主机的 URL；
- 解析完成后返回执行层可以直接消费的不可变 typed model；
- 执行层不继续依赖原始 JSON / dict；
- 模块只负责配置转换，不访问文件系统和网络；
- 补充最小必要测试。

如果当前项目已经存在适合的模型/校验依赖，优先沿用现有依赖，不要重复造轮子。

## Required observations

在项目已经存在 Pydantic 且适合该边界模型的环境下，生成结果应体现：

- 使用声明式 schema model 表达 required / default / extra / 基础字段约束；
- 不再手写第二份字段集合；
- mode 使用稳定 typed representation，例如 `StrEnum` / `Enum`；
- local / remote 分别落到具体 typed model；
- 动态 JSON 在边界结束，内部不继续传播裸 Mapping；
- 对外只保留任务真正需要的 canonical parser API；
- 错误模型保持轻量；
- runtime-visible error/log/diagnostic strings 使用 ASCII English；
- 成组私有解析/校验逻辑具有清晰职责归属；如果形成一组 helper 家族，优先进入职责明确的私有类；
- 文件按逆向调用拓扑组织：低层被调用实现位于上方，public entry 位于其依赖实现之后并靠近文件底部；
- 生成的 pytest 测试如果围绕同一个 parser / public API 形成多个 case，应使用清晰的 `TestXxx` class 聚合，而不是全部平铺在模块级。

如果 local / remote 的模式特有行为已经包含多步独立解析、校验或构造逻辑并明显会随模式增长，应优先让模式拥有独立 strategy / polymorphic implementation，而不是继续扩大中央 `if/elif`。如果只是一个很轻的 typed dispatch，则不要求为了模式名称强造策略类。

## Regression failures

除非 prompt、仓库公共 API 或明确兼容要求真的要求，下列现象视为失败：

- 出现 `_LOCAL_FIELDS` / `_REMOTE_FIELDS` / required tuple 等第二份 schema 字段表；
- 出现 `check_schema()` 一类手写 schema engine，而项目已有适合的 Pydantic；
- 在多处使用 `mode == "local"` / `mode == "remote"` 等魔法字符串；
- 同时新增 `parse_transfer_plan`、`parse_transfer_config`、`load_transfer_plan` 等同义 public API；
- 自行把输入扩展为 bytes / bytearray / Mapping，而需求只要求 JSON 文本；
- 为 missing/type/value/mode/unknown-field 分别创建一整套异常子类，而调用方没有独立 catch / recovery 需求；
- 一组 `_decode_*` / `_read_*` / `_validate_*` / `_required_*` helper 无职责归属地平铺整个模块，而没有封装进明确私有职责类；
- public parser / facade 出现在文件中部或顶部，而它调用的私有 helper 大量定义在其后方；
- 针对同一个 parser / public API 的多个 pytest case 全部以模块级 `test_*` 函数平铺，没有明确 test class 归属；
- runtime exception/log/diagnostic 文本使用中文；
- pytest 通过后直接交付，却仍明显违反上述规则。

## Pass condition

同一个自然语言 prompt 在不显式提醒编码风格的情况下，能够稳定生成符合 `python-code-style` mandatory gates 的实现；测试通过只是必要条件，不是充分条件。
