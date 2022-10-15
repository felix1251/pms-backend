class OnPayrollCompensationWorker
  include Sidekiq::Worker
  sidekiq_options lock: :until_executed

  def perform(payroll_id, company_id)
    sql = "SELECT (#{payroll_id}) AS payroll_id, emp.id as employee_id, emp.compensation, emp.company_account_id,"
    sql += " emp.position_id, emp.department_id, emp.salary_mode_id, emp.work_sched_type"
    sql += " FROM employees emp"
    sql += " LEFT JOIN payrolls AS py ON py.id = #{payroll_id}"
    sql += " WHERE emp.company_id = #{company_id}"
    sql += " AND (emp.status = 'A' OR (select COUNT(*) FROM time_keepings WHERE biometric_no = emp.biometric_no AND DATE(date) BETWEEN py.from AND py.to) > 0)"
    employees_current_compensation = ActiveRecord::Base.connection.exec_query(sql).each { |ecc| ecc }
    
    # puts "------------------", employees_current_compensation.pluck("employee_id")

    sql = ""
    sql += "SELECT name, amount, employee_id, (#{payroll_id}) AS payroll_id"
    sql += " FROM employee_allowances"
    sql += " WHERE employee_id IN (#{employees_current_compensation.pluck("employee_id").join(",")})"
    employees_current_allowances = ActiveRecord::Base.connection.exec_query(sql).each { |ecc| ecc }

    #create
    OnPayrollCompensation.create(employees_current_compensation)
    OnPayrollAllowance.create(employees_current_allowances)
  end
end