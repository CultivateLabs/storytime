Storytime::Engine.routes.draw do
  get 'posts/types/:post_type', to: "posts#index"
  resources :posts, only: [:show, :index]

  namespace :dashboard do
    get "/", to: "posts#index"
    resources :sites, only: [:new, :edit, :update, :create]
    resources :posts, except: [:show]
    resources :post_types
    resources :pages, except: [:show]
    resources :media, except: [:show, :edit, :update]
    resources :imports, only: [:new, :create]
    resources :users
    resources :roles do 
      collection do
        patch :update_multiple
      end
    end
  end
  get 'tags/:tag', to: 'posts#index', as: :tag

  get "/", to: "posts#index", constraints: Storytime::RootConstraint.new("posts")
  get "/", to: "pages#show", constraints: Storytime::RootConstraint.new("page")

  resources :pages, only: [:show], path: "/"

  get "/", to: "application#setup", as: :storytime_root # should only get here during app setup
end
