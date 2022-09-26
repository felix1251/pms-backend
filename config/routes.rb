require 'sidekiq/web'
# Configure Sidekiq-specific session middleware
Sidekiq::Web.use ActionDispatch::Cookies
Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: '_interslice_session'

Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  username == ENV['PMS_SIDEKIQ_USERNAME'] && password == ENV['PMS_SIDEKIQ_PASSWORD']
end

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  
  root to: "welcome#index"

  namespace :api do
    namespace :v1 do
      #cable
      mount ActionCable.server => '/cable'
      #auths
      post 'refresh', controller: :refresh, action: :create
      post 'signin', controller: :signin, action: :create
      delete 'signin', controller: :signin, action: :logout
      resources :password_resets, only: [:create] do
        collection do
          get ':token', action: :edit, as: :edit
          patch ':token', action: :update
        end
      end
      #------
      resources :employee_schedules
      resources :offsets
      resources :overtimes
      get 'emp_overtime', controller: :overtimes, action: :emp_overtime
      resources :company_accounts
      resources :on_payroll_compensations
      resources :official_businesses
      resources :type_of_leaves
      resources :leaves
      get 'pending_leaves', controller: :leaves, action: :pending_leaves
      get 'pending_offsets', controller: :offsets, action: :pending_offsets
      get 'leaves_count', controller: :leaves, action: :leaves_count
      get 'overtime_count', controller: :overtimes, action: :overtime_count
      get 'ob_count', controller: :official_businesses, action: :ob_count
      get 'offset_count', controller: :offsets, action: :offset_count
      get 'overtime_count', controller: :overtimes, action: :overtime_count
      get 'pending_ob', controller: :official_businesses, action: :pending_ob
      get 'pending_overtimes', controller: :overtimes, action: :pending_overtimes
      put 'leave_action', controller: :leaves, action: :leave_action
      put 'overtime_action', controller: :overtimes, action: :overtime_action
      put 'ob_action', controller: :official_businesses, action: :ob_action
      put 'offset_action', controller: :offsets, action: :offset_action
      resources :compensation_histories
      resources :payrolls
      get 'payroll_data', controller: :payrolls, action: :payroll_data
      get 'approver_list', controller: :payrolls, action: :approver_list
      resources :time_keepings
      resources :failed_time_keepings
      post 'time_bulk_create', controller: :time_keepings, action: :bulk_create
      get 'time_records', controller: :time_keepings, action: :time_records
      get 'time_keeping_counts', controller: :time_keepings, action: :time_keeping_counts
      get 'time_keeping_calendar', controller: :time_keepings, action: :time_keeping_calendar
      resources :assigned_areas
      resources :employment_statuses
      resources :employee_action_histories
      resources :positions
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
      get 'groupings', controller: :employees, action: :groupings
      get 'search_employee', controller: :employees, action: :search_employee
      get 'search_employee_id', controller: :employees, action: :search_employee_id
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

  namespace :api do
    namespace :admin do
      resources :pms_devices
    end
  end
end
