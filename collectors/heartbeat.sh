#!/bin/bash

BASE_DIR="/home/homi/guardian"
OUTPUT_DIR="$BASE_DIR/raw/heartbeat"

mkdir -p "$OUTPUT_DIR"

TIMESTAMP=$(date +"%Y-%m-%dT%H:%M:%S")
HOSTNAME=$(hostname)

echo "$TIMESTAMP,$HOSTNAME,OK" >> "$OUTPUT_DIR/heartbeat.csv"
