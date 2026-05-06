#!/bin/bash

WORK_DIR="/home/windrose/sub-ram"

# フラグの初期化（デフォルトはどちらも表示しない設定）
SHOW_EXPIRED=false
SHOW_SLOW=false

# getopts を使ってオプションを解析
while getopts "es" opt; do
  case "$opt" in
    e) SHOW_EXPIRED=true ;;
    s) SHOW_SLOW=true ;;
    *) 
      echo "Usage: $0 [-e] [-s]"
      exit 1
      ;;
  esac
done

# オプションが1つも指定されなかった場合（両方falseの場合）は両方ともtrueにする
if [ "$SHOW_EXPIRED" = false ] && [ "$SHOW_SLOW" = false ]; then
  SHOW_EXPIRED=true
  SHOW_SLOW=true
fi

# docker-compose.yml があるディレクトリへ移動
cd "$WORK_DIR" || exit 1

# フラグに応じてログを出力
if [ "$SHOW_EXPIRED" = true ]; then
  docker compose logs | grep "TimeStamp expired"
fi

if [ "$SHOW_SLOW" = true ]; then
  docker compose logs | grep -E "Slow task|EXTREMELY slow task"
fi
