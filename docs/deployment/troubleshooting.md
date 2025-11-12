# Troubleshooting Guide

## Deployment Issues

### CloudFormation Stack Fails

**Symptoms**: Stack creation fails with errors

**Solutions**:
1. Check CloudFormation events in AWS console
2. Verify team name doesn't conflict with existing stacks
3. Ensure AWS credentials have sufficient permissions
4. Check region is `eu-central-1`

### SAM CLI Errors

**Error**: `command not found`

**Solution**: Reinstall SAM CLI and ensure it's in PATH

**Error**: `Docker not running`

**Solution**: Start Docker Desktop for local testing

## Runtime Issues

### Lambda Function Errors

**Check Logs**:
```bash
aws logs tail /aws/lambda/HTF25-YourTeamName-FunctionName --follow
```

**Common Issues**:
- Environment variables not set
- Missing IAM permissions
- Timeout errors (increase timeout)
- Memory limits (increase memory)

### EventBridge Not Triggering

**Symptoms**: Events not reaching Lambda

**Solutions**:
1. Verify EventBridge rule pattern matches
2. Check event bus name: `HTF25-EventBridge-EventBus`
3. Confirm Lambda permissions for EventBridge

### SNS Messages Not Delivered

**Symptoms**: Messages not reaching subscribers

**Solutions**:
1. Check SNS topic ARN
2. Verify Lambda subscriptions
3. Confirm IAM permissions for SNS

### SQS Messages Not Processing

**Symptoms**: Messages stuck in queue

**Solutions**:
1. Check SQS queue URL
2. Verify Lambda event source mapping
3. Check for Lambda errors processing messages

## Data Issues

### DynamoDB Not Storing Data

**Symptoms**: No items in table

**Solutions**:
1. Check table name in environment variables
2. Verify IAM permissions for DynamoDB
3. Check for conditional write failures (duplicates)

### OpenSearch Indexing Fails

**Symptoms**: Alerts not appearing in OpenSearch

**Solutions**:
1. Verify OpenSearch endpoint
2. Check IAM permissions for OpenSearch
3. Confirm index creation permissions

## Decryption Issues

### Dark Signals Not Decrypted

**Symptoms**: Messages not reaching SQS

**Solutions**:
1. Check S3 bucket access for keys
2. Verify XML parsing of keys
3. Check cipher algorithm implementation
4. Validate base64 decoding

### Translation Issues

**Symptoms**: Messages not posted to Discord

**Solutions**:
1. Verify webhook URL
2. Check Discord rate limits
3. Validate Comprehend/Translate permissions
4. Test webhook manually

## Testing Issues

### Local Testing Fails

**Error**: `template not found`

**Solution**: Use absolute paths or run from project root

**Error**: `runtime not supported`

**Solution**: Ensure Docker is running for local Lambda

### Event Format Issues

**Symptoms**: Functions receive unexpected data

**Solutions**:
1. Validate event payloads against documentation
2. Check message attribute types
3. Verify JSON parsing

## Performance Issues

### High Latency

**Causes**:
- Cold starts (optimize with provisioned concurrency)
- Large payloads
- Network timeouts

**Solutions**:
- Increase memory allocation
- Optimize code for speed
- Use connection pooling

### Throttling

**Symptoms**: Functions being throttled

**Solutions**:
- Increase reserved concurrency
- Implement exponential backoff
- Batch processing where possible

## Monitoring

### Enable Detailed Monitoring

```bash
# Enable X-Ray
aws lambda update-function-configuration \
  --function-name HTF25-YourTeamName-FunctionName \
  --tracing-config Mode=Active
```

### Set Up Alarms

Create CloudWatch alarms for:
- Lambda errors
- Duration spikes
- SQS queue depth
- DynamoDB throttling

## Getting Help

1. Check AWS documentation
2. Review CloudWatch logs
3. Test locally with SAM
4. Contact team members
5. Ask instructors during hackathon
