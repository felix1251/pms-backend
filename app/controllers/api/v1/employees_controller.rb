class Api::V1::EmployeesController < PmsDesktopController
  before_action :authorize_access_request!
  before_action :check_backend_session
  before_action :set_employee, only: [:update, :destroy]
  before_action :set_employee_show, only: [:show]
  # GET /employees
  def index
    max = 35
    current_page = params[:page].to_i 
    per_page = params[:per_page].to_i
    current_page = current_page || 1
    per_page = per_page || max
    unless per_page <= max
      per_page = max
    end
    records_fetch_point = (current_page - 1) * per_page

    sql_start = ""
    sql_start += "SELECT"
    # only to display count
    sql_count = " COUNT(*) as total_count"
    # columns
    sql_fields = " emp.id, emp.company_id, emp.status, emp.biometric_no, emp.first_name"
    sql_fields += " ,emp.middle_name, emp.last_name, emp.suffix"
    sql_fields += " ,emp.position, dp.name AS department_name, sm.description AS salary_mode_desc"
    sql_fields += " ,emp.assigned_area, emp.job_classification"
    sql_fields += " ,DATE(emp.date_hired) as date_hired, emp.employment_status, emp.sex"
    sql_fields += " ,emp.birthdate, emp.status , emp.email, emp.phone_number, emp.street"
    sql_fields += " ,emp.barangay, emp.municipality, emp.province"
    sql_fields += " ,emp.sss_no, emp.tin_no, emp.phic_no, emp.hdmf_no, emp.course, emp.institution"
    sql_fields += " ,emp.highest_educational_attainment, emp.biometric_no, emp.employee_id"
    sql_fields += " ,emp.emergency_contact_person, emergency_contact_number"
    sql_fields += " ,emp.course_major, emp.civil_status"
    # main column
    sql_from = " FROM employees AS emp"
    # joins
    sql_join = " LEFT JOIN departments AS dp ON dp.id = emp.department_id"
    sql_join += " LEFT JOIN salary_modes AS sm ON sm.id = emp.salary_mode_id"
    # conditions
    sql_condition = " WHERE emp.status = 'A' AND emp.company_id = #{payload["company_id"]}"
    sql_sort = " ORDER BY last_name ASC, first_name ASC, middle_name ASC"
    # paginate
    sql_paginate = " LIMIT #{per_page} OFFSET #{records_fetch_point};"
  
    # render json: Employee.all
    begin
      employees = execute_sql_query(sql_start + sql_fields + sql_from + sql_join + sql_condition + sql_sort + sql_paginate)
      employee_count = execute_sql_query(sql_start + sql_count + sql_from + sql_condition)
      render json: { employees: employees, total_count: employee_count.first["total_count"] }
    rescue Exception => exc
      render json: { error: exc.message }, status: :unprocessable_entity
    end
  end

  # GET /employees/1
  def show
    render json: { employee: @employee }.merge!({
      department: {value: @employee.department_id, label: @employee.department_name}, 
      salary_mode: {value: @employee.salary_mode_id, label: @employee.salary_mode_name}},
    )
  end

  # POST /employees
  def create
    @employee = current_company.employees.new(employee_params)
    if @employee.save
      render json: {message: "Successfully created"}, status: :created
    else
      render json: @employee.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /employees/1
  def update
    if @employee.update(employee_params)
      render json: {message: "Successfully updated"}
    else
      render json: @employee.errors, status: :unprocessable_entity
    end
  end

  # DELETE /employees/1
  def destroy
    @employee.destroy
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
                          LEFT JOIN salary_modes AS sm ON sm.id = employees.salary_mode_id")
                          .select("employees.*, dp.name as department_name, sm.description as salary_mode_name")
                          .find(params[:id])
    end

    def set_employee
      @employee = Employee.find(params[:id])
    end
    # Only allow a trusted parameter "white list" through.
    def employee_params
      params.require(:employee).permit(:first_name, :middle_name, :last_name, :suffix, :biometric_no, :position,
                                      :department_id, :assigned_area, :job_classification, :salary_mode_id,
                                      :date_hired, :employment_status, :sex, :birthdate, :civil_status, 
                                      :phone_number, :email, :street, :barangay, :municipality, :province,
                                      :sss_no, :hdmf_no, :tin_no, :phic_no, :highest_educational_attainment,
                                      :institution, :course, :course_major, :graduate_school, :remarks,
                                      :emergency_contact_number, :emergency_contact_person, :compensation,
                                      :date_regularized)
    end
end
