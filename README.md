# HTF25 - The Serverless Quest Beneath the Surface 🌊

The Earth is receiving mysterious sonar signals from an uncharted deep-sea region.  
Your team is deployed with an underwater drone, connected to an intelligent serverless observation platform.  
Explore the zone and respond in real time to everything you encounter — from detecting rare sea creatures to evading underwater threats.

![HTF-2025-Architecture](img/HTF-2025-Architecture.png)

---

## 🎯 Project Overview

This project demonstrates a complete **event-driven serverless architecture** on AWS that processes sonar signals through a multi-stage pipeline, handling everything from normal observations to encrypted dark signals requiring AI-powered decryption and translation.

### System Capabilities

✅ **Level 1**: Intelligent signal classification and routing  
✅ **Level 2**: Observation storage in DynamoDB and OpenSearch  
✅ **Level 3**: Rare creature detection and tracking  
✅ **Level 4**: Encrypted message decryption using S3-stored cipher keys  
✅ **Level 5**: AI-powered language detection and translation with Discord notifications

### Technology Stack

**AWS Services:**  
EventBridge • Lambda (Node.js 20.x) • SNS • SQS • DynamoDB • OpenSearch • S3 • Comprehend • Translate • CloudWatch

**Infrastructure:**  
CloudFormation with AWS SAM

---

## 🚀 Quick Start

### 1. Install Prerequisites

#### AWS CLI

Installation files:
- [Windows](https://awscli.amazonaws.com/AWSCLIV2.msi)
- [MacOS](https://awscli.amazonaws.com/AWSCLIV2.pkg)
- [Linux](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html)

After installation, configure with your credentials:

```bash
aws configure
```

#### AWS SAM (Optional but Recommended)

Installation guides:
- [Windows](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-install-windows.html)
- [MacOS](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-install-mac.html)
- [Linux](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-install-linux.html)

#### Node.js and NPM

[Download Node.js](https://nodejs.org/en/download/) (includes NPM)

### 2. Configure Your Team

Edit these files and replace `[TEAMNAME]` with your team name (no spaces):

**Available Teams:**  
GoPowerRanger • Hydra • MaranzasDiBrugge • OTR • Samoth • SecurityMobistar • SuperHacker • WeCantC

Files to update:
- `deployStudent.ps1` or `deployStudent.sh`
- `cfn-students.yaml` (TeamName parameter)

### 3. Install Dependencies

```bash
cd src/fn-signal-classifier && npm install && cd ../..
cd src/fn-observation-ingest && npm install && cd ../..
cd src/fn-dark-signal-decipherer && npm install && cd ../..
cd src/fn-message-translator && npm install && cd ../..
```

### 4. Deploy to AWS

**PowerShell (Windows):**

```powershell
.\deployStudent.ps1
```

**Bash (Linux/Mac/WSL):**

```bash
bash deployStudent.sh
```

---

## 🧪 Testing the System

We provide comprehensive PowerShell test scripts with colored output and step-by-step explanations.

### Complete Demo Suite

Run all levels in sequence:

```powershell
.\test-all-levels.ps1
```

### Individual Level Tests

```powershell
# Level 1: Normal observation (creature sighting)
.\test-level1-observation.ps1

# Level 2: High-intensity alert (hazard detection)
.\test-level1-alert.ps1

# Level 3: Rare creature detection
.\test-level3-rare-creature.ps1

# Level 4-5: Complete dark signal pipeline (decrypt + translate)
.\test-level4-dark-signal.ps1
```

### Verify Results

```powershell
# Check stored DynamoDB data
.\test-check-dynamodb.ps1

# Check CloudWatch logs
aws logs tail /aws/lambda/HTF25-SignalClassifier --since 2m --follow
aws logs tail /aws/lambda/HTF25-ObservationIngest --since 2m --follow
aws logs tail /aws/lambda/HTF25-DarkSignalDecipherer --since 2m --follow
aws logs tail /aws/lambda/HTF25-MessageTranslator --since 2m --follow
```

---

## 📋 Challenge Levels

### Level 1 - Signal Classifier

**Objective:** Classify incoming EventBridge sonar events and route to appropriate SNS topics

**Classification Logic:**
- Missing required fields or `type='dark-signal'` → **dark-signal**
- `intensity >= 80` → **alert**
- `type='rare-creature'` and `intensity >= 30` → **rare-observation**
- Otherwise → **observation**

**Test:** `.\test-level1-observation.ps1`

[📖 Detailed Documentation](./src/fn-signal-classifier/README.md)

### Level 2 & 3 - Observation Ingest

**Objective:** Store sonar observations in DynamoDB and index high-intensity alerts in OpenSearch

**Storage Strategy:**
- All observations → DynamoDB (permanent record)
- Alerts with `intensity >= 80` → OpenSearch (real-time alerting)

**Tests:**
- Level 2: `.\test-level1-alert.ps1`
- Level 3: `.\test-level3-rare-creature.ps1`

[📖 Detailed Documentation](./src/fn-observation-ingest/README.md)

### Level 4 - Dark Signal Decipherer

**Objective:** Decrypt encrypted messages using substitution cipher with S3-stored keys

**Decryption Process:**
1. Base64 decode payload
2. Extract `kid` (key ID) and cipher text
3. Fetch key mapping from S3 (`keys.xml`)
4. Apply character-by-character substitution
5. Send decrypted message to SQS

**Example:**  
`Qbbb Xffbzb` → `Dove sei` (Italian: "Where are you")

**Test:** `.\test-level4-dark-signal.ps1`

[📖 Detailed Documentation](./src/fn-dark-signal-decipherer/README.md)

### Level 5 - Message Translator

**Objective:** Translate decrypted messages and post to Discord

**Translation Process:**
1. Poll SQS queue for decrypted messages
2. Detect language using AWS Comprehend
3. Translate to English using AWS Translate
4. POST formatted message to Discord webhook

**Example:**  
Italian: `Dove sei` → English: `Where are you`

**Test:** `.\test-level4-dark-signal.ps1` (includes Level 5)

[📖 Detailed Documentation](./src/fn-message-translator/README.md)

---

## 🏗️ Architecture Highlights

### Event-Driven Design

Uses AWS EventBridge as the central event bus, enabling:
- Loose coupling between components
- Easy addition of new event processors
- Serverless scalability

### SNS Message Filtering

Intelligent routing without complex Lambda logic:
- **Observation Ingest** subscribes with: `messageType IN ['observation', 'alert', 'rare-observation']`
- **Dark Signal Decipherer** subscribes with: `messageType = 'dark-signal'`

### Decoupled Processing

SQS queue between decryption and translation provides:
- ✅ Fault tolerance (automatic retries)
- ✅ Independent scaling (handle translation spikes)
- ✅ Message durability (no data loss)
- ✅ Testability (inject messages directly)

### AI Integration

AWS Comprehend and Translate enable:
- Automatic language detection (100+ languages)
- High-quality neural machine translation
- Support for international teams

---

## 📖 Documentation

Comprehensive VitePress documentation is available in the `docs/` directory.

### Start Documentation Server

```bash
cd docs
npm install
npm run docs:dev
```

Open http://localhost:5173 in your browser.

### Documentation Structure

- **Architecture**: System overview, event flow diagrams, AWS services guide
- **Implementation**: Detailed guides for each level
- **Deployment**: Setup, configuration, troubleshooting
- **Presentation**: Demo script, Q&A preparation, innovation highlights
- **Reflection**: Learning journey, AWS mastery, AI usage, pitfalls and solutions

### Key Documentation Files

- **[Demo Script](./docs/presentation/demo-script.md)** - Complete 7-minute presentation guide
- **[Reflection & Learning](./docs/presentation/reflection-and-learning.md)** - Comprehensive learning journey documentation
- **[Reflection Presentation Script](./docs/presentation/reflection-presentation-script.md)** - Detailed script for presenting your learning journey
- **[Event Flow Diagrams](./docs/architecture/event-flow.md)** - Visual representation of all 5 levels
- **[Architecture Overview](./docs/architecture/overview.md)** - Deep dive into system design

---

## 🎨 Project Structure

```
HTF-2025/
├── src/                           # Lambda function source code
│   ├── fn-signal-classifier/      # Level 1: Routes events
│   ├── fn-observation-ingest/     # Level 2-3: Stores data
│   ├── fn-dark-signal-decipherer/ # Level 4: Decrypts messages
│   └── fn-message-translator/     # Level 5: Translates & notifies
├── payloads/                      # Test event payloads (JSON)
├── docs/                          # VitePress documentation
│   ├── architecture/              # System design docs
│   ├── implementation/            # Level guides
│   ├── deployment/                # Setup guides
│   └── presentation/              # Demo scripts
├── test-*.ps1                     # PowerShell test scripts
├── cfn-students.yaml              # CloudFormation template
├── deployStudent.sh               # Bash deployment script
├── deployStudent.ps1              # PowerShell deployment script
└── README.md                      # This file
```

---

## 🚨 Troubleshooting

### Lambda Deployment Fails

```bash
# Check AWS credentials
aws configure list

# Verify AWS CLI is working
aws sts get-caller-identity
```

- Ensure team name is correct in `cfn-students.yaml` and deploy scripts
- Verify all npm packages are installed

### Discord Webhook Not Working

- Check webhook URL is correct
- Verify Lambda environment variable: `DISCORD_WEBHOOK_URL`
- Test webhook directly:

```bash
curl -X POST -H "Content-Type: application/json" \
  -d '{"content":"Test message"}' \
  YOUR_WEBHOOK_URL
```

### DynamoDB Permission Errors

- Ensure Lambda execution role has `dynamodb:PutItem` permission
- Check CloudFormation stack IAM role configuration
- Review CloudWatch logs for specific error messages

### OpenSearch Permission Errors

- This is expected in some deployments
- System continues to work with DynamoDB storage
- Non-critical for hackathon success

### @smithy/url-parser Module Not Found

**Solution:**

❌ Do NOT manually add `@smithy` packages to package.json  
✅ Let AWS SDK manage its own dependencies  
✅ Use AWS SDK v3 official packages only

This was fixed in our deployment by removing manual `@smithy` dependencies.

---

## 💡 Best Practices

### Rate Limits

We're using free tiers of various AWS services:
- Be careful with loops or short intervals
- Avoid excessive event sending
- Monitor CloudWatch metrics

### Multiple Accounts

If you hit rate limits:
- Each team member can create separate AWS accounts
- Swap credentials to continue testing
- Keep backup credentials ready

### Discord Webhook

Set your Discord webhook URL:

```powershell
# PowerShell
$env:DISCORD_WEBHOOK_URL = "https://discord.com/api/webhooks/your-url"
```

Or update Lambda environment variables in `cfn-students.yaml`.

---

## 🛠️ Local Development (Requires Docker)

Test Lambda functions locally with SAM:

```bash
# Signal Classifier
sam local invoke Challenge1Lambda \
  --event ./payloads/signal-classifier.json \
  -t cfn-students.yaml

# Observation Ingest
sam local invoke Challenge2Lambda \
  --event ./payloads/observation-ingest.json \
  -t cfn-students.yaml

# Dark Signal Decipherer
sam local invoke Challenge4Lambda \
  --event ./payloads/dark-signal-decipherer.json \
  -t cfn-students.yaml

# Message Translator
sam local invoke Challenge5Lambda \
  --event ./payloads/message-translator.json \
  -t cfn-students.yaml
```

---

## 🎓 Team Information

- **Team Name**: [Your Team Name]
- **Challenge**: Serverless Ocean Exploration Platform
- **Hackathon**: Hack The Future 2025

---

## 📞 Support & Resources

### Getting Help

1. Check comprehensive documentation in `docs/`
2. Review CloudWatch logs for error details
3. Run `.\test-check-dynamodb.ps1` to verify data storage
4. Consult `docs/presentation/demo-script.md` for demo guidance

### Useful Commands

```powershell
# List all Lambda functions
aws lambda list-functions --query 'Functions[?starts_with(FunctionName, `HTF25`)].FunctionName'

# Check EventBridge bus
aws events list-event-buses --query 'EventBuses[?Name==`HTF25-EventBridge-EventBus`]'

# Describe DynamoDB table
aws dynamodb describe-table --table-name HTF25-SuperHacker-Challenge2DynamoDB-1S4KV8EJIY020

# Clear test data (start fresh)
.\test-check-dynamodb.ps1  # Shows delete command
```

---

## 🏆 Innovation Highlights

### 1. Intelligent Message Routing

SNS message attributes enable clean routing without complex Lambda logic.

### 2. Custom Substitution Cipher

Manual implementation demonstrating cryptography understanding without external libraries.

### 3. Decoupled Architecture

SQS queue provides fault tolerance and independent scaling.

### 4. Comprehensive Testing Suite

Professional PowerShell scripts with:
- Colored console output
- Step-by-step flow explanations
- Built-in verification commands
- Production-ready error handling

### 5. Complete Documentation

VitePress documentation with:
- Mermaid diagrams for visualization
- Detailed architecture explanations
- Demo scripts for presentations
- Q&A preparation

---

Built with passion, AWS serverless technologies, and a love for ocean exploration 🌊

**Good luck with your hackathon! 🚀**
