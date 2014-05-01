Storytime::Engine.routes.draw do
  resources :posts

  devise_for :users, class_name: "Storytime::User", module: :devise

  root to: "posts#index"
end
