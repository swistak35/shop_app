ShopApp::Application.routes.draw do
	resource :cart, only: [:show] do
		post 'add_product'
	end
	resources :categories, only: [:show]
  resources :products, only: [:show]
  
  root to: "shop#index"
end
