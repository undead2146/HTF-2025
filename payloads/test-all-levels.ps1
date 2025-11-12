# HTF-2025 Ocean Exploration Platform - Complete Demo Suite
# This script demonstrates all levels of the platform in sequence

param(
    [switch]$SkipWait
)

$EVENT_BUS_NAME = "HTF25-EventBridge-EventBus"
$WAIT_TIME = if ($SkipWait) { 2 } else { 5 }

function Show-Header {
    param($Title)
    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host "  $Title" -ForegroundColor Cyan
    Write-Host "========================================`n" -ForegroundColor Cyan
}

function Show-Step {
    param($Number, $Description)
    Write-Host "[$Number] $Description" -ForegroundColor Yellow
}

function Show-Success {
    param($Message)
    Write-Host "✓ $Message" -ForegroundColor Green
}

function Wait-ForProcessing {
    param($Seconds)
    Write-Host "`nWaiting $Seconds seconds for processing..." -ForegroundColor DarkGray
    Start-Sleep -Seconds $Seconds
}

# =============================================================================
# LEVEL 1: Normal Observation
# =============================================================================
Show-Header "LEVEL 1: Normal Observation Processing"

Write-Host "Testing a standard creature observation..." -ForegroundColor White
Write-Host "This will flow through:" -ForegroundColor White
Write-Host "  EventBridge → Signal Classifier → SNS → Observation Ingest → DynamoDB" -ForegroundColor DarkGray
Write-Host ""

$observationPayload = Get-Content "payloads/observation-ingest.json" -Raw

Show-Step 1 "Sending normal observation event to EventBridge..."
aws events put-events --entries $observationPayload | Out-Null
Show-Success "Event sent successfully"

Wait-ForProcessing $WAIT_TIME

Show-Step 2 "Check CloudWatch logs:"
Write-Host "  Signal Classifier: aws logs tail /aws/lambda/HTF25-SuperHacker-SonarSignalClassifier --since 2m --follow" -ForegroundColor DarkGray
Write-Host "  Observation Ingest: aws logs tail /aws/lambda/HTF25-SuperHacker-SonarObservationIngest --since 2m --follow" -ForegroundColor DarkGray

# =============================================================================
# LEVEL 2: High-Intensity Alert
# =============================================================================
Show-Header "LEVEL 2: High-Intensity Alert Processing"

Write-Host "Testing a hazardous hydrothermal vent alert..." -ForegroundColor White
Write-Host "This will flow through:" -ForegroundColor White
Write-Host "  EventBridge → Signal Classifier → SNS → Observation Ingest → DynamoDB + OpenSearch" -ForegroundColor DarkGray
Write-Host ""

$alertEvent = @'
[
  {
    "Source": "ocean.sonar",
    "DetailType": "sonar-signal",
    "Detail": "{\"observationId\":\"alert-demo-001\",\"timestamp\":\"2025-12-11T14:30:00Z\",\"coordinates\":{\"latitude\":-23.5,\"longitude\":-45.8},\"depth\":2800,\"temperature\":380.5,\"type\":\"hydrothermal-vent\",\"intensity\":95,\"description\":\"Extremely hazardous hydrothermal activity detected - immediate alert\"}",
    "EventBusName": "HTF25-EventBridge-EventBus"
  }
]
'@

Show-Step 1 "Sending high-intensity alert to EventBridge..."
aws events put-events --entries $alertEvent | Out-Null
Show-Success "Alert sent successfully"

Wait-ForProcessing $WAIT_TIME

Show-Step 2 "This alert has intensity=95, which triggers OpenSearch indexing"
Write-Host "  (Note: OpenSearch may have permission issues, but DynamoDB storage will succeed)" -ForegroundColor DarkGray

# =============================================================================
# LEVEL 3: Rare Creature Observation
# =============================================================================
Show-Header "LEVEL 3: Rare Creature Observation"

Write-Host "Testing a rare deep-sea creature sighting..." -ForegroundColor White
Write-Host "This demonstrates special handling for rare species." -ForegroundColor White
Write-Host ""

$rareCreatureEvent = @'
[
  {
    "Source": "ocean.sonar",
    "DetailType": "sonar-signal",
    "Detail": "{\"observationId\":\"rare-demo-001\",\"timestamp\":\"2025-12-11T14:31:00Z\",\"coordinates\":{\"latitude\":-15.2,\"longitude\":140.7},\"depth\":8200,\"temperature\":2.1,\"type\":\"rare-creature\",\"intensity\":45,\"description\":\"Unidentified bioluminescent organism - potentially new species\"}",
    "EventBusName": "HTF25-EventBridge-EventBus"
  }
]
'@

Show-Step 1 "Sending rare creature observation to EventBridge..."
aws events put-events --entries $rareCreatureEvent | Out-Null
Show-Success "Rare observation sent successfully"

Wait-ForProcessing $WAIT_TIME

# =============================================================================
# LEVEL 4: Dark Signal Processing
# =============================================================================
Show-Header "LEVEL 4: Dark Signal Decryption and Translation"

Write-Host "Testing encrypted dark signal processing..." -ForegroundColor White
Write-Host "This will flow through the complete pipeline:" -ForegroundColor White
Write-Host "  EventBridge → Signal Classifier → SNS → Dark Signal Decipherer" -ForegroundColor DarkGray
Write-Host "  → SQS → Message Translator → Discord Webhook" -ForegroundColor DarkGray
Write-Host ""

$darkSignalPayload = Get-Content "payloads/dark-signal-decipherer.json" -Raw

Show-Step 1 "Sending encrypted dark signal to EventBridge..."
aws events put-events --entries $darkSignalPayload | Out-Null
Show-Success "Dark signal sent successfully"

Wait-ForProcessing $WAIT_TIME

Show-Step 2 "Dark Signal Decipherer will:"
Write-Host "  • Fetch cipher keys from S3 (keys.xml)" -ForegroundColor White
Write-Host "  • Decrypt the message using substitution cipher" -ForegroundColor White
Write-Host "  • Send decrypted message to SQS queue" -ForegroundColor White

Wait-ForProcessing $WAIT_TIME

Show-Step 3 "Message Translator will:"
Write-Host "  • Detect language using AWS Comprehend" -ForegroundColor White
Write-Host "  • Translate to English using AWS Translate" -ForegroundColor White
Write-Host "  • Post to Discord webhook" -ForegroundColor White

Show-Success "Check your Discord channel for the translated message!"

# =============================================================================
# VERIFICATION
# =============================================================================
Show-Header "Verification and Next Steps"

Write-Host "To verify all data was stored correctly:" -ForegroundColor Yellow
Write-Host "  .\test-check-dynamodb.ps1" -ForegroundColor White
Write-Host ""

Write-Host "To check CloudWatch logs for any specific function:" -ForegroundColor Yellow
Write-Host "  aws logs tail /aws/lambda/HTF25-SuperHacker-SonarSignalClassifier --since 5m --follow" -ForegroundColor White
Write-Host "  aws logs tail /aws/lambda/HTF25-SuperHacker-SonarObservationIngest --since 5m --follow" -ForegroundColor White
Write-Host "  aws logs tail /aws/lambda/HTF25-SuperHacker-DarkSignalDecipherer --since 5m --follow" -ForegroundColor White
Write-Host "  aws logs tail /aws/lambda/HTF25-SuperHacker-MessageTranslator --since 5m --follow" -ForegroundColor White
Write-Host ""

Show-Success "Complete demo suite finished!"
Write-Host ""
