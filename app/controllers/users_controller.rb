require 'json'
class UsersController < ApplicationController
  before_action :authorize_access_request!

  def me
      render json: current_user
  end

  def check_user_access
    page_access_rigths = JSON.parse(current_user.page_access_rigths)
    action_access_rigths = JSON.parse(current_user.action_access_rigths)
    render json: {page: page_access_rigths, actions: action_access_rigths}
  end

end
