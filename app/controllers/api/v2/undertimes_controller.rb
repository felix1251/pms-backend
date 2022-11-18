class Api::V2::UndertimesController < PmsErsController
  before_action :authorize_access_request!
  before_action :set_undertime, only: [:show, :update, :destroy]

  # GET /undertimes
  def index
    pagination = custom_pagination(params[:page].to_i, params[:per_page].to_i)

    sql_start = "SELECT"
    sql_count = " COUNT(*) AS total_count"
    sql_fields = " und.id, und.status, DATE_FORMAT(und.created_at, '%b %d, %Y %h:%i %p') AS date_filed, und.reason,"
    sql_fields += " TRUNCATE(TIMESTAMPDIFF(MINUTE, DATE_FORMAT(und.start_time, '%Y-%m-%d %H:%i'), DATE_FORMAT(und.end_time, '%Y-%m-%d %H:%i'))/60, 2) AS hours,"
    sql_fields += " CONCAT(DATE_FORMAT(und.start_time, '%b %d, %Y %h:%i %p'),' - ',DATE_FORMAT(und.end_time, '%b %d, %Y %h:%i %p')) AS datetime"
    sql_from = " FROM undertimes AS und"
    sql_condition = " WHERE und.employee_id = #{payload['employee_id']}"
    sql_sort = " ORDER BY und.created_at DESC"
    sql_paginate = " LIMIT #{pagination[:per_page]} OFFSET #{pagination[:fetch_point]}"

    undertimes = execute_sql_query(sql_start + sql_fields + sql_from + sql_condition + sql_sort + sql_paginate)
    count = execute_sql_query(sql_start + sql_count + sql_from + sql_condition)
    render json: {data: undertimes, total_count: count.first["total_count"]}
  end

  # GET /undertimes/1
  def show
    render json: @undertime
  end

  # POST /undertimes
  def create
    @undertime = Undertime.new(undertime_params.merge!({company_id: payload["company_id"], employee_id: payload['employee_id'], origin: 1}))
    if @undertime.save
      render json: @undertime, status: :created
    else
      render json: @undertime.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /undertimes/1

  def update
    if @undertime.status == "P" && @undertime.update(undertime_params)
      render json: @overtime
    else
      if @undertime.status != "P"
        render json: {error: "Cant't update undertime"}, status: :unprocessable_entity
      else
        render json: @undertime.errors, status: :unprocessable_entity
      end
    end
  end

  # DELETE /undertimes/1

  def destroy
    if @undertime.status == "P" && @undertime.update(status: "V")
      render json: {message: "Overtime voided"}
    else
      if @undertime.status != "P"
        render json: {error: "Cant't void undertime"}, status: :unprocessable_entity
      else
        render json: @undertime.errors, status: :unprocessable_entity
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_undertime
      @undertime = Undertime.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def undertime_params
      params.require(:undertime).permit(:start_time, :end_time, :reason)
    end
end
