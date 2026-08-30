#!/bin/bash

TABLE_NAME="Users"
REGION="ap-south-1"
USER_ID="101"

aws dynamodb update-item \
  --table-name "$TABLE_NAME" \
  --key "{\"id\":{\"S\":\"$USER_ID\"}}" \
  --update-expression "SET #n = :name, #l = :level" \
  --expression-attribute-names '{
    "#n": "name",
    "#l": "level"
  }' \
  --expression-attribute-values '{
    ":name": {"S": "Cloud Colosseum Advanced"},
    ":level": {"N": "2"}
  }' \
  --return-values ALL_NEW \
  --region "$REGION"