class Api::V1::CountsController < PmsDesktopController
  before_action :authorize_access_request!
  before_action :check_backend_session

  def counts
    com_id = payload["company_id"]
    sql = "SELECT"
    sql += " (SELECT COUNT(*) FROM users WHERE company_id = #{com_id}) AS company_user_count,"
    sql += " (SELECT COUNT(*) FROM employees WHERE company_id = #{com_id}) AS employees_count"
    counts = execute_sql_query(sql)
    render json: counts.first
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
