class Api::V2::OvertimesController < PmsErsController
  before_action :authorize_access_request!
  before_action :set_overtime, only: [:show, :update, :destroy]

  # GET /overtimes
  def index
    pagination = custom_pagination(params[:page].to_i, params[:per_page].to_i)

    sql_start = "SELECT"
    sql_count = " COUNT(*) AS total_count"
    sql_fields = " CONCAT(DATE_FORMAT(ov.start_date, '%b %d, %Y %h:%i %p'),' - ',DATE_FORMAT(ov.end_date, '%b %d, %Y %h:%i %p')) AS datetime, DATE_FORMAT(ov.created_at, '%b %d, %Y %h:%i %p') AS date_filed,"
    sql_fields += " ov.output, ov.status, ov.id, ov.billable,"
    sql_fields += " TIMESTAMPDIFF(HOUR, DATE_FORMAT(ov.start_date, '%Y-%m-%d %H:%i'), DATE_FORMAT(ov.end_date, '%Y-%m-%d %H:%i')) AS hours"
    sql_from = " FROM overtimes as ov"
    sql_condition = " WHERE ov.employee_id = #{payload['employee_id']}"
    sql_sort = " ORDER BY ov.created_at DESC"
    sql_paginate = " LIMIT #{pagination[:per_page]} OFFSET #{pagination[:fetch_point]}"

    overtimes = execute_sql_query(sql_start + sql_fields + sql_from + sql_condition + sql_sort + sql_paginate)
    count = execute_sql_query(sql_start + sql_count + sql_from + sql_condition)
    render json: {data: overtimes, total_count: count.first["total_count"]}
  end

  # GET /overtimes/1
  def show
    render json: @overtime
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
    if @overtime.update(action_params.merge!({employee_id: payload['employee_id']}))
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

    # Only allow a trusted parameter "white list" through.
    def overtime_params
      params.require(:overtime).permit(:output, :start_date, :end_date, :billable)
    end
end
