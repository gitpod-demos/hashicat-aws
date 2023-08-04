# hashicat-aws - Gitpodified
This repo contains the classic Hashicat example application and terraform code for deploying it into an AWS account.

**WARNING:** Terraform will store your state file on the local filesystem in your workspace. You should use a remote backend for persisting your state file, so if you forget to run `terraform destroy` and your workspace goes away, you can still recover and delete the infrastructure.

## Gitpod AWS Terraform Setup

To run this workspace against your own AWS account follow these steps:

## Create an AWS IAM Identity Provider for Gitpod

Visit the AWS IAM Identity Provider page in the console:

https://us-east-1.console.aws.amazon.com/iamv2/home?region=us-east-1#/identity_providers/create

Create a new identity provider with the following settings:

Provider Type: OpenID Connect  
Provider URL: api.gitpod.io/idp  
Audience: sts.amazonaws.com  

![Screenshot 2023-08-04 at 1 15 42 PM](https://github.com/gitpod-demos/hashicat-aws/assets/403332/1882f1f8-12ce-44b7-8d8b-136b6a1547ea)

Copy the ARN of your new identity provider so you can connect it with an IAM Role.  It will look similar to this:

```
arn:aws:iam::12345678912:oidc-provider/api.gitpod.io/idp
```

## Create (or use existing) AWS IAM Role

Visit the IAM Roles page in the AWS console and create or select a custom role, if you have one already. Your role should have the appropriate policies for the workspace attached. 

https://us-east-1.console.aws.amazon.com/iamv2/home?region=us-east-1#/roles

Under the Trust Relationships tab for your role, click on **Edit Trust Policy** and copy the following JSON, replacing the ARN with the one for your own idp.

The StringLike URL should be replaced with the GitHub organization (or username) where you have the hashicat-aws repo stored.

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::123456789012:oidc-provider/api.gitpod.io/idp"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "api.gitpod.io/idp:aud": "sts.amazonaws.com"
                },
                "StringLike": {
                    "api.gitpod.io/idp:sub": "https://github.com/your-organization/hashicat-aws"
                }
            }
        }
    ]
}
```

Save the Trust Policy. Now start a Gitpod workspace with your fork of the repo:

https://gitpod.io/#https://gitub.com/youruser/hashicat-aws

## Set a Gitpod Environment Variable:

Once the workspace starts up you'll need to set an environment variable to tell the workspace which role to assume. The command will look like this, but use your role's ARN:

```
gp env GP_AWS_CONNECTION_ARN=arn:aws:iam::12345678912:role/your-custom-role-here
```

Stop and delete your workspace. The next workspace you launch from this repo will come with AWS preconfigured and authenticated, ready to run Terraform.
