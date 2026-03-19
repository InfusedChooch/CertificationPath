# 🚀 Enterprise AI Infrastructure & Orchestration Study Guide

This track is designed to bridge the gap between bare-metal systems administration and enterprise-scale AI/MLOps engineering. 

---

## Tier 1: The Baseline & Security Filters
*Core competency validation for access management, secure transit, and system administration.*

### [ ] CompTIA Security+ (SY0-701)
- **Focus:** Zero-trust perimeters, cryptography, incident response, and GRC (Governance, Risk, and Compliance) frameworks.
- **Homelab Application:** Formalizing the concepts used to deploy Authentik SSO, secure services behind Caddy reverse proxies, and manage internal DNS sinkholes.
- **Target Exam Date:** `YYYY-MM-DD`

### [ ] CompTIA Linux+ (XK0-005)
- **Focus:** Advanced command-line operations, automation scripting, package management, and system administration.
- **Homelab Application:** Writing the underlying Bash scripts and cron jobs used to automate container patching and manage backend storage pools across multiple Debian/Ubuntu instances.
- **Target Exam Date:** `YYYY-MM-DD`

---

## Tier 2: Enterprise Cloud & Infrastructure as Code (IaC)
*Translating local hardware topologies into scalable, declarative cloud environments.*

### [ ] AWS Certified Solutions Architect – Associate (SAA-C03)
- **Focus:** Designing resilient, secure, and highly available cloud architectures (VPCs, S3, IAM, EC2).
- **Homelab Application:** Mapping a physical 3-node bare-metal cluster and attached NAS storage into cloud-native equivalents like Auto Scaling Groups and S3 buckets.
- **Target Exam Date:** `YYYY-MM-DD`

### [ ] HashiCorp Certified: Terraform Associate
- **Focus:** Infrastructure as Code (IaC), state management, and declarative deployments.
- **Homelab Application:** Transitioning from manual graphical interface deployments to spinning up virtual machines, network bridges, and firewall rules entirely through version-controlled code.
- **Target Exam Date:** `YYYY-MM-DD`

---

## Tier 3: High Availability & Orchestration
*Building the fault-tolerant container grids required for autonomous services.*

### [ ] Certified Kubernetes Administrator (CKA)
- **Focus:** 100% command-line management of Kubernetes clusters, fault tolerance, node health, and self-healing deployments.
- **Homelab Application:** Evolving beyond basic Docker control planes. Ensuring that if a physical node drops offline or becomes unreachable, the hosted containerized services automatically migrate and recover without manual intervention.
- **Target Exam Date:** `YYYY-MM-DD`

---

## Tier 4: MLOps & Agent Plumbing
*Orchestrating the backend environments where LLMs and Agents run and retrieve context.*

### [ ] AWS Certified Machine Learning Engineer – Associate (MLA-C01)
- **Focus:** Putting machine learning models into production, securing data pipelines, managing inference endpoints, and monitoring resource utilization.
- **Homelab Application:** Designing the secure infrastructure required to pass hardware accelerators through to virtualized environments, allowing local models to efficiently query structured Markdown file trees for context retrieval.
- **Target Exam Date:** `YYYY-MM-DD`

### [ ] Google Cloud Professional Machine Learning Engineer (Alternative)
- **Focus:** Building scalable data pipelines and deploying highly available ML models on GCP (Vertex AI).
- **Homelab Application:** A solid alternative to the AWS track if the target enterprise environment heavily relies on the Google Cloud ecosystem for its vector databases and model hosting.
- **Target Exam Date:** `YYYY-MM-DD`
