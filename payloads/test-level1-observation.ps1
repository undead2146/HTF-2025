# Test Level 1: Signal Classification - Normal Observation
# This test sends a creature observation that should be classified as "observation"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Testing Level 1: Signal Classification" -ForegroundColor Cyan
Write-Host "Type: Normal Creature Observation" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$payload = @'
[
    {
        "Source": "HTF25",
        "DetailType": "ToBeUsedBy-SuperHacker",
        "Detail": "{\"type\":\"creature\",\"species\":\"Sea Turtle\",\"location\":\"reef-2\",\"intensity\":2}",
        "EventBusName": "HTF25-EventBridge-EventBus"
    }
]
'@

Write-Host "Sending event to EventBridge..." -ForegroundColor Yellow
$result = aws events put-events --entries $payload | ConvertFrom-Json

if ($result.FailedEntryCount -eq 0) {
    Write-Host "✓ Event sent successfully!" -ForegroundColor Green
    Write-Host "Event ID: $($result.Entries[0].EventId)" -ForegroundColor Green
    Write-Host ""
    Write-Host "Expected Flow:" -ForegroundColor Cyan
    Write-Host "  1. EventBridge receives event" -ForegroundColor White
    Write-Host "  2. Signal Classifier Lambda triggered" -ForegroundColor White
    Write-Host "  3. Classified as 'observation' (creature, intensity < 3)" -ForegroundColor White
    Write-Host "  4. Published to SNS with message attribute 'observation'" -ForegroundColor White
    Write-Host "  5. Observation Ingest Lambda stores in DynamoDB" -ForegroundColor White
    Write-Host ""
    Write-Host "Checking logs in 5 seconds..." -ForegroundColor Yellow
    Start-Sleep -Seconds 5
    Write-Host ""
    Write-Host "Signal Classifier Logs:" -ForegroundColor Cyan
    aws logs tail /aws/lambda/HTF25-SuperHacker-SonarSignalClassifier --since 1m
} else {
    Write-Host "✗ Failed to send event" -ForegroundColor Red
    Write-Host $result | ConvertTo-Json
}
