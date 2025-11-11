# Sonar Signal Classifier

This Lambda ingests EventBridge events containing sonar observations, validates required fields, classifies each event, and publishes to the appropriate **SNS** topic.
- If **any required fields are missing** → it emits a **dark signal**.
- Otherwise → it routes to the right **observation/alert** topic based on `type` and `intensity`.

---

## Flow

**EventBridge** (source of events) → **Lambda** (this function) → **SNS topics**

### Event Shape
Shape of an incoming event
```json
{
  "id": "event-uuid",
  "detail-type": "creature | hazard | anomaly | dark-signal",
  "source": "htf-2025-aquatopia.sonar-generator",
  "detail": {
    "type": "creature | hazard | anomaly",
    "species": "Sea Turtle",
    "location": "reef-2",
    "intensity": 1
  }
}
```
- Dark signals from upstream may have only `{ "data": "..." }` in `detail`, which will be detected as missing required fields. These need to be translated later on:
```json
{
  "type": "dark-signal",
  "originalPayload": { /* original detail */ }
}
```

### Routing Rules

| type       | intensity condition | type              |
| ---------- | ------------------- | ------------------ |
| creature   | < 3               | `observation`      |
| creature   | >= 3              | `rare-observation` |
| hazard     | >= 2              | `alert`            |
| anomaly    | >= 2              | `alert`            |
| (fallback) | —                   | `observation`      |

**Dark signals** (any missing required field) → `dark-signals`
