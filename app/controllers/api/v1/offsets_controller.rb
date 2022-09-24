class Api::V1::OffsetsController < PmsDesktopController
  before_action :authorize_access_request!
  before_action :check_backend_session
  before_action :set_offset, only: [:show, :update, :destroy]
  before_action :set_action, only: [:offset_action]

  # GET /offsets
  def index
    max = 20
    current_page = params[:page].to_i 
    per_page = params[:per_page].to_i
    current_page = current_page || 1
    per_page = per_page || max
    per_page = max unless per_page <= max
    records_fetch_point = (current_page - 1) * per_page

    sql_start = " SELECT"
    sql_count = " COUNT(*) AS total_count"
    sql_fields = " (SELECT COALESCE(SUM(TIMESTAMPDIFF(HOUR, DATE_FORMAT(start_date, '%Y-%m-%d %H:%i'), DATE_FORMAT(end_date, '%Y-%m-%d %H:%i'))), 0)"
    sql_fields += " FROM overtimes WHERE offset_id = ofs.id) AS ot_total_hours, DATE_FORMAT(ofs.offset_date, '%b %d, %Y') AS offset_date, ofs.id,"
    sql_fields += " DATE_FORMAT(ofs.created_at, '%b %d, %Y %h:%i %p') AS date_filed, CASE ofs.origin WHEN 0 THEN 'PMS' ELSE 'ERS' END AS origin,"
    sql_fields += " CONCAT(emp.last_name, ', ', emp.first_name, ' ', CASE WHEN emp.suffix = '' THEN '' ELSE CONCAT(emp.suffix, '.') END,' ',"
    sql_fields += " CASE emp.middle_name WHEN '' THEN '' ELSE CONCAT(SUBSTR(emp.middle_name, 1, 1), '.') END) AS fullname, ofs.reason, ofs.status"
    sql_from = " FROM offsets as ofs"
    sql_join = " LEFT JOIN employees as emp ON emp.id = ofs.employee_id"
    sql_condition = " WHERE ofs.company_id = #{payload['company_id']} AND ofs.status != 'P'"
    sql_sort = " ORDER BY ofs.created_at DESC"
    sql_paginate = " LIMIT #{per_page} OFFSET #{records_fetch_point}"

    offsets = execute_sql_query(sql_start + sql_fields + sql_from + sql_join + sql_condition + sql_sort + sql_paginate)
    count = execute_sql_query(sql_start + sql_count + sql_from + sql_condition)
    render json: {data: offsets, total_count: count.first["total_count"]}
  end

  def pending_offsets
    max = 20
    current_page = params[:page].to_i 
    per_page = params[:per_page].to_i
    current_page = current_page || 1
    per_page = per_page || max
    per_page = max unless per_page <= max
    records_fetch_point = (current_page - 1) * per_page

    sql_start = " SELECT"
    sql_count = " COUNT(*) AS total_count"
    sql_fields = " (SELECT COALESCE(SUM(TIMESTAMPDIFF(HOUR, DATE_FORMAT(start_date, '%Y-%m-%d %H:%i'), DATE_FORMAT(end_date, '%Y-%m-%d %H:%i'))), 0)"
    sql_fields += " FROM overtimes WHERE offset_id = ofs.id) AS ot_total_hours, DATE_FORMAT(ofs.offset_date, '%b %d, %Y') AS offset_date, ofs.id,"
    sql_fields += " DATE_FORMAT(ofs.created_at, '%b %d, %Y %h:%i %p') AS date_filed, CASE ofs.origin WHEN 0 THEN 'PMS' ELSE 'ERS' END AS origin,"
    sql_fields += " CONCAT(emp.last_name, ', ', emp.first_name, ' ', CASE WHEN emp.suffix = '' THEN '' ELSE CONCAT(emp.suffix, '.') END,' ',"
    sql_fields += " CASE emp.middle_name WHEN '' THEN '' ELSE CONCAT(SUBSTR(emp.middle_name, 1, 1), '.') END) AS fullname, ofs.reason, ofs.status"
    sql_from = " FROM offsets as ofs"
    sql_join = " LEFT JOIN employees as emp ON emp.id = ofs.employee_id"
    sql_condition = " WHERE ofs.company_id = #{payload['company_id']} AND ofs.status = 'P'"
    sql_sort = " ORDER BY ofs.created_at DESC"
    sql_paginate = " LIMIT #{per_page} OFFSET #{records_fetch_point}"

    offsets = execute_sql_query(sql_start + sql_fields + sql_from + sql_join + sql_condition + sql_sort + sql_paginate)
    count = execute_sql_query(sql_start + sql_count + sql_from + sql_condition)
    render json: {data: offsets, total_count: count.first["total_count"]}
  end

  # GET /offsets/1
  def show
    render json: @offset
  end

  def offset_count
    com_id = payload['company_id']
    sql = "SELECT"
    sql += " (SELECT COUNT(*) FROM offsets WHERE status = 'P' AND company_id = #{com_id}) as pending,"
    sql += " (SELECT COUNT(*) FROM offsets WHERE status = 'A' AND company_id = #{com_id}) as approved,"
    sql += " (SELECT COUNT(*) FROM offsets WHERE status = 'D' AND company_id = #{com_id}) as rejected,"
    sql += " (SELECT COUNT(*) FROM offsets WHERE status = 'V' AND company_id = #{com_id}) as voided"
    counts = execute_sql_query(sql)
    render json: counts.first
  end

  # POST /offsets
  def create
    @offset = Offset.new(offset_params.merge!({company_id: payload['company_id']}))
    if @offset.save
      overtime = Overtime.where(id: offset_params[:overtime_ids]).update(offset_id: @offset.id)
      render json: {offset: @offset, overtimes: overtime}, status: :created
    else
      render json: @offset.errors, status: :unprocessable_entity
    end
  end

  def offset_action
    if @offset.update(action_params.merge!({actioned_by_id: payload['user_id']}))
      render json: @offset
    else
      render json:  @offset.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /offsets/1
  def update
    if @offset.update(offset_params)
      render json: @offset
    else
      render json: @offset.errors, status: :unprocessable_entity
    end
  end

  # DELETE /offsets/1
  def destroy
    @offset.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_offset
      @offset = Offset.find(params[:id])
    end

    def set_action
      @offset = Offset.find(params[:id])
    end

    def action_params
      params.require(:offset).permit(:status)
    end

    # Only allow a trusted parameter "white list" through.
    def offset_params
      params.require(:offset).permit(:employee_id, :offset_date, :reason, :overtime_ids => [])
    end
end