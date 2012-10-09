class CreateCategories < ActiveRecord::Migration
  def up
  	create_table :categories do |t|
  		t.string :name

  		t.timestamps
  	end
  	add_column :products, :category_id, :integer
  end

  def down
  	remove_column :products, :category_id
  	drop_table :categories
  end
end
