Rails.application.routes.draw do
  root to: "pages#top"

  namespace :admin do
    root to: "/admin#top"
    put "ldap_sync"
    get "statistics"
    # get 'translations'
    # put 'translations', to: '/admin#translations_update'
    resources :users, only: [:index, :show, :create, :update], controller: "/users" do
      collection do
        put "sync"
      end
    end
    # # get 'translations', as: 'translations'
    # get 'translations/:id', as: '/translations'
    resources :translations, only: [:index, :show, :create, :update, :destroy], controller: "/translations"
  end

  resource :user, only: [:show]

  resources :mail_templates do
    member do
      patch "count"
    end
  end

  resources :bulk_mails do
    member do
      put "apply"
      put "withdraw"
      put "approve"
      put "reject"
      put "deliver"
      put "reserve"
      put "cancel"
      put "discard"
    end
  end

  resources :recipient_lists do
    member do
      get "mail_users/:type", to: "recipient_mail_users#index", as: "mail_users"
      post "mail_users/:type", to: "recipient_mail_users#create"
      delete "mail_users/:type/:mail_user_id", to: "recipient_mail_users#destroy", as: "mail_user"
      delete "mail_users/:type", to: "recipient_mail_users#destroy"
    end
  end

  resources :mail_users, only: [:index, :show]

  resources :mail_groups, only: [:index, :show] do
    resources :mail_users, only: [:index]
  end

  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  authenticated :user, ->(user) { user.admin? } do
    mount DelayedJobWeb, at: "/admin/delayed_job"
  end

  resource :search, only: [:new, :create]
  get "/search" => redirect("/search/new")
end
