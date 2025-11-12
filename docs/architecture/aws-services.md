# AWS Services Guide

## EventBridge

**Purpose**: Serverless event bus for routing events between services.

**Usage in Our System**:
- Receives sonar signals from the HTF event source
- Routes events to the Signal Classifier Lambda based on patterns
- Custom event bus: `HTF25-EventBridge-EventBus`

**Key Features**:
- Pattern matching with source and detail-type
- High throughput and low latency
- Integration with 200+ AWS services

## Lambda

**Purpose**: Serverless compute service running code in response to events.

**Functions in Our System**:
- `HTF25-{TeamName}-SonarSignalClassifier`
- `HTF25-{TeamName}-SonarObservationIngest`
- `HTF25-{TeamName}-DarkSignalDecipherer`
- `HTF25-{TeamName}-MessageTranslator`

**Configuration**:
- Runtime: Node.js 20.x
- Timeout: 10 seconds
- Tracing: Active (X-Ray)

## SNS (Simple Notification Service)

**Purpose**: Pub/sub messaging service for fan-out messaging.

**Usage**:
- Single topic receives classified signals
- Two Lambda subscriptions: Observation Ingest and Dark Signal Decipherer
- Message attributes used for routing logic

## SQS (Simple Queue Service)

**Purpose**: Decoupled message queuing for reliable processing.

**Usage**:
- Receives decrypted dark signals
- Triggers Message Translator Lambda
- Standard queue with batch size 1

## DynamoDB

**Purpose**: NoSQL database for fast, flexible data storage.

**Table Schema**:
- Partition Key: `team` (String)
- Sort Key: `id` (String)
- Attributes: species, location, intensity, timestamp, type

**Usage**: Stores observation and rare-observation events

## OpenSearch

**Purpose**: Search and analytics engine for real-time data exploration.

**Usage**: Indexes alert events for dashboard visualization

**Endpoint**: `https://s6tkjpxuugo2q82i4z3d.eu-central-1.aoss.amazonaws.com`

## S3

**Purpose**: Object storage service.

**Usage**: Stores cipher keys for decryption

**Bucket**: `htf-2025-cipher-keys`

**Key Format**: `keys/{kid}.json` (but actually XML at root)

## Comprehend

**Purpose**: Natural language processing service.

**Usage**: Detects dominant language of decrypted messages

## Translate

**Purpose**: Text translation service.

**Usage**: Translates non-English messages to English

## CloudWatch

**Purpose**: Monitoring and observability service.

**Usage**:
- Logs from all Lambda functions
- Metrics and alarms
- X-Ray traces for performance monitoring
