class OnPayrollCompensationWorker
  include Sidekiq::Worker
  sidekiq_options lock: :until_executed

  def perform(payroll_id, company_id)
    sql = "SELECT (#{payroll_id}) AS payroll_id, id as employee_id, compensation, company_account_id"
    sql += " FROM employees WHERE company_id = #{company_id} and status = 'A';"
    store = []
    employees_current_compensation = ActiveRecord::Base.connection.exec_query(sql).each { |ecc| ecc }
    OnPayrollCompensation.create(employees_current_compensation)
  end

end