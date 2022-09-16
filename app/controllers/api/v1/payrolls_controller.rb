class Api::V1::PayrollsController < PmsDesktopController
  before_action :authorize_access_request!
  before_action :check_backend_session
  before_action :set_payroll, only: [:show, :update, :destroy]

  # GET /payrolls
  def index
    sql = "SELECT py.id, CONCAT(py.from, ' to ', py.to) as date_range, py.from, py.to,"
    sql += " CASE WHEN py.status = 'P' THEN 'pending' WHEN py.status = 'V' THEN 'voided' ELSE 'approved' END as status,"
    sql += " CASE WHEN py.require_approver = true THEN u.name ELSE 'none' END as approver" 
    sql += " FROM payrolls as py"
    sql += " LEFT JOIN users as u ON u.id = py.approver_id"
    sql += " WHERE py.company_id = #{payload['company_id']} and py.status != 'V'"
  
    payrolls = execute_sql_query(sql)
    render json: payrolls
  end

  def approver_list
    sql = "SELECT"
    sql += " id as value, CONCAT(name, ' (',position,')') as label"
    sql += " FROM users"
    sql += " WHERE admin = true AND company_id = #{payload['company_id']}"
    approver = execute_sql_query(sql)
    render json: approver
  end

  def payroll_data
    # payroll_id = params[:payroll_id]

    sql_time_keeping = " SELECT biometric_no, date, status, DATE(date) AS only_date"
    sql_time_keeping += " FROM time_keepings AS t"
    sql_time_keeping += " WHERE biometric_no = emp.biometric_no AND DATE(date) BETWEEN '2022-06-01' AND '2022-06-15' and company_id = emp.company_id "
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

    sql_time_keeping_sum = " COALESCE(("
    sql_time_keeping_sum += " SELECT SUM(rendered_hrs_per_day)"
    sql_time_keeping_sum += " FROM ("
    sql_time_keeping_sum += sql_time_keeping_time
    sql_time_keeping_sum += " ) final"
    sql_time_keeping_sum += " GROUP BY biometric_no"
    sql_time_keeping_sum += " ), 0) AS total_hours_earned"
    
    sql_employee = " SELECT"
    sql_employee += " CONCAT(emp.last_name, ', ', first_name, ' ', CASE WHEN emp.suffix = '' THEN '' ELSE CONCAT(emp.suffix, '.') END,' ', SUBSTR(emp.middle_name, 1, 1), '.') AS fullname,"
    sql_employee += " pos.name AS position, aa.name AS assigned_area, sm.description AS salary_mode, sm.id AS salary_id, emp.compensation as rate, emp.employee_id,"
    sql_employee += sql_time_keeping_sum
    sql_employee += " FROM employees AS emp"
    sql_employee += " LEFT JOIN positions AS pos ON pos.id = emp.position_id"
    sql_employee += " LEFT JOIN assigned_areas AS aa ON aa.id = emp.assigned_area_id"
    sql_employee += " LEFT JOIN salary_modes AS sm ON sm.id = emp.salary_mode_id"
    sql_employee += " WHERE emp.status = 'A' and emp.company_id = #{payload['company_id']}"
    sql_employee += " ORDER BY fullname"

    sql = "SELECT"
    sql += " emp_data.*,"
    sql += " CASE salary_id"
    sql += " WHEN 2 THEN CONCAT(emp_data.total_hours_earned, ' hours')"
    sql += " ELSE CONCAT(TRUNCATE((emp_data.total_hours_earned/8), 0), ' days')"
    sql += " END AS total_time,"
    sql += " TRUNCATE(CASE salary_id"
    sql += " WHEN 3 THEN (emp_data.rate * (emp_data.total_hours_earned/8))"
    sql += " WHEN 2 THEN (emp_data.rate * total_hours_earned)"
    sql += " ELSE ((emp_data.rate/26) * (emp_data.total_hours_earned/8))"
    sql += " END, 2) AS total_regular_pay"
    sql += " FROM ("
    sql += sql_employee
    sql += " ) emp_data;"

    payroll = execute_sql_query(sql)
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
