class Api::V2::SigninController < PmsErsController
  before_action :authorize_access_request!, only: [:logout]
  before_action :set_employee, only: [:create]

  def create
    if @employee && @employee.authenticate(params[:password])
      payload = {employee_id: @employee.id, company_id: @employee.company_id}
      session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true, namespace: "employee_#{@employee.id}")
      tokens = session.login
      response.set_cookie(JWTSessions.access_cookie, value: tokens[:access], httponly: true, secure: Rails.env.production?)
      render json: { csrf: tokens[:csrf], employee: @employee }
    else
      not_found
    end
  end

  def logout
    session = JWTSessions::Session.new(payload: payload, namespace: "employee_#{payload['employee_id']}")
    if session.flush_by_access_payload
      render json: {status: "logout succesfully"}, status: :ok
    end
  end

  private

  def set_employee
    sql = " CONCAT(employees.last_name, ', ', employees.first_name, ' ', CASE WHEN employees.suffix = '' THEN '' ELSE CONCAT(employees.suffix, '.') END,' '," 
    sql += " CASE employees.middle_name WHEN '' THEN '' ELSE CONCAT(SUBSTR(employees.middle_name, 1, 1), '.') END) AS fullname"

    @employee = Employee.select("employees.id, employees.employee_id, com.description AS company_name, company_id,
                        employees.biometric_no, employees.password_digest, employees.profile," + sql)
                        .joins("LEFT JOIN companies AS com ON com.id = employees.company_id")
                        .find_by!(employee_id: params[:employee_id], status: "A")
  end

  def not_found
    render json: { error: "Can't find such UID and password combination" }, status: :not_found
  end
end
