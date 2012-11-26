class @BuyingProductsUseCase
  constructor: ->
    @categories = []
    @products = []
    @cart = new Cart()

  initMainPage: ->
  homePage: ->

  productsFromCategory: (category) =>
    product for product in @products when product.category_id is category.id

  findCategory: (id) =>
    (category for category in @categories when category.id is id).first()

  findProduct: (id) =>
    (product for product in @products when product.id is id).first()

  categoryShow: (id)->
    console.log("Id: "+id)
    console.log("Kategorie: "+useCase.categories.count())
  productShow: (id)->
  addToCart: (id, quantity)->
  searchProducts: (name_cont, desc, price_from, price_to)->
    result = @products
    if desc
      result = result.filter (product) -> (product.name.has(name_cont) or product.desc.has(name_cont))
    else
      result = result.filter (product) -> product.name.has(name_cont)
    if price_from then result = result.filter (product) -> product.price >= price_from
    if price_to then result = result.filter (product) -> product.price <= price_to
    result
  cartShow: ->
  cartUpdate: ->
  proceed: ->
  proceedUpdate: ->
  completedPayment: (id)->
  search: (name_cont, desc, price_from, price_to)->