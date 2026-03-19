---
domain: "3.0 — Security Architecture"
exam_weight: "18%"
source: "Homelab-anchored notes — Winston Koh"
---

# Domain 3.0: Security Architecture
## Homelab-Anchored Study Notes

---

## 3.1 Identity and Access Management (IAM) — Federation Protocols

### SAML vs. OIDC vs. OAuth 2.0

This is one of the most commonly tested IAM topics. Know when each protocol is used and what it does:

| Protocol | Version | What it does | Token format | Use case |
|---|---|---|---|---|
| **SAML 2.0** | XML-based | Authentication + Authorization | XML assertion | Enterprise SSO (corporate IdP → web apps) |
| **OIDC** (OpenID Connect) | Sits on top of OAuth 2.0 | Authentication only | JWT (JSON Web Token) | Modern web/mobile SSO |
| **OAuth 2.0** | — | Authorization only (not authentication) | Access token | Delegated API access (app acts on behalf of user) |

**Critical exam distinction:** OAuth 2.0 is an *authorization* framework, not an *authentication* protocol. It answers "what can this app do?" not "who is this user?" OIDC adds an identity layer on top of OAuth 2.0 to answer "who is this user?"

### How Authentik Implements These on Your Homelab

**Your setup:** Authentik runs on `ct-control-01` (192.168.1.12). It acts as the Identity Provider (IdP) for all services behind `ct-edge-01` (Caddy).

**SAML flow for an enterprise-style integration:**
```
1. User hits app.dayrose.me
2. App (Service Provider) redirects to Authentik (IdP) with SAML AuthnRequest
3. User authenticates at Authentik (MFA if configured)
4. Authentik returns a SAML Assertion (XML, signed with Authentik's private key)
5. App verifies assertion signature using Authentik's public cert
6. App grants access based on attributes in the assertion (groups, email, etc.)
```

**OIDC flow for modern apps:**
```
1. User hits app.dayrose.me
2. App redirects to Authentik with OAuth 2.0 Authorization Code request
3. User authenticates at Authentik
4. Authentik returns Authorization Code
5. App exchanges code for Access Token + ID Token (JWT)
6. App validates JWT signature using Authentik's JWKS endpoint
7. ID Token contains user identity claims (sub, email, groups)
```

**When Authentik uses which:**
- Proxmox web UI, Grafana, Gitea → OIDC (modern, supports JWT)
- Legacy enterprise apps → SAML 2.0
- Raw API access → OAuth 2.0 Client Credentials flow

**Exam trap:** A question that says "an application needs to verify user identity using a corporate directory" → SAML or OIDC. If it says "a third-party app needs to access Google Drive files on behalf of a user" → OAuth 2.0.

---

## 3.2 Forward-Auth Flow — Step-by-Step

Caddy's `forward_auth` directive is a security architecture pattern that maps directly to exam concepts around authentication gateways and zero-trust.

### What Happens on Every Request to a Protected Service

```
[External client]
      │
      │ HTTPS request to omni.dayrose.me
      ▼
[ct-edge-01 — Caddy reverse proxy]
      │
      │ 1. Caddy intercepts request BEFORE forwarding to backend
      │ 2. Caddy sends auth check request to Authentik's outpost
      │    (forward_auth to https://authentik.dayrose.me/outpost.goauthentik.io/auth/caddy)
      │
      ▼
[ct-control-01 — Authentik]
      │
      │ 3. Authentik checks session cookie
      │    - Valid session? → returns 200 OK + user headers
      │    - No session? → returns 302 redirect to login
      │
      ▼
[ct-edge-01 — Caddy] (receives Authentik response)
      │
      │ 4a. If 200: Caddy forwards original request to backend,
      │     injecting user identity headers (X-Authentik-Username, X-Authentik-Groups)
      │
      │ 4b. If 302: Caddy returns redirect to client → client goes to Authentik login
      │
      ▼
[Backend container — e.g., Omni on vm-apps-01]
      │
      │ 5. Backend receives request with user identity in headers
      │    (never saw the original unauthenticated request)
```

**Exam concepts this demonstrates:**
- **Authentication gateway / proxy authentication**: all traffic passes through a centralized auth point — no backend handles credentials directly
- **Defense in depth**: even if a backend has a vulnerability, unauthenticated requests never reach it
- **Single Sign-On**: one session at Authentik covers all services (one login, multiple resources)
- **Zero Trust principle**: every request is verified, even from internal network. Trust is not assumed based on network location

---

## 3.3 Secure Remote Access — VPN and Jump Servers

### Jump Servers (Bastion Hosts)

A jump server is a hardened, single-purpose host that sits on the boundary between networks. All administrative access to internal systems routes through it.

**Exam attributes of a jump server:**
- Minimal installed software — attack surface reduction
- Strong authentication (MFA, certificate-based SSH)
- All session activity logged and auditable
- No direct internet access from internal systems — all admin traffic flows inbound through the jump server

**Your homelab equivalent:** You do not expose SSH port 22 directly from any server to the internet. Administrative access uses Tailscale (WireGuard mesh VPN) as the equivalent control — only enrolled, authenticated devices can reach internal services.

### Tailscale as a Zero-Trust VPN

**How it maps to exam concepts:**

| Traditional VPN | Tailscale / Zero Trust VPN |
|---|---|
| All traffic routed through central gateway | Peer-to-peer encrypted tunnels, no hairpin |
| Once inside VPN, can reach everything | ACLs per device/user — granular access control |
| Trust based on network connection | Trust based on device identity + user identity |
| Single auth at VPN connect | Continuous verification |

**Exit node routing `0.0.0.0/0`:** When a Tailscale exit node is configured on `vm-apps-01` and a client routes all traffic through it, all external traffic appears to originate from the exit node's IP. This is equivalent to a traditional VPN split-tunnel vs. full-tunnel decision, with the security trade-off that exit node compromise affects all clients using it.

### Site-to-Site vs. Remote Access VPN

| | Site-to-Site VPN | Remote Access VPN |
|---|---|---|
| **Connects** | Two networks (e.g., branch to HQ) | Individual device to network |
| **Authentication** | Pre-shared key or certificates | User credentials + device cert |
| **Always on?** | Yes | Usually on-demand |
| **Protocol examples** | IPsec IKEv2, WireGuard | OpenVPN, WireGuard, L2TP/IPsec |

**Always-on VPN (exam concept):** Device connects to corporate VPN before user login — ensures endpoint compliance checks and policy enforcement run before user access begins.

---

## 3.4 DNS Sinkholing — Dual Pi-hole Setup

### What DNS Sinkholing Is

When a client requests resolution of a known malicious domain, the sinkhole returns a controlled (usually private/null) IP instead of the real address. The malware or threat actor's C2 server never receives the connection.

**Your implementation:** Dual Pi-hole resolvers on `ct-dns-01` (192.168.1.20) and `ct-dns-02` (192.168.1.21), synchronized for consistency.

**How it maps to exam concepts:**

| Exam Concept | Your Implementation |
|---|---|
| **DNS sinkholing** | Pi-hole blocklists returning null for known bad domains |
| **Defense in depth** | Two resolvers — if one fails, the other serves. Blocklists kept in sync. |
| **Network-based control** | All DHCP clients get Pi-hole as primary DNS — control at the network layer, not per-device |
| **Threat intelligence feeds** | Blocklists are community-maintained threat intel (e.g., Steven Black's hosts list) |

**Exam trap:** DNS sinkholing is a detective + preventive control — it detects attempted C2 communication and prevents the connection. It does NOT remove malware already running on the host.

### DNSSEC vs. DNS over HTTPS vs. DNS over TLS

| | DNSSEC | DoH | DoT |
|---|---|---|---|
| **What it does** | Signs DNS records — proves they haven't been tampered with | Encrypts DNS queries over HTTPS (port 443) | Encrypts DNS queries over TLS (port 853) |
| **Protects against** | DNS cache poisoning, on-path tampering | DNS eavesdropping, ISP monitoring | DNS eavesdropping, ISP monitoring |
| **Transport** | UDP/TCP 53 (unencrypted transport) | Port 443 | Port 853 |
| **Pi-hole support** | Validates DNSSEC responses | Can forward to DoH upstream | Can forward to DoT upstream |

---

## 3.5 Least Privilege and RBAC — Container Stack

### The Principle of Least Privilege

Each process, service account, or user should have only the minimum permissions required to perform its function — nothing more.

**Homelab mappings:**

| Service | How least privilege is applied | What would happen without it |
|---|---|---|
| Caddy (ct-edge-01) | Runs as non-root after binding port 443 | A process escape would give root access to the host |
| Docker containers (vm-apps-01) | `no-new-privileges`, dropped capabilities, read-only FS where possible | Container escape could pivot to host |
| Authentik service account | Only has permission to write to its own DB schema | Compromise of Authentik service account would have limited blast radius |
| Proxmox API tokens | Scoped to specific VM operations | Full API token compromise gives unrestricted cluster control |
| TrueNAS shares | Per-dataset ACLs, dedicated service users per share | One compromised share user could access all datasets |

### RBAC vs. ABAC vs. MAC vs. DAC

| Model | Description | Example |
|---|---|---|
| **RBAC** (Role-Based) | Permissions assigned to roles; users assigned to roles | Authentik groups → app access. Proxmox "PVEAdmin" role |
| **ABAC** (Attribute-Based) | Access based on attributes (user dept, time of day, location) | "Allow access only from Tailscale IPs during business hours" |
| **MAC** (Mandatory) | Labels/classifications control access; users cannot change | SELinux, government clearance systems |
| **DAC** (Discretionary) | Resource owner controls access | Unix file permissions (chmod), Windows NTFS ACLs |

**Exam question pattern:** When a scenario describes "the security team sets the policy centrally and users cannot override it" → MAC. When "the file owner decides who can read it" → DAC. When "a user belongs to a group that has access" → RBAC.

### Separation of Duties and Dual Control

**Separation of duties:** No single person should have end-to-end control of a sensitive transaction.
- Homelab analogy: Having a separate admin account for Proxmox root tasks (not your daily-use Authentik-authed account) is a weak form of role separation.

**Dual control:** Two people must both act for a sensitive operation to proceed.
- Exam context: Splitting an encryption key into two halves held by two people — neither alone can decrypt.

---

## 3.6 Secure Network Architecture

### Network Segmentation Concepts

| Concept | Description | Your Homelab Equivalent |
|---|---|---|
| **DMZ** | Public-facing services isolated from internal network | `ct-edge-01` handling all external traffic; backends on internal network |
| **VLAN** | Logical network separation at Layer 2 | Tagged VLANs on Proxmox bridges (if configured) |
| **Air gap** | Physical separation — no network connection | Offline backup drives not connected to network |
| **Screened subnet** | Internal DMZ with firewalls on both sides | Services behind Caddy that still face internal-only traffic |

### Firewall Types

| Type | Inspects | State awareness |
|---|---|---|
| **Packet filter** | Headers only (IP, port, protocol) | Stateless |
| **Stateful firewall** | Headers + connection state | Stateful (knows established vs. new) |
| **Application-layer (WAF/proxy)** | Full payload, HTTP methods, request content | Stateful + content-aware |
| **NGFW** | Combines stateful + app awareness + IDS/IPS | Full stack |

**Your reverse proxy as application-layer firewall:** Caddy's `forward_auth` acts as an application-layer control — it inspects the full HTTP request (path, headers, session) before allowing through to the backend. This is closer to a WAF or application proxy than a traditional packet filter.

---

*See also: `domain4-ir-scenarios-expanded.md` for how these architecture decisions affect incident response.*
