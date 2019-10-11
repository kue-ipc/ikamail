# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'pages#top'
  namespace :admin do
    root to: '/admin#top'
    put 'ldap_sync'
    post 'statistics'
    resources :users, only: [:index, :show, :edit]
  end
  resources :bulk_mail_templates
  resources :bulk_mails
  resources :recipient_lists do
    resources :mail_users, only: [:index],
      controller: 'recipient_lists_mail_users'
  end
  resources :mail_users, only: [:index, :show]
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
