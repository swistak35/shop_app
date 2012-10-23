require 'spec_helper'

describe Buyer do
	subject(:buyer) { Buyer.create }

	describe "current_order" do
		context "if buyer doesn't have new order" do
			its(:current_order) { should_not be_nil }
		end
		
		context "if buyer has order" do
			let!(:order) { buyer.orders.create }

			its(:current_order) { should == order }
		end
	end
end