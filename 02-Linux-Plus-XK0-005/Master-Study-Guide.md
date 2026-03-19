# Linux+ (XK0-005) Master Study Guide

## Purpose

Use this guide as the anchor page for Linux+ study material.

- `Resources-and-PDFs/` holds books, exam objectives, lab PDFs, and reference sheets.
- `OCR-Dumps/` holds raw OCR output, copied terminal notes, and extracted text for search.

## Working Structure

Add notes here under major Linux+ themes:

- System management
- Security
- Scripting and automation
- Containers and cloud
- Troubleshooting

## Resource Intake Notes

- Keep vendor PDFs and official objective maps in `Resources-and-PDFs/`.
- Keep command transcripts, OCR text, and rough notes in `OCR-Dumps/`.
- Consolidate polished notes and exam-ready summaries into this file.

---

## Free Resources

> You already own ~60% of this exam from Proxmox/Docker operations. Gaps: POSIX scripting rigor, SELinux/AppArmor policy syntax, and systemd unit file authoring from memory.
>
> **Version note**: XK0-005 (V7) retired from English testing January 13, 2026. Verify whether your Pearson VUE voucher targets V7 or V8 before purchasing.

### Official Exam Objectives

- **Exam Objectives PDF** — Download via form at: https://www.comptia.org/certifications/linux
  - Navigate to the V7 exam page and click "Download Exam Objectives." Save to `Resources-and-PDFs/`.
  - Domain weights: System Management 32% · Security 21% · Scripting/Containers/Automation 19% · Troubleshooting 28%

### Top Community GitHub Repos

| Repo | Why it fits |
|---|---|
| [emr-ks/CompTIA-Linux-Plus-Study-Notes](https://github.com/emr-ks/CompTIA-Linux-Plus-Study-Notes) | Single comprehensive PDF covering all XK0-005 domains — structured for rapid review. |
| [LukaszJag/CompTIA-Linux-Plus](https://github.com/LukaszJag/CompTIA-Linux-Plus) | Bootcamp-style notes organized by domain. Use alongside the PDF above. |
| [bregman-arie/devops-exercises](https://github.com/bregman-arie/devops-exercises) | 81k+ stars. The Linux section is far more thorough than any dedicated Linux+ repo — use for drilling command syntax and shell scripting, which Domain 3 tests heavily. |

### Cheat Sheets & Mind Maps

- **tldr-pages** — https://github.com/tldr-pages/tldr (51k+ stars)
  - Practical man-page replacements for every tool on the exam. More useful than a static cheat sheet because this exam tests command syntax recall. Clone it locally for offline use.
- **The Linux Command Line** (free book) — https://linuxcommand.org/tlcl.php
  - Covers shell scripting fundamentals that Domain 3 (Scripting/Automation) tests. Your existing bash usage in Proxmox hooks and Docker entrypoints gives you a head start — use this to fill POSIX compliance gaps.

### Free Video Courses

- **Sander van Vugt — Linux+** (YouTube samples)
  - Search: `"Sander van Vugt" "Linux+"` — free sample lectures cover the hardest XK0-005 topics: SELinux, NFS, containers. His content is Red Hat-aligned, which maps well to exam expectations.
- **Linux Foundation — Introduction to Linux (LFS101)** (free on edX)
  - https://www.edx.org/learn/linux/the-linux-foundation-introduction-to-linux
  - Good for surfacing specific knowledge gaps before you drill objectives. Skip sections that overlap your daily Proxmox/Docker work.
