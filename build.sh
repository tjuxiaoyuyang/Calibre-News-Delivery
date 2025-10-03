#!/usr/bin/env bash
set -eo pipefail

mkdir -p output

# 固定参数：禁用默认封面，强制使用我们生成的封面图
EXTRA_OPTS=(--no-default-epub-cover --cover output/cover.png)

grep -Ev '^\s*($|#)' recipe_list.txt |
while IFS=: read -r recipe outname; do
  if [[ -z "$recipe" || -z "$outname" ]]; then
    echo "::warning ::跳过格式不完整的行：'$recipe:$outname'"
    continue
  fi

  echo "Convert $recipe -> output/$outname"
  set +e
  ebook-convert "$recipe" "output/$outname" "${EXTRA_OPTS[@]}"
  code=$?
  set -e

  case $code in
    0)  echo "✓ Success: $outname";;
    1)  echo "ℹ 无新文章：$recipe";;
    *)  echo "::error ::ebook-convert exit $code on $recipe"
        exit "$code"
        ;;
  esac
done
