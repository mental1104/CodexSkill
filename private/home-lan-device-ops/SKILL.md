---
name: home-lan-device-ops
description: Connect to, diagnose, and maintain the user's home NAS, soft router, and wireless router over SSH. Use automatically when the user asks to connect to or operate a home NAS, storage server, soft router, gateway, router, Wi-Fi device, or related home-LAN service. Resolve the device role and SSH alias from the fixed private knowledge-base document before connecting; if the current runtime terminal cannot log in with public-key authentication, guide the user to configure the alias and passwordless SSH there. Do not use for unrelated remote hosts.
---

# Home LAN Device Operations

Use a private knowledge-base note as the source of truth for device roles and SSH aliases. The public Skill owns only the generic connection, bootstrap, diagnosis, and safe-operation workflow.

## Read the private connection note first

Before selecting a target or issuing SSH commands:

1. Locate the fixed note at `Atlas/300-Infras/Architecture/家庭 LAN SSH 建联清单.md`.
2. When the vault is available in the current workspace, read that exact file.
3. Otherwise, use the available private-knowledge retrieval capability to fetch that exact note from the user's configured private knowledge source.
4. Read only the connection fields needed for the requested device and operation.
5. Match the user's wording to the role recorded in the note. Keep NAS, soft router, and wireless router distinct.
6. Treat the alias in the note as authoritative. Do not derive an address, user, model, identity path, or fingerprint from this public Skill.

If the private note is unavailable, say that the device alias cannot be resolved from the private knowledge base. Ask the user to make the note accessible or provide the intended alias. Do not search the public web for private connection data and do not guess.

## Alias-only connection contract

Assume a correctly prepared Codex runtime terminal can connect through a stable SSH alias.

- Probe public-key login non-interactively:

```bash
ssh -o BatchMode=yes -o ConnectTimeout=8 <alias> true
```

- After the probe succeeds, connect with:

```bash
ssh <alias>
```

- For a read-only remote check, continue to use the alias:

```bash
ssh <alias> '<read-only command>'
```

Do not bypass a failing alias with a raw IP address, username, identity file, password, or legacy endpoint from memory. Connection details belong in the private note and the runtime terminal's SSH configuration, not in this Skill.

## When the alias or passwordless login is not ready

A failed probe means the current runtime environment is not ready for device operations. Stop before running device commands and classify the failure.

### Alias missing or hostname unresolved

Explain that the alias is not configured in the current terminal's SSH environment. Guide the user to add a `Host <alias>` entry to that environment's `~/.ssh/config` using the private note and a trusted working environment as references:

```sshconfig
Host <alias>
    HostName <device-host-or-ip>
    User <ssh-user>
    IdentityFile ~/.ssh/<private-key>
    IdentitiesOnly yes
```

Do not write or replace the user's SSH configuration unless they explicitly ask. Do not invent any placeholder value.

### Public-key authentication fails or SSH asks for a password

The target may lack the current environment's public key, or the alias may point at the wrong identity.

Guide the user to:

1. Inspect the effective alias configuration with `ssh -G <alias>`.
2. Generate an Ed25519 key in the current runtime environment when no suitable key exists.
3. Install only the public key on the target, for example with `ssh-copy-id <alias>` when supported, or through the device's trusted management interface.
4. Enter any one-time login password directly in their own terminal. Do not ask them to send the password to Codex.
5. Repeat the `BatchMode=yes` probe until it succeeds without interaction.

Never store a password, private key, recovery code, or secret in the Skill, knowledge note, command arguments, environment variables, logs, or chat.

### Host key verification fails

Do not automatically delete `known_hosts` entries or use `StrictHostKeyChecking=no`.

- Compare the presented fingerprint with the fingerprint recorded in the private note or another trusted out-of-band source.
- Treat an unexpected change as a possible reinstall, address reuse, or interception until verified.
- Let the user accept or replace the key only after verification.
- If the private note has no verified fingerprint, ask the user to verify it through the device console or management interface and then update the private note.

`ssh-keyscan` may collect a candidate key but does not establish trust by itself.

### Connection timeout or refusal

Check, in order:

1. whether the current environment is on the required LAN or VPN;
2. whether the alias resolves to the expected destination with `ssh -G <alias>`;
3. whether routing and DNS are available;
4. whether TCP port 22 is reachable;
5. whether the target SSH service is running and allowed by its firewall.

Keep these checks read-only. Do not change router, firewall, or SSH settings merely to make the probe pass.

## Operating workflow after connection

- Re-detect the operating system, version, architecture, current privilege, package manager, services, and network state on every session. Historical facts in the private note are context, not guaranteed runtime state.
- For questions, status checks, and diagnosis, perform read-only inspection only. Diagnosis does not authorize installation, configuration changes, service restarts, reboots, deletions, upgrades, or key rotation.
- For an authorized change, inspect the exact current state, preserve the relevant configuration, make the smallest scoped change, and verify the requested outcome.
- Follow device-specific cautions recorded in the private note. Do not assume all routers run the same operating system or that every login is root.
- Before changing routing, firewall, DNS, DHCP, Wi-Fi, SSH, storage, RAID, filesystems, containers, or core services, identify how the active connection could be lost and keep a recovery path.
- Query only the fields needed for the task. Redact subscription URLs, tokens, cookies, private keys, passwords, complete credential-bearing configuration, and unrelated private data.
- End by stating what was observed, what changed, what was verified, and any relevant recovery or rollback detail.

## Maintaining the boundary

When a device role, alias, address, user, identity path, topology fact, or host key fingerprint changes:

1. update the fixed private knowledge-base note;
2. update the affected runtime environments' SSH configuration;
3. verify passwordless access from each environment;
4. leave this public Skill generic.

Never copy private infrastructure facts back into this repository.
