require 'spec_helper'

describe Category do
	describe "products_count should return amount of products in category" do
		subject(:category) { Category.create(name: "teas") }

		context "with 0 products" do
			its(:products_count) { should == 0 }
		end

		context "with 1 product" do
			let!(:product) { category.products.create(name: "xxx", desc: "yyy", price: "3.99") }

			its(:products_count) { should == 1 }
		end
	end
end