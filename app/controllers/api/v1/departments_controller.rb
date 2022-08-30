class Api::V1::DepartmentsController < PmsDesktopController
  before_action :authorize_access_request!
  before_action :check_backend_session
  before_action :set_department, only: [:show, :update, :destroy]

  # GET /departments
  def index
    sql_start = ""
    sql_start += "SELECT"
    sql_fields = " dp.id value, dp.name AS label, dp.code"
    sql_from = " FROM departments AS dp"
    sql_conditions = " WHERE dp.status = 'A' and dp.company_id = #{payload['company_id']}"
    sql_sort = " ORDER BY dp.name ASC"
    departments = execute_sql_query(sql_start + sql_fields + sql_from + sql_conditions + sql_sort)
    render json:departments
  end

  # GET /departments/1
  def show
    render json: @department
  end

  # POST /departments
  def create
    @department = Department.new(department_params.merge!({company_id: payload["company_id"] ,created_by_id: payload['user_id']}))
    if @department.save
      render json: @department, status: :created
    else
      render json: @department.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /departments/1
  def update
    if @department.update(department_params)
      render json: @department
    else
      render json: @department.errors, status: :unprocessable_entity
    end
  end

  # DELETE /departments/1
  def destroy
    @department.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_department
      @department = Department.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def department_params
      params.require(:department).permit(:code, :name)
    end
end
