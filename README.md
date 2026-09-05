# AWS Serverless CRUD - AWS CLI console based approach

## Architecture

```text
                    ┌─────────────┐
                    │   Postman   │
                    └──────┬──────┘
                           │
                         HTTPS
                           │
                           ▼
                  ┌─────────────────┐
                  │   API Gateway   │
                  │     HTTP API     │
                  └────────┬────────┘
                           │
                           ▼
                  ┌─────────────────┐
                  │  AWS Lambda     │
                  │   users-crud    │
                  │                 │
                  │ POST /users     │
                  │ GET  /users     │
                  │ PUT  /users/id  │
                  │ DELETE /users/id│
                  └────────┬────────┘
                           │
                           │
                           ▼
                  ┌─────────────────┐
                  │    DynamoDB     │
                  │      Users      │
                  │                 │
                  │ id    (String)  │
                  │ name  (String)  │
                  │ level (Number)  │
                  └─────────────────┘

                  ┌─────────────────┐
                  │   CloudWatch    │
                  │      Logs       │
                  └─────────────────┘
```

<details>
  <summary>
    Steps From AWS Cloud Console 
  </summary>
  
Create Custom Policy for least privilege

1.	Search IAM 
2.	Open “Policies” in left panel
3.	Click "Create policy" on top right corner
4.	In the policy editor, click JSON, and paste the following
5.	Give name "lambda-custom-policy", and click "Create policy" on bottom right	
 ```
{
    "Version": "2012-10-17",
    "Statement": [
    {
      "Sid": "Stmt1428341300017",
      "Action": [
        "dynamodb:DeleteItem",
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:Query",
        "dynamodb:Scan",
        "dynamodb:UpdateItem"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Sid": "",
      "Resource": "*",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Effect": "Allow"
    }
    ]
 }
```

Create Lambda IAM execution Role to give your function permission to access AWS resources

•	Search IAM 
•	Open “Roles” in left panel
•	Choose Create role.
•	Select trusted entity Trusted entity type – AWS service > Use case: select Lambda
•	Click Permissions > In the Permissions policies page, in the search bar, type lambda-custom-policy. The newly created policy should show up. Select it, and click Next.
•	Name, review, and create page > Role name: lambda-apigateway-role > Click "Create role"

Create Lambda function

•	Click "Create function" in AWS Lambda Console
•	Select "Author from scratch". Use name LambdaFunctionOverHttps , select Python 3.13 as Runtime. 
•	Click "Create function"
•	Functions > Select LambdaFunctionOverHttps link > Custom settings > Configuration Tab > Under Permissions in left Panel > Execution Role > section > Edit > Select lambda-apigateway-role that we created, from the drop down > Save
•	 Functions > Select LambdaFunctionOverHttps link > Custom settings > Code Tab ode Tab > Replace the boilerplate coding with the following code snippet > click "Deploy"


```
from __future__ import print_function
import boto3
import json

print('Loading function')


def lambda_handler(event, context):
    '''Provide an event that contains the following keys:

      - operation: one of the operations in the operations dict below
      - tableName: required for operations that interact with DynamoDB
      - payload: a parameter to pass to the operation being performed
    '''
    #print("Received event: " + json.dumps(event, indent=2))

    operation = event['operation']

    if 'tableName' in event:
        dynamo = boto3.resource('dynamodb').Table(event['tableName'])

    operations = {
        'create': lambda x: dynamo.put_item(**x),
        'read': lambda x: dynamo.get_item(**x),
        'update': lambda x: dynamo.update_item(**x),
        'delete': lambda x: dynamo.delete_item(**x),
        'list': lambda x: dynamo.scan(**x),
        'echo': lambda x: x,
        'ping': lambda x: 'pong'
    }

    if operation in operations:
        return operations[operation](event.get('payload'))
    else:
        raise ValueError('Unrecognized operation "{}"'.format(operation))
```

Test Lambda Function with sample echo function
•	Let's test our newly created function. We haven't created DynamoDB and the API yet, so we'll do a sample echo operation. The function should output whatever input we pass.
•	Click the "Test Events" tab right beside "Code" tab > “Create New  Event”> 
•	Give "Event name" as echotest
•	Paste the following JSON into the event. The field "operation" dictates what the lambda function will perform. In this case, it'd simply return the payload from input event as output. Click "Save" to save
•	Click Save > Click "Invoke", and it will execute the test event. You should see the output in the console
```
{
    "operation": "echo",
    "payload": {
        "somekey1": "somevalue1",
        "somekey2": "somevalue2"
    }
}
```

Create DynamoDB Table that Lambda function uses

•	Open the DynamoDB console.
•	Choose "tables" from left pane, then click "Create table" on top right.
•	Create a table with the following settings.
o	Table name – lambda-apigateway
o	Partition key – id (string)
•	Choose "Create table".

Create API Gateway

•	Go to API Gateway console
•	Click Create API
•	Scroll down and select "Build" for REST API
•	Give the API name as "DynamoDBOperations", keep everything as is, click "Create API"
•	Each API is collection of resources and methods that are integrated with backend HTTP endpoints, Lambda functions, or other AWS services. Typically, API resources are organized in a resource tree according to the application logic. At this time you only have the root resource, but let's add a resource next. Click "Create Resource"
•	Input "DynamoDBManager" in the Resource Name. Click "Create Resource"
•	Let's create a POST Method for our API. With the "/dynamodbmanager" resource selected, click "Create Method".
•	Select "POST" from drop down.
•	Integration type should be pre-selected as "Lambda function". Select "LambdaFunctionOverHttps" function that we created earlier. As you start typing the name, your function name will show up.Select the function, scroll down and click "Create method".
•	ARN is seen in Dashboard : arn:aws:execute-api:ap-southeast-2:546478859289:wdnk62t3t0/*/POST/DynamoDBManager

Deploy the API Gateway
•	In this step, you deploy the API that you created to a stage called prod.
•	Click "Deploy API" on top right
•	Now it is going to ask you about a stage. Select "[New Stage]" for "Stage". Give "Prod" as "Stage name". Click "Deploy"
•	We're all set to run our solution! To invoke our API endpoint, we need the endpoint url. In the "Stages" screen, expand the stage "Prod", keep expanding till you see "POST", select "POST" method, and copy the "Invoke URL" from screen.

Invoking POST API from Postman
•	The Lambda function supports using the create operation to create an item in your DynamoDB table. To request this operation, use the following JSON
•	To run this from terminal using Curl, run the below
$ curl -X POST -d "{\"operation\":\"create\",\"tableName\":\"lambda-apigateway\",\"payload\":{\"Item\":{\"id\":\"1\",\"name\":\"Bob\"}}}" https://$API.execute-api.$REGION.amazonaws.com/prod/DynamoDBManager
•	To validate that the item is indeed inserted into DynamoDB table, go to Dynamo console, select "lambda-apigateway" table, select "Explore table items" button from top right, and the newly inserted item should be displayed.

```
POST https://wdnk62t3t0.execute-api.ap-southeast-2.amazonaws.com/Prod/DynamoDBManager
{
        "operation": "create",
        "tableName": "lambda-apigateway",
        "payload": {
            "Item": {
                "id": "1234ABCD",
                "number": 5
            }
        }
    }

Response – HttpStatus 200 OK:

{
    "ResponseMetadata": {
        "RequestId": "15A49ABNEBTCTMAFEK7Q5LBVPVVV4KQNSO5AEMVJF66Q9ASUAAJG",
        "HTTPStatusCode": 200,
        "HTTPHeaders": {
            "server": "Server",
            "date": "Sat, 05 Sep 2026 11:49:53 GMT",
            "content-type": "application/x-amz-json-1.0",
            "content-length": "2",
            "connection": "keep-alive",
            "x-amzn-requestid": "15A49ABNEBTCTMAFEK7Q5LBVPVVV4KQNSO5AEMVJF66Q9ASUAAJG",
            "x-amz-crc32": "2745614147"
        },
        "RetryAttempts": 0
    }
}
```

Load Testing From Postman Collection
•	Create a new POSTMAN Collection 
•	Add New Request and SAVE
•	Click “...” in the collection name, and from the drop down click “Run”
o	NOTE: A common mistake is to look for “Run” in the “POST New Request”. “Run” option is available in the collection name. 
•	Click “Performance”, then select “Ramp up” under Load Profile, select “10” in Virtual users, and Test duration as 2 mins. Click Run!
•	To get all the inserted items from the table, we can use the "list" operation of Lambda using the same API. Pass the following JSON to the API, and it will return all the items from the Dynamo table 
o	Note: this is also a POST and not a GET request!!!	

```
POST   https://wdnk62t3t0.execute-api.ap-southeast-2.amazonaws.com/Prod/DynamoDBManager
{
    "operation": "list",
    "tableName": "lambda-apigateway",
    "payload": {
    }
}
```



Cleaning up Resources
•	To delete the table, from DynamoDB console, select the table "lambda-apigateway", then on top right , click "Actions", then "Delete table"
•	To delete the Lambda, from the Lambda console, select lambda "LambdaFunctionOverHttps", click "Actions", then click Delete
•	To delete the API we created, in API gateway console, under APIs, select "DynamoDBOperations" API, click "Delete"



</details>

<details>
<summary> Creation Steps</summary>
1. Create DynamoDb table and insert sample data

* PAY_PER_REQUEST chosen for this hands-on because dont need to provision DynamoDB capacity in advance.

* Folder structure : 
```text

dynamodb/
├── 01-create-table.sh : Creates structure for (Table=Users, Partition Key=id:String): DynamoDB allows to define name and level while inserting items:
├── 02-insert-data.sh : add 2 records(id=101, name=Cloud Colosseum, level=1), (id=102, name=AWS Lambda, level=2)
├── 03-get-item.sh : Get one user by ID
├── 04-update-item.sh : Update name and level
├── 05-delete-item.sh
└── 06-scan-table.sh : Get all users
```

2. Create Lambda functions for DynamoDB CRUD
* Create Lambda function 
* Give Lambda IAM permissions to DynamoDB 
* Add Lambda CRUD code

Folder Structure : 
```text

lambda-users-crud/
│
├── 01-create-iam-role.sh : Lambda needs an IAM execution role with least privilege instead of AmazonDynamoDBFullAccess
├── 03-create-lambda.sh : Package the Python code and create the Lambda.
├── 04-deploy-lambda.sh : Whenever you modify lambda_function.py, run this script.
├── 05-test-lambda.sh : Test the Lambda without API Gateway first.
├── 06-delete-resources.sh
│
└── 02-lambda_function.py : This is the actual CRUD Lambda.
```

3. Create API Gateway
Once Lambda + DynamoDB work correctly, create the HTTP API.

Folder Structure : 
```text
api-gateway/
│
└── 01-create-api-gateway.sh : This is the actual CRUD Lambda.
```

4. Postman collection 

* Since the API Gateway URL is generated dynamically, use the "baseUrl" Postman collection variable.
* Replace YOUR_API_GATEWAY_URL with the URL generated by your API Gateway - baseUrl appends a "/" at end.
* Download the postman_collection/Users-CRUD-collection.json and import it into Postman:

```text
api-gateway/
│
└── postman_collection/
    │
    └── Users-CRUD-collection.json
```

Expected Flow : 
* POST users >> Lambda : PutItem >> DynamoDB
* GET users/101 >> Lambda : GetItem >>  DynamoDB
</details>

<details>
<summary>Lambda Performance Evaluation Table</summary>

* It directly compares memory >> execution time >> cost >> SLO during Power Tuning.
* SLO: 95% of valid CRUD requests should complete within 500 ms.
* Infra choice decision: Memory >> Duration >> P95 Latency >> SLO >> Cost >> Best Cost + Performance configuration
* Note: Don't automatically choose 128 MB because it is cheapest or 1536 MB because it is fastest. Choose the lowest-cost configuration that comfortably meets your SLO.
```text

| Metric | Description | 128 MB | 256 MB | 512 MB | 1024 MB | 1536 MB |
|---|---|---:|---:|---:|---:|---:|
| **Memory** | Lambda memory configuration being tested | 128 MB | 256 MB | 512 MB | 1024 MB | 1536 MB |
| **Avg Duration** | Average Lambda execution time | — | — | — | — | — |
| **P95 Duration** | 95% of requests complete within this time | — | — | — | — | — |
| **Invocations** | Number of Lambda executions | — | — | — | — | — |
| **Errors** | Failed Lambda executions | — | — | — | — | — |
| **Cost / 1K Requests** | Estimated Lambda compute cost | — | — | — | — | — |
| **SLO Met?** | Whether your latency/reliability target is achieved(Y/N) | — | — | — | — | — |
| **Result** | Overall performance/cost assessment | Slow / Low cost | — | Potential sweet spot | Faster / Higher cost | Fastest / Costlier |



</details>


<details>
<summary> Well-Architected Analysis</summary>

Well-Architected pillars...

</details>


<details>
<summary> Cleanup Steps</summary>
* For cleanup after completing the assignment run cleanup-all.sh to call the scripts in  order. 

* It deletes all below resources : 
 1.  API Gateway
 2.  Lambda permission
 3. Lambda function
 4. IAM role/policy
 5. DynamoDB table

</details>
