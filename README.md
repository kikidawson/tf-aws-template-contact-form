# Contact Form Terraform Template

This is a simple contact form web app. Once the contact form has been submitted, the details on the form are emailed to the owner. This app uses AWS and terraform.

## Flow Diagram

User interacts with contact form on webpage hosted in S3 bucket. Submitting contact form sends post request which triggers the lambda. The lambda sends an email to website owner with contents of contact form using SES.
![flow diagram](./diagrams/Untitled.png)

### AWS Management Console Screenshots
Webpage
![webpage screenshot](./images/webpage.png)

S3 Bucket
![S3 Bucket screenshot](./images/s3-bucket.png)

S3 Objects
![S3 Objects screenshot](./images/s3-bucket-objects.png)

API Gateway
![API Gateway screenshot](./images/api-gateway.png)

API Gateway POST
![API Gateway POST screenshot](./images/api-gateway-post.png)

Lambda Function
![Lambda Function screenshot](./images/lambda-function.png)

Trust Policy attached to the IAM Role
![IAM Role Trust Policy screenshot](./images/iam-role-trust-policy.png)

Permissions attached to the IAM Role
![IAM Role Permissions screenshot](./images/iam-role-permissions.png)

SES Identities
![S3 Objects screenshot](./images/ses-identities.png)

Email
![gmail screenshot](./images/email.png)

# TODO

- [X] codify
- [x] variablise
- [x] use S3 module
- [x] github actions to upload lambda code once pushed to main
  - [x] stop tf from uploading changing to lambda code
- [ ] PR checks once pr raised/changed
- [ ] modulise lambda
  - [ ] trigger lambda code deployment after creation
- [ ] modulise apigateway
