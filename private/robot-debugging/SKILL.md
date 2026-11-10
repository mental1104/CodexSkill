---
name: robot-debugging
description: Locate problems during company robot testing and debugging by connecting over SSH to a user-provided intranet IP. Use for 机器人调试、问题定位、测试上机 and inspecting the robot host configuration under /opt/xr/config. Do not use for unrelated SSH hosts or home-LAN device maintenance.
---

# 机器人调试问题定位

## SSH 上机约定

- 目标为用户当次提供的内网 IP；缺少 IP 时再询问，不猜测地址或扫描网段。
- SSH 用户固定为 `xr`，密码固定为 `123`。按 `ssh xr@<内网IP>` 建联，在密码提示时输入固定密码；无需重复询问已约定的账号和密码。
- 使用当前执行环境的终端连接；连接失败时，根据实际错误说明是网络不可达、认证失败或其他问题，不将失败描述为已上机。
- 密码仅用于认证，不写入命令行参数、调试日志或结果报告。

## 问题定位

围绕用户当次提供的现象和测试目标选择检查项。目标已明确时直接开展已授权的排查；未给出现象时，先完成建联，再询问需要定位的问题，不预设具体故障流程。

宿主机可能区分主机和从机，角色线索位于宿主机的 `/opt/xr/config`。需要了解角色时，只读查看该目录中与当前问题相关的实际配置，保留文件名、字段和值作为判断依据。主从机的具体判定方法尚未约定，后续由用户补充；证据不足时标注“角色未确定”，不猜测文件名、字段含义或主从映射，也不把容器中的同名目录当作宿主机配置。

单纯定位问题时先读取相关配置、状态和日志；测试动作、配置修改、服务重启等按当次授权范围执行。汇报已观察到的事实、据此形成的判断和仍待验证的部分；后续遇到具体需求时，再将有依据的通用做法补入本 Skill。

## 使用示例

用户提供内网 IP 并说“这台机器人连不上服务，帮我上机定位”：使用固定账号 SSH 连接给定 IP，围绕该连接故障收集证据。若排查需要区分主从机，查看宿主机 `/opt/xr/config` 中的相关配置；尚不清楚字段语义时保留角色未知，继续不依赖角色的检查。

用户仅要求编写或维护本 Skill 时，只处理 Skill 文件；用户要求维护家庭 NAS 时，使用对应的设备维护流程。
