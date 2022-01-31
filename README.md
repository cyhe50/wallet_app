# README
# How to use it

## environment

Ruby: 2.6.3 version

Rails: 5.2.6 version

bundler: 2.3.6 version

## what you should do to execute

```bash
to setup the server

> cd wallet_app
> bundle install
> bundle exec rake db:migrate
> bundle exec rake db:seed
> rails s
```

```bash
to test all spec

> bundle exec rspec
```

```bash
make sure the application.yml contains two keys

TRUST_COMMERCE_GATEWAY_LOGIN: TestMerchant
TRUST_COMMERCE_GATEWAY_PWD: password
```

### after seeding data

you’ll get 2 users

`user1` ⇒ `contains 1 account which got 1000 usd in and 1 transaction info`

`user2` ⇒ `contains nothing`

## Postman api

---

### collection file

[wallet_app.postman_collection.json](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/5522c2f6-11f0-484e-813c-efd29b89196e/wallet_app.postman_collection.json)

[wallet_app_local.postman_environment.json](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/012d45f2-3571-4256-834d-b62ff0cb5fb6/wallet_app_local.postman_environment.json)

### after seeding data, you can check by step

<aside>
💡 be aware that you set `user_id` in headers

</aside>

1. account api for `user1` , expect to get the account info
2. account api for `user2` , expect that it’ll return a null array
3. deposit money to `user2` and check his account, expect to get an account info
4. withdraw money back to `user2` and check his account, expect the balance is decreased
5. transfer money from `user1` to `user2`, check both accounts and expect the two account balance changed

# How do I implement

## code structure

### database

> user
>
1. `first_name, last_name` is used for credit card
2. was setup with `devise` , but not yet implement authentication
3. has many accounts and transactions

> account
>
1. one user can has many accounts but with different type of currency
2. balance is calculated by transaction only when transaction is success

> transaction
>
1. each action creates a transaction
2. the amount can be positive or negative base on the action
3. the state is follow by aasm flow

### api

`lib/v1/auth/deposit` ⇒ connect to trust_commerce gateway service to deposit

`lib/v1/auth//withdraw` ⇒ connect to trust_commerce gateway service to withdraw

`lib/v1/auth/transfer` ⇒ connect to in_app gateway service to transfer

`lib/v1/auth/accounts` ⇒ present user’s all accounts

`lib/v1/auth/accounts/:currency` ⇒ present the specific account

### library

> Gateway::TrustCommerce
>
1. is already set to be test mode
2. is a third party pay method which I use it to deposit and withdraw
3. methods description

    `#authorize` ⇒ checking validation before purchasing

    `#capture` ⇒ after authorize, the capture can actually purchase

    `#refund` ⇒ refund by transaction id


### service

> Gateway::TrustCmmerceService
>
1. cascade to the lib I build `Gateway::TrustCommerce`
2. logic description

    `#purchase` ⇒

    1. check creditcard validation
    2. check transaction in third party authorization
    3. initialize transaction and validate it
    4. post the capture api to the third party to checkout
    5. if capture success update the transaction info and set it as success, else update the transaction info and set it as failed

    `#refund` ⇒

    - since refund need a transaction_id
    1. get an array on how many money can be refund by each transaction_id
    2. refund each transaction_id
    3. each refund action will create an transaction

> Gateway::InAppService
>
1. transfer will not go through any third party, it only through my server
2. logic description
    - set that user1 transfer money to user2

    `#transfer` ⇒

    1. create a transaction for user1
    2. create a transaction for user2
    3. set transaction for user2 as success
    4. set transaction for user1 as success

### test

1. test for service and api only

## design concept

> searching phase
>
1. `deposit` and `withdraw` function should be implemented by third party. My concept was like implement like JKOpay which means I’d like to create an account and cascade the bank api so I start with searching bank api.
2. Somehow I did’t find any useful bank api, so I’d been thinking cascade like a crypto wallet so I start looking for web3 and ethereum on ROR, I’ve used `web3-eth` gem and it looked good but I got a problem to send transaction via the gem. After searching for about half a day, I finally gave up.
3. In the end, I use `active_merchant` gem to checkout and refund as  deposit and withdraw

> implement phase
>
1. set up an `lib` object to be the only interface to cascade third party
2. set up a service for internal server usage, it only connect to the lib object and implement businesses logic here
3. set up api which would call corresponding service
4. error handle

# Improvement

1. I’d like to cascade a bank account to implement the true deposit function
2. lock for avoiding race condition
3. setting sidekiq for background job, since the deposit and withdraw api is slow
4. authorization for the api ( so far I am using `user_id` in the header only)
5. along with 4. , implement login and signup api
6. so far the trust_commerce is on test mode in a hardcode way, change it to the real library base on environment

# How many time I spent

First of all, I was designing for my database and structure for about half a day and ran a new repository, set up the environment for another half a day. Then I was thinking of implementing a crypto wallet and I spent about a day to study for that. But finally I found out it’s not gonna work so I spent a whole day to implement the rest structure.

So I spent the whole 3 days to do the task this time.
