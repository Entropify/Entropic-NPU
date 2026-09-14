#!/usr/bin/env bash
# Regenerate Google-Docs-ready exports (.docx for Drive import, .html for copy-paste)
set -e
PANDOC="$LOCALAPPDATA/Temp/pandoc-dl/pandoc.exe"
cd "$(dirname "$0")"
for f in ROADMAP TEAM-A-hardware-fpga TEAM-B-software-ai; do
  "$PANDOC" -f gfm -t docx -s --toc --toc-depth=2 "$f.md" -o "$f.docx"
  "$PANDOC" -f gfm -t html5 -s --toc --toc-depth=2 --metadata title="$f" \
      --include-in-header=gdocs-style.html "$f.md" -o "$f.html"
  echo "built $f.docx / $f.html"
done
