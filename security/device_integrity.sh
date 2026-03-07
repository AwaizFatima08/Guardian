#!/bin/bash

BASELINE="/home/humayun/guardian/security/authorized_devices.conf"
LOGFILE="/NAS_BACKUPS/guardian_logs/integrity/device_integrity.log"
TMPFILE="/tmp/current_scan.txt"

DATE=$(date "+%Y-%m-%d %H:%M:%S")

# Ensure log directory exists
mkdir -p /home/humayun/guardian/security

# Run arp-scan (requires sudoers NOPASSWD already configured)
sudo /usr/sbin/arp-scan --localnet --quiet \
| grep "^192.168.1." \
| awk '{print $1, toupper($2)}' \
| sort -u > "$TMPFILE"

# Always create log entry
{
echo "=============================="
echo "Scan Time: $DATE"
} >> "$LOGFILE"

# Process scan results
while read ip mac; do

    [ -z "$ip" ] && continue

    last_octet="${ip##*.}"

    # Skip invalid octets
    case "$last_octet" in
        ''|*[!0-9]*) continue ;;
    esac

    # Ignore DHCP pool (200–249)
    if [ "$last_octet" -ge 200 ] && [ "$last_octet" -le 249 ]; then
        echo "[GUEST] $ip $mac" >> "$LOGFILE"
        continue
    fi

    if grep -q "^$ip $mac" "$BASELINE"; then
        echo "[OK] $ip $mac" >> "$LOGFILE"
    else
        echo "[CRITICAL] Reserved IP violation: $ip $mac" >> "$LOGFILE"
    fi

done < "$TMPFILE"

echo "" >> "$LOGFILE"

exit 0
