#!/bin/bash

FUNCTION_NAME="users-crud"
REGION="ap-south-1"

cat > test-update.json <<'EOF'
{
  "requestContext": {
    "http": {
      "method": "PUT"
    }
  },
  "pathParameters": {
    "id": "101"
  },
  "body": "{\"name\":\"Cloud Colosseum Updated\",\"level\":2}"
}
EOF

aws lambda invoke \
  --function-name users-crud \
  --payload fileb://test-update.json \
  --cli-binary-format raw-in-base64-out \
  response.json \
  --region ap-south-1

cat response.json
