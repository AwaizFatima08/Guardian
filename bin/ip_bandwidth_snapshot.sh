#!/bin/bash

TS=$(date +"%Y-%m-%d_%H-%M-%S")
OUT="$HOME/guardian/scans/bandwidth_$TS.txt"

echo "Timestamp: $TS" > "$OUT"
echo "----------------------------------" >> "$OUT"
echo "Per-IP bandwidth snapshot (conntrack)" >> "$OUT"
echo "----------------------------------" >> "$OUT"

conntrack -L -o extended 2>/dev/null | \
awk '
/bytes=/ {
  for (i=1;i<=NF;i++) {
    if ($i ~ /^src=/) src=$i
    if ($i ~ /^dst=/) dst=$i
    if ($i ~ /^bytes=/) bytes=$i
  }
  print src, dst, bytes
}' >> "$OUT"
