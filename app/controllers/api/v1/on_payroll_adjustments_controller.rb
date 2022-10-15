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
      params.require(:on_payroll_adjustment).permit(:payroll_id, :employee_id, :description, :amount, :type)
    end
end
