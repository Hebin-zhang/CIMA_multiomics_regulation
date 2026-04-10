#!/usr/bin/env bash
set -euo pipefail

# 使用说明：
# ./git_push.sh "commit message"
# 如果没有提供 commit message，默认使用 "update project"

# commit message
MSG="${1:-update project}"

# 切换到项目根目录（确保路径正确）
PROJ_DIR=$(dirname "$0")/..
cd "$PROJ_DIR"

# 配置身份（只针对当前仓库，如果未配置）
git config user.name "zhanghebin"
git config user.email "misakaheb@163.com"

# 添加所有文件（受 .gitignore 控制）
git add .

# 提交
git commit -m "$MSG"

# 确认当前分支
BRANCH=$(git branch --show-current)

# 如果没有远程 origin，需要先添加：
# git remote add origin https://github.com/Hebin-zhang/CIMA_multiomics_regulation.git

# 推送到 GitHub
git push -u origin "$BRANCH"

echo "✅ Push 完成: branch=$BRANCH"