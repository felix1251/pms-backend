class AddColumninOnPayrollCOmpeEmpEorkSched < ActiveRecord::Migration[5.2]
  def change
    add_column :on_payroll_compensations, :work_sched_type, :string
  end
end
