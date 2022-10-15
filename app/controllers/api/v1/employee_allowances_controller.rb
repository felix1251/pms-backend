class Api::V1::EmployeeAllowancesController < PmsDesktopController
  before_action :authorize_access_request!
  before_action :check_backend_session
  before_action :set_employee_allowance, only: [:show, :update, :destroy]

  # GET /employee_allowances
  def index
    @employee_allowances = EmployeeAllowance.all
    render json: @employee_allowances
  end

  def employee_allowance_list
    sql = " SELECT *"
    sql += " FROM employee_allowances"
    sql += " WHERE employee_id = #{params[:employee_id]}"
    sql += " ORDER BY created_at DESC"
    employee_allowances = execute_sql_query(sql)
    render json: employee_allowances
  end

  # GET /employee_allowances/1
  def show
    render json: @employee_allowance
  end

  # POST /employee_allowances
  def create
    @employee_allowance = EmployeeAllowance.new(employee_allowance_params)
    if @employee_allowance.save
      render json: @employee_allowance, status: :created
    else
      render json: @employee_allowance.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /employee_allowances/1
  def update
    if @employee_allowance.update(employee_allowance_params)
      render json: @employee_allowance
    else
      render json: @employee_allowance.errors, status: :unprocessable_entity
    end
  end

  # DELETE /employee_allowances/1
  def destroy
    @employee_allowance.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employee_allowance
      @employee_allowance = EmployeeAllowance.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def employee_allowance_params
      params.require(:employee_allowance).permit(:employee_id, :amount, :name)
    end
end
