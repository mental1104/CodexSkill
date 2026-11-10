# 请求诊断与探测降噪案例

适用于 C++ / Python 服务中已授权的请求日志优化。以下是脱敏的日志与职责示意，不是已运行实现；字段名、等级及长度阈值沿用目标仓库。

## 案例一：从失败记录还原请求现场

用户提供一次导出请求失败的记录，希望看见必要请求输入和排障信息。原记录有路由、404 和 `source_not_found`，底层只说目录不可用，读者无法判断请求选择了哪个存储空间、解析到了哪个目录，以及失败是不存在还是权限问题。

```text
原记录：
DEBUG event=request_received request_id=req-42 method=POST route=/api/exports
ERROR Directory unavailable
ERROR event=source_prepare_failed reason=source_not_found
DEBUG event=response_submitted request_id=req-42 status=404

改进后的失败摘要：
ERROR event=request_failed request_id=req-42 method=POST route=/api/exports status=404 request_body={"space":"reports","file":"weekly.txt","token":"[REDACTED]"} response_body={"code":"SOURCE_UNAVAILABLE"}
ERROR event=source_prepare_failed request_id=req-42 space=reports file=weekly.txt resolved_directory=/data/reports operation=read reason=permission_denied system_error=EACCES
```

两层记录通过同一请求标识关联：公共入口负责请求与响应摘要，资源准备层负责它实际知道的解析结果与系统错误。不要求每一层重复整段正文；异步完成也要保留关联信息，避免并发请求串线。日志说明实际原因，不借补日志改变状态码或错误契约。

记录正文前复用现有脱敏与单行化能力，保留排障需要的非敏感字段。正文无法安全输出、解析失败或超出限制时，记录处理原因、原始长度和可安全取得的上下文。脱敏字段与正文上限按现有策略、数据形态和排障需要确定；失败等级按实际语义与仓库规范选择。

条件改变时：流式或二进制输入优先记录类型、长度、资源标识等摘要，不为日志无界缓存整段数据。原记录已足够还原现场时，复用而不重复埋点；只读分析则列明缺口，不修改服务。

## 案例二：正常探测静默，异常仍可定位

用户反馈健康轮询过于频繁。原实现每次探测在接收、处理、响应三层分别输出 DEBUG；即使没有业务活动，打开调试也会被成功轮询淹没。

| 场景 | 改进后的行为 | 取舍依据 |
|---|---|---|
| 正常 health / 心跳 | 不输出逐次成功记录 | 高频且没有新增业务信息；仅降级到 DEBUG 不能解决此时的噪声 |
| 探测被拒绝或返回失败 | 保留关联标识与失败原因 | 降噪不能隐藏需要处理的异常 |
| HTTP 200，但按既有契约业务探测失败 | 保留业务失败诊断 | 传输成功不等于能力正常；不为日志修改协议 |
| 普通导出或其他业务请求 | 保留已有业务生命周期与失败记录 | 探测静默不构成所有成功操作静默的依据 |

端点差异由已有路由元数据或组装处表达，通用 HTTP 后端执行必要策略；不要在后端硬编码某个产品的 health 路径。如果现有结构只需一个局部判断，不为套用策略模式新建框架或配置体系。

静默范围沿用实际路由行为：框架自动派生 HEAD 或 CORS 预检时，检查它们是否仍输出正常探测日志，同时保留失败分支。普通业务路由的预检策略不因 health 一并改变。

条件改变时：用户明确要排查探测本身、记录可用率，或仓库有审计与采样约定时，保留所需观测，不把默认静默当作绝对禁令。普通任务进度与关键状态变化按各自契约记录，不归入无业务动作的心跳。

## 验证边界

按本次范围同时核对失败诊断是否足够、正常探测是否确实静默，以及其他业务日志是否受影响。涉及公开 HTTP 行为时，用 `service-blackbox-validation` 组织独立请求与日志证据；普通补日志不自动启动 TDD 阶段审批，也不默认禁止修改测试。
