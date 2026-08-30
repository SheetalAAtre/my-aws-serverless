#!/bin/bash

TABLE_NAME="Users"
REGION="ap-south-1"

echo "Creating DynamoDB table: $TABLE_NAME"

aws dynamodb create-table \
  --table-name "$TABLE_NAME" \
  --attribute-definitions \
      AttributeName=id,AttributeType=S \
  --key-schema \
      AttributeName=id,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region "$REGION"

echo "Waiting for table to become ACTIVE..."

aws dynamodb wait table-exists \
  --table-name "$TABLE_NAME" \
  --region "$REGION"

echo "DynamoDB table '$TABLE_NAME' is ACTIVE."