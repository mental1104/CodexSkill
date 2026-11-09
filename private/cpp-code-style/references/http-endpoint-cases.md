# HTTP 端点案例

本例展示同步 JSON 任务准备端点。类型名和文件名只说明职责，不要求更换框架或复制一套 HTTP 基础设施。

## 原问题与改进后的接口

原业务方法接收完整 Request 和发送回调，自己读取 JSON 字段、设置通用响应头、编码并发送响应。其他端点反复实现同一流程，业务输入和协议细节交织。

```text
原方法：Handle(Request, Respond)
  → 逐字段读取 JSON → 调用业务服务 → 设置响应头 → 编码并发送

改进后：适配器解码与结构校验 → Handle(Input) → 适配器编码与发送
                                   ↓
                              既有业务服务
```

下面是可独立做语法检查的 C++17 接口示例。`ExportService::Prepare` 只声明既有业务能力；没有实现传输、JSON 编解码或可运行的 HTTP 服务。为集中说明输入输出，片段只展示成功结果；实际项目应保留已有错误类型、状态码和失败传播，不据此把拒绝或失败当成成功。

```cpp
#include <filesystem>
#include <string>
#include <utility>

namespace http_schema::exports {

/// HTTP 请求数据；由适配层解码并完成约定的结构校验，不持有请求上下文。
struct PrepareInput {
    std::string relative_path;
};

/// HTTP 受理响应；只保存任务标识，不表示后台工作已经完成。
struct PrepareOutput {
    std::string task_id;
};

} // namespace http_schema::exports

/// 业务受理结果；独立于 HTTP Schema，任务标识贯穿后续查询与取消。
struct AcceptedTask {
    std::string task_id;
};

/// 既有业务服务的示意声明；负责任务准入，HTTP 编解码由适配层承担。
class ExportService {
public:
    /// 受理指定源文件的准备任务；路径安全和业务授权沿用已有服务契约。
    /// @param source 相对源路径，按值交给服务；本例不增加路径接受范围限制。
    /// @return 独立的受理结果；取得任务标识不代表文件已交付。
    [[nodiscard]] AcceptedTask Prepare(std::filesystem::path source);
};

/// 同步 HTTP 业务端点；借用业务服务，不解析 JSON，也不主动提交响应。
class PrepareEndpoint final {
public:
    /// 注入既有业务服务，不取得其所有权。
    /// @param service 必须在端点及本次同步调用结束前保持有效的业务服务。
    explicit PrepareEndpoint(ExportService& service) noexcept : service_{service} {}

    /// 把已解码输入交给业务服务，再返回供适配器编码的响应数据。
    /// @param input 已完成约定结构校验的请求值；只读借用，不会保存该引用。
    /// @return 独立拥有任务标识的 HTTP 输出；发送职责仍属于外层适配器。
    [[nodiscard]] http_schema::exports::PrepareOutput Handle(
        const http_schema::exports::PrepareInput& input) const {
        // 沿用既有准入能力，避免端点自行创建第二套任务执行链。
        auto accepted = service_.Prepare(std::filesystem::path{input.relative_path});
        return {std::move(accepted.task_id)};
    }

private:
    ExportService& service_;
};
```

端点看到的是结构化输入与业务结果。Schema 的 `from_json` / `to_json` 或等价映射随数据定义维护；通用 JSON 适配器负责字段解码、通用响应头和单次响应提交。这里没有为了支持一个端点再设计动态类型注册表或统一的 `virtual Handle(JSON)`。

## Schema 归属与按需上下文

已有 Schema 层时，一种组织方式是把 `PrepareInput`、`PrepareOutput` 及字段映射放在 `http_adapter/schema/exports/prepare.hpp`，端点和注册文件引用它。示例中的 `AcceptedTask` 属于业务服务契约，不因为 HTTP 输出字段相同就归入 HTTP Schema。仓库已有清楚布局时沿用原结构，不为本例强制拆出这些文件。

无输入的 health 端点可以是 `Handle() → HealthOutput`，没有必要增加空的 `HealthInput`。需要读取 header 的端点则沿用明确的 Request 参数或既有端点基类的 `Header()`，普通输入结构体不继承 HTTP 上下文。

```text
请求 A → 请求 A 专用上下文 → 本次端点 → Handle(Input)
请求 B → 请求 B 专用上下文 → 本次端点 → Handle(Input)
                                   ↑
                         需要时才读取 Header / PathParameter
```

服务依赖可以共享，请求上下文不能由单例端点反复覆盖。同步期间取得的 header 引用或视图不能直接交给后台任务；异步工作需要的数据应按实际所有权契约复制或由明确的拥有者保活。

## 条件改变时

- 已有自由函数和显式参数能清楚表达依赖时，可以保持该形式，不为访问 header 强制建立端点继承体系。
- 文件下载、流式响应和异步回调继续使用其真实响应类型与生命周期，不强制返回普通 JSON Output。
- 通用 HTTP Server 和通用 JSON 库仍可以操作未知动态数据，具体业务 Schema 留在业务协议边界。
- 用户只授权验证一个 health 端点时，只验证该端点和适配机制，不同时实现任务队列或全部业务接口。

## 回放检查

改用另一个同步 JSON 接口，观察业务方法能否只接收需要的数据，并保留已有结果与错误语义。再改成流式下载或异步端点，检查是否仍保留资源持有与实际发送结束语义。接口片段的语法通过不等于实际编解码、并发隔离或 HTTP 生命周期已经运行验证。
