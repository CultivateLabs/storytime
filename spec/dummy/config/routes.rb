Rails.application.routes.draw do
  devise_for :users
  mount Admin::Engine => "/admin"
  mount Storytime::Engine => "/"
end
