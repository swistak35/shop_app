class ShopGui
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
		$(".home").click => @homeClicked()

	renderCategoriesMenu: ->
		$(".categoryShow").remove();
		template = @compileTemplate("menu-category")
		for category in useCase.categories
			$("#menu").append(template(category))

		$(".categoryShow").click => @categoryShowClicked(`$(this).data('categoryid')`)

	renderHomePage: ->
		$("#content").html @renderTemplate("home-page")

	renderProducts: (products)->
		context = { slices: [] }

		productsRows = Math.ceil(useCase.products.count() / 4)
		for i in [0..(productsRows-1)]
			context.slices.push({ products: products.slice(i*3, (i+1)*3) })

		$("#content").html @renderTemplate("products", context)
		$(".productShow").click => @productShowClicked(`$(this).data('productid')`)

	renderProduct: (product)->
		$("#content").html @renderTemplate("product", product)

	renderCartInfo: ->
		amount = useCase.cart.amount_of_items()
		context = {
			amount: amount
		}
		if (amount == 0)
			context['amount_equal_to_zero'] = true
		if (amount == 1)
			context['amount_equal_to_one'] = true
		if (amount >  1)
			context['amount_bigger_than_one'] = true

		$("#cart-info").html @renderTemplate("cart-info", context)
		$("#cart-info").click => @cartInfoClicked()

	homeClicked: ->
	categoryShowClicked: (id)->
	productShowClicked: (id)->
	cartInfoClicked: (id)->

class BuyingProductsUseCase
	constructor: ->
		@categories = []
		@products = []
		@cart = null

	initMainPage: ->
	homePage: ->

	productsFromCategory: (category) =>
		product for product in @products when product.category_id is category.id

	findCategory: (id) =>
		(category for category in @categories when category.id is id).first()

	findProduct: (id) =>
		(product for product in @products when product.id is id).first()

	categoryShow: (id)->
	productShow: (id)->


class ApiStorage
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


class ShopGlue
	constructor: (@useCase, @gui, @storage)->
		Before(@useCase, 'initMainPage', => @storage.getCategories())
		Before(@useCase, 'initMainPage', => @storage.getProducts())
		Before(@useCase, 'initMainPage', => @storage.getCart())
		After(@useCase, 'initMainPage', => @gui.renderMainLayout())
		After(@gui, 'renderMainLayout', => @useCase.homePage())
		
		After(@storage, 'downloadCategories', => @gui.renderCategoriesMenu())
		After(@storage, 'downloadCart', => @gui.renderCartInfo())
		
		After(@gui, 'categoryShowClicked', (id) => @useCase.categoryShow(id))
		After(@useCase, 'categoryShow', (id) => @gui.renderProducts(
			@useCase.productsFromCategory(@useCase.findCategory(id))
		))
		
		After(@gui, 'homeClicked', => @useCase.homePage())
		After(@useCase, 'homePage', => @gui.renderHomePage())
		
		After(@gui, 'productShowClicked', (id) => @useCase.productShow(id))
		After(@useCase, 'productShow', (id) => @gui.renderProduct(@useCase.findProduct(id)))


class ShopApp
	constructor: ->
		useCase = new BuyingProductsUseCase()
		window.useCase = useCase
		gui = new ShopGui()
		apiStorage = new ApiStorage()
		glue = new ShopGlue(useCase, gui, apiStorage)
		window.storage = apiStorage #for debugging
		window.gui = gui #for debugging
		useCase.initMainPage()

class OrderItem
	constructor: (@id, @price, @product_id, @quantity)->

	product: ->
		useCase.findProduct(@product_id)

class Cart
	constructor: ()->
		@items = []

	amount_of_items: ()->
		@items.count()

class Category
	constructor: (@id, @name) ->

class Product
	constructor: (@id, @name, @price, @desc, @category_id) ->

$(document).ready ()->
	new ShopApp()