class Api::V1::CompaniesController < PmsDesktopController
  before_action :authorize_access_request!
  before_action :check_backend_session
  # before_action :set_company, only: [:update_setings]

  # GET /companies
  def index
    sql = "SELECT"
    sql += " com.code, IF(com.status = 'A', 'Active', 'Inactive') AS status, com.description, com.id,"
    sql += " DATE_FORMAT(com.created_at, '%b %d, %Y %h:%i %p') AS created_at,"
    sql += " (SELECT COUNT(*) FROM contracts as ct WHERE ct.company_id = com.id) AS total_contracts,"
    sql += " (SELECT COUNT(*) FROM employees emp WHERE emp.company_id = com.id AND emp.status = 'A') AS total_active_employees"
    sql += " FROM companies AS com"
    sql += " ORDER BY com.created_at DESC"
    companies = execute_sql_query(sql)
    render json: companies
  end

  def get_company_details
    company = Company.select(:settings, :employee_approvers).find(payload['company_id'])
    company.employee_approvers = company.employee_approvers || []
    company.settings = company.settings || {}
    render json: company
  end

  def update_company_approver_settings
    @company = Company.find(payload['company_id'])
    if @company.update(custom_params)
      render json: @company
    else
      render json: @company.errors, status: :unprocessable_entity
    end
  end

  def get_account_list_selection
    company = Company.find(payload['company_id'])

    #employee approvers
    find_employee_approvers_id = ""
    if params[:employee].present?
      employee_approvers = company.employee_approvers || [] 
      find_employee_approvers_id = "OR id IN (#{employee_approvers.join(',')})" if employee_approvers.length > 0
    end

    sql = "SELECT"
    sql += " id AS value, CONCAT(name,' (', position, ')') AS label"
    sql += " FROM users"
    sql += " WHERE company_id = #{payload['company_id']}"
    sql += " AND (page_accesses LIKE '%EV%' OR admin = 1 #{find_employee_approvers_id})" if params[:employee].present?
    sql += " AND (page_accesses LIKE '%CV%' OR admin = 1)" if params[:schedules].present?
    sql += " AND (page_accesses LIKE '%TV%' OR admin = 1)" if params[:time_keeping].present?
    sql += " AND (page_accesses LIKE '%YV%' OR admin = 1)" if params[:employee_request].present?
    sql += " ORDER BY name ASC"
    result = execute_sql_query(sql)
    render json: result
  end

  def token_claims
    {
      aud: ['YE'],
      verify_aud: true
    }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def custom_params
      params.require(:params).permit(:settings => {}, :employee_approvers => [])
    end
end
