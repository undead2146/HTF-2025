# Level 2 & 3: Observation Ingest

## Overview

The Observation Ingest Lambda processes SNS messages containing classified sonar events. It stores observations in DynamoDB and indexes alerts in OpenSearch.

## Input Message Structure

SNS message received:

```json
{
  "Type": "Notification",
  "MessageId": "uuid",
  "TopicArn": "arn:aws:sns:...",
  "Message": "{\"type\":\"anomaly\",\"species\":\"Spectral Bloom\",\"location\":\"reef-3\",\"intensity\":1}",
  "Timestamp": "2025-11-10T21:23:05.948Z",
  "MessageAttributes": {
    "type": {
      "Type": "String",
      "Value": "observation"
    }
  }
}
```

## Processing Logic

Based on `MessageAttributes.type.Value`:

- `observation` or `rare-observation` → Store in DynamoDB
- `alert` → Index in OpenSearch

## DynamoDB Storage

**Table**: `htf-2025-sonar-observations`

**Item Structure**:
```json
{
  "id": "SNS-MessageId",
  "team": "TeamName",
  "species": "Spectral Bloom",
  "location": "reef-3",
  "intensity": 1,
  "timestamp": "2025-11-10T21:23:05.948Z",
  "type": "observation"
}
```

**Key Schema**:
- Partition Key: `team` (String)
- Sort Key: `id` (String)

## OpenSearch Indexing

**Index**: `{TeamName}` (lowercased)

**Document Structure**:
```json
{
  "id": "SNS-MessageId",
  "team": "TeamName",
  "species": "Spectral Bloom",
  "location": "reef-3",
  "intensity": 1,
  "timestamp": "2025-11-10T21:23:05.948Z",
  "type": "alert"
}
```

**Endpoint**: `https://s6tkjpxuugo2q82i4z3d.eu-central-1.aoss.amazonaws.com`

## Error Handling

- DynamoDB conditional writes prevent duplicates
- OpenSearch indexing failures are logged
- Lambda retries on transient failures
