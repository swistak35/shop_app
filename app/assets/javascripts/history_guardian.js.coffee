class @HistoryGuardian
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