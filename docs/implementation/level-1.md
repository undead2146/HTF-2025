# Level 1: Signal Classifier

## Overview

The Signal Classifier Lambda is the entry point of our system. It receives EventBridge events containing sonar observations, validates the required fields, classifies each event based on type and intensity, and publishes to the appropriate SNS topic.

## Input Event Structure

```json
{
  "version": "0",
  "id": "event-uuid",
  "detail-type": "ToBeUsedBy-{TeamName}",
  "source": "HTF25",
  "time": "2025-11-10T21:13:05Z",
  "region": "eu-central-1",
  "detail": {
    "type": "anomaly",
    "species": "Spectral Bloom",
    "location": "reef-3",
    "intensity": 1
  }
}
```

## Validation Rules

**Required Fields**: `type`, `species`, `location`, `intensity`

- If any required field is missing → classify as `dark-signal`
- Otherwise → classify based on type and intensity

## Classification Logic

| Type | Intensity Condition | Classification |
|------|-------------------|----------------|
| creature | < 3 | observation |
| creature | >= 3 | rare-observation |
| hazard | >= 2 | alert |
| anomaly | >= 2 | alert |
| (fallback) | — | observation |

## Output

Publishes to SNS with:

- **Message Body**: Original event detail
- **Message Attributes**:
  - `type`: classification result (String)

## Error Handling

- Invalid events are logged but still processed
- Missing fields trigger dark-signal routing
- SNS publish failures are retried by Lambda
