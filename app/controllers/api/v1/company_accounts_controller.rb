class Api::V1::CompanyAccountsController < PmsDesktopController
  before_action :authorize_access_request!
  before_action :check_backend_session
  before_action :set_company_account, only: [:show, :update, :destroy]

  # GET /company_accounts
  def index
    sql_start = ""
    sql_start += "SELECT"
    sql_fields = " ca.id value, ca.name AS label, ca.code, ca.created_at"
    sql_from = " FROM company_accounts AS ca"
    sql_conditions = " WHERE ca.status = 'A' and ca.company_id = #{payload['company_id']}"
    sql_sort = " ORDER BY ca.name ASC"

    if params[:page].present? && params[:per_page].present?
      max = 20
      current_page = params[:page].to_i 
      per_page = params[:per_page].to_i
      current_page = current_page || 1
      per_page = per_page || max
      unless per_page <= max
        per_page = max
      end
      records_fetch_point = (current_page - 1) * per_page

      sql_employee_count = " ,(SELECT COUNT(*) FROM employees as emp WHERE ca.id = emp.company_account_id and emp.status = 'A') AS employee_count" 
      sql_paginate = " LIMIT #{per_page} OFFSET #{records_fetch_point}"
      sql_count = " COUNT(*) as total_count"

      company_account = execute_sql_query(sql_start + sql_fields + sql_employee_count + sql_from + sql_conditions + sql_sort + sql_paginate)
      counts = execute_sql_query(sql_start + sql_count + sql_from + sql_conditions)

      render json: {results: company_account, total_count: counts.first["total_count"] }
    else
      company_account = execute_sql_query(sql_start + sql_fields + sql_from + sql_conditions + sql_sort)
      render json: company_account
    end
  end

  
  # GET /company_accounts/1
  def show
    render json: @company_account
  end

  # POST /company_accounts
  def create
    @company_account = CompanyAccount.new(company_account_params.merge!({company_id: payload["company_id"] ,created_by_id: payload['user_id']}))
    if @company_account.save
      render json: @company_account, status: :created
    else
      render json: @company_account.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /company_accounts/1
  def update
    if @company_account.update(company_account_params)
      render json: @company_account
    else
      render json: @company_account.errors, status: :unprocessable_entity
    end
  end

  # DELETE /company_accounts/1
  def destroy
    if Employee.where(company_account_id: @company_account.id).count > 0
      @company_account.update(status: "I")
    else
      @company_account.destroy
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company_account
      @company_account = CompanyAccount.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def company_account_params
      params.require(:company_account).permit(:name, :code)
    end
end
