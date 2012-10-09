class Product < ActiveRecord::Base
	attr_accessible :name, :desc, :price
end