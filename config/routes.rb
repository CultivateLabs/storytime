Storytime::Engine.routes.draw do
  
  resources :posts, only: [:show, :index]
  resources :pages, only: [:show], path: "/"

  namespace :dashboard do
    resources :sites, only: [:new, :edit, :update, :create]
    resources :posts, except: [:show]
    resources :pages, except: [:show]
    resources :media, except: [:show, :edit, :update]
  end

  devise_for :users, class_name: "Storytime::User", module: :devise

  root to: "posts#index"
end
