# Quizmaster Seeds — Security+ SY0-701

> This file is read by the Quizmaster agent to generate targeted quiz sessions.
> Each section specifies the domain, quiz format, focus areas, and homelab-anchored context for scenario questions.

---

## Domain 1 — General Security Concepts (12%)
- **Quiz type:** Flashcard
- **Focus:** CIA triad definitions and homelab examples; authentication factor types (know/have/are/where); control categories (preventive/detective/corrective/deterrent/compensating/directive); non-repudiation
- **Homelab context:** Ask student to categorize a described homelab control (e.g., "Caddy's forward-auth blocks unauthenticated requests" → which control type?)
- **Difficulty target:** Medium — this domain is mostly recall, not scenario analysis
- **Sample question types:**
  - "Which pillar of the CIA triad does TLS encryption primarily address?"
  - "A login banner warns users that all activity is monitored and logged. What type of control is this?"
  - "An organization requires a password AND a TOTP code to log in. What type of authentication is this, and why?"

---

## Domain 2 — Threats, Vulnerabilities & Mitigations (22%)
- **Quiz type:** Scenario
- **Focus:** Identify attack type from symptoms; choose correct mitigation; cryptography type selection; PKI components; certificate lifecycle
- **Homelab context:** Map to Caddy TLS, Authentik, Pi-hole DNS, and NVMe degradation scenarios from `domain2-crypto-and-threats-homelab-notes.md`
- **Difficulty target:** Hard — scenario questions require elimination, not recall
- **Sample question types:**
  - "A workstation begins connecting to an unfamiliar IP address on port 443 nightly at 3am. What type of malware behavior does this suggest?"
  - "An attacker captures an authentication token and replays it 10 minutes later to gain access. Which attack occurred, and what control prevents it?"
  - "A developer stores passwords by running them through SHA-256 before saving to the database. What is wrong with this approach?"
  - "During a TLS handshake, which type of cryptography is used to exchange the session key, and which type encrypts the session data?"
  - "A certificate's OCSP responder is unavailable. Which mechanism allows the web server to provide the certificate status without the client querying the CA directly?"

---

## Domain 3 — Security Architecture (18%)
- **Quiz type:** Scenario
- **Focus:** IAM protocol selection (SAML vs. OIDC vs. OAuth 2.0); network design tradeoffs (VPN types, DMZ, segmentation); access control models (RBAC vs. ABAC vs. MAC vs. DAC); firewall types
- **Homelab context:** Map to Authentik federation flows, Caddy forward-auth, Tailscale mesh, and Pi-hole DNS sinkholing from `domain3-iam-and-architecture-homelab-notes.md`
- **Difficulty target:** Hard — protocol selection questions are frequently the most missed on SY0-701
- **Sample question types:**
  - "A company needs to allow employees to use their corporate Active Directory credentials to log into a SaaS application. Which protocol is most appropriate?"
  - "A developer wants to allow a mobile app to post to a user's social media account without the user sharing their password with the app. Which framework enables this?"
  - "A security team implements a policy where access to the financial database is only allowed from company-issued devices between 8am and 6pm. Which access control model does this represent?"
  - "An organization places web servers in a network zone that is accessible from the internet but isolated from internal systems. What is this zone called?"
  - "A reverse proxy checks with an identity provider before forwarding each request to a backend service. Which security principle does this architecture implement?"

---

## Domain 4 — Security Operations (28%)
- **Quiz type:** IR lifecycle ordering + scenario analysis
- **Focus:** IR phase identification; which action belongs in which phase; forensic evidence handling (order of volatility, chain of custody); log analysis and SIEM concepts
- **Homelab context:** Use the three IR scenarios from `domain4-ir-scenarios-expanded.md` (quorum loss, NVMe degradation, Pi-hole config drift) as scenario bases
- **Difficulty target:** Hard — ordering questions and "what should happen next" questions are the most common Domain 4 format
- **Sample question types:**
  - "After confirming that a server has been compromised, the IT team immediately rebuilds it from a clean image. Which phase of the IR lifecycle have they skipped?"
  - "A forensic analyst arrives at a compromised workstation. In what order should they collect: running processes, RAM contents, hard drive image, system logs?"
  - "A Pi-hole resolver begins returning NXDOMAIN for all internal service names after an automated sync script ran. An analyst disables the sync script and removes ct-dns-02 from DHCP. Which IR phase does this represent?"
  - "After resolving an incident, a team documents that their monitoring system failed to detect the anomaly for 4 hours due to a misconfigured threshold. Which phase does this activity belong to, and what artifact should it produce?"
  - "Which control would have prevented an automated configuration script from overwriting production DNS settings without review?"

---

## Domain 5 — GRC (20%) — PRIORITY: HIGH
- **Quiz type:** Formula application + framework identification + document classification
- **Focus:** Calculate ALE from given SLE and ARO; identify which NIST CSF function an activity belongs to; match a scenario to the correct business document; identify control types in scenarios
- **Homelab context:** Use the NVMe failure and quorum loss scenarios for risk formula practice; use homelab controls for control type classification
- **Priority note:** This domain represents your largest knowledge gap. Weight quiz sessions here MORE than other domains. Target ≥75% before sitting the exam.
- **Difficulty target:** Medium (formulas are mechanical; framework matching is pattern recognition)
- **Sample question types:**
  - "A server has an asset value of $5,000. A ransomware infection has an exposure factor of 0.40 and is expected to occur once every two years. What is the ALE?"
  - "A security team creates an inventory of all company assets and maps potential threat sources to each. Which NIST CSF 2.0 function does this activity belong to?"
  - "Two organizations agree to share malware signatures informally, with no financial penalties for either party. Which document type governs this arrangement?"
  - "A company implements full-disk encryption on all laptops to protect data if devices are lost. What type of control is this, and which CIA pillar does it primarily protect?"
  - "Under GDPR, a user submits a request to have all personal data associated with their account permanently deleted. What right is the user exercising?"
  - "A cloud provider signs a document guaranteeing 99.95% monthly uptime and agreeing to issue service credits if this threshold is missed. What document type is this?"

---

## Quizmaster Session Configuration

### Recommended Session Formats

| Session type | Domains to cover | Questions | Timing |
|---|---|---|---|
| Domain gap drill | 5 only | 20 questions | 20 minutes |
| Full timed simulation | 1–5 all | 90 questions | 90 minutes |
| Weak domain remediation | Lowest scoring domain | 30 questions | 30 minutes |
| IR lifecycle drill | 4 only | 15 ordering scenarios | 15 minutes |
| GRC formula sprint | 5 only (formulas only) | 10 calculation problems | 15 minutes |

### Scoring Targets Before Scheduling Real Exam

- Domain 1: ≥80%
- Domain 2: ≥75%
- Domain 3: ≥75%
- Domain 4: ≥75%
- Domain 5: ≥75%
- Overall total: ≥80% on two consecutive full simulations
