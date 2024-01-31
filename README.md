# 3.3 - Solve the problem

Hello and welcome!

This is fabioaraujo121@gmail.com challange.

⚠️ The answers to the questions can be found in the `/answers` folder.

## Setup
This projects uses Docker 🐳, straight forward, do the following:

1. Building and running up: `docker compose up`
2. Connecting: `docker exec -it cloudwalk-web-1 /bin/bash` (or the container ID, if you will -- `docker ps` is helpful here)
3. Populating DB and trainning model `rails db:seed`
4. Done! ✅

### Explanations

- You can find the CSV with transaction in `db/seeds/transactional-sample.csv`.
- The ML train happens while we do the seed.

#### Goals
1. Validates if a transaction is trustful enough and return the recommendation.

To do so, we're using a "worst-case" based validation, which is simply a mix of rule-base and prediction-based validation. Whichever says the worst answer (deny) we take it as a deny.

##### Rule on rule-based
1. User cannot have any past Payment with chargeback.
2. User cannot perform more than 1_000.0 amount in the past 24h (including the current payment).
3. User cannot perform more than 1 payment in less than 5 minutes.

##### Rule on prediction-based
1. Using Predictive Model to achive the goal. The train and validation data are based on the rule-based decisions above and from the list of payments available in the challange. We have a validation accuracy of 93.3%. Although, the train data is not the best one available, it shows and implements a possible path to the solution.

### Request Examples
#### POST api/v1/payments

Creates the payment and returns the recommendation

Running with cURL:

```shell
curl -X POST http://localhost:3000/api/v1/payments -H "Content-Type: application/json" -H "AUTHORIZATION: Token secret" -d '{"transaction_id": 123, "merchant_id": 321, "user_id": 123321, "card_number": "434505******9116", "transaction_date": "2019-12-01T23:16:32.812632", "transaction_amount": 374.56, "device_id": 123321123321 }'
```
Example response:

```shell
{ "transaction_id": "123", "recommendation": "approve" }
```
