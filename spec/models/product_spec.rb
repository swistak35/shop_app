require 'spec_helper'

describe Product do
  describe "price format" do
    let(:product) { Product.new(name: "xxx", desc: "yyy") }

    it "price 3.9 should not be valid" do
      product.price = "3.9"
      product.valid?
      product.errors.keys.should include(:price)
    end

    it "price 3.99 should be valid" do
      product.price = "3.99"
      product.valid?
      product.errors.keys.should_not include(:price)
    end

    it "price 3.999 should not be valid" do
      product.price = "3.999"
      product.valid?
      product.errors.keys.should include(:price)
    end

    it "price 3,99 should not be valid" do
      product.price = "3,99"
      product.valid?
      product.errors.keys.should include(:price)
    end

    it "price 3 should not be valid" do
      product.price = "3"
      product.valid?
      product.errors.keys.should include(:price)
    end

    it "price 3. should not be valid" do
      product.price = "3."
      product.valid?
      product.errors.keys.should include(:price)
    end

    it "price 3.0 should be valid" do
      product.price = "3.0"
      product.valid?
      product.errors.keys.should_not include(:price)
    end

    it "price xxx3.99 should not be valid" do
      product.price = "xxx3.99"
      product.valid?
      product.errors.keys.should include(:price)
    end

    it "price 3.90 should be valid" do
      product.price = "3.90"
      product.valid?
      product.errors.keys.should_not include(:price)
    end
  end
end