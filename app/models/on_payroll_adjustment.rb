class OnPayrollAdjustment < ApplicationRecord
  belongs_to :payroll
  belongs_to :employee
  enum type: { U: "U", O: "O"}
end
