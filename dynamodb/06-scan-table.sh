#!/bin/bash

TABLE_NAME="Users"
REGION="ap-south-1"

echo "Scanning Users table..."

aws dynamodb scan \
  --table-name "$TABLE_NAME" \
  --region "$REGION"