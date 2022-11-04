class Api::V2::OffsetsController < PmsErsController
  before_action :authorize_access_request!
  before_action :set_offset, only: [:show, :update, :destroy]

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
    render json: offset_credits
  end

  # POST /offsets
  def create
    @offset = Offset.new(offset_params.merge!({company_id: payload["company_id"], employee_id: payload["employee_id"]}))
    if @offset.save
      render json: @offset, status: :created
    else
      render json: @offset.errors, status: :unprocessable_entity
    end
  end

  def update
    if @offset.status == "P" && @offset.update(offset_params)
      render json: @offset
    else
      if @offset.status != "P"
        render json: {error: "Cant't update offset"}, status: :unprocessable_entity
      else
        render json: @offset.errors, status: :unprocessable_entity
      end
    end
  end

  # DELETE /offsets/1
  def destroy
    if @offset.status == "P" && @offset.update(status: "V")
      render json: {message: "Offset voided"}
    else
      if @offset.status != "P"
        render json: {error: "Cant't void offset"}, status: :unprocessable_entity
      else
        render json: @offset.errors, status: :unprocessable_entity
      end
    end
  end

  private

    def offset_credits
      today = Date.today
      start_of_the_year = today.beginning_of_year.strftime("%Y-%m-%d")
      end_of_the_year = today.end_of_year.strftime("%Y-%m-%d")

      sql = "SELECT (final.overtime_credits"
      sql += " - IFNULL((SELECT SUM(8) FROM offsets AS ofc WHERE ofc.employee_id = #{payload['employee_id']}"
      sql += " AND (ofc.offset_date BETWEEN '#{start_of_the_year}' AND '#{end_of_the_year}')"
      sql += " AND ofc.status IN ('A','P') ), 0)) AS total"
      sql += " FROM ("
      sql += " SELECT SUM(TRUNCATE((TIMESTAMPDIFF("
      sql += " MINUTE, DATE_FORMAT(ov.start_date, '%Y-%m-%d %H:%i'), DATE_FORMAT(end_date, '%Y-%m-%d %H:%i'))/60),2)) AS overtime_credits"
      sql += " FROM overtimes ov"
      sql += " WHERE ov.employee_id = #{payload['employee_id']} AND ov.status = 'A' AND ov.billable = 0"
      sql += " AND (ov.start_date BETWEEN '#{start_of_the_year}' AND '#{end_of_the_year}')"
      sql += " ) final"
      return execute_sql_query(sql).first["total"] || "0.0"
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_offset
      @offset = Offset.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def offset_params
      params.require(:offset).permit(:offset_date, :reason)
    end
end
