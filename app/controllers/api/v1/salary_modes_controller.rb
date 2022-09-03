class Api::V1::SalaryModesController < PmsDesktopController
  before_action :authorize_access_request!
  before_action :check_backend_session
  before_action :set_salary_mode, only: [:show, :update, :destroy]

  # GET /salary_modes
  def index
    sql_start = "SELECT" 
    sql_fields = " sm.id as value, sm.description as label, sm.code"
    sql_from = " FROM salary_modes as sm"

    if params[:grouping].present? && params[:grouping]
      sql_employee_count = " ,(SELECT COUNT(*) FROM employees as emp WHERE sm.id = emp.salary_mode_id) AS employee_count"
      salary_modes = execute_sql_query(sql_start + sql_fields + sql_employee_count + sql_from)
      render json: salary_modes
    else
      salary_modes = execute_sql_query(sql_start + sql_fields + sql_from)
      render json: salary_modes
    end
  end

  # # GET /salary_modes/1
  # def show
  #   render json: @salary_mode
  # end

  # # POST /salary_modes
  # def create
  #   @salary_mode = SalaryMode.new(salary_mode_params)

  #   if @salary_mode.save
  #     render json: @salary_mode, status: :created, location: @salary_mode
  #   else
  #     render json: @salary_mode.errors, status: :unprocessable_entity
  #   end
  # end

  # # PATCH/PUT /salary_modes/1
  # def update
  #   if @salary_mode.update(salary_mode_params)
  #     render json: @salary_mode
  #   else
  #     render json: @salary_mode.errors, status: :unprocessable_entity
  #   end
  # end

  # # DELETE /salary_modes/1
  # def destroy
  #   @salary_mode.destroy
  # end

  # private
  #   # Use callbacks to share common setup or constraints between actions.
  #   def set_salary_mode
  #     @salary_mode = SalaryMode.find(params[:id])
  #   end

  #   # Only allow a trusted parameter "white list" through.
  #   def salary_mode_params
  #     params.fetch(:salary_mode, {})
  #   end
end
