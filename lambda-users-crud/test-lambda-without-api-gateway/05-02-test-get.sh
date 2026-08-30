#!/bin/bash

FUNCTION_NAME="users-crud"
REGION="ap-south-1"

cat > test-get.json <<'EOF'
{
  "requestContext": {
    "http": {
      "method": "GET"
    }
  },
  "pathParameters": {
    "id": "101"
  }
}
EOF

aws lambda invoke \
  --function-name users-crud \
  --payload fileb://test-get.json \
  --cli-binary-format raw-in-base64-out \
  response.json \
  --region ap-south-1

cat response.json