Storytime::Engine.routes.draw do
  resources :posts, only: [:show, :index]

  namespace :dashboard do
    resources :posts, except: [:show]
  end

  devise_for :users, class_name: "Storytime::User", module: :devise

  root to: "posts#index"
end
