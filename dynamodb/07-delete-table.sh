#!/bin/bash

TABLE_NAME="Users"
REGION="ap-south-1"

echo "Deleting DynamoDB table..."

aws dynamodb delete-table \
  --table-name "$TABLE_NAME" \
  --region "$REGION"

echo "Waiting for table deletion..."

aws dynamodb wait table-not-exists \
  --table-name "$TABLE_NAME" \
  --region "$REGION"

echo "DynamoDB table '$TABLE_NAME' deleted."