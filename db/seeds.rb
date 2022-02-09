# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(id: 1, first_name: 'User1', last_name: 'User1', email: 'testing1@test.com', password: '1111111')
Account.create(user_id: 1, currency: 'usd')
Transaction.create(
  user_id: 1,
  account_id: 1,
  action: 'purchase',
  aasm_state: 'success',
  currency: 'usd',
  amount: 1000,
  transaction_id: '039-0115095948',
  raw_data: 'deposit by seed')

User.create(first_name: 'User2', last_name: 'User2', email: 'testing2@test.com', password: '1111111')
