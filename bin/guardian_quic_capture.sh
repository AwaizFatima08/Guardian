#!/bin/bash
# Guardian QUIC Capture (UDP/443)
# Runs continuously and rotates files

OUTDIR="$HOME/guardian/tls"
IFACE="eno1"

mkdir -p "$OUTDIR"

exec /usr/bin/tcpdump -i "$IFACE" -nn udp port 443 \
  -G 300 \
  -w "$OUTDIR/tls_%Y-%m-%d_%H-%M-%S.pcap" \
  -z gzip \
  -Z homi

