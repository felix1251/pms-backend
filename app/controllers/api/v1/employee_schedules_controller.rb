class Api::V1::EmployeeSchedulesController < PmsDesktopController
  before_action :authorize_access_request!
  before_action :check_backend_session
  before_action :set_employee_schedule, only: [:show, :update, :destroy]

  # GET /employee_schedules
  def index
    sql = "SELECT"
    sql += " es.id,"
    sql += " DATE_FORMAT(es.start_time, '%b %d, %Y %h:%i %p') as start_time, DATE_FORMAT(es.end_time, '%b %d, %Y %h:%i %p') as end_time," if params[:day].present?
    sql += " TRUNCATE(TIMESTAMPDIFF(MINUTE, es.start_time, es.end_time)/60, 1) AS hours" if params[:day].present?
    sql += " CONCAT(DATE_FORMAT(es.start_time, '%h:%i %p'), ' - ', DATE_FORMAT(es.end_time, '%h:%i %p'), ' (', TRUNCATE(TIMESTAMPDIFF(MINUTE, es.start_time, es.end_time)/60, 1), ' hrs)') AS time_range, " if params[:month].present?
    sql += " DATE(es.start_time) AS only_date" if params[:month].present?
    sql += " FROM employee_schedules es"
    sql += " WHERE"
    sql += " es.employee_id = #{params[:employee_id]}" if params[:employee_id].present?
    sql += " AND DATE(es.start_time) = '#{params[:day]}'" if params[:day].present?
    sql += " AND DATE_FORMAT(es.start_time, '%Y-%m') = '#{params[:month]}'" if params[:month].present?
    sql += " ORDER BY es.start_time"
    employee_schedules = execute_sql_query(sql)
    render json: employee_schedules
  end

  # GET /employee_schedules/1
  def show
    render json: @employee_schedule
  end

  # POST /employee_schedules
  def create
    @employee_schedule = EmployeeSchedule.new(employee_schedule_params)
    if @employee_schedule.save
      render json: @employee_schedule, status: :created
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
