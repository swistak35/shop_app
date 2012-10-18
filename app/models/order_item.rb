class OrderItem < ActiveRecord::Base
	attr_accessible :price

	belongs_to :order
	belongs_to :product
end