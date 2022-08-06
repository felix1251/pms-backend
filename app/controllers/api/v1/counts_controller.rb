class Api::V1::CountsController < ApplicationController
  before_action :authorize_access_request!
  before_action :check_backend_session

  def counts
    company_users = User.where(company_id: payload["company_id"]).count
    render json: {company_user_count: company_users}
  end
end
