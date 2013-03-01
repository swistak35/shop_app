class @ShopApp
	constructor: ->
		useCase = new BuyingProductsUseCase()
		window.useCase = useCase
		gui = new ShopGui()
		apiStorage = new ApiStorage()
		historyGuardian = new HistoryGuardian($("#main").data("initpath"))
		glue = new ShopGlue(useCase, gui, apiStorage, historyGuardian)
		useCase.initMainPage()

$(document).ready ()->
	new ShopApp()