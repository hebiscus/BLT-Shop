CartItemSchema = Dry::Schema.Params do
  required(:sandwich_id).filled(:integer)
  required(:quantity).filled(:integer, gt?: 0)
  required(:charged_price).filled(:integer, gteq?: 0)
end
