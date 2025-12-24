Rails.application.routes.draw do # rubocop: disable Metrics/BlockLength
  root to: "pages#top"

  namespace :admin do
    root to: "/admin#top"
    put "ldap_sync"
    get "statistics"
    resources :users, controller: "/users",
      only: [:index, :show, :create, :update] do
      collection do
        put "sync"
      end
    end
    resources :translations, controller: "/translations",
      only: [:index, :show, :create, :update, :destroy]
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
      delete "mail_users/:type/:mail_user_id",
        to: "recipient_mail_users#destroy", as: "mail_user"
      delete "mail_users/:type", to: "recipient_mail_users#destroy"
    end
  end

  resources :mail_users, only: [:index, :show]

  resources :mail_groups, only: [:index, :show] do
    resources :mail_users, only: [:index]
  end

  resource :search, only: [:new, :create]
  get "/search" => redirect("/search/new")

  devise_for :users

  mount MissionControl::Jobs::Engine, at: "/admin/jobs"

  patch "/applications/:application_id/recurring_tasks/:id", to: "custom_recurring_tasks#update"
  put "/applications/:application_id/recurring_tasks/:id", to: "custom_recurring_tasks#update"

  # if ENV["RAILS_QUEUE_ADAPTER"] == "resque"
  #   require "resque/server"
  #   require "resque/scheduler/server"

  #   authenticated :user, ->(user) { user.admin? } do
  #     mount Resque::Server, at: "/admin/jobs"
  #   end
  # end
end
