---
name: cpp-code-style
description: Mandatory personal C++ coding conventions. Use automatically whenever creating, modifying, refactoring, fixing, reviewing, or outputting executable C++ code, even when the user does not explicitly mention this skill. Prefer compile-time guarantees, const-correct and ownership-explicit interfaces, strongly typed domain models, RAII, value semantics, visible state changes, explicit error contracts, and APIs that make invalid states difficult to represent. Apply repository-specific mandatory constraints when they directly conflict, but do not copy legacy weakly typed or mutation-heavy patterns into new code merely because they already exist.
---

# C++ Code Style

## 定位

这是 C++ 编码任务的个人工程风格约束。

只要任务涉及以下任一行为，就应自动应用本 Skill：

- 新增 C++ 代码；
- 修改已有 C++ 代码；
- 修复 C++ 缺陷；
- 重构 C++ 实现；
- 设计 C++ API；
- 编写 C++ 测试；
- 输出准备直接进入项目的 C++ 代码。

本 Skill 主要约束：

- 类型如何表达业务语义；
- 参数、返回值和成员如何表达所有权；
- 状态变化如何从接口和调用点体现；
- 生命周期如何通过 RAII 管理；
- 哪些错误应尽可能提前到编译期；
- 哪些错误属于运行期协议；
- 如何避免无必要的动态性、隐式契约和抽象复杂度。

格式化、缩进、大括号风格、include 排序和命名细节等机械规范，优先交给仓库已有 formatter、clang-tidy 和项目约定。

`code-comment-writing` 负责 C++ 注释和文档要求，本 Skill 不重复定义注释格式。

# 一、规则优先级

发生冲突时按以下顺序处理：

1. 用户当前任务中的明确要求；
2. 仓库的 `AGENTS.md`、`CONTRIBUTING.md`、公共 API、ABI、协议兼容和其他强制规范；
3. 本 Skill；
4. 项目已有但未明确规定的历史代码风格。

已有代码使用裸指针、输出参数、字符串状态、动态 JSON 或隐式副作用，不代表新增代码必须继续复制。

不要为了改善风格无限扩大重构范围，但当前新增和修改的代码不应主动制造新的同类问题。

# 二、Static First

## 1. 能编译期表达的约束不要留到运行期

稳定的业务约束应优先通过以下方式表达：

- 明确类型；
- `enum class`；
- `struct` / class；
- 模板约束；
- `std::variant`；
- `std::optional`；
- 强类型 value object；
- `const`；
- 标准库已有语义类型。

避免长期依赖：

```cpp
std::string type;
int timeout;
int mode;
std::map<std::string, std::any> data;
```

再在运行期通过字符串和值约定解释其真实含义。

例如：

- 时间长度优先使用 `std::chrono`；
- 文件路径优先使用 `std::filesystem::path`；
- 有限状态优先使用 `enum class`；
- 明确不存在语义优先使用 `std::optional<T>`。

核心原则：

> 稳定约束尽量放进类型和接口；运行期只处理真正依赖外部数据、运行环境和动态选择的事情。

## 2. 不要擦除已经获得的静态类型信息

如果调用链已经知道具体类型，不要为了统一 registry、callback、factory 或“以后扩展”，主动把类型退化为：

```cpp
void*
std::any
Base*
```

再在下游通过 `dynamic_cast`、`std::any_cast` 或其他运行期检查恢复本来已经知道的信息。

运行期类型擦除只应存在于真实需要异构运行期分派的基础设施边界。

核心原则：

> 一旦获得可靠的静态类型关系，就不要在中间层主动把它弄丢。

# 三、动态数据止于边界

外部输入可以是：

- JSON；
- YAML；
- MQTT payload；
- ROS / DDS 消息；
- 数据库记录；
- 配置文件；
- 第三方协议对象。

进入核心逻辑前，应尽早完成：

```text
parse
→ validate
→ convert
→ typed domain model
→ core logic
```

避免核心逻辑长期操作：

```cpp
json["event_type"]
json["robot_id"]
json["size"]
```

或使用：

```cpp
std::map<std::string, std::string>
std::unordered_map<std::string, std::any>
```

表达固定 schema。

稳定数据应优先建模为明确的 `struct` 或 class。

# 四、让非法状态难以表示

不要设计一个对象允许大量实际上不合法的字段组合，再依赖调用者记住组合规则。

避免：

```cpp
struct Event {
    EventType type;
    std::optional<std::string> path;
    std::optional<int> percent;
    std::optional<bool> charging;
    std::optional<std::string> checksum;
};
```

如果不同状态天然互斥，应考虑：

```cpp
using Event = std::variant<FileUploadedEvent, BatteryChangedEvent>;
```

同样地：

- “不存在”是合法状态时使用 `std::optional<T>`；
- 多种明确结果类型互斥时考虑 `std::variant`；
- 不要通过 magic value 表达不存在或特殊状态。

目标不是让所有非法输入在编译期消失，而是让内部模型尽量无法轻易进入业务上不成立的状态。

# 五、参数默认只读

## 1. 输入参数默认不应被修改

普通输入对象默认使用适合其语义的只读接口。

对于非平凡对象，通常考虑：

```cpp
const T&
```

对于轻量、天然值语义或本来就需要取得副本的对象，可以按值传递。

不要机械地把所有参数都改成 `const T&`。

## 2. `T&` 应明确意味着 mutation

非 const 引用意味着调用者提供的对象可能发生变化，因此不应随意出现。

如果函数签名：

```cpp
void Process(Config& config, User& user, Context& context);
```

调用者很难判断三个对象到底谁会被修改。

应优先：

- 减少 mutable reference；
- 将修改动作拆成明确步骤；
- 使用成员函数让 receiver 表达修改主体；
- 或通过返回值生成新状态。

例如：

```cpp
user.Normalize();
Process(config, user);
```

或者：

```cpp
auto normalized_user = Normalize(user);
Process(config, normalized_user);
```

重要状态变化应能从调用点看到。

# 六、避免输出参数

不要默认设计：

```cpp
bool Parse(
    const Input& input,
    Result& result,
    Error& error);
```

调用者必须同时理解：

- 返回的 `bool`；
- `result` 什么时候有效；
- `error` 什么时候有效；
- 哪些引用会被修改。

优先让函数直接返回操作结果。

如果项目和 C++ 标准版本允许，可使用：

```cpp
std::expected<Result, Error>
```

否则优先使用项目已有的 `Result<T>`、`StatusOr<T>` 或等价结果类型。

输出参数仅在以下情况合理：

- 既有 API / ABI 兼容；
- C API 边界；
- 已验证的性能敏感路径；
- 第三方库接口要求；
- 返回多个对象确实存在明确工程收益。

# 七、所有权必须从接口可见

接口应尽量让调用者看出：

- 谁拥有对象；
- 谁只是借用；
- 谁可以修改；
- 是否允许为空；
- 生命周期由谁保证。

一般语义：

```cpp
const T&           // 非 owning，只读借用
T&                 // 非 owning，可修改借用
T                  // 值语义或 ownership transfer
T*                 // 通常表示 nullable observer 或外部对象
std::unique_ptr<T> // 独占 ownership
std::shared_ptr<T> // 真正共享 ownership
```

具体语义仍应遵循项目约定。

## 不要把 shared_ptr 当默认参数类型

`std::shared_ptr<T>` 表达共享所有权，不是“更安全的指针”。

如果函数只是临时使用对象，不应为了方便接收 `shared_ptr`。

只有函数确实参与对象生命周期管理时，才让接口接受或保存 shared ownership。

## unique_ptr 表示 ownership transfer

接受 `std::unique_ptr<T>` 应真实意味着函数取得所有权，而不是单纯为了避免复制。

# 八、Value Semantics 优先

对于普通：

- 配置；
- 事件；
- DTO；
- 结果；
- 小型领域对象；

优先考虑值语义。

值对象通常更容易理解、测试、移动、返回，并更容易推导生命周期。

不要因为 C++ 支持继承和指针，就默认建立复杂对象图。

运行期多态只应在真实存在多实现替换、插件、runtime-selected backend 或开放扩展时使用。

# 九、RAII 管理生命周期

凡是具有获取与释放语义的资源，应优先绑定到对象生命周期。

包括：

- mutex；
- file；
- socket；
- transaction；
- memory；
- thread；
- temporary resource；
- handle；
- subscription；
- callback registration。

避免：

```cpp
Lock();
DoSomething();
Unlock();
```

优先使用作用域对象管理生命周期。

尤其不要依赖“每个成功路径、错误路径和以后新增的 return 都记得 cleanup”这种人肉协议。

# 十、const correctness 是默认设计工具

不修改对象的成员函数应优先标记 `const`。

只读取对象的接口不应获得无必要的 mutable access。

`const` 用于：

- 让调用者理解副作用；
- 让编译器阻止意外修改；
- 让接口表达真实依赖；
- 降低读代码时需要考虑的状态空间。

如果必须不断通过 `const_cast` 或 `mutable` 绕过设计，应优先重新检查对象职责和 ownership。

# 十一、使用最小必要能力

函数参数应只要求真正需要的能力。

例如：

- 只读取连续数据可考虑 `std::span<const T>`；
- 只读取字符串且生命周期明确时可考虑 `std::string_view`。

不要仅为了读取数据就要求具体 mutable container。

但 view 类型是 non-owning 的。

使用 `std::string_view`、`std::span`、reference 或 pointer 时，必须确保生命周期安全，不要用“少复制”换悬空引用。

# 十二、减少 stringly-typed API

避免：

```cpp
StartTask("fast");
SetMode("safe");
if (event.type == "file_uploaded") {
    ...
}
```

当值集合稳定时优先使用 `enum class` 或明确类型。

如果两个值底层都是整数或字符串，但业务上不可互换，并且混淆风险真实存在，可以考虑专用类型，例如：

```text
RobotId
TaskId
Sequence
```

但不要反过来给每一个整数都创建 wrapper。

强类型应解决真实问题，而不是把类型系统变成俄罗斯套娃。

# 十三、避免布尔参数 API

调用：

```cpp
Process(file, true, false, true);
```

几乎无法从调用点理解。

如果布尔值表达业务模式，应优先考虑：

- `enum class`；
- 明确的 options object；
- 或拆分职责。

单个语义非常明确的 bool 并非禁止，但调用点必须容易理解。

# 十四、错误是接口契约的一部分

对可预期失败，例如：

- 输入非法；
- 文件不存在；
- 网络请求失败；
- 状态不允许；
- 资源冲突；

优先使用项目统一且明确的错误模型。

不要在同一层 API 混杂：

```text
false
nullptr
exception
errno
只写日志然后继续
```

如果返回结果必须由调用者检查，可根据项目和编译器支持考虑 `[[nodiscard]]`。

异常是否使用遵循项目已有异常策略。本 Skill 不强制“必须异常”或“禁止异常”。

# 十五、一个概念只有一个 canonical name

不要为了“更顺口”、猜测未来兼容或提供无必要便利，给同一概念创建多个近义 alias。

避免：

```cpp
using FileProcessResult = FileProcessingResult;
```

当两者语义完全相同且没有真实兼容需求。

同样避免同时提供两个执行完全相同职责的近义函数名。

类型别名应主要用于：

- 表达新的领域语义；
- 降低真实模板噪声；
- 必要兼容迁移；
- 对齐协议或公共 API。

核心原则：

> 一个概念只保留一个正名，不主动扩大调用者需要记忆的词汇表。

# 十六、运行期扩展不是默认目标

“未来可能增加新的事件、类型或处理器”不等于现在就必须建立：

- dynamic registry；
- factory framework；
- plugin architecture；
- runtime type erasure；
- inheritance hierarchy。

如果新增一种类型只需要：

```text
新增一个 struct
新增一个处理函数
扩展一个 variant
增加一个显式 dispatch 分支
```

这是合理的源码级扩展。

只有明确要求第三方插件、无需重新编译即可注册、配置驱动模块、运行时动态装载或 runtime implementation selection 时，才为动态扩展支付复杂度成本。

# 十七、抽象必须降低调用方复杂度

允许使用：

- template；
- concepts；
- traits；
- CRTP；
- type erasure；
- inheritance；
- factory；
- registry；
- callback；
- policy class。

但这些机制不是默认奖励项。

判断标准：

> 抽象是否显著降低调用方复杂度、消除真实重复，或表达简单代码无法清楚表达的约束？

如果三行显式代码比多层模板、trait、factory 和 registry 更容易理解，就保留三行代码。

# 十八、局部不可变优先

局部变量构造完成后，如果后续无需改变，应尽量避免重复赋值和状态复用。

相比：

```cpp
Result result;
result = Parse();
result = Transform(result);
```

如果逻辑允许，更倾向：

```cpp
const auto parsed = Parse();
const auto transformed = Transform(parsed);
```

不要机械要求所有局部变量必须 `const`。

目标是让一个名字尽量长期代表一个稳定含义。

# 十九、避免万能 Context / Options / Request

不要为了减少参数数量，把大量无关依赖塞进：

```cpp
Context
Request
Options
Environment
Runtime
```

再让所有函数接收整个对象。

这种对象很容易变成 C++ 版本的 `dict[str, Any]`。

如果函数只依赖其中两个能力，应优先直接表达这两个依赖。

大型 context object 只有在它确实代表稳定领域概念或统一生命周期边界时才合理。

# 二十、性能优化必须有依据

不要以“C++ 性能”为理由提前进行：

- 手写内存池；
- 自定义 allocator；
- intrusive structure；
- unsafe lifetime trick；
- 无必要 move；
- 缓存复杂对象；
- 晦涩零拷贝；
- 手动资源生命周期。

优先写出正确、ownership 清晰、生命周期明确、可测试、可分析的实现。

只有存在 benchmark、profiling、明确数据规模或已知热点时，再承担额外复杂度。

性能敏感设计必须能够说明具体优化目标和为何值得。

# 二十一、编码前流程

处理 C++ 编码任务时：

1. 阅读仓库的 `AGENTS.md`、`CONTRIBUTING.md`、README 和现有 C++ 风格；
2. 确认 C++ 标准版本；
3. 确认 formatter、clang-tidy、编译告警和静态分析配置；
4. 应用本 Skill；
5. 同时应用 `code-comment-writing`；
6. 确定输入边界和内部 domain model；
7. 确定 ownership 与 lifetime；
8. 确定哪些参数只读、哪些操作真正修改状态；
9. 确定错误返回模型；
10. 再开始实现。

不要因为本 Skill 推荐 `std::expected`、`std::span` 或其他标准库能力，就在项目标准版本不支持时强行引入。

优先使用当前项目已有且语义等价的方案。

# 二十二、交付前检查

完成 C++ 代码前检查：

- [ ] 能否将更多稳定约束放到编译期；
- [ ] 固定业务 schema 是否有明确类型；
- [ ] 是否存在可以避免的 stringly-typed 状态；
- [ ] 是否主动擦除了已有的静态类型关系；
- [ ] 对象是否能够轻易进入业务非法状态；
- [ ] 只读参数是否错误地使用 mutable reference；
- [ ] `T&` 是否真的意味着明确 mutation；
- [ ] 重要状态变化是否从调用点可见；
- [ ] 是否存在可以避免的 output parameter；
- [ ] ownership 是否能从接口理解；
- [ ] 是否滥用了 `shared_ptr`；
- [ ] non-owning pointer / reference / view 的生命周期是否安全；
- [ ] 资源是否优先使用 RAII；
- [ ] 不修改对象的成员函数是否保持 const correctness；
- [ ] 是否要求了比实际需要更强的容器或参数能力；
- [ ] 是否存在难以阅读的 bool 参数组合；
- [ ] 错误模型是否清晰且与相邻 API 一致；
- [ ] 关键返回值是否应使用 `[[nodiscard]]`；
- [ ] 是否仅因为“未来可能扩展”就提前引入运行期注册或继承体系；
- [ ] 同一个概念是否创建了多个近义 alias 或同义 API；
- [ ] 抽象是否真的降低调用方复杂度；
- [ ] 是否为了假设中的性能提前牺牲可读性或生命周期安全；
- [ ] 已运行项目已有 formatter、clang-tidy、编译、静态分析和相关测试。

任何一项明显违反且没有项目约束或任务需求作为理由时，都应在交付前修正。

# 核心判断

当设计存在多个可行方案时，优先选择满足以下目标的方案：

> 让类型表达语义，让签名表达所有权和副作用，让作用域管理生命周期，让非法状态尽可能在编译期无处藏身。

内部代码应尽可能：

- strongly typed；
- const-correct；
- ownership explicit；
- lifetime safe；
- mutation visible；
- value-oriented；
- explicit about errors and state transitions。

调用者只看函数名、类型、签名和调用顺序，就应能够理解主要数据流、所有权和状态变化，而不需要反复进入实现寻找隐藏契约。
