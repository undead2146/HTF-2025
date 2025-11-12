# HTF-2025 Ocean Exploration Platform - DynamoDB Data Verification
# This script checks what data is currently stored in DynamoDB

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  DynamoDB Data Verification" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

$TABLE_NAME = "HTF25-SuperHacker-Challenge2DynamoDB-1S4KV8EJIY020"

Write-Host "Scanning DynamoDB table: $TABLE_NAME" -ForegroundColor Yellow
Write-Host ""

# Scan the table and format output
aws dynamodb scan --table-name $TABLE_NAME --output json | ConvertFrom-Json | ForEach-Object {
    Write-Host "Found $($_.Count) items in DynamoDB:" -ForegroundColor Green
    Write-Host ""
    
    $_.Items | ForEach-Object {
        Write-Host "----------------------------------------" -ForegroundColor DarkGray
        Write-Host "Observation ID: $($_.observationId.S)" -ForegroundColor Yellow
        Write-Host "Timestamp: $($_.timestamp.S)" -ForegroundColor White
        Write-Host "Type: $($_.type.S)" -ForegroundColor White
        Write-Host "Coordinates: ($($_.coordinates.M.latitude.N), $($_.coordinates.M.longitude.N))" -ForegroundColor White
        Write-Host "Depth: $($_.depth.N) meters" -ForegroundColor White
        Write-Host "Temperature: $($_.temperature.N)°C" -ForegroundColor White
        Write-Host "Intensity: $($_.intensity.N)" -ForegroundColor White
        Write-Host "Description: $($_.description.S)" -ForegroundColor White
        Write-Host ""
    }
}

Write-Host "`nTo delete all test data and start fresh, run:" -ForegroundColor Cyan
Write-Host "aws dynamodb scan --table-name $TABLE_NAME --attributes-to-get observationId --output json | ConvertFrom-Json | ForEach-Object { `$_.Items | ForEach-Object { aws dynamodb delete-item --table-name $TABLE_NAME --key '{\"observationId\":{\"S\":\"'+ `$_.observationId.S +'\"}}'} }" -ForegroundColor DarkGray
Write-Host ""