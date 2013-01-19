class ProductsCell < Cell::Rails
  def top(args)
    all_products = Product.all
    order_items = OrderItem.joins(:order).
      select("order_items.id, orders.completed, order_items.quantity, order_items.product_id").
      where("orders.completed" => true)

    products = all_products.collect do |product|
      amount = order_items.inject(0) do |sum, i|
        if i.product_id == product.id
          sum + i.quantity
        else
          sum
        end
      end

      {
        id: product.id,
        name: product.name,
        count: amount
      }
    end

    products.sort_by! {|p| p[:count] }

    @top_count = products[-(args[:count])..-1]

    render
  end
end
