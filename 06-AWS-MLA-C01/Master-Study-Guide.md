# AWS Certified Machine Learning Engineer - Associate (MLA-C01) Master Study Guide

## Purpose

Use this guide for ML platform architecture, deployment patterns, and monitoring notes.

- `Resources-and-PDFs/` holds AWS docs exports, exam guides, and ML operations references.
- `OCR-Dumps/` holds extracted text, notebook summaries, and rough study notes.

## Working Structure

Add notes here under major MLA-C01 themes:

- Data engineering for ML
- Feature processing
- Training and tuning
- Deployment and inference
- Monitoring, security, and governance

---

## Free Resources

> Domain 3 (Deployment/Orchestration, 22%) maps directly to your Docker/container skills — applied to SageMaker pipelines, Step Functions, and ECR. Domain 4 (Monitoring/Security, 24%) maps to your Authentik/Caddy security thinking. Gaps: SageMaker-specific APIs (training jobs, endpoints, feature store, pipelines) and AWS AI service selection (Bedrock vs SageMaker JumpStart vs Comprehend vs Rekognition — when to use each).

### Official Exam Objectives

- **Exam Guide PDF** (direct download, confirmed): https://docs.aws.amazon.com/pdfs/aws-certification/latest/machine-learning-engineer-associate-01/machine-learning-engineer-associate-01.pdf
  - Save to `Resources-and-PDFs/`. Exam format: 65 questions (50 scored + 15 unscored), passing score 720/1000.
  - Domain weights: Data Preparation for ML 28% · ML Model Development 26% · **Deployment & Orchestration 22%** · **Monitoring, Maintenance & Security 24%**

### Top Community GitHub Repos

| Repo | Why it fits |
|---|---|
| [artreimus/notes-aws-machine-learning](https://github.com/artreimus/notes-aws-machine-learning) | 14 topic directories covering all 4 domains: AI services, SageMaker (algorithms, training, endpoints, JumpStart), data ingestion/transformation, MLOps, GenAI/Bedrock, Agentic AI, and security/compliance. 239 commits — actively maintained. |
| [marcus912/aws-mla-certification-notes](https://github.com/marcus912/aws-mla-certification-notes) | 21 markdown files (~9,170 lines). All 17 SageMaker built-in algorithms catalogued, 25+ AWS AI/ML services covered, 333 exam-specific tips. Strong on MLOps and inference optimization. |
| [pluralsight-cloud/AWS-Certified-Machine-Learning-Associate-MLA-C01](https://github.com/pluralsight-cloud/AWS-Certified-Machine-Learning-Associate-MLA-C01) | Jupyter Notebooks + Python + Docker from Pluralsight's official MLA-C01 course. Code-based and hands-on — ideal for someone who learns by running things in a container. |

### Cheat Sheets & Mind Maps

- **Tutorials Dojo MLA-C01 Cheat Sheets** (free): https://tutorialsdojo.com/aws-cheat-sheets/#machine-learning
  - Service comparison tables for SageMaker features, AI services, and MLOps tooling. Particularly useful for the inference endpoint type decision tree (real-time vs batch vs async vs serverless).
- **AWS SageMaker Developer Guide** (use as exam reference, not linear read): https://docs.aws.amazon.com/sagemaker/latest/dg/whatis.html
  - The exam is written against this. Focus on: built-in algorithms, training job config, inference endpoint types, and Model Monitor.

### Free Video Courses

- **FreeCodeCamp — AWS Machine Learning, Mike Chambers (~6 hours)**: https://www.youtube.com/watch?v=tMhqKxkOPEY
  - ML fundamentals + AWS ML services. Not MLA-C01-specific but covers the foundational model and service knowledge the exam assumes.
- **AWS Skill Builder — MLA-C01 Official Prep** (free tier): https://explore.skillbuilder.aws/learn
  - Includes the official MLA-C01 exam prep course and sample questions. Sample questions are the highest-fidelity signal of actual exam difficulty and style.
- **SageMaker Immersion Day** (free, self-paced workshops): https://catalog.workshops.aws/sagemaker-immersion-day
  - Hands-on SageMaker labs covering the exact workflows tested. Bridging your Docker/container MLOps thinking to SageMaker's paradigm (training jobs, endpoints, pipelines) is the key skill transfer for this cert.
