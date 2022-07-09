Rails.application.routes.draw do

  resources :device_session_records
  resources :session_records
  resources :user_page_action_accesses
  resources :page_action_accesses
  resources :page_access_controls
  resources :page_accesses
  resources :user_page_accesses
  resources :companies
  post 'refresh', controller: :refresh, action: :create
  post 'signin', controller: :signin, action: :create
  delete 'signin', controller: :signin, action: :destroy
  get 'me', controller: :users, action: :me
  get 'check_user_access', controller: :users, action: :check_user_access
  

  resources :password_resets, only: [:create] do
    collection do
      get ':token', action: :edit, as: :edit
      patch ':token', action: :update
    end
  end
  
  namespace :api do
    namespace :v1 do
    end
  end
end
