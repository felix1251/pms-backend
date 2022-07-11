require 'json'
class UsersController < ApplicationController
  before_action :authorize_access_request!
  before_action :check_backend_session

  def me
      render json: current_user
  end

  def check_user_access
    page_access_rigths = UserPageAccess.joins("LEFT JOIN page_accesses AS p ON p.id = user_page_accesses.page_access_id")
                                      .select("user_page_accesses.*, p.access_code")
                                      .where(user_id: current_user.id, status: "A")
                                      .pluck(:access_code)
    render json: {page_access: page_access_rigths}
  end
  
end
