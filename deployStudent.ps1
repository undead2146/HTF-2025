# Load environment variables from .env file if it exists
if (Test-Path .env) {
    Get-Content .env | ForEach-Object {
        if ($_ -match '^(.*?)=(.*)$') {
            $name = $matches[1]
            $value = $matches[2] -replace '^"|"$'
            Set-Item -Path "env:$name" -Value $value
        }
    }
}

# Check if webhook URL is provided as environment variable
if (-not $env:WEBHOOK_URL) {
    $env:WEBHOOK_URL = Read-Host "Discord Webhook URL"
}

# Set variables
$STACK_NAME = "HTF25-SuperHacker"
$MY_REGION = "eu-central-1"
$MY_DEV_BUCKET = "htf25-cfn-bucket"
$AWS_PROFILE = "default"

Write-Host "Packaging CloudFormation template..."
aws cloudformation package --template ./cfn-students.yaml --s3-bucket $MY_DEV_BUCKET --output-template ./cfn-students-export.yaml

Write-Host "Deploying stack..."
sam deploy --template-file ./cfn-students-export.yaml --stack-name $STACK_NAME --capabilities CAPABILITY_NAMED_IAM --region $MY_REGION --parameter-overrides WebhookURL=$env:WEBHOOK_URL

Write-Host "Deployment complete!"
