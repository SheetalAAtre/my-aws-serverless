#!/bin/bash

FUNCTION_NAME="users-crud"
REGION="ap-south-1"

echo "Deleting Lambda function..."

aws lambda delete-function \
  --function-name "$FUNCTION_NAME" \
  --region "$REGION"

echo "Lambda '$FUNCTION_NAME' deleted."