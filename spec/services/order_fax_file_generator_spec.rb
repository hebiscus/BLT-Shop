require "rails_helper"

RSpec.describe OrderFaxFileGenerator do
  describe "#call" do
    let(:sandwich) { create(:sandwich, name: "BLT", price: 999) }

    let(:order) do
      create(:order, items_count: 2, sandwich: sandwich).tap do |order|
        order.order_items.second.update(sandwich: create(:sandwich, name: "Tuna Melt", price: 899), quantity: 1, charged_price: 899)
      end
    end

    it "generates a text file with the correct content" do
      file_path = described_class.new(order).call
      content = File.read(file_path)

      expect(content).to include("Order ID: #{order.id}")
      expect(content).to include("Shop ID: #{order.shop_id}")
      expect(content).to include("Shop Name: #{order.shop.name}")
      expect(content).to include("Delivery Method: #{order.delivery_method}")
      expect(content).to include("Delivery Time: #{order.delivery_time}")
      expect(content).to include("Status: #{order.order_status}")
      expect(content).to include("- BLT (2)")
      expect(content).to include("- Tuna Melt (1)")

      total = order.total_amount
      expect(content).to include("Total: $#{total}")

      File.delete(file_path) if File.exist?(file_path)
    end
  end
end
