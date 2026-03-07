#!/bin/bash

OUTPUT_DIR="/NAS_BACKUPS/guardian_logs/telemetry"

mkdir -p "$OUTPUT_DIR"

TIMESTAMP=$(date +"%Y-%m-%dT%H:%M:%S")
HOSTNAME=$(hostname)
UPTIME=$(awk '{print int($1)}' /proc/uptime)
BOOT_TIME=$(who -b | awk '{print $3" "$4}')
LOAD_AVG=$(awk '{print $1}' /proc/loadavg)

echo "$TIMESTAMP,$HOSTNAME,$UPTIME,$BOOT_TIME,$LOAD_AVG" >> "$OUTPUT_DIR/host_status.csv"
