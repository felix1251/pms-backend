class Api::V2::OffsetsController < PmsErsController
  before_action :authorize_access_request!
  before_action :set_offset, only: [:show, :update, :destroy]
  before_action :set_action, only: [:offset_action]

  # GET /offsets
  def index
    pagination = custom_pagination(params[:page].to_i, params[:per_page].to_i)
    sql_start = " SELECT"
    sql_count = " COUNT(*) AS total_count"
    sql_fields = " DATE_FORMAT(ofs.offset_date, '%b %d, %Y') AS offset_date, ofs.id, 8 AS hours_used, ofs.reason, ofs.status,"
    sql_fields += " DATE_FORMAT(ofs.created_at, '%b %d, %Y %h:%i %p') AS date_filed, ofs.id"
    sql_from = " FROM offsets as ofs"
    sql_condition = " WHERE ofs.employee_id = #{payload['employee_id']}"
    sql_sort = " ORDER BY created_at DESC"
    sql_paginate = " LIMIT #{pagination[:per_page]} OFFSET #{pagination[:fetch_point]}"
    offsets = execute_sql_query(sql_start + sql_fields + sql_from + sql_condition + sql_sort + sql_paginate)
    count = execute_sql_query(sql_start + sql_count + sql_from + sql_condition)
    render json: {data: offsets, total_count: count.first["total_count"]}
  end

  # GET /offsets/1
  def show
    render json: @offset
  end

  def emp_overtime
    sql = "SELECT"
    sql += " IFNULL(SUM(TRUNCATE((TIMESTAMPDIFF("
    sql += " MINUTE, DATE_FORMAT(start_date, '%Y-%m-%d %H:%i'), DATE_FORMAT(end_date, '%Y-%m-%d %H:%i'))/60)"
    sql += " - (SELECT SUM(8) FROM offsets WHERE employee_id = #{payload['employee_id']} AND status = 'A' )"
    sql += " ,2)), 0) AS overtime_credits"
    sql += " FROM overtimes"
    sql += " WHERE employee_id = #{payload['employee_id']} AND status = 'A' AND billable = 0"

    emp_ov = execute_sql_query(sql)
    render json: emp_ov.first["overtime_credits"]
  end

  # POST /offsets
  def create
    @offset = Offset.new(offset_params.merge!({company_id: employee_company_id, employee_id: payload["employee_id"]}))
    if @offset.save
      render json: @offset, status: :created
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
      params.require(:offset).permit(:offset_date, :reason)
    end
end
