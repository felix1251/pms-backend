class Api::V1::EmployeesController < PmsDesktopController
  before_action :authorize_access_request!
  before_action :check_backend_session
  before_action :set_employee, only: [:update, :destroy]
  before_action :set_employee_show, only: [:show]
  # GET /employees

  def index
    pagination = custom_pagination(params[:page].to_i, params[:per_page].to_i)

    sql_start = ""
    sql_start += "SELECT"
    # only to display count
    sql_count = " COUNT(*) AS total_count"
    # columns
    sql_fields = " emp.id, emp.company_id, emp.status, emp.biometric_no, emp.first_name"
    sql_fields += " ,emp.middle_name, emp.last_name, emp.suffix"
    sql_fields += " ,po.name AS position, dp.name AS department_name, sm.description AS salary_mode_desc"
    sql_fields += " ,aa.name AS assigned_area, jc.name AS job_classification"
    sql_fields += " ,DATE_FORMAT(date_hired, '%b %d, %Y') as date_hired, es.name AS employment_status, emp.sex"
    sql_fields += " ,emp.birthdate, emp.status, emp.phone_number, cac.name AS company_account_name"
    sql_fields += " ,emp.sss_no, emp.tin_no, emp.phic_no, emp.hdmf_no"
    sql_fields += " ,emp.biometric_no, emp.employee_id, emp.work_sched_type"
    # main table
    sql_from = " FROM employees AS emp"
    # joins
    sql_join = " LEFT JOIN departments AS dp ON dp.id = emp.department_id"
    sql_join += " LEFT JOIN salary_modes AS sm ON sm.id = emp.salary_mode_id"
    sql_join += " LEFT JOIN positions AS po ON po.id = emp.position_id"
    sql_join += " LEFT JOIN employment_statuses AS es ON es.id = emp.employment_status_id"
    sql_join += " LEFT JOIN job_classifications AS jc ON jc.id = emp.job_classification_id"
    sql_join += " LEFT JOIN assigned_areas AS aa ON aa.id = emp.assigned_area_id"
    sql_join += " LEFT JOIN company_accounts AS cac ON cac.id = emp.company_account_id"
    # conditions
    sql_condition = " WHERE emp.company_id = #{payload["company_id"]}"
    sql_condition += " AND emp.status = 'A'"
    sql_sort = " ORDER BY last_name ASC, first_name ASC, middle_name ASC"
    # paginate
    sql_paginate = " LIMIT #{pagination[:per_page]} OFFSET #{pagination[:fetch_point]};"
  
    # render json: Employee.all
    begin
      employees = execute_sql_query(sql_start + sql_fields + sql_from + sql_join + sql_condition + sql_sort + sql_paginate)
      employees_count = execute_sql_query(sql_start + sql_count + sql_from + sql_condition)
      render json: { employees: employees, total_count: employees_count.first["total_count"]}
    rescue Exception => exc
      render json: { error: exc.message }, status: :unprocessable_entity
    end
  end

  def groupings
    pagination = custom_pagination(params[:page].to_i, params[:per_page].to_i)

    sql = "SELECT"
    sql += " emp.id, emp.first_name, emp.middle_name, emp.employee_id,"
    sql += " emp.last_name, emp.suffix, emp.biometric_no, emp.sex, po.name as employee_position"
    sql += " FROM employees AS emp"
    sql += " LEFT JOIN positions AS po ON po.id = emp.position_id"
    sql += " WHERE emp.status = 'A' AND emp.company_id = #{payload["company_id"]}"
    sql += " AND emp.position_id = #{params[:position_id].to_i}" if params[:position_id].present?
    sql += " AND emp.job_classification_id = #{params[:job_classification_id].to_i}" if params[:job_classification_id].present?
    sql += " AND emp.department_id = #{params[:department_id].to_i}" if params[:department_id].present?
    sql += " AND emp.assigned_area_id = #{params[:assigned_area_id].to_i}" if params[:assigned_area_id].present?
    sql += " AND emp.employment_status_id = #{params[:employment_status_id].to_i}" if params[:employment_status_id].present?
    sql += " AND emp.salary_mode_id = #{params[:salary_mode_id].to_i}" if params[:salary_mode_id].present?
    sql += " AND emp.company_account_id = #{params[:company_account_id].to_i}" if params[:company_account_id].present?
    sql += " ORDER BY emp.last_name ASC, emp.first_name ASC, emp.middle_name ASC"
    sql += " LIMIT #{pagination[:per_page]} OFFSET #{pagination[:fetch_point]}"

    sql_count = "SELECT"
    sql_count += " COUNT(*) AS total_count"
    sql_count += " FROM employees AS emp"
    sql_count += " WHERE emp.status = 'A' AND emp.company_id = #{payload["company_id"]}"
    sql_count += " AND emp.position_id = #{params[:position_id].to_i}" if params[:position_id].present?
    sql_count += " AND emp.job_classification_id = #{params[:job_classification_id].to_i}" if params[:job_classification_id].present?
    sql_count += " AND emp.department_id = #{params[:department_id].to_i}" if params[:department_id].present?
    sql_count += " AND emp.assigned_area_id = #{params[:assigned_area_id].to_i}" if params[:assigned_area_id].present?
    sql_count += " AND emp.employment_status_id = #{params[:employment_status_id].to_i}" if params[:employment_status_id].present?
    sql_count += " AND emp.salary_mode_id = #{params[:salary_mode_id].to_i}" if params[:salary_mode_id].present?
    sql_count += " AND emp.company_account_id = #{params[:company_account_id].to_i}" if params[:company_account_id].present?

    employees = execute_sql_query(sql)
    employees_count = execute_sql_query(sql_count)
    render json: {employees: employees, total_count: employees_count.first["total_count"]}
  end

  def search_employee
    search = params[:search]
    search_by = params[:search_by]
    sql = "SELECT CONCAT(emp.last_name,', ',emp.middle_name,' ',emp.first_name,' ',emp.suffix,' (',emp.biometric_no,')') AS label,"
    sql += " emp.biometric_no AS value"
    sql += " FROM employees AS emp"
    sql ++ " WHERE emp.status = 'A' AND emp.company_id = #{payload["company_id"]}"
    sql += " WHERE emp.first_name LIKE '%#{search}%' OR emp.middle_name LIKE '%#{search}%' OR emp.last_name LIKE '%#{search}%'" if search_by.present? && search_by == "name" 
    sql += " WHERE emp.biometric_no LIKE '%#{search.to_i}%'" if search_by.present? && search_by == "biometric_no" 
    sql += " WHERE emp.employee_id LIKE '%#{search}%'" if search_by.present? && search_by == "employee_uid"
    sql += " ORDER BY emp.last_name ASC, emp.first_name ASC, emp.middle_name ASC"
    sql += " LIMIT 15"
    results = execute_sql_query(sql)
    render json: results
  end

  def search_employee_id
    search = params[:search]
    search_by = params[:search_by]
    sql = "SELECT CONCAT(emp.last_name,', ',emp.middle_name,' ',emp.first_name,' ',emp.suffix,' (',emp.biometric_no,')') AS label,"
    sql += " emp.id AS value"
    sql += " FROM employees AS emp"
    sql ++ " WHERE emp.status = 'A' AND emp.company_id = #{payload["company_id"]}"
    sql += " WHERE emp.first_name LIKE '%#{search}%' OR emp.middle_name LIKE '%#{search}%' OR emp.last_name LIKE '%#{search}%'" if search_by.present? && search_by == "name" 
    sql += " WHERE emp.biometric_no LIKE '%#{search.to_i}%'" if search_by.present? && search_by == "biometric_no" 
    sql += " WHERE emp.employee_id LIKE '%#{search}%'" if search_by.present? && search_by == "employee_uid"
    sql += " ORDER BY emp.last_name ASC, emp.first_name ASC, emp.middle_name ASC"
    sql += " LIMIT 10"
    results = execute_sql_query(sql)
    render json: results
  end

  # GET /employees/1
  def show
    render json: { employee: @employee }.merge!({
        department: {value: @employee.department_id, label: @employee.department_name}, 
        salary_mode: {value: @employee.salary_mode_id, label: @employee.salary_mode_name},
        position: {value: @employee.position_id, label: @employee.position_name},
        employment_status: {value: @employee.emp_status_id, label: @employee.emp_status_name},
        job_classification: {value: @employee.job_classification_id, label: @employee.job_classification_name},
        assigned_area: {value: @employee.assigned_area_id, label: @employee.assigned_area_name},
        company_account: {value: @employee.company_account_id, label: @employee.company_account_name},
      })
  end

  # POST /employees
  def create
    @employee = Employee.new(employee_params.merge!({company_id: payload["company_id"], created_by_id: payload["user_id"]}))
    if @employee.save
      EmployeeActionHistoryWorker.perform_async(payload['user_id'], @employee.created_at, 'CREATED', @employee.id, @employee.compensation)
      render json: {message: "Successfully created"}, status: :created
    else
      render json: @employee.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /employees/1
  def update
    if @employee.update(employee_params)
      EmployeeActionHistoryWorker.perform_async(payload['user_id'], @employee.updated_at, 'UPDATED', @employee.id, nil)
      render json: {message: "Successfully updated"}
    else
      render json: @employee.errors, status: :unprocessable_entity
    end
  end

  # DELETE /employees/1
  def destroy
    # @employee.destroy
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
        ['EA']
      when 'update'
        ['EE']
      when 'destroy'
        ['ED']
      else
        ['EV']
      end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_employee_show
      @employee = Employee.joins("LEFT JOIN departments AS dp ON dp.id = employees.department_id
                          LEFT JOIN salary_modes AS sm ON sm.id = employees.salary_mode_id
                          LEFT JOIN positions AS po ON po.id = employees.position_id
                          LEFT JOIN employment_statuses AS es ON es.id = employees.employment_status_id
                          LEFT JOIN job_classifications AS jc ON jc.id = employees.job_classification_id
                          LEFT JOIN assigned_areas AS aa ON aa.id = employees.assigned_area_id
                          LEFT JOIN company_accounts AS ca ON ca.id = employees.company_account_id")
                          .select("employees.*, dp.name AS department_name, sm.description AS salary_mode_name,
                          po.name AS position_name, po.id as position_id, es.id as emp_status_id, es.name AS emp_status_name,
                          jc.name AS job_classification_name, jc.id AS job_classification_id, aa.id AS assigned_area_id,
                          aa.name AS assigned_area_name, ca.id as company_account_id, ca.name as company_account_name")
                          .find(params[:id])
    end

    def set_employee
      @employee = Employee.find(params[:id])
    end
    # Only allow a trusted parameter "white list" through.
    def employee_params
      params.require(:employee).permit(:first_name, :middle_name, :last_name, :suffix, :biometric_no, :position_id,
                                      :department_id, :assigned_area_id, :job_classification_id, :salary_mode_id,
                                      :date_hired, :employment_status_id, :sex, :birthdate, :civil_status, 
                                      :phone_number, :email, :street, :barangay, :municipality, :province,
                                      :sss_no, :hdmf_no, :tin_no, :phic_no, :highest_educational_attainment,
                                      :institution, :course, :course_major, :graduate_school, :remarks, :company_account_id,
                                      :emergency_contact_number, :emergency_contact_person, :compensation, :profile,
                                      :date_regularized, :work_sched_start, :work_sched_end, :work_sched_type, 
                                      :company_email, :date_resigned, :emergency_contact_relationship, :work_sched_days => [])
    end
end
