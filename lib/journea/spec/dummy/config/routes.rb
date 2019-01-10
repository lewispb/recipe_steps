Rails.application.routes.draw do
  root to: 'pages#start'
  mount Journea::Engine => '/journey'
end
