#!/bin/bash

BASE_DIR="/home/homi/guardian"
OUTPUT_DIR="$BASE_DIR/raw/wan"

mkdir -p "$OUTPUT_DIR"

TIMESTAMP=$(date +"%Y-%m-%dT%H:%M:%S")

PING_OUTPUT=$(ping -c 5 -W 2 8.8.8.8)

AVG_LATENCY=$(echo "$PING_OUTPUT" | grep rtt | awk -F '/' '{print $5}')
PACKET_LOSS=$(echo "$PING_OUTPUT" | grep -oP '\d+(?=% packet loss)')

if [ -z "$AVG_LATENCY" ]; then
    AVG_LATENCY="NA"
fi

if [ -z "$PACKET_LOSS" ]; then
    PACKET_LOSS="100"
fi

echo "$TIMESTAMP,$AVG_LATENCY,$PACKET_LOSS" >> "$OUTPUT_DIR/wan_quality.csv"
