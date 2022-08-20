require 'sidekiq/web'
# Configure Sidekiq-specific session middleware
Sidekiq::Web.use ActionDispatch::Cookies
Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: '_interslice_session'

Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  username == 'admin' && password == 'admin'
end

Rails.application.routes.draw do

  mount Sidekiq::Web => '/sidekiq'
  
  root to: "welcome#index"

  post 'refresh', controller: :refresh, action: :create
  post 'signin', controller: :signin, action: :create
  delete 'signin', controller: :signin, action: :logout
  
  resources :password_resets, only: [:create] do
    collection do
      get ':token', action: :edit, as: :edit
      patch ':token', action: :update
    end
  end
  
  namespace :api do
    namespace :v1 do
      resources :job_classifications
      resources :salary_modes
      resources :departments
      resources :employees
      resources :users
      resources :device_session_records
      resources :session_records
      resources :user_page_action_accesses
      resources :phone_indexes
      resources :page_action_accesses
      resources :page_access_controls
      resources :page_accesses
      resources :user_page_accesses
      resources :companies
      get 'counts', controller: :counts, action: :counts
      get 'me', controller: :me, action: :me
      get 'system_accounts', controller: :users, action: :system_accounts
      get 'get_account', controller: :users, action: :get_account
      get 'get_page_acess_for_selection', controller: :page_accesses, action: :get_page_acess_for_selection
    end
  end

  namespace :api do
    namespace :v2 do
      resources :support_chats
    end
  end

end
