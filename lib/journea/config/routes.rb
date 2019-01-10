Journea::Engine.routes.draw do
  resources :journeys, only: [:create], path: "/" do
    resources :steps, only: [:edit, :update]
  end
end
