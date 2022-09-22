class OnPayrollCompensation < ApplicationRecord
  belongs_to :payroll
  validates :employee_id, uniqueness: { scope: :payroll_id }
end
