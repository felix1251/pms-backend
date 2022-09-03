class Api::V1::EmploymentStatusesController < PmsDesktopController
  before_action :authorize_access_request!
  before_action :check_backend_session
  before_action :set_employment_status, only: [:show, :update, :destroy]

  # GET /employment_statuses
  def index
    sql_start = ""
    sql_start += "SELECT"
    sql_fields = " es.id value, es.name as label, es.code"
    sql_from = " FROM employment_statuses as es"
    sql_conditions = " WHERE es.status = 'A'"
    sql_sort = " ORDER BY es.name"

    if params[:grouping].present? && params[:grouping]
      sql_employee_count = " ,(SELECT COUNT(*) FROM employees as emp WHERE es.id = emp.employment_status_id) AS employee_count"
      employment_status = execute_sql_query(sql_start + sql_fields + sql_employee_count + sql_from + sql_conditions + sql_sort)
      render json: employment_status
    else
      employment_status = execute_sql_query(sql_start + sql_fields + sql_from + sql_conditions + sql_sort)
      render json: employment_status
    end
  end

  # GET /employment_statuses/1
  def show
    render json: @employment_status
  end

  # POST /employment_statuses
  def create
    @employment_status = EmploymentStatus.new(employment_status_params)
    if @employment_status.save
      render json: @employment_status, status: :created, location: @employment_status
    else
      render json: @employment_status.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /employment_statuses/1
  def update
    if @employment_status.update(employment_status_params)
      render json: @employment_status
    else
      render json: @employment_status.errors, status: :unprocessable_entity
    end
  end

  # DELETE /employment_statuses/1
  def destroy
    @employment_status.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employment_status
      @employment_status = EmploymentStatus.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def employment_status_params
      params.require(:employment_status).permit(:name)
    end
end
