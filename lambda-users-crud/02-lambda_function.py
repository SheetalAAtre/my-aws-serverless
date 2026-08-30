import json
import boto3

TABLE_NAME = "Users"

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(TABLE_NAME)


def lambda_handler(event, context):

    method = event.get("requestContext", {}).get(
        "http", {}
    ).get("method")

    path_parameters = event.get("pathParameters") or {}
    user_id = path_parameters.get("id")

    body = json.loads(event.get("body") or "{}")

    try:

        # CREATE
        if method == "POST":

            if "id" not in body or "name" not in body or "level" not in body:
                return response(
                    400,
                    {"message": "id, name and level are required"}
                )

            table.put_item(
                Item={
                    "id": body["id"],
                    "name": body["name"],
                    "level": body["level"]
                }
            )

            return response(
                201,
                {
                    "message": "User created",
                    "user": body
                }
            )

        # READ
        elif method == "GET":

            # GET /users/{id}
            if user_id:

                result = table.get_item(
                    Key={
                        "id": user_id
                    }
                )

                item = result.get("Item")

                if not item:
                    return response(
                        404,
                        {"message": "User not found"}
                    )

                return response(
                    200,
                    item
                )

            # GET /users
            else:

                result = table.scan()

                return response(
                    200,
                    result.get("Items", [])
                )

        # UPDATE
        elif method == "PUT":

            if not user_id:
                return response(
                    400,
                    {"message": "User id is required"}
                )

            if "name" not in body or "level" not in body:
                return response(
                    400,
                    {"message": "name and level are required"}
                )

            result = table.update_item(
                Key={
                    "id": user_id
                },
                UpdateExpression="SET #n = :name, #l = :level",
                ExpressionAttributeNames={
                    "#n": "name",
                    "#l": "level"
                },
                ExpressionAttributeValues={
                    ":name": body["name"],
                    ":level": body["level"]
                },
                ReturnValues="ALL_NEW"
            )

            return response(
                200,
                result["Attributes"]
            )

        # DELETE
        elif method == "DELETE":

            if not user_id:
                return response(
                    400,
                    {"message": "User id is required"}
                )

            table.delete_item(
                Key={
                    "id": user_id
                }
            )

            return response(
                200,
                {
                    "message": "User deleted",
                    "id": user_id
                }
            )

        else:

            return response(
                405,
                {"message": "Method not supported"}
            )

    except Exception as e:

        print(f"Error: {str(e)}")

        return response(
            500,
            {
                "message": "Internal server error"
            }
        )


def response(status_code, body):

    return {
        "statusCode": status_code,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": json.dumps(body)
    }