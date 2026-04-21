#!/usr/bin/env bash
set -euo pipefail

# =========================================================
# 用途：
# 把你指定的目录/文件移动到项目根目录下的 .legacy/ 中
#
# 你只需要改下面 MOVE_LIST 这一段
# 支持：
# 1) 目录
# 2) 文件
# 3) 相对项目根目录的路径
# 4) 绝对路径（但必须在项目根目录内）
# =========================================================

PROJECT_ROOT="/mnt/zzbnew/peixunban/zhanghebin/CIMA_multiomics_regulation"
LEGACY_ROOT="${PROJECT_ROOT}/.legacy"

# =========================================================
# 只改这里：把你想转移的路径一行一个粘贴进去
# 可以写相对路径，也可以写绝对路径
# 例子先给你放着，不要的就删掉
# =========================================================
MOVE_LIST=$(cat <<'EOF'
/mnt/zzbnew/peixunban/zhanghebin/CIMA_multiomics_regulation/notebooks/01_eda/01_raw_meta_inventory_and_conversion.ipynb
EOF
)

# =========================================================
# 正式逻辑
# =========================================================

mkdir -p "${LEGACY_ROOT}"

echo "PROJECT_ROOT: ${PROJECT_ROOT}"
echo "LEGACY_ROOT : ${LEGACY_ROOT}"
echo

moved_count=0
skipped_count=0

while IFS= read -r raw_path; do
    # 去掉首尾空白
    path="$(echo "${raw_path}" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"

    # 跳过空行和注释
    [[ -z "${path}" ]] && continue
    [[ "${path}" =~ ^# ]] && continue

    # 统一成绝对路径
    if [[ "${path}" = /* ]]; then
        src="${path}"
    else
        src="${PROJECT_ROOT}/${path}"
    fi

    # 规范化父目录，避免不存在时报错太奇怪
    src_parent="$(dirname "${src}")"
    if [[ ! -d "${src_parent}" ]]; then
        echo "[skip] parent not found: ${src_parent}"
        skipped_count=$((skipped_count + 1))
        echo
        continue
    fi

    # 转成规范绝对路径
    src_abs="$(cd "${src_parent}" && pwd)/$(basename "${src}")"

    # 必须在项目目录内
    case "${src_abs}" in
        "${PROJECT_ROOT}"/*) ;;
        *)
            echo "[skip] not under project root: ${src_abs}"
            skipped_count=$((skipped_count + 1))
            echo
            continue
            ;;
    esac

    if [[ ! -e "${src_abs}" ]]; then
        echo "[skip] not found: ${src_abs}"
        skipped_count=$((skipped_count + 1))
        echo
        continue
    fi

    # 计算相对项目根目录路径
    rel="${src_abs#${PROJECT_ROOT}/}"
    dst="${LEGACY_ROOT}/${rel}"
    dst_parent="$(dirname "${dst}")"

    mkdir -p "${dst_parent}"

    if [[ -e "${dst}" ]]; then
        timestamp="$(date +%Y%m%d_%H%M%S)"
        dst="${dst}.moved_${timestamp}"
        echo "[warn] target exists, renamed to:"
        echo "       ${dst}"
    fi

    echo "[move]"
    echo "  from: ${src_abs}"
    echo "  to  : ${dst}"
    mv "${src_abs}" "${dst}"
    moved_count=$((moved_count + 1))
    echo

done <<< "${MOVE_LIST}"

echo "done"
echo "moved  : ${moved_count}"
echo "skipped: ${skipped_count}"