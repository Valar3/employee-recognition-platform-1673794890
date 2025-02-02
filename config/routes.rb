# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :admins, path: 'admins'
  devise_for :employees, path: 'employees', controllers: { omniauth_callbacks: 'employees/omniauth_callbacks' }
  namespace :employees do

    resources :rewards, only: [:index, :show]
    get 'rewards/categories/:id', to: 'categories#show', as: 'rewards_category'
    resources :kudos
    resources :orders, only: [:create, :index, :show] do
      collection do
        get 'new/:reward_id', to:'orders#new', as: 'new_with_reward'
      end
    end
  end
  namespace :admins do
    resources :categories
    resources :kudos, only: [:index, :destroy]
    patch 'update_add_kudos_to_all/', to: 'employees#update_add_kudos_to_all'
    get  'edit_add_kudos_to_all/', to: 'employees#edit_add_kudos_to_all'
    resources :employees, only: [:index, :edit, :update, :destroy] do
      resources :orders, only: [:index, :update]
      end


    namespace :employees do
      resources :orders, only: [:index, :update]
    end
    resources :online_codes do
      collection do
        post :import_online_codes
        get '/import_online_codes', to: 'rewards#import_online_codes'
      end
    end
    resources :company_values
    resources :rewards do
      collection do
        post :import
        get '/import' =>'pages#import'
      end
    end
  end

  get '/admin' => "admins/pages#dashboard", :as => :admin_root
  root 'employees/kudos#index'
end
