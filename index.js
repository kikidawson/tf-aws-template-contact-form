var aws = require("aws-sdk")
var ses = new aws.SES({ region: "eu-west-2" })
 
 exports.handler = async function (event, context) {
    console.log('Received event:', event);
    var params = {
        Destination: {
            ToAddresses: [
                "kikiadawson@gmail.com"
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
        Source: "kikiadawson@gmail.com"
    };

    return ses.sendEmail(params).promise();
 };
