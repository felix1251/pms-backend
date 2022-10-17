class Api::V1::OnPayrollAdjustmentsController < PmsDesktopController
  before_action :authorize_access_request!
  before_action :check_backend_session
  before_action :set_on_payroll_adjustment, only: [:show, :update, :destroy]

  # GET /on_payroll_adjustments
  def index
    @on_payroll_adjustments = OnPayrollAdjustment.all
    render json: @on_payroll_adjustments
  end

  # GET /on_payroll_adjustments/1
  def show
    render json: @on_payroll_adjustment
  end

  def payroll_under_payments
    sql_start = "SELECT"
    sql_sum = " COALESCE(TRUNCATE(SUM(amount), 2), 0) AS total_amount"
    sql_fields = " id, description, payroll_id, employee_id, amount, adjustment_type"
    sql_from = " FROM on_payroll_adjustments"
    sql_conditions = " WHERE adjustment_type = 'U'"
    sql_conditions += " AND employee_id = #{params[:employee_id]}" if params[:employee_id].present?
    sql_conditions += " AND payroll_id = #{params[:payroll_id]}" if params[:payroll_id].present?
    sql_sort = " ORDER BY created_at DESC"

    sql_list = sql_start + sql_fields + sql_from + sql_conditions + sql_sort
    sql_total = sql_start + sql_sum + sql_from + sql_conditions

    under_payments_list = execute_sql_query(sql_list)
    under_payments_sum = execute_sql_query(sql_total)

    render json: {data: under_payments_list, amount_sum: under_payments_sum.first["total_amount"]}
  end

  def payroll_over_payments
    sql_start = "SELECT"
    sql_sum = " COALESCE(TRUNCATE(SUM(amount), 2), 0) AS total_amount"
    sql_fields = " id, description, payroll_id, employee_id, amount, adjustment_type"
    sql_from = " FROM on_payroll_adjustments"
    sql_conditions = " WHERE adjustment_type = 'O'"
    sql_conditions += " AND employee_id = #{params[:employee_id]}" if params[:employee_id].present?
    sql_conditions += " AND payroll_id = #{params[:payroll_id]}" if params[:payroll_id].present?
    sql_sort = " ORDER BY created_at DESC"

    sql_list = sql_start + sql_fields + sql_from + sql_conditions + sql_sort
    sql_total = sql_start + sql_sum + sql_from + sql_conditions

    over_payments_list = execute_sql_query(sql_list)
    over_payments_sum = execute_sql_query(sql_total)

    render json: {data: over_payments_list, amount_sum: over_payments_sum.first["total_amount"]}
  end

  # POST /on_payroll_adjustments
  def create
    @on_payroll_adjustment = OnPayrollAdjustment.new(on_payroll_adjustment_params)
    if @on_payroll_adjustment.save
      render json: @on_payroll_adjustment, status: :created
    else
      render json: @on_payroll_adjustment.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /on_payroll_adjustments/1
  def update
    if @on_payroll_adjustment.update(on_payroll_adjustment_params)
      render json: @on_payroll_adjustment
    else
      render json: @on_payroll_adjustment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /on_payroll_adjustments/1
  def destroy
    @on_payroll_adjustment.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_on_payroll_adjustment
      @on_payroll_adjustment = OnPayrollAdjustment.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def on_payroll_adjustment_params
      params.require(:on_payroll_adjustment).permit(:payroll_id, :employee_id, :description, :amount, :adjustment_type)
    end
end
