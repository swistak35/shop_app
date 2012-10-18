ShopApp::Application.routes.draw do
	resources :categories, only: [:show]
  resources :products, only: [:show]
  
  root to: "shop#index"
end
