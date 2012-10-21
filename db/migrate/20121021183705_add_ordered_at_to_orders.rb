class AddOrderedAtToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :ordered_at, :timestamp
  end
end
