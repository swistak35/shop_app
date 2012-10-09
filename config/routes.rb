ShopApp::Application.routes.draw do
  resources :products
  root to: "shop#index"
end
