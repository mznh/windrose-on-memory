#!/bin/sh
# sync.sh - 差分同期とSIGTERM処理（安全装置付き）

SYNC_INTERVAL=300 # 5分
SRC_DIR="/saved/"
DEST_DIR="/backup/"

echo "[Sidecar] Starting Sync Service. Interval: ${SYNC_INTERVAL}s"

cleanup() {
    echo "[Sidecar] SIGTERM received! Starting graceful shutdown..."
    
    # マーカーファイルがある場合のみ最終保存する
    if [ -f "${SRC_DIR}.ram_loaded" ]; then
        echo "[Sidecar] Waiting for main server to release files (10s)..."
        sleep 10
        echo "[Sidecar] Executing FINAL sync to physical disk..."
        rsync -a --delete --exclude='.ram_loaded' "$SRC_DIR" "$DEST_DIR"
        echo "[Sidecar] Final sync complete. Safe to exit."
    else
        echo "[Sidecar] DANGER: Initial load not completed! Skipping final sync to prevent data loss."
    fi
    exit 0
}

trap cleanup TERM INT

while true; do
    sleep $SYNC_INTERVAL &
    wait $!
    
    if [ -f "${SRC_DIR}.ram_loaded" ]; then
        echo "[Sidecar] Periodic sync at $(date)"
        rsync -a --delete --exclude='.ram_loaded' "$SRC_DIR" "$DEST_DIR"
    else
        echo "[Sidecar] Waiting for initial load to complete..."
    fi
done
