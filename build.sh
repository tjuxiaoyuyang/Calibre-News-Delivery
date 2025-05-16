#!/usr/bin/env bash
set -eo pipefail

mkdir -p output

# 允许 ebook-convert 退出码 0（成功）或 1（AbortRecipe=无新文章）
ebook-convert recipes/caijing_weather.recipe \
              "output/财经·天气.epub" 2>&1 || status=$?

if [[ -n "$status" && "$status" -ne 1 ]]; then
  # 只有非 0/1 才是真异常，结束 CI
  exit "$status"
fi
