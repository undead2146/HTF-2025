// Recommended Packages for this Lambda
const { SNSClient, PublishCommand } = require("@aws-sdk/client-sns");
const AWSXRay = require('aws-xray-sdk-core');

// SNS to send messages to
const snsArn = process.env.SNSArn;

exports.handler = async (event) => {
    console.log(JSON.stringify(event));

    const eventDetail = event.detail;
    
    let signalType;
    if (eventDetail.type === 'dark-signal') {
        signalType = 'dark-signal';
    } else {
        signalType = determineSignal(eventDetail);
    }

    const messageToSend = eventDetail;

    console.log(JSON.stringify(messageToSend));
    // Send to SNS
    await sendToSNS(messageToSend, signalType);
}

function determineSignal(detail) {
    const { type, intensity } = detail;
    if (type === 'creature') {
        return intensity < 3 ? 'observation' : 'rare-observation';
    } else if (type === 'hazard' || type === 'anomaly') {
        return intensity >= 2 ? 'alert' : 'observation';
    } else {
        return 'observation';
    }
}

async function sendToSNS(message, signalType) {
    console.log(message);

    // Client to be used
    const snsClient = AWSXRay.captureAWSv3Client(new SNSClient());

    // Setup parameters for SNS
    const params = {
        TopicArn: snsArn,
        Message: JSON.stringify(message),
        MessageAttributes: {
            type: {
                DataType: 'String',
                StringValue: signalType
            }
        }
    };

    // Get a response
    const response = await snsClient.send(new PublishCommand(params));

    // Just to check if it worked
    console.log(response);
}
