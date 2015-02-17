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
        get :edit_multiple
        patch :update_multiple
      end
    end

    # Routes for generic admin controller
    get "/:resource_name", to: "admin#index", as: :admin_index
    get "/:resource_name/new", to: "admin#new", as: :admin_new
    post "/:resource_name", to: "admin#create", as: :admin_create
    get "/:resource_name/:id/edit", to: "admin#edit", as: :admin_edit
    patch "/:resource_name/:id", to: "admin#update", as: :admin_update
    delete ":resource_name/:id", to: "admin#destroy", as: :admin_destroy
  end

  get 'tags/:tag', to: 'posts#index', as: :tag

  ##################################################################################################
  # TODO: These 2 routes need to use constraints so we can figre it out based on current_site
  ##################################################################################################
  get Storytime.home_page_path, Storytime.home_page_route_options
  resources :posts, { only: :index }.merge(Storytime.post_index_path_options)
  ##################################################################################################

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
