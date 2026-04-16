#!/usr/bin/env bash
set -euo pipefail

echo "[1/8] 定位项目目录"
PROJ_DIR=$(cd "$(dirname "$0")/.." && pwd)
echo "PROJ_DIR=$PROJ_DIR"
cd "$PROJ_DIR"

echo "[2/8] 检查是否为 git 仓库"
git rev-parse --is-inside-work-tree

echo "[3/8] 生成 commit message"
TODAY=$(date +%Y%m%d)
COUNT=$(git log --since="today 00:00" --oneline | wc -l)
INDEX=$((COUNT + 1))
AUTO_MSG="${TODAY}_${INDEX}"
MSG="${1:-$AUTO_MSG}"
echo "MSG=$MSG"

echo "[4/8] 配置 git 用户"
git config user.name "zhanghebin"
git config user.email "misakaheb@163.com"

echo "[5/8] 查看变更"
git status --short

echo "[6/8] git add"
time git add .

echo "[7/8] git commit"
git commit -m "$MSG" || echo "⚠️ 没有新的更改"

echo "[8/8] git push"
BRANCH=$(git branch --show-current)
echo "BRANCH=$BRANCH"
time git push -u origin "$BRANCH"

echo "✅ Push 完成: $MSG (branch=$BRANCH)"