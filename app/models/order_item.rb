class OrderItem < ActiveRecord::Base
	attr_accessible :price, :product_id, :quantity

	delegate :name, :desc, to: :product,
					prefix: true, allow_nil: true

	belongs_to :order
	belongs_to :product

	def cost
		(self.quantity * self.price).round(2)
	end
end