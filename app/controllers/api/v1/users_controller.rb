require 'json'
class Api::V1::UsersController < ApplicationController
  before_action :authorize_access_request!
  before_action :check_backend_session
  before_action :set_user, only: [:get_account]

  def me
      render json: current_user
  end

  def create
    company = Company.find(payload["company_id"])
    @user = company.users.new(user_params)
    page = page_access_params
    action = page_action_access_params
    if @user.save
      @user.user_page_access.create(page)
      @user.user_page_action_access.create(action)
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def get_account
    user_page_access = @user.user_page_accesses.joins("LEFT JOIN page_accesses AS p ON p.id = page_access_id")  
                                              .select("user_page_accesses.*, p.access_code")
                                              .where(status: "A")
                                              .pluck(:access_code)

    user_page_action_access = @user.user_page_action_accesses
                                    .joins("LEFT JOIN page_accesses AS p ON p.id = user_page_action_accesses.page_access_id")  
                                    .joins("LEFT JOIN page_action_accesses AS pa ON pa.id = user_page_action_accesses.page_action_access_id") 
                                    .select("user_page_action_accesses.*, p.access_code, pa.access_code")
                                    .where(status: "A")
                                    .pluck("p.access_code, pa.access_code")
                                    
    render json: {account: @user, page_access: user_page_access, action_access: user_page_action_access}
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

  private

  def user_params
    params.require(:user).permit(:name, :email, :position, :username, :password, :password_confirmation)
  end

  def page_access_params
    params.require(:page_access)
  end

  def page_action_access_params
    params.require(:action_access)
  end

  def set_user
    @user = User.find(params[:id])
  end

end
