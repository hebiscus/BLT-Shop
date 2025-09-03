require "rails_helper"

RSpec.describe OrdersController, type: :controller do
  let!(:shop) { Shop.create!(name: "Test Shop", address: {street: "123 Main St"}) }
  let!(:cart) { Cart.create! }
  let!(:sandwich) { Sandwich.create!(name: "BLT", price: 999) }
  let!(:cart_item) { CartItem.create!(cart: cart, sandwich: sandwich, quantity: 2, charged_price: 999) }

  before do
    allow(controller).to receive(:current_cart).and_return(cart)
    session[:selected_shop_id] = shop.id

    allow(OrderFaxFileGenerator).to receive(:new).and_return(double(call: "/tmp/fax.txt"))
    allow(FaxSender).to receive(:new).and_return(double(call: true))
  end

  describe "POST #create" do
    context "with valid params" do
      let(:order_params) do
        {
          order: {
            delivery_method: "self_pickup",
            delivery_time: 1.hour.from_now,
            order_status: "pending"
          }
        }
      end

      it "creates an order and order items" do
        expect {
          post :create, params: order_params
        }.to change(Order, :count).by(1)
          .and change(OrderItem, :count).by(1)

        p response

        expect(response).to redirect_to("/sandwiches")
        expect(flash[:notice]).to eq("Order placed successfully!")
      end
    end

    context "with invalid params" do
      let(:order_params) { {order: {delivery_method: nil}} }

      it "does not create an order" do
        expect {
          post :create, params: order_params
        }.not_to change(Order, :count)

        expect(response).to redirect_to("/cart")
        expect(flash[:errors]).to be_present
      end
    end

    context "when an exception is raised" do
      let(:order_params) do
        {
          order: {
            delivery_method: "self_pickup",
            delivery_time: 1.hour.from_now,
            order_status: "pending"
          }
        }
      end

      before do
        allow(Order).to receive(:create!).and_raise(StandardError.new("DB exploded"))
      end

      it "renders error message" do
        post :create, params: order_params

        expect(response.body).to include("Fatal error")
        expect(response.body).to include("DB exploded")
      end
    end
  end
end
