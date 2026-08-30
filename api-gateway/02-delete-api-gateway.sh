#!/bin/bash

API_NAME="UsersAPI"
REGION="ap-south-1"

echo "Finding API Gateway..."

API_ID=$(aws apigatewayv2 get-apis \
  --region "$REGION" \
  --query "Items[?Name=='$API_NAME'].ApiId | [0]" \
  --output text)

if [ "$API_ID" = "None" ] || [ -z "$API_ID" ]; then
    echo "API Gateway '$API_NAME' not found."
    exit 0
fi

echo "API ID: $API_ID"

echo "Deleting API Gateway..."

aws apigatewayv2 delete-api \
  --api-id "$API_ID" \
  --region "$REGION"

echo "API Gateway '$API_NAME' deleted."