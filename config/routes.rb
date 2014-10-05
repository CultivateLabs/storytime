 Storytime::Engine.routes.draw do
  resources :comments

  namespace :dashboard do
    get "/", to: "posts#index"
    resources :sites, only: [:new, :edit, :update, :create]
    resources :posts, except: [:show]
    resources :posts, except: [:show], shallow: true do
      resources :autosaves, only: [:create]
    end
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

  # using a page as the home page
  constraints ->(request){ Storytime::Site.first && Storytime::Site.first.root_page_content == "page" } do
    get "/", to: "pages#show"
    resources :posts, only: :index
  end

  # using blog index as the home page
  constraints ->(request){ Storytime::Site.first && Storytime::Site.first.root_page_content == "posts" } do
    resources :posts, path: "/", only: :index, as: :root_post
  end

  # index page for post types that are excluded from primary feed
  constraints ->(request){ Storytime.post_types.any?{|type| type.constantize.type_name.pluralize == request.path.gsub("/", "") } } do
    get ":post_type", to: "posts#index"
  end

  # pages at routes like /about
  constraints ->(request){ Storytime::Page.published.where(slug: request.params[:id]).any? } do
    resources :pages, only: :show, path: "/"
  end

  resources :posts, path: "(/:component_1(/:component_2(/:component_3)))/", only: :show, constraints: ->(request){ request.params[:component_1] != "assets" }
  resources :posts, only: nil do
    resources :comments, only: [:create, :destroy]
  end

  get "/", to: "application#setup", as: :storytime_root # should only get here during app setup
end


# Custom Post types:
# /portfolio
# /portfolio/storyport

# Page Posts:
# /page-slug

# Blog:
# Index: / or /blog based on site selection
# Show: based on selection