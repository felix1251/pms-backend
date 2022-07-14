class Api::V1::CountsController < ApplicationController
  before_action :check_backend_session

  before_action do 
    page_on_access = "D"
    check_user_page_access(page_on_access)
  end

  def counts
    company_users = User.where(company_id: payload["company_id"]).count
    render json: {company_user_count: company_users, action: action_name}
  end

  private

  def check_user_page_access(page)
    unless current_user.admin || current_user_page_access.include?(page)
      forbidden
    end
  end

end
