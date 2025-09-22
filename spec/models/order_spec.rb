require "rails_helper"

RSpec.describe Order, type: :model do
  describe "#total_amount" do
    it "calculates the total order amount" do
      order = create(:order)
      create(:order_item, order: order, charged_price: 500, quantity: 2)  # $10.00
      create(:order_item, order: order, charged_price: 300, quantity: 1)  # $3.00

      expect(order.total_amount).to eq(1300)
    end
  end
end
