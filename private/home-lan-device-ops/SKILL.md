---
name: home-lan-device-ops
description: Diagnose and maintain the user's known home LAN router and NAS over SSH. Use automatically for requests about the router, OpenWrt, Xiaomi AX6000, OpenClash, the NAS, Synology/DSM, or the known LAN addresses; route to the correct SSH endpoint and handle NAS sudo password prompts safely. Do not use for unrelated remote hosts.
---

# Home LAN Device Operations

Route the request to the known device, connect using the established WSL2 SSH setup, inspect before changing anything, and verify the requested outcome. Device facts can change after upgrades; treat the connection details below as stable but re-detect software and runtime state.

## Device routing

### Router

Use for “路由器”, OpenWrt, AX6000, OpenClash, firewall, DNS, DHCP, Wi-Fi, routing, or `192.168.31.1` requests.

- Primary command: `ssh openwrt-ax600`
- Endpoint behind the alias: `root@192.168.31.1`
- Dedicated WSL2 identity: `~/.ssh/id_ed25519_openwrt_ax6000`
- The session is already root; do not use `sudo`.
- This is a Xiaomi AX6000 and was running OpenWrt 25.12.4/aarch64 when the skill was created. Re-check with `ubus call system board`, `uname -m`, and the available package manager rather than assuming the recorded version is still current.
- OpenWrt 25.12 uses `apk`; older releases may use `opkg`. Never run a blanket `apk upgrade` or `opkg upgrade` as an ordinary troubleshooting step.
- BusyBox may omit familiar utilities. Prefer OpenWrt-native commands such as `ubus`, `uci`, `/etc/init.d/<service>`, `logread`, and `apk`/`opkg`.

If the alias is missing, fall back to:

```bash
ssh -i ~/.ssh/id_ed25519_openwrt_ax6000 -o IdentitiesOnly=yes root@192.168.31.1
```

Report the local alias problem instead of falling back to a password.

### NAS

Use for “NAS”, Synology, DSM, storage, RAID, shared folders, NAS Docker/containers, or `192.168.31.240` requests.

- Login command: `ssh mental1104@192.168.31.240`
- WSL2 public-key login is already configured and was verified when the skill was created.
- The login user is an administrator but is not root. Start with unprivileged read-only checks.
- For work that genuinely requires root, allocate a PTY, connect with `ssh -tt mental1104@192.168.31.240`, then run `sudo -i`.
- `sudo -i` requires the NAS account password; it is not passwordless.

## Password interaction

Never store, infer, reuse across devices, or write a password into this skill, a file, a command argument, an environment variable, or shell history.

When NAS root access is needed:

1. Start the SSH command with a PTY and retain the live session identifier.
2. Run `sudo -i` only after login.
3. When the sudo password prompt appears, pause and ask the user for the NAS password. Do not treat any previously supplied router password as the NAS password.
4. If the user supplies it for the active session, send it once through the session's stdin followed by a newline. Do not repeat it in commentary or the final response.
5. Confirm elevation with `id -u`; continue only when it returns `0`. On failure, stop and ask rather than guessing.

Do not ask for a password when key login or unprivileged checks are sufficient.

## Operating workflow

- For questions, explanations, status checks, and diagnosis, perform read-only inspection only. A request to diagnose does not authorize package installation, configuration edits, service restarts, reboots, deletions, or updates.
- For an authorized change, inspect the exact current state first, preserve relevant configuration, make the smallest scoped change, and verify both the requested behavior and the critical service/network path it could affect.
- Use `BatchMode=yes` for non-interactive key-authentication checks so an unexpected password prompt fails cleanly. Use a PTY only for an interactive shell or NAS sudo.
- Avoid printing secrets such as subscription URLs, tokens, private keys, complete service configurations, or credentials. Query only the fields needed for the task and redact sensitive output.
- Before router firewall, DNS, DHCP, package, OpenClash, or SSH changes, identify how the current SSH session could be disrupted and keep a recovery path. Do not disable password SSH authentication unless the user explicitly requests it and key login has just been verified.
- Before NAS storage, RAID, filesystem, package, container, network, or service changes, inspect health and dependencies. Treat array operations, filesystem repair, recursive permission changes, deletes, reboots, and service-wide restarts as high-impact actions requiring explicit scope.
- Do not copy arbitrary executables or packages to either device merely to inspect them. Prefer local package inspection, streaming/read-only checks, or a clearly authorized installation workflow.
- End by stating what was observed, what changed, what was verified, and any recovery/rollback detail that remains relevant.
