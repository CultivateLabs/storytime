Rails.application.routes.draw do
  devise_for :users
  mount Storytime::Engine => "/"
end
