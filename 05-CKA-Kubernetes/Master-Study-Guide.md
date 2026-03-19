# Certified Kubernetes Administrator (CKA) Master Study Guide

## Purpose

Use this guide to consolidate cluster administration notes, troubleshooting drills, and command-heavy study material.

- `Resources-and-PDFs/` holds Kubernetes docs exports, practice tasks, and architecture references.
- `OCR-Dumps/` holds raw OCR text, copied terminal output, and rough lab notes.

## Working Structure

Add notes here under major CKA themes:

- Cluster architecture
- Workloads and scheduling
- Services and networking
- Storage
- Troubleshooting
- Security and maintenance

---

## Free Resources

> The CKA is a 2-hour **hands-on performance exam** in a live cluster — no multiple choice. `kubectl` speed is a score multiplier. Your Docker/Proxmox container and networking mental models are correct; gaps are: kubeadm cluster bootstrap from scratch, etcd backup/restore, RBAC policy authoring, and NetworkPolicy YAML syntax — all from memory under time pressure.

### Official Exam Objectives

- **CNCF Curriculum PDF (v1.35, current)**: https://raw.githubusercontent.com/cncf/curriculum/master/CKA_Curriculum_v1.35.pdf
  - Save to `Resources-and-PDFs/`. Domain weights: **Troubleshooting 30%** · Cluster Architecture/Installation 25% · Services & Networking 20% · Workloads & Scheduling 15% · Storage 10%
- **Candidate Handbook**: https://docs.linuxfoundation.org/tc-docs/certification/lf-handbook2 — read before scheduling; covers the exam environment rules (allowed browser tabs, etc.)

### Top Community GitHub Repos

| Repo | Why it fits |
|---|---|
| [walidshaari/Kubernetes-Certified-Administrator](https://github.com/walidshaari/Kubernetes-Certified-Administrator) | 4.4k+ stars. The most starred CKA repo. Curated links to kubernetes.io docs organized by domain, RBAC and networking labs, kubectl alias patterns. The canonical starting index. |
| [leandrocostam/cka-preparation-guide](https://github.com/leandrocostam/cka-preparation-guide) | Organized by all 5 domains with kubectl command examples, YAML templates, and links to KillerCoda/Killer.sh simulators. |
| [chadmcrowell/CKA-Exercises](https://github.com/chadmcrowell/CKA-Exercises) | Practice exercises mapped to exam domains in performance-based format — you run commands against a cluster, matching the actual exam format. |
| [ismet55555/Certified-Kubernetes-Administrator-Notes](https://github.com/ismet55555/Certified-Kubernetes-Administrator-Notes) | Comprehensive notes: kubeadm, etcd, RBAC, CNI, NetworkPolicies, PV/PVC, and troubleshooting — all the procedures you need memorized for the live exam. |
| [theplatformlab/CKA-Certified-Kubernetes-Administrator](https://github.com/theplatformlab/CKA-Certified-Kubernetes-Administrator) | Updated for v1.35. Includes 12 hands-on exercises, 18 YAML skeleton templates, kubectl cheat sheet, troubleshooting playbook, and exam setup script (aliases/vim config/bash-completion). Author passed at 89%. |

### Cheat Sheets & Mind Maps

- **Official kubectl Quick Reference** (kubernetes.io): https://kubernetes.io/docs/reference/kubectl/quick-reference/
  - This is available during the exam (you can open kubernetes.io docs). Know it cold. Save to `Resources-and-PDFs/`.
- **Exam setup aliases** (from theplatformlab repo above) — the `alias k=kubectl`, `export do="--dry-run=client -o yaml"` patterns are standard exam optimizations. Add these to your `.bashrc` and practice with them daily.

### Free Video Courses

- **FreeCodeCamp — Kubernetes Full Course, TechWorld with Nana (~5.5 hours)**: https://www.youtube.com/watch?v=X48VuDVv0do
  - Bridges Docker-to-K8s mental model. Covers architecture and core operations. Not CKA-specific but essential context for someone coming from Docker/Compose.
- **Mumshad Mannambeth — Kubernetes for Beginners (FreeCodeCamp, ~4 hours)**: https://www.youtube.com/watch?v=s_o8dwzRlu4
  - Designed as CKA prep. Covers cluster setup, YAML, scheduling, networking, and storage.
- **KillerCoda — Free CKA labs** (browser-based, no cluster needed): https://killercoda.com/killer-shell-cka
  - Free interactive scenarios that match exam task format. Critical if you don't run a local kubeadm cluster.
- **Killer.sh** (2 free simulator sessions included with exam purchase): https://killer.sh
  - Harder than the real exam deliberately. Use both sessions in the week before your exam date.
