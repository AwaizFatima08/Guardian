#!/bin/bash

NETWORK="192.168.1.0/24"
LOG_DIR="/NAS_BACKUPS/network_logs"

INVENTORY="$LOG_DIR/device_inventory.log"
NEW_DEVICES="$LOG_DIR/new_devices.log"
KNOWN="$LOG_DIR/known_devices.txt"

TMP_SCAN="/tmp/device_scan.txt"

sudo arp-scan --localnet > "$TMP_SCAN"

while read line; do
    IP=$(echo $line | awk '{print $1}')
    MAC=$(echo $line | awk '{print $2}')

    if [[ $IP =~ ^192\.168\. ]]; then

        echo "$(date) $IP $MAC" >> "$INVENTORY"

        if ! grep -q "$MAC" "$KNOWN"; then
            echo "$(date) NEW DEVICE DETECTED → $IP $MAC" >> "$NEW_DEVICES"
            echo "$MAC" >> "$KNOWN"
        fi

    fi
done < "$TMP_SCAN"
