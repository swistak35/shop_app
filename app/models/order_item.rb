class OrderItem < ActiveRecord::Base
	attr_accessible :price, :product_id

	delegate :name, :desc, to: :product,
					prefix: true, allow_nil: true

	belongs_to :order
	belongs_to :product
end