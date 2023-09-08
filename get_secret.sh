#!/bin/bash
AWS_REGION=us-west-2
echo "Fetching secret message from AWS Secrets Manager..."
DECODED=$(aws secretsmanager get-secret-value --secret-id '/dev/secrets/captainmidnight' --region $AWS_REGION --query SecretString --output text | jq -r .secretmessage)
echo $DECODED
