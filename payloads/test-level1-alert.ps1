# Test Level 1: Signal Classification - High Intensity Alert
# This test sends a hazard with high intensity that should be classified as "alert"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Testing Level 1: Signal Classification" -ForegroundColor Cyan
Write-Host "Type: High-Intensity Hazard Alert" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$payload = @'
[
    {
        "Source": "HTF25",
        "DetailType": "ToBeUsedBy-SuperHacker",
        "Detail": "{\"type\":\"hazard\",\"species\":\"Unknown Anomaly\",\"location\":\"trench-9\",\"intensity\":8}",
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
    Write-Host "  3. Classified as 'alert' (hazard, intensity >= 2)" -ForegroundColor White
    Write-Host "  4. Published to SNS with message attribute 'alert'" -ForegroundColor White
    Write-Host "  5. Observation Ingest Lambda tries to index in OpenSearch" -ForegroundColor White
    Write-Host ""
    Write-Host "Note: OpenSearch indexing may fail (403) if permissions not configured" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Checking logs in 5 seconds..." -ForegroundColor Yellow
    Start-Sleep -Seconds 5
    Write-Host ""
    Write-Host "Observation Ingest Logs:" -ForegroundColor Cyan
    aws logs tail /aws/lambda/HTF25-SuperHacker-SonarObservationIngest --since 1m
} else {
    Write-Host "✗ Failed to send event" -ForegroundColor Red
    Write-Host $result | ConvertTo-Json
}
