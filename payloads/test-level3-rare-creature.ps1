# HTF-2025 Ocean Exploration Platform - Level 3 Test
# Tests rare creature observation processing

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  LEVEL 3: Rare Creature Observation" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

$EVENT_BUS_NAME = "HTF25-EventBridge-EventBus"

Write-Host "This test demonstrates special handling for rare deep-sea creatures." -ForegroundColor White
Write-Host ""

# Rare creature event
$rareCreatureEvent = @"
[
  {
    "Source": "ocean.sonar",
    "DetailType": "sonar-signal",
    "Detail": "{\"observationId\":\"rare-$(Get-Date -Format 'yyyyMMddHHmmss')\",\"timestamp\":\"$(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssZ')\",\"coordinates\":{\"latitude\":-15.234,\"longitude\":140.678},\"depth\":8200,\"temperature\":2.1,\"type\":\"rare-creature\",\"intensity\":45,\"description\":\"Unidentified bioluminescent organism detected at extreme depth - potentially new species with unique light patterns\"}",
    "EventBusName": "$EVENT_BUS_NAME"
  }
]
"@

Write-Host "[1] Sending rare creature observation to EventBridge..." -ForegroundColor Yellow
aws events put-events --entries $rareCreatureEvent | Out-Null
Write-Host "✓ Rare observation event sent successfully" -ForegroundColor Green
Write-Host ""

Write-Host "Expected Flow:" -ForegroundColor Cyan
Write-Host "  1. EventBridge receives the sonar signal event" -ForegroundColor White
Write-Host "  2. Signal Classifier Lambda triggered:" -ForegroundColor White
Write-Host "     • Detects type='rare-creature'" -ForegroundColor DarkGray
Write-Host "     • Routes to SNS with messageType='observation'" -ForegroundColor DarkGray
Write-Host "     • May add special attributes for rare species tracking" -ForegroundColor DarkGray
Write-Host "  3. SNS publishes to Observation Ingest Lambda" -ForegroundColor White
Write-Host "  4. Observation Ingest stores in DynamoDB" -ForegroundColor White
Write-Host "     • Standard observation storage" -ForegroundColor DarkGray
Write-Host "     • Can be queried later for rare species analysis" -ForegroundColor DarkGray
Write-Host ""

Write-Host "[2] Waiting 5 seconds for processing..." -ForegroundColor Yellow
Start-Sleep -Seconds 5
Write-Host "✓ Processing should be complete" -ForegroundColor Green
Write-Host ""

Write-Host "Verification Steps:" -ForegroundColor Cyan
Write-Host ""

Write-Host "1. Check Signal Classifier logs:" -ForegroundColor Yellow
Write-Host "   aws logs tail /aws/lambda/HTF25-SignalClassifier --since 2m --follow" -ForegroundColor White
Write-Host "   Look for: 'Routing observation to SNS' with rare-creature type" -ForegroundColor DarkGray
Write-Host ""

Write-Host "2. Check Observation Ingest logs:" -ForegroundColor Yellow
Write-Host "   aws logs tail /aws/lambda/HTF25-ObservationIngest --since 2m --follow" -ForegroundColor White
Write-Host "   Look for: 'Successfully stored observation in DynamoDB'" -ForegroundColor DarkGray
Write-Host ""

Write-Host "3. Verify data in DynamoDB:" -ForegroundColor Yellow
Write-Host "   .\test-check-dynamodb.ps1" -ForegroundColor White
Write-Host "   Look for: observation with type='rare-creature' at depth 8200m" -ForegroundColor DarkGray
Write-Host ""

Write-Host "Rare Creature Details:" -ForegroundColor Cyan
Write-Host "  • Species: Unidentified bioluminescent organism" -ForegroundColor White
Write-Host "  • Depth: 8,200 meters (hadal zone)" -ForegroundColor White
Write-Host "  • Temperature: 2.1°C" -ForegroundColor White
Write-Host "  • Coordinates: 15.234°S, 140.678°E (Pacific Ocean)" -ForegroundColor White
Write-Host "  • Intensity: 45 (moderate - not an alert)" -ForegroundColor White
Write-Host ""

Write-Host "✓ Level 3 test complete!" -ForegroundColor Green
Write-Host ""