---
name: python-code-style
description: Mandatory personal Python coding conventions. Use automatically whenever creating, modifying, refactoring, fixing, or outputting executable Python code, even when the user does not explicitly mention this skill. Prefer static-analysis-first design, complete boundary modeling instead of dict/JSON-shaped internal APIs, preserved concrete type relationships, no unrequested runtime plugin registries, visible state changes, responsibility-grouped private implementations, canonical naming, read-only-oriented parameters, and IDE-discoverable contracts. Always pair with code-comment-writing. Apply repository-specific mandatory constraints when they directly conflict, but do not copy legacy dynamic patterns into new code merely because they already exist.
---

# Python Code Style

## 定位

这是 Python 编码任务的个人工程风格约束。

只要任务涉及以下任一行为，就应自动应用本 Skill：

- 新增 Python 代码；
- 修改已有 Python 代码；
- 修复 Python 缺陷；
- 重构 Python 实现；
- 设计 Python API；
- 编写 Python 测试；
- 输出准备直接进入项目的 Python 代码。

本 Skill 主要约束：

- API 如何表达数据和行为；
- 类型信息何时确定；
- 动态数据在哪一层结束；
- 参数和状态如何发生变化；
- 哪些错误应在静态分析阶段暴露；
- 如何让调用者只看接口和调用顺序就能理解主要行为。

格式化、换行、单双引号、import 排序等机械规则交给项目已有 formatter、linter 和静态检查工具。

`code-comment-writing` 负责注释和文档要求，本 Skill 不重复定义注释细则。所有 Python 编码任务必须同时应用 `code-comment-writing`；如果其中文优先、docstring、参数/返回值和关键路径注释要求未满足，则代码不能视为完成。

# Mandatory generation gates

以下规则属于 Python 代码交付前的强制 gate。它们不是可选建议，也不能因为测试通过就跳过。

1. **稳定外部 schema 必须声明式建模。** 如果项目已经使用 Pydantic，或当前任务允许使用项目已有 Pydantic 依赖，优先使用 `BaseModel` / `Field` / validator / discriminated union 表达 required、optional、default、extra 和基础约束；不要手写第二套 schema engine。
2. **schema 只保留一个事实源。** 已有明确模型后，不要再维护 `_LOCAL_FIELDS`、`_REMOTE_FIELDS`、required tuple、`check_schema()` 等重复字段清单。
3. **有限稳定状态不要散落魔法字符串。** 对稳定且有限的 mode / status / kind 等，优先使用 `Enum` / `StrEnum` 或其他明确 typed representation；不要让 `"local"`、`"remote"` 之类字符串在分支、校验和构造逻辑中重复出现。
4. **不要擅自扩大兼容面和 public API。** 未经用户、协议、已有公共 API 或明确迁移计划要求，不新增 bytes / Mapping 等额外输入形态，不新增字段 alias、fallback、兼容入口，也不增加多个同义 public parser / loader。
5. **错误模型保持轻量。** 如果调用方只需要错误类别、字段和说明，优先使用一个异常类型 + typed error code；不要按每个错误类别机械创建异常子类。
6. **运行时可见字符串使用 ASCII English。** 日志、异常文本、CLI/stdout/stderr、assertion 和诊断字符串不得因为注释中文优先而改成中文。
7. **相关私有实现必须有职责归属。** 当存在一组共同服务于解析、校验、构造或适配的私有 helper 时，应优先封装进职责明确的私有类；不要让一串 `_decode_*` / `_read_*` / `_validate_*` / `_required_*` 在模块级平铺。只有极小、无状态、天然属于整个模块且不形成职责组的 helper 才保留为模块级函数；同时不要为了消灭 helper 强造万能类。
8. **文件按逆向调用拓扑组织。** 除 import、枚举/常量/协议和基础模型外，默认让被调用的低层实现位于上方，调用它们的高层实现位于下方；public facade / public entry 属于调用链最外层，应靠近文件底部，`__all__` 最后。不要先写 public entry，再在后面补它调用的一串 helper。
9. **pytest 测试按被测职责聚合。** 当多个测试围绕同一个 public API、class、组件或行为域时，优先使用命名明确的 `TestXxx` class 聚合，而不是把一长串 `test_*` 函数平铺在模块级。测试类只承担组织职责，不要为了 OOP 引入无意义共享状态、setup 层次或继承。只有少量彼此独立、无法形成清晰职责组的测试才保留模块级函数。
10. **生成完成后必须回看本 Skill。** formatter、测试和 type checker 全部通过仍不等于完成。交付前必须按本 Skill 的 mandatory gates 和末尾 checklist 重新审查生成代码，并主动修正明显冲突。

如果当前任务与这些 gate 发生真实冲突，必须以“用户明确需求 / 仓库强制约束 / 公共 API 兼容”为依据，而不是以“实现方便”作为绕过理由。

# 一、规则优先级

发生冲突时按以下顺序处理：

1. 用户当前任务中的明确要求；
2. 仓库的 `AGENTS.md`、`CONTRIBUTING.md`、公共 API 兼容要求和其他强制规范；
3. 本 Skill；
4. 项目已有但未明确规定的历史代码风格。

已有代码使用动态、弱类型或隐式副作用，不代表新增代码必须继续复制。

当修改范围允许时，应让新增或修改的接口逐步向本 Skill 靠拢，而不是为了保持历史一致性继续制造新的设计债务。

# 二、Static First

## 1. 尽可能提前确定程序性质

能够在以下阶段确定的问题，不应无故拖到业务运行期：

- IDE 编辑期；
- Pylance / Pyright / mypy 等静态分析阶段；
- import / 初始化阶段；
- 程序边界解析和校验阶段。

核心原则：

> 稳定约束应尽量编码进类型和接口；运行期只处理真正依赖动态输入、外部状态和运行环境的事情。

例如：

- 参数和返回值应有明确类型；
- 有限状态使用 `Enum`、`Literal` 或明确类型，而不是任意字符串；
- 明确的可空语义使用 `T | None`；
- 稳定的数据结构应建模为类型；
- 类型之间的关系应尽量通过泛型、`Protocol` 或继承关系表达；
- 能让静态分析器完成 narrowing 时，不依赖随后的猜测、异常或 `Any`。

## 2. 新增函数默认必须有完整类型注解

新增或修改的正常业务函数，应明确标注：

- 每个参数；
- 返回值；
- 回调；
- 重要成员变量；
- 复杂容器的元素类型。

不要新增：

```python
def process(data, config):
    ...
```

也不要把：

```python
dict[str, Any]
list[Any]
Any
```

当作正常业务类型的默认逃生出口。

只有真实动态边界、无法提前知道的第三方数据或框架限制，才允许局部使用 `Any`。

即便不得不使用，也应尽快在边界完成 narrowing 或转换，不让 `Any` 向内部扩散。

## 3. 优先让 IDE 理解代码

设计 API 时应考虑调用者能否获得：

- 参数补全；
- 字段补全；
- 重命名跟踪；
- 跳转定义；
- 类型错误提示；
- exhaustiveness / narrowing；
- 明确的可空性；
- 明确的返回结果。

如果一种写法只有运行以后才知道字段、状态或对象能力，而另一种同样简单的写法能让静态分析器提前知道，优先后者。

## 4. 保留已经可以静态表达的类型关系

如果参数、返回值或两个 callable 之间的类型关系在编写代码时已经确定，不要为了统一接口、注册表或“以后扩展”而主动将其退化成 `object`、`Any` 或其他宽泛类型。

避免：

```python
ProcessingResult = FileResult | BatteryResult | object
EventParser = Callable[[Mapping[str, object]], object]
EventProcessor = Callable[[object], ProcessingResult]
```

这种设计会先擦除类型信息，再迫使后续代码通过 `isinstance()` 在运行期恢复它。

优先保持具体关系：

```python
def parse_file_uploaded(...) -> FileUploadedEvent:
    ...

def process_file_uploaded(event: FileUploadedEvent) -> FileProcessingResult:
    ...
```

如果确实需要动态注册或异构 registry，应把类型擦除限制在最小的基础设施边界，不要让 `object` / `Any` 扩散到正常业务函数。

核心原则：

> 一旦获得了可靠的静态类型信息，就不要在中间层主动把它弄丢。

## 5. 公共 API 不得为了内部动态机制退化类型

当公开方法的合法返回集合在源码中已经确定，应使用明确 union 或具体结果类型，不要因为内部使用 registry、factory、callback 或其他动态机制就把返回值退化成 `object` / `Any`。

避免：

```python
ProcessResult = FileProcessingResult | BatteryStatusResult | IgnoredEventResult

def process(message: object) -> object:
    ...
```

应优先：

```python
def process(message: object) -> ProcessResult:
    ...
```

如果确实存在用户明确要求的运行期插件能力，应把动态类型边界限制在插件接入层，不要污染正常业务 API 的类型信息。

# 三、动态数据止于边界

## 1. JSON 和裸字典不是内部业务模型

JSON、反序列化后的 `dict`、第三方 payload 等动态结构允许存在于系统边界，例如：

- HTTP 请求；
- MQTT / Kafka / ROS 消息；
- 配置文件；
- JSON 文件；
- 第三方 SDK；
- 数据库 JSON 字段；
- 环境变量和命令行输入。

它们进入系统后，应尽早完成：

```text
解析
→ 字段存在性校验
→ 字段类型校验
→ 必要的值域 / 枚举 / 可空性校验
→ 转换成明确的数据模型
→ 进入内部逻辑
```

不要让原始动态结构穿过多个业务函数。

## 1.1 边界建模必须完整

边界转换不能只建模公共字段，再把原始 JSON / dict 与部分模型一起传给内部 handler。

避免：

```python
context = parse_context(message)
return handle_file_uploaded(context, message)
```

其中 `message` 仍然是 `Mapping[str, object]`，事件专属字段依旧在内部业务逻辑中动态读取。

应在边界层一次性完成具体事件建模：

```python
event = parse_file_uploaded_event(message)
return handle_file_uploaded(event)
```

内部业务 handler 应只接收完整、明确、已经校验过的事件模型，例如：

```python
def handle_file_uploaded(event: FileUploadedEvent) -> FileProcessingResult:
    ...
```

对于带 discriminator 的 JSON，应在边界层根据 discriminator 选择具体解析器并构造具体事件模型；原始 mapping 到此为止，不再继续进入后续业务层。

核心原则：

> 动态数据一旦完成边界转换，就不要以“上下文 + 原始 dict”的形式继续泄漏到内部。

## 2. 固定 schema 禁止使用 dict 表达

只要一组数据存在稳定、可命名的字段语义，就应优先建模为：

- `dataclass`；
- 明确的普通 class；
- 已存在于项目中的数据模型机制；
- 第三方模型库已有类型；
- 必要时其他静态分析友好的结构。

内部业务函数的参数和返回值，不应使用 JSON / 字典状结构表达固定 schema。

避免：

```python
def process_user(data: dict[str, Any]) -> dict[str, Any]:
    ...
```

以及：

```python
status = result["status"]
user_id = result["user_id"]
```

散布在业务逻辑中。

更倾向先将数据转换为具有明确字段的对象，再进入处理逻辑。

## 3. TypedDict 不是内部模型的默认替代品

`TypedDict` 可以改善静态分析，但运行期仍然是字典。

对于稳定的内部业务对象，不要只是把：

```python
dict[str, Any]
```

机械替换成 `TypedDict` 就视为完成建模。

内部长期流动的数据优先使用真正具有字段和类型语义的对象。

`TypedDict` 更适合：

- 外部 payload 的类型描述；
- 与既有字典 API 兼容的边界；
- 短生命周期的适配层。

## 4. 边界 schema 优先声明式建模

对于 JSON、配置、请求参数等具有稳定字段集合的外部 schema，应优先让模型字段声明本身表达：

- 字段是否必填；
- 是否允许缺省；
- 默认值是什么；
- 是否允许 `None`；
- 基础类型；
- 枚举 / Literal；
- 能自然表达的简单值约束。

不要在已经存在明确模型定义的同时，再额外维护一份字段名 tuple、set、list 或 `check_schema()` / `required()` 规则表。

避免：

```python
class RemoteTransferPlan:
    ...

fields.check_schema(("mode", "source_path", "target_url", "timeout"))
```

这种设计会让同一份 schema 同时存在于模型字段和手写字段集合中，字段增删时容易产生漂移。

核心原则：

> schema 应尽量只有一个事实源；字段契约优先体现在模型声明中，而不是散落在 helper 和字段清单里。

如果当前项目已经使用 Pydantic，或任务允许使用项目已有的 Pydantic 依赖，应优先考虑：

- `BaseModel`；
- `Field`；
- `model_config`；
- field / model validator；
- discriminated union；

来表达外部边界 schema，而不是手写一套字段存在性、默认值、未知字段和基础类型校验框架。

例如：

```python
class RemoteTransferConfig(BaseModel):
    model_config = ConfigDict(extra="forbid")

    mode: Literal["remote"]
    source_path: Path
    target_url: str
    timeout: float
```

然后只为真正属于业务语义、Pydantic 无法自然表达，或需要访问多个字段关系的规则补充 validator。

不要：

- 为了使用这条规则给原本无第三方依赖的项目强行新增 Pydantic；
- 在用户明确要求“仅标准库”时引入 Pydantic；
- 为简单 schema 叠加 Pydantic model + 手写 `check_schema()` 两套校验；
- 把 Pydantic validator 当成新的万能 helper 层；
- 因为使用 Pydantic 就把内部执行层模型也全部改成 BaseModel，如果 dataclass / 普通 class 更适合内部不可变执行模型。

推荐边界：

```text
外部 JSON / Mapping
→ 声明式 schema model 完成字段契约和基础校验
→ 转换成内部执行模型
→ 内部逻辑
```

如果项目没有 Pydantic、任务禁止第三方依赖，或仓库明确采用其他模型机制，则继续使用标准库或项目既有方案，但仍应遵守“schema 单一事实源”，避免重复字段清单。

## 5. 动态映射本身是领域语义时允许 Mapping

如果数据的真实语义本来就是动态键值集合，例如：

- HTTP headers；
- labels；
- arbitrary metadata；
- 用户自定义 attributes；

可以使用映射类型。

但应优先明确：

```python
Mapping[str, str]
Mapping[str, AttributeValue]
```

而不是：

```python
dict[str, Any]
```

只读消费时优先使用 `Mapping`，不要无理由要求具体可变 `dict`。

# 四、外部数据必须运行期校验

Static First 不意味着相信来自外部世界的数据。

任何来自以下来源的数据都不能仅依赖类型注解：

- 网络；
- 文件；
- 消息系统；
- 数据库中的动态字段；
- 用户输入；
- 环境变量；
- 第三方 API。

边界层必须验证至少适用的项目：

- 必填字段是否存在；
- 字段运行期类型是否正确；
- `None` 是否允许；
- 枚举值是否合法；
- 数值范围是否合法；
- 嵌套结构是否合法；
- 协议版本或 discriminator 是否合法。

校验成功后立即转换成内部明确模型。

不要在后续每一层重新写：

```python
if "xxx" not in data:
    ...

if not isinstance(data["xxx"], ...):
    ...
```

同一份外部数据应尽量：

> validate once, model once, then trust the internal type.

## 内部可信接口不要重复进行静态契约校验

运行期类型校验主要用于系统边界和真实动态数据。

当内部函数已经通过类型签名建立可靠契约时，不要为了防御式编程重复写：

```python
def process(event: FileUploadedEvent) -> FileProcessingResult:
    if not isinstance(event, FileUploadedEvent):
        raise TypeError(...)
```

这种检查通常意味着上游类型设计已经被擦除。

优先修复类型关系，而不是在每一层增加运行期检查。

只有以下情况才保留内部运行期类型检查：

- 数据确实来自未受信任的动态来源；
- 第三方框架绕过静态类型系统；
- 运行期插件接口无法静态保证实现；
- 检查本身属于明确的协议边界。

核心原则：

> 如果运行期检查只是为了重新证明静态分析阶段本来就能知道的事实，优先修改接口设计，而不是增加检查。

## 不得擅自扩展业务校验规则

边界校验应来自以下依据：

- 用户明确给出的需求；
- 协议、标准或外部接口的明确约束；
- 仓库已有且当前任务必须遵守的业务规则；
- 为保证解析安全和类型正确所必需的基础校验。

不要因为“更严格看起来更安全”就自行增加业务限制。

例如，需求只说明字段是 URL 时，不应在没有依据的情况下额外禁止 fragment、userinfo、特定 query 形式或其他协议本身允许的结构；需求只说明字段是路径时，也不要擅自要求绝对路径、文件必须已存在或只能位于某个目录。

如果某项限制会改变哪些输入被业务接受，它就属于业务规则，而不是单纯的类型校验。没有明确依据时，应保持最小充分校验，并把进一步限制留给真正拥有该业务语义的层。

核心原则：

> 校验负责落实已知契约，不负责替需求发明新的契约。

## 错误模型保持轻量

错误需要可区分，不代表每一种错误都必须对应一个异常子类。

如果调用方只需要稳定判断错误类别、字段和说明，优先使用：

- 一个明确的异常基类或单一异常类型；
- 一个 `Enum` / `StrEnum` 错误码；
- 必要的字段名、上下文或结构化属性。

例如，一个 `ConfigError(code, field, message)` 已经能够完整表达配置失败时，不要机械扩展成 `MissingFieldError`、`FieldTypeError`、`UnknownModeError` 等一整套异常层次。

只有当不同错误类型需要被不同层分别捕获、具有不同恢复策略、携带显著不同的数据，或仓库公共 API 已经明确采用异常层次时，才创建独立异常子类。

判断标准：

> 错误模型的结构复杂度应与调用方真实处理需求匹配，而不是与错误类别数量匹配。

# 五、参数默认是输入

## 1. 普通处理函数默认不得偷偷修改参数

函数参数默认视为输入。

尤其禁止在具有多个业务参数的普通函数中，隐式修改其中某一个调用者拥有的对象。

例如下面这种接口应被视为设计警告：

```python
process(config, user, context)
```

如果 `process()` 内部偷偷执行：

```python
user.status = ...
```

调用者仅从调用点无法知道 `user` 在这一行发生了变化。

这会迫使调用者阅读函数实现才能理解状态流。

## 2. 状态变化必须在调用点可见

如果对象确实需要发生状态变化，应优先采用以下方式之一。

### 返回新状态

优先：

```python
normalized_user = normalize_user(user)
process(config, normalized_user)
```

让状态转换在赋值语句中可见。

### 使用明确的状态修改方法

当对象本身就是状态主体时：

```python
user.normalize()
process(config, user)
```

receiver 已经明确告诉调用者状态变化发生在 `user` 上。

### 使用独立的 command-style 函数

如果必须通过函数修改对象，应把修改动作隔离成一个职责明确的调用：

```python
normalize_user(user)
process(config, user)
```

不要把：

```text
修改状态
+
消费状态
+
生成结果
```

塞进同一个普通处理函数。

## 3. 避免多个可变输入 / 输出参数

不要设计需要调用者猜测：

```text
参数 A 是输入
参数 B 会修改
参数 C 偶尔修改
参数 D 用来接收输出
```

的接口。

尤其避免一个函数同时修改两个或更多调用方传入的对象。

如果一个操作产生多个结果，应优先：

- 返回明确的结果对象；
- 拆分状态变化；
- 拆成多个职责清晰的步骤。

## 4. 无返回值函数应具有明显副作用语义

返回 `None` 的业务函数通常意味着它执行了某种 command / side effect。

它的主要副作用应该：

- 单一；
- 明确；
- 可从函数名、receiver 或调用上下文推断；
- 不隐藏在多个普通输入参数之间。

如果一个 `None` 返回函数既修改参数、又修改全局状态、又产生远程副作用，应重新检查职责是否过宽。

# 六、优先只读接口

如果函数只需要读取一个集合或对象，就不要要求比实际需要更强的可变能力。

例如：

- 只遍历时考虑 `Iterable[T]`；
- 只读取映射时考虑 `Mapping[K, V]`；
- 只读取序列时考虑 `Sequence[T]`；
- 只依赖某组行为时考虑 `Protocol`。

参数类型应描述函数真正依赖的最小能力。

这样可以：

- 减少误修改；
- 提升复用性；
- 明确函数契约；
- 让静态分析器更准确地理解行为。

不要为了“以后可能要改”而提前暴露可变接口。

## 保持单一 canonical name

同一个概念应只有一个 canonical name。

不要为了“名字更顺口”、兼容不存在的旧接口、猜测未来调用习惯，或单纯追求别名便利性，为同一个 class、function、result 或 type 创建多个近义名称。

避免：

```python
FileProcessResult = FileProcessingResult
BatteryProcessingResult = BatteryStatusResult
```

也避免同时暴露语义完全一致的：

```python
handle_message(...)
process_message(...)

handle_json(...)
process_json(...)
```

除非存在明确的兼容性、协议映射、迁移窗口或领域语义差异，否则保留一个名字。

类型别名、函数别名和兼容入口都必须真实减少复杂度，而不是扩大调用者需要记忆的词汇表。

核心原则：

> 一个概念只保留一个正名；不要为了“方便”主动制造同义 API。

## 不得擅自扩展兼容性和公共接口

兼容逻辑、输入别名、fallback、迁移适配和额外公共入口都属于 API 契约的一部分，不能因为实现起来容易、看起来更友好，或“以后可能用得到”就自动加入。

未经明确需求，不要自行新增：

- 字段 alias 或旧字段名兼容；
- 同一语义的多个输入名称；
- 额外 fallback 路径；
- 历史格式兼容；
- 迁移期双写 / 双读入口；
- 额外 public function、public class 或 public type；
- 把内部 helper、Mapping 入口或中间层能力顺手暴露成公共 API；
- 为了“方便测试”或“方便调用”扩大正式支持的输入类型。

例如，需求只要求从 JSON 文本解析配置时，不要因为内部已经有 Mapping 解析函数，就把 Mapping 自动升级成公共输入契约；也不要自行支持 `source` / `source_path`、`url` / `target_url` 这类未声明别名。

如果为了实现主入口需要额外 helper，应默认保持 private。只有用户需求、既有公共 API、协议兼容要求或明确迁移计划需要时，才扩大兼容面和公共调用面。

核心原则：

> 不要因为代码能够兼容更多输入，就假设产品应该接受更多输入；不要因为内部能力存在，就把它自动变成公共能力。

# 七、内部实现按职责聚合

模块级下划线函数不是默认的内部组织方式。

当一组私有函数服务于同一类职责，例如：

- 外部消息字段解析；
- 事件模型构造；
- 业务结果生成；
- 状态转换；
- 协议适配；

应优先收敛到一个职责明确的私有类中维护，而不是把大量 `_xxx()` 函数平铺在整个模块。

例如可以使用：

```python
class _MessageParser:
    ...

class _EventHandler:
    ...
```

目标不是为了面向对象而制造 class，而是让文件结构本身表达职责边界。

避免创建 `_Utils`、`_Helpers` 这类无边界的万能私有类。

同样不要把“私有函数应结构化归类”误解为“把所有私有逻辑塞进一个私有类”。

私有类本身也必须具有单一、清晰的职责边界。如果一个私有类同时承担多个可以独立描述、独立变化的职责，例如：

- JSON 解码机制；
- schema 字段读取；
- 领域值校验；
- 业务对象构造；
- dispatch / orchestration；

应检查这些职责是否真的需要由同一个类维护。只有它们共同服务于同一抽象、共享同一状态或拆分反而增加理解成本时，才继续聚合。

不要制造 `_Utils`、`_Helpers`、`_Manager`、`_Parser` 之类名字看似具体、实际上不断吸收无关职责的“万能私有类”。

判断标准：

> 聚合是为了让职责更清晰，不是为了减少模块级函数数量。

以下情况可以保留模块级私有函数：

- 极小；
- 无状态；
- 职责天然属于整个模块；
- 与其他 helper 不形成明显的一组功能。

核心原则：

> 一组相关的私有实现应该有结构上的归属，而不是仅靠下划线表达“这是内部代码”。

当出现三个及以上明显属于同一职责链的私有函数，或函数名已经形成 `_decode_*`、`_read_*`、`_validate_*`、`_required_*` 这类家族时，应把“封装成职责明确的私有类”作为默认选择，而不是继续模块级平铺。只有拆成类反而破坏职责边界、增加状态耦合或明显降低可读性时，才保留函数组。

# 八、减少 stringly-typed 和 dictly-typed 设计

稳定语义不要长期编码在任意字符串、魔法 key 和匿名结构里。

避免大量：

```python
mode = "fast"
result["status"]
config["timeout"]
event["type"]
```

如果这些值具有稳定业务语义，应考虑：

- `Enum`；
- dataclass / model；
- 明确字段；
- discriminated union；
- `Protocol`；
- 专用 value object。

目标不是消灭字符串，而是避免让调用者依赖无法被 IDE 理解的隐式协议。

## 模式分派优先让类型拥有语义

当外部配置、消息或请求使用 discriminator（例如 `mode`、`type`、`kind`）区分多个稳定模式时，应先完成：

```text
discriminator
→ typed enum / literal
→ 具体 schema model
→ 具体内部模型或行为
```

不要把 discriminator 长期保留为任意字符串，并在多个函数中重复：

```python
if mode == "local":
    ...
elif mode == "remote":
    ...
```

如果不同模式只存在非常轻量、局部的构造差异，一个明确的 typed dispatch 分支是可以接受的，不要为了“用了设计模式”强行增加 class 层次。

如果每个模式开始拥有独立且非平凡、会继续增长的解析、校验、构造或执行行为，则应优先考虑 strategy / polymorphism / 独立职责对象，让新增模式主要通过新增实现完成，而不是持续扩大中央 `if/elif`。

判断标准：

> 是否已经出现“新增一种 mode，需要同时修改多处字符串判断、字段清单、校验函数和构造分支”的趋势？如果是，应收敛到 typed model + 独立模式实现。

# 九、抽象必须降低调用方复杂度

允许使用 Python 的动态能力，包括：

- decorator；
- `ContextVar`；
- descriptor；
- `__init_subclass__`；
- singledispatch；
- `Protocol`；
- generic；
- factory；
- registry。

但使用这些机制必须有明确收益。

判断标准：

> 抽象是否显著降低调用方复杂度，并让调用接口更加统一、清晰和可替换？

如果只是把三行容易理解的显式代码改成一个难以追踪的隐式机制，则保留显式实现。

不要因为 Python 能做到，就自动把行为变成 magic。

动态能力可以隐藏重复机制，但不能隐藏重要业务状态变化。

## 运行期扩展不是默认设计目标

“未来会增加新的类型、事件或处理逻辑”默认表示代码未来会继续修改，不代表当前必须提供运行期注册、插件系统、动态 factory 或通用 registry。

除非需求明确要求运行期扩展，否则不要新增 `register_handler()`、插件注册表、配置驱动 handler、动态 factory 等公共扩展入口。

如果新增一种类型只需要：

- 新增一个模型；
- 新增一个处理函数；
- 扩展一个 union；
- 增加一个显式 dispatch 分支；

这通常是可以接受的源码级扩展。

只有需求明确要求以下能力时，才为运行期扩展机制付出额外复杂度：

- 第三方插件；
- 无需修改源码即可注册；
- 配置驱动加载；
- 运行期间动态增加实现。

不要为了假设中的未来扩展提前牺牲静态类型信息。

源码级扩展是默认策略：新增模型、扩展 union、增加显式 dispatch 分支，都属于正常维护成本，不需要为了“未来可能增加”预先设计插件架构。

# 十、合理默认值 + 显式覆盖入口

基础设施和复用层可以提供合理默认行为，让常见调用保持简单。

但重要行为应保留显式覆盖入口。

例如：

- 默认配置可以自动推导；
- 默认 backend 可以自动选择；
- 默认 session / context 可以自动取得；

但当调用者需要指定：

- client；
- session；
- strategy；
- backend；
- timeout；
- execution policy；

时，应提供明确方式，而不是迫使调用者绕过内部实现。

默认值用于减少重复，不用于剥夺控制权。

# 十一、Sync / Async 保持概念对称

同一能力同时存在同步和异步实现时，应尽量保持：

- 相近的命名；
- 相近的参数语义；
- 相近的生命周期；
- 相近的错误模型；
- 相近的返回模型。

不要仅因为进入 async，就让调用者重新学习另一套完全不同的业务抽象。

实现层可以不同，概念接口应尽量一致。

# 十二、静态分析不得为了形式制造噪声

Static First 是为了降低不确定性，不是为了把 Python 写成低配 C++。

不要为了满足类型形式而：

- 给明显的一次性局部数据创建庞大类型层次；
- 为简单 callback 建三层 `Protocol`；
- 大量使用无意义 `cast()` 压制类型检查器；
- 为了消除每一个 inference 而显式标注所有局部变量；
- 创建只被使用一次且没有语义价值的 wrapper class。

判断标准：

> 类型和模型是否让接口、重构、补全或错误发现更可靠？

如果答案是否定的，就不要仅为了“类型更多”而增加结构。

# 十三、优先复用熟悉的 common 实现

当当前任务需要实现通用能力，并且 `mental1104/common` 中已经存在相近、成熟、熟悉的实现时，应优先参考该仓库，而不是无依据地重新发明一套。

复用方式必须根据 common 在当前仓库中的存在形态处理：

## 1. common 仅安装在系统路径

如果 common 只是通过系统级安装、site-packages、全局路径或其他仓库外路径可见，而当前仓库本身并未把 common 作为源码依赖纳入版本管理：

- 可以读取 common 中已有实现，优先复用其成熟思路和老代码；
- 如果当前模块确实需要这段能力，应把必要实现复制并适配到当前模块包内；
- 复制后由当前仓库自行维护，不直接 import 系统路径中的 common；
- 不因为本机恰好安装了 common，就给当前项目制造隐藏的机器环境依赖。

核心原则：

> 系统安装的 common 可以作为参考源码，但不能自动成为当前仓库的运行时依赖。

## 2. common 作为当前仓库的 submodule

如果当前仓库已经通过 Git submodule 正式包含 common：

- 先检查当前仓库现有的依赖关系、导入方式、构建配置和版本固定方式；
- 如果项目本来就直接引用该 submodule，可以沿用现有方式直接复用 common 中的实现；
- 不要把本可直接引用的 submodule 代码再次复制一份到当前模块；
- 仍需遵守当前仓库对模块边界和依赖方向的既有约束。

## 3. common 不存在于当前环境

如果既没有可读取的系统安装版本，也没有作为当前仓库 submodule 存在：

- 忽略 common 的存在；
- 不为了查找或接入 common 阻塞当前编码任务；
- 按本 Skill 和当前仓库自身约束正常完成实现；
- 不凭记忆伪造 common 中可能存在的 API 或实现。

## 4. 复用边界

即使发现 common 中存在相近实现，也不要机械整段搬运。

复用前应确认：

- 语义是否与当前需求一致；
- 是否依赖当前仓库不存在的环境或框架；
- 是否会带入无关兼容逻辑、历史包袱或过度抽象；
- 当前仓库是否已经存在更直接、更局部的实现。

优先复用“已有、熟悉、已验证”的实现，但最终代码仍需符合当前仓库和本 Skill 的约束。

# 十四、common Python 来源探测与优先级

当实现 Python 通用能力、准备参考 `mental1104/common` 中已有实现时，不要凭目录名、当前工作区偶然可见路径或历史记忆判断 common 是否可用。

必须按以下优先级探测：

> submodule > 当前解释器已安装的 mental1104 distribution > common 不可用

## 1. 优先检查 Git submodule

先检查当前仓库的 Git 元数据，而不是简单判断是否存在名为 `common` 的目录。

应读取：

- `.gitmodules`；
- `git submodule status --recursive`；

并确认某个 submodule 的远端或配置确实指向：

`mental1104/common`

找到后进一步确认其中存在 Python 源码结构，例如：

- `python/pyproject.toml`；
- `python/mental1104/`。

如果成立，则将 common 来源视为 submodule。

此时即使当前 Python 环境同时安装了 `mental1104` package，也优先使用 submodule，不再使用系统安装版本作为实现来源。

如果当前仓库已经通过 submodule 建立了正式引用关系，应遵循当前仓库已有 import、构建和依赖方式直接复用；不要再复制一份相同实现。

## 2. 没有 submodule 时检查当前项目解释器

只有不存在 common submodule 时，才检查 Python package 是否已经安装。

不要默认使用裸 `python3`。

应优先确定当前项目真实使用的 Python interpreter，例如：

1. 仓库明确配置的解释器；
2. 当前激活 virtualenv 的 Python；
3. `.venv/bin/python` 等项目本地解释器；
4. 最后才退回系统 `python3` / `python`。

使用该解释器通过 package metadata 检查：

`importlib.metadata.distribution("mental1104")`

只有成功找到 distribution 时，才视为 common Python 已安装。

不要只通过：

`import mental1104`

判断安装状态，因为当前工作区、`PYTHONPATH` 或其他临时路径可能遮蔽真正的 site-packages 来源。

探测时应同时确认：

- distribution 名为 `mental1104`；
- 当前 interpreter；
- distribution location；
- `mental1104` module 实际解析位置。

推荐思路：

```python
from importlib import metadata
import importlib.util

dist = metadata.distribution("mental1104")
spec = importlib.util.find_spec("mental1104")
```

这样可以区分“真正安装到当前解释器环境”与“只是当前目录碰巧能 import”。

## 3. 系统安装版本只能作为参考实现

如果 common 仅通过当前解释器的 site-packages 可见，而当前仓库没有把 common 作为 submodule 或正式源码依赖：

- 可以读取已安装 `mental1104` package 中已有、熟悉、成熟的实现；
- 需要复用时，把必要代码复制并适配到当前模块包中；
- 不要直接 import 系统安装的 `mental1104` 来形成隐藏运行时依赖；
- 不要因为开发机上恰好安装了 common，就改变当前仓库原本的依赖契约。

## 4. 两者都不存在时忽略 common

如果：

- 当前仓库没有指向 `mental1104/common` 的 submodule；
- 当前项目实际使用的 Python interpreter 也没有安装 `mental1104` distribution；

则忽略 common 的存在，按照本 Skill 和当前仓库自身约束正常实现。

不要：

- 为了寻找 common 阻塞任务；
- 从网络临时安装 common；
- 凭记忆假设 common 中存在某个 API；
- 因 common 不存在而降低当前实现质量。

## 5. 探测结果必须影响复用方式

最终只允许得到三种明确状态：

```text
COMMON_SOURCE = submodule
COMMON_SOURCE = installed-package
COMMON_SOURCE = absent
```

对应行为：

- `submodule`：按当前仓库既有引用关系直接复用；
- `installed-package`：只作为参考源码，必要时复制到当前模块；
- `absent`：忽略 common，正常实现。

核心原则：

> common 的来源探测必须可重复、可解释，并且优先尊重当前仓库已经声明的源码依赖关系。

# 十五、pytest 测试按被测职责聚合

pytest 测试文件也应表达清晰的职责归属。

当多个测试共同验证同一个被测对象、public API、class、组件或行为域时，默认使用命名明确的 test class 聚合，例如：

```python
class TestParseTaskConfig:
    def test_move_uses_default_speed(self) -> None:
        ...

    def test_rejects_unknown_fields(self) -> None:
        ...
```

不要默认把大量：

```python
def test_xxx():
    ...

def test_yyy():
    ...

def test_zzz():
    ...
```

直接平铺在模块级，迫使读者仅靠函数名前缀自行判断它们属于哪个测试职责。

测试类的目标只是提供结构归属和阅读导航，不代表必须引入面向对象测试设计。

因此：

- 不要为了使用 test class 制造共享可变状态；
- 不要无依据引入 `setup_method` / fixture 成员状态；
- 不要创建测试类继承体系；
- 不要把所有测试塞进一个巨大的 `TestEverything`；
- 如果不同测试自然属于不同职责，应拆成多个 `TestXxx`；
- 如果文件中只有一两个彼此独立的测试，保留模块级函数是可以接受的。

判断标准：

> 测试文件结构应直接表达“这组 case 在验证谁 / 哪一类行为”，而不是让相关测试函数长期散落在模块级。

# 十六、文件内代码布局按逆向调用拓扑组织

单个 Python 模块默认采用“逆向调用拓扑”：**被调用者在上，调用者在下**。文件越往下，越接近对外入口和最高层 orchestration。

默认顺序如下：

1. import；
2. 枚举、常量、类型别名和稳定协议定义；
3. 数据模型、异常模型等基础类型；
4. 最底层私有实现；
5. 调用这些低层能力的更高层私有职责类 / orchestration；
6. public facade / public function / public class entry；
7. `__all__` 等导出声明。

例如：

```text
imports
↓
Enum / constants / base models
↓
low-level private helpers
↓
private parser / validator / strategy classes
↓
higher-level orchestration
↓
public facade / public entry
↓
__all__
```

判断函数或类应放在哪里时，优先看调用关系，而不是“它是不是 public”或“它和哪个模型看起来更近”：

- 如果 A 调用 B，默认 B 应位于 A 上方；
- 如果一个 public entry 调用了多个私有实现，它应位于这些实现之后；
- 如果一个 public class 是整个模块的 facade，它应靠近文件底部；
- 如果两个定义之间没有调用依赖，再按职责和阅读连续性排列。

不要采用：

```text
public entry
↓
private helper
↓
private helper
↓
private helper
```

这种“先展示入口、后补实现”的布局。用户阅读本项目 Python 模块时，应能从上往下先理解基础定义和实现能力，最后在文件末端看到统一入口。

如果语言或框架对注册顺序、装饰器执行、声明位置有明确要求，优先满足真实运行约束；否则默认遵守逆向调用拓扑。

# 十七、编码前流程

处理 Python 编码任务时：

1. 阅读目标仓库的 `AGENTS.md`、`CONTRIBUTING.md`、README 和 Python 工具配置；
2. 确认 formatter、linter 和 type checker；
3. 应用本 Skill；
4. 同时读取并应用 `code-comment-writing`，确保中文优先的 docstring、参数/返回值和关键路径注释要求生效；
5. 确定外部动态数据的系统边界；
6. 确定内部数据模型；
7. 确定哪些函数纯消费数据，哪些操作真正改变状态；
8. 如果需要实现通用能力，按“submodule > 当前解释器已安装 package > absent”探测 `mental1104/common`，并记录实际来源；
9. 根据来源决定直接引用、复制参考实现或忽略 common；
10. 再开始实现。

遇到已有代码大量使用 dict、Any 或隐式 mutation 时，不要自动扩大重构范围。

只在当前修改范围内改善接口，并避免新增同类问题。

# 十八、交付前检查

完成 Python 代码前检查：

- [ ] 新增或修改的正常函数是否有完整类型注解；
- [ ] 是否存在本可避免的 `Any`；
- [ ] IDE / type checker 是否能够理解主要字段和返回类型；
- [ ] 外部 JSON / dict 是否在边界完成字段存在性和类型校验；
- [ ] 固定 schema 是否已经转换为明确模型；
- [ ] 外部稳定 schema 是否优先由模型字段声明表达必填、缺省、默认值和基础约束；
- [ ] 稳定有限的 mode / status / kind 是否仍以魔法字符串散落在分支和校验逻辑中；
- [ ] discriminator 是否已经收敛到 typed enum / literal 和具体 schema model；
- [ ] 多模式行为已经明显独立并持续增长时，是否仍把所有逻辑堆在中央 if/elif；
- [ ] 是否已经有明确模型，却又额外维护了一份字段名 tuple / set / list 或 `check_schema()`；
- [ ] 项目已有 Pydantic 且适合边界建模时，是否仍无理由手写了一套 schema engine；
- [ ] 是否为了使用 Pydantic 反而给原本要求标准库或无第三方依赖的任务新增了不必要依赖；
- [ ] 是否有裸 dict / JSON 继续穿过内部业务函数；
- [ ] 是否只建模了公共字段，却仍把原始 mapping 传入内部 handler；
- [ ] 具体事件 handler 是否只接收完整、已校验的 typed model；
- [ ] 内部函数是否使用 dict 作为固定 schema 的参数或返回值；
- [ ] 是否存在多个参数中某一个被偷偷修改的情况；
- [ ] 重要状态变化是否能直接从调用点看到；
- [ ] 是否把状态修改和后续只读处理拆开；
- [ ] 只读函数是否无理由要求可变容器；
- [ ] 是否存在可以用明确类型替代的 stringly-typed / dictly-typed 协议；
- [ ] 是否为了 registry / factory / callback 统一接口，把已知具体类型擦成了 `object` 或 `Any`；
- [ ] 是否存在先擦除类型、随后又通过 `isinstance()` 恢复类型的逻辑；
- [ ] 是否仅因为“未来可能扩展”就提前引入运行期注册机制；
- [ ] 在没有明确插件需求时是否仍暴露了 `register_handler()`、动态 registry 或类似扩展入口；
- [ ] 已知有限结果集合的公共 API 是否仍错误返回 `object` / `Any`；
- [ ] 内部可信函数是否重复执行本可由 type checker 保证的类型检查；
- [ ] 同一个概念是否被创建了多个近义类型别名、函数别名或同义 API；
- [ ] 是否擅自新增了字段 alias、旧格式兼容、fallback 或迁移逻辑；
- [ ] 是否因为内部 helper 已经存在，就顺手扩大了 public API 或正式支持的输入类型；
- [ ] 如果实现了通用能力，是否先检查了 `mental1104/common` 的可用形态；
- [ ] common 探测是否优先检查真正指向 `mental1104/common` 的 Git submodule，而不是仅检查目录名；
- [ ] submodule 与系统安装同时存在时，是否错误地选择了系统安装版本；
- [ ] 检查系统安装时是否使用了当前项目真实 interpreter，而不是无脑调用裸 `python3`；
- [ ] 是否通过 `importlib.metadata.distribution("mental1104")` 等 metadata 方式确认真实安装，而不是只凭 `import mental1104`；
- [ ] system package 模式下是否只参考/复制实现，而没有制造对开发机 site-packages 的隐藏依赖；
- [ ] common 仅系统安装时，是否错误地直接 import 并制造了隐藏环境依赖；
- [ ] common 作为 submodule 时，是否重复复制了本可直接引用的实现；
- [ ] 是否存在成组 `_decode_*` / `_read_*` / `_validate_*` / `_required_*` 等职责相关私有函数仍平铺在模块级，而没有归入职责明确的私有类；
- [ ] pytest 中多个测试是否围绕同一个 public API / class / 行为域却仍全部平铺为模块级 `test_*`，而没有用清晰的 `TestXxx` class 组织；
- [ ] test class 是否仅承担组织职责，没有因此引入无意义共享状态、继承或 setup 复杂度；
- [ ] 私有函数归类后是否又形成了吸收多个独立职责的万能私有类；
- [ ] 私有类的职责是否可以用一个清晰概念描述，而不是仅因为“这些都是内部实现”就放在一起；
- [ ] 错误模型是否因为“每个错误都要可区分”而机械膨胀成大量异常子类；
- [ ] 单一异常 + typed error code 是否已经足够，却仍额外创建了异常层次；
- [ ] 文件布局是否遵循逆向调用拓扑：被调用者在上、调用者在下；
- [ ] public facade / public entry 是否位于其依赖的私有实现之后，并靠近文件底部；
- [ ] 是否出现 public entry 先定义、后面才铺开它依赖的一串 helper 的正向调用布局；
- [ ] 边界校验是否存在用户、协议或仓库规则未要求的额外业务限制；
- [ ] 是否把“更严格”误当成“更正确”，擅自缩小了合法输入范围；
- [ ] 是否已经同时应用 `code-comment-writing`；
- [ ] 新增或修改的 Python docstring 与关键路径注释是否按 companion Skill 以中文为主；
- [ ] 动态抽象是否真的降低了调用方复杂度；
- [ ] 是否为了满足类型检查制造了不必要的抽象；
- [ ] 已运行项目已有的 formatter、linter、type checker 和相关测试。

任何一项明显违反且没有项目约束或任务需求作为理由时，都应在交付前修正。

# 核心判断

当设计存在多个可行方案时，优先选择满足以下目标的方案：

> 把动态性限制在边界，把确定性带进内部。

内部代码应尽可能：

- typed；
- validated；
- IDE discoverable；
- mutation visible；
- read-only by default；
- explicit about state transitions。

调用者只看函数名、类型、签名和调用顺序，就应能够理解主要数据流和状态变化，而不需要反复进入函数实现寻找隐藏契约。
