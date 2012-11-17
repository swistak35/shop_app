class ShopGlue
  constructor: (@useCase, @gui, @storage)->
  	After(@useCase, 'renderLayout', @gui.renderLayout)