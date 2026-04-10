#!/usr/bin/env bash
set -euo pipefail
git add .
git commit -m "${1:-update project}"
git push
