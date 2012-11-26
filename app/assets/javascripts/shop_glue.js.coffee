class @ShopGlue
  constructor: (@useCase, @gui, @storage, @historyGuardian)->
    Before(@useCase, 'initMainPage', => @storage.getCategories())
    Before(@useCase, 'initMainPage', => @storage.getProducts())
    Before(@useCase, 'initMainPage', => @storage.getCart())
    After(@useCase, 'initMainPage', => @gui.renderMainLayout())

    # We don't know which from these 3 will be the slowest, so we will
    #   try to render initPage after each...
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