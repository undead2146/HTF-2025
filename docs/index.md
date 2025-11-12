# Hack The Future 2025 - Serverless Quest Beneath the Surface

Welcome to our underwater exploration platform! This serverless application processes mysterious sonar signals from deep-sea drones, classifying threats, decrypting dark signals, and alerting teams in real-time.

## 🎯 Mission Overview

The Earth is receiving mysterious sonar signals from an uncharted deep-sea region. Our team has deployed an underwater drone connected to an intelligent serverless observation platform. We explore the zone and respond in real-time to everything we encounter — from detecting rare sea creatures to evading underwater threats.

Our platform handles **four distinct levels of signal processing**, from basic observations to encrypted dark signals that require decryption and translation before human operators can understand them.

## 🏗️ Architecture

Our system uses AWS serverless technologies to process events through multiple levels:

### Level 1: Signal Classification

Routes incoming sonar events based on type and intensity. The **Signal Classifier Lambda** validates required fields (`type`, `species`, `location`, `intensity`) and classifies events using business rules:

- **Normal observations**: `creature` type with intensity < 3 → `observation`
- **Rare creatures**: `creature` type with intensity ≥ 3 → `rare-observation`
- **High-threat alerts**: `hazard` or `anomaly` types with intensity ≥ 2 → `alert`
- **Encrypted signals**: Missing required fields → `dark-signal`

Publishes classified events to SNS with message attributes for downstream routing.

### Level 2: Observation Storage

Stores validated observations in **DynamoDB** for long-term analysis and querying. High-intensity signals (≥ 80) are also indexed in **OpenSearch** for real-time alerting and dashboard visualization.

**DynamoDB Schema**: Partition key `team`, sort key `id`, with fields for species, location, intensity, timestamp, and observation type.

### Level 3: Rare Creature Tracking

Processes `rare-observation` events through the same storage pipeline as Level 2, but with specialized handling for scientific research. Rare creatures (intensity ≥ 3) receive enhanced metadata storage in DynamoDB, enabling future analysis of deep-sea biodiversity patterns and species distribution mapping.

### Level 4: Dark Signal Decryption

Uses a **custom substitution cipher** to decrypt encoded messages. Cipher keys are stored in S3 and referenced by `kid` (key ID) in the encrypted payload. The process:

1. Base64 decodes the encrypted payload
2. Fetches the cipher key from S3 `keys.xml`
3. Applies monoalphabetic character substitution
4. Sends decrypted plaintext to SQS queue

### Level 5: Message Translation

Detects the language of decrypted messages using **AWS Comprehend**, translates to English using **AWS Translate**, and posts to Discord webhooks for human review. Supports 100+ languages with automatic language detection and formatted notifications: `**TeamName**: original → translated (lang: xx)`.

## 🚀 Quick Start

### For Demos & Presentations

We've created comprehensive PowerShell test scripts for easy demonstration:

- **`test-all-levels.ps1`** - Complete demo of all levels in sequence
- **`test-level1-observation.ps1`** - Normal creature observation
- **`test-level1-alert.ps1`** - High-intensity hazard alert
- **`test-level3-rare-creature.ps1`** - Rare species detection
- **`test-level4-dark-signal.ps1`** - Complete dark signal pipeline
- **`test-check-dynamodb.ps1`** - Verify stored data

```powershell
# Run complete demo suite
.\test-all-levels.ps1

# Or test individual levels
.\test-level4-dark-signal.ps1
```

### For Development

1. [Setup your environment](./deployment/setup.md)
2. [Deploy the infrastructure](./deployment/configuration.md)
3. [Configure AWS services](./deployment/troubleshooting.md)
4. [Run the test suite](./presentation/demo-script.md)

### For Presentation

We've created comprehensive presentation materials:

- **[Demo Script](./presentation/demo-script.md)** - Complete 7-minute live demo guide with PowerShell scripts
- **[Reflection & Learning](./presentation/reflection-and-learning.md)** - 30+ page comprehensive learning journey (what I learned, pitfalls, AWS mastery, AI usage)
- **[Reflection Presentation Script](./presentation/reflection-presentation-script.md)** - Detailed 10-minute script for presenting your learning journey

## 📊 System Capabilities

- **Intelligent event classification** with business rules for signal routing (creature intensity thresholds, hazard detection)
- **Dual storage architecture** (DynamoDB for all records, OpenSearch for high-threat alerts ≥ 80 intensity)
- **Custom encryption/decryption** using S3-stored substitution ciphers with key ID references
- **Multi-language AI translation** supporting 100+ languages with Comprehend detection and Translate conversion
- **Real-time notifications** via Discord webhooks with formatted alerts: `**Team**: original → translated (lang: xx)`
- **Serverless fault tolerance** with automatic retries, dead-letter queues, and graceful degradation
- **Comprehensive monitoring** with CloudWatch structured logging, X-Ray tracing, and custom metrics

## 🔧 Technology Stack

**AWS Services:**

- EventBridge (event ingestion)
- Lambda (Node.js 20.x compute)
- SNS (message fan-out)
- SQS (decoupled processing)
- DynamoDB (NoSQL storage)
- OpenSearch Serverless (search & analytics)
- S3 (cipher key storage)
- Comprehend (language detection)
- Translate (text translation)
- CloudWatch (monitoring & logging)

**Infrastructure as Code:**

- AWS SAM (Serverless Application Model)
- CloudFormation templates

## 📈 Project Structure

```text
HTF-2025/
├── src/                          # Lambda function source code
│   ├── fn-signal-classifier/     # Level 1: Validates & classifies sonar events by type/intensity
│   ├── fn-observation-ingest/    # Level 2-3: Stores observations in DynamoDB, indexes alerts in OpenSearch
│   ├── fn-dark-signal-decipherer/# Level 4: Decrypts base64 payloads using S3 cipher keys
│   └── fn-message-translator/    # Level 5: Detects language with Comprehend, translates with Translate
├── payloads/                     # Test event payloads (JSON files for each level)
├── docs/                         # VitePress documentation with Mermaid diagrams
├── test-*.ps1                    # PowerShell test scripts with colored output
└── cfn-students.yaml             # CloudFormation template with IAM policies
```

## 📚 Documentation Navigation

### Architecture & Design

- [Architecture Overview](./architecture/overview.md) - System design and component relationships
- [Event Flow Diagrams](./architecture/event-flow.md) - Visual flow for all 5 levels with Mermaid diagrams
- [AWS Services Guide](./architecture/aws-services.md) - Detailed guide to each AWS service used

### Implementation Details

- [Level 1: Signal Classifier](./implementation/level-1.md) - Event validation, classification logic, and SNS publishing
- [Level 2/3: Observation Ingest](./implementation/level-2-3.md) - DynamoDB storage schema and OpenSearch indexing
- [Level 4: Dark Signal Decipherer](./implementation/level-4.md) - Base64 decoding, S3 key fetching, substitution cipher
- [Level 5: Message Translator](./implementation/level-5.md) - Comprehend language detection and Translate API usage

### Deployment & Operations

- [Environment Setup](./deployment/setup.md) - Prerequisites and AWS configuration
- [Configuration & Deployment](./deployment/configuration.md) - CloudFormation deployment steps
- [Troubleshooting](./deployment/troubleshooting.md) - Common issues and solutions

### Innovation & Future

- [Innovation Features](./innovation/features.md) - Unique features and enhancements
- [Future Work](./innovation/future-work.md) - Roadmap and planned improvements

### Presentation Materials

- [Demo Script](./presentation/demo-script.md) - 7-minute live demo with timing
- [Reflection & Learning](./presentation/reflection-and-learning.md) - Comprehensive learning journey
- [Reflection Presentation Script](./presentation/reflection-presentation-script.md) - 10-minute presentation script

## 🎓 Team

- **Team Name**: [Your Team Name]
- **Members**: [Team Members]
- **Challenge**: Serverless Ocean Exploration Platform
- **Hackathon**: Hack The Future 2025

---

Built with passion, AWS serverless technologies, and a love for ocean exploration 🌊
