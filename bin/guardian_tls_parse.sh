#!/bin/bash
# Guardian Step-4b: Parse TLS pcaps into readable log

PCAP_DIR="$HOME/guardian/tls"
OUT="$HOME/guardian/tls/tls_readable.log"

mkdir -p "$(dirname "$OUT")"
echo "timestamp,src_ip,dst_ip,sni,org" > "$OUT"

for p in "$PCAP_DIR"/tls_*.pcap; do
  [ -s "$p" ] || continue

  # Extract TLS ClientHello SNI
  tshark -r "$p" -Y "tls.handshake.type==1 && tls.handshake.extensions_server_name" \
    -T fields \
    -e frame.time_epoch \
    -e ip.src \
    -e ip.dst \
    -e tls.handshake.extensions_server_name 2>/dev/null \
  | while IFS=$'\t' read -r t src dst sni; do
      ts=$(date -d @"${t%.*}" +"%Y-%m-%d %H:%M:%S")
      # Resolve destination org (cached by whois; best-effort)
      org=$(whois "$dst" 2>/dev/null | awk -F: '/OrgName|org-name|Organization/{print $2; exit}' | sed 's/^[ \t]*//')
      echo "$ts,$src,$dst,${sni:-unknown},${org:-unknown}" >> "$OUT"
    done
done
