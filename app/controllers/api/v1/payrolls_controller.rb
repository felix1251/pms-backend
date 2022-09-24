class Api::V1::PayrollsController < PmsDesktopController
  before_action :authorize_access_request!
  before_action :check_backend_session
  before_action :set_payroll, only: [:show, :update, :destroy, :payroll_data]

  # GET /payrolls
  def index
    sql = "SELECT py.id, CONCAT(py.from, ' to ', py.to) as date_range, py.from, py.to, py.pay_date, py.status,"
    sql += " CASE WHEN py.require_approver = true THEN u.name ELSE 'none' END as approver" 
    sql += " FROM payrolls as py"
    sql += " LEFT JOIN users as u ON u.id = py.approver_id"
    sql += " WHERE py.company_id = #{payload['company_id']} and py.status != 'V'"
    sql += " ORDER BY py.to DESC"
  
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
    sql_time_keeping = " SELECT biometric_no, date, status, DATE(date) AS only_date"
    sql_time_keeping += " FROM time_keepings AS t"
    sql_time_keeping += " WHERE biometric_no = emp.biometric_no AND DATE(date) BETWEEN '#{@payroll.from}' AND '#{@payroll.to}'"
    sql_time_keeping += " AND status = 0 OR status = 1 AND company_id = #{payload['company_id']}"
    sql_time_keeping += " ORDER BY biometric_no, date"

    sql_time_keeping_lead = " SELECT *,"
    sql_time_keeping_lead += " LEAD(date) OVER (ORDER BY biometric_no, date) AS next_date,"
    sql_time_keeping_lead += " LEAD(status) OVER (ORDER BY biometric_no, date) AS next_status"
    sql_time_keeping_lead += " FROM ("
    sql_time_keeping_lead += sql_time_keeping
    sql_time_keeping_lead += " ) tk"

    sql_time_keeping_time = " SELECT biometric_no,"
    sql_time_keeping_time += " CASE WHEN SUM(ABS(TIME_TO_SEC(TIMEDIFF(next_date, date)) / 3600)) > 8 THEN 8"
    sql_time_keeping_time += " ELSE TRUNCATE(SUM(ABS(TIME_TO_SEC(TIMEDIFF(next_date, date)) / 3600)), 0) END AS rendered_hrs_per_day"
    sql_time_keeping_time += " FROM("
    sql_time_keeping_time += sql_time_keeping_lead
    sql_time_keeping_time += " ) tk_filtered"
    sql_time_keeping_time += " WHERE status = 0 AND next_status = 1"
    sql_time_keeping_time += " GROUP BY biometric_no, only_date"

    sql_time_keeping_hours_sum = " COALESCE(("
    sql_time_keeping_hours_sum += " SELECT SUM(rendered_hrs_per_day)"
    sql_time_keeping_hours_sum += " FROM ("
    sql_time_keeping_hours_sum += sql_time_keeping_time
    sql_time_keeping_hours_sum += " ) final"
    sql_time_keeping_hours_sum += " GROUP BY biometric_no"
    sql_time_keeping_hours_sum += " ), 0.0) AS total_hours_earned"

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
    
    sql_employee = "SELECT CONCAT(emp.last_name, ', ', first_name, ' ', CASE WHEN emp.suffix = '' THEN '' ELSE CONCAT(emp.suffix, '.') END,' '," 
    sql_employee += "CASE emp.middle_name WHEN '' THEN '' ELSE CONCAT(SUBSTR(emp.middle_name, 1, 1), '.') END) AS fullname," 
    sql_employee += " pos.name AS position, aa.name AS assigned_area, sm.description AS salary_mode, sm.id AS salary_id, emp.employee_id,"
    sql_employee += " dep.name AS department_name, emp.id,"
    sql_employee += " COALESCE(opc.compensation, emp.compensation) AS rate,"
    sql_employee += sql_payed_leave_hours_sum
    sql_employee += sql_payed_ob_hours_sum
    sql_employee += sql_payed_overtime_hours_sum
    sql_employee += sql_time_keeping_hours_sum
    sql_employee += " FROM employees AS emp"
    sql_employee += " LEFT JOIN positions AS pos ON pos.id = emp.position_id"
    sql_employee += " LEFT JOIN assigned_areas AS aa ON aa.id = emp.assigned_area_id"
    sql_employee += " LEFT JOIN salary_modes AS sm ON sm.id = emp.salary_mode_id"
    sql_employee += " LEFT JOIN departments AS dep ON dep.id = emp.department_id"
    sql_employee += " LEFT JOIN on_payroll_compensations AS opc ON opc.employee_id = emp.id AND opc.payroll_id = #{@payroll.id}"
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
    sql_gather_fields += " WHEN 3 THEN ((emp_data.rate/8) * TRUNCATE((emp_data.total_hours_earned), 0))"
    sql_gather_fields += " WHEN 2 THEN (emp_data.rate * total_hours_earned)"
    sql_gather_fields += " ELSE (((emp_data.rate/26)/8) * TRUNCATE((emp_data.total_hours_earned), 0) + IF((emp_data.total_hours_earned/8) > 2, (emp_data.rate/26) * 2, 0))"
    sql_gather_fields += " END, 2) AS payed_hours_amount,"
    sql_gather_fields += " TRUNCATE(CASE salary_id"
    sql_gather_fields += " WHEN 3 THEN ((emp_data.rate/8) * TRUNCATE((emp_data.total_payed_overtime_hours), 0))"
    sql_gather_fields += " WHEN 2 THEN (emp_data.rate * emp_data.total_payed_overtime_hours)"
    sql_gather_fields += " ELSE (((emp_data.rate/26)/8) * TRUNCATE((emp_data.total_payed_overtime_hours), 0))"
    sql_gather_fields += " END, 2) AS payed_overtime_amount,"
    sql_gather_fields += " TRUNCATE(CASE salary_id"
    sql_gather_fields += " WHEN 3 THEN ((emp_data.rate/8) * TRUNCATE((emp_data.total_payed_leave_hours), 0))"
    sql_gather_fields += " WHEN 2 THEN (emp_data.rate * emp_data.total_payed_leave_hours)"
    sql_gather_fields += " ELSE (((emp_data.rate/26)/8) * TRUNCATE((emp_data.total_payed_leave_hours), 0))"
    sql_gather_fields += " END, 2) AS payed_leave_amount,"
    sql_gather_fields += " TRUNCATE(CASE salary_id"
    sql_gather_fields += " WHEN 3 THEN ((emp_data.rate/8)* TRUNCATE((emp_data.total_payed_ob_hours), 0))"
    sql_gather_fields += " WHEN 2 THEN (emp_data.rate * emp_data.total_payed_ob_hours)"
    sql_gather_fields += " ELSE (((emp_data.rate/26)/8) * TRUNCATE((emp_data.total_payed_ob_hours), 0))"
    sql_gather_fields += " END, 2) AS payed_ob_amount"
    sql_gather_fields += " FROM ("
    sql_gather_fields += sql_employee
    sql_gather_fields += " ) emp_data"

    sql_total = "SELECT"
    sql_total += " with_total.*, (payed_hours_amount + payed_leave_amount + payed_ob_amount ) AS total_regular_pay,"
    sql_total += " (payed_overtime_amount) AS premium_pay_total,"
    sql_total += " (payed_hours_amount + payed_leave_amount + payed_ob_amount + payed_overtime_amount) gross_pay"
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

  # POST /payrolls
  def create
    @payroll = Payroll.new(payroll_params.merge!({company_id: payload["company_id"]}))
    if @payroll.save
      OnPayrollCompensationWorker.perform_async(@payroll.id, payload["company_id"])
      render json: @payroll, status: :created
    else
      render json: @payroll.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /payrolls/1
  def update
    if @payroll.update(payroll_params)
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
