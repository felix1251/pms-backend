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
    company = Company.select(:settings, :employee_approvers, :schedule_approvers, :time_keeping_approvers, 
                            :request_administrative_approvers, :request_supervisory_approvers)
                            .find(payload['company_id'])

    render json: company, :except => [:id]
  end

  def get_company_accounts_details
    company_accounts = CompanyAccount.select(:id, :name, :approvers)
                      .where(company_id: payload['company_id']).map{|e| {id: e.id, name: e.name, approvers: e.approvers || []} }
    render json: company_accounts
  end

  def update_company_accounts_approvers
    company_account = CompanyAccount.find(params[:id])
    if company_account.update(company_account_params)
      render json: company_account.approvers || []
    else
      render json: company_account.errors, status: :unprocessable_entity
    end
  end

  def update_company_approver_settings
    @company = Company.find(payload['company_id'])
    if @company.update(custom_params)
      @company.settings = @company.settings || {}
      @company.employee_approvers = @company.employee_approvers || []
      @company.schedule_approvers = @company.schedule_approvers || []
      @company.time_keeping_approvers = @company.time_keeping_approvers || []
      render json: @company
    else
      render json: @company.errors, status: :unprocessable_entity
    end
  end

  def get_account_list_selection
    company = Company.find(payload['company_id']) if params[:employee].present? || params[:schedules].present? || params[:employee_request].present?

    #employee approvers
    find_employee_approvers_id = ""
    if params[:employee].present?
      employee_approvers = company.employee_approvers || [] 
      find_employee_approvers_id = "OR id IN (#{employee_approvers.join(',')})" if employee_approvers.length > 0
    end

    find_schedule_approvers_id = ""
    if params[:schedules].present?
      schedule_approvers = company.schedule_approvers || [] 
      find_schedule_approvers_id = "OR id IN (#{schedule_approvers.join(',')})" if schedule_approvers.length > 0
    end

    find_time_keeping_approvers_id = ""
    if params[:schedules].present?
      time_keeping_approvers = company.time_keeping_approvers || [] 
      find_time_keeping_approvers_id = "OR id IN (#{time_keeping_approvers.join(',')})" if time_keeping_approvers.length > 0
    end

    find_request_administrative_approvers_id = nil;
    if params[:schedules].present?
      request_administrative_approvers = company.request_administrative_approvers || [] 
      find_request_administrative_approvers_id = "OR id IN (#{request_administrative_approvers.join(',')})" if request_administrative_approvers.length > 0
    end

    find_request_supervisory_approvers_id = nil
    if params[:schedules].present?
      request_supervisory_approvers = company.request_supervisory_approvers || [] 
      find_request_supervisory_approvers_id = "OR id IN (#{request_supervisory_approvers.join(',')})" if request_supervisory_approvers.length > 0
    end

    find_request_approvers_id = find_request_administrative_approvers_id || find_request_supervisory_approvers_id || ""

    sql = "SELECT"
    sql += " id AS value, CONCAT(name,' (', position, ')') AS label"
    sql += " FROM users"
    sql += " WHERE company_id = #{payload['company_id']}"
    sql += " AND (page_accesses LIKE '%EV%' OR admin = 1 #{find_employee_approvers_id})" if params[:employee].present?
    sql += " AND (page_accesses LIKE '%CV%' OR admin = 1 #{find_schedule_approvers_id})" if params[:schedules].present?
    sql += " AND (page_accesses LIKE '%TV%' OR admin = 1 #{find_time_keeping_approvers_id})" if params[:time_keeping].present?
    sql += " AND (page_accesses LIKE '%PV%' OR admin = 1)" if params[:payroll].present?
    sql += " AND (page_accesses LIKE '%QV%' OR admin = 1 #{find_request_approvers_id})" if params[:employee_request].present?
    sql += " AND id NOT IN (#{company.request_supervisory_approvers.join(',')})" if params[:employee_request].present? && params[:request_type].present? && params[:request_type] == 'A' && company.request_supervisory_approvers.length > 0
    sql += " AND id NOT IN (#{company.request_administrative_approvers.join(',')})" if params[:employee_request].present? && params[:request_type].present? && params[:request_type] == 'S' && company.request_administrative_approvers.length > 0
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

    def company_account_params
      params.require(:params).permit(:approvers => [])
    end

    def custom_params
      params.require(:params).permit(:settings => {}, :employee_approvers => [], :schedule_approvers => [],
                                    :time_keeping_approvers => [], :request_administrative_approvers => [], 
                                    :request_supervisory_approvers => [])
    end
end
