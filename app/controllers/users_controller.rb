require 'json'
class UsersController < ApplicationController
  before_action :authorize_access_request!
  before_action :check_backend_session

  def me
      render json: current_user
  end

  def check_user_access
    render json: {page_access: current_user_page_access}
  end

end
