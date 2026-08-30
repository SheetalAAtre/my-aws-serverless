#!/bin/bash

FUNCTION_NAME="users-crud"
REGION="ap-south-1"

cat > test-create.json <<'EOF'
{
  "requestContext": {
    "http": {
      "method": "POST"
    }
  },
  "body": "{\"id\":\"103\",\"name\":\"Postman\",\"level\":3}"
}
EOF

aws lambda invoke \
  --function-name "$FUNCTION_NAME" \
  --payload fileb://test-create.json \
  --cli-binary-format raw-in-base64-out \
  response.json \
  --region "$REGION"

cat response.json