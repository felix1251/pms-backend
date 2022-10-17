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
    sql_fields += " emp.first_name, emp.last_name, SUBSTR(emp.middle_name, 1, 1) AS middle_name, emp.suffix," if !params[:biometric_no].present?
    sql_fields += " IFNULL(emp.employee_id, '-----UNKNOWN-----') AS employee_id," if !params[:biometric_no].present?
    sql_fields += " CASE tk.record_type WHEN 1 THEN 'BIOMETRIC' WHEN 2 THEN 'CUSTOM' ELSE 'ERS' END AS record_type"
    sql_from = " FROM time_keepings AS tk"
    sql_join = " LEFT JOIN employees AS emp ON emp.biometric_no = tk.biometric_no"
    sql_condition = " WHERE tk.company_id = #{payload['company_id']} AND (tk.status = 0 OR tk.status = 1)"
    sql_condition += " AND tk.biometric_no = #{params[:biometric_no]}" if params[:biometric_no].present?
    sql_condition += " AND (tk.date BETWEEN '#{params["from"]}' AND '#{params["to"]}')" if params["from"].present? && params["to"].present?
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
    sql += " TRUNCATE(SUM(ABS(TIME_TO_SEC(TIMEDIFF(next_date, date)) / 3600)), 1) AS detailed_hours,"
    sql += " GROUP_CONCAT(DATE_FORMAT(date, '%Y-%m-%d %H:%i') ORDER BY date ASC) AS time_in, GROUP_CONCAT(DATE_FORMAT(next_date, '%Y-%m-%d %H:%i') ORDER BY date ASC) AS time_out,"
    sql += " GROUP_CONCAT(TRUNCATE(TIMESTAMPDIFF(minute,DATE_FORMAT(date, '%Y-%m-%d %H:%i'), DATE_FORMAT(next_date, '%Y-%m-%d %H:%i'))/60,1) ORDER BY date ASC) as in_out_hours" 
    sql += " FROM ("
    sql += " SELECT tk.*, CONCAT(e.first_name, ', ',e.middle_name, ' ', e.last_name, ' ', e.suffix) as fullname,"
    sql += " LEAD(tk.date) OVER () AS next_date,"
    sql += " LEAD(tk.status) OVER () AS next_status"
    sql += " FROM ("
    sql += " SELECT biometric_no, date, status, DATE(date) AS only_date" 
    sql += " FROM time_keepings as t"
    sql += " WHERE company_id = #{payload['company_id']} AND status = 0 OR status = 1"
    sql += " AND biometric_no = #{params[:biometric_no]}" if params[:biometric_no].present?
    sql += " and company_id = #{payload['company_id']}"
    sql += " and DATE(date) BETWEEN '#{params[:from]}' AND '#{params[:to]}'" if params[:from].present? && params[:to].present?
    sql += " ORDER BY biometric_no, date) tk"
    sql += " LEFT JOIN employees AS e ON tk.biometric_no = e.biometric_no )tk_filtered"
    sql += " WHERE status = 0 AND next_status = 1"
    sql += " GROUP BY biometric_no, fullname, only_date"
    sql += " LIMIT #{per_page} OFFSET #{records_fetch_point};"

    sql_count = "SELECT COUNT(*) as total_count"
    sql_count += " FROM ("
    sql_count += " SELECT biometric_no, only_date"
    sql_count += " FROM("
    sql_count += " SELECT tk.*, lead(tk.date) over () as next_date, lead(tk.status) over () as next_status"
    sql_count += " FROM ("
    sql_count += " SELECT biometric_no, date, status, DATE(date) as only_date" 
    sql_count += " from time_keepings as t"
    sql_count += " WHERE company_id = #{payload['company_id']} AND status = 0 OR status = 1"
    sql_count += " AND biometric_no = #{params[:biometric_no]}" if params[:biometric_no].present?
    sql_count += " AND DATE(date) BETWEEN '#{params[:from]}' AND '#{params[:to]}'" if params[:from].present? && params[:to].present?
    sql_count += " ORDER BY biometric_no, date"
    sql_count += " ) tk"
    sql_count += " )tk_filtered"
    sql_count += " WHERE status = 0 AND next_status = 1"
    sql_count += " GROUP BY biometric_no, only_date ) cnt;"

    records = execute_sql_query(sql)
    total_count = execute_sql_query(sql_count)
    render json: {time_records: records, total_count: total_count.first["total_count"]}
  end

  def time_keeping_calendar 
    if params[:mode].present? && params[:mode] == "month"
      sql = "SELECT SUM(detailed_hours) hours_monthly, only_date, YEAR(only_date) as year, MONTH(only_date) as month, DAY(only_date) as day"
      sql += " FROM ("
      sql += " SELECT only_date," 
      sql += " CASE WHEN SUM(ABS(TIME_TO_SEC(TIMEDIFF(next_date, date)) / 3600)) > 8" 
      sql += " THEN 8 ELSE TRUNCATE(SUM(ABS(TIME_TO_SEC(TIMEDIFF(next_date, date)) / 3600)), 0)" 
      sql += " END AS detailed_hours"
      sql += " FROM("
      sql += " SELECT tk.*,"
      sql += " lead(tk.date) over () as next_date,"
      sql += " lead(tk.status) over () as next_status"
      sql += " FROM ("
      sql += " SELECT biometric_no, date, status, DATE(date) as only_date" 
      sql += " from time_keepings as t"
      sql += " WHERE company_id = #{payload['company_id']} AND status = 0 OR status = 1"
      sql += " AND YEAR(date) = '#{params[:year]}' AND MONTH(date) = '#{params[:month]}'" if params[:year].present? && params[:month].present?
      sql += " order by biometric_no, date"
      sql += " ) tk"
      sql += " )tk_filtered"
      sql += " where status = 0 and next_status = 1"
      sql += " group by biometric_no, only_date"
      sql += " order by only_date"
      sql += " )final"
      sql += " group by only_date;"
      calendar = execute_sql_query(sql)
      render json: calendar
    elsif params[:mode].present? && params[:mode] == "year"
      #make query later
      render json: []
    else
      render json: []
    end
  end

  # GET /time_keepings/1
  def show
    render json: @time_keeping
  end

  # POST /time_keepings
  def create
    @time_keeping = TimeKeeping.new(time_keeping_params.merge!({record_type: 2, company_id: payload["company_id"], device_id: 0}))
    if @time_keeping.save
      render json: @time_keeping, status: :created
    else
      render json: @time_keeping.errors, status: :unprocessable_entity
    end
  end

  def bulk_create
    record = request.params[:time_list] || []
    if record && record.length > 0
      TimeKeepingWorker.perform_async(record, payload["company_id"])
      ActionCable.server.broadcast "time_keeping_#{payload["company_id"]}", { add_counts: record.length}
      render json: { message: "data processing" }, status: :created
    else
      render json: {error: "biometric data not valid or empty"}, status: :unprocessable_entity
    end
  end

  def time_keeping_counts
    sql = "SELECT"
    sql += " (SELECT COUNT(*) FROM time_keepings AS tk WHERE tk.company_id = com.id) AS succeeded,"
    sql += " (SELECT COUNT(*) FROM failed_time_keepings AS ftk WHERE ftk.company_id = com.id) AS rejected"
    sql += " FROM companies AS com"
    sql += " WHERE id = #{payload["company_id"]} LIMIT 1"

    company = Company.find(payload["company_id"])
    pid_list = company.worker_pid_list
    pending_count = 0

    pid_list.each do |jid|
      if queued = Sidekiq::Queue.new('default').find_job(jid)
        pending_count += queued.item["args"][0].size
      elsif workers = Sidekiq::Workers.new
        workers.each do |process_id, thread_id, work|
          pending_count += work["payload"]["args"][0].size if work["payload"]["jid"] = jid
          break if work["payload"]["jid"] = jid
        end
      elsif scheduled = Sidekiq::ScheduledSet.new.find_job(jid)
        pending_count += scheduled.item["args"][0].size
      elsif retried = Sidekiq::RetrySet.new.find_job(jid)
        pending_count += retried.item["args"][0].size
      else
        pending_count += 0
      end
    end

    counts = execute_sql_query(sql).first
    counts = counts.merge!({proccesed: counts["succeeded"] + counts["rejected"], pending: pending_count})
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
      params.require(:time_keeping).permit(:biometric_no, :date, :status)
    end
end
