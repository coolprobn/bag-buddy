Rails.application.routes.draw do
  # Public routes
  root "welcome#index"

  # Authentication routes
  devise_for :users

  # Authenticated routes
  get "dashboard", to: "dashboard#index", as: :dashboard
  get "reports", to: "reports#index", as: :reports
  get "reports/export", to: "reports#export", as: :export_reports
  get "reports/bulk_export", to: "reports#bulk_export", as: :bulk_export_reports

  # User profile
  get "profile", to: "users#show", as: :profile
  get "profile/edit", to: "users#edit", as: :edit_profile
  patch "profile", to: "users#update"
  put "profile", to: "users#update"

  # Resources
  resources :vendors
  resources :products do
    member do
      delete "purge_attachment/:attachment_id",
             to: "products#purge_attachment",
             as: :purge_attachment
    end
  end
  resources :customers
  resources :sales do
    resources :sales_returns, only: [:create], path: "returns"
    resources :exchanges, only: [:create]
  end
  resources :sales_returns
  resources :exchanges
  resources :expenses
  resources :delivery_partners
  resources :application_settings, path: "settings"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  get "manifest" => "rails/pwa#manifest", :as => :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", :as => :pwa_service_worker
end
