#!/bin/bash
# ============================================================
# Guardian Step-4b: HTTPS / QUIC passive visibility
# Uses frame.len (robust across tshark builds)
# Handles .pcap and .pcap.gz
# Sensor self-traffic excluded
# ============================================================

EXCLUDE_IP="192.168.50.110"
PCAP_DIR="$HOME/guardian/tls"
OUT="$HOME/guardian/tls/quic_readable.log"
TMP="/tmp/guardian_quic_parse_$$.pcap"

mkdir -p "$(dirname "$OUT")"
echo "timestamp,src_ip,dst_ip,protocol,bytes" > "$OUT"

parse_file() {
    local file="$1"

    tshark -r "$file" -Y "udp.port == 443" \
        -T fields \
        -e frame.time_epoch \
        -e ip.src \
        -e ip.dst \
        -e frame.len 2>/dev/null \
    | awk -F'\t' -v exclude="$EXCLUDE_IP" '
        NF < 4 { next }
        $2 == exclude || $3 == exclude { next }
        {
            ts = strftime("%Y-%m-%d %H:%M:%S", $1)
            printf "%s,%s,%s,UDP/443,%s\n", ts, $2, $3, $4
        }
    ' >> "$OUT"
}

for file in "$PCAP_DIR"/tls_*.pcap; do
    [[ -s "$file" ]] || continue
    parse_file "$file"
done

for gz in "$PCAP_DIR"/tls_*.pcap.gz; do
    [[ -s "$gz" ]] || continue
    gunzip -c "$gz" > "$TMP" || continue
    parse_file "$TMP"
    rm -f "$TMP"
done

exit 0

