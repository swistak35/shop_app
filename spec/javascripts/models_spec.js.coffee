# use require to load any .js file available to the asset pipeline
#= require jquery
#= require jquery_ujs
#= require bootstrap.min
#= require jquery.json-2.3.min
#= require uuid
#= require underscore
#= require sugar-1.3.min
#= require handlebars-1.0.rc.1
#= require YouAreDaBomb
#= require utils
#= require shop_gui
#= require shop_use_case
#= require history_guardian
#= require api_storage
#= require shop_glue
#= require models

# Mocks:
window.useCase = {
  findProduct: (id)->
    return {
      name: "Test"+id
    }
}

describe "Cart", ->
  describe "without items", ->
    beforeEach =>
      @cart = new Cart()
    
    it "can calculate total cost", =>
      @cart.calculate_total_cost()
      expect(@cart.total_cost).toBe(0.0)

    it "can return cart size", =>
      expect(@cart.amount_of_items()).toBe(0)

    it "can return if amount_bigger_than_zero", =>
      expect(@cart.amount_bigger_than_zero()).toBe(false)

  describe "with items", ->
    beforeEach =>
      @item1 = new OrderItem(1, 9.99, 123, 2)
      @item2 = new OrderItem(2, 3.00, 125, 1)
      @cart = new Cart()
      @cart.items.push(@item1)
      @cart.items.push(@item2)
    
    it "can calculate total cost", =>
      @cart.calculate_total_cost()
      expect(@cart.total_cost).toBe(22.98)

    it "can return cart size", =>
      expect(@cart.amount_of_items()).toBe(2)

    it "can return if amount_bigger_than_zero", =>
      expect(@cart.amount_bigger_than_zero()).toBe(true)

describe "OrderItem", ->
  beforeEach =>
    @item = new OrderItem(1, 9.99, 123, 1)

  it "should know product name", =>
    expect(@item.product_name()).toBe("Test123")

  describe "with quantity equal 1", ->
    beforeEach =>
      @item = new OrderItem(1, 9.99, 123, 1)

    it "should have cost", =>
      expect(@item.cost).toBe(@item.price)
      expect(@item.cost).toBe(9.99)

    it "should know if quantity is bigger than one", =>
      expect(@item.quantity_bigger_than_one()).toBe(false)

  describe "with quantity bigger than 1", ->
    beforeEach =>
      @item = new OrderItem(1, 9.99, 123, 2)

    it "should have cost", =>
      expect(@item.cost).toBe(@item.price*2)
      expect(@item.cost).toBe(19.98)

    it "should know if quantity is bigger than one", =>
      expect(@item.quantity_bigger_than_one()).toBe(true)