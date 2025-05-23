require "dry/schema"

OrderSchema = Dry::Schema.Params do
  required(:delivery_method).filled(:string, included_in?: %w[self_pickup delivery])
  required(:delivery_time).filled(:datetime)

  required(:order_items).array(:hash) do
    required(:sandwich_id).filled(:integer)
    required(:quantity).filled(:integer, gt?: 0)
  end
end
