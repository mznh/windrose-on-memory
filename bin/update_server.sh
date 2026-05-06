#!/bin/bash

# --- 設定 ---
cd "$(dirname "$0")/.."
WORK_DIR="$(pwd)"
BACKUP_DIR="${WORK_DIR}/backup_saved"
ARCHIVE_DIR="${WORK_DIR}/archives"
KEEP_DAYS=7 # 保持する日数
# ----------

echo "=== Starting Server Update & Backup at $(date) ==="

cd "$WORK_DIR" || exit 1

# image更新
echo "Pulling latest images..."
docker compose pull || { echo "[Error] Failed to pull images. Update aborted."; exit 1; }


# サーバー停止
echo "Stopping containers gracefully (Waiting for final sync)..."
docker compose down


# バックアップ作成
# その時点でのbackup_savedをzipで固める
echo "Creating offline archive..."
mkdir -p "$ARCHIVE_DIR"
DATE=$(date +"%Y%m%d_%H%M%S")
ARCHIVE_FILE="${ARCHIVE_DIR}/windrose_offline_${DATE}.zip"

if command -v zip >/dev/null 2>&1; then
    cd "$BACKUP_DIR" && zip -qr "$ARCHIVE_FILE" .
    echo "Archive successfully created: $ARCHIVE_FILE"
else
    echo "[Warning] 'zip' command not found. Falling back to tar.gz..."
    ARCHIVE_FILE="${ARCHIVE_DIR}/windrose_offline_${DATE}.tar.gz"
    cd "$BACKUP_DIR" && tar -czf "$ARCHIVE_FILE" .
    echo "Archive successfully created: $ARCHIVE_FILE"
fi


# 古いアーカイブのローテーション（削除）
echo "Cleaning up archives older than $KEEP_DAYS days..."
find "$ARCHIVE_DIR" -name "windrose_offline_*" -type f -mtime +$KEEP_DAYS -exec rm -f {} \;

cd "$WORK_DIR" || exit 1
# ---------------------------------------------------------


# 再起動
echo "Starting containers..."
docker compose up -d --build

# 不要イメージ削除
echo "Pruning old images..."
docker image prune -f

echo "=== Update & Backup Complete ==="
