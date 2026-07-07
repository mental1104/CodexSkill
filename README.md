# Codex Skills

Personal Codex skill collection with a split between first-party skills and public upstream skills.

## Layout

- `private/`: skills maintained directly in this repository.
- `public/obsidian-skills/`: public upstream skills from `kepano/obsidian-skills`, tracked as a git submodule.
- `scripts/install.sh`: links every skill into `${CODEX_HOME:-$HOME/.codex}/skills`.

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

The installer creates symlinks, so editing this repository updates the installed skills immediately. It is written for the default Bash and core tools on macOS and Ubuntu.

Useful options:

```bash
./scripts/install.sh --dry-run
./scripts/install.sh --list
./scripts/install.sh --target /path/to/skills
./scripts/install.sh --force
```

If a destination already exists and points somewhere else, the script stops. Re-run with `--force` only when you want to replace those entries.

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
