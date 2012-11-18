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


class BuyingProductsUseCase
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

class HistoryGuardian
	constructor: (@params)->
		@initWindowPopStateFunction()
		@prepared = 0

	increasePrepared: (phase)->
		@prepared += 1

	initPage: ->
		if @prepared >= 3
			if @params['path']
				words = @params['path'].split("/")
				page = words[0]
				elementId = words[1]
				if page == "categories" && elementId
					useCase.categoryShow(parseInt(elementId))
				else if page == "products" && elementId
					useCase.productShow(parseInt(elementId))
				else if page == "search"
					useCase.search(
						@params['name_cont'],
						(@params['desc'] == "true"),
						parseInt(@params['price_from']),
						parseInt(@params['price_to'])
					)
				else if page == "cart"
					useCase.cartShow()
				else
					useCase.homePage()
			else
				useCase.homePage()

	categoryShow: (id)->
		window.history.pushState(
			{ page: 'categoryShow', category_id: id },
			"Category Show",
			'/spa/categories/'+id
		)
	productShow: (id)->
		window.history.pushState(
			{ page: 'productShow', product_id: id },
			'Product Show',
			'/spa/products/'+id
		)
	cartShow: ->
		window.history.pushState(
			{ page: 'cartShow' },
			'Cart',
			'/spa/cart'
		)
	homePage: ->
		window.history.pushState(
			{ page: 'homepage' },
			'Home',
			'/spa/'
		)
	search: (name_cont, desc, price_from, price_to)->
		window.history.pushState(
			{
				page: 'search',
				name_cont: name_cont,
				desc: desc,
				price_from: price_from,
				price_to: price_to
			},
			'Search',
			'/spa/search?name_cont='+name_cont+"&desc="+desc+"&price_from="+price_from+"&price_to="+price_to
		)

	initWindowPopStateFunction: ->
		window.onpopstate = (event)->
			if event.state && event.state.page
				if event.state.page == "categoryShow" && event.state.category_id
					useCase.categoryShow(event.state.category_id)
				if event.state.page == "cartShow"
					useCase.cartShow()
				if event.state.page == "productShow" && event.state.product_id
					useCase.productShow(event.state.product_id)
				if event.state.page == "homepage"
					useCase.homePage()
				if event.state.page == "search"
					name_cont = event.state.name_cont
					name_cont ?= ""
					desc = event.state.desc
					desc ?= false
					price_from = event.state.price_from
					price_from ?= ""
					price_to = event.state.price_to
					price_to ?= ""
					useCase.search(name_cont, desc, price_from, price_to)


class ShopGlue
	constructor: (@useCase, @gui, @storage, @historyGuardian)->
		Before(@useCase, 'initMainPage', => @storage.getCategories())
		Before(@useCase, 'initMainPage', => @storage.getProducts())
		Before(@useCase, 'initMainPage', => @storage.getCart())
		After(@useCase, 'initMainPage', => @gui.renderMainLayout())

		# We don't know which from these 3 will be the slowest, so we will
		#		try to render initPage after each...
		After(@gui, 'renderMainLayout', => @historyGuardian.increasePrepared())
		After(@storage, 'downloadProducts', => @historyGuardian.increasePrepared())
		After(@storage, 'downloadCategories', => @historyGuardian.increasePrepared())
		After(@historyGuardian, 'increasePrepared', => @historyGuardian.initPage())

		After(@storage, 'downloadCategories', => @gui.renderCategoriesMenu())
		After(@storage, 'downloadCart', => @gui.renderCartInfo(
			@useCase.cart.amount_of_items()
		))
		AfterAll(@storage, ['downloadCart', 'downloadProducts'], => @gui.renderCartItems(
			@useCase.cart.items
		))
		
		After(@gui, 'categoryShowClicked', (id) => @useCase.categoryShow(id))
		After(@useCase, 'categoryShow', (id) => @gui.renderProducts(
			@useCase.productsFromCategory(@useCase.findCategory(id))
		))
		After(@useCase, 'categoryShow', (id)=> @historyGuardian.categoryShow(id))
		
		After(@gui, 'homeClicked', => @useCase.homePage())
		After(@useCase, 'homePage', => @gui.renderHomePage())
		After(@useCase, 'homePage', => @historyGuardian.homePage())
		
		After(@gui, 'productShowClicked', (id) => @useCase.productShow(id))
		After(@useCase, 'productShow', (id) => @gui.renderProduct(@useCase.findProduct(id)))
		After(@useCase, 'productShow', (id) => @historyGuardian.productShow(id))

		After(@gui, 'addProductToCartFormSubmitted', (id, quantity)=> @useCase.addToCart(id, quantity))
		Before(@useCase, 'addToCart', (id, quantity)=> @storage.addProductRequest(id, quantity))
		After(@storage, 'receiveNotice', (notice)=> @gui.renderNotice(notice))
		After(@storage, 'addedToCart', => @storage.getCart())

		After(@gui, 'searchFormSubmitted', (name_cont, desc, price_from, price_to) => @useCase.search(name_cont, desc, price_from, price_to))
		After(@useCase, 'search', (name_cont, desc, price_from, price_to)=> @gui.renderProducts(
			@useCase.searchProducts(name_cont, desc, price_from, price_to)
		))
		After(@useCase, 'search', (name_cont, desc, price_from, price_to)=> @historyGuardian.search(name_cont, desc, price_from, price_to))

		After(@gui, 'cartInfoClicked', => @useCase.cartShow())
		After(@useCase, 'cartShow', => @gui.renderCartShow(@useCase.cart))
		After(@useCase, 'cartShow', => @historyGuardian.cartShow())

		After(@gui, 'cartUpdateFormSubmitted', (params)=> @useCase.cartUpdate(params))
		Before(@useCase, 'cartUpdate', (params)=> @storage.cartUpdateRequest(params))
		After(@storage, 'updatedCart', => @useCase.cartShow())
		Before(@useCase, 'cartShow', => @storage.getCart())

		After(@gui, 'proceedClicked', => @useCase.proceed())
		After(@useCase, 'proceed', => @gui.renderProceedPage(@useCase.cart))

		After(@gui, 'proceedFormSubmitted', (params)=> @useCase.proceedUpdate(params))
		Before(@useCase, 'proceedUpdate', (params)=> @storage.completePaymentRequest(params))
		After(@storage, 'paymentCompleted', (id)=> @useCase.completedPayment(id))
		After(@storage, 'paymentRejected', => @useCase.proceed())
		After(@storage, 'paymentRejected', (warning)=> @gui.renderWarning(warning))

		After(@useCase, 'completedPayment', (id)=> @gui.renderCompletedPayment(id))
		After(@useCase, 'completedPayment', => @storage.getCart())

class ShopApp
	constructor: ->
		useCase = new BuyingProductsUseCase()
		window.useCase = useCase
		gui = new ShopGui()
		apiStorage = new ApiStorage()
		historyGuardian = new HistoryGuardian($("#main").data("initpath"))
		glue = new ShopGlue(useCase, gui, apiStorage, historyGuardian)
		window.storage = apiStorage #for debugging
		window.gui = gui #for debugging
		useCase.initMainPage()

class OrderItem
	constructor: (@id, @price, @product_id, @quantity)->
		@cost = @quantity * @price

	product: ->
		useCase.findProduct(@product_id)

	product_name: =>
		product = @product()
		product.name if product?

	quantity_bigger_than_one: ->
		@quantity > 1

class Cart
	constructor: ()->
		@items = []
		@total_cost = 0

	amount_of_items: ()->
		@items.count()

	amount_bigger_than_zero: ()->
		@amount_of_items() > 0

	calculate_total_cost: ->
		@total_cost = @items.reduce ((sum, item)-> sum + item.price), 0

class Category
	constructor: (@id, @name) ->

class Product
	constructor: (@id, @name, @price, @desc, @category_id) ->

$(document).ready ()->
	new ShopApp()