class Order < ActiveRecord::Base
	belongs_to :buyer
	has_many :items, class_name: 'OrderItem'

	attr_accessible :items_attributes

	accepts_nested_attributes_for :items

	after_update :remove_items_with_wrong_quantity

	def amount_of_items
		self.items.count
	end

	def total_cost
		self.items.inject(0) do |sum, i|
			sum += i.cost
		end.round(2)
	end

	def remove_items_with_wrong_quantity
		self.items.where("quantity <= 0").delete_all
	end
end