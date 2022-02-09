class API::V1::Entities::Accounts < Grape::Entity
  expose :id
  expose :balance
  expose :currency
  expose :user_id
end
