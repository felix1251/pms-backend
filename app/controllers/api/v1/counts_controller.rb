class Api::V1::CountsController < ApplicationController
  before_action :authorize_access_request!
  before_action :check_backend_session

  def counts
    company = Company.find_by!(id: current_user.company_id)
    company_users = company.users.count
    render json: {company_user_count: company_users}, status: :ok
  end
end
