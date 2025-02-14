Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  resources :tickets do
    resources :comments
  end

  resources :statuses

  root "tickets#index"
  get "admin", to: "admin#index"

  namespace :admin do
    resources :users do
      member do
        post :resend_activation_email
      end
    end
  end

  get "signup", to: "signup#new"
  post "signup", to: "signup#create"
  get "signup/:id/confirm_email", to: "signup#confirm_email", as: :confirm_email_signup

  get "support/home", to: "support#index"
  get "support", to: redirect("support/home")

  namespace :support do
    resources :tickets, only: [ :index, :create, :new, :edit, :show, :update ] do
      resources :comments, only: [ :create ]
    end
  end

  get "workspace/dashboard", to: "workspace#index"
  get "workspace", to: redirect("workspace/dashboard")

  namespace :workspace do
    resources :tickets, only: [ :index, :create, :new, :edit, :show, :update ] do
      resources :comments, only: [ :create ]
    end
  end
end
