#!/bin/bash

# Passive DNS capture (non-inline)
IFACE="enx00e09900b4f3"
OUTDIR="$HOME/guardian/dns"
LOG="$HOME/guardian/logs/dns.log"

TS=$(date +"%Y-%m-%d_%H-%M-%S")
PCAP="$OUTDIR/dns_$TS.pcap"

mkdir -p "$OUTDIR" "$(dirname "$LOG")"

# Capture DNS (UDP/TCP 53) for 60 seconds
timeout 60 tcpdump -i "$IFACE" -n -s 0 -w "$PCAP" '(udp port 53 or tcp port 53)' >> "$LOG" 2>&1

echo "[$TS] DNS capture saved: $PCAP" >> "$LOG"
