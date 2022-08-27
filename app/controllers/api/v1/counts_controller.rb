class Api::V1::CountsController < PmsDesktopController
  before_action :authorize_access_request!
  before_action :check_backend_session

  def counts
    company_users = User.where(company_id: payload["company_id"], status: "A").count
    employees = Employee.where(company_id: payload["company_id"], status: "A").count
    render json: {company_user_count: company_users, employees_count: employees}
  end

  def token_claims
    {
          aud: allowed_aud,
          verify_aud: true
    }
  end

  private

  def allowed_aud
    ["HV"]
  end
end
