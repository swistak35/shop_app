class @ApiStorage
  constructor: ->

  getCategories: =>
    $.getJSON "/categories.json", (data, status) => @downloadCategories(data)

  downloadCategories: (data)->
    useCase.categories = []
    $.each data, (index, item)->
      useCase.categories.push(new Category(item.id, item.name))

  getProducts: =>
    $.getJSON "/products.json", (data, status) => @downloadProducts(data)

  downloadProducts: (data)->
    useCase.products = []
    $.each data, (index, item)->
      useCase.products.push(new Product(item.id, item.name, item.price, item.desc, item.category_id))

  getCart: ->
    $.getJSON "/cart.json", (data, status) => @downloadCart(data)

  downloadCart: (data)->
    useCase.cart = new Cart()
    $.each data.items, (index, item)->
      useCase.cart.items.push(new OrderItem(item.id, item.price, item.product_id, item.quantity))
    useCase.cart.calculate_total_cost()

  addProductRequest: (id, quantity)->
    $.ajax({
      url: "/cart/add_product.json",
      data: { id: id, quantity: quantity },
      type: 'POST',
      async: false,
      success: (data, textStatus, jqXHR)=>
        @receiveNotice(data.notice)
        @addedToCart()
    })

  receiveNotice: (notice)->
  addedToCart: () ->

  cartUpdateRequest: (params)->
    params['_method'] = 'PUT'
    $.ajax({
      url: "/cart.json",
      data: params,
      type: 'POST',
      async: false,
      success: (data, textStatus, jqXHR)=>
        @receiveNotice(data.notice)
        @updatedCart()
    })
  updatedCart: ->
  completePaymentRequest: (params)->
    params['_method'] = 'PUT'
    $.ajax({
      url: "/cart/complete.json",
      data: params,
      type: 'POST',
      async: false,
      success: (data, textStatus, jqXHR)=>
        if data.status == "failed"
          @paymentRejected(data.warning)
        else
          @paymentCompleted(data.order_id)
    })
  paymentRejected: (warning)->
  paymentCompleted: (id)->