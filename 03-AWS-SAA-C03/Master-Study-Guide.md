# AWS Certified Solutions Architect - Associate (SAA-C03) Master Study Guide

## Purpose

Use this guide to consolidate architecture notes, service comparisons, and exam patterns.

- `Resources-and-PDFs/` holds whitepapers, diagrams, practice exam PDFs, and architecture references.
- `OCR-Dumps/` holds extracted text from PDFs, screenshots, and handwritten notes.

## Working Structure

Add notes here under major SAA-C03 themes:

- Identity and access
- Resilient architectures
- Storage and databases
- Networking and hybrid connectivity
- Cost optimization and operational excellence

---

## Free Resources

> Your VPC, IAM, container, and CDN mental models transfer directly. Real exam weight is in cross-service integration patterns (SQS→Lambda→DynamoDB→SNS), multi-AZ/multi-region HA design, and service selection justification (ECS vs EKS vs Fargate vs Lambda — not just what they are, but *when* to choose each).

### Official Exam Objectives

- **Exam Guide PDF** (direct download, confirmed): https://d1.awsstatic.com/training-and-certification/docs-sa-assoc/AWS-Certified-Solutions-Architect-Associate_Exam-Guide.pdf
  - Current version: September 25, 2023 (SAA-C03). Save to `Resources-and-PDFs/`.
  - Domain weights: Design Secure Architectures 30% · Resilient Architectures 26% · High-Performing Architectures 24% · Cost-Optimized Architectures 20%

### Top Community GitHub Repos

| Repo | Why it fits |
|---|---|
| [acantril/aws-sa-associate-saac03](https://github.com/acantril/aws-sa-associate-saac03) | Adrian Cantrill's SAA-C03 course lab code (1.2k+ stars). 20+ sections covering all domains with hands-on demos. His architectural explanations are the best available for bridging practical infra knowledge to AWS theory. |
| [Ditectrev/AWS-Certified-Solutions-Architect-Associate-SAA-C03-Practice-Tests-Exams-Questions-Answers](https://github.com/Ditectrev/AWS-Certified-Solutions-Architect-Associate-SAA-C03-Practice-Tests-Exams-Questions-Answers) | 700+ free practice questions with answers. Best available free test bank — use for timed simulation in the final 2 weeks. |
| [vicjor/aws-saa-c03](https://github.com/vicjor/aws-saa-c03) | Comprehensive personal study notes based on Cantrill's course. IAM, VPC, EC2, S3, RDS, Lambda, CloudFormation, and monitoring all covered in scannable markdown. |
| [sv222/AWS-Solutions-Architect-Associate-Exam-2025](https://github.com/sv222/AWS-Solutions-Architect-Associate-Exam-2025) | Cheatsheet-format service reference. Strong on ECS/EKS, Lambda, ALB/NLB/GLB, KMS, GuardDuty, Macie — the service-comparison scenarios that appear most frequently on the exam. |

### Cheat Sheets & Mind Maps

- **Tutorials Dojo SAA-C03 Cheat Sheets** (free): https://tutorialsdojo.com/aws-cheat-sheets/
  - Service-by-service comparison tables (SQS vs SNS vs EventBridge, etc.). Widely considered the best free reference — these are the exact comparison tables the exam tests.
- **AWS Well-Architected Framework** (free): https://aws.amazon.com/architecture/well-architected/
  - The SAA exam tests Well-Architected thinking directly. Download the whitepapers for all 6 pillars into `Resources-and-PDFs/`.

### Free Video Courses

- **FreeCodeCamp — AWS SAA-C03, Andrew Brown (~10 hours)**: https://www.youtube.com/watch?v=c3Cn4xEfh3g
  - Full course updated for SAA-C03. Andrew Brown maintains ExamPro's open-source course content. Good pacing for someone with existing infra knowledge.
- **AWS Skill Builder — Official free tier**: https://explore.skillbuilder.aws/learn
  - Includes official SAA-C03 sample questions — the highest-fidelity signal of actual exam style and difficulty.
