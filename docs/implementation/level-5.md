# Level 5: Message Translator

## Overview

The Message Translator Lambda processes decrypted messages from SQS. It detects the language using AWS Comprehend, translates non-English text to English using AWS Translate, and posts formatted messages to a Discord webhook.

## Input Message Structure

SQS record:

```json
{
  "body": "{\"Message\":\"so dove ti trovi\",\"TeamName\":\"TestTeam\"}",
  "attributes": {
    "ApproximateReceiveCount": "1"
  }
}
```

Parsed body:
```json
{
  "Message": "so dove ti trovi",
  "TeamName": "TestTeam"
}
```

## Processing Steps

1. **Extract Text**: Get `Message` from SQS body
2. **Language Detection**: Use Comprehend to detect dominant language
3. **Translation**: If not English, translate to English
4. **Format Message**: Create Discord webhook payload
5. **Send to Discord**: POST to webhook URL

## Language Detection

**Service**: AWS Comprehend

**API**: `DetectDominantLanguage`

**Input**: Plain text message

**Output**: Language code (e.g., `en`, `it`, `es`)

## Translation

**Service**: AWS Translate

**API**: `TranslateText`

**Parameters**:
- SourceLanguageCode: Detected language
- TargetLanguageCode: `en`
- Text: Original message

## Discord Webhook

**Method**: HTTP POST

**URL**: Configured in environment variable `WEBHOOK_URL`

**Payload**:
```json
{
  "content": "**TestTeam**: so dove ti trovi -> where are you (lang: it)"
}
```

**Format**: `**{TeamName}**: {original} -> {translated} (lang: {lang})`

## Error Handling

- Comprehend/Translate failures → Use original text
- Webhook failures → Lambda retry
- Invalid JSON → Skip message
