#!/bin/bash

TABLE_NAME="Users"
REGION="ap-south-1"
USER_ID="101"

aws dynamodb delete-item \
  --table-name "$TABLE_NAME" \
  --key "{\"id\":{\"S\":\"$USER_ID\"}}" \
  --region "$REGION"

echo "User $USER_ID deleted."