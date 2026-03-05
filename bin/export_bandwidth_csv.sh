#!/bin/bash

OUT="$HOME/guardian/reports/per_ip_bandwidth.csv"

echo "timestamp,src_ip,dst_ip,bytes" > "$OUT"

for f in "$HOME"/guardian/scans/bandwidth_*.txt; do
  TS=$(basename "$f" | sed 's/bandwidth_//; s/.txt//')
  awk -v ts="$TS" '
  /src=192\.168\.50\./ {
    src=""; dst=""; bytes=""
    for (i=1;i<=NF;i++) {
      if ($i ~ /^src=/)   src=substr($i,5)
      if ($i ~ /^dst=/)   dst=substr($i,5)
      if ($i ~ /^bytes=/) bytes=substr($i,7)
    }
    if (src != "" && bytes != "")
      print ts "," src "," dst "," bytes
  }' "$f" >> "$OUT"
done
