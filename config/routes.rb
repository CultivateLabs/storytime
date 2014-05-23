Storytime::Engine.routes.draw do
  resources :posts, only: [:show, :index]

  namespace :dashboard do
    resources :sites, only: [:new, :edit, :update, :create]
    resources :posts, except: [:show]
    resources :pages, except: [:show]
    resources :media, except: [:show, :edit, :update]
    resources :users
    resources :roles do 
      collection do
        patch :update_multiple
      end
    end
  end
  get 'tags/:tag', to: 'posts#index', as: :tag

  devise_for :users, class_name: "Storytime::User", module: :devise

  get "/", to: "posts#index", constraints: Storytime::RootConstraint.new("posts")
  get "/", to: "pages#show", constraints: Storytime::RootConstraint.new("page")

  resources :pages, only: [:show], path: "/"

  root to: "application#setup" # should only get here during app setup
end
