#!/bin/bash

TABLE_NAME="Users"
REGION="ap-south-1"
USER_ID="101"

aws dynamodb get-item \
  --table-name "$TABLE_NAME" \
  --key "{\"id\":{\"S\":\"$USER_ID\"}}" \
  --region "$REGION"