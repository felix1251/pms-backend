class Api::V1::UndertimesController < PmsDesktopController
  before_action :authorize_access_request!
  before_action :check_backend_session
  before_action :set_undertime, only: [:show, :update, :destroy, :undertime_action]

  # GET /undertimes
  def index
    pagination = custom_pagination(params[:page].to_i, params[:per_page].to_i)

    allow_status = ['P']
    status = allow_status.include?(params[:status] || "") ? " = 'P'" : " != 'P'"

    sql_start = "SELECT"
    sql_count = " COUNT(*) AS total_count"
    sql_fields = " und.id, und.status, DATE_FORMAT(und.created_at, '%b %d, %Y %h:%i %p') AS date_filed, und.reason, CASE und.origin WHEN 0 THEN 'PMS' ELSE 'ERS' END AS origin,"
    sql_fields += " TRUNCATE(TIMESTAMPDIFF(MINUTE, DATE_FORMAT(und.start_time, '%Y-%m-%d %H:%i'), DATE_FORMAT(und.end_time, '%Y-%m-%d %H:%i'))/60, 2) AS hours,"
    sql_fields += " CONCAT(DATE_FORMAT(und.start_time, '%b %d, %Y %h:%i %p'),' - ',DATE_FORMAT(und.end_time, '%b %d, %Y %h:%i %p')) AS datetime,"
    sql_fields += " CONCAT(emp.last_name, ', ', emp.first_name, ' ', CASE WHEN emp.suffix = '' THEN '' ELSE CONCAT(emp.suffix, '.') END,' ',"
    sql_fields += " CASE emp.middle_name WHEN '' THEN '' ELSE CONCAT(SUBSTR(emp.middle_name, 1, 1), '.') END) AS fullname"
    sql_from = " FROM undertimes AS und"
    sql_join = " LEFT JOIN employees as emp ON emp.id = und.employee_id"
    sql_condition = " WHERE und.company_id = #{payload['company_id']}"
    sql_condition += " AND und.status #{status}"
    sql_sort = " ORDER BY und.created_at DESC"
    sql_paginate = " LIMIT #{pagination[:per_page]} OFFSET #{pagination[:fetch_point]}"

    undertimes = execute_sql_query(sql_start + sql_fields + sql_from + sql_join + sql_condition + sql_sort + sql_paginate)
    count = execute_sql_query(sql_start + sql_count + sql_from + sql_condition)

    render json: {data: undertimes, total_count: count.first["total_count"]}
  end

  # GET /undertimes/1
  def show
    render json: @undertime
  end

  def undertime_count
    com_id = payload['company_id']
    sql = "SELECT"
    sql += " (SELECT COUNT(*) FROM undertimes WHERE status = 'P' AND company_id = #{com_id}) as pending,"
    sql += " (SELECT COUNT(*) FROM undertimes WHERE status = 'A' AND company_id = #{com_id}) as approved,"
    sql += " (SELECT COUNT(*) FROM undertimes WHERE status = 'D' AND company_id = #{com_id}) as rejected,"
    sql += " (SELECT COUNT(*) FROM undertimes WHERE status = 'V' AND company_id = #{com_id}) as voided"
    counts = execute_sql_query(sql)
    render json: counts.first
  end

  # POST /undertimes
  def create
    @undertime = Undertime.new(undertime_params.merge!({company_id: payload["company_id"]}))
    if @undertime.save
      render json: @undertime, status: :created
    else
      render json: @undertime.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /undertimes/1
  def update
    if @undertime.update(undertime_params)
      render json: @undertime
    else
      render json: @undertime.errors, status: :unprocessable_entity
    end
  end

  def undertime_action
    if @undertime.update(action_params.merge!({actioned_by_id: payload['user_id']}))
      render json: @leaveAction
    else
      render json: @undertime.errors, status: :unprocessable_entity
    end
  end

  # DELETE /undertimes/1
  def destroy
    @undertime.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_undertime
      @undertime = Undertime.find(params[:id])
    end

    def action_params
      params.require(:undertime).permit(:status)
    end

    # Only allow a trusted parameter "white list" through.
    def undertime_params
      params.require(:undertime).permit(:start_time, :end_time, :employee_id, :reason)
    end
end
