class Buyer < ActiveRecord::Base
	has_many :orders
	
	def current_order
		orders.where(completed: false).last || self.orders.create
	end
end