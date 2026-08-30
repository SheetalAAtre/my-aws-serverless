#!/bin/bash

TABLE_NAME="Users"
REGION="ap-south-1"

echo "Deleting DynamoDB table..."

aws dynamodb delete-table \
  --table-name "$TABLE_NAME" \
  --region "$REGION"

echo "Delete request submitted."