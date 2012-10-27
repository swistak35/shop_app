require 'spec_helper'

describe Order do
	subject(:order) { Order.create }
	let(:product) { Product.create(name: "xxx", desc: "xxx", price: "3.99") }

	context "with 0 items" do
		its(:amount_of_items) { should == 0 }
		its(:total_cost) { should == 0 }

		describe "add_product" do
			it "should change 'amount of items' by 1" do
				expect {
					order.add_product(product, 1)
				}.to change {
					order.amount_of_items
				}.by(1)
			end
		end
	end

	context "with more than 0 items" do
		let(:product) { Product.create(name: "xxx", desc: "xxx", price: "3.99") }
		let!(:order_item) { order.items.create(product_id: product.id, price: product.price, quantity: 2) }

		its(:amount_of_items) { should == 1 }
		its(:total_cost) { should == 7.98 }

		describe "remove_items_with_wrong_quantity callback" do
			it "should remove all unnecessary order_items" do
				expect {
					order.update_attributes({"items_attributes"=>{"0"=>{"quantity"=>"0", "id"=>"#{order_item.id}"}}})
				}.to change {
					order.amount_of_items
				}.by(-1)
			end
		end

		describe "add_product" do
			it "should not change 'amount_of_items'" do
				expect {
					order.add_product(product, 1)
				}.to change {
					order.amount_of_items
				}.by(0)
			end

			it "should change order_item.quantity by 1" do
				expect {
					order.add_product(product, 1)
				}.to change {
					order.items.where(product_id: product.id).first.quantity
				}.by(1)
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