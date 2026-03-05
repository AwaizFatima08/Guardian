#!/bin/bash

# ================================
# Guardian Network Scan (Sensor)
# ================================

set -e

# ---- CONFIG ----
SUBNET="192.168.50.0/24"
BASELINE="$HOME/guardian/baseline/nmap_baseline.txt"
SCAN_ROOT="$HOME/guardian/scans"
LOG="$HOME/guardian/logs/guardian.log"
ALERT_SCRIPT="$HOME/guardian/bin/guardian_alerts.sh"

NAS_USER="humayun"
NAS_IP="192.168.50.103"
NAS_SCAN_DIR="/home/humayun/guardian/scans"

# ---- INIT ----
TS=$(date +"%Y-%m-%d_%H-%M-%S")
SCAN_DIR="$SCAN_ROOT/$TS"

mkdir -p "$SCAN_DIR" "$(dirname "$LOG")"

echo "[$TS] Starting Guardian scan" >> "$LOG"

# ---- SCAN (ARP-based, LAN-safe) ----
nmap -sn -PR "$SUBNET" > "$SCAN_DIR/nmap.txt"

# ---- VALIDATE SCAN ----
HOSTS_UP=$(grep -c "Nmap scan report for" "$SCAN_DIR/nmap.txt")

if [ "$HOSTS_UP" -eq 0 ]; then
  echo "[$TS] WARN: Empty scan (0 hosts up). Skipping diff & alerts." >> "$LOG"
  exit 0
fi

echo "[$TS] Scan completed: $HOSTS_UP hosts up" >> "$LOG"

# ---- DIFF AGAINST BASELINE ----
if [ -f "$BASELINE" ]; then
  diff -u "$BASELINE" "$SCAN_DIR/nmap.txt" > "$SCAN_DIR/diff.txt" || true
else
  echo "[$TS] WARN: Baseline missing, creating baseline" >> "$LOG"
  cp "$SCAN_DIR/nmap.txt" "$BASELINE"
  echo "Baseline created at $TS" > "$SCAN_DIR/diff.txt"
fi

# ---- RSYNC TO NAS ----
rsync -az --delete \
  "$SCAN_DIR/" \
  "$NAS_USER@$NAS_IP:$NAS_SCAN_DIR/$TS/" >> "$LOG" 2>&1

echo "[$TS] Scan synced to NAS" >> "$LOG"

# ---- RUN ALERTS ----
if [ -x "$ALERT_SCRIPT" ]; then
  "$ALERT_SCRIPT"
  echo "[$TS] Alerts evaluated" >> "$LOG"
else
  echo "[$TS] WARN: Alert script not executable or missing" >> "$LOG"
fi

echo "[$TS] Guardian scan completed" >> "$LOG"
