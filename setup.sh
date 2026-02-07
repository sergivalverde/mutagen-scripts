#!/bin/bash
# setup.sh — Install Mutagen and create the sync session
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/config.sh"

echo "=== Mutagen Sync Setup ==="

# Check if mutagen is installed
if ! command -v mutagen &>/dev/null; then
    echo "Installing Mutagen via Homebrew..."
    brew install mutagen-io/mutagen/mutagen
else
    echo "Mutagen already installed: $(mutagen version)"
fi

# Start daemon if not running
if ! mutagen daemon start 2>/dev/null; then
    echo "Daemon already running."
fi

# Create local directory
mkdir -p "${LOCAL_DIR}"
echo "Local directory: ${LOCAL_DIR}"

# Check if session already exists
if mutagen sync list "${SESSION_NAME}" &>/dev/null; then
    echo "Session '${SESSION_NAME}' already exists."
    mutagen sync list "${SESSION_NAME}"
    exit 0
fi

# Build ignore flags
IFS=',' read -ra IGNORES <<< "${IGNORE_PATTERNS}"
IGNORE_FLAGS=()
for pattern in "${IGNORES[@]}"; do
    IGNORE_FLAGS+=(--ignore="${pattern}")
done

# Create sync session
echo "Creating sync session '${SESSION_NAME}'..."
mutagen sync create \
    "${LOCAL_DIR}" \
    "${SSH_HOST}:${REMOTE_DIR}" \
    --name="${SESSION_NAME}" \
    --sync-mode="${SYNC_MODE}" \
    "${IGNORE_FLAGS[@]}" \
    --symlink-mode=posix-raw

echo ""
echo "Registering daemon for auto-start on login..."
mutagen daemon stop 2>/dev/null || true
sleep 1
mutagen daemon register 2>/dev/null || echo "Already registered."
mutagen daemon start

echo ""
echo "=== Setup Complete ==="
mutagen sync list "${SESSION_NAME}"
