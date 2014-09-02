 Storytime::Engine.routes.draw do
  resources :comments

  namespace :dashboard do
    get "/", to: "posts#index"
    resources :sites, only: [:new, :edit, :update, :create]
    resources :blog_posts, except: [:show]
    resources :pages
    resources :categories
    resources :media, except: [:show, :edit, :update]
    resources :imports, only: [:new, :create]
    resources :users
    resources :roles do 
      collection do
        patch :update_multiple
      end
    end
  end
  
  #resources :posts, only: [:show, :index]

  get 'tags/:tag', to: 'posts#index', as: :tag

  # any categories
  constraints ->(request){ Storytime::Category.where(name: request.params[:category]).any? } do
    get ':category/:id', to: "posts#show"
    get ':category', to: "posts#index"
  end

  # using a page as the home page
  constraints ->(request){ Storytime::Site.first && Storytime::Site.first.root_page_content == "page" } do
    get "/", to: "posts#show"
    resources :posts, only: :index
  end

  # using blog index as the home page
  constraints ->(request){ Storytime::Site.first && Storytime::Site.first.root_page_content == "posts" } do
    resources :posts, path: "/", only: :index, as: :root_post
  end

  resources :posts, path: "(/:component_1(/:component_2(/:component_3)))/", only: :show, constraints: ->(request){ request.params[:component_1] != "assets" }
  resources :posts, only: nil do
    resources :comments, only: [:create, :destroy]
  end

  #get "/:id", to: "posts#show" # for pages

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