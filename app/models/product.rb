class Product < ActiveRecord::Base
	attr_accessible :name, :desc, :price, :category_id

	belongs_to :category
	has_many :order_items

	validates :name, :desc, :price, presence: true

	validates :price, format: {
		with: /\A\d+(\.\d{2})?\Z/,
		message: "has invalid format. Format should be for ex. '3' or '13.45'."
	}
end