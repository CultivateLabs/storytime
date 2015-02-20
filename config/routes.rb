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
    get "/", to: "posts#index"
    resources :sites, only: [:new, :edit, :update, :create]

    resources :posts, except: :show, concerns: :autosavable
    resources :pages, except: :show, concerns: :autosavable
    resources :blogs, except: :show, concerns: :autosavable
    resources :blog_posts, except: :show, concerns: :autosavable
    Storytime.post_types.reject{|type| %w[Storytime::BlogPost Storytime::Page Storytime::Blog].include?(type) }.each do |post_type|
      resources post_type.tableize.to_sym, controller: "custom_posts", except: :show, concerns: :autosavable
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

  # TODO: HOW DO WE DEAL WITH THIS WHEN THERE ARE MULTIPLE BLOG PAGES?
  get 'tags/:tag', to: 'posts#index', as: :tag

  get Storytime.home_page_path, to: "blog_homepage#show", constraints: Storytime::Constraints::BlogHomepageConstraint.new
  get Storytime.home_page_path, to: "homepage#show", constraints: Storytime::Constraints::PageHomepageConstraint.new
  resources :blogs, only: :show, path: "/", constraints: Storytime::Constraints::BlogConstraint.new
  resources :pages, only: :show, path: "/", constraints: Storytime::Constraints::PageConstraint.new

  resources :posts, path: "(/:component_1(/:component_2(/:component_3)))/", only: :show, constraints: ->(request){ request.params[:component_1] != "assets" }
  Storytime.post_types.each do |post_type|
    if post_type.constantize.respond_to?(:show_comments?) && post_type.constantize.show_comments?
      resources post_type.split("::").last().tableize.to_sym, only: nil, concerns: :commentable
    end
  end
end
