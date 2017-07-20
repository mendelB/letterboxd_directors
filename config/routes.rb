Rails.application.routes.draw do
  root to: 'home#home'
  post '/fetch-directors', to: 'home#fetch_directors'
  get 'directors', to: 'home#directors'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
