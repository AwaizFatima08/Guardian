#!/bin/bash
IN="$HOME/guardian/isp/rx_tx_1min.log"
OUT="$HOME/guardian/isp/isp_hourly.log"

[[ -f "$IN" ]] || exit 0

tail -n 60 "$IN" | awk -F, '
{
  rx+=$2; tx+=$3
  if($2>rxp) rxp=$2
  if($3>txp) txp=$3
}
END {
  printf "%s,avg_rx=%d,peak_rx=%d,avg_tx=%d,peak_tx=%d\n",
  strftime("%F %H:00"), rx/60, rxp, tx/60, txp
}' >> "$OUT"

