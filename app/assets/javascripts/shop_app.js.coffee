class @ShopApp
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

$(document).ready ()->
	new ShopApp()