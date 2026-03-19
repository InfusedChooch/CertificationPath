---
domain: "5.0 — Security Program Management & Oversight (GRC)"
exam_weight: "20% — PRIMARY KNOWLEDGE GAP"
source: "Homelab-anchored notes — Winston Koh"
priority: "HIGH — no homelab substitute for this material"
---

# Domain 5.0: GRC — Governance, Risk & Compliance
## Study Notes for Your Primary Knowledge Gap

> This domain has almost no homelab equivalent. It is entirely about organizational policy, legal frameworks,
> risk quantification, and business documentation. The exam tests scenario recognition:
> given a description, identify the framework, formula, or document type.
> Memorize the structure; practice with scenarios.

---

## 5.1 Risk Quantification Formulas

These three formulas appear on nearly every SY0-701 attempt. You WILL get a calculation question.

### The Core Formulas

**SLE — Single Loss Expectancy**
> What does ONE occurrence of this incident cost?

```
SLE = Asset Value (AV) × Exposure Factor (EF)
```

- **Asset Value (AV):** What is the asset worth? (replacement cost, revenue impact, etc.)
- **Exposure Factor (EF):** What percentage of the asset's value is lost in one incident? (0.0 to 1.0)

---

**ARO — Annualized Rate of Occurrence**
> How many times per year do we expect this incident to happen?

```
ARO = Expected occurrences per year
```

- Can be a fraction: ARO = 0.25 means once every 4 years
- Based on historical data, threat intelligence, or industry statistics

---

**ALE — Annualized Loss Expectancy**
> What is our total expected loss from this risk over a year?

```
ALE = SLE × ARO
```

---

### Worked Examples Using Your Real Hardware Costs

**Example 1: NVMe Drive Failure on `node-app-01`**

| Parameter | Value |
|---|---|
| Asset: 1TB NVMe (Inland QN450) | $80 (replacement cost) |
| Exposure Factor | 1.0 (full drive fails = full replacement + 4 hrs labor) |
| Labor cost (4 hrs at $50/hr) | $200 |
| **Asset Value (AV)** | **$280 total cost per event** |
| ARO (SSDs fail at ~1% annually; but this drive is already degrading: estimate 1/yr) | **1.0** |

```
SLE = $280 × 1.0 = $280
ARO = 1.0
ALE = $280 × 1.0 = $280/year
```

**Exam application:** If someone offers a hardware replacement/monitoring service for $150/year, is it worth it?
```
ALE Before (without control) = $280
Cost of control = $150
ALE After (with control, assume 80% risk reduction) = $280 × 0.20 = $56

Value = ALE_before - ALE_after - Cost_of_control
Value = $280 - $56 - $150 = $74 net benefit → YES, implement the control
```

---

**Example 2: Service Outage from Quorum Loss (Revenue Impact)**

Suppose you host a service that generates $500/hour in revenue, and a quorum loss event causes 2 hours of downtime:

| Parameter | Value |
|---|---|
| Asset Value (2 hrs lost revenue) | $1,000 |
| Exposure Factor | 1.0 (all revenue stops during outage) |
| ARO (historically 2 cluster events/year) | 2.0 |

```
SLE = $1,000 × 1.0 = $1,000
ALE = $1,000 × 2.0 = $2,000/year
```

A high-availability solution costing $800/year that prevents 90% of outages:
```
ALE_after = $2,000 × 0.10 = $200
Value = $2,000 - $200 - $800 = $1,000 net benefit → Worth it
```

---

### Risk Response Strategies (not just formulas)

| Strategy | Description | When to Use |
|---|---|---|
| **Avoid** | Eliminate the activity that creates the risk | Risk is too high and activity isn't essential |
| **Transfer** | Shift financial impact (insurance, SLA, third party) | Risk is high but can't be eliminated |
| **Mitigate** | Implement controls to reduce likelihood or impact | Most common — reduce to acceptable level |
| **Accept** | Acknowledge risk and do nothing | Risk is within tolerance; cost of control exceeds ALE |

**Residual risk:** The risk that remains AFTER controls are applied. You can never reach zero risk.
**Inherent risk:** The risk before any controls are applied.

---

## 5.2 Governance Frameworks

The exam tests: given a description, identify which framework applies. Learn each framework's PURPOSE, not just its name.

### NIST Cybersecurity Framework (CSF) 2.0

**Purpose:** Voluntary framework for organizations to manage and reduce cybersecurity risk. Widely adopted in the US. The SY0-701 tests this framework more than any other.

**Six Core Functions (CSF 2.0 adds "Govern" as the first function):**

| Function | What It Covers | Your Homelab Analog |
|---|---|---|
| **Govern** | Policies, roles, risk strategy, supply chain risk (NEW in CSF 2.0) | Documenting your security policy; defining who is responsible for what |
| **Identify** | Asset inventory, risk assessment, data classification | Your infrastructure map, AGENTS.md, network diagrams |
| **Protect** | Access control, training, data security, maintenance | Authentik SSO, Caddy TLS, Pi-hole, firewall rules |
| **Detect** | Continuous monitoring, anomaly detection | Prometheus + Grafana, SMART monitoring, log aggregation |
| **Respond** | IR planning, communications, analysis, mitigation | Your IR runbooks (Scenarios A, B, C above) |
| **Recover** | Recovery planning, improvements, communications | Backup/restore procedures, cluster rebuild runbooks |

**Exam pattern:** A scenario describes an activity. Which NIST CSF function does it belong to?
- "A company creates an inventory of all servers and their owners" → **Identify**
- "An organization deploys MFA on all admin accounts" → **Protect**
- "After an incident, a team reviews what went wrong and updates the playbook" → **Recover** (not Lessons Learned — that's the IR lifecycle; Recover in NIST is broader)
- "A new policy requires all vendors to submit security assessments" → **Govern**

---

### ISO/IEC 27001

**Purpose:** International standard for Information Security Management Systems (ISMS). Organizations get **certified** to ISO 27001. It is audited and certified by third parties — unlike NIST CSF which is self-assessed.

**Key concept:** ISO 27001 defines *what* you must manage; Annex A defines *controls* (114 controls across 14 domains in 27001:2013; revised to 93 controls in 27001:2022).

**Exam contrast with NIST CSF:**
- NIST CSF = voluntary, US-focused, no certification, flexible
- ISO 27001 = international, certification-based, requires formal audit, more prescriptive

---

### CIS Controls (CIS Critical Security Controls)

**Purpose:** Practical, prioritized set of security actions. Not a framework for managing a program — a checklist of specific technical controls, ordered by impact.

**Three implementation groups:**
- **IG1:** Basic cyber hygiene — for all organizations. ~56 safeguards
- **IG2:** IG1 + controls for organizations with more risk exposure
- **IG3:** IG1 + IG2 + controls for critical/high-risk organizations

**Most-tested CIS Controls by number:**
- CIS Control 1: Inventory of hardware assets
- CIS Control 2: Inventory of software assets
- CIS Control 3: Data protection
- CIS Control 5: Account management
- CIS Control 6: Access control management

**Exam contrast:** CIS Controls are tactical (specific actions). NIST CSF is strategic (functions and outcomes). ISO 27001 is structural (management system requirements).

---

### Other Frameworks to Know

| Framework | Domain | Key Point |
|---|---|---|
| **SOC 2** | Audit/compliance | AICPA standard. Service organizations prove controls over security, availability, processing integrity, confidentiality, privacy. Two types: Type I (point-in-time), Type II (over a period). |
| **PCI-DSS** | Payment card industry | Mandatory if you handle payment card data. 12 requirements. Quarterly vulnerability scans, annual penetration test. |
| **HIPAA** | Healthcare | US law protecting Protected Health Information (PHI). Requires Security Rule (technical safeguards), Privacy Rule (use/disclosure), Breach Notification Rule. |
| **GDPR** | Privacy (EU) | EU law. Applies to anyone processing EU residents' data. 72-hour breach notification. Right to erasure. Data Protection Officer (DPO) required in some cases. |
| **FISMA** | US federal government | Requires federal agencies to implement NIST SP 800-series controls. ATO (Authority to Operate) process. |

---

## 5.3 Business and Legal Documents

**These are tested through scenario recognition — a question describes a situation, you identify the document.**

| Document | What It Is | Key Differentiator |
|---|---|---|
| **SLA** (Service Level Agreement) | Defines measurable service commitments (uptime %, response time) with financial penalties for non-compliance | Legally binding, quantified metrics, penalties |
| **MOU** (Memorandum of Understanding) | Formal agreement of intent between parties — less legally binding than a contract | No financial penalties; outlines shared goals, not specific metrics |
| **MSA** (Master Service Agreement) | Overarching contract governing the relationship; specific work orders or SOWs hang off it | The "master" — governs how future specific agreements work |
| **SOW** (Statement of Work) | Specific deliverables, timelines, and costs for a specific engagement | Child of MSA; specific not general |
| **NDA** (Non-Disclosure Agreement) | Legally binds parties not to disclose confidential information | Confidentiality; can be one-way or mutual |
| **BPA** (Business Partnership Agreement) | Governs an ongoing business relationship | Broader than MSA; covers profit sharing, decision-making, dispute resolution |

**Exam scenario examples:**
- *"Two companies agree to share threat intelligence but neither wants to create legal obligations"* → MOU
- *"A cloud provider guarantees 99.9% uptime and must pay credits if they miss it"* → SLA
- *"Before sharing their network architecture with a vendor, a company requires a signed agreement ensuring confidentiality"* → NDA

---

## 5.4 Security Control Types

**Two classification dimensions:** What the control does (category) vs. when it acts (timing).

### By Category

| Category | Description | Examples |
|---|---|---|
| **Technical** | Implemented in hardware or software | Firewall, MFA, encryption, IDS |
| **Administrative** | Policies, procedures, training | Security policy, acceptable use policy, awareness training, background checks |
| **Physical** | Tangible, physical-world controls | Locks, badges, cameras, fences, guards |

### By Timing (Function)

| Type | When it acts | What it does | Examples |
|---|---|---|---|
| **Preventive** | Before the event | Stops the incident from happening | Firewall rules, MFA, locks, encryption |
| **Detective** | During/after | Identifies that an incident occurred | IDS, SIEM, audit logs, cameras (recording) |
| **Corrective** | After | Reduces impact / restores state | Incident response, patch management, backup restore |
| **Deterrent** | Before | Discourages threat actors | Warning signs, visible cameras, legal notices |
| **Compensating** | When primary control is unavailable | Provides equivalent protection | Using MFA when biometrics are broken |
| **Directive** | Before | Specifies required behavior | Policies, procedures, regulations |

**Homelab examples for each type:**

| Control Type | Your Homelab Example |
|---|---|
| Preventive | Caddy forward-auth blocks unauthenticated requests |
| Detective | Prometheus alert fires when a node goes offline |
| Corrective | Restoring a VM from backup after a storage failure |
| Deterrent | Login page that displays "unauthorized access is monitored and logged" |
| Compensating | Using SSH key auth as MFA substitute when Authentik is temporarily unavailable |
| Directive | Your documented policy: "all admin tasks must use sudo, never root login" |

**Exam pattern:** Questions give a scenario and ask which type of control it is. Always identify the *timing* first (before/during/after), then the *category* (technical/admin/physical).

---

## 5.5 Data Classification and Roles

### Classification Levels

**Government:**
- Top Secret > Secret > Confidential > Unclassified

**Commercial (most common on exam):**
- Restricted/Confidential > Internal/Private > Public

### Data Roles

| Role | Responsibility |
|---|---|
| **Data Owner** | Senior leader accountable for the data. Defines classification and authorized uses. NOT the person managing it. |
| **Data Custodian** | IT or security team member who implements and maintains controls the owner requires. Manages storage, backups, access controls. |
| **Data Processor** | Third party that processes data on behalf of the data controller (GDPR concept). |
| **Data Subject** | The individual whose personal data is being processed (GDPR concept). |
| **Data Steward** | Responsible for data quality and governance. Bridges business and IT. |

**Exam trap:** The **Data Owner** is a business role (VP, Director) — NOT the DBA or sysadmin. The DBA is the **Data Custodian**. If a question asks "who is responsible for classifying customer data?", the answer is Data Owner, not IT.

**Homelab mapping:**
- You are simultaneously the Data Owner (you define the policy), Data Custodian (you manage the storage and backups on TrueNAS), and Data Processor (you run the infrastructure).
- In a real organization, these roles are separated.

---

## 5.6 Privacy Concepts (Domain 5 Overlap with Legal)

| Concept | Definition |
|---|---|
| **PII** (Personally Identifiable Information) | Any data that can identify an individual (name, SSN, email, IP address in GDPR context) |
| **PHI** (Protected Health Information) | PII related to health status or healthcare — covered by HIPAA |
| **Data minimization** | Only collect what is necessary for the stated purpose — GDPR principle |
| **Purpose limitation** | Data collected for one purpose cannot be used for another without consent — GDPR |
| **Right to erasure** ("right to be forgotten") | GDPR: individuals can request deletion of their data |
| **Data sovereignty** | Data is subject to the laws of the country where it is stored — important for cloud |
| **Privacy by design** | Build privacy controls into systems from the start, not as an afterthought |

---

*This document covers your primary gap. Pair with the NIST CSF 2.0 PDF (in Resources-and-PDFs) for the official framework language.*
*Practice: After reading each section, close the file and write down the formula, framework structure, or document distinction from memory. GRC is retention-heavy.*
