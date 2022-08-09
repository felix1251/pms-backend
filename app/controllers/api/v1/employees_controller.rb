class Api::V1::EmployeesController < ApplicationController
  before_action :authorize_access_request!
  before_action :check_backend_session
  before_action :set_employee, only: [:show, :update, :destroy]

  # GET /employees
  def index
    max = 10
    current_page = params[:page] 
    per_page = params[:per_page]
    current_page = current_page || 1
    per_page = per_page || max
    unless per_page <= max
      per_page = max
    end
    records_fetch_point = (current_page - 1) * per_page

    sql = ""
    sql += "SELECT"
    # columns
    sql += " emp.id, emp.company_id, emp.status, emp.biometric_no, UPPER(emp.first_name) AS first_name"
    sql += " ,UPPER(emp.middle_name) AS middle_name, UPPER(emp.last_name) AS last_name, UPPER(emp.suffix) AS suffix"
    sql += " ,UPPER(emp.position) as position, UPPER(dp.name) AS department_name, UPPER(sm.description) AS salary_mode_desc"
    sql += " ,UPPER(emp.assigned_area) as assigned_area, UPPER(emp.job_classification) AS job_classification"
    sql += " ,DATE(emp.date_hired) as date_hired, UPPER(emp.employment_status) AS employment_status, UPPER(emp.sex) AS sex"
    sql += " ,emp.birthdate, emp.status ,emp.age, emp.email, emp.phone_number, UPPER(emp.street) AS street"
    sql += " ,UPPER(emp.barangay) AS barangay, UPPER(emp.municipality) AS municipality, UPPER(emp.province) AS province"
    sql += " ,emp.sss_no, emp.tin_no, emp.phic_no, emp.hdmf_no, UPPER(emp.course) AS course, UPPER(emp.institution) AS institution"
    sql += " ,UPPER(emp.highest_educational_attainment) AS highest_educational_attainment, emp.biometric_no, emp.employee_id"
    sql += " ,UPPER(emp.emergency_contact_person) AS contact_person, UPPER(emergency_contact_number) AS contact_person_number"
    # main column
    sql += " FROM employees AS emp"
    # joins
    sql += " LEFT JOIN departments AS dp ON dp.id = emp.department_id"
    sql += " LEFT JOIN salary_modes AS sm ON sm.id = emp.salary_mode_id"
    # conditions
    sql += " WHERE emp.status = 'A' AND emp.company_id = #{payload["company_id"]}"
    sql += " ORDER BY last_name ASC, first_name ASC"
    # paginate
    sql += " LIMIT #{per_page} OFFSET #{records_fetch_point};"
    # execute query
    employees = execute_sql_query(sql)
    render json: employees
  end

  # GET /employees/1
  def show
    render json: @employee
  end

  # POST /employees
  def create
    @employee = Employee.new(employee_params)

    if @employee.save
      render json: @employee, status: :created, location: @employee
    else
      render json: @employee.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /employees/1
  def update
    if @employee.update(employee_params)
      render json: @employee
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
    def set_employee
      @employee = Employee.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def employee_params
      params.fetch(:employee, {})
    end
end
