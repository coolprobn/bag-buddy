Rails.application.routes.draw do
  # Public routes
  root "welcome#index"

  # Authentication routes
  devise_for :users, skip: [:registrations]

  # Allow users to edit their own profile (but not create new accounts)
  devise_scope :user do
    get "users/edit",
        to: "devise/registrations#edit",
        as: :edit_user_registration
    put "users", to: "devise/registrations#update", as: :user_registration
  end

  # Authenticated routes
  get "dashboard", to: "dashboard#index", as: :dashboard

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

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
