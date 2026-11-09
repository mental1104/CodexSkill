# 对外消息与字段策略案例

## 案例一：先转换输出模型，再统一序列化

输入消息用原始整数和质量位图表达采样；输出协议要求可空数值与具名 `quality` 对象。第一版只有输入结构体，把它序列化后执行 `erase(quality_flags)`、补 `quality` 和逐字段置空。输出契约只存在于 JSON 修改代码里，阅读头文件看不到实际报文类型。

```text
原路径：SourceSample → JSON → 删除源字段 / 解析质量位 / 修改数值 → 发布

改进后：SourceSample → 明确的有效性与单位转换
         → ReportData → Record[] → SensorReport[] → ReportQuality
         → 项目已有 to_json 或等价入口 → 既有事件信封与发送链路
```

记录、数组元素与质量对象都有具体 C++ 类型。空值、空字符串、合法零值及字段缺失按协议分别表达；`optional` 的 JSON 映射随输出类型维护，不假定库自动提供正确的空值语义。外层信封已有类型时继续复用，不能为一个业务再建平行传输结构。

质量位按含义映射到受影响字段。例如时间不可信不必然表示测量无效；不根据某一个质量位就把整份对象抹空。业务判断在转换中完成，序列化只落实已有字段契约。变更同步到实际发送路径、协议样例和映射断言。

反向情形：输入和输出原本是同一份公开契约、无需转换时，可复用现有生成/SDK 类型；通用未知 JSON 转发也不强制建立全部字段模型。

## 案例二：同义字段的类型包装复用

两个模型的字段名称、单位和原始类型大多一致，只是一份保存 `T`，另一份保存 `optional<T>`。普通公共基类无法同时给同名成员提供这两种类型；用户希望减少字段声明重复时，可以用模板模板参数表达包装策略。

以下为 C++17 类型声明示意，省略业务转换和 JSON 序列化，不代表消息发送已经运行验证：

```cpp
#include <cstdint>
#include <optional>
#include <string>

/// 必填字段策略：保持原始类型，不增加运行时包装。
/// @tparam T 字段的原始值类型。
template <typename T>
using RequiredField = T;

/// 两个模型共同的字段声明；只复用同义字段，不执行协议转换。
/// @tparam Field 将原始类型映射为该模型实际字段类型的别名或类模板。
template <template <typename> class Field>
struct SensorFields {
    std::uint8_t channel{};              // 通道身份在两份契约中都必须存在。
    Field<std::int16_t> temperature{};   // 单位为 0.1 摄氏度，两份契约保持相同单位。
    Field<std::string> sensor_id{};      // 是否允许空字符串由具体协议定义。
};

/// 原始采样：持有原始值，质量判定独立保留。
struct SensorSample : SensorFields<RequiredField> {
    bool valid{};
    std::uint32_t quality_flags{};
};

/// 输出质量契约：分别表达时间与测量质量。
struct ReportQuality {
    bool time_invalid{};
    bool measurement_invalid{};
};

/// 对外报告：可空字段与具名质量状态组成独立的序列化契约。
struct SensorReport : SensorFields<std::optional> {
    ReportQuality quality{};
};
```

`temperature` 在采样中为整数，在报告中为 optional；`channel` 始终不可空。`{}` 分别让原始数值默认零、字符串为空、optional 无值；默认零不自动代表有效采样。

这是模板策略与模板基类的编译期复用，不是 CRTP，也不是运行时多态。两个派生模型仍需显式转换，不能将基类转换当成质量校验；本例不通过基类指针管理对象，不为字段复用引入虚函数。序列化映射仍须明确维护，模板不自动消除这部分契约。

反向情形：字段只有一两项，或两协议的名称、单位、结构会独立变化时，重复少量声明通常更清楚；不为消除任何字段重复都引入模板继承、宏反射或运行时注册。

## 回放检查

给一个“源位图 → 输出质量对象、原始值 → 可空值”的上报需求，检查头文件能否直接呈现输出契约、真实发送是否使用该类型、有效性转换是否仍清楚。再换成已有同构生成类型或两个含义分化的模型，确认不会强制复制 schema 或共享字段模板。类型声明、序列化正确性和实际消息送达须分别验证。
