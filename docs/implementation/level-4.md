# Level 4: Dark Signal Decipherer

## Overview

The Dark Signal Decipherer Lambda processes encrypted dark signals. It decodes base64 payloads, fetches decryption keys from S3, performs monoalphabetic substitution decryption, and forwards plaintext messages to SQS.

## Input Message Structure

SNS message with dark signal:

```json
{
  "Message": "{\"type\":\"dark-signal\",\"originalPayload\":{\"data\":\"eyJhbGciOiJzdWJzdGl0dXRpb24tY2lwaGVyIiwia2lkIjoiOWU4ZDdjNmItNWE0Zi00ZTNkLThjMmItMWEwZjllOGQ3YzZiIiwiY2lwaGVyIjoidmYgYWZlaCBteiBtY2ZleiJ9\",\"species\":\"creature\",\"location\":\"lagoon-east\"}}"
}
```

## Decryption Process

1. **Base64 Decode**: Decode `originalPayload.data`
2. **Parse JSON**: Extract `alg`, `kid`, `cipher`
3. **Validate Algorithm**: Must be `substitution-cipher`
4. **Fetch Key**: Get key from S3 using `kid`
5. **Decrypt**: Apply monoalphabetic substitution
6. **Send to SQS**: Forward plaintext message

## Key Storage

**S3 Bucket**: `htf-2025-cipher-keys`

**Key File**: `keys.xml`

**XML Structure**:
```xml
<keys>
  <key>
    <kid>9e8d7c6b-5a4f-4e3d-8c2b-1a0f9e8d7c6b</kid>
    <cipher>twzocgmpkjsavneryldfxhuqib</cipher>
  </key>
</keys>
```

## Cipher Algorithm

- **Alphabet**: `abcdefghijklmnopqrstuvwxyz`
- **Mapping**: The `cipher` string provides the substitution
- **Example**: If cipher = `qwertyuiopasdfghjklzxcvbnm`
  - `a` → `q`
  - `b` → `w`
  - etc.

## Output

SQS message:

```json
{
  "Message": "decrypted plaintext",
  "TeamName": "YourTeamName"
}
```

## Error Handling

- Invalid base64 or JSON → Skip message
- Unknown algorithm → Skip message
- Missing key → Skip message
- SQS send failures → Lambda retry
