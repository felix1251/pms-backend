class Api::V1::SchedulesController < PmsDesktopController
  before_action :authorize_access_request!
  before_action :check_backend_session
  before_action :set_schedule, only: [:update, :destroy]

  # GET /schedules
  def index
    sql = "SELECT"
    sql += " CONCAT(DATE_FORMAT(sc.start_date, '%b %d, %Y'),' to ',"
    sql += " DATE_FORMAT(sc.end_date, '%b %d, %Y')) as date,"
    sql += " dp.name AS department_name, sc.title, sc.id, sc.start_date, sc.end_date"
    sql += " FROM schedules AS sc"
    sql += " LEFT JOIN departments AS dp ON dp.id = sc.department_id"
    sql += " WHERE sc.company_id = #{payload['company_id']}"
    sql += " ORDER BY sc.created_at DESC"
    schedules = execute_sql_query(sql)
    render json: schedules
  end

  # GET /schedules/1
  def show
    value = '"value"'
    label = '"label"'
    ats = '"'
    sql = "SELECT CONCAT('[{#{value}:',sc.department_id,',#{label}:','#{ats}',dp.name,'#{ats}','}]') AS department_json,"
    sql += " sc.start_date, sc.end_date, sc.department_id, sc.remarks, sc.id, sc.title"
    sql += " FROM schedules AS sc"
    sql += " LEFT JOIN departments AS dp ON dp.id = sc.department_id"
    sql += " WHERE sc.id = #{params[:id]}"
    sql += " LIMIT 1"
    execute_sql_query("SET SESSION group_concat_max_len = 10000;")
    details = execute_sql_query(sql).first
    render json: details
  end

  def schedule_listing
    schedule = Schedule.find(params[:id])

    ats = '"'
    sql = "SELECT"
    sql += " CONCAT(emp.last_name, ', ', emp.first_name, ' ', CASE WHEN emp.suffix = '' THEN '' ELSE CONCAT(emp.suffix, '.') END,' ',"
		sql += " CASE emp.middle_name WHEN '' THEN '' ELSE CONCAT(SUBSTR(emp.middle_name, 1, 1), '.') END) AS fullname,"
    sql += " (SELECT IFNULL(JSON_ARRAYAGG(JSON_OBJECT('id', es.id, 'start_time_iso', es.start_time, 'end_time_iso', es.end_time,"
    sql += " 'employee_id', es.employee_id, 'start_date', DATE(es.start_time), 'end_date', DATE(es.end_time),"
    sql += " 'end_time_24hrs', DATE_FORMAT(es.end_time, '%H:%i'), 'start_time_24hrs', DATE_FORMAT(es.start_time, '%H:%i'),"
    sql += " 'end_time', DATE_FORMAT(es.end_time, '%h:%i %p'), 'start_time', DATE_FORMAT(es.start_time, '%h:%i %p'),"
    sql += " 'hours', TRUNCATE(TIMESTAMPDIFF(MINUTE, es.start_time, es.end_time)/60, 1), 'until_next_day', IF(DATE(es.start_time) = DATE(es.end_time), 0, 1))), '[]')"
    sql += " FROM (SELECT * FROM employee_schedules AS es WHERE es.employee_id = emp.id"
    sql += " AND (DATE(es.start_time) BETWEEN '#{schedule.start_date}' AND '#{schedule.end_date}')) es) as sched_json,"
    sql += " emp.id, emp.employee_id"
    sql += " FROM employees AS emp"
    sql += " WHERE emp.department_id = #{schedule.department_id} AND emp.work_sched_type = 'FL'"

    results = execute_sql_query(sql) 
    columns = (schedule.start_date..schedule.end_date).map(&:to_s)
    render json: {data: results, columns: columns}
  end

  # POST /schedules
  def create
    @schedule = Schedule.new(schedule_params.merge!({company_id: payload["company_id"]}))
    if @schedule.save
      render json: @schedule, status: :created
    else
      render json: @schedule.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /schedules/1
  def update
    if @schedule.update(schedule_params)
      render json: @schedule
    else
      render json: @schedule.errors, status: :unprocessable_entity
    end
  end

  # DELETE /schedules/1
  def destroy
    @schedule.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_schedule
      @schedule = Schedule.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def schedule_params
      params.require(:schedule).permit(:title, :start_date, :end_date, :remarks, :department_id)
    end
end
