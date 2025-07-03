class OrderFaxFileGenerator
  def initialize(order)
    @order = order
  end

  def call
    file_content = <<~TXT
      Order ID: #{@order.id}
      Shop ID: #{@order.shop_id}
      Shop Name: #{@order.shop.name}
      Delivery Method: #{@order.delivery_method}
      Delivery Time: #{@order.delivery_time}
      Status: #{@order.order_status}

      Items:
    TXT

    @order.order_items.each do |item|
      file_content << "- #{item.sandwich_name} (#{item.quantity})\n"
    end

    file_content << "\nTotal: $#{@order.total_amount}"

    file_path = Rails.root.join("tmp", "order-#{@order.id}.txt")
    File.write(file_path, file_content)

    file_path
  end
end
