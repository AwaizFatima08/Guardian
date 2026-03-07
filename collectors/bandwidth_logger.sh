#!/bin/bash

INTERFACE="eno1"
OUTPUT_DIR="/NAS_BACKUPS/guardian_logs/telemetry"

mkdir -p "$OUTPUT_DIR"

TIMESTAMP=$(date +"%Y-%m-%dT%H:%M:%S")

RX1=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
TX1=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes)
RX_DROPS=$(cat /sys/class/net/$INTERFACE/statistics/rx_dropped)
TX_DROPS=$(cat /sys/class/net/$INTERFACE/statistics/tx_dropped)
RX_ERRORS=$(cat /sys/class/net/$INTERFACE/statistics/rx_errors)
TX_ERRORS=$(cat /sys/class/net/$INTERFACE/statistics/tx_errors)

sleep 1

RX2=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
TX2=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes)

RX_RATE=$((RX2 - RX1))
TX_RATE=$((TX2 - TX1))

RX_Mbps=$(awk "BEGIN {printf \"%.2f\", ($RX_RATE * 8) / 1000000}")
TX_Mbps=$(awk "BEGIN {printf \"%.2f\", ($TX_RATE * 8) / 1000000}")

echo "$TIMESTAMP,$INTERFACE,$RX_Mbps,$TX_Mbps,$RX_DROPS,$TX_DROPS,$RX_ERRORS,$TX_ERRORS" >> "$OUTPUT_DIR/bandwidth.csv"
