class Buyer < ActiveRecord::Base
	has_many :orders
	
	def current_order
		orders.where(completed: false).order("created_at ASC").last || self.orders.create
	end
end