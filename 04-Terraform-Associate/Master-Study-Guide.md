# Terraform Associate Master Study Guide

## Purpose

Use this guide to centralize Terraform concepts, workflow notes, and provider-specific examples.

- `Resources-and-PDFs/` holds official docs exports, study guides, and cheat sheets.
- `OCR-Dumps/` holds extracted text, command notes, and rough lab output.

## Working Structure

Add notes here under major Terraform themes:

- Core workflow
- Providers and resources
- State management
- Modules
- Variables, outputs, and functions
- Collaboration and remote backends

---

## Free Resources

> You likely know 60–70% of this exam from writing Docker Compose and infrastructure configs. Focus on: remote state backends and locking semantics, `terraform import` and state manipulation, workspace patterns, and Sentinel/OPA policy concepts for HCP Terraform.
>
> **Version note**: Exam 003 objectives now redirect to 004 on the HashiCorp portal. Verify your voucher version. Core content is ~85% identical; primary differences are HCP Terraform workspace features.

### Official Exam Objectives

- **HashiCorp Study Guide (003)**: https://developer.hashicorp.com/terraform/tutorials/certification-003/associate-study-003
  - If this redirects to 004, use the allister-grange repo (below) as the 003 objectives reference.
- **Exam page**: https://www.hashicorp.com/certification/terraform-associate

### Top Community GitHub Repos

| Repo | Why it fits |
|---|---|
| [allister-grange/terraform-associate-guide-003](https://github.com/allister-grange/terraform-associate-guide-003) | 003-specific. 9 folders mapped to exam objectives + Anki deck with 185 flashcards. Author scored 90%+ using this. Explicitly exam-focused — no fluff. |
| [ari-hacks/terraform-study-guide](https://github.com/ari-hacks/terraform-study-guide) | All 9 objectives with markdown notes + Anki flashcards + sample exam questions. The Anki deck is particularly useful for state management and CLI command recall under exam pressure. |

### Cheat Sheets & Mind Maps

- **HashiCorp Terraform CLI reference** (official, the exam is written against this): https://developer.hashicorp.com/terraform/cli
- **Spacelift Terraform CLI Cheat Sheet** (free, comprehensive): https://spacelift.io/blog/terraform-commands-cheat-sheet
  - All exam-relevant CLI commands, state subcommands (`state list`, `state mv`, `state rm`), and workspace operations. Print or save to `Resources-and-PDFs/`.

### Free Video Courses

- **FreeCodeCamp — HashiCorp Terraform Associate, Andrew Brown (~13 hours)**: https://www.youtube.com/watch?v=V4waklkBC38
  - Covers 003 objectives fully. Best free option available.
- **HashiCorp Developer Tutorials** (free, interactive): https://developer.hashicorp.com/terraform/tutorials
  - Organized by the same objective framework as the exam. Run these against your existing homelab — provisioning Proxmox VMs or Docker stacks with Terraform is the fastest bridge from hands-on to exam knowledge.
