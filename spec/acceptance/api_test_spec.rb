require "spec_helper"

feature do
  background do
    headers = {'HTTP_ACCEPT' => 'application/json'}
    @client = Bbq::TestClient.new(:headers => headers)
  end

  scenario "fetching categories" do
    @category = Category.create(name: "test category")

    @client.get "/categories.json" do |response|
      response.status.should == 200
      response.body[0]["name"].should == "test category"
    end
  end

  scenario "fetching products" do
    @product1 = Product.create(name: "czarna herbata", desc: "pyszna", price: 3.0)
    @product2 = Product.create(name: "dzbanek", desc: "szklany", price: 40.0)

    @client.get "/products.json" do |response|
      response.status.should == 200
      products = response.body.map {|p| p["name"] }
      products.should include(@product1.name)
      products.should include(@product2.name)
    end
  end

  scenario "adding products" do
    @product1 = Product.create(name: "czarna herbata", desc: "pyszna", price: 3.0)
    @product2 = Product.create(name: "dzbanek", desc: "szklany", price: 40.0)

    @client.get "/cart.json" do |response|
      response.status.should == 200
      response.body["items"].should == []
    end

    @client.post "/cart/add_product.json", { id: @product1.id, quantity: 2 } do |response|
      response.status.should == 200
      response.body["notice"].should == "Product added to the cart."
    end

    @client.get "/cart.json" do |response|
      @order_item_id = response.body["items"][0]["id"]

      response.status.should == 200
      response.body["items"].count.should == 1
      response.body["items"][0]["quantity"].should == 2
      response.body["items"][0]["product_id"].should == @product1.id
      response.body["items"][0]["price"].should == 3.0
    end

    @client.post "/cart/add_product.json", { id: @product1.id, quantity: 3 } do |response|
      response.status.should == 200
      response.body["notice"].should == "Increased quantity of this product in the cart."
    end

    @client.get "/cart.json" do |response|
      response.status.should == 200
      response.body["items"].count.should == 1
      response.body["items"][0]["quantity"].should == 5
      response.body["items"][0]["product_id"].should == @product1.id
      response.body["items"][0]["price"].should == 3.0
    end

    params = {
      "order" => {
        "items_attributes" => {
          "#{@order_item_id}" => {
            "quantity" => "6",
            "id" => @order_item_id
          }
        }
      },
      "commit" => "Update"
    }

    @client.put "/cart.json", params do |response|
      response.status.should == 200
      response.body["notice"].should == "Cart updated successfully."
    end

    @client.get "/cart.json" do |response|
      response.status.should == 200
      response.body["items"].count.should == 1
      response.body["items"][0]["quantity"].should == 6
      response.body["items"][0]["product_id"].should == @product1.id
      response.body["items"][0]["price"].should == 3.0
    end
  end
end