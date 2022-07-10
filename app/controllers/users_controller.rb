require 'json'
class UsersController < ApplicationController
  before_action :authorize_access_request!

  def me
      render json: current_user
  end

  def check_user_access
    page_access_rigths = current_user.user_page_accesses.where(status: "A").pluck(:access_code)
    render json: {page: page_access_rigths, actions: action_access_rigths}
  end

end
