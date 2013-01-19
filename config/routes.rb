ShopApp::Application.routes.draw do
	namespace :admin do
	  devise_for :admins, :controllers => { :sessions => "admin/sessions" }

	  resources :categories, except: [:new, :edit, :show]
	  resources :products
	  resources :orders, only: [:index, :show] do
      get "order_items", on: :collection
    end

	  get "/", to: "main#index"
	end

	resource :cart, only: [:show, :update] do
		post 'add_product'
		get 'payment'
		put 'complete'
	end

	resources :categories, only: [:index, :show]
  resources :products, only: [:index, :show] do
  	get "search", on: :collection
  end
  
  match "/spa(/*path)", to: "home#spa"
  root to: "home#index"
end
