#!/usr/bin/env bash
set -eo pipefail

mkdir -p output

# 逐行读取，忽略空行和以 # 开头的注释行
grep -Ev '^\s*($|#)' recipe_list.txt |
while IFS=: read -r recipe outname; do
  # —— 基本校验 ——
  if [[ -z "$recipe" || -z "$outname" ]]; then
    echo "::warning ::跳过格式不完整的行：'$recipe:$outname'"
    continue
  fi

  echo "Convert $recipe -> $outname"
  set +e
  ebook-convert "$recipe" "output/$outname"
  code=$?
  set -e

  case $code in
    0)  echo "✓ Success: $outname";;
    1)  echo "ℹ 无新文章：$recipe";;      # AbortRecipe
    *)  echo "::error ::ebook-convert exit $code on $recipe"
        exit "$code"
        ;;
  esac
done
