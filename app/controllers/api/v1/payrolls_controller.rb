class Api::V1::PayrollsController < PmsDesktopController
  before_action :authorize_access_request!
  before_action :check_backend_session
  before_action :set_payroll, only: [:show, :update, :destroy, :payroll_data, :daily_time_records]

  # GET /payrolls
  def index
    pagination = custom_pagination(params[:page].to_i, params[:per_page].to_i) if params[:page].present? && params[:per_page].present?

    sql = "SELECT py.id, CONCAT(py.from, ' to ', py.to) as date_range, py.from, py.to, py.pay_date, py.status,"
    sql += " CASE WHEN py.require_approver = true THEN u.name ELSE 'none' END as approver,"
    sql += " (SELECT IFNULL(JSON_ARRAYAGG(JSON_OBJECT('value', pa.id, 'label', pa.name)), '[]') FROM"
    sql += " (SELECT cac.id as id, cac.name  FROM payroll_accounts pa"
    sql += " LEFT JOIN company_accounts AS cac ON cac.id = pa.company_account_id"
    sql += " WHERE payroll_id = py.id ORDER BY cac.name ASC) AS pa"
    sql += " ) AS payroll_account_json" 
    sql += " FROM payrolls as py"
    sql += " LEFT JOIN users as u ON u.id = py.approver_id"
    sql += " WHERE py.company_id = #{payload['company_id']} and py.status != 'V'"
    sql += " ORDER BY py.from ASC"
    sql += " LIMIT #{pagination[:per_page]} OFFSET #{pagination[:fetch_point]}" if params[:page].present? && params[:per_page].present?
    
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
    pagination = custom_pagination(params[:page].to_i, params[:per_page].to_i) if params[:page].present? && params[:per_page].present?

    num_days_of_month = @payroll.from.end_of_month.day.to_f
    days_on_range = (@payroll.to - @payroll.from).to_f  

    percentage_of_month = ((days_on_range + 1) / num_days_of_month)

    sql_time_keeping_hours_sum = " COALESCE("
    sql_time_keeping_hours_sum += " (SELECT"
    sql_time_keeping_hours_sum += " CASE IFNULL(opc.work_sched_type, emp.work_sched_type) WHEN 'FL'"
    sql_time_keeping_hours_sum += " THEN SUM(COALESCE((SELECT SUM(TRUNCATE(TIMESTAMPDIFF(MINUTE, DATE_FORMAT(start_time, '%Y-%m-%d %H:%i'), DATE_FORMAT(end_time, '%Y-%m-%d %H:%i'))/60, 1))"
    sql_time_keeping_hours_sum += " FROM employee_schedules"
    sql_time_keeping_hours_sum += " WHERE employee_id = emp.id AND date(start_time) = only_date LIMIT 1), 1))"
    sql_time_keeping_hours_sum += " ELSE SUM(IF(emp.work_sched_days LIKE CONCAT('%', DATE_FORMAT(only_date, '%a'), '%'),"
    sql_time_keeping_hours_sum += " COALESCE(TRUNCATE((TIMESTAMPDIFF(MINUTE, CONCAT(only_date,' ', emp.work_sched_start), CONCAT(only_date,' ', emp.work_sched_end))-60)/60, 2), 0), 0)) END"
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
    sql_time_undertime_sum += " THEN IFNULL((SELECT TIMESTAMPDIFF(MINUTE, DATE_FORMAT(start_time, '%Y-%m-%d %H:%i'), DATE_FORMAT(end_time, '%Y-%m-%d %H:%i'))"
    sql_time_undertime_sum += " FROM employee_schedules WHERE employee_id = emp.id AND DATE(start_time) = only_date LIMIT 1), 0)"
    sql_time_undertime_sum += " ELSE IF(emp.work_sched_days LIKE CONCAT('%', DATE_FORMAT(only_date, '%a'), '%'),"
    sql_time_undertime_sum += " COALESCE(TIMESTAMPDIFF(MINUTE, CONCAT(only_date,' ', emp.work_sched_start), CONCAT(only_date,' ', emp.work_sched_end))-60, 0), 0) END"
    sql_time_undertime_sum += " AS expected_hours"
    sql_time_undertime_sum += " FROM ("
    sql_time_undertime_sum += " SELECT only_date,"
    sql_time_undertime_sum += " COALESCE(CASE IFNULL(opc.work_sched_type, emp.work_sched_type) WHEN 'FL' THEN"
    sql_time_undertime_sum += " SUM(TIMESTAMPDIFF(MINUTE,"
    sql_time_undertime_sum += " IF(date > (SELECT start_time FROM employee_schedules WHERE DATE(start_time) = only_date LIMIT 1), DATE_FORMAT(date, '%Y-%m-%d %H:%i'), (SELECT start_time FROM employee_schedules WHERE DATE(start_time) = only_date LIMIT 1)),"
    sql_time_undertime_sum += " IF(next_date < (SELECT end_time FROM employee_schedules WHERE DATE(start_time) = only_date LIMIT 1), DATE_FORMAT(next_date, '%Y-%m-%d %H:%i'), (SELECT end_time FROM employee_schedules WHERE DATE(start_time) = only_date LIMIT 1))"
    sql_time_undertime_sum += " ))"
    sql_time_undertime_sum += " ELSE"
    sql_time_undertime_sum += " SUM(IF(emp.work_sched_days LIKE CONCAT('%', DATE_FORMAT(only_date, '%a'), '%'), TIMESTAMPDIFF(MINUTE,"
    sql_time_undertime_sum += " IF(date > CONCAT(only_date,' ',emp.work_sched_start), DATE_FORMAT(date, '%Y-%m-%d %H:%i'), CONCAT(only_date,' ',emp.work_sched_start)),"
    sql_time_undertime_sum += " IF(next_date < CONCAT(only_date,' ',emp.work_sched_end), DATE_FORMAT(next_date, '%Y-%m-%d %H:%i'), CONCAT(only_date,' ',emp.work_sched_end))"
    sql_time_undertime_sum += " ) - IF(CONCAT(only_date,' 11:00') AND CONCAT(only_date,' 12:00') BETWEEN date AND next_date, 60, 0),0))"
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

    sql_payed_leave_hours_sum = " COALESCE((SELECT"
    sql_payed_leave_hours_sum += " SUM((CASE le.half_day WHEN 0" 
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

    sql_payed_spec_hol_hours_sum = " (SELECT IFNULL(SUM((SELECT"
		sql_payed_spec_hol_hours_sum += " TRUNCATE(COALESCE(CASE IFNULL(opc.work_sched_type, emp.work_sched_type) WHEN 'FL' THEN"
		sql_payed_spec_hol_hours_sum += " SUM(TIMESTAMPDIFF(MINUTE,"
		sql_payed_spec_hol_hours_sum +=	" IF(date > emp_sch.start_time, DATE_FORMAT(date, '%Y-%m-%d %H:%i'), emp_sch.start_time),"
		sql_payed_spec_hol_hours_sum +=	"	IF(next_date < emp_sch.end_time, DATE_FORMAT(next_date, '%Y-%m-%d %H:%i'), emp_sch.end_time)))"
		sql_payed_spec_hol_hours_sum += " ELSE SUM(IF(emp.work_sched_days LIKE CONCAT('%', DATE_FORMAT(spec_hol.date, '%a'), '%'), TIMESTAMPDIFF(MINUTE,"		
		sql_payed_spec_hol_hours_sum +=	"	IF(bio_logs.date > CONCAT(spec_hol.date,' ',emp.work_sched_start), DATE_FORMAT(bio_logs.date, '%Y-%m-%d %H:%i'), CONCAT(spec_hol.date,' ',emp.work_sched_start)),"
		sql_payed_spec_hol_hours_sum +=	"	IF(bio_logs.next_date < CONCAT(spec_hol.date,' ',emp.work_sched_end), DATE_FORMAT(bio_logs.next_date, '%Y-%m-%d %H:%i'), CONCAT(spec_hol.date,' ',emp.work_sched_end))"
		sql_payed_spec_hol_hours_sum +=	" ) - IF(CONCAT(spec_hol.date,' 11:00') AND CONCAT(spec_hol.date,' 12:00') BETWEEN bio_logs.date AND bio_logs.next_date, 60, 0),0))"
		sql_payed_spec_hol_hours_sum += " END/60, 0), 2) AS minutes_in_date"
		sql_payed_spec_hol_hours_sum += "	FROM (SELECT tk.id, tk.date, tk.status, tk.biometric_no, DATE(tk.date) AS only_date,"
		sql_payed_spec_hol_hours_sum += " LEAD(tk.date) OVER (ORDER BY tk.biometric_no, tk.date) AS next_date,"
		sql_payed_spec_hol_hours_sum += "	LEAD(tk.status) OVER (ORDER BY tk.biometric_no, tk.date) AS next_status"
		sql_payed_spec_hol_hours_sum += "	FROM time_keepings as tk"
		sql_payed_spec_hol_hours_sum += " WHERE tk.biometric_no = emp.biometric_no"
		sql_payed_spec_hol_hours_sum += " AND DATE(tk.date) = spec_hol.date"
		sql_payed_spec_hol_hours_sum +=	" AND (tk.status = 0 OR tk.status = 1) AND tk.company_id = #{payload['company_id']}"
		sql_payed_spec_hol_hours_sum += " ) AS bio_logs"
		sql_payed_spec_hol_hours_sum += " WHERE bio_logs.status = 0 AND bio_logs.next_status = 1)), 0) AS rendered_hours"
		sql_payed_spec_hol_hours_sum += " from holidays spec_hol"
		sql_payed_spec_hol_hours_sum += " LEFT JOIN employee_schedules as emp_sch ON emp_sch.employee_id = emp.id AND DATE(emp_sch.start_time) = spec_hol.date" 
		sql_payed_spec_hol_hours_sum += " WHERE type_of_holiday = 'S' AND (spec_hol.date BETWEEN '#{@payroll.from}' AND '#{@payroll.to}')"
		sql_payed_spec_hol_hours_sum += " ) AS total_special_holiday_hours,"

    sql_total_emp_allwances = " TRUNCATE(COALESCE("
		sql_total_emp_allwances += " (SELECT SUM(amount*#{percentage_of_month}) FROM on_payroll_allowances WHERE employee_id = emp.id),"
		sql_total_emp_allwances += " COALESCE((SELECT SUM(amount) FROM employee_allowances WHERE employee_id = emp.id), 0)"
    sql_total_emp_allwances += " ), 2) AS total_allowances_amount,"

    sql_total_emp_under_and_over_payments = " TRUNCATE("
		sql_total_emp_under_and_over_payments +=	" (SELECT COALESCE(TRUNCATE(SUM(amount), 2), 0) AS total_amount FROM on_payroll_adjustments WHERE adjustment_type = 'O' AND employee_id = emp.id AND payroll_id = #{@payroll.id})"
    sql_total_emp_under_and_over_payments += " ,2) AS total_over_payment_amount,"
		sql_total_emp_under_and_over_payments += " TRUNCATE("
		sql_total_emp_under_and_over_payments += "	(SELECT COALESCE(TRUNCATE(SUM(amount), 2), 0) AS total_amount FROM on_payroll_adjustments WHERE adjustment_type = 'U' AND employee_id = emp.id AND payroll_id = #{@payroll.id})"
    sql_total_emp_under_and_over_payments += " ,2) AS total_under_payment_amount,"

    sql_employee = "SELECT CONCAT(emp.last_name, ', ', first_name, ' ', CASE WHEN emp.suffix = '' THEN '' ELSE CONCAT(emp.suffix, '.') END,' '," 
    sql_employee += "CASE emp.middle_name WHEN '' THEN '' ELSE CONCAT(SUBSTR(emp.middle_name, 1, 1), '.') END) AS fullname,  sm.code AS salary_mode_code," 
    sql_employee += " pos.name AS position, sm.description AS salary_mode, IFNULL(opc.salary_mode_id, emp.salary_mode_id) AS salary_id, emp.employee_id,"
    sql_employee += " dep.name AS department_name, emp.id, emp.biometric_no, IF(emp.date_hired < date_add('#{@payroll.from}', interval -1 month), 0, 1) AS is_newly_hired,"
    sql_employee += " COALESCE(opc.compensation, emp.compensation) AS rate,"
    sql_employee += sql_payed_offset_hours_sum
    sql_employee += sql_payed_leave_hours_sum
    sql_employee += sql_total_emp_allwances
    sql_employee += sql_payed_ob_hours_sum
    sql_employee += sql_payed_overtime_hours_sum
    sql_employee += sql_total_emp_under_and_over_payments
    sql_employee += sql_time_undertime_sum
    sql_employee += sql_payed_spec_hol_hours_sum
    sql_employee += sql_time_keeping_hours_sum
    sql_employee += " FROM employees AS emp"
    sql_employee += " LEFT JOIN on_payroll_compensations AS opc ON opc.employee_id = emp.id AND opc.payroll_id = #{@payroll.id}"
    sql_employee += " LEFT JOIN positions AS pos ON pos.id = IFNULL(opc.position_id, emp.position_id)"
    sql_employee += " LEFT JOIN salary_modes AS sm ON sm.id = IFNULL(opc.salary_mode_id, emp.salary_mode_id)"
    sql_employee += " LEFT JOIN departments AS dep ON dep.id = IFNULL(opc.department_id, emp.department_id)"
    sql_employee += " WHERE (emp.status = 'A' OR (SELECT COUNT(*) FROM time_keepings WHERE biometric_no = emp.biometric_no AND DATE(date) BETWEEN '#{@payroll.from}' AND '#{@payroll.to}') > 0)"
    sql_employee += " AND emp.company_id = #{payload['company_id']}"
    sql_employee += " AND '#{@payroll.to}' > DATE(emp.date_hired)"
    sql_employee += " AND (opc.company_account_id = #{params[:company_account_id]}" if params[:company_account_id].present?
    sql_employee += " OR emp.company_account_id = #{params[:company_account_id]})" if params[:company_account_id].present?
    sql_employee += " AND (opc.company_account_id IN (#{params[:company_account_ids]})" if params[:company_account_ids].present?
    sql_employee += " OR emp.company_account_id IN (#{params[:company_account_ids]}))" if params[:company_account_ids].present?
    sql_employee += " emp.id = #{params[:employee_id]}" if params[:employee_id].present?
    sql_employee += " ORDER BY fullname"
    sql_employee += " LIMIT #{pagination[:per_page]} OFFSET #{pagination[:fetch_point]}" if params[:page].present? && params[:per_page].present?

    sql_gather_fields = " SELECT"
    sql_gather_fields += " emp_data.*,"
    sql_gather_fields += " CASE salary_mode_code"
    sql_gather_fields += " WHEN 'HRLY' THEN CONCAT(emp_data.total_hours_earned, ' hours')"
    sql_gather_fields += " ELSE CONCAT(TRUNCATE((emp_data.total_hours_earned/8), 1), ' days')"
    sql_gather_fields += " END AS total_time,"
    sql_gather_fields += " TRUNCATE(CASE salary_mode_code"
    sql_gather_fields += " WHEN 'DLY' THEN emp_data.rate"
    sql_gather_fields += " WHEN 'HRLY' THEN emp_data.rate*8"
    sql_gather_fields += " ELSE (emp_data.rate/26)"
    sql_gather_fields += " END, 2) AS daily_rate,"
    sql_gather_fields += " TRUNCATE(CASE salary_mode_code"
    sql_gather_fields += " WHEN 'DLY' THEN ((emp_data.rate/8) * TRUNCATE((emp_data.total_hours_earned), 1))"
    sql_gather_fields += " WHEN 'HRLY' THEN (emp_data.rate * TRUNCATE((emp_data.total_hours_earned), 1))"
    sql_gather_fields += " ELSE (((emp_data.rate/26)/8) * TRUNCATE((emp_data.total_hours_earned), 1) + IF((emp_data.total_hours_earned/8) > 2, (emp_data.rate/26) * 2, 0))"
    sql_gather_fields += " END, 2) AS payed_hours_amount,"
    sql_gather_fields += " TRUNCATE(CASE salary_mode_code"
    sql_gather_fields += " WHEN 'DLY' THEN ((emp_data.rate/8) * TRUNCATE((emp_data.total_payed_overtime_hours), 2))"
    sql_gather_fields += " WHEN 'HRLY' THEN (emp_data.rate * TRUNCATE((emp_data.total_payed_overtime_hours), 2))"
    sql_gather_fields += " ELSE (((emp_data.rate/26)/8) * TRUNCATE((emp_data.total_payed_overtime_hours), 2))"
    sql_gather_fields += " END, 2) AS payed_overtime_amount,"
    sql_gather_fields += " TRUNCATE(CASE salary_mode_code"
    sql_gather_fields += " WHEN 'DLY' THEN ((emp_data.rate/8) * TRUNCATE((emp_data.total_payed_offset_hours), 1))"
    sql_gather_fields += " WHEN 'HRLY' THEN (emp_data.rate * TRUNCATE((emp_data.total_payed_offset_hours), 1))"
    sql_gather_fields += " ELSE (((emp_data.rate/26)/8) * TRUNCATE((emp_data.total_payed_offset_hours), 1))"
    sql_gather_fields += " END, 2) AS payed_offset_amount,"
    sql_gather_fields += " TRUNCATE(CASE salary_mode_code"
    sql_gather_fields += " WHEN 'DLY' THEN ((emp_data.rate/8) * TRUNCATE((emp_data.total_payed_leave_hours), 1))"
    sql_gather_fields += " WHEN 'HRLY' THEN (emp_data.rate * TRUNCATE((emp_data.total_payed_leave_hours), 1))"
    sql_gather_fields += " ELSE (((emp_data.rate/26)/8) * TRUNCATE((emp_data.total_payed_leave_hours), 1))"
    sql_gather_fields += " END, 2) AS payed_leave_amount,"
    sql_gather_fields += " TRUNCATE(CASE salary_mode_code"
    sql_gather_fields += " WHEN 'DLY' THEN ((emp_data.rate/8)* TRUNCATE((emp_data.total_payed_ob_hours), 1))"
    sql_gather_fields += " WHEN 'HRLY' THEN (emp_data.rate * TRUNCATE((emp_data.total_payed_ob_hours), 1))"
    sql_gather_fields += " ELSE (((emp_data.rate/26)/8) * TRUNCATE((emp_data.total_payed_ob_hours), 1))"
    sql_gather_fields += " END, 2) AS payed_ob_amount,"
    sql_gather_fields += " TRUNCATE(CASE salary_mode_code"
    sql_gather_fields += " WHEN 'DLY' THEN (((emp_data.rate/8)/60) * emp_data.undertime_minutes)"
    sql_gather_fields += " WHEN 'HRLY' THEN ((emp_data.rate/60) * emp_data.undertime_minutes)"
    sql_gather_fields += " ELSE ((((emp_data.rate/26)/8)/60) * emp_data.undertime_minutes)"
    sql_gather_fields += " END, 2) AS undertime_amount,"
    sql_gather_fields += " COALESCE(TRUNCATE((CASE salary_mode_code WHEN 'DLY' THEN (emp_data.rate/8) WHEN 'HRLY'"
    sql_gather_fields += " THEN emp_data.rate ELSE (emp_data.rate/26)/8 END)*total_special_holiday_hours*0.30, 2), 0) AS payed_special_holiday,"
    sql_gather_fields += " COALESCE((SELECT COUNT(id) from holidays reg_hol WHERE type_of_holiday = 'R' AND (date BETWEEN '#{@payroll.from}' AND '#{@payroll.to}')"
    sql_gather_fields += " ),0) AS total_regular_holiday_days"
    sql_gather_fields += " FROM ("
    sql_gather_fields += sql_employee
    sql_gather_fields += " ) emp_data"

    sql_total = "SELECT"
    #regular pay
    sql_total += " with_total.*, (payed_hours_amount - undertime_amount + payed_leave_amount + payed_ob_amount + payed_offset_amount) AS total_regular_pay,"
    #premium_pay
    sql_total += " (payed_overtime_amount + (total_regular_holiday_days * daily_rate) + payed_special_holiday) AS premium_pay_total,"
    #gross_pay
    sql_total += " (payed_hours_amount - undertime_amount + payed_leave_amount + total_allowances_amount + total_under_payment_amount - total_over_payment_amount + payed_ob_amount + payed_overtime_amount + (total_regular_holiday_days * daily_rate) + payed_special_holiday) AS gross_pay,"
    #net pay
    sql_total += " (payed_hours_amount - undertime_amount + payed_leave_amount + total_allowances_amount + total_under_payment_amount - total_over_payment_amount + payed_ob_amount + payed_overtime_amount + (total_regular_holiday_days * daily_rate) + payed_special_holiday - IFNULL(sss.total_ee, 0)"
    sql_total += " - IFNULL(pb.amount, 0) - ROUND((payed_hours_amount - undertime_amount + payed_leave_amount + payed_ob_amount + payed_offset_amount)*(ph.percentage_deduction /100), 2)) AS net_pay,"
    
    sql_total += " ROUND((payed_hours_amount - undertime_amount + payed_leave_amount + payed_ob_amount + payed_offset_amount)*(ph.percentage_deduction /100), 2) AS phic_deduction,"

    sql_total += " IFNULL(sss.total_ee, 0) AS sss_deduction, IFNULL(pb.amount, 0) AS pagibig_deduction, ph.percentage_deduction AS phic_percentage_deduction,"

    sql_total += " (total_regular_holiday_days * daily_rate) AS payed_regular_holiday,"
    #total adjusment and additional
    sql_total += " (total_allowances_amount + total_under_payment_amount + total_over_payment_amount) AS additional_and_adjustment_total,"
    #total deductions
    sql_total += " (IFNULL(pb.amount, 0) + IFNULL(sss.total_ee, 0) + ROUND((payed_hours_amount - undertime_amount + payed_leave_amount + payed_ob_amount + payed_offset_amount)*(ph.percentage_deduction /100), 2)) AS total_deductions"
  
    sql_total += " from ("
    sql_total += sql_gather_fields
    sql_total += " ) with_total"
    sql_total += " LEFT JOIN philhealths AS ph ON ph.id = #{@payroll.philhealth_id}"
    sql_total += " LEFT JOIN pagibigs AS pb ON pb.id = #{@payroll.pagibig_id ? @payroll.pagibig_id : 'null'}"
    sql_total += " LEFT JOIN social_security_systems AS sss ON sss.id = "
    sql_total += " (SELECT ss.id FROM social_security_systems as ss"
    sql_total += " WHERE (IF((payed_hours_amount - undertime_amount + payed_leave_amount + payed_ob_amount + payed_offset_amount) > 0, (payed_hours_amount - undertime_amount + payed_leave_amount + payed_ob_amount + payed_offset_amount), 0)" 
    sql_total += " BETWEEN ss.com_from AND ss.com_to) AND sss_contribution_id = #{@payroll.sss_contribution_id}"
    sql_total += " LIMIT 1)"

    payroll = execute_sql_query(sql_total) if !params[:summary].present?

    if params[:page].present? && params[:per_page].present?
      count_sql = "SELECT"
      count_sql += " COUNT(emp.id) AS total_count"
      count_sql += " FROM employees AS emp"
      count_sql += " LEFT JOIN on_payroll_compensations AS opc ON opc.employee_id = emp.id AND opc.payroll_id = #{@payroll.id}"
      count_sql += " WHERE (emp.status = 'A' OR (SELECT COUNT(*) FROM time_keepings WHERE biometric_no = emp.biometric_no AND DATE(date) BETWEEN '#{@payroll.from}' AND '#{@payroll.to}') > 0)"
      count_sql += " AND emp.company_id = #{payload['company_id']}"
      count_sql += " AND '#{@payroll.to}' >= DATE(emp.date_hired)"
      count_sql += " AND (opc.company_account_id = #{params[:company_account_id]}" if params[:company_account_id].present?
      count_sql += " OR emp.company_account_id = #{params[:company_account_id]})" if params[:company_account_id].present?
      count = execute_sql_query(count_sql)
      render json: {data: payroll, total_count: count.first["total_count"]}
    elsif params[:summary].present?
      sql_total_ext = "SELECT"
      sql_total_ext += " SUM(total_regular_pay) AS regular_pay_summary, SUM(gross_pay) AS gross_pay_summary,"
      sql_total_ext += " SUM(net_pay) AS net_pay_summary, SUM(total_deductions) as deductions_summary,"
      sql_total_ext += " SUM(premium_pay_total) AS premium_pay_summary,"
      sql_total_ext += " SUM(additional_and_adjustment_total) as additional_and_adjustment_summary"
      sql_total_ext += " FROM ("
      sql_total_ext += sql_total
      sql_total_ext += " ) summary"
      summary = execute_sql_query(sql_total_ext)
      render json: summary.first
    elsif params[:employee_id].present?
      render json: payroll.first
    else
      render json: payroll
    end
  end

  def daily_time_records
    start_day_payroll = @payroll.from
    end_day_payroll = @payroll.to
    date_range = (start_day_payroll..end_day_payroll).map(&:to_s)

    sql = "SELECT "
    sql += " IFNULL(TRUNCATE((TIMESTAMPDIFF(MINUTE, CONCAT('2000-01-01 ', emp.work_sched_start), CONCAT('2000-01-01 ', emp.work_sched_end))-60)/60, 0), 0) AS expected_hours,"
    sql += " COALESCE((SELECT json_arrayagg(JSON_OBJECT('in', DATE_FORMAT(start_time, '%H:%i %p'), 'out', DATE_FORMAT(end_time, '%H:%i %p'),"
    sql += " 'expected_hours', TRUNCATE((TIMESTAMPDIFF(MINUTE, start_time, end_time)-60)/60, 0)"
    sql += " )) FROM employee_schedules WHERE employee_id = emp.id AND DATE(start_time)"
    sql += " BETWEEN '#{@payroll.from}' AND '#{@payroll.to}'), '[]') AS fl_actual,"
    sql += " COALESCE((SELECT"
    sql += " SUM(TRUNCATE((TIMESTAMPDIFF(minute, CASE WHEN DATE(ov.end_date) > '#{@payroll.to}' THEN DATE_FORMAT('#{@payroll.to}', '%Y-%m-%d %H:%i') ELSE DATE_FORMAT(ov.start_date, '%Y-%m-%d %H:%i') END,"
    sql += " CASE WHEN DATE(ov.start_date) < '#{@payroll.from}' THEN DATE_FORMAT('#{@payroll.from}', '%Y-%m-%d %H:%i') ELSE  DATE_FORMAT(ov.end_date, '%Y-%m-%d %H:%i') END)/60), 1))"
    sql += " FROM overtimes ov"
    sql += " WHERE ov.status = 'A' AND ov.employee_id = emp.id"
    sql += " AND (DATE(ov.start_date) BETWEEN '#{@payroll.from}' AND '#{@payroll.to}' OR DATE(ov.end_date) BETWEEN '#{@payroll.from}' AND '#{@payroll.to}')"
    sql += " GROUP BY ov.employee_id"
    sql += " ), 0.0) total_payed_overtime_hours,"
    sql += " CONCAT(emp.last_name, ', ', first_name, ' ', CASE WHEN emp.suffix = '' THEN '' ELSE CONCAT(emp.suffix, '.') END,' ',"
    sql += " CASE emp.middle_name WHEN '' THEN '' ELSE CONCAT(SUBSTR(emp.middle_name, 1, 1), '.') END) AS fullname, pos.name AS position, dep.name As department,"
    sql += " IFNULL(opc.work_sched_type, emp.work_sched_type) AS shed_type, emp.id, emp.first_name, emp.last_name, emp.biometric_no, emp.work_sched_start, emp.work_sched_end,"
    sql += " (SELECT IFNULL(json_arrayagg(JSON_OBJECT('date', only_date, 'in', actual_in, 'out', actual_out, 'undertime_minutes', (expected_minutes - minutes_in_date),"
    sql += " 'expected_hours', TRUNCATE(expected_minutes/60, 0), 'actual_minutes', minutes_in_date"
    sql += " )), '[]') FROM"
    sql += " (SELECT from_bio.only_date, group_concat(date_format(from_bio.date, '%h:%i %p')) AS actual_in, group_concat(date_format(from_bio.next_date, '%h:%i %p')) as actual_out,"
    sql += " CASE IFNULL(opc.work_sched_type, emp.work_sched_type) WHEN 'FL'"
    sql += " THEN COALESCE((SELECT TIMESTAMPDIFF(MINUTE, DATE_FORMAT(start_time, '%Y-%m-%d %H:%i'), DATE_FORMAT(end_time, '%Y-%m-%d %H:%i'))"
    sql += " FROM employee_schedules WHERE employee_id = emp.id AND DATE(start_time) = from_bio.only_date LIMIT 1), 0)"
    sql += " ELSE TIMESTAMPDIFF(MINUTE, CONCAT('2000-01-01 ', emp.work_sched_start), CONCAT('2000-01-01 ', emp.work_sched_end))-60 END AS expected_minutes,"
    sql += " COALESCE(CASE IFNULL(opc.work_sched_type, emp.work_sched_type) WHEN 'FL' THEN"
    sql += " SUM(TIMESTAMPDIFF(MINUTE,"
    sql += " IF(date > (SELECT start_time FROM employee_schedules WHERE DATE(start_time) = only_date LIMIT 1), DATE_FORMAT(date, '%Y-%m-%d %H:%i'), (SELECT start_time FROM employee_schedules WHERE DATE(start_time) = only_date LIMIT 1)),"
    sql += " IF(next_date < (SELECT end_time FROM employee_schedules WHERE DATE(start_time) = only_date LIMIT 1), DATE_FORMAT(next_date, '%Y-%m-%d %H:%i'), (SELECT end_time FROM employee_schedules WHERE DATE(start_time) = only_date LIMIT 1))))"
    sql += " ELSE"
    sql += " SUM(TIMESTAMPDIFF(MINUTE,"
    sql += " IF(date > CONCAT(only_date,' ',emp.work_sched_start), DATE_FORMAT(date, '%Y-%m-%d %H:%i'), CONCAT(only_date,' ',emp.work_sched_start)),"
    sql += " IF(next_date < CONCAT(only_date,' ',emp.work_sched_end), DATE_FORMAT(next_date, '%Y-%m-%d %H:%i'), CONCAT(only_date,' ',emp.work_sched_end))"
    sql += " ) - IF(CONCAT(only_date,' 11:00') AND CONCAT(only_date,' 12:00') BETWEEN date AND next_date, 60, 0))"
    sql += " END, 0) AS minutes_in_date"
    sql += " FROM (SELECT id, date, status, biometric_no, DATE(date) AS only_date,"
    sql += " LEAD(date) OVER (ORDER BY biometric_no, date) AS next_date,"
    sql += " LEAD(status) OVER (ORDER BY biometric_no, date) AS next_status"
    sql += " FROM time_keepings"
    sql += " WHERE biometric_no = emp.biometric_no AND"
    sql += " DATE(date) BETWEEN '#{@payroll.from}' AND '#{@payroll.to}'"
    sql += " AND (status = 0 OR status = 1) AND company_id = 1) from_bio"
    sql += " WHERE status = 0 and next_status = 1"
    sql += " GROUP BY only_date) AS final"
    sql += " ) AS actual"
    sql += " FROM employees AS emp"
    sql += " LEFT JOIN on_payroll_compensations AS opc ON opc.employee_id = emp.id AND opc.payroll_id = #{@payroll.id}"
    sql += " LEFT JOIN positions AS pos ON pos.id = IFNULL(opc.position_id, emp.position_id)"
    sql += " LEFT JOIN departments AS dep ON dep.id = IFNULL(opc.department_id, emp.department_id)"
    sql += " WHERE (emp.status = 'A' OR (SELECT COUNT(*) FROM time_keepings WHERE biometric_no = emp.biometric_no AND DATE(date) BETWEEN '#{@payroll.from}' AND '#{@payroll.to}') > 0)"
    sql += " AND (opc.company_account_id IN (#{params[:company_account_ids]})" if params[:company_account_ids].present?
    sql += " OR emp.company_account_id IN (#{params[:company_account_ids]}))" if params[:company_account_ids].present?
    sql += " AND emp.company_id = #{payload['company_id']}"
    sql += " AND '#{@payroll.to}' >= DATE(emp.date_hired)"
    sql += " ORDER BY fullname"
    #count_sql += " AND (opc.company_account_id = #{params[:company_account_id]}" if params[:company_account_id].present?
    #count_sql += " OR emp.company_account_id = #{params[:company_account_id]})" if params[:company_account_id].present?

    data = execute_sql_query(sql)
    render json: {date_range: date_range, data: data}
  end

  # GET /payrolls/1
  def show
    render json: @payroll
  end

  def payroll_details
    value = '"value"'
    label = '"label"'
    ats = '"'
    sql = "SELECT py.id, py.from, py.to, py.status, py.approver_id, py.require_approver, CONCAT('[{#{value}:',py.approver_id,',#{label}:','#{ats}',usr.name,' (',usr.position,')','#{ats}','}]') AS approver,"
    sql += " (SELECT CONCAT('[',GROUP_CONCAT('{#{value}:',pa.id, ',#{label}:','#{ats}',pa.name,'#{ats}','}' ORDER BY pa.name SEPARATOR ','),']') FROM"
    sql += " (SELECT cac.id as id, cac.name FROM payroll_accounts pa"
    sql += " LEFT JOIN company_accounts AS cac ON cac.id = pa.company_account_id"
    sql += " WHERE payroll_id = py.id ORDER BY cac.name ASC)"
    sql += " AS pa) AS payroll_account_json"
    sql += " FROM payrolls AS py"
    sql += " LEFT JOIN users AS usr ON usr.id = py.approver_id"
    sql += " WHERE py.id = #{params[:id]}"
    sql += " LIMIT 1;"
    execute_sql_query("SET SESSION group_concat_max_len = 10000;")
    details = execute_sql_query(sql).first
    render json: details
  end

  def on_params_details
    sql = "SELECT py.id, "
    sql += " (SELECT cac.id as com_id FROM payroll_accounts pa"
    sql += " LEFT JOIN company_accounts AS cac ON cac.id = pa.company_account_id"
    sql += " WHERE pa.payroll_id = py.id ORDER BY cac.name ASC LIMIT 1)"
    sql += " AS pa) AS com_id"
    sql += " FROM payroll AS py"
    details = execute_sql_query(sql).first
    render json: details
  end

  # POST /payrolls
  def create
    philhealth_id = Philhealth.find_by!(status: "A").id
    sss_contribution_id = SssContribution.find_by!(status: "A").id
    pagibig = Pagibig.find_by!(status: "A")
    pagibig_id = nil

    date = Date.parse(payroll_params[:from])
    exist_on_month_payroll = Payroll.where("(? BETWEEN payrolls.from AND payrolls.to OR ? BETWEEN payrolls.from AND payrolls.to)
                            AND payrolls.company_id = ?", date.beginning_of_month, date.end_of_month, payload["company_id"]).first

    if exist_on_month_payroll && exist_on_month_payroll.payroll_accounts.pluck(:company_account_id) == request.params[:payroll][:company_account_ids]
      pagibig_id = nil
    else
      pagibig_id = pagibig.id if pagibig
    end
    
    @payroll = Payroll.new(payroll_params.merge!({company_id: payload["company_id"], pagibig_id: pagibig_id, philhealth_id: philhealth_id, sss_contribution_id: sss_contribution_id}))

    if philhealth_id && sss_contribution_id && pagibig && @payroll.save
      store = []
      request.params[:payroll][:company_account_ids].each { |id| store.push({company_account_id: id})}
      @payroll.payroll_accounts.create(store) if store.length > 0
      OnPayrollCompensationWorker.perform_async(@payroll.id, payload["company_id"])
      render json: @payroll, status: :created
    else
      if !philhealth_id
        render json: {error: "there is no active philhealth records"}, status: :unprocessable_entity
      elsif !sss_contribution_id
        render json: {error: "there is no active sss records"}, status: :unprocessable_entity
      elsif !pagibig
        render json: {error: "there is no active pagibig records"}, status: :unprocessable_entity
      else
        render json: @payroll.errors, status: :unprocessable_entity
      end
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
