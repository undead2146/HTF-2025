// Recommended Packages for this Lambda
const { SQSClient, SendMessageCommand } = require('@aws-sdk/client-sqs');
const axios = require('axios');
const AWSXRay = require('aws-xray-sdk-core');
AWSXRay.captureHTTPsGlobal(require('http'));
AWSXRay.captureHTTPsGlobal(require('https'));
const { XMLParser } = require("fast-xml-parser");

// SQS queue to send the messages to
const queueUrl = process.env.SQSQueue;

// Contains the name of your team
const teamName = process.env.TeamName;

// URL of the Keys, retrieve these
const keysUrl = "https://htf-2025-cipher-keys.s3.eu-central-1.amazonaws.com/keys.xml";

exports.handler = async (event) => {
    console.log(JSON.stringify(event));

    // Fetch Keys
    const keys = await fetchKeys();

    for (const record of event.Records) {
        const snsMessage = JSON.parse(record.Sns.Message);
        if (snsMessage.type === 'dark-signal') {
            const deciphered = await decipherMsg(snsMessage, keys);
            await sendToSQS(deciphered);
        }
    }
}

async function fetchKeys() {
    console.log("Fetching keys");
    const response = await axios.get(keysUrl);
    const parser = new XMLParser();
    const json = parser.parse(response.data);
    
    const keysMap = {};
    if (json.keys && json.keys.key) {
        const keyArray = Array.isArray(json.keys.key) ? json.keys.key : [json.keys.key];
        for (const k of keyArray) {
            keysMap[k.kid] = k.cipher;
        }
    }
    return keysMap;
}

async function decipherMsg(msg, keys) {
    const data = Buffer.from(msg.originalPayload.data, 'base64').toString();
    const payload = JSON.parse(data);
    if (payload.alg !== 'substitution-cipher') {
        throw new Error('Unsupported algorithm');
    }
    const key = keys[payload.kid];
    if (!key) {
        throw new Error('Key not found');
    }
    
    // Manual substitution cipher decryption
    const alphabet = "abcdefghijklmnopqrstuvwxyz";
    const decipheredMessage = payload.cipher.split('').map(char => {
        if (char === ' ') return ' ';
        const index = key.indexOf(char.toLowerCase());
        if (index === -1) return char; // Keep non-alphabet characters as-is
        return alphabet[index];
    }).join('');
    
    console.log('Decrypted:', decipheredMessage);
    return decipheredMessage;
}

async function sendToSQS(message) {
    const messageToSend = {
        Message: message,
        TeamName: teamName
    };
    const params = {
        QueueUrl: queueUrl,
        MessageBody: JSON.stringify(messageToSend)
    };
    const sqsClient = AWSXRay.captureAWSv3Client(new SQSClient());
    const command = new SendMessageCommand(params);
    const response = await sqsClient.send(command);
    console.log(response);
}
