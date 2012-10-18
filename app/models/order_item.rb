class OrderItem < ActiveRecord::Base
	attr_accessible :price, :product_id

	delegate :name, :desc, to: :product,
					prefix: true, allow_nil: true

	belongs_to :order
	belongs_to :product

	def quantity
		2
	end

	def cost
		self.quantity * self.price
	end
end