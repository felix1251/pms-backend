require 'json'
class Api::V1::UsersController < ApplicationController
  before_action :check_backend_session

  def me
      render json: current_user
  end

  def system_accounts
    page = params[:page]
    per_page = params[:per_page]
    accounts = User.paginate(:page => page, :per_page => per_page)
                    .select("id, company_id, admin, email, position,
                      name, status, DATE(created_at) AS created")
                    .where(company_id: payload['company_id'])
                    
    render json: {accounts: accounts, count: accounts.count} 
  end

  def current_user_access
    user_page_access = current_user_page_access
    action_access = {}
    user_page_access.map do |page|
      action_access.merge!({page => current_user_page_action_access(page)})
    end
    render json: {page_access: user_page_access, page_action_access: action_access}
  end
end
