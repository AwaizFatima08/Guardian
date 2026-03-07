#!/bin/bash

OUTPUT_DIR="/NAS_BACKUPS/guardian_logs/telemetry"

mkdir -p "$OUTPUT_DIR"

TIMESTAMP=$(date +"%Y-%m-%dT%H:%M:%S")
HOSTNAME=$(hostname)

echo "$TIMESTAMP,$HOSTNAME,OK" >> "$OUTPUT_DIR/heartbeat.csv"
