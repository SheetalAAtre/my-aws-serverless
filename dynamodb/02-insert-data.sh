#!/bin/bash

TABLE_NAME="Users"
REGION="ap-south-1"

echo "Inserting users..."

aws dynamodb put-item \
  --table-name "$TABLE_NAME" \
  --item '{
    "id": {"S": "101"},
    "name": {"S": "Cloud Colosseum"},
    "level": {"N": "1"}
  }' \
  --region "$REGION"

aws dynamodb put-item \
  --table-name "$TABLE_NAME" \
  --item '{
    "id": {"S": "102"},
    "name": {"S": "AWS Lambda"},
    "level": {"N": "2"}
  }' \
  --region "$REGION"

echo "Users inserted successfully."