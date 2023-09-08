#!/bin/bash
AWS_REGION=us-west-2
aws secretsmanager get-secret-value --secret-id '/dev/secrets/captainmidnight' --region $AWS_REGION --query SecretString --output text | jq -r .secretmessage