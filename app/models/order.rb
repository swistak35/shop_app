class Order < ActiveRecord::Base
	belongs_to :buyer
	has_many :items, class_name: 'OrderItem'

	def amount_of_items
		self.items.count
	end

	def total_cost
		self.items.inject(0) do |sum, i|
			sum += i.cost
		end.round(2)
	end
end