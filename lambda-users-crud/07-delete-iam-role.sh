#!/bin/bash

ROLE_NAME="users-crud-lambda-role"

echo "Deleting inline DynamoDB policy..."

aws iam delete-role-policy \
  --role-name "$ROLE_NAME" \
  --policy-name UsersDynamoDBAccess

echo "Detaching CloudWatch policy..."

aws iam detach-role-policy \
  --role-name "$ROLE_NAME" \
  --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole

echo "Deleting IAM role..."

aws iam delete-role \
  --role-name "$ROLE_NAME"

echo "IAM role '$ROLE_NAME' deleted."