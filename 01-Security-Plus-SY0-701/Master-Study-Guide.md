---
title: "Security+ (SY0-701) Master Study Guide"
exam_code: "SY0-701"
duration: "8 Weeks (Weeks 17-24 of Master Plan)"
status: "active"
---

# CompTIA Security+ (SY0-701) Master Study Guide

## Purpose

This guide is the long-form landing page for Security+ study material stored in:
- `Resources-and-PDFs/` for books, exam objectives, whitepapers, and cheat sheets
- `OCR-Dumps/` for raw text extracted from PDFs, screenshots, and scanned notes

This guide bridges official CompTIA Security+ theory with practical, real-world infrastructure operations. The schedule is structured as an 8-week sprint, dedicating specific weeks to the heaviest exam domains.

---

## The 8-Week Study Sprint

### [ ] Weeks 17–19: Threats, Vulnerabilities, and Mitigations (Domain 2.0)
*Focus: Understanding attack vectors, cryptographic concepts, and availability threats.*

**Key Concepts to Master:**
* **Malware & Ransomware:** How lateral movement occurs across subnets if zero-trust is not enforced.
* **Cryptographic Protocols:** * Symmetric vs. Asymmetric encryption. 
    * Public Key Infrastructure (PKI) and TLS termination. When a reverse proxy (like Caddy on `ct-edge-01`) handles ACME DNS-01 challenges to secure `*.dayrose.me`, it relies on asymmetric cryptography to establish the session, then switches to a symmetric block cipher (like AES) for the actual data transit.
* **Availability as a Security Concept:** Security isn't just about hackers; the "A" in the CIA triad stands for Availability. Hardware failure is a primary security threat. 
    * *Practical Application:* An Inland QN450 NVMe accumulating 186 media errors and 38 unsafe shutdowns is a critical availability threat. Because it hosts 5 distinct virtualized services without continuous block-level replication, physical degradation directly compromises the integrity and availability of the entire hosted stack.

### [ ] Weeks 20–21: Security Architecture and IAM (Domains 3.0 & 5.0)
*Focus: Identity and Access Management, Zero-Trust, and Secure Network Design.*

**Key Concepts to Master:**
* **Federation and SSO (Single Sign-On):**
    * SAML vs. OIDC (OpenID Connect). 
    * *Practical Application:* A central Identity Provider (IdP) operating on a dedicated node (such as Authentik on `ct-control-01`) acts as the single source of truth. When an external service (like `omni.dayrose.me`) requests access, the reverse proxy utilizes forward-auth to force the user through the central IdP before any traffic reaches the backend container.
* **Secure Network Architecture:**
    * **Jump Servers & VPNs:** Using secure tunnels (like a Tailscale exit node routing `0.0.0.0/0`) rather than exposing SSH or RDP directly to the internet.
    * **DNS Sinkholing:** Intercepting malicious outbound requests at the network layer using dual-resolver configurations (primary and secondary Pi-holes) kept in parity via synchronization agents.
* **Least Privilege & RBAC (Role-Based Access Control):** Ensuring service accounts only have the exact permissions required to execute their specific daemon, nothing more.

### [ ] Weeks 22–23: Security Operations & Incident Response (Domain 4.0)
*Focus: The Incident Response Lifecycle and Disaster Recovery.*

*(See Domain 4.0 Deep Dive section below for detailed homelab analogies).*

### [ ] Week 24: Governance, Risk, and Compliance (GRC) & Final Review (Domain 1.0)
*Focus: Risk calculations, enterprise frameworks, and standard operating procedures.*

**Key Concepts to Master:**
* **Quantitative Risk Assessment Formulas:**
    * **SLE (Single Loss Expectancy):** The cost of one specific incident (e.g., the cost to replace one 1TB NVMe drive).
    * **ARO (Annualized Rate of Occurrence):** How many times you expect that failure to happen in one year.
    * **ALE (Annualized Loss Expectancy):** SLE × ARO = Your total expected financial loss per year for that specific risk.
* **Business Documents:**
    * **SLA (Service Level Agreement):** Defines strict uptime metrics and financial penalties.
    * **MOU (Memorandum of Understanding):** A formal agreement between two parties, but less legally binding than an SLA.
    * **NDA (Non-Disclosure Agreement):** Protects confidential data.
* **Control Types:** Memorize the difference between Preventive, Detective, Corrective, Deterrent, Compensating, and Physical controls.

---

## Domain 4.0 Deep Dive: Security Operations

Domain 4.0 focuses on the work of defending, monitoring, responding, recovering, and improving operations after security events. In practice, this domain is where policy turns into action.

### Objective 4.8: Explain Appropriate Incident Response Activities

The exam expects you to understand the standard incident response lifecycle and choose the best action for the situation. 

**Quick Memory Hooks:**
* **Preparation:** Be ready
* **Identification:** Prove it
* **Containment:** Stop spread
* **Eradication:** Remove cause
* **Recovery:** Restore trust
* **Lessons Learned:** Improve process

### Practical Analogies That Make The Cycle Stick

#### Scenario A: `node-auth-02` drops offline
*Observed facts: `node-auth-02` stops responding to ping, SSH is unavailable, Proxmox web UI on port `8006` is unavailable, and Cluster health falls to `2/3` quorum.*

1. **Preparation:** Having a current map of the three-node cluster, documented quorum expectations, and console access options before the outage occurs.
2. **Identification:** Confirming the node is actually down (not a browser issue), scoping which workloads are impacted, and verifying cluster membership is degraded.
3. **Containment:** Freezing nonessential cluster changes (like bulk backup sweeps) to prevent split-brain scenarios or further cluster damage.
4. **Eradication:** Replacing the failed PSU/NIC, correcting a bad network config, or repairing the corrupted boot device.
5. **Recovery:** Rejoining `node-auth-02` to the cluster carefully, validating quorum, and confirming ping/SSH/`8006` function normally.
6. **Lessons Learned:** Asking if alerts fired quickly enough, if out-of-band access worked, and updating the playbook.

#### Scenario B: `node-app-01` shows `186` media errors on an NVMe drive
*Observed facts: SMART telemetry reports `186` media errors. The host is running, but storage trust is degrading.*

1. **Preparation:** Storage health monitoring/alerting, and having a current inventory of guest workloads and tested live migration procedures.
2. **Identification:** Verifying the error count is increasing and scoping which datastores/guests depend on the drive.
3. **Containment:** Stopping placement of new workloads on `node-app-01` and migrating critical guests off the at-risk storage to limit the blast radius.
4. **Eradication:** Physically replacing the degrading Inland QN450 NVMe drive and rebuilding the datastore.
5. **Recovery:** Confirming the new drive is healthy and migrating guests back only when stability is proven.
6. **Lessons Learned:** Evaluating if SMART alerts were configured early enough and if migration priority matched business criticality.

---

## Suggested Resource Intake

**Drop items into `Resources-and-PDFs/` such as:**
- Official CompTIA exam objectives
- Incident response cheat sheets
- NIST-style lifecycle references
- SIEM, logging, and playbook notes

**Drop items into `OCR-Dumps/` such as:**
- OCR text from textbooks
- Raw notes from screenshots
- Exported terminal transcripts and incident timelines

---

### End of Sprint Action Items:
* [ ] Complete two full-length timed SY0-701 practice exams.
* [ ] Review the `\OCR-Dumps` and `\Resources-and-PDFs` folders using the Librarian Index for weak domains.
* [ ] Schedule official Pearson VUE exam.

---

## Free Resources

> Resources curated for an experienced homelab admin. GRC (Domain 5, 20% weight) is the primary knowledge gap — prioritize it explicitly.

### Official Exam Objectives

- **Exam Objectives PDF** — Download via form at: https://www.comptia.org/certifications/security#examdetails
  - File is `comptia-security-sy0-701-exam-objectives-2-0.pdf`. Save to `Resources-and-PDFs/`.
  - Domain weights: General Security Concepts 12% · Threats & Vulns 22% · Security Architecture 18% · Security Operations 28% · **GRC 20%**

### Top Community GitHub Repos

| Repo | Why it fits |
|---|---|
| [MaheshShukla1/CompTIA-Security-Plus-SY0-701-Notes-CheatSheet-Exam-Prep](https://github.com/MaheshShukla1/CompTIA-Security-Plus-SY0-701-Notes-CheatSheet-Exam-Prep) | Best SY0-701-specific repo: all 5 domains, NIST/ISO/CIS framework mappings (the exact frameworks GRC questions test), inline cheat sheet tables. The wiki has premium-quality guides. |
| [iProgrammer16/CompTIA-SecurityPlus-SY0-701-Notes-and-Cheatsheet](https://github.com/iProgrammer16/CompTIA-SecurityPlus-SY0-701-Notes-and-Cheatsheet) | Tightly anchored to official objectives — good for rapid domain-by-domain gap checks. |
| [bregman-arie/devops-exercises](https://github.com/bregman-arie/devops-exercises) | 81k+ stars. Security section has practical questions that bridge homelab ops to exam theory. |

### Cheat Sheets & Mind Maps

- **Professor Messer SY0-701 Study Notes** — free PDF per section at: https://www.professormesser.com/security-plus/sy0-701/
  - Download the notes PDF from each video page. Strong on Domain 4 (Operations) and Domain 5 (GRC).
- **MaheshShukla1 repo cheat sheets** (linked above) — particularly strong on cryptography and identity controls, two high-frequency exam areas.

### Free Video Courses

- **Professor Messer — SY0-701 Complete Course (free, YouTube)**
  - Playlist: https://www.youtube.com/playlist?list=PLG49S3nxzAnl4QDVqK-hOnoqcSKEIDDuv
  - The gold standard for free Security+ prep. Each video aligns directly to an exam objective. As a homelab admin, skip 1.1–1.3 and go straight to Domain 4 (Security Operations) and Domain 5 (GRC) — those are where your hands-on background stops covering you.