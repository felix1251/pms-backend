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

    sql_start = ""
    sql_start += "SELECT"
    # only to display count
    sql_count = " COUNT(*) as total_count"
    # columns
    sql_select = " emp.id, emp.company_id, emp.status, emp.biometric_no, emp.first_name"
    sql_select += " ,emp.middle_name, emp.last_name, emp.suffix"
    sql_select += " ,emp.position, dp.name AS department_name, sm.description AS salary_mode_desc"
    sql_select += " ,emp.assigned_area, emp.job_classification"
    sql_select += " ,DATE(emp.date_hired) as date_hired, emp.employment_status, emp.sex"
    sql_select += " ,emp.birthdate, emp.status ,emp.age, emp.email, emp.phone_number, emp.street"
    sql_select += " ,emp.barangay, emp.municipality, emp.province"
    sql_select += " ,emp.sss_no, emp.tin_no, emp.phic_no, emp.hdmf_no, emp.course, emp.institution"
    sql_select += " ,emp.highest_educational_attainment, emp.biometric_no, emp.employee_id"
    sql_select += " ,emp.emergency_contact_person, emergency_contact_number"
    sql_select += " ,emp.course_major"
    # main column
    sql_from = " FROM employees AS emp"
    # joins
    sql_join = " LEFT JOIN departments AS dp ON dp.id = emp.department_id"
    sql_join += " LEFT JOIN salary_modes AS sm ON sm.id = emp.salary_mode_id"
    # conditions
    sql_condition = " WHERE emp.status = 'A' AND emp.company_id = #{payload["company_id"]}"
    sql_sort = " ORDER BY last_name ASC, first_name ASC"
    # paginate
    sql_paginate = " LIMIT #{per_page} OFFSET #{records_fetch_point};"
    # execute query
    begin
      employees = execute_sql_query(sql_start + sql_select + sql_from + sql_join + sql_condition + sql_sort + sql_paginate)
      employee_count = execute_sql_query(sql_start + sql_count + sql_from + sql_condition)
      render json: {employees: employees, total_count: employee_count.first["total_count"]}
    rescue Exception => exc
      render json: { error: exc.message }, status: :unprocessable_entity
    end
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
