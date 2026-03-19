---
title: "Security+ SY0-701 — Folder Build-Out Plan"
folder: "01-Security-Plus-SY0-701"
created: "2026-03-19"
status: "active"
---

# Security+ (SY0-701) — Folder Build-Out Plan

This document is the actionable roadmap for fleshing out `01-Security-Plus-SY0-701` from its current skeleton state into a fully populated, exam-ready study module.

Work is organized into three parallel tracks. Run them in sequence — Track 1 first so the Librarian has something to index before Tracks 2 and 3 produce new files.

---

## Current State Snapshot

| Item | Status |
|---|---|
| `Master-Study-Guide.md` | ✅ Strong — Domains 2, 3, 4 covered with homelab analogies |
| `Resources-and-PDFs/` | ❌ Empty — nothing indexed yet |
| `OCR-Dumps/` | ❌ Empty — no homelab-anchored notes authored yet |
| Domain 1.0 coverage | ⚠️ Missing — no dedicated section in Master Study Guide |
| Domain 5.0 / GRC coverage | ⚠️ Thin — flagged as primary gap, only a bullet list |
| Practice exam strategy | ⚠️ Missing — no guidance on sources, scoring, or remediation |
| Quizmaster enablement | ⚠️ No seed file — Quizmaster has thin material outside Domain 4 |
| `deep-research-report.md` | ⚠️ Sitting at repo root, not integrated into cert folder |

---

## Track 1 — Resource Intake

**Goal:** Populate `Resources-and-PDFs/` so the Librarian agent has real content to index.  
**Dependency:** Must be done before running `Update-Index.ps1`.

### 1.1 — Priority Downloads for `Resources-and-PDFs/`

| File to save | Source | Notes |
|---|---|---|
| `comptia-security-sy0-701-exam-objectives-2-0.pdf` | https://www.comptia.org/certifications/security#examdetails (form download) | Ground truth — everything maps to this |
| `professor-messer-sy0-701-notes.pdf` | https://www.professormesser.com/security-plus/sy0-701/ (one PDF per section) | Free, high signal, strong on Domains 4 & 5 |
| `mahesh-shukla-sy0-701-cheatsheet.pdf` | https://github.com/MaheshShukla1/CompTIA-Security-Plus-SY0-701-Notes-CheatSheet-Exam-Prep | Strong on cryptography and IAM — your two hardest areas |
| `nist-csf-2-0.pdf` | https://nvlpubs.nist.gov/nistpubs/CSWP/NIST.CSWP.29.pdf | GRC domain tests NIST CSF directly |
| `iprogrammer-sy0-701-notes.pdf` | https://github.com/iProgrammer16/CompTIA-SecurityPlus-SY0-701-Notes-and-Cheatsheet | Tightly anchored to objectives — good for domain gap checks |

### 1.2 — After Downloading

- [ ] Drop all files into `Resources-and-PDFs/`
- [ ] Run `Update-Index.ps1` from the repo root
- [ ] Confirm `Resource-Index.md` shows the new files under `01-Security-Plus-SY0-701`

---

## Track 2 — OCR-Dumps Authoring

**Goal:** Create homelab-anchored notes that map your real infrastructure to exam objectives.  
These are not downloads — they are authored files written in your own words.  
**Dependency:** Can run in parallel with Track 1.

### 2.1 — `domain2-crypto-and-threats-homelab-notes.md`

**Domain 2.0 — Threats, Vulnerabilities & Mitigations (22% of exam)**

Content to cover:
- Symmetric vs. asymmetric encryption, mapped to how Caddy handles ACME DNS-01 challenges for `*.dayrose.me`
- PKI and TLS termination — what actually happens when the reverse proxy negotiates a session
- Lateral movement across subnets — what stops it in your current VLAN/firewall setup vs. what wouldn't
- Availability as a security concept — the NVMe media error scenario as a live CIA triad case study

### 2.2 — `domain3-iam-and-architecture-homelab-notes.md`

**Domain 3.0 — Security Architecture (18% of exam)**

Content to cover:
- SAML vs. OIDC — how Authentik on `ct-control-01` implements each and when it uses which
- Forward-auth flow — step-by-step what happens when a request hits the reverse proxy before reaching a backend container
- Jump servers and VPNs — Tailscale exit node routing `0.0.0.0/0` vs. direct SSH exposure
- DNS sinkholing — dual Pi-hole setup mapped to the exam concept
- Least privilege and RBAC — service account scoping in your container stack

### 2.3 — `domain4-ir-scenarios-expanded.md`

**Domain 4.0 — Security Operations (28% of exam)**

Content to cover:
- Expand the `node-auth-02` quorum loss scenario (already in Master Study Guide) into a full tabletop exercise format
- Expand the NVMe media error scenario into a formal IR report template
- Add a third scenario: a Pi-hole config drift event causing DNS resolution failures across the cluster
- Map each scenario explicitly to the six IR lifecycle phases: Preparation → Identification → Containment → Eradication → Recovery → Lessons Learned

### 2.4 — `domain5-grc-gap-notes.md`

**Domain 5.0 / GRC — your primary knowledge gap (20% of exam)**

Content to cover:
- **Risk formulas:** SLE, ARO, ALE — worked examples using your actual hardware costs
  - Example: cost of one NVMe replacement × expected failure rate = ALE
- **Frameworks to memorize:** NIST CSF (Identify/Protect/Detect/Respond/Recover), ISO 27001, CIS Controls — what each is used for and how exam questions test them
- **Business documents:** SLA, MOU, NDA, BPA, MSA — definitions and key differentiators
- **Control types:** Preventive, Detective, Corrective, Deterrent, Compensating, Physical — with a one-line homelab example for each
- **Data roles:** Data owner, data custodian, data processor, data subject — and how they map to your current setup

---

## Track 3 — Master Study Guide Expansion

**Goal:** Fill the three documented gaps in `Master-Study-Guide.md`.  
**Dependency:** Complete Track 2 first — the OCR-Dump files inform what belongs here.

### 3.1 — Add Domain 1.0 Section

**Domain 1.0 — General Security Concepts (12% of exam)**

Insert a new section before the 8-Week Sprint. Should cover:
- CIA triad (Confidentiality, Integrity, Availability) — with homelab examples for each pillar
- Authentication factors: something you know / have / are / somewhere you are
- Non-repudiation and its role in audit logging
- Gap-flag: this domain is mostly definitional — a cheat sheet is more useful than deep notes

### 3.2 — Add GRC Deep-Dive Section

Comparable in depth to the existing Domain 4 IR Lifecycle section.

Insert after the current Week 24 bullet list. Should cover:
- NIST CSF function-by-function breakdown with homelab mappings
- Risk formula worked examples (pulled from `domain5-grc-gap-notes.md`)
- Business document comparison table
- Control type comparison table
- Exam-specific callout: GRC questions are almost always scenario-based — practice recognizing which framework or formula a scenario is invoking, not just memorizing definitions

### 3.3 — Add Practice Exam Strategy Section

Insert at the end of the guide, after the Sprint Action Items checklist.

Should cover:
- **Recommended sources:** Jason Dion (Udemy), Professor Messer practice exams, ExamCompass (free), CompTIA official practice tests
- **Scoring methodology:** After each timed exam, score by domain — not just total. Track which of the 5 domains is pulling your average down.
- **Remediation loop:** Any domain below 75% on practice → go back to the corresponding OCR-Dump notes and Resource PDF before retesting
- **Timing discipline:** 90 questions in 90 minutes. Flag and skip anything over 90 seconds. Return to flagged items after completing the rest.
- **PBQ strategy:** Performance-based questions appear first. Do not spend more than 3 minutes on any single PBQ during a first pass — mark it and come back.

---

## Track 4 — Integration and Quizmaster Enablement

**Goal:** Connect the `deep-research-report.md` content and create a seed file for the Quizmaster agent.  
**Dependency:** Tracks 1–3 complete.

### 4.1 — Absorb `deep-research-report.md`

The report's Security+ content (voucher pricing, study hour estimates, resource pros/cons) belongs in the Master Study Guide, not at the repo root. Extract and integrate:
- Exam format details (90 questions, 90 min, 750/900 passing score) → add to the guide header or a new "Exam Logistics" section
- Voucher pricing and retake policy → add to the guide's Sprint Action Items section
- Resource pros/cons table → merge into the Free Resources section

Do not delete `deep-research-report.md` from the root — it serves the broader repo. Copy relevant excerpts only.

### 4.2 — Create `Quizmaster-Seeds.md`

Create a new file in `01-Security-Plus-SY0-701/` that the Quizmaster agent reads to generate targeted quizzes.

Structure:

```
# Quizmaster Seeds — Security+ SY0-701

## Domain 1 — General Security Concepts
- Quiz type: flashcard
- Focus: CIA triad definitions, authentication factor types, control categories

## Domain 2 — Threats, Vulnerabilities & Mitigations
- Quiz type: scenario
- Focus: Identify attack type from symptoms; choose correct mitigation

## Domain 3 — Security Architecture
- Quiz type: scenario
- Focus: IAM protocol selection (SAML vs OIDC); network design tradeoffs

## Domain 4 — Security Operations
- Quiz type: IR lifecycle ordering
- Focus: Given a scenario, identify the correct IR phase and next action

## Domain 5 — GRC
- Quiz type: formula application + framework identification
- Focus: Calculate ALE from given SLE/ARO; match scenario to NIST CSF function
- Priority: HIGH — primary knowledge gap, weight 20%
```

### 4.3 — Final Index Refresh

- [ ] Run `Update-Index.ps1` one final time
- [ ] Confirm all new files appear under `01-Security-Plus-SY0-701` in `Resource-Index.md`
- [ ] Review index output against this plan's file list — any missing files = incomplete track

---

## Sequencing Summary

```
Week 1
├── Track 1: Download all Resources-and-PDFs items
├── Track 1: Run Update-Index.ps1 — confirm Librarian sees them
├── Track 2: Author domain2-crypto-and-threats-homelab-notes.md
└── Track 2: Author domain3-iam-and-architecture-homelab-notes.md

Week 2
├── Track 2: Author domain4-ir-scenarios-expanded.md
├── Track 2: Author domain5-grc-gap-notes.md
├── Track 3: Add Domain 1.0 section to Master Study Guide
└── Track 3: Add GRC deep-dive section to Master Study Guide

Week 3
├── Track 3: Add practice exam strategy section to Master Study Guide
├── Track 4: Extract and integrate deep-research-report.md excerpts
├── Track 4: Create Quizmaster-Seeds.md
└── Track 4: Final index refresh + review pass
```

---

## Completion Checklist

### Track 1 — Resource Intake
- [ ] `comptia-security-sy0-701-exam-objectives-2-0.pdf` saved to `Resources-and-PDFs/`
- [ ] `professor-messer-sy0-701-notes.pdf` saved to `Resources-and-PDFs/`
- [ ] `mahesh-shukla-sy0-701-cheatsheet.pdf` saved to `Resources-and-PDFs/`
- [ ] `nist-csf-2-0.pdf` saved to `Resources-and-PDFs/`
- [ ] `iprogrammer-sy0-701-notes.pdf` saved to `Resources-and-PDFs/`
- [ ] `Update-Index.ps1` run and `Resource-Index.md` confirmed updated

### Track 2 — OCR-Dumps
- [ ] `domain2-crypto-and-threats-homelab-notes.md` created in `OCR-Dumps/`
- [ ] `domain3-iam-and-architecture-homelab-notes.md` created in `OCR-Dumps/`
- [ ] `domain4-ir-scenarios-expanded.md` created in `OCR-Dumps/`
- [ ] `domain5-grc-gap-notes.md` created in `OCR-Dumps/`

### Track 3 — Master Study Guide
- [ ] Domain 1.0 section added
- [ ] GRC deep-dive section added
- [ ] Practice exam strategy section added

### Track 4 — Integration
- [ ] `deep-research-report.md` excerpts integrated into Master Study Guide
- [ ] `Quizmaster-Seeds.md` created
- [ ] Final `Update-Index.ps1` run confirmed clean

---

*Drop this file in `01-Security-Plus-SY0-701/` alongside `Master-Study-Guide.md`. Update checkboxes as work completes.*