class CreateBuyers < ActiveRecord::Migration
  def up
  	create_table :buyers do |t|
  		t.timestamps
  	end
  end

  def down
  	drop_table :buyers
  end
end
