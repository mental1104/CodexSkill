---
name: python-code-style
description: Mandatory personal Python coding conventions. Use automatically whenever creating, modifying, refactoring, fixing, or outputting executable Python code, even when the user does not explicitly mention this skill. Prefer static-analysis-first design, explicit typing, validated boundary models instead of dict/JSON-shaped internal APIs, visible state changes, read-only-oriented parameters, and IDE-discoverable contracts. Apply repository-specific mandatory constraints when they directly conflict, but do not copy legacy dynamic patterns into new code merely because they already exist.
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

`code-comment-writing` 负责注释和文档要求，本 Skill 不重复定义注释规则。

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

## 4. 动态映射本身是领域语义时允许 Mapping

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

# 七、减少 stringly-typed 和 dictly-typed 设计

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

# 八、抽象必须降低调用方复杂度

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

# 九、合理默认值 + 显式覆盖入口

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

# 十、Sync / Async 保持概念对称

同一能力同时存在同步和异步实现时，应尽量保持：

- 相近的命名；
- 相近的参数语义；
- 相近的生命周期；
- 相近的错误模型；
- 相近的返回模型。

不要仅因为进入 async，就让调用者重新学习另一套完全不同的业务抽象。

实现层可以不同，概念接口应尽量一致。

# 十一、静态分析不得为了形式制造噪声

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

# 十二、编码前流程

处理 Python 编码任务时：

1. 阅读目标仓库的 `AGENTS.md`、`CONTRIBUTING.md`、README 和 Python 工具配置；
2. 确认 formatter、linter 和 type checker；
3. 应用本 Skill；
4. 同时应用 `code-comment-writing`；
5. 确定外部动态数据的系统边界；
6. 确定内部数据模型；
7. 确定哪些函数纯消费数据，哪些操作真正改变状态；
8. 再开始实现。

遇到已有代码大量使用 dict、Any 或隐式 mutation 时，不要自动扩大重构范围。

只在当前修改范围内改善接口，并避免新增同类问题。

# 十三、交付前检查

完成 Python 代码前检查：

- [ ] 新增或修改的正常函数是否有完整类型注解；
- [ ] 是否存在本可避免的 `Any`；
- [ ] IDE / type checker 是否能够理解主要字段和返回类型；
- [ ] 外部 JSON / dict 是否在边界完成字段存在性和类型校验；
- [ ] 固定 schema 是否已经转换为明确模型；
- [ ] 是否有裸 dict / JSON 继续穿过内部业务函数；
- [ ] 内部函数是否使用 dict 作为固定 schema 的参数或返回值；
- [ ] 是否存在多个参数中某一个被偷偷修改的情况；
- [ ] 重要状态变化是否能直接从调用点看到；
- [ ] 是否把状态修改和后续只读处理拆开；
- [ ] 只读函数是否无理由要求可变容器；
- [ ] 是否存在可以用明确类型替代的 stringly-typed / dictly-typed 协议；
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
