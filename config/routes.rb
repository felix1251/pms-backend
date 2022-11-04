require 'sidekiq/web'
# Configure Sidekiq-specific session middleware
Sidekiq::Web.use ActionDispatch::Cookies
Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: '_interslice_session'

Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  username == ENV['PMS_SIDEKIQ_USERNAME'] && password == ENV['PMS_SIDEKIQ_PASSWORD']
end

Rails.application.routes.draw do
  resources :undertimes
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
      resources :on_payroll_adjustments
      resources :on_payroll_allowances
      get 'payroll_under_payments', controller: :on_payroll_adjustments, action: :payroll_under_payments
      get 'payroll_over_payments', controller: :on_payroll_adjustments, action: :payroll_over_payments
      get 'employee_allowance_list', controller: :employee_allowances, action: :employee_allowance_list
      
      resources :employee_allowances
      resources :payroll_comments
      resources :philhealths
      resources :pagibigs
      resources :schedules
      get 'schedule_listing', controller: :schedules, action: :schedule_listing
      resources :payroll_accounts
      resources :holidays
      get 'holidays_api', controller: :holidays, action: :holidays_api
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
      get 'daily_time_records', controller: :payrolls, action: :daily_time_records
      get 'on_params_details', controller: :payrolls, action: :on_params_details
      get 'payroll_details', controller: :payrolls, action: :payroll_details
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
      put 'approved_payroll_account', controller: :payrolls, action: :approved_payroll_account
      get 'get_payroll_approvers_users', controller: :payrolls, action: :get_payroll_approvers_users
      get 'get_payroll_approvers', controller: :payrolls, action: :get_payroll_approvers
      get 'get_company_accounts_details', controller: :companies, action: :get_company_accounts_details
      put 'update_company_accounts_approvers', controller: :companies, action: :update_company_accounts_approvers
      get 'get_company_details', controller: :companies, action: :get_company_details
      get 'get_account_list_selection', controller: :companies, action: :get_account_list_selection
      put 'update_company_approver_settings', controller: :companies, action: :update_company_approver_settings
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
      post 'refresh', controller: :refresh, action: :create
      post 'signin', controller: :signin, action: :create
      delete 'signin', controller: :signin, action: :logout
      get 'me', controller: :me, action: :me
      resources :leaves
      resources :type_of_leaves
      resources :overtimes
      resources :offsets
      resources :password_change
      get 'emp_overtime', controller: :offsets, action: :emp_overtime
      get 'leave_credits_total', controller: :leaves, action: :leave_credits_total
    end
  end

  namespace :api do
    namespace :admin do
      post 'refresh', controller: :refresh, action: :create
      post 'signin', controller: :signin, action: :create
      delete 'signin', controller: :signin, action: :logout
      resources :pms_devices
      resources :philhealths
      resources :pagibigs
      resources :contracts
      resources :companies
      resources :admins
      resources :sss_contributions
      resources :social_security_systems
    end
  end
end
