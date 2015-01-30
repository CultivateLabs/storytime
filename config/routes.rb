 Storytime::Engine.routes.draw do
  resources :comments
  resources :subscriptions, only: [:create]
  get "subscriptions/unsubscribe", to: "subscriptions#destroy", as: "unsubscribe_mailing_list"

  namespace :dashboard, :path => Storytime.dashboard_namespace_path do
    get "/", to: "posts#index"
    resources :sites, only: [:new, :edit, :update, :create]
    resources :posts, except: [:show] do
      resources :autosaves, only: [:create]
    end
    resources :snippets, except: [:show]
    resources :media, except: [:show, :edit, :update]
    resources :imports, only: [:new, :create]
    resources :subscriptions
    resources :users, path: Storytime.user_class_underscore.pluralize
    resources :roles do 
      collection do
        patch :update_multiple
      end
    end
  end

  get 'tags/:tag', to: 'posts#index', as: :tag

  get Storytime.home_page_path, Storytime.home_page_route_options
  resources :posts, { only: :index }.merge(Storytime.post_index_path_options)

  # index page for post types that are excluded from primary feed
  constraints ->(request){ Storytime.post_types.any?{|type| type.constantize.type_name.pluralize == request.path.gsub("/", "") } } do
    get ":post_type", to: "posts#index"
  end

  # pages at routes like /about
  constraints ->(request){ (request.params[:id] != Storytime.home_page_path) && Storytime::Page.friendly.exists?(request.params[:id]) } do
    resources :pages, only: :show, path: "/"
  end

  resources :posts, path: "(/:component_1(/:component_2(/:component_3)))/", only: :show, constraints: ->(request){ request.params[:component_1] != "assets" }
  resources :posts, only: nil do
    resources :comments, only: [:create, :destroy]
  end

end
