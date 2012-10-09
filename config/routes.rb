ShopApp::Application.routes.draw do
	resources :categories
  resources :products
  root to: "shop#index"
end
