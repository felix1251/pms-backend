# class Api::V1::OnPayrollCompensationsController < PmsDesktopController
#   before_action :set_on_payroll_compensation, only: [:show, :update, :destroy]

#   # GET /on_payroll_compensations
#   def index
#     @on_payroll_compensations = OnPayrollCompensation.all

#     render json: @on_payroll_compensations
#   end

#   # GET /on_payroll_compensations/1
#   def show
#     render json: @on_payroll_compensation
#   end

#   # POST /on_payroll_compensations
#   def create
#     @on_payroll_compensation = OnPayrollCompensation.new(on_payroll_compensation_params)

#     if @on_payroll_compensation.save
#       render json: @on_payroll_compensation, status: :created, location: @on_payroll_compensation
#     else
#       render json: @on_payroll_compensation.errors, status: :unprocessable_entity
#     end
#   end

#   # PATCH/PUT /on_payroll_compensations/1
#   def update
#     if @on_payroll_compensation.update(on_payroll_compensation_params)
#       render json: @on_payroll_compensation
#     else
#       render json: @on_payroll_compensation.errors, status: :unprocessable_entity
#     end
#   end

#   # DELETE /on_payroll_compensations/1
#   def destroy
#     @on_payroll_compensation.destroy
#   end

#   private
#     # Use callbacks to share common setup or constraints between actions.
#     def set_on_payroll_compensation
#       @on_payroll_compensation = OnPayrollCompensation.find(params[:id])
#     end

#     # Only allow a trusted parameter "white list" through.
#     def on_payroll_compensation_params
#       params.require(:on_payroll_compensation).permit(:employee_id, :compesation, :payroll_id)
#     end
# end
