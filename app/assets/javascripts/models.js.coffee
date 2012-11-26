class @OrderItem
  constructor: (@id, @price, @product_id, @quantity)->
    @cost = @quantity * @price

  product: ->
    useCase.findProduct(@product_id)

  product_name: =>
    product = @product()
    product.name if product?

  quantity_bigger_than_one: ->
    @quantity > 1

class @Cart
  constructor: ()->
    @items = []
    @total_cost = 0

  amount_of_items: ()->
    @items.count()

  amount_bigger_than_zero: ()->
    @amount_of_items() > 0

  calculate_total_cost: ->
    @total_cost = @items.reduce ((sum, item)-> sum + item.price), 0

class @Category
  constructor: (@id, @name) ->

class @Product
  constructor: (@id, @name, @price, @desc, @category_id) ->