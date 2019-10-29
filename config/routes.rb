# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'pages#top'
  post '/search/mail_users', to: 'mail_users#search'
  get '/search/mail_users', to: 'mail_users#search'

  namespace :admin do
    root to: '/admin#top'
    put 'ldap_sync'
    post 'statistics'
    resources :users, only: [:index, :show, :update], controller: '/users'
  end

  resource :user, only: [:show]

  resources :templates
  resources :bulk_mails do
    resources :action_logs, path: 'actions', only: [:index, :create]
  end
  resources :recipient_lists do
    resources :mail_users, only: [:index]
  end

  resources :mail_users, only: [:index, :show]

  resources :mail_groups, only: [:index, :show] do
    resources :mail_users, only: [:index]
  end


  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  authenticated :user, ->(user) { user.admin? } do
    mount DelayedJobWeb, at: '/admin/delayed_job'
  end
end
