#!/bin/bash
THRESHOLD=$((2.5 * 1024 * 1024))   # bytes/sec
FILE="$HOME/guardian/isp/isp_hourly.log"
ALERT="$HOME/guardian/logs/isp_alerts.log"

mkdir -p "$(dirname "$ALERT")"
[[ -f "$FILE" ]] || exit 0

low=$(tail -n 3 "$FILE" | awk -F, '
{
  for(i=1;i<=NF;i++)
    if($i ~ /peak_rx=/){
      split($i,a,"=")
      if(a[2] < ENVIRON["THRESHOLD"]) c++
    }
}
END{print c}')

if [[ "$low" -eq 3 ]]; then
  echo "$(date '+%F %T') ISP RX degradation detected" >> "$ALERT"
fi

