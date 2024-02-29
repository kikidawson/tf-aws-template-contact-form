let email = process.env.EMAIL_ADDRESS
let region = process.env.REGION

var aws = require("aws-sdk")
var ses = new aws.SES({ region: region })

 exports.handler = async function (event, context) {
    console.log('Received event:', event);
    var params = {
        Destination: {
            ToAddresses: [
                email
            ]
        },
        Message: {
            Body: {
                Text: {
                    Data: 'name: ' + event.name + '\nemail: ' + event.email + '\nmessage: ' + event.message,
                    Charset: 'UTF-8'
                }
            },
            Subject: {
                Data: 'Website Referral Form: ' + event.name,
                Charset: 'UTF-8'
            }
        },
        Source: email
    };

    return ses.sendEmail(params).promise();
 };
