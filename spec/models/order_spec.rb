require 'spec_helper'

describe Order do
	subject(:order) { Order.create }

	context "with 0 items" do
		its(:amount_of_items) { should == 0 }
		its(:total_cost) { should == 0 }
	end

	context "with more than 0 items" do
		let(:product) { Product.create(name: "xxx", desc: "xxx", price: "3.99") }
		let!(:order_item) { order.items.create(product_id: product.id, price: product.price, quantity: 2) }

		describe "amount_of_items" do
			it "should be equal amount of items" do
				order.amount_of_items.should == 1
			end
		end

		describe "total_cost" do
			it "should be equal total cost of all items" do
				order.total_cost.should == 7.98
			end
		end

		describe "remove_items_with_wrong_quantity callback" do
			let!(:order_item2) { order.items.create(product_id: product.id, price: product.price, quantity: 1) }

			it "should remove all unnecessary order_items" do
				expect {
					order.update_attributes({"items_attributes"=>{"0"=>{"quantity"=>"0", "id"=>"#{order_item2.id}"}}})
				}.to change {
					order.amount_of_items
				}.by(-1)
			end
		end
	end

	describe "complete!" do
		context "not completed" do
			its(:completed) { should be_false }
		end

		context "completed" do
			before(:each) do
				@time_now = Time.parse("Feb 24 2011")
				Time.stub!(:now).and_return(@time_now)
				order.complete!
			end

			its(:completed) { should be_true }
			its(:ordered_at) { should == Time.now }
		end
	end
end