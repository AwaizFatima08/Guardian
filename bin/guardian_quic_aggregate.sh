#!/bin/bash
# ============================================================
# Guardian Step-4bA: Aggregate QUIC (UDP/443) flows
# Output: flow-level summaries (5-minute buckets)
# ============================================================

IN="$HOME/guardian/tls/quic_readable.log"
OUT="$HOME/guardian/tls/quic_flows.log"

[ -f "$IN" ] || exit 0

echo "window_start,src_ip,dst_ip,packets,total_bytes" > "$OUT"

awk -F',' '
NR>1 {
  # bucket into 5-minute windows
  cmd = "date -d \"" $1 "\" +\"%Y-%m-%d %H:%M\""
  cmd | getline t
  close(cmd)

  key = t "," $2 "," $3
  pkts[key]++
  bytes[key] += $5
}
END {
  for (k in pkts) {
    split(k, a, ",")
    printf "%s,%s,%s,%d,%d\n", a[1], a[2], a[3], pkts[k], bytes[k]
  }
}' "$IN" >> "$OUT"
