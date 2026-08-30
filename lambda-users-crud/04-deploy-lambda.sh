#!/bin/bash

FUNCTION_NAME="users-crud"
REGION="ap-south-1"

echo "Creating deployment package..."

rm -f lambda.zip

zip lambda.zip lambda_function.py

echo "Updating Lambda code..."

aws lambda update-function-code \
  --function-name "$FUNCTION_NAME" \
  --zip-file fileb://lambda.zip \
  --region "$REGION"

echo "Lambda deployment completed."