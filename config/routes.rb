ShopApp::Application.routes.draw do
	resource :cart, only: [:show, :update] do
		post 'add_product'
		get 'payment'
		put 'complete'
	end

	resources :categories, only: [:show]
  resources :products, only: [:show]
  
  root to: "shop#index"
end
