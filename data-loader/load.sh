#!/bin/sh
# load.sh - 初期データのRAMディスクへの流し込み

echo '[Loader] Checking /backup directory...'

if [ "$(ls -A /backup 2>/dev/null)" ]; then
    echo '[Loader] Backup data found. Restoring to RAM...'
    rsync -v -rltD --chown=1002:1002 /backup/ /saved/ || echo '[Loader] rsync ERROR!'
else
    echo '[Loader] No backup found. Fresh start.'
fi

# data-sync側が先に実行されてしまうことを防ぐマーカーファイル
touch /saved/.ram_loaded
chown 1002:1002 /saved/.ram_loaded

echo '[Loader] Finished. Marker created.'
