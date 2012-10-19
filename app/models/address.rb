class Address < ActiveRecord::Base
	attr_accessible :first_name, :last_name

	belongs_to :order

	validates :first_name, :last_name, presence: true
end