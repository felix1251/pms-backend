class Api::V2::LeavesController < PmsErsController
  before_action :authorize_access_request!
  before_action :set_leave, only: [:show, :update, :destroy]
  before_action :check_status, only: [:update, :destroy]

  # GET /leaves
  def index
    pagination = custom_pagination(params[:page].to_i, params[:per_page].to_i)
    sql_start = "SELECT"
    sql_count = " COUNT(*) AS total_count"
    sql_fields = " CASE WHEN le.end_date = le.start_date THEN DATE_FORMAT(le.end_date, '%b %d, %Y')"
    sql_fields += " ELSE CONCAT(DATE_FORMAT(le.start_date, '%b %d, %Y'),' - ',DATE_FORMAT(le.end_date, '%b %d, %Y'))" 
    sql_fields += " END AS inclusive_date, le.id, DATE_FORMAT(le.created_at, '%b %d, %Y %h:%i %p') AS date_filed,"
    sql_fields += " tol.name as type, reason, le.status, tol.with_pay,"
    sql_fields += " (CASE le.half_day WHEN 0 THEN (DATEDIFF(le.end_date, le.start_date) + 1) ELSE 0.5 END) AS days"
    sql_from = " FROM leaves as le"
    sql_join = " LEFT JOIN type_of_leaves AS tol ON tol.id = le.leave_type"
    sql_join += " LEFT JOIN employees as emp ON emp.id = le.employee_id"
    sql_condition = " WHERE le.employee_id = #{payload['employee_id']}"
    sql_sort = " ORDER BY le.created_at DESC"
    sql_paginate = " LIMIT #{pagination[:per_page]} OFFSET #{pagination[:fetch_point]}"

    leaves = execute_sql_query(sql_start + sql_fields + sql_from + sql_join + sql_condition + sql_sort + sql_paginate)
    count = execute_sql_query(sql_start + sql_count + sql_from + sql_condition)

    render json: {data: leaves, total_count: count.first["total_count"]}
  end

  # GET /leaves/1
  def show
    render json: @leave
  end

  def leave_credits_total
    com = Company.select(:max_vacation_leave_credit, :max_sick_leave_credit).find(payload["company_id"])

    vac_leave_credits = leave_credits("VLWP", nil).to_d
    sick_leave_credits = leave_credits("SLWP", nil).to_d
    others = leave_credits(nil, ["VLWP","SLWP"]).to_d

    render json: {
          max_vacation_leave_credits: com.max_vacation_leave_credit, 
          max_sick_leave_credits: com.max_sick_leave_credit, 
          employee_current_vacation_leave_credits: vac_leave_credits,
          employee_current_sick_leave_credits: sick_leave_credits,
          others: others,
        }
  end

  # POST /leaves
  def create
    @leave = Leave.new(leave_params.merge!({company_id: payload["company_id"], employee_id: payload['employee_id'], origin: 1}))
    if @leave.save
      render json: @leave, status: :created
    else
      render json: @leave.errors, status: :unprocessable_entity
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
    if @leave.update(status: "V")
      render json: {message: "Leave Voided"}
    else
      render json: @leave.errors, status: :unprocessable_entity
    end
  end

  private

    def leave_credits(code, arr)
      today = Date.today
      start_of_the_year = today.beginning_of_year.strftime("%Y-%m-%d")
      end_of_the_year = today.end_of_year.strftime("%Y-%m-%d")

      if code
        tol = TypeOfLeave.find_by!(code: code) 
      else
        tol_arr = TypeOfLeave.where.not(code: arr).pluck("id")
      end

      sql = "SELECT"
      sql += " SUM(CASE le.half_day WHEN 0 THEN (DATEDIFF(le.end_date, le.start_date) + 1) ELSE 0.5 END) AS days"
      sql += " FROM leaves AS le"
      sql += " WHERE le.employee_id = #{payload["employee_id"]}"

      if code 
        sql += " AND le.leave_type = #{tol.id} AND le.status IN ('A', 'P')"
      else
        sql += " AND le.leave_type IN (#{tol_arr.join(',')}) AND le.status = 'A'"
      end

      sql += " AND (le.start_date BETWEEN '#{start_of_the_year}' AND '#{end_of_the_year}')"

      return execute_sql_query(sql).first["days"] || "0.0"
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_leave
      @leave = Leave.find(params[:id])
    end

    def check_status
      if @leave.status != "P"
        render json: {error: "Cant't update leave"}, status: :unprocessable_entity
      end
    end

    # Only allow a trusted parameter "white list" through.
    def leave_params
      params.require(:leave).permit(:start_date, :end_date, :leave_type, :reason, :half_day)
    end
end
