#!/bin/bash
# sync-ctl.sh — Manage Mutagen sync sessions
# Usage: sync-ctl.sh [status|pause|resume|flush|reset|monitor|destroy]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/config.sh"

case "${1:-status}" in
    status)
        echo "=== Mutagen Sync Status ==="
        mutagen sync list "${SESSION_NAME}"
        ;;
    pause)
        echo "Pausing sync..."
        mutagen sync pause "${SESSION_NAME}"
        echo "Sync paused. Use 'resume' to restart."
        ;;
    resume)
        echo "Resuming sync..."
        mutagen sync resume "${SESSION_NAME}"
        echo "Sync resumed."
        ;;
    flush)
        echo "Flushing (forcing immediate sync)..."
        mutagen sync flush "${SESSION_NAME}"
        echo "Flush complete."
        ;;
    reset)
        echo "Resetting sync session (re-scans both sides)..."
        mutagen sync reset "${SESSION_NAME}"
        echo "Reset complete."
        ;;
    monitor)
        echo "Monitoring sync (Ctrl+C to stop)..."
        mutagen sync monitor "${SESSION_NAME}"
        ;;
    destroy)
        read -rp "This will remove the sync session (local files are kept). Continue? [y/N] " confirm
        if [[ "${confirm}" =~ ^[Yy]$ ]]; then
            mutagen sync terminate "${SESSION_NAME}"
            echo "Session destroyed. Local files in ${LOCAL_DIR} are untouched."
        else
            echo "Aborted."
        fi
        ;;
    *)
        echo "Usage: $0 {status|pause|resume|flush|reset|monitor|destroy}"
        echo ""
        echo "  status   - Show current sync status (default)"
        echo "  pause    - Pause syncing"
        echo "  resume   - Resume syncing"
        echo "  flush    - Force immediate sync"
        echo "  reset    - Re-scan both sides"
        echo "  monitor  - Live monitoring"
        echo "  destroy  - Remove the sync session (keeps local files)"
        exit 1
        ;;
esac
