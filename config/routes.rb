Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: "users/sessions", registrations: "users/registrations" }
  root to: "home#index"

  get "profile" => "users#profile", as: :profile
  get "profile/edit" => "users#edit_profile", as: :edit_profile
  get "users/:id/profile" => "users#public_profile", as: :public_profile
  post "users/:id/follow" => "users#follow", as: :follow_user
  delete "users/:id/unfollow" => "users#unfollow", as: :unfollow_user

  # photos routes
  get "photos/feed" => "photos#feed", as: :photos_feed
  get "photos/discovery" => "photos#discovery", as: :photos_discovery

  # albums routes
  get "albums/feed" => "albums#feed", as: :albums_feed
  get "albums/discovery" => "albums#discovery", as: :albums_discovery

  resources :albums
  resources :photos
  resources :users

  namespace :admin do
    root "users#index"
    # resources :photos
    # resources :albums
    resources :users
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
