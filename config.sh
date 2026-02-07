#!/bin/bash
# config.sh — Mutagen sync configuration
# Edit these values to match your setup.

# SSH host alias (as defined in ~/.ssh/config)
SSH_HOST="mic2"

# Remote directory to sync
REMOTE_DIR="/home/sergivalverde/devcontainer_data/shared"

# Local directory to sync
LOCAL_DIR="$HOME/dev/mic2-sync"

# Mutagen session name
SESSION_NAME="mic2-shared"

# Sync mode: two-way-safe, two-way-resolved, one-way-safe, one-way-replica
SYNC_MODE="two-way-resolved"

# Ignore patterns (comma-separated)
IGNORE_PATTERNS=".git,__pycache__,*.pyc,.venv,*.tmp,.DS_Store"
