class Api::V1::EmployeeSchedulesController < PmsDesktopController
  before_action :set_employee_schedule, only: [:show, :update, :destroy]

  # GET /employee_schedules
  def index
    @employee_schedules = EmployeeSchedule.all
    render json: @employee_schedules
  end

  # GET /employee_schedules/1
  def show
    render json: @employee_schedule
  end

  # POST /employee_schedules
  def create
    @employee_schedule = EmployeeSchedule.new(employee_schedule_params)

    if @employee_schedule.save
      render json: @employee_schedule, status: :created, location: @employee_schedule
    else
      render json: @employee_schedule.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /employee_schedules/1
  def update
    if @employee_schedule.update(employee_schedule_params)
      render json: @employee_schedule
    else
      render json: @employee_schedule.errors, status: :unprocessable_entity
    end
  end

  # DELETE /employee_schedules/1
  def destroy
    @employee_schedule.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employee_schedule
      @employee_schedule = EmployeeSchedule.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def employee_schedule_params
      params.require(:employee_schedule).permit(:start_time, :end_time, :employee_id)
    end
end
