#!/bin/bash
# Guardian Step-4: Parse DNS pcaps into readable log

PCAP_DIR="$HOME/guardian/dns"
OUT="$HOME/guardian/dns/dns_readable.log"

mkdir -p "$(dirname "$OUT")"

# CSV header
echo "timestamp,src_ip,query,answer" > "$OUT"

for p in "$PCAP_DIR"/dns_*.pcap; do
  [ -s "$p" ] || continue

  tshark -r "$p" -Y "dns && dns.qry.name" \
    -T fields \
    -e frame.time_epoch \
    -e ip.src \
    -e dns.qry.name \
    -e dns.a 2>/dev/null \
  | awk -F'\t' '{printf "%s,%s,%s,%s\n", strftime("%Y-%m-%d %H:%M:%S",$1), $2, $3, $4}' >> "$OUT"
done
