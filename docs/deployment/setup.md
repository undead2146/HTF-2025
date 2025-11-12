# Environment Setup

## Prerequisites

Before deploying the system, ensure you have the following installed:

### AWS CLI v2

**Download**: https://awscli.amazonaws.com/AWSCLIV2.msi

**Installation**:
1. Download the MSI installer
2. Run the installer with administrator privileges
3. Verify installation: `aws --version`

### AWS SAM CLI

**Download**: https://github.com/aws/aws-sam-cli/releases/latest/download/AWS_SAM_CLI_64_PY3.msi

**Installation**:
1. Download the MSI installer
2. Run the installer
3. Verify installation: `sam --version`

### Node.js and NPM

**Download**: https://nodejs.org/en/download/

**Installation**:
1. Download the Windows installer (.msi)
2. Run the installer
3. Verify installation: `node --version` and `npm --version`

## AWS Configuration

### Get Credentials

Your AWS credentials were sent to your school email. Contact your instructor if you haven't received them.

### Configure AWS CLI

Run the following command and enter your credentials:

```bash
aws configure
```

**Prompts**:
- AWS Access Key ID: [from email]
- AWS Secret Access Key: [from email]
- Default region name: `eu-central-1`
- Default output format: `json`

### Verify Configuration

Test your configuration:

```bash
aws sts get-caller-identity
```

You should see your AWS account information.

## Team Configuration

### Choose Team Name

Select your team name from the available options (no spaces):

- GoPowerRanger
- Hydra
- MaranzasDiBrugge
- OTR
- Samoth
- SecurityMobistar
- SuperHacker
- WeCantC

### Update Configuration Files

1. **cfn-students.yaml**: Change `Default: <TEAMNAME>` to your team name
2. **deployStudent.sh**: Change `<TEAMNAME>` to your team name

Example for team "SuperHacker":
- cfn-students.yaml: `Default: SuperHacker`
- deployStudent.sh: `STACK_NAME="HTF25-SuperHacker"`

## Discord Webhook Setup

1. Go to your Discord server
2. Server Settings → Integrations → Webhooks
3. Create a new webhook
4. Copy the webhook URL
5. In `cfn-students.yaml`, replace `<YOUR_DISCORD_WEBHOOK_URL>` with your URL

## Install Dependencies

From the project root:

```bash
# Install Lambda dependencies
bash installRequiredPackages.sh

# Or manually:
cd src/fn-signal-classifier && npm install
cd ../fn-observation-ingest && npm install
cd ../fn-dark-signal-decipherer && npm install
cd ../fn-message-translator && npm install
```

## Ready for Deployment

Once all prerequisites are complete, proceed to [deployment](./configuration.md).
