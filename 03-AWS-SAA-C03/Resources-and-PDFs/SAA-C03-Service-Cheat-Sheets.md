# SAA-C03 Service Cheat Sheets
> Exam-focused reference for AWS Certified Solutions Architect – Associate.
> Format mirrors Tutorials Dojo's comparison-table style. Focus: *when to choose what*, not just *what it is*.

---

## Table of Contents
1. [S3](#s3)
2. [EC2](#ec2)
3. [VPC](#vpc)
4. [IAM](#iam)
5. [RDS & Aurora](#rds--aurora)
6. [Lambda](#lambda)
7. [ECS / EKS / Fargate](#ecs--eks--fargate)
8. [Load Balancers — ALB / NLB / GLB](#load-balancers)
9. [Auto Scaling](#auto-scaling)
10. [CloudFront](#cloudfront)
11. [Route 53](#route-53)
12. [SQS / SNS / EventBridge](#sqs--sns--eventbridge)
13. [DynamoDB](#dynamodb)
14. [Storage Comparisons](#storage-comparisons)
15. [Security Services](#security-services)

---

## S3

**Durability**: 11 nines (99.999999999%) — all storage classes
**Availability**: varies by class (Standard = 99.99%)

### Storage Classes — When to Use

| Class | Use Case | Retrieval | Min Storage |
|---|---|---|---|
| **S3 Standard** | Active, frequently accessed data | Instant | None |
| **S3 Intelligent-Tiering** | Unknown or changing access patterns | Instant | None |
| **S3 Standard-IA** | Infrequent access, rapid retrieval needed | Instant | 30 days |
| **S3 One Zone-IA** | Infrequent, non-critical, single AZ OK | Instant | 30 days |
| **S3 Glacier Instant** | Archives accessed ~once/quarter | Instant | 90 days |
| **S3 Glacier Flexible** | Archives, 1–5 min to 12 hr retrieval | Minutes–hours | 90 days |
| **S3 Glacier Deep Archive** | Long-term archives, 12–48 hr retrieval | 12–48 hrs | 180 days |

### Key Features
- **Versioning**: protects against accidental delete/overwrite. Required for MFA Delete and Cross-Region Replication.
- **Lifecycle Policies**: auto-transition or expire objects across storage classes.
- **Replication**: Cross-Region (CRR) and Same-Region (SRR). Requires versioning on source AND destination.
- **S3 Transfer Acceleration**: uses CloudFront edge locations to speed uploads globally.
- **Multipart Upload**: recommended >100 MB, required >5 GB.
- **Pre-signed URLs**: time-limited access to private objects without changing bucket policy.
- **Static Website Hosting**: S3 can serve HTML directly. Does NOT support HTTPS natively — put CloudFront in front for HTTPS.
- **Object Lock / WORM**: Compliance and Governance modes. Prevent delete/overwrite for a retention period.
- **S3 Select**: query S3 object content with SQL (CSV, JSON, Parquet). Reduces data transfer.

### Access Control (layered — most restrictive wins)
1. Bucket Policy (resource-based)
2. IAM Policy (identity-based)
3. ACLs (legacy, avoid on new buckets)
4. Block Public Access (account/bucket level — overrides policies)

### Exam Traps
- S3 is **not** a file system — it's object storage. Don't use it where EFS or EBS is needed.
- **Cross-account access**: use bucket policy + IAM role, not ACLs.
- **Requester Pays**: bucket owner pays storage; requester pays transfer costs.
- **Event Notifications**: S3 → SQS, SNS, Lambda, or EventBridge.

---

## EC2

### Instance Pricing Models — When to Use

| Model | Use Case | Discount vs On-Demand |
|---|---|---|
| **On-Demand** | Unpredictable, short-term, cannot be interrupted | Baseline |
| **Reserved (1 or 3 yr)** | Steady-state, predictable workloads | Up to 72% |
| **Savings Plans** | Flexible reserved pricing (Compute or EC2) | Up to 66% |
| **Spot** | Fault-tolerant, flexible, interruptible workloads | Up to 90% |
| **Dedicated Hosts** | Compliance/licensing requiring physical server control | Most expensive |
| **Dedicated Instances** | Isolation at hardware level, no server affinity needed | Expensive |

### Storage
| Type | Description | When to Use |
|---|---|---|
| **EBS** | Persistent block storage, AZ-specific | Primary OS/data disk |
| **Instance Store** | Ephemeral (lost on stop/terminate) | Temp data, cache, buffers |
| **EFS** | Shared NFS (multi-AZ, multi-instance) | Shared file storage across instances |
| **FSx for Windows** | Managed Windows file share (SMB) | Windows workloads needing shared storage |
| **FSx for Lustre** | High-performance parallel FS, integrates with S3 | HPC, ML training |

### AMI
- Region-specific. Copy across regions to launch in another region.
- Can be public, private, or shared with specific accounts.

### Placement Groups
| Type | Description | Use Case |
|---|---|---|
| **Cluster** | Same AZ, same rack, low latency | HPC, tightly coupled apps |
| **Spread** | Max 7 instances per AZ, different hardware | Critical instances that must not share hardware |
| **Partition** | Groups of instances on separate racks | Kafka, HDFS, Cassandra |

### Exam Traps
- Stopping and starting an instance **changes the public IP** (unless Elastic IP).
- **Hibernate**: saves RAM to EBS, fast restart. Requires encrypted root volume.
- **UserData** runs once at launch as root. **Metadata** available at `169.254.169.254`.
- Spot **interruptions** give 2-minute warning. Use Spot Fleet or Auto Scaling for resilience.

---

## VPC

### Core Components

| Component | Function |
|---|---|
| **Internet Gateway (IGW)** | Allows internet traffic to/from public subnets |
| **NAT Gateway** | Allows private subnet instances to reach internet (outbound only). Managed, highly available per AZ. |
| **NAT Instance** | Self-managed NAT. Must disable source/dest check. Legacy. |
| **Virtual Private Gateway (VGW)** | VPN attachment on the AWS side |
| **Customer Gateway** | VPN attachment on the customer side |
| **Transit Gateway** | Hub-and-spoke to connect many VPCs and on-prem |
| **VPC Peering** | Direct 1-to-1 VPC connection, no transitive routing |
| **VPC Endpoint (Gateway)** | Private route to S3 or DynamoDB, no NAT/IGW needed |
| **VPC Endpoint (Interface)** | Private ENI for most AWS services (PrivateLink) |

### Security Groups vs NACLs

| | Security Groups | NACLs |
|---|---|---|
| **Level** | Instance (ENI) | Subnet |
| **State** | Stateful (return traffic auto-allowed) | Stateless (must allow inbound AND outbound) |
| **Rules** | Allow only | Allow and Deny |
| **Evaluation** | All rules evaluated | Rules evaluated in order (lowest # first) |

### Subnet Types
- **Public**: has route to IGW in route table.
- **Private**: no route to IGW. Uses NAT Gateway for outbound internet.
- **Isolated**: no internet route at all.

### Key Routing Rules
- Route tables are per subnet. A subnet inherits the main route table if not explicitly associated.
- Most specific route wins. `0.0.0.0/0 → IGW` is the default internet route.
- Transitive routing is NOT supported with VPC Peering — use Transit Gateway.

### Connectivity Options
| Need | Use |
|---|---|
| Secure VPN to on-prem | Site-to-Site VPN (VGW + Customer Gateway) |
| Dedicated private connection to on-prem | AWS Direct Connect |
| VPN as backup to Direct Connect | Both (Direct Connect primary, VPN failover) |
| Connect many VPCs + on-prem | Transit Gateway |
| Private access to S3/DynamoDB | Gateway Endpoint (free, in route table) |
| Private access to other AWS services | Interface Endpoint (PrivateLink, costs money) |

---

## IAM

### Core Concepts
- **Users**: long-term credentials (access keys, passwords). Avoid for applications — use roles.
- **Groups**: collection of users. Cannot nest groups. Policies attach to groups, inherited by members.
- **Roles**: temporary credentials via STS. Used by EC2, Lambda, cross-account, federated users.
- **Policies**: JSON documents defining Allow/Deny on Actions for Resources.

### Policy Evaluation Logic
1. Explicit **Deny** always wins.
2. Check for explicit **Allow**.
3. Default **Deny** (implicit) if no matching Allow.
4. Permission boundaries and SCPs can further restrict what's allowed.

### Policy Types
| Type | Attached To | Scope |
|---|---|---|
| **Identity-based** | User/Group/Role | What the identity can do |
| **Resource-based** | S3/KMS/SQS/etc. | Who can access this resource |
| **Permission Boundary** | User/Role | Maximum permissions allowed |
| **SCP (Service Control Policy)** | AWS Account/OU | Org-level guardrails |
| **Session Policy** | Assumed role session | Further restrict session |

### Cross-Account Access
1. Role in **Account B** with trust policy allowing Account A principal.
2. User in **Account A** assumes the role via STS `AssumeRole`.
3. No need to create users in Account B.

### Federation
| Standard | Use Case |
|---|---|
| **SAML 2.0** | Enterprise SSO (AD, Okta) — AssumeRoleWithSAML |
| **OIDC** | Web identity federation (Google, Cognito) — AssumeRoleWithWebIdentity |
| **AWS SSO / IAM Identity Center** | Multi-account SSO with AWS Organizations |

### Exam Traps
- Root account: **never use for daily tasks**. Enable MFA. Cannot be restricted by SCP.
- Access keys have **no expiry** by default — rotate them.
- **IAM is global** (not region-specific).
- EC2 instance profile = the container that holds a role for EC2.

---

## RDS & Aurora

### Multi-AZ vs Read Replica

| | Multi-AZ | Read Replica |
|---|---|---|
| **Purpose** | High availability / failover | Read scalability / offload |
| **Replication** | Synchronous | Asynchronous |
| **Failover** | Automatic (~60–120 sec) | Manual promotion |
| **Endpoint** | Same endpoint after failover | Separate read endpoint |
| **Readable?** | No (standby not accessible) | Yes |
| **Cross-Region?** | No (same region, different AZ) | Yes |

### Aurora vs RDS

| | Aurora | RDS (MySQL/Postgres/etc.) |
|---|---|---|
| **Storage** | Distributed, auto-scales to 128 TB | Fixed EBS volume |
| **Replicas** | Up to 15 read replicas, same storage | Up to 5 read replicas |
| **Failover** | ~30 seconds | ~60–120 seconds |
| **Multi-AZ** | Default (6 copies across 3 AZs) | Optional standby |
| **Cost** | ~5x RDS pricing | Lower |

### Aurora Specific Features
- **Aurora Serverless v2**: auto-scales capacity. Use for intermittent/variable workloads.
- **Aurora Global Database**: multi-region, <1 second replication lag. For disaster recovery and global reads.
- **Backtrack**: rewind database to any point without restoring from backup (MySQL only).
- **Aurora Replica auto-scaling**: add read replicas automatically based on CPU/connections.

### RDS Key Points
- **Automated backups**: 1–35 day retention. Stored in S3. Enables point-in-time recovery.
- **Manual snapshots**: no expiry. Survive instance deletion.
- **Encryption**: must be enabled at creation. Encrypted instance → encrypted snapshots. Cannot encrypt existing unencrypted instance — must snapshot, copy with encryption, restore.
- **RDS Proxy**: connection pooling for Lambda-heavy workloads to reduce DB connection overhead.

---

## Lambda

### Key Limits (memorize these)
| Parameter | Limit |
|---|---|
| Execution timeout | 15 minutes max |
| Memory | 128 MB – 10 GB |
| Deployment package | 50 MB zipped / 250 MB unzipped |
| Ephemeral storage (/tmp) | 512 MB – 10 GB |
| Concurrency (default) | 1,000 per region (soft limit) |
| Environment variables | 4 KB |

### Invocation Types
| Type | Trigger Examples | Retry Behavior |
|---|---|---|
| **Synchronous** | API Gateway, ALB, SDK direct call | Caller handles errors |
| **Asynchronous** | S3 events, SNS, EventBridge | Lambda retries 2x; DLQ for failures |
| **Poll-based (stream)** | SQS, DynamoDB Streams, Kinesis | Lambda polls; retries until success or expired |

### Cold Start Mitigation
- **Provisioned Concurrency**: pre-warms instances. Eliminates cold start. Costs money.
- Keep Lambda in VPC only if needed (VPC adds cold start latency).
- Use Lambda SnapStart (Java) for JVM warm-up optimization.

### Lambda@Edge vs CloudFront Functions
| | Lambda@Edge | CloudFront Functions |
|---|---|---|
| **Runtime** | Node.js, Python | JavaScript only |
| **Execution location** | Regional edge caches | All 400+ edge locations |
| **Max execution time** | 30 sec (viewer) / 30 sec (origin) | < 1 ms |
| **Use case** | Complex logic, auth, dynamic content | Header manipulation, URL rewrites, simple transforms |

---

## ECS / EKS / Fargate

### When to Choose What

| | ECS | EKS | Fargate |
|---|---|---|---|
| **Orchestrator** | AWS-native (simpler) | Kubernetes (industry standard) | Serverless compute for ECS or EKS |
| **Control plane** | AWS managed | AWS managed (you pay for it) | N/A — it IS the compute layer |
| **Use case** | AWS-native Docker workloads | Teams already using K8s / portability | No server management, variable scale |
| **Pricing** | EC2 or Fargate launch type | ~$0.10/hr control plane + compute | Per vCPU/memory-second |

**Fargate** = no EC2 instances to manage. Works with both ECS and EKS.
**ECS on EC2** = you manage the EC2 instances (Auto Scaling groups).
**EKS** = choose when you need Kubernetes compatibility, existing Helm charts, or multi-cloud portability.

### ECS Key Concepts
- **Task Definition**: blueprint (image, CPU, memory, ports, IAM role).
- **Service**: keeps N tasks running, integrates with ALB.
- **Cluster**: logical grouping of tasks/services.
- **Task Role**: IAM role for the container. **Execution Role**: IAM role for ECS agent to pull images and write logs.

---

## Load Balancers

### ALB vs NLB vs GLB

| | ALB (Application) | NLB (Network) | GLB (Gateway) |
|---|---|---|---|
| **Layer** | 7 (HTTP/HTTPS) | 4 (TCP/UDP/TLS) | 3 (IP) |
| **Routing** | Path, host, header, query | IP, port | N/A (transparent passthrough) |
| **Use Case** | Web apps, microservices, gRPC | Ultra-low latency, static IP, TCP apps | Third-party security appliances |
| **SSL Termination** | Yes | Yes (TLS passthrough option too) | No |
| **Static IP** | No (use DNS) | Yes (one per AZ, or Elastic IP) | No |
| **WebSockets** | Yes | Yes | No |
| **Target Types** | Instance, IP, Lambda | Instance, IP | Instance, IP |

### ALB Features
- **Listener rules**: forward, redirect, fixed-response. Weighted target groups for blue/green.
- **Sticky sessions**: cookie-based. Routes user to same target.
- **Authentication**: native OIDC/Cognito integration.
- **Access logs**: to S3.

### Key Exam Scenario: Static IP behind ALB
- ALB doesn't have static IPs. Workaround: put NLB in front of ALB, or use Global Accelerator.

---

## Auto Scaling

### Scaling Policies

| Policy | Description | Use Case |
|---|---|---|
| **Target Tracking** | Maintain a metric at target value (e.g., CPU = 50%) | Simplest, recommended default |
| **Step Scaling** | Scale by X when metric crosses threshold | More control over step sizes |
| **Simple Scaling** | One action per alarm, cooldown before next | Legacy, avoid |
| **Scheduled** | Scale at a specific time | Predictable traffic patterns |
| **Predictive** | ML-based, pre-scales for anticipated load | Recurring patterns |

### Key Concepts
- **Cooldown period**: prevents rapid scale-in/out after a scaling activity. Default 300 sec.
- **Warm-up period**: time for new instance to contribute metrics before affecting scale decisions.
- **Health checks**: EC2 (instance state) or ELB (load balancer health). Use ELB for web apps.
- **Termination policy**: default removes oldest launch config instance first.
- **Lifecycle hooks**: pause instance during launch/terminate for custom actions (e.g., install agent, drain connections).

---

## CloudFront

### Key Concepts
- **Distribution**: the CloudFront endpoint. Origin can be S3, ALB, EC2, HTTP server.
- **Cache Behavior**: rules per path pattern (`/images/*`, `/api/*`). Controls TTL, allowed methods, forwarding.
- **TTL**: `min`, `max`, `default`. Origin can override with `Cache-Control` headers.
- **Invalidations**: force cache clear. Costs money. Prefer versioned file names.
- **OAC (Origin Access Control)**: restricts S3 access so only CloudFront can read it (successor to OAI).
- **Geo-restriction**: allow/block countries.
- **Signed URLs / Signed Cookies**: time-limited access to private content.
  - Signed URL = single file.
  - Signed Cookie = multiple files (whole section of site).
- **Field-level encryption**: encrypt specific POST fields end-to-end.

### CloudFront vs S3 Transfer Acceleration
| | CloudFront | S3 Transfer Acceleration |
|---|---|---|
| **Purpose** | Content delivery (reads + some writes) | Faster S3 uploads from global clients |
| **Direction** | Reads (primarily) | Uploads only |
| **Edge network** | CloudFront edge locations | CloudFront edge locations |

---

## Route 53

### Routing Policies

| Policy | Description | Use Case |
|---|---|---|
| **Simple** | Single record, no health check | Basic DNS |
| **Failover** | Primary/secondary with health check | Active-passive DR |
| **Weighted** | Split traffic by weight (0–255) | Blue/green, A/B testing |
| **Latency** | Routes to lowest-latency region | Multi-region performance |
| **Geolocation** | Routes by user country/continent | Compliance, localization |
| **Geoproximity** | Routes by location + bias value | Fine-tuned geographic routing |
| **Multivalue Answer** | Returns up to 8 healthy records | Client-side load balancing |
| **IP-based** | Routes by client IP CIDR | ISP-based routing |

### Key Concepts
- **Alias records**: Route 53 extension. Points to AWS resources (ALB, CloudFront, S3 website, another Route 53 record). **Free for queries to AWS resources.** Use alias over CNAME for apex domain (naked domain).
- **CNAME**: cannot be used at apex domain (`example.com`). Use Alias instead.
- **Health checks**: monitor endpoints. Used by Failover, Weighted, Latency, Geolocation policies.
- **Private Hosted Zone**: DNS resolution within VPC only. Must have `enableDnsHostnames` and `enableDnsSupport` on VPC.

---

## SQS / SNS / EventBridge

### When to Choose What

| | SQS | SNS | EventBridge |
|---|---|---|---|
| **Pattern** | Queue (pull) | Pub/Sub (push) | Event bus (rule-based routing) |
| **Consumers** | One consumer processes each message | Multiple subscribers (fan-out) | Multiple rules/targets |
| **Message retention** | Up to 14 days | No retention | 24 hrs (archive up to forever) |
| **Ordering** | FIFO queues only | No ordering | No ordering |
| **Filtering** | No | Yes (subscription filter policy) | Yes (event pattern rules) |
| **Use case** | Decouple producer/consumer, buffer spikes | Notify multiple systems of same event | React to AWS service events, SaaS events |

### SQS Deep Dive
- **Standard**: at-least-once delivery, best-effort ordering, unlimited throughput.
- **FIFO**: exactly-once processing, strict ordering, 300 TPS (3,000 with batching).
- **Visibility Timeout**: time a message is invisible after being received. Default 30s. Extend if processing takes longer.
- **Dead Letter Queue (DLQ)**: receives messages that fail processing after `maxReceiveCount`.
- **Long Polling** (`WaitTimeSeconds` up to 20s): reduces empty API calls and cost. Prefer over short polling.
- **Delay Queue**: postpone delivery of new messages (0–900 sec). Per-queue or per-message.
- **Message size**: max 256 KB. Use S3 + SQS extended client library for larger payloads.

### Fan-out Pattern (SNS + SQS)
SNS topic → multiple SQS queues. Each queue has its own consumer. Decoupled, parallel processing.

### EventBridge Key Points
- **Default event bus**: receives events from AWS services.
- **Custom event bus**: receive events from your apps.
- **Partner event bus**: receive events from SaaS (Datadog, Zendesk, etc.).
- **Schema Registry**: auto-discovers event schemas.
- Replaces CloudWatch Events (same underlying service, extended features).

---

## DynamoDB

### Key Concepts
- **Partition key** (required): determines partition. Must be unique if used alone.
- **Sort key** (optional): enables range queries within a partition.
- **Item size**: max 400 KB.
- **Throughput modes**:
  - **Provisioned**: set RCU/WCU. Use for predictable traffic. Auto Scaling available.
  - **On-Demand**: pay per request. Use for unpredictable traffic. More expensive per request.
- **RCU**: 1 strongly consistent read of ≤4 KB/s. 2 eventually consistent reads of ≤4 KB/s.
- **WCU**: 1 write of ≤1 KB/s.

### Indexes
| | GSI (Global Secondary Index) | LSI (Local Secondary Index) |
|---|---|---|
| **Partition key** | Different from base table | Same as base table |
| **Sort key** | Any attribute | Different from base table |
| **Created when** | Anytime | At table creation only |
| **Capacity** | Separate RCU/WCU | Shares table capacity |
| **Limit** | 20 per table | 5 per table |

### DynamoDB Streams + Lambda = event-driven pattern for change data capture.

### DAX (DynamoDB Accelerator)
- In-memory cache, microsecond reads. Drop-in replacement (same API).
- Use for read-heavy, eventually consistent workloads.
- Does NOT help with write-heavy workloads.

### Global Tables
- Multi-region, multi-active replication. Requires on-demand or auto scaling mode.
- Use for globally distributed apps needing local low-latency reads AND writes.

---

## Storage Comparisons

### EBS vs EFS vs S3 vs Instance Store

| | EBS | EFS | S3 | Instance Store |
|---|---|---|---|---|
| **Type** | Block | File (NFS) | Object | Block |
| **Persistence** | Persistent | Persistent | Persistent | Ephemeral |
| **Scope** | Single AZ | Multi-AZ, multi-instance | Global | Single instance |
| **Attach to** | One EC2 (usually) | Many EC2 simultaneously | Via API/SDK | Attached EC2 only |
| **Use case** | OS disk, databases | Shared file storage | Backups, media, static assets | Temp scratch space |
| **Max size** | 64 TB (io2 Block Express) | Unlimited (auto-scales) | Unlimited | Instance-dependent |

### EBS Volume Types

| Type | Description | Use Case |
|---|---|---|
| **gp3** | General purpose SSD, baseline 3,000 IOPS | Default for most workloads |
| **gp2** | General purpose SSD, IOPS scales with size | Legacy default |
| **io2 / io2 Block Express** | Provisioned IOPS SSD, up to 256,000 IOPS | Databases, latency-sensitive |
| **st1** | Throughput-optimized HDD | Big data, data warehouses |
| **sc1** | Cold HDD | Infrequently accessed, lowest cost |

---

## Security Services

### When to Choose What

| Service | What It Does | When to Use |
|---|---|---|
| **KMS** | Managed encryption keys (CMK) | Encrypting EBS, S3, RDS, etc. |
| **CloudHSM** | Dedicated hardware security module | Strict key control, compliance (FIPS 140-2 L3) |
| **Secrets Manager** | Stores and auto-rotates secrets | DB credentials, API keys |
| **Parameter Store** | Stores config + secrets, lower cost | Config values, simple secrets without auto-rotation |
| **GuardDuty** | Threat detection (VPC Flow, DNS, CloudTrail) | Detecting anomalies, compromised instances |
| **Macie** | ML-based PII discovery in S3 | Data classification, compliance |
| **Inspector** | Vulnerability scanning for EC2/ECR | CVE and network exposure analysis |
| **Shield Standard** | DDoS protection (L3/L4) | Automatic, free for all AWS customers |
| **Shield Advanced** | Enhanced DDoS + 24/7 DRT + cost protection | Mission-critical apps, CloudFront/Route 53/ALB |
| **WAF** | L7 firewall (rules on HTTP requests) | Block SQLi, XSS, bad bots |
| **Firewall Manager** | Centrally manage WAF/Shield/SG rules across accounts | Multi-account governance |
| **Network Firewall** | Stateful L3–L7 firewall for VPC | Deep packet inspection, IDS/IPS in VPC |

### KMS Key Types
| | AWS Managed Keys | Customer Managed Keys (CMK) | CloudHSM |
|---|---|---|---|
| **Control** | AWS controls rotation | You control rotation/policy | Full hardware control |
| **Cost** | Free | $1/month/key | ~$1.60/hr/HSM |
| **Cross-account** | No | Yes (key policy) | Yes |

---

*Source: compiled from exam objectives, AWS documentation, and community study notes.*
*Save vendor PDFs to this folder: `Resources-and-PDFs/`*
