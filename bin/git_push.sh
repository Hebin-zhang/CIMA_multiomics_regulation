#!/usr/bin/env bash
set -euo pipefail

# ========================
# 自动生成 commit message
# 格式：20260410_1
# ========================

TODAY=$(date +%Y%m%d)

# 统计今天已有多少 commit
COUNT=$(git log --since="today 00:00" --oneline | wc -l)

# 当前是第几次（+1）
INDEX=$((COUNT + 1))

AUTO_MSG="${TODAY}_${INDEX}"

# 如果用户手动输入 message，就用用户的
MSG="${1:-$AUTO_MSG}"

# ========================

# 切换到项目根目录
PROJ_DIR=$(dirname "$0")/..
cd "$PROJ_DIR"

# 配置身份
git config user.name "zhanghebin"
git config user.email "misakaheb@163.com"

# add
git add .

# commit（如果没变化不会报错）
git commit -m "$MSG" || echo "⚠️ 没有新的更改"

# 当前分支
BRANCH=$(git branch --show-current)

# push
git push -u origin "$BRANCH"

echo "✅ Push 完成: $MSG (branch=$BRANCH)"