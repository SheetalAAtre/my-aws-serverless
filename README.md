# my-aws-serverless

# AWS Serverless CRUD

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
<summary> Security</summary>

Security details and table...

</details>

<details>
<summary> Postman Testing</summary>

Postman test cases...

</details>

<details>
<summary>Lambda Performance Evaluation Table</summary>

* It directly compares memory >> execution time >> cost >> SLO during Power Tuning.
* SLO: 95% of valid CRUD requests should complete within 500 ms.
* Infra choice decision: Memory >> Duration >> P95 Latency >> SLO >> Cost >> Best Cost + Performance configuration
* Note: Don't automatically choose 128 MB because it is cheapest or 1536 MB because it is fastest. Choose the lowest-cost configuration that comfortably meets your SLO.
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