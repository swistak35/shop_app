require 'test_helper'
 
class ProductTest < ActiveSupport::TestCase
  test "price format" do
  	product = Product.new(name: "xxx", desc: "xxx")
    
    ["xxx", "3", "3.", "3.9", "3.999", "3,99", "a3.99", "3.99a"].each do |test_price|
    	assert !product.valid?
    end

    product.price = "3.99"
    assert product.valid?
  end
end