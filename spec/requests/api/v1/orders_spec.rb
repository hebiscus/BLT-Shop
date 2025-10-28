require "rails_helper"

RSpec.describe "API::V1::Orders", type: :request do
  describe "POST /api/v1/orders" do
    before do
      allow(OrderFaxFileGenerator).to receive(:new).and_return(double(call: "/tmp/fax.txt"))
      allow(FaxSender).to receive(:new).and_return(double(call: true))
    end
    it "creates an order with items" do
      shop = create(:shop)
      sandwich1 = create(:sandwich, price: 1000)
      sandwich2 = create(:sandwich, price: 1500)

      order_params = {
        order: {
          delivery_method: "delivery",
          delivery_time: 1.hour.from_now,
          shop_id: shop.id
        },
        order_items: [
          {sandwich_id: sandwich1.id, quantity: 2},
          {sandwich_id: sandwich2.id, quantity: 1}
        ]
      }

      post "/api/v1/orders", params: order_params.to_json, headers: {"Content-Type" => "application/json"}

      expect(response).to have_http_status(:created)
      body = JSON.parse(response.body)
      expect(Order.count).to eq(1)
      expect(OrderItem.count).to eq(2)
      expect(body["delivery_method"]).to eq("delivery")
    end
  end

  describe "GET /api/v1/orders/:id" do
    it "returns the order with items" do
      shop = create(:shop)
      sandwich = create(:sandwich, name: "Ham")
      order = create(:order, shop: shop, delivery_time: 1.day.from_now)
      create(:order_item, order: order, sandwich: sandwich, quantity: 1)

      get "/api/v1/orders/#{order.id}"

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["order_items"].first["sandwich"]["name"]).to eq("Ham")
    end
  end
end
