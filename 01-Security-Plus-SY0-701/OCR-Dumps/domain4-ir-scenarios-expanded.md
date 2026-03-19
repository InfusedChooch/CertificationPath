---
domain: "4.0 — Security Operations"
exam_weight: "28% (heaviest domain)"
source: "Homelab-anchored notes — Winston Koh"
---

# Domain 4.0: Security Operations
## Expanded Incident Response Tabletop Exercises

> This document expands the IR lifecycle scenarios from `Master-Study-Guide.md` into full tabletop exercise format,
> adds a third scenario, and maps all phases explicitly to the six-step IR lifecycle.
> Each scenario is written to generate practice with the exact question style the SY0-701 uses for Domain 4.

---

## IR Lifecycle Reference

The CompTIA SY0-701 uses this six-phase lifecycle. Memorize the sequence — questions often ask "which phase comes next?" or "which phase does this action belong to?"

```
1. Preparation     → Build capability before incidents happen
2. Identification  → Detect and confirm an incident has occurred
3. Containment     → Stop the spread (short-term and long-term)
4. Eradication     → Remove the root cause
5. Recovery        → Restore to normal operation safely
6. Lessons Learned → Document, improve, prevent recurrence
```

**Quick memory hook:** **P I C E R L** — *People In Crisis Erase Records Later*

---

## Scenario A: `node-auth-02` Drops Offline (Cluster Quorum Loss)

### Context
`node-auth-02` (192.168.1.14) stops responding. SSH is unavailable. The Proxmox web UI on port 8006 is inaccessible from this node. Cluster quorum falls to 2/3.

### Phase-by-Phase IR Response

**Phase 1 — Preparation (done BEFORE the incident)**
- *What should exist:* A current network map showing which VMs and LXC containers run on which nodes
- *What should exist:* Documented quorum expectations (Proxmox's default: majority quorum, so 2/3 = still operational)
- *What should exist:* Out-of-band access to each node (IPMI/iDRAC, serial console, or physical access procedure documented)
- *What should exist:* Runbook entry: "node offline — check IPMI, SSH from other node, check Proxmox journal"
- *Self-assessment:* Is the runbook current? Is out-of-band access tested and functional?

**Phase 2 — Identification**
- *Detection trigger:* Alert from monitoring (Prometheus → Alertmanager → Grafana), or manual discovery
- *Confirm it's real:* Ping `node-auth-02` from another node. Attempt SSH. Check `pvecm status` on a healthy node.
  ```bash
  pvecm status          # Check quorum and member list
  pvecm nodes           # List all nodes and their status
  ```
- *Scope:* Which VMs are on `node-auth-02`? What is their current state? Are they migrated or suspended?
- *Classify:* Unplanned outage (hardware/OS failure) or possible security incident (external attack, unauthorized access)?

**Phase 3 — Containment**
- *Short-term:* Freeze nonessential cluster changes — do NOT attempt bulk migrations or snapshot jobs while quorum is degraded
- *Critical:* Do NOT force-kill quorum (`pvecm expected 1`) unless you have assessed split-brain risk
- *Protect remaining nodes:* Temporarily restrict management plane access (8006) to trusted IPs only
- *Logging:* Capture current `pvecm status` output, syslog from `node-app-01` and `node-auth-01` — preserve evidence

**Phase 4 — Eradication**
- *Diagnose root cause:*
  - PSU failure → replace hardware
  - Network config error → roll back config change
  - Corrupted boot device → NVMe/SSD failure → replace drive, rebuild Proxmox install
  - OS panic → review `/var/log/kern.log` on recovery
- *Once diagnosed:* Resolve the root cause before bringing the node back

**Phase 5 — Recovery**
- *Rejoin node carefully:*
  ```bash
  pvecm add <node-app-01-ip>   # rejoin cluster from node-auth-02
  pvecm status                 # confirm quorum restored to 3/3
  ```
- *Validate:* Ping all cluster members. Confirm all previously hosted VMs are running (or migrate them back)
- *Test:* Access web UI on all three nodes. Confirm storage mounts. Run a test VM snapshot.
- *Do NOT declare recovery complete* until all services are confirmed healthy

**Phase 6 — Lessons Learned**
- *Document:* When was the incident detected? How long to identify root cause? How long to recover?
- *Gaps:*
  - Did alerting fire promptly? (Detection gap)
  - Was out-of-band access functional? (Preparation gap)
  - Was a runbook available? (Preparation gap)
  - Did the cluster handle quorum degradation correctly? (Architecture question)
- *Improve:* Update runbook. Fix alerting threshold if detection was late. Consider IPMI configuration if not present.

### Exam Questions This Scenario Answers

- *"An administrator notices the cluster management interface is unreachable on one of three nodes. Which IR phase should they perform first?"* → Identification (confirm scope before acting)
- *"After confirming a node is offline, the admin begins migrating all VMs off the remaining nodes. What IR phase error is this?"* → Jumping to Recovery without completing Eradication (root cause not addressed)
- *"What is the primary goal of the containment phase?"* → Stop the spread/limit damage, NOT restore operations

---

## Scenario B: `node-app-01` NVMe Drive Accumulating Media Errors

### Context
SMART telemetry reports 186 media errors on the Inland QN450 NVMe in `node-app-01`. The host is running. Five guest VMs are on this datastore with no block-level replication.

### Phase-by-Phase IR Response

**Phase 1 — Preparation**
- *What should exist:* SMART monitoring configured (e.g., `smartd`, Proxmox storage health check)
- *What should exist:* Inventory of which VMs are on which physical storage devices
- *What should exist:* Tested procedure for live migration of VMs between nodes
- *What should exist:* Backup policy with tested restore capability
- *Self-assessment:* When were the 5 affected VMs last backed up? To where?

**Phase 2 — Identification**
- *Detection:* SMART alert threshold crossed. Or discovered manually via `smartctl -a /dev/nvme0`
  ```bash
  smartctl -a /dev/nvme0 | grep -i "media\|error\|unsafe"
  ```
- *Assess severity:*
  - 186 media errors = sectors with uncorrectable reads. **Not a trend to monitor — a signal to act now.**
  - 38 unsafe shutdowns = prior power loss events have degraded write consistency
- *Classify:* Hardware integrity failure. Availability + Integrity threat (CIA triad: both A and I affected)
- *Scope:* Identify all 5 VMs, their criticality, last backup timestamps, and current health

**Phase 3 — Containment**
- *Immediate:* Stop placing new VMs or increasing writes on this datastore
- *Freeze new snapshots* to this storage (a snapshot write to a degrading drive risks corruption)
- *Verify backup integrity:* Can you restore any of the 5 VMs from backup right now? Test one.
- *Communication:* If any hosted services have SLAs, notify stakeholders of elevated risk

**Phase 4 — Eradication**
- *Root cause:* Hardware degradation — the NVMe is failing
- *Action:* Procure replacement NVMe. Plan migration window.
- *Do NOT:* Attempt data recovery tools on a live degrading drive — increased reads may trigger more errors
- *After replacement:* Rebuild the datastore on the new drive. Verify health with SMART baseline.

**Phase 5 — Recovery**
- *Ordered migration* (do NOT rush):
  1. Live-migrate lowest-criticality VMs first (test the process)
  2. Migrate remaining VMs in order of business criticality
  3. Verify each VM post-migration (ping, application health, data integrity check)
- *Only after all VMs are off:* Take the old drive offline, physically remove it, label it (do NOT discard without secure wipe)
- *Restore test:* After migration, restore one VM from backup to a test node — confirm the backup was valid

**Phase 6 — Lessons Learned**
- Was SMART monitoring configured and alerting BEFORE the threshold was exceeded?
- What is the acceptable error threshold for triggering a migration? (Document this: "Media errors > 0 = investigate; > 50 = begin migration planning; > 100 = immediate migration required")
- Was there replication for any of these VMs? (If no: implement Proxmox scheduled replication to `node-auth-01`)
- Update the hardware lifecycle tracking document

---

## Scenario C: Pi-hole Config Drift Causes DNS Resolution Failures

### Context
After a config synchronization script runs, `ct-dns-02` (192.168.1.21) begins returning NXDOMAIN for internal service hostnames (e.g., `omni.dayrose.me`, `auth.dayrose.me`). Users report services are "down." The services themselves are running normally.

### Why This Is a Security Incident (Not Just an Operational Issue)
- **Availability attack**: DNS failure makes services unreachable — functionally equivalent to a DoS
- **Root cause is config integrity failure**: an automated process modified state in an unintended way — this is an integrity violation
- **Detection gap**: if monitoring is DNS-based, the monitoring itself may fail, creating a blind spot

### Phase-by-Phase IR Response

**Phase 1 — Preparation**
- *What should exist:* Configuration versioning for Pi-hole (pihole-FTL config files should be in a Git repo or tracked)
- *What should exist:* Health check that verifies DNS resolution of known internal names (not just that Pi-hole is running)
- *What should exist:* Documented rollback procedure for Pi-hole config
- *Self-assessment:* Can you diff the current running config against a known-good baseline?

**Phase 2 — Identification**
- *Detection trigger:* User reports, or (ideally) synthetic monitoring that resolves `auth.dayrose.me` every 60 seconds
- *Confirm and scope:*
  ```bash
  # From any host on the network:
  nslookup omni.dayrose.me 192.168.1.20   # Test ct-dns-01
  nslookup omni.dayrose.me 192.168.1.21   # Test ct-dns-02
  ```
- *Narrow the failure:* Is it both resolvers or one? Is it all domains or only internal ones?
- *Timestamp:* When did the sync script last run? Correlate with when failures started.

**Phase 3 — Containment**
- *Immediate:* Remove `ct-dns-02` from DHCP as the advertised DNS server — push only `ct-dns-01` until resolved
- *Disable the sync script* so it does not continue pushing the bad config
- *Preserve evidence:* Copy current `/etc/pihole/` config from `ct-dns-02` before making any changes

**Phase 4 — Eradication**
- *Root cause:* Sync script pushed a config that removed local DNS override entries (custom A records for internal services)
- *Fix:* Restore the custom DNS entries. Compare `ct-dns-02`'s config to `ct-dns-01` using diff
  ```bash
  diff /etc/pihole/custom.list.backup /etc/pihole/custom.list.current
  ```
- *Script review:* Identify what the sync script overwrites. Add the local DNS override file to the sync exclusion list.

**Phase 5 — Recovery**
- *Restore custom DNS entries* on `ct-dns-02`
- *Verify resolution:* Test all internal service names from multiple clients
- *Re-enable DHCP advertisement* of `ct-dns-02` once confirmed clean
- *Monitor for 30 minutes:* Confirm no recurrence before closing

**Phase 6 — Lessons Learned**
- The sync script lacked awareness of files that should not be overwritten. This is a **change management failure** — the script should have had a tested exclusion list.
- Monitoring was DNS-dependent — when DNS failed, some monitors also failed (blind spot). Add out-of-band monitoring that uses hardcoded IPs for health checks.
- **Change control:** Automated config management scripts should be tested in a staging context before running on production. This is **change management** — a Domain 5/GRC concept bleeding into operations.

### Exam Concepts This Scenario Tests

- *"A monitoring system shows all services are down. However, an admin who connects directly via IP finds the services are responsive. What is the most likely cause?"* → DNS failure (name resolution, not service failure)
- *"An automated script runs and causes service degradation. Which control would have prevented this?"* → Change management / change advisory board approval for automated config changes
- *"What type of attack does a failure that makes services unreachable most resemble?"* → Denial of Service (even if the root cause is internal/accidental — the impact is the same)

---

## IR Support Concepts — Forensics and Evidence

### Order of Volatility (memorize this sequence)

When collecting evidence, collect most volatile first — it disappears fastest:

1. CPU registers, cache
2. RAM (memory dump)
3. Running processes, network connections
4. Disk (swap, temp files)
5. Remote logging / SIEM
6. Physical media (HDD, NVMe)
7. Backup tapes / offline storage

**Exam question:** "An analyst discovers a compromised system. In what order should forensic data be collected?" → RAM before disk, always.

### Chain of Custody

Every piece of evidence must have documented:
- Who collected it
- When it was collected
- How it has been stored
- Who has had access since collection

Any gap = evidence may be inadmissible.

### Legal Hold

When litigation is anticipated, organizations must preserve all relevant data — including backups — and suspend normal deletion schedules. This applies to your homelab if you were running a business: snapshot policies that delete after 7 days would need to be suspended.

---

*See also: `domain5-grc-gap-notes.md` for the governance frameworks and risk formulas that support IR program design.*
