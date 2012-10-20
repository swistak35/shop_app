class Category < ActiveRecord::Base
	attr_accessible :name

	has_many :products

	validates :name, presence: true

	scope :sorted, lambda { order("name ASC") }

	def products_count
		self.products.count
	end
end