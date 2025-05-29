require "dry/schema"

OrderSchema = Dry::Schema.Params do
  required(:delivery_method).filled(:string, included_in?: %w[self_pickup delivery])
  required(:delivery_time).filled(:date_time)
  required(:order_status).filled(:string, included_in?: %w[pending confirmed in_progress out_for_delivery delivered cancelled])

  required(:order_items).array(:hash) do
    required(:sandwich_id).filled(:integer)
    required(:quantity).filled(:integer, gteq?: 0)
    required(:charged_price).filled(:integer, gteq?: 0)
  end
end
