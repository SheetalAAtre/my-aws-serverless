#!/bin/bash

set -e

echo "========================================"
echo " AWS Serverless CRUD Cleanup"
echo "========================================"

./api-gateway/02-delete-api-gateway.sh

./lambda-users-crud/06-delete-lambda.sh

./lambda-users-crud/07-delete-iam-role.sh

./dynamodb/07-delete-dynamodb.sh

echo ""
echo "========================================"
echo " All resources deleted successfully."
echo "========================================"