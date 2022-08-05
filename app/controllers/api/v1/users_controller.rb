require 'json'
class Api::V1::UsersController < ApplicationController
  before_action :authorize_access_request!
  before_action :check_backend_session
  before_action :set_user, only: [:get_account, :update]

  def me
      render json: current_user
  end

  def create
    company = Company.find(payload["company_id"])
    @user = company.users.new(user_params)
    page = params[:access][:page]
    action = params[:access][:action]
    if page.present? && action.present?
      if @user.save
        page_store = []
        action_store = []
        page.each do |pg|
          page_store.push({page_access_id: pg["page_access_id"], status: pg["status"]})
        end
        action.each do |ac|
          action_store.push({page_access_id: ac["page_access_id"], page_action_access_id: ac["page_action_access_id"],status: ac["status"]})
        end
        page_access_save = @user.user_page_accesses.create(page_store)
        action_access_save = @user.user_page_action_accesses.create(action_store)
        if page_access_save && action_access_save
          render json: {user: @user, page_access: page_access_save, action_access: action_access_save}, status: :created
        else
          render json: {error: "Saving access error"}, status: :unprocessable_entity
        end
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    else
      render json: {error: "missing params"}, status: :unprocessable_entity
    end
  end

  def update
    page = params[:access][:page]
    action = params[:access][:action]
    if page.present? && action.present?
      if @user.update(user_params)
        page_store = []
        action_store = []
        page.each do |pg|
          info_one = @user.user_page_accesses.find_by!(page_access_id: pg["page_access_id"]).update(status: pg["status"])
          if info_one
            page_store.push({page_access_id: pg["page_access_id"], status: pg["status"]})
          end
        end
        action.each do |ac|
          info_two = @user.user_page_action_accesses.find_by!(page_access_id: ac["page_access_id"], 
                                                            page_action_access_id: ac["page_action_access_id"])
                                                            .update(status: ac["status"])
          if info_two
            action_store.push({page_access_id: ac["page_access_id"], page_action_access_id: ac["page_action_access_id"], status: ac["status"]})
          end
        end
        render json: {user: @user, action_access: action_store, page_access: page_store}
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    else
      render json: {error: "missing params"}, status: :unprocessable_entity
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
                    .select("id, company_id, admin, email, position, system_default,
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
    params.require(:user).permit(:name, :email, :position, :username, :admin, :password, :password_confirmation)
  end

  # def page_access_params
  #   params.require(:page_access)
  # end

  # def page_action_access_params
  #   params.require(:action_access)
  # end

  def set_user
    @user = User.find(params[:id])
  end

end
