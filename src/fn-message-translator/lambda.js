// Recommended Packages for this Lambda
const { TranslateClient, TranslateTextCommand } = require('@aws-sdk/client-translate');
const { ComprehendClient, DetectDominantLanguageCommand } = require('@aws-sdk/client-comprehend');
const axios = require('axios');
const AWSXRay = require('aws-xray-sdk-core');
AWSXRay.captureHTTPsGlobal(require('http'));
AWSXRay.captureHTTPsGlobal(require('https'));

// Language the text has to be in
const targetLanguage = "en";

exports.handler = async (event) => {
    console.log(JSON.stringify(event));

    for (const record of event.Records) {
        const body = JSON.parse(record.body);
        const message = body.Message;
        const teamName = body.TeamName;

        const sourceLanguage = await checkLanguage(message);
        let translatedMessage = message;
        if (sourceLanguage !== 'en') {
            translatedMessage = await translateToEnglish(message, sourceLanguage);
        }

        await sendToWebhook(message, translatedMessage, sourceLanguage, teamName);
    }
}

async function checkLanguage(message) {
    console.log(message);

    // Client to be used
    const comprehendClient = AWSXRay.captureAWSv3Client(new ComprehendClient());

    // Setup Parameters for Comprehend
    const params = {
        Text: message
    };

    const command = new DetectDominantLanguageCommand(params);

    // Get Response from Comprehend
    const response = await comprehendClient.send(command);

    console.log(response);

    // Return Primary Language
    return response.Languages[0].LanguageCode;
}

async function translateToEnglish(message, sourceLanguage) {
    console.log(sourceLanguage);

    // Setup parameters for Translate
    const params = {
        Text: message,
        SourceLanguageCode: sourceLanguage,
        TargetLanguageCode: targetLanguage
    };

    // Client to be used
    const translateClient = AWSXRay.captureAWSv3Client(new TranslateClient());

    // Get Response from Translate
    const response = await translateClient.send(new TranslateTextCommand(params));

    console.log(response);

    // Return translated text
    return response.TranslatedText;
}

async function sendToWebhook(original, translated, lang, team) {
    const payload = {
        content: `**${team}**: ${original} -> ${translated} (lang: ${lang})`
    };
    console.log('Sending to Discord webhook:', payload);
    console.log('Webhook URL:', process.env.WEBHOOK_URL);
    try {
        const response = await axios.post(process.env.WEBHOOK_URL, payload);
        console.log('Discord webhook response:', response.status, response.statusText);
    } catch (error) {
        console.error('Failed to send to Discord webhook:', error.message);
        console.error('Error details:', error.response?.data || error);
    }
}
