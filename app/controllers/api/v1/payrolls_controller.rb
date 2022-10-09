class Api::V1::PayrollsController < PmsDesktopController
  before_action :authorize_access_request!
  before_action :check_backend_session
  before_action :set_payroll, only: [:show, :update, :destroy, :payroll_data]

  # GET /payrolls
  def index
    value = '"value"'
    label = '"label"'
    ats = '"'

    sql = "SELECT py.id, CONCAT(py.from, ' to ', py.to) as date_range, py.from, py.to, py.pay_date, py.status,"
    sql += " CASE WHEN py.require_approver = true THEN u.name ELSE 'none' END as approver,"
    sql += " (SELECT CONCAT('[',GROUP_CONCAT('{#{value}:',pa.id, ',#{label}:','#{ats}',pa.name,'#{ats}','}' ORDER BY pa.name SEPARATOR ','),']') FROM"
    sql += " (SELECT cac.id as id, cac.name  FROM payroll_accounts pa"
    sql += " LEFT JOIN company_accounts AS cac ON cac.id = pa.company_account_id"
    sql += " WHERE payroll_id = py.id)"
    sql += " AS pa) AS payroll_account_json" 
    sql += " FROM payrolls as py"
    sql += " LEFT JOIN users as u ON u.id = py.approver_id"
    sql += " WHERE py.company_id = #{payload['company_id']} and py.status != 'V'"
    sql += " ORDER BY py.from ASC"
  
    payrolls = execute_sql_query(sql)
    render json: payrolls
  end

  def approver_list
    sql = "SELECT"
    sql += " id as value, CONCAT(name, ' (',position,')') as label"
    sql += " FROM users"
    sql += " WHERE admin = true AND company_id = #{payload['company_id']} AND status = 'A'"
    approver = execute_sql_query(sql)
    render json: approver
  end

  def payroll_data
    sql_time_keeping_hours_sum = " COALESCE("
    sql_time_keeping_hours_sum += " (SELECT"
    sql_time_keeping_hours_sum += " CASE IFNULL(opc.work_sched_type, emp.work_sched_type) WHEN 'FL'"
    sql_time_keeping_hours_sum += " THEN SUM(COALESCE((SELECT SUM(TRUNCATE(TIMESTAMPDIFF(MINUTE, DATE_FORMAT(start_time, '%Y-%m-%d %H:%i'), DATE_FORMAT(end_time, '%Y-%m-%d %H:%i'))/60, 1))"
    sql_time_keeping_hours_sum += " FROM employee_schedules"
    sql_time_keeping_hours_sum += " WHERE employee_id = emp.id AND date(start_time) = only_date LIMIT 1), 1))"
    sql_time_keeping_hours_sum += " ELSE SUM(8) END"
    sql_time_keeping_hours_sum += " AS total_hours"
    sql_time_keeping_hours_sum += " FROM ("
    sql_time_keeping_hours_sum += " SELECT only_date"
    sql_time_keeping_hours_sum += " FROM ("
    sql_time_keeping_hours_sum += " SELECT id, date, status, biometric_no, DATE(date) AS only_date,"
    sql_time_keeping_hours_sum += " LEAD(date) OVER (ORDER BY biometric_no, date) AS next_date,"
    sql_time_keeping_hours_sum += " LEAD(status) OVER (ORDER BY biometric_no, date) AS next_status"
    sql_time_keeping_hours_sum += " FROM time_keepings"
    sql_time_keeping_hours_sum += " WHERE biometric_no = emp.biometric_no AND company_id = #{payload['company_id']} AND"
    sql_time_keeping_hours_sum += " DATE(date) BETWEEN '#{@payroll.from}' AND '#{@payroll.to}' AND (status = 0 OR status = 1)"
    sql_time_keeping_hours_sum += " ) from_bio"
    sql_time_keeping_hours_sum += " WHERE status = 0 and next_status = 1"
    sql_time_keeping_hours_sum += " GROUP BY only_date"
    sql_time_keeping_hours_sum += " ) fixed_hours)"
    sql_time_keeping_hours_sum += " , 0) total_hours_earned"

    sql_time_undertime_sum = " COALESCE("
    sql_time_undertime_sum += " (SELECT SUM(IF(hours_in_date - expected_hours > 0 , 0 , (hours_in_date - expected_hours)*-1)) AS undertime"
    sql_time_undertime_sum += " FROM ("
    sql_time_undertime_sum += " SELECT *,"
    sql_time_undertime_sum += " CASE IFNULL(opc.work_sched_type, emp.work_sched_type) WHEN 'FL'"
    sql_time_undertime_sum += " THEN (SELECT TIMESTAMPDIFF(MINUTE, DATE_FORMAT(start_time, '%Y-%m-%d %H:%i'), DATE_FORMAT(end_time, '%Y-%m-%d %H:%i'))"
    sql_time_undertime_sum += " FROM employee_schedules WHERE employee_id = emp.id AND DATE(start_time) = only_date LIMIT 1)"
    sql_time_undertime_sum += " ELSE 8*60 END"
    sql_time_undertime_sum += " AS expected_hours"
    sql_time_undertime_sum += " FROM ("
    sql_time_undertime_sum += " SELECT only_date,"
    sql_time_undertime_sum += " COALESCE(CASE IFNULL(opc.work_sched_type, emp.work_sched_type) WHEN 'FL' THEN"
    sql_time_undertime_sum += " SUM(TIMESTAMPDIFF(MINUTE,"
    sql_time_undertime_sum += " IF(date > (SELECT start_time FROM employee_schedules WHERE DATE(start_time) = only_date LIMIT 1), DATE_FORMAT(date, '%Y-%m-%d %H:%i'), (SELECT start_time FROM employee_schedules WHERE DATE(start_time) = only_date LIMIT 1)),"
    sql_time_undertime_sum += " IF(next_date < (SELECT end_time FROM employee_schedules WHERE DATE(start_time) = only_date LIMIT 1), DATE_FORMAT(next_date, '%Y-%m-%d %H:%i'), (SELECT end_time FROM employee_schedules WHERE DATE(start_time) = only_date LIMIT 1))"
    sql_time_undertime_sum += " ))"
    sql_time_undertime_sum += " ELSE"
    sql_time_undertime_sum += " SUM(TIMESTAMPDIFF(MINUTE,"
    sql_time_undertime_sum += " IF(date > CONCAT(only_date,' ',emp.work_sched_start), DATE_FORMAT(date, '%Y-%m-%d %H:%i'), CONCAT(only_date,' ',emp.work_sched_start)),"
    sql_time_undertime_sum += " IF(next_date < CONCAT(only_date,' ',emp.work_sched_end), DATE_FORMAT(next_date, '%Y-%m-%d %H:%i'), CONCAT(only_date,' ',emp.work_sched_end))"
    sql_time_undertime_sum += " ) - IF(CONCAT(only_date,' 11:00') AND CONCAT(only_date,' 12:00') BETWEEN date AND next_date, 60, 0))"
    sql_time_undertime_sum += " END, 0) AS hours_in_date"
    sql_time_undertime_sum += " FROM ("
    sql_time_undertime_sum += " SELECT id, date, status, biometric_no, DATE(date) AS only_date,"
    sql_time_undertime_sum += " LEAD(date) OVER (ORDER BY biometric_no, date) AS next_date,"
    sql_time_undertime_sum += " LEAD(status) OVER (ORDER BY biometric_no, date) AS next_status"
    sql_time_undertime_sum += " FROM time_keepings"
    sql_time_undertime_sum += " WHERE biometric_no = emp.biometric_no AND"
    sql_time_undertime_sum += " DATE(date) BETWEEN '#{@payroll.from}' AND '#{@payroll.to}'"
    sql_time_undertime_sum += " AND (status = 0 OR status = 1) AND company_id = #{payload['company_id']}"
    sql_time_undertime_sum += " ) from_bio"
    sql_time_undertime_sum += " WHERE status = 0 and next_status = 1"
    sql_time_undertime_sum += " GROUP BY only_date"
    sql_time_undertime_sum += " ) fixed_hours"
    sql_time_undertime_sum += " ) final)"
    sql_time_undertime_sum += " , 0) as undertime_minutes,"

    sql_payed_leave_hours_sum = " COALESCE((SELECT "
    sql_payed_leave_hours_sum += " SUM((CASE le.half_day WHEN 0 " 
    sql_payed_leave_hours_sum += " THEN (DATEDIFF("
    sql_payed_leave_hours_sum += " CASE WHEN le.end_date > '#{@payroll.to}' THEN '#{@payroll.to}' ELSE le.end_date  END,"
    sql_payed_leave_hours_sum += " CASE WHEN le.start_date < '#{@payroll.from}' THEN '#{@payroll.from}' ELSE le.start_date END) + 1) ELSE 0.5 END)*8)"
    sql_payed_leave_hours_sum += " FROM leaves le"
    sql_payed_leave_hours_sum += " LEFT JOIN type_of_leaves as tol ON tol.id = le.leave_type"
    sql_payed_leave_hours_sum += " WHERE tol.with_pay = 1 and le.status = 'A' and le.employee_id = emp.id"
    sql_payed_leave_hours_sum += " AND (le.start_date BETWEEN '#{@payroll.from}' AND '#{@payroll.to}' OR le.end_date BETWEEN '#{@payroll.from}' AND '#{@payroll.to}')"
    sql_payed_leave_hours_sum += " GROUP BY employee_id"
    sql_payed_leave_hours_sum += " ), 0) AS total_payed_leave_hours,"
    
    sql_payed_ob_hours_sum = " COALESCE((SELECT"
		sql_payed_ob_hours_sum += " SUM((DATEDIFF(CASE WHEN ob.end_date > '#{@payroll.to}' THEN  '#{@payroll.to}' ELSE ob.end_date END,"
    sql_payed_ob_hours_sum += " CASE WHEN ob.start_date < '#{@payroll.from}' THEN '#{@payroll.from}' ELSE  ob.start_date  END) + 1)*8)"
		sql_payed_ob_hours_sum += " FROM official_businesses ob"
		sql_payed_ob_hours_sum += " WHERE ob.status = 'A' and ob.employee_id = emp.id"
		sql_payed_ob_hours_sum += " AND (ob.start_date BETWEEN '#{@payroll.from}' AND '#{@payroll.to}' OR ob.end_date BETWEEN '#{@payroll.from}' AND '#{@payroll.to}')"
		sql_payed_ob_hours_sum += " GROUP BY ob.employee_id"
		sql_payed_ob_hours_sum += " ), 0.0) AS total_payed_ob_hours,"

    sql_payed_overtime_hours_sum = " COALESCE((SELECT "
    sql_payed_overtime_hours_sum += " SUM(TIMESTAMPDIFF(HOUR, CASE WHEN DATE(ov.end_date) > '#{@payroll.to}' THEN DATE_FORMAT('#{@payroll.to}', '%Y-%m-%d %H:%i')"
    sql_payed_overtime_hours_sum += " ELSE DATE_FORMAT(ov.start_date, '%Y-%m-%d %H:%i') END,"
		sql_payed_overtime_hours_sum += " CASE WHEN DATE(ov.start_date) < '#{@payroll.from}' THEN DATE_FORMAT('#{@payroll.from}', '%Y-%m-%d %H:%i') ELSE  DATE_FORMAT(ov.end_date, '%Y-%m-%d %H:%i') END))"
		sql_payed_overtime_hours_sum += " FROM overtimes ov"
		sql_payed_overtime_hours_sum += " WHERE ov.status = 'A' AND ov.employee_id = emp.id AND ov.billable = 1 AND ov.offset_id IS NULL"
		sql_payed_overtime_hours_sum += " AND (DATE(ov.start_date) BETWEEN '#{@payroll.from}' AND '#{@payroll.to}' OR DATE(ov.end_date) BETWEEN '#{@payroll.from}' AND '#{@payroll.to}')"
    sql_payed_overtime_hours_sum += " GROUP BY ov.employee_id"
    sql_payed_overtime_hours_sum += " ), 0.0) total_payed_overtime_hours,"

    sql_payed_offset_hours_sum = " COALESCE((SELECT" 
		sql_payed_offset_hours_sum += " SUM((SELECT COALESCE(IF(SUM(TIMESTAMPDIFF(HOUR, DATE_FORMAT(start_date, '%Y-%m-%d %H:%i'),"
		sql_payed_offset_hours_sum += " DATE_FORMAT(end_date, '%Y-%m-%d %H:%i'))) >= 8 , 8, 0), 0) FROM overtimes WHERE status = 'A' AND offset_id = ofs.id))"
		sql_payed_offset_hours_sum += " FROM offsets as ofs"
    sql_payed_offset_hours_sum += " WHERE ofs.status = 'A' AND ofs.employee_id = emp.id AND ofs.offset_date BETWEEN '#{@payroll.from}' AND '#{@payroll.to}'"
		sql_payed_offset_hours_sum += " ), 0.0) AS total_payed_offset_hours,"

    sql_employee = "SELECT CONCAT(emp.last_name, ', ', first_name, ' ', CASE WHEN emp.suffix = '' THEN '' ELSE CONCAT(emp.suffix, '.') END,' '," 
    sql_employee += "CASE emp.middle_name WHEN '' THEN '' ELSE CONCAT(SUBSTR(emp.middle_name, 1, 1), '.') END) AS fullname," 
    sql_employee += " pos.name AS position, sm.description AS salary_mode, IFNULL(opc.salary_mode_id, emp.salary_mode_id) AS salary_id, emp.employee_id,"
    sql_employee += " dep.name AS department_name, emp.id,"
    sql_employee += " COALESCE(opc.compensation, emp.compensation) AS rate,"
    sql_employee += sql_payed_offset_hours_sum
    sql_employee += sql_payed_leave_hours_sum
    sql_employee += sql_payed_ob_hours_sum
    sql_employee += sql_payed_overtime_hours_sum
    sql_employee += sql_time_undertime_sum
    sql_employee += sql_time_keeping_hours_sum
    sql_employee += " FROM employees AS emp"
    sql_employee += " LEFT JOIN on_payroll_compensations AS opc ON opc.employee_id = emp.id AND opc.payroll_id = #{@payroll.id}"
    sql_employee += " LEFT JOIN positions AS pos ON pos.id = IFNULL(opc.position_id, emp.position_id)"
    sql_employee += " LEFT JOIN salary_modes AS sm ON sm.id = IFNULL(opc.salary_mode_id, emp.salary_mode_id)"
    sql_employee += " LEFT JOIN departments AS dep ON dep.id = IFNULL(opc.department_id, emp.department_id)"
    sql_employee += " WHERE (emp.status = 'A' OR (SELECT COUNT(*) FROM time_keepings WHERE biometric_no = emp.biometric_no AND DATE(date) BETWEEN '#{@payroll.from}' AND '#{@payroll.to}') > 0)"
    sql_employee += " AND emp.company_id = #{payload['company_id']}"
    sql_employee += " AND '#{@payroll.to}' >= DATE(emp.date_hired)"
    sql_employee += " AND (opc.company_account_id = #{params[:company_account_id]}" if params[:company_account_id].present?
    sql_employee += " OR emp.company_account_id = #{params[:company_account_id]})" if params[:company_account_id].present?
    sql_employee += " ORDER BY fullname"

    sql_gather_fields = " SELECT"
    sql_gather_fields += " emp_data.*,"
    sql_gather_fields += " CASE salary_id"
    sql_gather_fields += " WHEN 2 THEN CONCAT(emp_data.total_hours_earned, ' hours')"
    sql_gather_fields += " ELSE CONCAT(TRUNCATE((emp_data.total_hours_earned/8), 1), ' days')"
    sql_gather_fields += " END AS total_time,"
    sql_gather_fields += " TRUNCATE(CASE salary_id"
    sql_gather_fields += " WHEN 3 THEN emp_data.rate/8"
    sql_gather_fields += " WHEN 2 THEN emp_data.rate"
    sql_gather_fields += " ELSE (emp_data.rate/26)"
    sql_gather_fields += " END, 2) AS daily_rate,"
    sql_gather_fields += " TRUNCATE(CASE salary_id"
    sql_gather_fields += " WHEN 3 THEN ((emp_data.rate/8) * TRUNCATE((emp_data.total_hours_earned), 1))"
    sql_gather_fields += " WHEN 2 THEN (emp_data.rate * TRUNCATE((emp_data.total_hours_earned), 1))"
    sql_gather_fields += " ELSE (((emp_data.rate/26)/8) * TRUNCATE((emp_data.total_hours_earned), 1) + IF((emp_data.total_hours_earned/8) > 2, (emp_data.rate/26) * 2, 0))"
    sql_gather_fields += " END, 2) AS payed_hours_amount,"
    sql_gather_fields += " TRUNCATE(CASE salary_id"
    sql_gather_fields += " WHEN 3 THEN ((emp_data.rate/8) * TRUNCATE((emp_data.total_payed_overtime_hours), 2))"
    sql_gather_fields += " WHEN 2 THEN (emp_data.rate * TRUNCATE((emp_data.total_payed_overtime_hours), 2))"
    sql_gather_fields += " ELSE (((emp_data.rate/26)/8) * TRUNCATE((emp_data.total_payed_overtime_hours), 2))"
    sql_gather_fields += " END, 2) AS payed_overtime_amount,"
    sql_gather_fields += " TRUNCATE(CASE salary_id"
    sql_gather_fields += " WHEN 3 THEN ((emp_data.rate/8) * TRUNCATE((emp_data.total_payed_offset_hours), 1))"
    sql_gather_fields += " WHEN 2 THEN (emp_data.rate * TRUNCATE((emp_data.total_payed_offset_hours), 1))"
    sql_gather_fields += " ELSE (((emp_data.rate/26)/8) * TRUNCATE((emp_data.total_payed_offset_hours), 1))"
    sql_gather_fields += " END, 2) AS payed_offset_amount,"
    sql_gather_fields += " TRUNCATE(CASE salary_id"
    sql_gather_fields += " WHEN 3 THEN ((emp_data.rate/8) * TRUNCATE((emp_data.total_payed_leave_hours), 1))"
    sql_gather_fields += " WHEN 2 THEN (emp_data.rate * TRUNCATE((emp_data.total_payed_leave_hours), 1))"
    sql_gather_fields += " ELSE (((emp_data.rate/26)/8) * TRUNCATE((emp_data.total_payed_leave_hours), 1))"
    sql_gather_fields += " END, 2) AS payed_leave_amount,"
    sql_gather_fields += " TRUNCATE(CASE salary_id"
    sql_gather_fields += " WHEN 3 THEN ((emp_data.rate/8)* TRUNCATE((emp_data.total_payed_ob_hours), 1))"
    sql_gather_fields += " WHEN 2 THEN (emp_data.rate * TRUNCATE((emp_data.total_payed_ob_hours), 1))"
    sql_gather_fields += " ELSE (((emp_data.rate/26)/8) * TRUNCATE((emp_data.total_payed_ob_hours), 1))"
    sql_gather_fields += " END, 2) AS payed_ob_amount,"
    sql_gather_fields += " TRUNCATE(CASE salary_id"
    sql_gather_fields += " WHEN 3 THEN (((emp_data.rate/8)/60) * emp_data.undertime_minutes)"
    sql_gather_fields += " WHEN 2 THEN ((emp_data.rate/60) * emp_data.undertime_minutes)"
    sql_gather_fields += " ELSE ((((emp_data.rate/26)/8)/60) * emp_data.undertime_minutes)"
    sql_gather_fields += " END, 2) AS undertime_amount,"
    sql_gather_fields += " (SELECT"
    sql_gather_fields += " IFNULL(SUM(IF(type_of_holiday = 'S', TRUNCATE((CASE salary_id WHEN 3 THEN emp_data.rate WHEN 2 THEN emp_data.rate*8 ELSE (emp_data.rate/26) END)*0.30, 2), 0)), 0)"
    sql_gather_fields += " from holidays WHERE type_of_holiday = 'S' AND (date BETWEEN '#{@payroll.from}' AND '#{@payroll.to}')"
    sql_gather_fields += " ) AS payed_special_holiday,"
    sql_gather_fields += " (SELECT"
    sql_gather_fields += " IFNULL(SUM(IF(type_of_holiday = 'R', TRUNCATE(CASE salary_id WHEN 3 THEN emp_data.rate WHEN 2 THEN emp_data.rate*8 ELSE (emp_data.rate/26) END, 2), 0)), 0)"
    sql_gather_fields += " from holidays WHERE type_of_holiday = 'R' AND (date BETWEEN '#{@payroll.from}' AND '#{@payroll.to}')"
    sql_gather_fields += " ) AS payed_regular_holiday"
    sql_gather_fields += " FROM ("
    sql_gather_fields += sql_employee
    sql_gather_fields += " ) emp_data"

    sql_total = "SELECT"
    sql_total += " with_total.*, ((payed_hours_amount - undertime_amount) + payed_leave_amount + payed_ob_amount + payed_offset_amount) AS total_regular_pay,"
    sql_total += " (payed_overtime_amount + payed_regular_holiday + payed_special_holiday) AS premium_pay_total,"
    sql_total += " ((payed_hours_amount - undertime_amount) + payed_leave_amount + payed_ob_amount + payed_overtime_amount + payed_regular_holiday + payed_special_holiday) AS gross_pay,"
    sql_total += " ((payed_hours_amount - undertime_amount) + payed_leave_amount + payed_ob_amount + payed_overtime_amount + payed_regular_holiday + payed_special_holiday) AS net_pay"
    sql_total += " from ("
    sql_total += sql_gather_fields
    sql_total += " ) with_total;"

    payroll = execute_sql_query(sql_total)
    render json: payroll
  end

  # GET /payrolls/1
  def show
    render json: @payroll
  end

  def payroll_details
    value = '"value"'
    label = '"label"'
    ats = '"'
    sql = "SELECT *, CONCAT('[{#{value}:',py.approver_id,',#{label}:','#{ats}',usr.name,' (',usr.position,')','#{ats}','}]') AS approver,"
    sql += " (SELECT CONCAT('[',GROUP_CONCAT('{#{value}:',pa.id, ',#{label}:','#{ats}',pa.name,'#{ats}','}' ORDER BY pa.name SEPARATOR ','),']') FROM"
    sql += " (SELECT cac.id as id, cac.name FROM payroll_accounts pa"
    sql += " LEFT JOIN company_accounts AS cac ON cac.id = pa.company_account_id"
    sql += " WHERE payroll_id = py.id ORDER BY cac.name ASC)"
    sql += " AS pa) AS payroll_account_json"
    sql += " FROM payrolls AS py"
    sql += " LEFT JOIN users as usr ON usr.id = py.approver_id"
    sql += " WHERE py.id = #{params[:id]}"
    sql += " LIMIT 1;"
    execute_sql_query("SET SESSION group_concat_max_len = 10000;")
    details = execute_sql_query(sql).first
    render json: details
  end

  # POST /payrolls
  def create
    @payroll = Payroll.new(payroll_params.merge!({company_id: payload["company_id"]}))
    if @payroll.save
      store = []
      request.params[:payroll][:company_account_ids].each { |id| store.push({company_account_id: id})}
      @payroll.payroll_accounts.create(store) if store.length > 0
      OnPayrollCompensationWorker.perform_async(@payroll.id, payload["company_id"])
      render json: @payroll, status: :created
    else
      render json: @payroll.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /payrolls/1
  def update
    if @payroll.update(payroll_params)
      store = []
      param_ids = request.params[:payroll][:company_account_ids]
      param_ids.each {|id| store.push({company_account_id: id})}
      if @payroll.payroll_accounts.create(store)
        remove_ids = @payroll.payroll_accounts.pluck(:company_account_id) - param_ids
        @payroll.payroll_accounts.where(company_account_id: remove_ids).delete_all if remove_ids.length > 0
      end
      render json: @payroll
    else
      render json: @payroll.errors, status: :unprocessable_entity
    end
  end

  # DELETE /payrolls/1
  def destroy
    @payroll.destroy
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
      when 'create'
        ['PA']
      when 'update'
        ['PE']
      when 'destroy'
        ['PD']
      else
        ['PV']
      end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_payroll
      @payroll = Payroll.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def payroll_params
      params.require(:payroll).permit(:from, :to, :approver_id, :require_approver, :remarks, :pay_date)
    end
end
