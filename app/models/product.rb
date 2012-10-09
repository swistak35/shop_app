class Product < ActiveRecord::Base
	attr_accessible :name, :desc, :price

	belongs_to :category
end