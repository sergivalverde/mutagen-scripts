# Mutagen Sync Scripts

## What is Mutagen?

[Mutagen](https://mutagen.io/) is a fast, continuous, bidirectional file synchronization tool designed for remote development. Unlike traditional tools like `rsync` or `scp` that require manual invocation, Mutagen runs as a background daemon that watches for filesystem changes and propagates them in real time between a local machine and a remote host over SSH. It handles conflict resolution, symlinks, permissions, and large file trees efficiently, making it ideal for developers who edit code locally but need it mirrored on a remote server, VM, or container.

## How It Works

This repo contains three shell scripts that wrap Mutagen into a simple workflow:

1. **`config.sh`** — Central configuration file. All settings (host, paths, sync mode, ignore patterns) live here so the other scripts stay generic and reusable.

2. **`setup.sh`** — One-time setup script that:
   - Installs Mutagen via Homebrew (if not already installed)
   - Starts the Mutagen daemon
   - Creates the local sync directory
   - Creates a named sync session between local and remote
   - Registers the daemon to auto-start on login

3. **`sync-ctl.sh`** — Day-to-day management tool with subcommands:
   - `status` — Show current sync state (default)
   - `pause` / `resume` — Toggle syncing on and off
   - `flush` — Force an immediate sync cycle
   - `reset` — Re-scan both sides from scratch
   - `monitor` — Live stream of sync activity
   - `destroy` — Remove the sync session (local files are kept)

Once `setup.sh` has run, the daemon watches both sides for changes and syncs them automatically. No cron jobs or manual triggers needed.

## Example Setup

This is configured to sync a shared directory from a remote GPU server (`mic2`) to a local Mac:

| Setting | Value |
|---|---|
| SSH host | `mic2` (defined in `~/.ssh/config`) |
| Remote directory | `/home/bobharris/data/shared` |
| Local directory | `~/dev/mic2-sync` |
| Session name | `mic2-shared` |
| Sync mode | `two-way-resolved` (changes on both sides sync, with alpha winning conflicts) |
| Ignored | `.git`, `__pycache__`, `*.pyc`, `.venv`, `*.tmp`, `.DS_Store` |

### Quick Start

```bash
# 1. Edit config.sh with your host and paths
vim config.sh

# 2. Run setup (installs mutagen, creates session, registers daemon)
./setup.sh

# 3. Check status
./sync-ctl.sh status

# 4. Monitor live sync activity
./sync-ctl.sh monitor
```

### SSH Config Prerequisite

The SSH host alias used in `config.sh` must be defined in `~/.ssh/config`. For example:

```
Host mic2
    HostName 10.0.0.50
    User bobharris
    IdentityFile ~/.ssh/id_ed25519
```
