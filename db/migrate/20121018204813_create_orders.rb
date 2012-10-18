class CreateOrders < ActiveRecord::Migration
  def up
  	create_table :orders do |t|
  		t.integer :buyer_id
  		t.boolean :completed, default: false

  		t.timestamps
  	end
  end

  def down
  	drop_table :orders
  end
end
