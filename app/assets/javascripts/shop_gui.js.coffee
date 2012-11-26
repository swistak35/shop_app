class @ShopGui
  constructor: ->

  compileTemplate: (name) ->
    template_name = "#" + name + "-template"
    source = $(template_name).html()
    Handlebars.compile(source)

  renderTemplate: (name, context = {})->
    template = @compileTemplate(name)
    template(context)

  renderMainLayout: ->
    $("#main").html @renderTemplate("main-layout")
    $(".home").click (event)=>
      event.preventDefault()
      @homeClicked()
    that = this
    $("#search").submit (event)->
      event.preventDefault()
      that.searchFormSubmitted(
        $(this).children("input[name=q_name_cont]").val(),
        $(this).children("input[name=desc_search]").attr("checked") == "checked",
        $(this).children("input[name=q_price_gteq]").val(),
        $(this).children("input[name=q_price_lteq]").val(),
      )
    $("#notice .close, #warning .close").click (event)->
      event.preventDefault()
      $(this).parent().hide()

  renderCategoriesMenu: ->
    $(".categoryShow").remove();
    template = @compileTemplate("menu-category")
    for category in useCase.categories
      $("#menu").append(template(category))

    that = this
    $(".categoryShow").click (event)->
      event.preventDefault()
      category_id = $(this).data('categoryid')
      that.categoryShowClicked(category_id)

  renderHomePage: ->
    $("#content").html @renderTemplate("home-page")

  renderProducts: (products)->
    context = { slices: [] }

    productsRows = Math.ceil(useCase.products.count() / 4)
    for i in [0..(productsRows-1)]
      context.slices.push({ products: products.slice(i*3, (i+1)*3) })
    $("#content").html @renderTemplate("products", context)

    that = this
    $(".productShow").click (event)->
      event.preventDefault()
      product_id = $(this).data('productid')
      that.productShowClicked(product_id)

  renderProduct: (product)->
    $("#content").html @renderTemplate("product", product)
    $(".back-button").click (event)->
      event.preventDefault()
      window.history.back()
    that = this
    $(".form-addProductToCart").submit (event)->
      event.preventDefault()
      that.addProductToCartFormSubmitted(
        $(this).children("input[name=id]").val(),
        $(this).children("input[name=quantity]").val()
      )

  renderCartInfo: (amount)->
    context = { amount: amount }
    if (amount == 0)
      context['amount_equal_to_zero'] = true
    if (amount == 1)
      context['amount_equal_to_one'] = true
    if (amount >  1)
      context['amount_bigger_than_one'] = true

    $("#cart-info").html @renderTemplate("cart-info", context)
    $("#cart-info").click (event)=>
      event.preventDefault()
      @cartInfoClicked()

  renderCartItems: (items)->
    context = { items: items }

    $("#cart-items").html @renderTemplate("cart-items", context)
    that = this
    $(".productShow").click (event)->
      event.preventDefault()
      product_id = $(this).data('productid')
      that.productShowClicked(product_id)

  renderNotice: (notice)->
    $("#notice span").text(notice)
    $("#notice").show()

  renderWarning: (warning)->
    $("#warning span").text(warning)
    $("#warning").show()

  homeClicked: ->
  categoryShowClicked: (id)->
  productShowClicked: (id)->
  cartInfoClicked: ->
  addProductToCartFormSubmitted: (id, quantity)->
  searchFormSubmitted: (name_cont, desc, price_from, price_to)->
  renderCartShow: (cart)->
    $("#content").html @renderTemplate("cart-show", cart)
    $(".proceed").click (event)=>
      event.preventDefault()
      @proceedClicked()
    $("#cartUpdate").submit (event)=>
      event.preventDefault()
      result = {}
      $.each $("#cartUpdate input"), (index, item)->
        result[item.name] = item.value
      @cartUpdateFormSubmitted(result)
  cartUpdateFormSubmitted: (params)->
  proceedClicked: ->
  renderProceedPage: (cart)->
    $("#content").html @renderTemplate("proceed-page", cart)
    $("#proceedForm").submit (event)=>
      event.preventDefault()
      result = {}
      $.each $("#proceedForm input"), (index, item)->
        result[item.name] = item.value
      @proceedFormSubmitted(result)
  proceedFormSubmitted: (params)->
  renderCompletedPayment: (id)->
    context = { id: id }
    $("#content").html @renderTemplate("completed-payment", context)