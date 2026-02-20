# 🛡️ Home NAS Guardian
## Project State Snapshot

**Phase:** 3 – Telemetry Stabilization Complete  
**Date:** 2026-02-19  
**Status:** Stable – Pre-Firewall Deployment  

---

# 1️⃣ Physical Network Topology (Pre-Firewall)

ISP Fiber  
↓  
Huawei HG8145V5 (WiFi Disabled)  
↓  
TP-Link Archer C24 (Router Mode)  
↓  
Home LAN  

### Notes
- Huawei operating as upstream GPON
- Archer currently routing + DHCP
- Static IP reservations configured on Archer
- All devices connect via Archer
- No dedicated firewall yet
- Firewall deployment planned (OPNsense)

---

# 2️⃣ Guardian Node Roles

## 🔵 SENSOR
- Machine: Dell Optiplex 980  
- OS: Debian 13  
- User: homi  
- Base Path: `/home/homi/guardian`

### Responsibilities
- Bandwidth telemetry (eno1)
- WAN latency & packet loss probe
- Host stability logging
- Heartbeat logging
- Legacy ISP sampling (active)

---

## 🟢 NAS
- Machine: Xeon E3 System  
- OS: Debian 12  
- User: humayun  
- Base Path: `/home/humayun/guardian`

### Responsibilities
- Device integrity monitoring
- Daily speedtest
- Throughput & latency legacy tests
- Host stability logging
- Heartbeat logging

---

# 3️⃣ Structured Telemetry Layer

## SENSOR → `/home/homi/guardian/raw/`

### bandwidth.csv
Format:
timestamp,interface,rx_mbps,tx_mbps,rx_drops,tx_drops,rx_errors,tx_errors  
Frequency: 1 minute  
Interface: eno1  

### wan_quality.csv
Format:
timestamp,avg_latency_ms,packet_loss_percent  
Frequency: 5 minutes  
Target: 8.8.8.8  

### host_status.csv
Format:
timestamp,hostname,uptime_seconds,boot_time,load_avg  
Frequency: 5 minutes  

### heartbeat.csv
Format:
timestamp,hostname,OK  
Frequency: 5 minutes  

---

## NAS → `/home/humayun/guardian/raw/`

### host_status.csv
Frequency: 5 minutes  

### heartbeat.csv
Frequency: 5 minutes  

---

# 4️⃣ Cron Configuration Summary

## SENSOR
- bandwidth_logger.sh (every minute)
- host_status.sh (every 5 minutes)
- wan_probe.sh (every 5 minutes)
- heartbeat.sh (every 5 minutes)
- Legacy ISP monitoring scripts

## NAS
- device_integrity.sh (every 15 minutes)
- speedtest-cli (03:00 daily)
- throughput test (every 30 minutes)
- latency test (every 5 minutes)
- host_status.sh (every 5 minutes)
- heartbeat.sh (every 5 minutes)

---

# 5️⃣ Stability Improvements Achieved

- Structured CSV logging
- Clear role separation (Sensor ≠ NAS)
- Interface error monitoring
- Restart detection capability
- Uptime tracking
- Packet loss tracking
- Latency baseline
- Silent script failure detection
- Clean directory hierarchy

---

# 6️⃣ Known Architectural Limitations

- No per-IP bandwidth accounting
- No shaping enforcement
- Double NAT (Huawei + Archer)
- No central policy engine
- No automated bandwidth control
- No gateway-level traffic analytics

Resolution planned in Phase 4.

---

# 7️⃣ Phase 4 – Firewall Deployment Plan

## Planned Topology

Huawei (Upstream Only)  
↓  
OPNsense Firewall  
↓  
Unmanaged Switch  
↓  
LAN + Archer (AP Mode)  

## Goals
- Single NAT
- Central DHCP
- Traffic Insight (per IP)
- Smart Queue (fq_codel / cake)
- Gateway monitoring
- Policy-based bandwidth control

---

# 8️⃣ ISP Status

- Plan: 30 Mbps  
- Observed: 20–25 Mbps stable  
- Upgrade to 50 Mbps: Deferred until post-firewall baseline

---

# 9️⃣ Guardian Maturity Index

- Telemetry Layer: ~75%  
- Control Layer: ~20%  
- Policy Engine: 0%  
- Firewall Integration: Pending  

**Overall System Maturity: ~60%**

---

# 🔒 Development Freeze Rule

Until firewall deployment:

Do NOT:
- Add new collectors
- Modify IP structure
- Add dashboards
- Implement shaping logic
- Change network topology

Collect clean telemetry baseline only.

---

# 🧭 Strategic Position

Guardian is:
- Structurally stable
- Logically separated
- Cleanly organized
- Ready for firewall integration

Next active development phase begins with firewall hardware availability.
