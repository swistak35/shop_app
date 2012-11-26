# use require to load any .js file available to the asset pipeline
#= require jquery
#= require jquery_ujs
#= require bootstrap.min
#= require jquery.json-2.3.min
#= require uuid
#= require underscore
#= require sugar-1.3.min
#= require handlebars-1.0.rc.1
#= require YouAreDaBomb
#= require utils
#= require shop_gui
#= require shop_use_case
#= require history_guardian
#= require api_storage
#= require shop_glue
#= require models

describe "UseCase", ->
  beforeEach =>
    @useCase = new BuyingProductsUseCase()
    @category = new Category(1, "Herbaty")
    @useCase.categories.push(@category)
    @product1 = new Product(1, "zielona herbata", 5.00, "zdrowa i pyszna", 1)
    @product2 = new Product(2, "pyszna czarna herbata", 3.00, "smaczna", 1)
    @product3 = new Product(3, "dzbanek", 19.00, "z drewna", 2)
    @useCase.products.push(@product1)
    @useCase.products.push(@product2)
    @useCase.products.push(@product3)

  describe "productsFromCategory", =>
    it "should return all products from category", =>
      categories = @useCase.productsFromCategory(@category)
      expect(categories).toEqual([@product1, @product2])

  describe "findCategory", =>
    it "should return category when given id", =>
      expect(@useCase.findCategory(1)).toBe(@category)

  describe "findProduct", =>
    it "should return product when given id", =>
      expect(@useCase.findProduct(1)).toBe(@product1)
      expect(@useCase.findProduct(2)).toBe(@product2)
      expect(@useCase.findProduct(3)).toBe(@product3)
      
  describe "searchProducts", =>
    it "should search in name", =>
      products = @useCase.searchProducts("herbata", null, null, null)
      expect(products).toEqual([@product1, @product2])

    it "should search in desc", =>
      products = @useCase.searchProducts("pyszna", true, null, null)
      expect(products).toEqual([@product1, @product2])

    it "should filter with price_from", =>
      products = @useCase.searchProducts("", null, 4.0, null)
      expect(products).toEqual([@product1, @product3])

      products = @useCase.searchProducts("herbata", null, 4.0, null)
      expect(products).toEqual([@product1])

    it "should filter with price_to", =>
      products = @useCase.searchProducts("", null, null, 10.0)
      expect(products).toEqual([@product1, @product2])

      products = @useCase.searchProducts("", null, null, 2.0)
      expect(products).toEqual([])

    it "should filter with both price_from and price_to", =>
      products = @useCase.searchProducts("", null, 4.0, 10.0)
      expect(products).toEqual([@product1])

      products = @useCase.searchProducts("dzbanek", null, 4.0, 10.0)
      expect(products).toEqual([])