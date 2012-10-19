class CreateAddresses < ActiveRecord::Migration
  def up
  	create_table :addresses do |t|
  		t.integer :order_id
  		
  		t.string :first_name
  		t.string :last_name

  		t.timestamps
  	end
  end

  def down
  	drop_table :addresses
  end
end
