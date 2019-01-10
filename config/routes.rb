Rails.application.routes.draw do
  mount Journea::Engine, at: '/journey'
  root 'pages#start'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
