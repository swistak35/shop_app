class Order < ActiveRecord::Base
	belongs_to :buyer
	has_many :order_items

	def amount_of_items
		self.order_items.count
	end
end