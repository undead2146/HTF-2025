# Test Level 4 & 5: Dark Signal Deciphering and Message Translation
# This test sends an encrypted dark signal that will be decrypted and translated

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Testing Level 4 & 5: Dark Signal Processing" -ForegroundColor Cyan
Write-Host "Encrypted Message: 'so dove ti trovi' (Italian)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$payload = @'
[
    {
        "Source": "HTF25",
        "DetailType": "ToBeUsedBy-SuperHacker",
        "Detail": "{\"type\":\"dark-signal\",\"originalPayload\":{\"data\":\"eyJhbGciOiJzdWJzdGl0dXRpb24tY2lwaGVyIiwia2lkIjoiOWU4ZDdjNmItNWE0Zi00ZTNkLThjMmItMWEwZjllOGQ3YzZiIiwiY2lwaGVyIjoidmYgYWZlaCBteiBtY2ZleiJ9\",\"species\":\"creature\",\"location\":\"lagoon-east\"}}",
        "EventBusName": "HTF25-EventBridge-EventBus"
    }
]
'@

Write-Host "Sending encrypted dark signal to EventBridge..." -ForegroundColor Yellow
$result = aws events put-events --entries $payload | ConvertFrom-Json

if ($result.FailedEntryCount -eq 0) {
    Write-Host "✓ Event sent successfully!" -ForegroundColor Green
    Write-Host "Event ID: $($result.Entries[0].EventId)" -ForegroundColor Green
    Write-Host ""
    Write-Host "Expected Flow:" -ForegroundColor Cyan
    Write-Host "  1. EventBridge receives encrypted dark signal" -ForegroundColor White
    Write-Host "  2. Signal Classifier detects dark-signal type" -ForegroundColor White
    Write-Host "  3. Published to SNS with message attribute 'dark-signal'" -ForegroundColor White
    Write-Host "  4. Dark Signal Decipherer Lambda triggered" -ForegroundColor White
    Write-Host "     - Base64 decodes the payload" -ForegroundColor Gray
    Write-Host "     - Fetches cipher key from S3" -ForegroundColor Gray
    Write-Host "     - Decrypts using substitution cipher" -ForegroundColor Gray
    Write-Host "     - Result: 'so dove ti trovi' (Italian)" -ForegroundColor Gray
    Write-Host "  5. Sends decrypted message to SQS" -ForegroundColor White
    Write-Host "  6. Message Translator Lambda triggered" -ForegroundColor White
    Write-Host "     - Detects language with AWS Comprehend" -ForegroundColor Gray
    Write-Host "     - Translates to English with AWS Translate" -ForegroundColor Gray
    Write-Host "     - Result: 'where are you'" -ForegroundColor Gray
    Write-Host "  7. Posts to Discord webhook" -ForegroundColor White
    Write-Host "     - Format: '**SuperHacker**: so dove ti trovi -> where are you (lang: it)'" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Waiting 10 seconds for processing..." -ForegroundColor Yellow
    Start-Sleep -Seconds 10
    Write-Host ""
    Write-Host "Dark Signal Decipherer Logs:" -ForegroundColor Cyan
    aws logs tail /aws/lambda/HTF25-SuperHacker-DarkSignalDecipherer --since 1m
    Write-Host ""
    Write-Host "Message Translator Logs:" -ForegroundColor Cyan
    aws logs tail /aws/lambda/HTF25-SuperHacker-MessageTranslator --since 1m
    Write-Host ""
    Write-Host "Check your Discord channel for the translated message!" -ForegroundColor Green
} else {
    Write-Host "✗ Failed to send event" -ForegroundColor Red
    Write-Host $result | ConvertTo-Json
}
