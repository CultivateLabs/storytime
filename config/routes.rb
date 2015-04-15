Storytime::Engine.routes.draw do
  resources :comments
  resources :subscriptions, only: [:create]
  get "subscriptions/unsubscribe", to: "subscriptions#destroy", as: "unsubscribe_mailing_list"

  concern :autosavable do
    resources :autosaves, only: :create
  end

  concern :commentable do
    resources :comments, only: [:create, :destroy]
  end

  namespace :dashboard, :path => Storytime.dashboard_namespace_path do
    get "/", to: "pages#index"
    resources :sites, only: [:new, :edit, :update, :create, :destroy]

    resources :pages, except: :show, concerns: :autosavable
    resources :blogs, except: [:index, :show], concerns: :autosavable do
      # override route names so they don't conflict with resources :blog_posts
      resources :posts, as: :blog_page_post, only: [:index]

      resources :blog_posts, shallow: true, except: :show, concerns: :autosavable
      Storytime.post_types.reject{|type| %w[Storytime::Page Storytime::Blog Storytime::BlogPost].include?(type) }.each do |post_type|
        resources post_type.tableize.to_sym, controller: "custom_posts", only: [:new, :create]
      end
    end
    
    # Create / Update / Delete pages, blog_posts, custom_post_types
    Storytime.post_types.reject{|type| %w[Storytime::Page Storytime::Blog Storytime::BlogPost].include?(type) }.each do |post_type|
      resources post_type.tableize.to_sym, controller: "custom_posts", only: [:edit, :update, :destroy], concerns: :autosavable
    end

    resources :snippets, except: [:show]
    resources :media, except: [:show, :edit, :update]
    resources :imports, only: [:new, :create]
    resources :subscriptions
    resources :users, path: Storytime.user_class_underscore.pluralize, only: [:new, :create, :edit, :update]
    resources :memberships, only: [:index, :create, :destroy]
    resources :roles do
      collection do
        get :edit_multiple
        patch :update_multiple
      end
    end
  end

  mount StorytimeAdmin::Engine => Storytime.dashboard_namespace_path

  get "/", to: "blog_homepage#show", constraints: Storytime::Constraints::BlogHomepageConstraint.new
  get "/", to: "homepage#show", constraints: Storytime::Constraints::PageHomepageConstraint.new

  resources :blogs, only: :show, path: "/", constraints: Storytime::Constraints::BlogConstraint.new
  resources :pages, only: :show, path: "/", constraints: Storytime::Constraints::PageConstraint.new
  resources :posts, only: [], concerns: :commentable
  
  Storytime.post_types.each do |post_type|
    constraints ->(request){ request.params[:component_1] != "assets" } do
      resources post_type.split("::").last.tableize, path: "(/:component_1(/:component_2(/:component_3)))/", only: :show, controller: "posts"
    end
  end

  constraints ->(request){ request.params[:component_1] != "assets" } do
    resources :posts, path: "(/:component_1(/:component_2(/:component_3)))/", only: :show
  end

  root to: "application#setup"
end
