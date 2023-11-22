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
    get 'reviews_list', on: :member

    resources :rooms, shallow: true, only: [:new, :create, :show, :edit, :update, :index] do
      resources :seasonal_rates, shallow: true, only: [:index, :new, :create, :edit, :update]
      resources :reservations, shallow: true, except: [:index, :destroy] do
        get 'validate', on: :member
        post 'confirm', on: :member
        post 'cancel', on: :member
        post 'host_cancel', on: :member
        
        resources :checkins, shallow: true, only: [:new, :create]
        resources :checkouts, shallow: true, only: [:new, :create]
        resources :reviews, shallow: true, only: [:new, :create] do
          resources :host_replies, shallow: true, only: [:new, :create]
        end
      end
    end
  end
  
  get 'my_inn', to: 'inns#my_inn'
  get 'my_inn_reservations', to: 'inns#my_inn_reservations'
  get 'my_inn_reviews', to: 'inns#my_inn_reviews'
  get 'my_reservations', to: 'users#my_reservations'

  # api routes

  namespace :api do
    namespace :v1 do
      resources :inns, only: [:index]
    end
  end
end
