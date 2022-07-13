require 'json'
class Api::V1::UsersController < ApplicationController
  before_action :authorize_access_request!
  before_action :check_backend_session

  def me
      render json: current_user
  end

  def system_accounts
    page = 1
    per_page = 2
    accounts = User.paginate(:page => 1, :per_page => per_page)
    render json: accounts
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
