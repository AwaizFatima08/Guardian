#!/bin/bash
# ============================================================
# Guardian Step-4b: Passive HTTPS / QUIC Visibility
# Interface : eno1 (default route / internet egress)
# Capture   : TCP 443 (TLS) + UDP 443 (QUIC / HTTP-3)
# Mode      : Passive, non-inline, safe
# ============================================================

IFACE="eno1"
OUTDIR="$HOME/guardian/tls"
LOGDIR="$HOME/guardian/logs"
LOG="$LOGDIR/tls.log"

TS=$(date +"%Y-%m-%d_%H-%M-%S")
PCAP="$OUTDIR/tls_$TS.pcap"

# Ensure directories exist
mkdir -p "$OUTDIR" "$LOGDIR"

# Capture HTTPS + QUIC metadata for 60 seconds
timeout 60 tcpdump \
  -i "$IFACE" \
  -n \
  -s 0 \
  -w "$PCAP" \
  '(tcp port 443 or udp port 443)' >> "$LOG" 2>&1

# Validate capture
if [ -s "$PCAP" ] && [ "$(stat -c%s "$PCAP")" -gt 100 ]; then
    echo "[$TS] TLS/QUIC capture OK: $(basename "$PCAP") ($(stat -c%s "$PCAP") bytes)" >> "$LOG"
else
    rm -f "$PCAP"
    echo "[$TS] TLS/QUIC capture empty or insignificant — discarded" >> "$LOG"
fi

exit 0

