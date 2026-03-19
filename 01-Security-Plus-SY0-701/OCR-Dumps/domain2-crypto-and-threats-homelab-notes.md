---
domain: "2.0 — Threats, Vulnerabilities & Mitigations"
exam_weight: "22%"
source: "Homelab-anchored notes — Winston Koh"
---

# Domain 2.0: Threats, Vulnerabilities & Mitigations
## Homelab-Anchored Study Notes

> These notes map real infrastructure from the GHL homelab to Security+ exam objectives.
> The goal is not to restate definitions but to anchor abstract concepts to things you have already built and operated.

---

## 2.1 Cryptography — Symmetric vs. Asymmetric

### The Core Distinction

| | Symmetric | Asymmetric |
|---|---|---|
| **Keys** | One shared secret key | Public key (encrypt/verify) + Private key (decrypt/sign) |
| **Speed** | Fast — good for bulk data | Slow — good for key exchange and signatures |
| **Examples** | AES-128, AES-256, ChaCha20 | RSA, ECDSA, Diffie-Hellman |
| **Problem it solves** | Encrypting data at rest and in transit (after key exchange) | Establishing trust and exchanging symmetric keys securely |

### Real Mapping: How Caddy Secures `*.dayrose.me`

Your reverse proxy on `ct-edge-01` uses ACME DNS-01 challenges to obtain TLS certificates for `*.dayrose.me` via Let's Encrypt. Here is what happens cryptographically at each step:

**Step 1 — Identity verification (asymmetric)**
- Caddy generates an ECDSA keypair. The public key is registered with Let's Encrypt.
- During the DNS-01 challenge, Caddy proves it controls the domain by placing a TXT record in `dayrose.me` DNS and signing the proof with its private key.
- Let's Encrypt verifies the signature with the known public key. No shared secret involved — this is asymmetric cryptography proving identity.

**Step 2 — Certificate issuance (asymmetric)**
- Let's Encrypt signs the TLS certificate with its own private key (this is PKI — the cert is a signed assertion of identity).
- The browser trusts it because Let's Encrypt's public key is in the browser's trust store.

**Step 3 — TLS handshake (asymmetric → symmetric handoff)**
- Client connects to `ct-edge-01`. During the TLS 1.3 handshake:
  - Both sides exchange ephemeral keys using ECDHE (Elliptic Curve Diffie-Hellman Ephemeral)
  - This establishes a shared symmetric session key that neither side transmitted over the wire
- **After the handshake, all data is encrypted with AES-256-GCM** (symmetric) — fast, efficient

**Exam insight:** TLS does not pick one or the other. It uses asymmetric crypto to authenticate and establish a symmetric key, then symmetric crypto for everything after. Questions that ask "what type of encryption does HTTPS use?" should trigger this mental model.

### Block Ciphers and Modes (tested on SY0-701)

| Mode | Description | Exam Flag |
|---|---|---|
| **ECB** | Each block encrypted independently — identical plaintext = identical ciphertext | **Insecure** — never use |
| **CBC** | Each block XOR'd with previous ciphertext before encryption | Requires IV; vulnerable to padding oracle if implemented badly |
| **CTR** | Block cipher used as stream cipher with counter | Parallelizable, good for random access |
| **GCM** | CTR + authentication tag | **TLS 1.3 standard** — provides confidentiality AND integrity |

### Hashing vs. Encryption

| | Hashing | Encryption |
|---|---|---|
| **Reversible?** | No | Yes (with key) |
| **Purpose** | Integrity verification | Confidentiality |
| **Examples** | SHA-256, SHA-3, bcrypt | AES, RSA, ChaCha20 |
| **Use case** | Password storage, file integrity, digital signatures | Data at rest, data in transit |

**Exam trap:** Hashing is NOT encryption. A hash cannot be decrypted. If a question says "protect stored passwords from being recovered even if the DB is stolen," the answer is hashing (with salt), not encryption.

---

## 2.2 PKI and Digital Certificates

### The Trust Chain

```
Root CA (self-signed)
  └── Intermediate CA (signed by Root)
       └── Leaf Certificate (signed by Intermediate) ← your *.dayrose.me cert
```

- **Root CAs**: pre-installed in browsers/OSes. Let's Encrypt, DigiCert, Comodo, etc.
- **Intermediate CAs**: real-world CAs sign leaf certs from an intermediate, keeping the root offline
- **Chain of trust**: if you trust the root and can verify the signature chain, you trust the leaf

### Certificate Components (know these cold)

| Field | What it contains |
|---|---|
| **Subject** | Who the cert is for (CN, SAN — Subject Alternative Name) |
| **Issuer** | Who signed it (the CA) |
| **Public Key** | The cert holder's public key |
| **Validity period** | Not Before / Not After |
| **Serial number** | Unique ID — used in CRL and OCSP |
| **Signature** | CA's signature over everything above |
| **Extensions** | Key Usage, Extended Key Usage, SAN, Basic Constraints |

### Certificate Revocation

| Method | How it works | Problem |
|---|---|---|
| **CRL** (Certificate Revocation List) | Client downloads a list of revoked serial numbers | Lists get large; client must cache/refresh |
| **OCSP** (Online Certificate Status Protocol) | Client queries CA's OCSP responder in real-time | Privacy concern — CA sees every domain you visit |
| **OCSP Stapling** | Server attaches a pre-fetched OCSP response to the TLS handshake | Fixes privacy issue; Caddy supports this natively |

**Your homelab relevance:** Caddy handles OCSP stapling automatically for the `*.dayrose.me` cert. When a client connects, Caddy provides the OCSP response cached from Let's Encrypt — the client never queries Let's Encrypt directly.

---

## 2.3 Threat Actors and Attack Vectors

### Threat Actor Types (SY0-701 objective 2.1)

| Actor | Motivation | Sophistication | Resources |
|---|---|---|---|
| **Nation-state** | Espionage, sabotage, IP theft | Very high (APT) | Unlimited |
| **Organized crime** | Financial gain | High | Significant |
| **Hacktivist** | Ideology, publicity | Moderate | Variable |
| **Insider threat** | Disgruntled, coerced, or negligent | Context-dependent | Internal access |
| **Script kiddie** | Curiosity, notoriety | Low | Public tools |
| **Shadow IT** | Convenience (not malicious intent) | N/A | Internal |

### Attack Surfaces Relevant to Your Infrastructure

Your homelab exposes a non-trivial attack surface. Mapping each to exam concepts:

| Homelab Component | Attack Surface | Exam Concept |
|---|---|---|
| `ct-edge-01` (Caddy on 443/80) | Public-facing reverse proxy | Network attack vector, input validation, WAF |
| Authentik on `ct-control-01` | SSO/IdP — high-value target | Credential stuffing, session hijacking, OAuth token theft |
| Tailscale WireGuard mesh | VPN mesh | Key compromise, rogue device enrollment |
| Pi-hole DNS (ct-dns-01/02) | DNS resolver | DNS poisoning, BGP hijacking (upstream) |
| Proxmox web UI on 8006 | Management plane | Unpatched software, credential brute-force |
| TrueNAS (vm-storage-01) | NAS/file share | Ransomware, data exfiltration, misconfigured shares |

### Attack Types to Memorize

**Malware categories:**
- **Ransomware**: encrypts data, demands payment. Defense: offline backups, network segmentation, EDR
- **Rootkit**: persists at OS/firmware level, hides itself. Detection: integrity checking, out-of-band scanning
- **RAT (Remote Access Trojan)**: persistent backdoor. C2 traffic often uses common ports (80/443) to evade egress filtering
- **Worm**: self-propagating, no user interaction. Spreads laterally across network segments — your VLAN segmentation is the relevant control
- **Spyware**: exfiltrates data silently. Egress filtering and DLP are mitigations

**Social engineering:**
- **Phishing**: mass email lure
- **Spear phishing**: targeted, uses personal details
- **Vishing**: phone-based
- **Smishing**: SMS-based
- **Whaling**: targets executives
- **Pretexting**: fabricated scenario to extract info
- **Baiting**: physical media (USB drop) or digital lure

**Network attacks:**
- **On-path (MITM)**: intercepts traffic between two parties. TLS + cert pinning mitigates
- **Replay attack**: captures and retransmits valid authentication token. Timestamps and nonces prevent
- **ARP spoofing**: poisons ARP cache to redirect traffic on local segment
- **DNS poisoning**: injects false DNS records. DNSSEC mitigates
- **DoS / DDoS**: exhausts resources. Rate limiting, scrubbing centers, Anycast routing mitigate

---

## 2.4 Availability as a Security Concept — CIA Triad Deep Dive

The CIA triad is Domain 1 territory but Domain 2 is where it becomes real through attack scenarios.

### Your Live Case Study: `node-app-01` NVMe Degradation

**Situation:** The Inland QN450 NVMe on `node-app-01` has accumulated 186 media errors and 38 unsafe shutdowns.

**CIA triad analysis:**

| Triad Pillar | Impact | Why It Qualifies as a Security Issue |
|---|---|---|
| **Confidentiality** | Low (current) | Risk increases if drive failure causes data to persist on discarded hardware |
| **Integrity** | HIGH | Media errors mean writes may not complete correctly — data corruption is possible without surfacing an error to the guest OS |
| **Availability** | CRITICAL | 5 VMs without block-level replication depend on this drive. Single-point failure takes down hosted services |

**Exam framing:** Availability threats are not only DDoS attacks. Hardware failure, software bugs, power outages, and ransomware all qualify as availability threats. Questions that describe "services becoming unavailable due to [physical cause]" are testing availability.

**Risk register entry for this scenario:**
- **Asset**: node-app-01 NVMe storage (5 guest VMs)
- **Threat**: Physical drive failure (MTBF exceeded, media errors trending up)
- **Vulnerability**: No synchronous replication; no automatic failover
- **Likelihood**: HIGH (drive is visibly degrading)
- **Impact**: HIGH (5 services down; manual recovery required)
- **Risk level**: CRITICAL
- **Controls**: Immediately migrate VMs off this datastore; replace drive; implement Proxmox replication job to node-auth-01

### Lateral Movement — Subnet Segmentation as a Security Control

If a guest on `node-app-01` is compromised:

**Without VLAN/firewall segmentation:**
- An attacker with access to one container could reach `vm-database-01` directly (same flat network)
- Could reach Proxmox API (8006) and escalate to full cluster control
- Could reach `ct-control-01` (Authentik) and poison IdP sessions

**With your current Pi-hole + Caddy setup:**
- External access is proxied — no direct service port exposure
- Tailscale provides encrypted tunnels with identity-based ACLs
- Pi-hole DNS can be used to sinkhole known C2 domains (if threat intel is fed in)

**Exam concept:** Defense-in-depth. No single control stops everything. Layers — network segmentation, application-layer proxy, DNS filtering, identity verification — reduce blast radius when one layer fails.

---

*See also: `domain3-iam-and-architecture-homelab-notes.md` for the IAM and network design continuations of these concepts.*
