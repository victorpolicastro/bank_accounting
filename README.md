# README

## How to run

1. Run `bundle` to install project dependencies;
2. Run `rails db:create` to create database;
3. Run `rails s` to start server, port: 3000.

## Specs

To run Specs, use the command `rspec`

## Usage

### Create account

1. Send a `POST` request to `/account` with the following payload:
```term
{
  "name": "<username>",
  "email": "<email>",
  "password": "<password>"
}
```

### Login

1. Send a `POST` request to `/auth/login` with the following payload:
```term
{
  "id": "<account id>",
  "password": <password>
}
```
2. You will receive a JWT and it's expiration date

### Account balance

1. To see account's balance, send a `GET` request to `/accounts/:account_id`, with the JWT obtained in previous steps

### Account transactions

1. Send `POST` request to `/accounts/:account_id/transactions` with the following payload:
```term
{
  "destination_account_id": "<account_id>",
  "amount": <amount>
}
```
