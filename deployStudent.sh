#!/bin/bash
STACK_NAME="HTF25-SuperHacker"
MY_REGION="eu-central-1"
MY_DEV_BUCKET="htf25-cfn-bucket"

AWS_PROFILE="default"

# Load environment variables from .env file if it exists
if [ -f .env ]; then
    source .env
fi

# Check if webhook URL is provided as environment variable
if [ -z "$WEBHOOK_URL" ]; then
    echo "Please set the WEBHOOK_URL environment variable or enter it below:"
    read -p "Discord Webhook URL: " WEBHOOK_URL
fi

# Package the cloudformation package
aws cloudformation package --template ./cfn-students.yaml --s3-bucket $MY_DEV_BUCKET --output-template ./cfn-students-export.yaml

# Deploy the package
sam deploy --template-file ./cfn-students-export.yaml --stack-name $STACK_NAME --capabilities CAPABILITY_NAMED_IAM --region $MY_REGION --parameter-overrides WebhookURL=$WEBHOOK_URL
