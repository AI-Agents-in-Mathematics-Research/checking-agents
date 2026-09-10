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

# The dateline printed on each handout. Not stored as YAML front-matter `date:`
# in the .md sources because that key is reserved by Jekyll (which also builds
# these files, via docs/_config.yml) and gets parsed as a datetime, not text.
declare -A DATE=(
  [worksheets]="Department of Mathematics, University of York"
  [setup]="Department of Mathematics, University of York"
  [teaching-pack]="Department of Mathematics, University of York — internal"
)

for f in worksheets setup teaching-pack; do
  [ -f "$f.md" ] || { echo "skipping $f.md (not present)"; continue; }
  tmp=$(mktemp /tmp/$f.XXXX.md)
  sed 's|^\\newpage$|<div style="page-break-before: always"></div>|' "$f.md" > "$tmp"
  toc="--toc --toc-depth=1"
  [ "$f" = "setup" ] && toc=""
  pandoc "$tmp" -o "pdf/${OUT[$f]}" --pdf-engine=wkhtmltopdf --css=style.css \
    --standalone --metadata pagetitle="Thread 3" --metadata date="${DATE[$f]}" $toc \
    -V margin-top=18mm -V margin-bottom=18mm -V margin-left=16mm -V margin-right=16mm
  rm -f "$tmp"
  echo "pdf/${OUT[$f]}"
done
