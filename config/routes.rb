ShopApp::Application.routes.draw do
	namespace :admin do
	  devise_for :admins, :controllers => { :sessions => "admin/sessions" }

	  resources :categories, except: [:new, :edit, :show]
	  resources :products

	  get "/", to: "admin#index"
	end

	resource :cart, only: [:show, :update] do
		post 'add_product'
		get 'payment'
		put 'complete'
	end

	resources :categories, only: [:show]
  resources :products, only: [:show]
  
  root to: "shop#index"
end
