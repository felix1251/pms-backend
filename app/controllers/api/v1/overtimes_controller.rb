class Api::V1::OvertimesController < PmsDesktopController
  before_action :authorize_access_request!
  before_action :check_backend_session
  before_action :set_overtime, only: [:show, :update, :destroy]
  before_action :set_action, only: [:overtime_action]

  # GET /overtimes
  def index
    max = 20
    current_page = params[:page].to_i 
    per_page = params[:per_page].to_i
    current_page = current_page || 1
    per_page = per_page || max
    per_page = max unless per_page <= max
    records_fetch_point = (current_page - 1) * per_page

    sql_start = "SELECT"
    sql_count = " COUNT(*) AS total_count"
    sql_fields = " CONCAT(ov.start_date, ',', ov.end_date) AS datetime,"
    sql_fields += " ov.output, ov.status, ov.id, ov.created_at AS date_filed, ov.billable,"
    sql_fields += " CASE ov.origin WHEN 0 THEN 'PMS' ELSE 'ERS' END AS origin,"
    sql_fields += " TIMESTAMPDIFF(HOUR, DATE_FORMAT(ov.start_date, '%Y-%m-%d %H:%i'), DATE_FORMAT(ov.end_date, '%Y-%m-%d %H:%i')) AS hours,"
    sql_fields += " CONCAT(emp.last_name, ', ', emp.first_name, ' ', CASE WHEN emp.suffix = '' THEN '' ELSE CONCAT(emp.suffix, '.') END,' ',"
    sql_fields += " CASE emp.middle_name WHEN '' THEN '' ELSE CONCAT(SUBSTR(emp.middle_name, 1, 1), '.') END) AS fullname"
    sql_from = " FROM overtimes as ov"
    sql_join = " LEFT JOIN employees as emp ON emp.id = ov.employee_id"
    sql_condition = " WHERE ov.company_id = #{payload['company_id']} AND ov.status != 'P'"
    sql_sort = " ORDER BY ov.created_at DESC"
    sql_paginate = " LIMIT #{per_page} OFFSET #{records_fetch_point}"

    overtimes = execute_sql_query(sql_start + sql_fields + sql_from + sql_join + sql_condition + sql_sort + sql_paginate)
    count = execute_sql_query(sql_start + sql_count + sql_from + sql_condition)
    render json: {data: overtimes, total_count: count.first["total_count"]}
  end

  def pending_overtimes
    max = 20
    current_page = params[:page].to_i 
    per_page = params[:per_page].to_i
    current_page = current_page || 1
    per_page = per_page || max
    per_page = max unless per_page <= max
    records_fetch_point = (current_page - 1) * per_page

    sql_start = "SELECT"
    sql_count = " COUNT(*) AS total_count"
    sql_fields = " CONCAT(ov.start_date,',', ov.end_date) AS datetime,"
    sql_fields += " ov.output, ov.status, ov.id, ov.created_at AS date_filed, ov.billable,"
    sql_fields += " CASE ov.origin WHEN 0 THEN 'PMS' ELSE 'ERS' END AS origin,"
    sql_fields += " TIMESTAMPDIFF(HOUR, DATE_FORMAT(ov.start_date, '%Y-%m-%d %H:%i'), DATE_FORMAT(ov.end_date, '%Y-%m-%d %H:%i')) AS hours,"
    sql_fields += " CONCAT(emp.last_name, ', ', emp.first_name, ' ', CASE WHEN emp.suffix = '' THEN '' ELSE CONCAT(emp.suffix, '.') END,' ',"
    sql_fields += " CASE emp.middle_name WHEN '' THEN '' ELSE CONCAT(SUBSTR(emp.middle_name, 1, 1), '.') END) AS fullname"
    sql_from = " FROM overtimes as ov"
    sql_join = " LEFT JOIN employees as emp ON emp.id = ov.employee_id"
    sql_condition = " WHERE ov.company_id = #{payload['company_id']} AND ov.status = 'P'"
    sql_sort = " ORDER BY ov.created_at DESC"
    sql_paginate = " LIMIT #{per_page} OFFSET #{records_fetch_point}"

    overtimes = execute_sql_query(sql_start + sql_fields + sql_from + sql_join + sql_condition + sql_sort + sql_paginate)
    count = execute_sql_query(sql_start + sql_count + sql_from + sql_condition)
    render json: {data: overtimes, total_count: count.first["total_count"]}
  end

  # GET /overtimes/1
  def show
    render json: @overtime
  end

  def overtime_count
    com_id = payload['company_id']
    sql = "SELECT"
    sql += " (SELECT COUNT(*) FROM overtimes WHERE status = 'P' AND company_id = #{com_id}) as pending,"
    sql += " (SELECT COUNT(*) FROM overtimes WHERE status = 'A' AND company_id = #{com_id}) as approved,"
    sql += " (SELECT COUNT(*) FROM overtimes WHERE status = 'D' AND company_id = #{com_id}) as rejected,"
    sql += " (SELECT COUNT(*) FROM overtimes WHERE status = 'V' AND company_id = #{com_id}) as voided"
    counts = execute_sql_query(sql)
    render json: counts.first
  end

  # POST /overtimes
  def create
    @overtime = Overtime.new(overtime_params.merge!({company_id: payload['company_id']}))
    if @overtime.save
      render json: @overtime, status: :created
    else
      render json: @overtime.errors, status: :unprocessable_entity
    end
  end

  def overtime_action
    if @overtime.update(action_params.merge!({actioned_by_id: payload['user_id']}))
      render json: @overtime
    else
      render json:  @overtime.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /overtimes/1
  def update
    if @overtime.update(overtime_params)
      render json: @overtime
    else
      render json: @overtime.errors, status: :unprocessable_entity
    end
  end

  # DELETE /overtimes/1
  def destroy
    @overtime.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_overtime
      @overtime = Overtime.find(params[:id])
    end

    def set_action
      @overtime = Overtime.find(params[:id])
    end

    def action_params
      params.require(:overtime).permit(:status)
    end

    # Only allow a trusted parameter "white list" through.
    def overtime_params
      params.require(:overtime).permit(:employee_id, :output, :start_date, :end_date, :billable)
    end
end
