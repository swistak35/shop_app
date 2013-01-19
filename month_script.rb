last_parsed_id = 0

12.times do |i|
  actual_time = Time.utc(2012, i+1, 15)
  count = Order.count / 12
  deviation = rand(count / 35) - (count / 60)
  amount = count + deviation
  orders = Order.where("id > ?", last_parsed_id).order("id ASC").limit(amount)
  orders.update_all(created_at: actual_time)
  orders.where("ordered_at IS NOT NULL").update_all(ordered_at: actual_time)
  ids = orders.pluck(:buyer_id)
  Buyer.where("created_at > ?", actual_time).where(id: (ids.min)..(ids.max)).update_all(created_at: actual_time)
  last_parsed_id = orders.last.id
end
