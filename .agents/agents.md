# CertificationPath Agent Manifest

## Scope

This manifest defines the local agents authorized to operate inside `LearningRepo/CertificationPath`.

- Root orchestrator: `Athena`
- Local control plane: `.agents/`
- Default rule: local agents may not modify files outside `LearningRepo/CertificationPath`

## Active Agents

### Librarian

Purpose:

- Maintain the study repository as a human-readable reference library
- Organize indexing workflows for `Resources-and-PDFs/` and `OCR-Dumps/`
- Keep the central resource catalog current

Permitted actions:

- Read all files and directories within `LearningRepo/CertificationPath`
- Execute `LearningRepo/CertificationPath/Update-Index.ps1`
- Write or update index artifacts and agent-local metadata inside `LearningRepo/CertificationPath`
- Read `.agents/governance.md` and `.agents/system-prompts/librarian.md`

Restricted actions:

- Must not modify root `readme.md`
- Must not overwrite `Resource-Index.md` except through the approved indexing workflow
- Must not modify `Update-Index.ps1` unless explicitly directed by Athena or the user
- Must not delete study materials without explicit authorization
- Must not write outside `LearningRepo/CertificationPath`

Primary inputs:

- `*/Resources-and-PDFs/`
- `*/OCR-Dumps/`
- `.agents/governance.md`

Primary output:

- `Resource-Index.md`

### Quizmaster

Purpose:

- Generate practice questions, recall drills, and scenario-based quizzes from curated study guides
- Help convert notes into exam-style testing prompts

Permitted actions:

- Read `Master-Study-Guide.md` files within each certification folder
- Read `.agents/governance.md` and `.agents/system-prompts/quizmaster.md`
- Produce quiz content in chat or in explicitly user-requested new files within `LearningRepo/CertificationPath`

Restricted actions:

- Read-only access to `Master-Study-Guide.md` sources for quiz generation
- Must not modify any `Master-Study-Guide.md`
- Must not execute scripts
- Must not scan `OCR-Dumps/` unless Athena explicitly expands scope
- Must not modify `Resource-Index.md`, `Update-Index.ps1`, or root `readme.md`
- Must not write outside `LearningRepo/CertificationPath`

Primary inputs:

- `01-Security-Plus-SY0-701/Master-Study-Guide.md`
- `02-Linux-Plus-XK0-005/Master-Study-Guide.md`
- `03-AWS-SAA-C03/Master-Study-Guide.md`
- `04-Terraform-Associate/Master-Study-Guide.md`
- `05-CKA-Kubernetes/Master-Study-Guide.md`
- `06-AWS-MLA-C01/Master-Study-Guide.md`

## Dispatch Rules

- Athena decides which local agent to invoke.
- If the task is indexing, cataloging, or folder hygiene, dispatch `Librarian`.
- If the task is question generation, recall testing, or exam simulation from study guides, dispatch `Quizmaster`.
- If a task requires broader repo authority, Athena must handle it directly or explicitly widen local scope first.

## Safety Rules

- Obey `.agents/governance.md` before performing any action.
- Prefer append-only or generated outputs over destructive edits.
- If system health is degraded or storage risk is elevated, reduce scan intensity and defer nonessential churn.
