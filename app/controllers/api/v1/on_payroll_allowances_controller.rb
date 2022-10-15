class Api::V1::OnPayrollAllowancesController < PmsDesktopController
  before_action :authorize_access_request!
  before_action :check_backend_session
  before_action :set_on_payroll_allowance, only: [:show, :update, :destroy]

  # GET /on_payroll_allowances
  def index
    @on_payroll_allowances = OnPayrollAllowance.all

    render json: @on_payroll_allowances
  end

  # GET /on_payroll_allowances/1
  def show
    render json: @on_payroll_allowance
  end

  # POST /on_payroll_allowances
  def create
    @on_payroll_allowance = OnPayrollAllowance.new(on_payroll_allowance_params)

    if @on_payroll_allowance.save
      render json: @on_payroll_allowance, status: :created
    else
      render json: @on_payroll_allowance.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /on_payroll_allowances/1
  def update
    if @on_payroll_allowance.update(on_payroll_allowance_params)
      render json: @on_payroll_allowance
    else
      render json: @on_payroll_allowance.errors, status: :unprocessable_entity
    end
  end

  # DELETE /on_payroll_allowances/1
  def destroy
    @on_payroll_allowance.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_on_payroll_allowance
      @on_payroll_allowance = OnPayrollAllowance.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def on_payroll_allowance_params
      params.require(:on_payroll_allowance).permit(:employee_id, :amount, :name, :payroll_id)
    end
end
