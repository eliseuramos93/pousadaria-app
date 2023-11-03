Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }
  root to: 'home#index'

  resources :inns, only: [:new, :create, :show, :edit, :update] do
    post 'inactive', on: :member
    post 'active', on: :member

    resources :rooms, only: [:create, :show, :edit, :update] do
      resources :seasonal_rates, only: [:new, :create]
    end
  end
  
  get 'my_inn', to: 'inns#my_inn'
  get 'create_new_room', to: 'rooms#create_new_room'
end
