class Product < ActiveRecord::Base
	attr_accessible :name, :desc, :price

	belongs_to :category
	has_many :order_items
end