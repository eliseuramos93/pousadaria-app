Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }

  devise_scope :user do 
    get 'new_regular_user', to: 'registrations#new_regular'
  end

  root to: 'home#index'

  resources :inns, only: [:new, :create, :show, :edit, :update] do
    post 'inactive', on: :member
    post 'active', on: :member
    get 'city_list', on: :collection
    get 'search', on: :collection

    resources :rooms, only: [:create, :show, :edit, :update, :index] do
      resources :seasonal_rates, only: [:index, :new, :create, :edit, :update]
      resources :reservations, shallow: true, except: [:destroy] do
        get 'validate', on: :member
        post 'confirm', on: :member
      end
    end
  end
  
  get 'my_inn', to: 'inns#my_inn'
  get 'create_new_room', to: 'rooms#create_new_room'
end
