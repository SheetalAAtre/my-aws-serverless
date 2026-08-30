#!/bin/bash

API_NAME="UsersAPI"
FUNCTION_NAME="users-crud"
REGION="ap-south-1"

ACCOUNT_ID=$(aws sts get-caller-identity \
  --query Account \
  --output text)

LAMBDA_ARN="arn:aws:lambda:$REGION:$ACCOUNT_ID:function:$FUNCTION_NAME"

echo "Creating HTTP API..."

API_ID=$(aws apigatewayv2 create-api \
  --name "$API_NAME" \
  --protocol-type HTTP \
  --query 'ApiId' \
  --output text \
  --region "$REGION")

echo "API ID: $API_ID"

echo "Creating Lambda integration..."

INTEGRATION_ID=$(aws apigatewayv2 create-integration \
  --api-id "$API_ID" \
  --integration-type AWS_PROXY \
  --integration-uri "$LAMBDA_ARN" \
  --payload-format-version 2.0 \
  --query 'IntegrationId' \
  --output text \
  --region "$REGION")

echo "Creating routes..."

aws apigatewayv2 create-route \
  --api-id "$API_ID" \
  --route-key "POST /users" \
  --target "integrations/$INTEGRATION_ID" \
  --region "$REGION"

aws apigatewayv2 create-route \
  --api-id "$API_ID" \
  --route-key "GET /users" \
  --target "integrations/$INTEGRATION_ID" \
  --region "$REGION"

aws apigatewayv2 create-route \
  --api-id "$API_ID" \
  --route-key "GET /users/{id}" \
  --target "integrations/$INTEGRATION_ID" \
  --region "$REGION"

aws apigatewayv2 create-route \
  --api-id "$API_ID" \
  --route-key "PUT /users/{id}" \
  --target "integrations/$INTEGRATION_ID" \
  --region "$REGION"

aws apigatewayv2 create-route \
  --api-id "$API_ID" \
  --route-key "DELETE /users/{id}" \
  --target "integrations/$INTEGRATION_ID" \
  --region "$REGION"

echo "Creating default stage..."

aws apigatewayv2 create-stage \
  --api-id "$API_ID" \
  --stage-name '$default' \
  --auto-deploy \
  --region "$REGION"

echo "Allowing API Gateway to invoke Lambda..."

aws lambda add-permission \
  --function-name "$FUNCTION_NAME" \
  --statement-id apigateway-invoke \
  --action lambda:InvokeFunction \
  --principal apigateway.amazonaws.com \
  --source-arn "arn:aws:execute-api:$REGION:$ACCOUNT_ID:$API_ID/*/*" \
  --region "$REGION"

API_URL=$(aws apigatewayv2 get-api \
  --api-id "$API_ID" \
  --query 'ApiEndpoint' \
  --output text \
  --region "$REGION")

echo ""
echo "================================"
echo "API CREATED"
echo "================================"
echo "$API_URL"
echo ""
echo "POST   $API_URL/users"
echo "GET    $API_URL/users"
echo "GET    $API_URL/users/{id}"
echo "PUT    $API_URL/users/{id}"
echo "DELETE $API_URL/users/{id}"