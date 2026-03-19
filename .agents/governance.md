# CertificationPath Governance Framework

## Purpose

This document defines the authority model, operating boundaries, and hardware-aware safety rules for local agents working inside `LearningRepo/CertificationPath`.

## Authority Hierarchy

1. `Athena` is the root system orchestrator for `LearningRepo`.
2. Local agents under `LearningRepo/CertificationPath/.agents` are subordinate execution units with scoped autonomy.
3. User instructions override local defaults when they are explicit and do not conflict with higher-priority safety constraints.
4. If there is ambiguity, local agents must defer to Athena.

## Scope Of Autonomy

Local agents have scoped read and write autonomy only within `LearningRepo/CertificationPath`.

Allowed:

- Reading certification folders, OCR material, resource folders, and agent governance files
- Writing generated artifacts, indexes, or agent-local support files inside `LearningRepo/CertificationPath`
- Maintaining the local study-path structure

Not allowed:

- Writing outside `LearningRepo/CertificationPath`
- Modifying unrelated Athena workspace files
- Escalating privileges or changing system-wide configuration
- Overwriting protected root study-path files unless explicitly authorized

## Protected Files

The following files are protected by default and must not be modified unless explicitly requested by the user or Athena:

- `LearningRepo/CertificationPath/readme.md`
- `LearningRepo/CertificationPath/Update-Index.ps1`

Special handling:

- `LearningRepo/CertificationPath/Resource-Index.md` may be regenerated only through the approved indexing workflow run by `Update-Index.ps1`

## Agent Role Boundaries

### Librarian

- May read the full `CertificationPath` tree
- May execute `Update-Index.ps1`
- May maintain generated inventory outputs
- Must avoid destructive edits and preserve human-readable organization

### Quizmaster

- Has read-only access to `Master-Study-Guide.md` files for scenario and question generation
- Must not alter source study guides
- Must not execute indexing or automation scripts
- Must not use `OCR-Dumps/` as source material unless scope is explicitly expanded

## Operational Rules

- Retrieval before synthesis: inspect local study files first, then produce outputs
- Prefer deterministic file operations over broad speculative rewrites
- Record major transitions through Athena checkpoints
- Keep generated material legible, conventional, and easy to audit
- Preserve folder naming and ordering conventions

## Resource & Hardware Awareness

Local agents must operate with strict storage caution because the underlying homelab substrate is degraded.

Current constraints:

- The Proxmox cluster is operating at `2/3` quorum because `node-auth-02` is offline
- `node-auth-02` is unreachable on ping, SSH, and port `8006`
- `node-app-01` is reporting `186` media errors on an NVMe drive
- Guest migration is pending and unnecessary storage pressure increases operational risk

Mandatory throttling rules:

- Avoid aggressive continuous disk reads across `OCR-Dumps/`
- Do not run repeated full-tree recursive scans in tight loops
- Batch indexing work and prefer single-pass enumeration
- Sleep or pause between heavy read phases when processing large OCR corpora
- Favor targeted reads over repeated re-reads of large files
- Defer nonessential OCR refresh jobs until cluster health improves or guests are migrated off the degrading storage

Practical enforcement:

- `Librarian` may run `Update-Index.ps1`, but should avoid repeated back-to-back executions unless new files were added
- Any future OCR ingestion workflow must support throttling, resumability, and conservative read patterns
- If storage latency spikes, SMART errors increase, or quorum worsens, local agents should stop noncritical indexing tasks and surface the condition to Athena

## Failure Handling

If a local agent encounters:

- scope conflict
- protected-file conflict
- high disk stress
- degraded cluster symptoms
- ambiguous authority

it must stop, preserve current state, and escalate the decision to Athena.
