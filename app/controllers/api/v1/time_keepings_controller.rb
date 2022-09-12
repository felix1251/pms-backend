class Api::V1::TimeKeepingsController < PmsDesktopController
  before_action :authorize_access_request!
  before_action :check_backend_session
  before_action :set_time_keeping, only: [:show, :update, :destroy]

  # GET /time_keepings
  def index
    max = 35
    current_page = params[:page].to_i || 1
    per_page = params[:per_page].to_i || max
    per_page = max unless per_page <= max
    records_fetch_point = (current_page - 1) * per_page

    sql_start = "SELECT"
    sql_count = " COUNT(*) AS total_count"
    sql_fields = " tk.id, tk.biometric_no, tk.verified,tk.status, tk.date, tk.work_code, tk.device_id,"
    sql_fields += " emp.first_name, emp.last_name, SUBSTR(emp.middle_name, 1, 1) AS middle_name, emp.suffix,"
    sql_fields += " CASE WHEN tk.record_type = 1 THEN 'BIOMETRIC' ELSE 'ERS' END AS record_type,"
    sql_fields += " IFNULL(emp.employee_id, '-------------------') AS employee_id"
    sql_from = " FROM time_keepings AS tk"
    sql_join = " LEFT JOIN employees AS emp ON emp.biometric_no = tk.biometric_no"
    sql_condition = " WHERE tk.company_id = #{payload['company_id']}"
    sql_sort = " ORDER BY tk.date ASC"
    sql_paginate = " LIMIT #{per_page} OFFSET #{records_fetch_point};"

    time_keepings = execute_sql_query(sql_start + sql_fields + sql_from + sql_join + sql_condition + sql_sort + sql_paginate)
    time_keeping_count = execute_sql_query(sql_start + sql_count + sql_from + sql_condition)

    render json: {time_keeping: time_keepings, total_count: time_keeping_count.first["total_count"]}
  end

  def time_records
    max = 30
    current_page = params[:page].to_i || 1
    per_page = params[:per_page].to_i || max
    per_page = max unless per_page <= max
    records_fetch_point = (current_page - 1) * per_page

    sql = "SELECT tk_filtered.biometric_no, COAlESCE(tk_filtered.fullname, 'UNSPECIFIED') AS fullname, tk_filtered.only_date,"
    sql += " TRUNCATE(SUM(ABS(TIME_TO_SEC(TIMEDIFF(next_date, date)) / 3600)), 2) AS detailed_hours,"
    sql += " GROUP_CONCAT(date) AS time_in, GROUP_CONCAT(next_date) AS time_out,"
    sql += " GROUP_CONCAT(ABS(TIME_TO_SEC(TIMEDIFF(next_date, date)) / 3600)) as in_out_hours" 
    sql += " FROM ("
    sql += " SELECT tk.*, CONCAT(e.first_name, ', ',e.middle_name, ' ', e.last_name, ' ', e.suffix) as fullname,"
    sql += " LEAD(tk.date) OVER () AS next_date,"
    sql += " LEAD(tk.status) OVER () AS next_status"
    sql += " FROM ("
    sql += " SELECT biometric_no, date, status, DATE(date) AS only_date" 
    sql += " FROM time_keepings as t"
    sql += " WHERE biometric_no = #{params[:biometric_no]}"
    sql += " ORDER BY biometric_no, date) tk"
    sql += " LEFT JOIN employees AS e ON tk.biometric_no = e.biometric_no )tk_filtered"
    sql += " WHERE status = 0 AND next_status = 1"
    sql += " GROUP BY biometric_no, fullname, only_date"
    sql += " ORDER BY only_date"
    sql += " LIMIT #{per_page} OFFSET #{records_fetch_point};"

    records = execute_sql_query(sql)
    render json: {time_records: records}
  end

  # GET /time_keepings/1
  def show
    render json: @time_keeping
  end

  # POST /time_keepings
  def create
    @time_keeping = TimeKeeping.new(time_keeping_params)
    if @time_keeping.save
      render json: @time_keeping, status: :created
    else
      render json: @time_keeping.errors, status: :unprocessable_entity
    end
  end

  def bulk_create
    record = request.params[:time_list] || []
    if record && record.length > 0
      company = Company.find(payload["company_id"])
      if company.update(pending_time_keeping: company.pending_time_keeping + record.length)
        ActionCable.server.broadcast "time_keeping_#{payload["company_id"]}", { pending: company.pending_time_keeping }
        TimeKeepingWorker.perform_async(record, payload["company_id"])
        render json: { message: "data processing" }, status: :created
      else
        render json: {error: "failed to update pending or company not exist"}, status: :unprocessable_entity
      end
    else
      render json: {error: "biometric data not valid or empty"}, status: :unprocessable_entity
    end
  end

  def time_keeping_counts
    sql = "SELECT"
    sql += " com.pending_time_keeping AS pending,"
    sql += " (SELECT COUNT(*) FROM time_keepings AS tk WHERE tk.company_id = com.id) AS succeeded,"
    sql += " (SELECT COUNT(*) FROM failed_time_keepings AS ftk WHERE ftk.company_id = com.id) AS rejected"
    sql += " FROM companies AS com"
    sql += " WHERE id = #{payload["company_id"]} LIMIT 1"

    counts = execute_sql_query(sql).first
    counts = counts.merge!({proccesed: counts["succeeded"] + counts["rejected"]})
    render json: counts
  end

  # PATCH/PUT /time_keepings/1
  def update
    if @time_keeping.update(time_keeping_params)
      render json: @time_keeping
    else
      render json: @time_keeping.errors, status: :unprocessable_entity
    end
  end

  # DELETE /time_keepings/1
  def destroy
    @time_keeping.destroy
  end

  def token_claims
    {
      aud: allowed_aud,
      verify_aud: true
    }
  end

  private
  
    def allowed_aud
      case action_name 
      when 'create', 'bulk_create'
        ['TA']
      when 'update'
        ['TE']
      when 'destroy'
        ['TD']
      else
        ['TV']
      end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_time_keeping
      @time_keeping = TimeKeeping.find(params[:id])
    end

    def bulk_allow_params
      params.permit(time_list: [])
    end

    # Only allow a trusted parameter "white list" through.
    def time_keeping_params
      params.require(:time_keeping).permit(:biomectric_no, :date, :status, :verified, :work_code, :record_type)
    end
end
