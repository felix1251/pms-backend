class Api::Admin::CompaniesController < AdministratorsController
  before_action :authorize_access_request!
  before_action :set_company, only: [:show, :update, :destroy]

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

  # GET /companies/1
  def show
    render json: @company
  end

  # POST /companies
  def create
    @company = Company.new(company_params)
    if @company.save
      render json: @company, status: :created
    else
      render json: @company.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /companies/1
  def update
    if @company.update(company_params)
      render json: @company
    else
      render json: @company.errors, status: :unprocessable_entity
    end
  end

  # DELETE /companies/1
  def destroy
    @company.destroy
  end

  def token_claims
    {
      aud: ['admin'],
      verify_aud: true
    }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def company_params
      params.require(:company).permit(:description, :code, :status)
    end
end
