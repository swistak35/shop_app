def random_number
  random_int = rand(63)
  if random_int < 32
    0
  elsif random_int < 48
    1
  elsif random_int < 56
    2
  elsif random_int < 60
    3
  elsif random_int < 62
    4
  else
    5
  end
end

@products = Product.all

5000.times do
  buyer = Buyer.create
  buyer.orders.create
  
  amount_of_orders = random_number
  
  amount_of_orders.times do
    order = buyer.orders.create
    amount_of_items = random_number
    
    amount_of_items.times do
      order.add_product(@products.sample, random_number+1)
    end
    
    order.create_address  first_name: Faker::Name.first_name,
                          last_name: Faker::Name.last_name
    
    order.save
    
    if random_number < 3
      order.complete! 
      order.ordered_at += 1.month
      order.save!
    end
  end
end
