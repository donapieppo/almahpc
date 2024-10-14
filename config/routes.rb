Rails.application.routes.draw do
  mount DmUniboCommon::Engine => "/dm_unibo_common", :as => "dm_unibo_common"

  get "/choose_organization", to: "home#choose_organization"
  get "/logins/logout", to: "dm_unibo_common/logins#logout"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up123", to: "rails/health#show", as: :rails_health_check

  get "/home", to: "home#index", as: "home"
  get "/guide", to: "home#guide", as: "guide"

  root "home#index"

  resources :users do
    get :memberships_to_sync, on: :collection
    resources :authorized_keys
  end

  scope ":__org__" do
    resources :users
    resources :slurm_associations
    resources :slurm_accounts do
      resources :slurm_associations
    end

    # get "/", to: "slurm_accounts#index", as: "current_organization_root"
    get "/", to: "home#index", as: "current_organization_root"
  end
end
