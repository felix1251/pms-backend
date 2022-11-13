class Api::V1::LeavesController < PmsDesktopController
  before_action :authorize_access_request!
  before_action :check_backend_session
  before_action :set_leave, only: [:show, :update, :destroy, :leave_action]

  # GET /leaves
  def index
    pagination = custom_pagination(params[:page].to_i, params[:per_page].to_i)

    sql_start = "SELECT"
    sql_count = " COUNT(*) AS total_count"
    sql_fields = " CASE WHEN le.end_date = le.start_date THEN end_date"
    sql_fields += " ELSE CONCAT(le.start_date,',',le.end_date)" 
    sql_fields += " END AS inclusive_date, le.id, le.created_at AS date_filed,"
    sql_fields += " tol.name as type, reason, le.status, tol.with_pay,"
    sql_fields += " CASE le.origin WHEN 0 THEN 'PMS' ELSE 'ERS' END AS origin,"
    sql_fields += " (CASE le.half_day WHEN 0 THEN (DATEDIFF(le.end_date, le.start_date) + 1) ELSE 0.5 END) AS days,"
    sql_fields += " CONCAT(emp.last_name, ', ', emp.first_name, ' ', CASE WHEN emp.suffix = '' THEN '' ELSE CONCAT(emp.suffix, '.') END,' ',"
    sql_fields += " CASE emp.middle_name WHEN '' THEN '' ELSE CONCAT(SUBSTR(emp.middle_name, 1, 1), '.') END) AS fullname"
    sql_from = " FROM leaves as le"
    sql_join = " LEFT JOIN type_of_leaves AS tol ON tol.id = le.leave_type"
    sql_join += " LEFT JOIN employees as emp ON emp.id = le.employee_id"
    sql_condition = " WHERE le.company_id = #{payload['company_id']} AND le.status != 'P'"
    sql_sort = " ORDER BY le.created_at DESC"
    sql_paginate = " LIMIT #{pagination[:per_page]} OFFSET #{pagination[:fetch_point]}"

    leaves = execute_sql_query(sql_start + sql_fields + sql_from + sql_join + sql_condition + sql_sort + sql_paginate)
    count = execute_sql_query(sql_start + sql_count + sql_from + sql_condition)
    render json: {data: leaves, total_count: count.first["total_count"]}
  end

  def pending_leaves
    pagination = custom_pagination(params[:page].to_i, params[:per_page].to_i)

    sql_start = "SELECT"
    sql_count = " COUNT(*) AS total_count"
    sql_fields = " CASE WHEN le.end_date = le.start_date THEN end_date"
    sql_fields += " ELSE CONCAT(le.start_date,',',le.end_date)" 
    sql_fields += " END AS inclusive_date, le.id, le.created_at AS date_filed,"
    sql_fields += " tol.name as type, reason, le.status, tol.with_pay,"
    sql_fields += " CASE le.origin WHEN 0 THEN 'PMS' ELSE 'ERS' END AS origin,"
    sql_fields += " (CASE le.half_day WHEN 0 THEN (DATEDIFF(le.end_date, le.start_date) + 1) ELSE 0.5 END) AS days,"
    sql_fields += " CONCAT(emp.last_name, ', ', emp.first_name, ' ', CASE WHEN emp.suffix = '' THEN '' ELSE CONCAT(emp.suffix, '.') END,' ',"
    sql_fields += " CASE emp.middle_name WHEN '' THEN '' ELSE CONCAT(SUBSTR(emp.middle_name, 1, 1), '.') END) AS fullname"
    sql_from = " FROM leaves as le"
    sql_join = " LEFT JOIN type_of_leaves AS tol ON tol.id = le.leave_type"
    sql_join += " LEFT JOIN employees as emp ON emp.id = le.employee_id"
    sql_condition = " WHERE le.company_id = #{payload['company_id']} AND le.status = 'P'"
    sql_sort = " ORDER BY le.created_at DESC"
    sql_paginate = " LIMIT #{pagination[:per_page]} OFFSET #{pagination[:fetch_point]}"

    leaves = execute_sql_query(sql_start + sql_fields + sql_from + sql_join + sql_condition + sql_sort + sql_paginate)
    count = execute_sql_query(sql_start + sql_count + sql_from + sql_condition)
    render json: {data: leaves, total_count: count.first["total_count"]}
  end

  def leaves_count
    com_id = payload['company_id']
    sql = "SELECT"
    sql += " (SELECT COUNT(*) FROM leaves WHERE status = 'P' AND company_id = #{com_id}) as pending,"
    sql += " (SELECT COUNT(*) FROM leaves WHERE status = 'A' AND company_id = #{com_id}) as approved,"
    sql += " (SELECT COUNT(*) FROM leaves WHERE status = 'D' AND company_id = #{com_id}) as rejected,"
    sql += " (SELECT COUNT(*) FROM leaves WHERE status = 'V' AND company_id = #{com_id}) as voided"
    counts = execute_sql_query(sql)
    render json: counts.first
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

    def action_params
      params.require(:leave).permit(:status)
    end

    # Only allow a trusted parameter "white list" through.
    def leave_params
      params.require(:leave).permit(:employee_id, :start_date, :end_date, :leave_type, :reason, :half_day)
    end
end
