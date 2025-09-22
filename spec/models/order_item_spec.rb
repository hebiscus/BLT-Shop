require "rails_helper"

RSpec.describe OrderItem, type: :model do
  describe "#sandwich_name" do
    it "returns the name of the associated sandwich" do
      sandwich = create(:sandwich, name: "Turkey")
      order_item = create(:order_item, sandwich: sandwich)

      expect(order_item.sandwich_name).to eq("Turkey")
    end
  end
end
