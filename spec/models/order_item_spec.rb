require 'spec_helper'

describe OrderItem do
	let(:product) { Product.create(name: "xxx", desc: "xxx", price: "3.99") }
	subject(:order_item) { OrderItem.create(product_id: product.id, price: product.price, quantity: 2) }

	describe "cost" do
		its(:cost) { should == 7.98 }
	end

	describe "after increase_quantity_by" do
		before(:each) { order_item.increase_quantity_by(3) }

		its(:cost) { should == 19.95 }
		its(:quantity) { should == 5 }
	end
end