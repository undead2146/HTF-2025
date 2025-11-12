// Recommended Packages for this Lambda
const { DynamoDBClient } = require("@aws-sdk/client-dynamodb")
const { PutCommand, DynamoDBDocumentClient } = require("@aws-sdk/lib-dynamodb");
const { defaultProvider } = require("@aws-sdk/credential-provider-node");
const { Client } = require("@opensearch-project/opensearch");
const { AwsSigv4Signer } = require("@opensearch-project/opensearch/aws");
const AWSXRay = require('aws-xray-sdk-core');
AWSXRay.captureHTTPsGlobal(require('http'));
AWSXRay.captureHTTPsGlobal(require('https'));

const openSearchEndpoint = "https://s6tkjpxuugo2q82i4z3d.eu-central-1.aoss.amazonaws.com";

const osClient = new Client({
    ...AwsSigv4Signer({
        region: "eu-central-1",
        service: 'aoss', // 'es' for managed, 'aoss' for serverless
        getCredentials: defaultProvider(),
    }),
    node: openSearchEndpoint,
});

const dynamoClient = AWSXRay.captureAWSv3Client(new DynamoDBClient());

exports.handler = async (event) => {
    console.log(JSON.stringify(event));

    for (const record of event.Records) {
        const snsMessage = JSON.parse(record.Sns.Message);
        const messageId = record.Sns.MessageId;
        const type = record.Sns.MessageAttributes?.type?.Value || 'observation';

        if (type === 'observation' || type === 'rare-observation') {
            await insertIntoDynamoDB(snsMessage, messageId, type);
        } else if (type === 'alert') {
            await insertIntoOpenSearch(snsMessage, messageId, type);
        }
    }
}

async function insertIntoDynamoDB(message, messageId, type) {
    const params = {
        TableName: process.env.DynamoDBTable,
        Item: {
            id: messageId,
            team: process.env.TeamName,
            species: message.species,
            location: message.location,
            intensity: message.intensity,
            timestamp: new Date().toISOString(),
            type: type
        },
        ConditionExpression: 'attribute_not_exists(id)'
    };

    const docClient = DynamoDBDocumentClient.from(dynamoClient);
    await docClient.send(new PutCommand(params));
}

async function insertIntoOpenSearch(message, messageId, type) {
    const index = process.env.TeamName.toLowerCase();
    const body = {
        id: messageId,
        team: process.env.TeamName,
        species: message.species,
        location: message.location,
        intensity: message.intensity,
        timestamp: new Date().toISOString(),
        type: type
    };

    await osClient.index({
        index: index,
        id: messageId,
        body: body
    });
}
