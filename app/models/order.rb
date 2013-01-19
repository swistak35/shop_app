class Order < ActiveRecord::Base
	belongs_to :buyer
	has_many :items, class_name: 'OrderItem'
	has_many :products, through: :items
	has_one :address

	attr_accessible :items_attributes, :address_attributes

	scope :completed, lambda { where(completed: true) }

	accepts_nested_attributes_for :items
	accepts_nested_attributes_for :address

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

	def complete!
		self.completed = true
		self.ordered_at = Time.now
		self.save
	end

	def add_product(product, amount)
		matching_items = items.where("order_items.product_id = ?", product.id)

		if matching_items.empty?
			items.create(
				product_id: product.id,
				price: product.price,
				quantity: amount)
			return :added
		else
			order_item = matching_items.first
			return :amount_increased if order_item.increase_quantity_by(amount)
		end
	end
	
	def self.to_csv(options = {})
	  CSV.generate(options) do |csv|
	    csv << column_names
	    all.each do |product|
	      csv << product.attributes.values_at(*column_names)
	    end
	  end
	end
end