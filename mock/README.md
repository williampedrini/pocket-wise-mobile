# Mock Server

Mock server using [json-server](https://github.com/typicode/json-server) to simulate the AccountController endpoints.

## Prerequisites

- Node.js installed
- json-server v0.17.x installed globally:

```bash
npm install -g json-server@0.17.4
```

## Running

```bash
json-server --watch mock/db.json --routes mock/routes.json --port 8080
```

## Endpoints

| Method | Endpoint                            | Description                  |
|--------|-------------------------------------|------------------------------|
| GET    | `/api/accounts/{iban}`              | Get account by IBAN          |
| GET    | `/api/accounts/{iban}/balances`     | Get balances for account     |
| GET    | `/api/accounts/{iban}/transactions` | Get transactions for account |

## Example Requests

```bash
# Get account
curl http://localhost:8080/api/accounts/PT50001000006264381000137
# Get balances
curl http://localhost:8080/api/accounts/PT50001000006264381000137/balances
# Get transactions
curl http://localhost:8080/api/accounts/PT50001000006264381000137/transactions
```