class Api::V1::LeavesController < PmsDesktopController
  before_action :authorize_access_request!
  before_action :check_backend_session
  before_action :set_leave, only: [:show, :update, :destroy]
  before_action :set_action, only: [:leave_action]

  # GET /leaves
  def index
    sql = "SELECT CASE WHEN le.end_date = le.start_date THEN end_date"
    sql += " ELSE CONCAT(le.start_date,',',le.end_date)" 
    sql += " END AS inclusive_date, le.created_at, le.id,"
    sql += " tol.name as type, reason, le.status, tol.with_pay,"
    sql += " CASE le.origin WHEN 0 THEN 'PMS' ELSE 'ERS' END AS origin,"
    sql += " (CASE le.half_day WHEN 0 THEN (DATEDIFF(le.end_date, le.start_date) + 1) ELSE 0.5 END) AS days,"
    sql += " CONCAT(emp.last_name, ', ', emp.first_name, ' ', CASE WHEN emp.suffix = '' THEN '' ELSE CONCAT(emp.suffix, '.') END,' ',"
    sql += " CASE emp.middle_name WHEN '' THEN '' ELSE CONCAT(SUBSTR(emp.middle_name, 1, 1), '.') END) AS fullname"
    sql += " FROM leaves as le"
    sql += " LEFT JOIN type_of_leaves AS tol ON tol.id = le.leave_type"
    sql += " LEFT JOIN employees as emp ON emp.id = le.employee_id"
    sql += " WHERE le.company_id = #{payload['company_id']} AND (le.status = 'A' OR le.status = 'D' OR le.status = 'V')"
    sql += " ORDER BY le.created_at ASC"
    leaves = execute_sql_query(sql)
    render json: leaves
  end

  def pending_leaves
    sql = "SELECT CASE WHEN le.end_date = le.start_date THEN end_date"
    sql += " ELSE CONCAT(le.start_date,',',le.end_date)" 
    sql += " END AS inclusive_date, le.created_at, tol.with_pay,"
    sql += " tol.name as type, reason, le.status, le.id,"
    sql += " CASE le.origin WHEN 0 THEN 'PMS' ELSE 'ERS' END AS origin,"
    sql += " (CASE le.half_day WHEN 0 THEN (DATEDIFF(le.end_date, le.start_date) + 1) ELSE 0.5 END) AS days,"
    sql += " CONCAT(emp.last_name, ', ', emp.first_name, ' ', CASE WHEN emp.suffix = '' THEN '' ELSE CONCAT(emp.suffix, '.') END,' ',"
    sql += " CASE emp.middle_name WHEN '' THEN '' ELSE CONCAT(SUBSTR(emp.middle_name, 1, 1), '.') END) AS fullname"
    sql += " FROM leaves as le"
    sql += " LEFT JOIN type_of_leaves AS tol ON tol.id = le.leave_type"
    sql += " LEFT JOIN employees as emp ON emp.id = le.employee_id"
    sql += " WHERE le.company_id = #{payload['company_id']} AND le.status = 'P'"
    sql += " ORDER BY le.created_at ASC"
    pending_leaves = execute_sql_query(sql)
    render json: pending_leaves
  end
  # GET /leaves/1
  def show
    render json: @leave
  end

  # POST /leaves
  def create
    @leave = Leave.new(leave_params.merge!({company_id: payload['company_id']}))
    if @leave.save
      render json: @leave, status: :created
    else
      render json: @leave.errors, status: :unprocessable_entity
    end
  end

  def leave_action
    if @leaveAction.update(action_params.merge!({actioned_by_id: payload['user_id']}))
      render json: @leaveAction
    else
      render json: @leaveAction.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /leaves/1
  def update
    if @leave.update(leave_params)
      render json: @leave
    else
      render json: @leave.errors, status: :unprocessable_entity
    end
  end

  # DELETE /leaves/1
  def destroy
    @leave.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_leave
      @leave = Leave.find(params[:id])
    end

    def set_action
      @leaveAction = Leave.find(params[:id])
    end

    def action_params
      params.require(:leave).permit(:status)
    end

    # Only allow a trusted parameter "white list" through.
    def leave_params
      params.require(:leave).permit(:employee_id, :start_date, :end_date, :leave_type, :reason, :half_day)
    end
end
