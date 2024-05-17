Rails.application.routes.draw do
  mount DmUniboCommon::Engine => "/dm_unibo_common", :as => "dm_unibo_common"

  get "/choose_organization", to: "home#choose_organization"
  get "/logins/logout", to: "dm_unibo_common/logins#logout"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up123", to: "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"

  resources :users do
    get :me, on: :collection
    get :myedit, on: :collection
  end

  scope ":__org__" do
    resources :users
    resources :hpc_memberships, only: :destroy
    resources :hpc_groups do
      resources :hpc_memberships
    end

    get "/", to: "hpc_groups#index", as: "current_organization_root"
  end
end
