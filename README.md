# Codex Skills

Personal Codex skill collection with a split between first-party skills and public upstream skills.

## Layout

- `private/`: skills maintained directly in this repository.
- `public/obsidian-skills/`: public upstream skills from `kepano/obsidian-skills`, tracked as a git submodule.
- `scripts/install.sh`: installs skills into `${CODEX_HOME:-$HOME/.codex}/skills`.

## Install

Fresh clone:

```bash
git clone --recurse-submodules <repo-url> codex-skills
cd codex-skills
./scripts/install.sh
```

Existing clone:

```bash
git submodule update --init --recursive
./scripts/install.sh
```

The installer defaults to symlinks, so editing this repository updates the installed skills immediately. Existing skill directories are moved aside with a timestamped `.backup-*` suffix instead of being overwritten.

Useful options:

```bash
./scripts/install.sh --dry-run
./scripts/install.sh --mode copy
./scripts/install.sh --private-only
./scripts/install.sh --public-only
./scripts/install.sh --target /path/to/skills
```

## Link Private Skills

For day-to-day maintenance, keep `private/` as the source of truth and link runtime skill directories back to it:

```bash
./scripts/link-private-skills.sh
```

Common targets:

```bash
./scripts/link-private-skills.sh --workspace "/path/to/project"
./scripts/link-private-skills.sh --global --workspace "/path/to/project"
./scripts/link-private-skills.sh --dry-run --global --workspace "/path/to/project"
```

The script is a small Bash wrapper around `install.sh --private-only --mode symlink`. It works with the default Bash and core tools on Linux and macOS.

## Update Public Skills

```bash
git submodule update --remote public/obsidian-skills
git add public/obsidian-skills
git commit -m "Update public obsidian skills"
```

## Push A New GitHub Repository

After creating an empty GitHub repository:

```bash
git remote add origin <repo-url>
git push -u origin main
```
