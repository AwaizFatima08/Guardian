#!/bin/bash
# ============================================================
# Guardian Step-4bB: Deterministic Organization Enrichment
# Bug-free, offline, SOC-style classification
# ============================================================

IN="$HOME/guardian/tls/quic_flows.log"
OUT="$HOME/guardian/tls/quic_flows_enriched.log"

[ -f "$IN" ] || exit 0

echo "window_start,src_ip,dst_ip,packets,total_bytes,organization" > "$OUT"

classify_org() {
  who=$(whois "$1" 2>/dev/null | tr '[:upper:]' '[:lower:]')

  case "$who" in
    *google*|*youtube*)      echo "Google" ;;
    *cloudflare*)            echo "Cloudflare" ;;
    *amazon*|*aws*)          echo "Amazon AWS" ;;
    *microsoft*|*azure*)     echo "Microsoft" ;;
    *facebook*|*meta*)       echo "Meta" ;;
    *netflix*)               echo "Netflix" ;;
    *apple*)                 echo "Apple" ;;
    *)                        echo "External" ;;
  esac
}

while IFS=',' read -r ts src dst pkts bytes; do
  [ "$ts" = "window_start" ] && continue
  org=$(classify_org "$dst")
  printf "%s,%s,%s,%s,%s,%s\n" "$ts" "$src" "$dst" "$pkts" "$bytes" "$org"
done < "$IN" >> "$OUT"

exit 0
