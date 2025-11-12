# Configuration & Deployment

## CloudFormation Template

The infrastructure is defined in `cfn-students.yaml` using AWS SAM.

### Key Resources

- **4 Lambda Functions**: Signal Classifier, Observation Ingest, Dark Signal Decipherer, Message Translator
- **EventBridge Rule**: Routes HTF25 events to Signal Classifier
- **SNS Topic**: Fan-out classified messages
- **SQS Queue**: Decoupled processing for dark signals
- **DynamoDB Table**: Storage for observations
- **IAM Roles**: Least-privilege permissions for each function

### Environment Variables

| Function | Variable | Purpose |
|----------|----------|---------|
| All | TeamName | Identifies your team |
| Message Translator | WEBHOOK_URL | Discord webhook URL |
| Observation Ingest | DynamoDBTable | Table name for storage |
| Dark Signal Decipherer | SQSQueue | Queue URL for decrypted messages |

## Deployment Steps

### 1. Package the Template

```bash
aws cloudformation package \
  --template-file cfn-students.yaml \
  --s3-bucket htf25-cfn-bucket \
  --output-template cfn-students-export.yaml
```

### 2. Deploy the Stack

```bash
sam deploy \
  --template-file cfn-students-export.yaml \
  --stack-name HTF25-YourTeamName \
  --capabilities CAPABILITY_NAMED_IAM \
  --region eu-central-1
```

Or use the provided script:

```bash
bash deployStudent.sh
```

### 3. Verify Deployment

Check CloudFormation console for stack status:

```bash
aws cloudformation describe-stacks --stack-name HTF25-YourTeamName
```

### 4. Test Functions

Use SAM local for testing:

```bash
# Test Signal Classifier
sam local invoke Challenge1Lambda \
  --event payloads/signal-classifier.json \
  -t cfn-students.yaml

# Test Observation Ingest
sam local invoke Challenge2Lambda \
  --event payloads/observation-ingest.json \
  -t cfn-students.yaml

# Test Dark Signal Decipherer
sam local invoke Challenge4Lambda \
  --event payloads/dark-signal-decipherer.json \
  -t cfn-students.yaml

# Test Message Translator
sam local invoke Challenge5Lambda \
  --event payloads/message-translator.json \
  -t cfn-students.yaml
```

## Monitoring

### CloudWatch Logs

View logs for each Lambda:

```bash
aws logs tail /aws/lambda/HTF25-YourTeamName-SonarSignalClassifier --follow
```

### X-Ray Traces

Enable X-Ray tracing for performance monitoring.

## Troubleshooting

### Common Issues

1. **Stack Creation Fails**
   - Check IAM permissions
   - Verify team name uniqueness
   - Check CloudFormation events

2. **Function Timeouts**
   - Increase timeout in template
   - Check for infinite loops

3. **SNS/SQS Issues**
   - Verify topic/queue ARNs
   - Check subscription confirmations

4. **Discord Webhook Errors**
   - Verify webhook URL
   - Check rate limits

### Debugging Tips

- Use `console.log()` for debugging
- Check CloudWatch logs
- Test locally with SAM
- Use X-Ray for tracing
