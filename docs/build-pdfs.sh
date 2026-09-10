#!/usr/bin/env bash
# Rebuild the handout PDFs from the markdown sources into docs/pdf/.
#
# Requires pandoc and wkhtmltopdf. The \newpage markers in the markdown are
# translated to CSS page breaks; --toc is applied to everything except the
# one-page setup guide.
set -euo pipefail
cd "$(dirname "$0")"
export LANG=C.UTF-8 LC_ALL=C.UTF-8
mkdir -p pdf

declare -A OUT=(
  [worksheets]="Thread3_student_worksheets_weeks1-6.pdf"
  [setup]="Thread3_student_setup_guide.pdf"
  [teaching-pack]="Thread3_teaching_pack_weeks1-6.pdf"
)

for f in worksheets setup teaching-pack; do
  [ -f "$f.md" ] || { echo "skipping $f.md (not present)"; continue; }
  tmp=$(mktemp /tmp/$f.XXXX.md)
  sed 's|^\\newpage$|<div style="page-break-before: always"></div>|' "$f.md" > "$tmp"
  toc="--toc --toc-depth=1"
  [ "$f" = "setup" ] && toc=""
  pandoc "$tmp" -o "pdf/${OUT[$f]}" --pdf-engine=wkhtmltopdf --css=style.css \
    --standalone --metadata pagetitle="Thread 3" $toc \
    -V margin-top=18mm -V margin-bottom=18mm -V margin-left=16mm -V margin-right=16mm
  rm -f "$tmp"
  echo "pdf/${OUT[$f]}"
done
