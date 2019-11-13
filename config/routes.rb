# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'pages#top'

  namespace :admin do
    root to: '/admin#top'
    put 'ldap_sync'
    post 'statistics'
    resources :users, only: [:index, :show, :create, :update], controller: '/users' do
      collection do
        put 'sync'
      end
    end
  end

  resource :user, only: [:show]

  resources :templates
  resources :bulk_mails do
    resources :action_logs, path: 'actions', only: [:index, :create]
  end
  resources :recipient_lists do
    resources :applicable_mail_users, only: [:index], controller: :mail_users
    resources :included_mail_users, only: [:index, :show, :create, :update, :destroy], controller: :recipient_mail_users
    resources :excluded_mail_users, only: [:index, :show, :create, :update, :destroy], controller: :recipient_mail_users
  end

  resources :mail_users, only: [:index, :show] do
    collection do
      post 'search'
      get 'search'
    end
  end

  resources :mail_groups, only: [:index, :show] do
    resources :mail_users, only: [:index]
  end

  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  authenticated :user, ->(user) { user.admin? } do
    mount DelayedJobWeb, at: '/admin/delayed_job'
  end
end
