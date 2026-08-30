#!/bin/bash

FUNCTION_NAME="users-crud"
ROLE_NAME="users-crud-lambda-role"
REGION="ap-south-1"

echo "Getting IAM role ARN..."

ROLE_ARN=$(aws iam get-role \
  --role-name "$ROLE_NAME" \
  --query 'Role.Arn' \
  --output text)

echo "Role ARN:"
echo "$ROLE_ARN"

echo "Creating deployment package..."

rm -f lambda.zip

zip lambda.zip lambda_function.py

echo "Waiting for IAM role to become available..."

sleep 10

echo "Creating Lambda function..."

aws lambda create-function \
  --function-name "$FUNCTION_NAME" \
  --runtime python3.12 \
  --role "$ROLE_ARN" \
  --handler lambda_function.lambda_handler \
  --zip-file fileb://lambda.zip \
  --timeout 10 \
  --memory-size 256 \
  --region "$REGION"

echo "Lambda created successfully."