Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :buyers, only: %i[create]
      resources :charge_orders, only: %i[create]
    end
  end
  
end
