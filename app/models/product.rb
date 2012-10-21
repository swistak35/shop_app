class Product < ActiveRecord::Base
	attr_accessible :name, :desc, :price, :category_id

	belongs_to :category
	has_many :order_items

	scope :sorted, lambda { order("name ASC") }

	validates :name, :desc, :price, presence: true

	validates :price, format: {
		with: /\A\d+\.\d{2}\z/,
		message: "has invalid format. Format should be for ex. '13.45'."
	}
end