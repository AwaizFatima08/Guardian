#!/bin/bash
IFACE="eno1"
OUT="$HOME/guardian/isp/rx_tx_1min.log"

mkdir -p "$(dirname "$OUT")"

rx1=$(cat /sys/class/net/$IFACE/statistics/rx_bytes)
tx1=$(cat /sys/class/net/$IFACE/statistics/tx_bytes)

sleep 60

rx2=$(cat /sys/class/net/$IFACE/statistics/rx_bytes)
tx2=$(cat /sys/class/net/$IFACE/statistics/tx_bytes)

rx_rate=$(( (rx2 - rx1) / 60 ))
tx_rate=$(( (tx2 - tx1) / 60 ))

echo "$(date '+%F %T'),$rx_rate,$tx_rate" >> "$OUT"

